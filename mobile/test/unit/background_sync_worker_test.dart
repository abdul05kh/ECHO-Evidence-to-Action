import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/core/network/network_connectivity_monitor.dart';
import 'package:echo_mobile/core/sync/sync_outbox_manager.dart';
import 'package:echo_mobile/core/sync/outbox_operation.dart';
import 'package:echo_mobile/core/sync/background_sync_worker.dart';

void main() {
  group('BackgroundSyncWorker Unit Tests', () {
    late SyncOutboxManager outboxManager;
    late NetworkConnectivityMonitor networkMonitor;
    late BackgroundSyncWorker worker;

    setUp(() {
      outboxManager = SyncOutboxManager();
      networkMonitor =
          NetworkConnectivityMonitor(initialStatus: NetworkStatus.wifi);
      worker = BackgroundSyncWorker(
        outboxManager: outboxManager,
        networkMonitor: networkMonitor,
      );
    });

    test('aborts sync if network is offline', () async {
      networkMonitor.updateStatus(NetworkStatus.offline);
      final result = await worker.performSync();

      expect(result.syncedCount, equals(0));
      expect(result.errorMessage, contains('Network unavailable'));
      expect(worker.status, equals(SyncWorkerStatus.idle));
    });

    test('executes sync for pending outbox items when online', () async {
      final op = OutboxOperation(
        id: 'outbox-1',
        operationType: 'sync_evidence',
        entityId: 'ev-1',
        idempotencyKey: 'idemp-1',
        payload: {'evidenceId': 'ev-1'},
        createdAt: DateTime.now(),
      );

      outboxManager.enqueue(op);
      expect(outboxManager.getPendingForAttempt().length, equals(1));

      final result = await worker.performSync();

      expect(result.syncedCount, equals(1));
      expect(result.failedCount, equals(0));
      expect(outboxManager.getPendingForAttempt().isEmpty, isTrue);
      expect(worker.status, equals(SyncWorkerStatus.idle));
    });
  });
}
