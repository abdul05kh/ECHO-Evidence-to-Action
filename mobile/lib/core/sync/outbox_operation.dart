import 'dart:convert';

/// Represents the status of an offline outbox operation.
enum OutboxStatus {
  pending,
  syncing,
  synced,
  failed,
}

extension OutboxStatusExtension on OutboxStatus {
  String toDbString() {
    switch (this) {
      case OutboxStatus.pending:
        return 'pending';
      case OutboxStatus.syncing:
        return 'syncing';
      case OutboxStatus.synced:
        return 'synced';
      case OutboxStatus.failed:
        return 'failed';
    }
  }

  static OutboxStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'syncing':
        return OutboxStatus.syncing;
      case 'synced':
        return OutboxStatus.synced;
      case 'failed':
        return OutboxStatus.failed;
      case 'pending':
      default:
        return OutboxStatus.pending;
    }
  }
}

/// Domain object representing an offline outbox operation.
class OutboxOperation {
  final String id;
  final String workspaceId;
  final String
      operationType; // 'create_packet', 'approve_packet', 'create_task', 'transition_task', 'sync_evidence'
  final String entityId;
  final String idempotencyKey;
  final Map<String, dynamic> payload;
  final OutboxStatus status;
  final int retryCount;
  final DateTime? nextAttemptAt;
  final DateTime createdAt;

  const OutboxOperation({
    required this.id,
    this.workspaceId = 'ws_default',
    required this.operationType,
    required this.entityId,
    required this.idempotencyKey,
    required this.payload,
    this.status = OutboxStatus.pending,
    this.retryCount = 0,
    this.nextAttemptAt,
    required this.createdAt,
  });

  /// Factory helper to create a new operation with an automatic idempotency key if not specified.
  factory OutboxOperation.create({
    required String id,
    String workspaceId = 'ws_default',
    required String operationType,
    required String entityId,
    String? idempotencyKey,
    required Map<String, dynamic> payload,
    DateTime? createdAt,
  }) {
    final now = createdAt ?? DateTime.now();
    final generatedIdempotencyKey = idempotencyKey ??
        'idempotent_${operationType}_${entityId}_${now.millisecondsSinceEpoch}';
    return OutboxOperation(
      id: id,
      workspaceId: workspaceId,
      operationType: operationType,
      entityId: entityId,
      idempotencyKey: generatedIdempotencyKey,
      payload: payload,
      status: OutboxStatus.pending,
      retryCount: 0,
      nextAttemptAt: now,
      createdAt: now,
    );
  }

  /// Calculates the next attempt timestamp using exponential backoff.
  /// Formula: baseIntervalSec * 2^(retryCount) capped at maxBackoffSec.
  static DateTime calculateNextAttemptTime({
    required int retryCount,
    DateTime? fromTime,
    int baseIntervalSec = 2,
    int maxBackoffSec = 3600,
  }) {
    final base = fromTime ?? DateTime.now();
    final exponent = retryCount.clamp(0, 12);
    final delaySeconds = (baseIntervalSec * (1 << exponent))
        .clamp(baseIntervalSec, maxBackoffSec);
    return base.add(Duration(seconds: delaySeconds));
  }

  OutboxOperation copyWith({
    String? id,
    String? workspaceId,
    String? operationType,
    String? entityId,
    String? idempotencyKey,
    Map<String, dynamic>? payload,
    OutboxStatus? status,
    int? retryCount,
    DateTime? nextAttemptAt,
    DateTime? createdAt,
  }) {
    return OutboxOperation(
      id: id ?? this.id,
      workspaceId: workspaceId ?? this.workspaceId,
      operationType: operationType ?? this.operationType,
      entityId: entityId ?? this.entityId,
      idempotencyKey: idempotencyKey ?? this.idempotencyKey,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      retryCount: retryCount ?? this.retryCount,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'workspace_id': workspaceId,
        'operation_type': operationType,
        'entity_id': entityId,
        'idempotency_key': idempotencyKey,
        'payload_json': jsonEncode(payload),
        'status': status.toDbString(),
        'retry_count': retryCount,
        'next_attempt_at': nextAttemptAt?.toIso8601String(),
        'created_at': createdAt.toIso8601String(),
      };

  factory OutboxOperation.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> parsedPayload = {};
    if (json['payload_json'] is String) {
      try {
        parsedPayload =
            jsonDecode(json['payload_json'] as String) as Map<String, dynamic>;
      } catch (_) {
        parsedPayload = {};
      }
    } else if (json['payload'] is Map<String, dynamic>) {
      parsedPayload = json['payload'] as Map<String, dynamic>;
    }

    return OutboxOperation(
      id: json['id'] as String? ?? '',
      workspaceId: json['workspace_id'] as String? ?? 'ws_default',
      operationType: json['operation_type'] as String? ?? 'unknown',
      entityId: json['entity_id'] as String? ?? '',
      idempotencyKey: json['idempotency_key'] as String? ?? '',
      payload: parsedPayload,
      status: OutboxStatusExtension.fromString(
          json['status'] as String? ?? 'pending'),
      retryCount: json['retry_count'] as int? ?? 0,
      nextAttemptAt: json['next_attempt_at'] != null
          ? DateTime.parse(json['next_attempt_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
    );
  }
}
