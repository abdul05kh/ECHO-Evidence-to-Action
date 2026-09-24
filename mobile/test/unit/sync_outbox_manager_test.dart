import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/core/sync/outbox_operation.dart';
import 'package:echo_mobile/core/sync/sync_outbox_manager.dart';

void main() {
  group('OutboxOperation & SyncOutboxManager Unit Tests', () {
    late SyncOutboxManager manager;
    final now = DateTime(2026, 9, 24, 12, 0, 0);

    setUp(() {
      manager = SyncOutboxManager(maxRetries: 3, baseBackoffSec: 2);
    });

    test(
        'OutboxOperation calculates exponential backoff retry schedule correctly',
        () {
      final t0 = OutboxOperation.calculateNextAttemptTime(
          retryCount: 0, fromTime: now, baseIntervalSec: 2);
      expect(t0, now.add(const Duration(seconds: 2)));

      final t1 = OutboxOperation.calculateNextAttemptTime(
          retryCount: 1, fromTime: now, baseIntervalSec: 2);
      expect(t1, now.add(const Duration(seconds: 4)));

      final t2 = OutboxOperation.calculateNextAttemptTime(
          retryCount: 2, fromTime: now, baseIntervalSec: 2);
      expect(t2, now.add(const Duration(seconds: 8)));
    });

    test('OutboxOperation serializes to and from JSON losslessly', () {
      final op = OutboxOperation.create(
        id: 'op_001',
        operationType: 'create_packet',
        entityId: 'ap_100',
        payload: {'title': 'HVAC Filter Replacement', 'priority': 'high'},
        createdAt: now,
      );

      final json = op.toJson();
      expect(json['id'], 'op_001');
      expect(json['status'], 'pending');

      final reconstructed = OutboxOperation.fromJson(json);
      expect(reconstructed.id, op.id);
      expect(reconstructed.operationType, op.operationType);
      expect(reconstructed.payload['title'], 'HVAC Filter Replacement');
    });

    test('SyncOutboxManager enforces idempotency key deduplication', () {
      final op1 = OutboxOperation(
        id: 'op_001',
        operationType: 'create_packet',
        entityId: 'ap_100',
        idempotencyKey: 'key_unique_123',
        payload: {'data': 1},
        createdAt: now,
      );

      final op2 = OutboxOperation(
        id: 'op_002',
        operationType: 'create_packet',
        entityId: 'ap_100',
        idempotencyKey: 'key_unique_123',
        payload: {'data': 2},
        createdAt: now,
      );

      manager.enqueue(op1);
      final result2 = manager.enqueue(op2);

      expect(manager.allOperations.length, 1);
      expect(result2.id, 'op_001');
    });

    test('SyncOutboxManager state transitions pending -> syncing -> synced',
        () {
      final op = OutboxOperation.create(
        id: 'op_10',
        operationType: 'approve_packet',
        entityId: 'ap_200',
        payload: {},
        createdAt: now,
      );

      manager.enqueue(op);
      expect(manager.getSummary().pendingCount, 1);

      manager.markSyncing('op_10');
      expect(manager.getSummary().syncingCount, 1);

      manager.markSynced('op_10');
      expect(manager.getSummary().syncedCount, 1);
      expect(manager.getSummary().pendingCount, 0);
    });

    test(
        'SyncOutboxManager handles failures and transitions to failed on max retries',
        () {
      final op = OutboxOperation.create(
        id: 'op_fail',
        operationType: 'sync_evidence',
        entityId: 'ev_999',
        payload: {},
        createdAt: now,
      );

      manager.enqueue(op);

      // Retry 1
      final r1 = manager.recordFailure('op_fail', now: now);
      expect(r1?.retryCount, 1);
      expect(r1?.status, OutboxStatus.pending);

      // Retry 2
      final r2 = manager.recordFailure('op_fail', now: now);
      expect(r2?.retryCount, 2);

      // Retry 3 (exceeds maxRetries = 3)
      final r3 = manager.recordFailure('op_fail', now: now);
      expect(r3?.status, OutboxStatus.failed);
      expect(manager.getSummary().failedCount, 1);
    });

    test('SyncOutboxManager purges old synced entries based on retention', () {
      final oldOp = OutboxOperation.create(
        id: 'op_old',
        operationType: 'create_packet',
        entityId: 'ap_old',
        payload: {},
        createdAt: now.subtract(const Duration(hours: 48)),
      );

      manager.enqueue(oldOp);
      manager.markSynced('op_old');

      final purged =
          manager.purgeSynced(retention: const Duration(hours: 24), now: now);
      expect(purged, 1);
      expect(manager.allOperations.isEmpty, isTrue);
    });
  });
}
