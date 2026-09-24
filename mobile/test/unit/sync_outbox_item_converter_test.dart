import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/core/storage/local_db.dart';
import 'package:echo_mobile/core/storage/sync_outbox_item_converter.dart';
import 'package:echo_mobile/core/sync/outbox_operation.dart';

void main() {
  group('SyncOutboxItemConverter Unit Tests', () {
    final now = DateTime(2026, 9, 25, 10, 0, 0);

    test('toCompanion maps domain OutboxOperation into Drift companion', () {
      final op = OutboxOperation.create(
        id: 'op_test_100',
        operationType: 'create_packet',
        entityId: 'ap_555',
        payload: {'title': 'HVAC Repair', 'priority': 'critical'},
        createdAt: now,
      );

      final companion = SyncOutboxItemConverter.toCompanion(op);

      expect(companion.id.value, 'op_test_100');
      expect(companion.operationType.value, 'create_packet');
      expect(companion.entityId.value, 'ap_555');
      expect(companion.status.value, 'pending');
      expect(companion.payloadJson.value, contains('HVAC Repair'));
    });

    test('toDomain maps Drift SyncOutboxItem data row to OutboxOperation', () {
      final dbItem = SyncOutboxItem(
        id: 'op_test_200',
        workspaceId: 'ws_default',
        operationType: 'approve_packet',
        entityId: 'ap_777',
        idempotencyKey: 'idem_key_999',
        payloadJson: '{"approved_by":"usr_01","timestamp":"2026-09-25"}',
        status: 'synced',
        retryCount: 1,
        nextAttemptAt: now,
        createdAt: now,
      );

      final op = SyncOutboxItemConverter.toDomain(dbItem);

      expect(op.id, 'op_test_200');
      expect(op.operationType, 'approve_packet');
      expect(op.entityId, 'ap_777');
      expect(op.status, OutboxStatus.synced);
      expect(op.retryCount, 1);
      expect(op.payload['approved_by'], 'usr_01');
    });
  });
}
