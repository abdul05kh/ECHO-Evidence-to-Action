import 'dart:convert';
import '../packet/domain/action_packet.dart';

/// Exporter for generating compliant enterprise JSON schema payloads.
class JSONSchemaExporter {
  /// Converts an [ActionPacketModel] into a formatted JSON string adhering to the ECHO schema contract.
  static String toJsonSchemaString(ActionPacketModel packet,
      {bool pretty = true}) {
    final payload = {
      r'$schema': 'https://echo.internal/schemas/v1/action_packet.json',
      'packet_id': packet.id,
      'workspace_id': packet.workspaceId,
      'version': packet.version,
      'status': packet.status,
      'title': packet.title,
      'category': packet.category,
      'priority': packet.priority,
      'priority_reason': packet.priorityReason,
      'summary': packet.summary,
      'confidence_state': packet.confidenceState,
      'requires_human_approval': packet.requiresHumanApproval,
      'generation_metadata': {
        'source': packet.generationSource,
        'model_name': packet.modelName,
        'runtime_mode': packet.runtimeMode,
        if (packet.captureDurationMs != null)
          'capture_duration_ms': packet.captureDurationMs,
      },
      'observations': packet.observations.map((o) => o.toJson()).toList(),
      'inferences': packet.inferences.map((i) => i.toJson()).toList(),
      'checklist': packet.checklist.map((c) => c.toJson()).toList(),
      'created_at': packet.createdAt.toIso8601String(),
      'updated_at': packet.updatedAt.toIso8601String(),
    };

    if (pretty) {
      return const JsonEncoder.withIndent('  ').convert(payload);
    }
    return jsonEncode(payload);
  }
}
