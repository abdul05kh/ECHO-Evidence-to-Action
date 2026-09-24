import 'dart:convert';
import 'package:drift/drift.dart';
import '../sync/outbox_operation.dart';
import 'local_db.dart';

/// Data Access Object converter between domain [OutboxOperation] and Drift [SyncOutboxItem].
class SyncOutboxItemConverter {
  /// Converts a domain [OutboxOperation] into a Drift [SyncOutboxItemsCompanion] for insertion or update.
  static SyncOutboxItemsCompanion toCompanion(OutboxOperation operation) {
    return SyncOutboxItemsCompanion(
      id: Value(operation.id),
      workspaceId: Value(operation.workspaceId),
      operationType: Value(operation.operationType),
      entityId: Value(operation.entityId),
      idempotencyKey: Value(operation.idempotencyKey),
      payloadJson: Value(jsonEncode(operation.payload)),
      status: Value(operation.status.toDbString()),
      retryCount: Value(operation.retryCount),
      nextAttemptAt: Value(operation.nextAttemptAt),
      createdAt: Value(operation.createdAt),
    );
  }

  /// Converts a Drift [SyncOutboxItem] data row into a domain [OutboxOperation].
  static OutboxOperation toDomain(SyncOutboxItem item) {
    Map<String, dynamic> parsedPayload = {};
    try {
      parsedPayload = jsonDecode(item.payloadJson) as Map<String, dynamic>;
    } catch (_) {
      parsedPayload = {};
    }

    return OutboxOperation(
      id: item.id,
      workspaceId: item.workspaceId,
      operationType: item.operationType,
      entityId: item.entityId,
      idempotencyKey: item.idempotencyKey,
      payload: parsedPayload,
      status: OutboxStatusExtension.fromString(item.status),
      retryCount: item.retryCount,
      nextAttemptAt: item.nextAttemptAt,
      createdAt: item.createdAt,
    );
  }
}
