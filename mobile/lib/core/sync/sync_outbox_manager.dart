import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'outbox_operation.dart';

/// Summary statistics for outbox state diagnostic monitoring.
class SyncOutboxSummary {
  final int totalCount;
  final int pendingCount;
  final int syncingCount;
  final int syncedCount;
  final int failedCount;

  const SyncOutboxSummary({
    required this.totalCount,
    required this.pendingCount,
    required this.syncingCount,
    required this.syncedCount,
    required this.failedCount,
  });

  bool get hasPendingWork => pendingCount > 0 || syncingCount > 0;
}

/// In-memory and queue manager for offline outbox sync operations.
class SyncOutboxManager {
  final Map<String, OutboxOperation> _operations = {};
  final int maxRetries;
  final int baseBackoffSec;

  SyncOutboxManager({
    this.maxRetries = 5,
    this.baseBackoffSec = 2,
  });

  /// Returns an unmodifiable list of all outbox operations in FIFO insertion order.
  List<OutboxOperation> get allOperations =>
      List.unmodifiable(_operations.values.toList());

  /// Enqueues an outbox operation. Guarantees idempotency by replacing or ignoring
  /// existing operations matching the same idempotency key.
  OutboxOperation enqueue(OutboxOperation operation) {
    // Check if an operation with the exact idempotency key already exists
    final existingKey = _operations.keys.firstWhere(
      (k) => _operations[k]?.idempotencyKey == operation.idempotencyKey,
      orElse: () => '',
    );

    if (existingKey.isNotEmpty) {
      return _operations[existingKey]!;
    }

    _operations[operation.id] = operation;
    return operation;
  }

  /// Retrieves all operations eligible for processing at [now].
  List<OutboxOperation> getPendingForAttempt({DateTime? now}) {
    final referenceTime = now ?? DateTime.now();
    return _operations.values.where((op) {
      if (op.status != OutboxStatus.pending) return false;
      if (op.nextAttemptAt == null) return true;
      return op.nextAttemptAt!.isBefore(referenceTime) ||
          op.nextAttemptAt!.isAtSameMomentAs(referenceTime);
    }).toList();
  }

  /// Marks an operation as currently syncing.
  OutboxOperation? markSyncing(String id) {
    final op = _operations[id];
    if (op == null) return null;

    final updated = op.copyWith(status: OutboxStatus.syncing);
    _operations[id] = updated;
    return updated;
  }

  /// Marks an operation as successfully synced.
  OutboxOperation? markSynced(String id) {
    final op = _operations[id];
    if (op == null) return null;

    final updated = op.copyWith(status: OutboxStatus.synced);
    _operations[id] = updated;
    return updated;
  }

  /// Handles operation failure by incrementing retry count and calculating exponential backoff.
  /// If retry count exceeds [maxRetries], status transitions to [OutboxStatus.failed].
  OutboxOperation? recordFailure(String id, {DateTime? now}) {
    final op = _operations[id];
    if (op == null) return null;

    final newRetryCount = op.retryCount + 1;
    final referenceTime = now ?? DateTime.now();

    if (newRetryCount >= maxRetries) {
      final failedOp = op.copyWith(
        status: OutboxStatus.failed,
        retryCount: newRetryCount,
      );
      _operations[id] = failedOp;
      return failedOp;
    }

    final nextAttempt = OutboxOperation.calculateNextAttemptTime(
      retryCount: newRetryCount,
      fromTime: referenceTime,
      baseIntervalSec: baseBackoffSec,
    );

    final retryingOp = op.copyWith(
      status: OutboxStatus.pending,
      retryCount: newRetryCount,
      nextAttemptAt: nextAttempt,
    );
    _operations[id] = retryingOp;
    return retryingOp;
  }

  /// Purges synced entries older than [retention]. Returns the count of purged items.
  int purgeSynced(
      {Duration retention = const Duration(hours: 24), DateTime? now}) {
    final referenceTime = now ?? DateTime.now();
    final toRemove = <String>[];

    _operations.forEach((id, op) {
      if (op.status == OutboxStatus.synced) {
        final age = referenceTime.difference(op.createdAt);
        if (age >= retention) {
          toRemove.add(id);
        }
      }
    });

    for (final id in toRemove) {
      _operations.remove(id);
    }

    return toRemove.length;
  }

  /// Generates diagnostic summary statistics.
  SyncOutboxSummary getSummary() {
    int pending = 0;
    int syncing = 0;
    int synced = 0;
    int failed = 0;

    for (final op in _operations.values) {
      switch (op.status) {
        case OutboxStatus.pending:
          pending++;
          break;
        case OutboxStatus.syncing:
          syncing++;
          break;
        case OutboxStatus.synced:
          synced++;
          break;
        case OutboxStatus.failed:
          failed++;
          break;
      }
    }

    return SyncOutboxSummary(
      totalCount: _operations.length,
      pendingCount: pending,
      syncingCount: syncing,
      syncedCount: synced,
      failedCount: failed,
    );
  }

  /// Resets and clears all in-memory outbox state.
  void clear() {
    _operations.clear();
  }
}

final syncOutboxManagerProvider = Provider((ref) => SyncOutboxManager());
