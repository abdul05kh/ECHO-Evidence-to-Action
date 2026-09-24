import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:echo_mobile/core/network/network_connectivity_monitor.dart';
import 'package:echo_mobile/core/sync/sync_outbox_manager.dart';

enum SyncWorkerStatus { idle, syncing, error }

class BackgroundSyncResult {
  final int syncedCount;
  final int failedCount;
  final String? errorMessage;

  BackgroundSyncResult({
    required this.syncedCount,
    required this.failedCount,
    this.errorMessage,
  });
}

class BackgroundSyncWorker {
  final SyncOutboxManager outboxManager;
  final NetworkConnectivityMonitor networkMonitor;

  SyncWorkerStatus _status = SyncWorkerStatus.idle;

  BackgroundSyncWorker({
    required this.outboxManager,
    required this.networkMonitor,
  });

  SyncWorkerStatus get status => _status;

  Future<BackgroundSyncResult> performSync() async {
    if (!networkMonitor.canSync) {
      return BackgroundSyncResult(
        syncedCount: 0,
        failedCount: 0,
        errorMessage: 'Network unavailable for background sync',
      );
    }

    _status = SyncWorkerStatus.syncing;
    int syncedCount = 0;
    int failedCount = 0;

    try {
      final pendingOperations = outboxManager.getPendingForAttempt();
      for (final op in pendingOperations) {
        outboxManager.markSyncing(op.id);
        outboxManager.markSynced(op.id);
        syncedCount++;
      }
      _status = SyncWorkerStatus.idle;
      return BackgroundSyncResult(
        syncedCount: syncedCount,
        failedCount: failedCount,
      );
    } catch (e) {
      _status = SyncWorkerStatus.error;
      return BackgroundSyncResult(
        syncedCount: syncedCount,
        failedCount: failedCount,
        errorMessage: e.toString(),
      );
    }
  }
}

final backgroundSyncWorkerProvider = Provider((ref) {
  final outboxManager = ref.watch(syncOutboxManagerProvider);
  final networkMonitor = ref.watch(networkConnectivityMonitorProvider);
  return BackgroundSyncWorker(
    outboxManager: outboxManager,
    networkMonitor: networkMonitor,
  );
});
