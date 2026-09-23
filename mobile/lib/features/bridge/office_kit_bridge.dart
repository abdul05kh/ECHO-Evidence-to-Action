import 'dart:convert';
import 'package:flutter/services.dart';
import '../packet/domain/action_packet.dart';

class BridgeResult {
  final bool success;
  final String message;
  final String? payload;

  const BridgeResult({
    required this.success,
    required this.message,
    this.payload,
  });
}

/// Office Kit Bridge handles cross-device payload serializations, markdown clipboard handoffs,
/// CSV exports, and `.echopack.json` imports.
class OfficeKitBridge {
  /// Generates machine-readable JSON packet for laptop import
  static String exportEchoPacketJson(ActionPacketModel packet) {
    final Map<String, dynamic> bridgeData = {
      'schema': 'https://echo.app/schemas/echopack-v1.json',
      'exported_at': DateTime.now().toIso8601String(),
      'source_device': 'iQOO 12 (Android 15)',
      'packet_id': packet.id,
      'packet_version': packet.version,
      'status': packet.status,
      'title': packet.title,
      'category': packet.category,
      'priority': packet.priority,
      'priority_reason': packet.priorityReason,
      'summary': packet.summary,
      'observations': packet.observations.map((o) => o.toJson()).toList(),
      'inferences': packet.inferences.map((i) => i.toJson()).toList(),
      'missing_information':
          packet.missingInformation.map((m) => m.toJson()).toList(),
      'suggested_actions':
          packet.suggestedActions.map((s) => s.toJson()).toList(),
      'checklist': packet.checklist.map((c) => c.toJson()).toList(),
      'confidence_state': packet.confidenceState,
      'capture_duration_ms': packet.captureDurationMs,
      'requires_human_approval': packet.requiresHumanApproval,
    };

    return const JsonEncoder.withIndent('  ').convert(bridgeData);
  }

  /// Generates human-readable Markdown summary for clipboard
  static String exportHumanReadableSummary(ActionPacketModel packet) {
    final buffer = StringBuffer();
    buffer.writeln('# ECHO ACTION PACKET — ${packet.id}');
    buffer.writeln('**Title:** ${packet.title}');
    buffer.writeln(
        '**Category:** ${packet.category.toUpperCase()} | **Priority:** ${packet.priority.toUpperCase()}');
    buffer.writeln('**Policy Reason:** ${packet.priorityReason}');
    buffer.writeln('**Status:** ${packet.status.toUpperCase()}');
    buffer.writeln('\n## Summary\n${packet.summary}');
    buffer.writeln('\n## Observed Facts');
    for (final obs in packet.observations) {
      buffer.writeln('- ${obs.text}');
    }
    buffer.writeln('\n## Missing Information');
    for (final m in packet.missingInformation) {
      buffer.writeln('- [ ] ${m.prompt}');
    }
    buffer.writeln('\n## Operational Checklist');
    for (final c in packet.checklist) {
      buffer.writeln('- [${c.isCompleted ? "x" : " "}] ${c.text}');
    }
    buffer.writeln(
        '\n---\n*Captured once. Structured locally. Approved by human.*');
    return buffer.toString();
  }

  /// Exports a list of work orders into CSV tabular format
  static String exportToCsv(List<ActionPacketModel> packets) {
    final buffer = StringBuffer();
    buffer.writeln('ID,Title,Category,Priority,Status,Created At,Summary');
    for (final p in packets) {
      final safeTitle = '"${p.title.replaceAll('"', '""')}"';
      final safeSummary = '"${p.summary.replaceAll('"', '""')}"';
      buffer.writeln(
          '${p.id},$safeTitle,${p.category},${p.priority},${p.status},${p.createdAt.toIso8601String()},$safeSummary');
    }
    return buffer.toString();
  }

  /// Parses incoming `.echopack.json` payload string back into ActionPacketModel
  static ActionPacketModel? importEchoPack(String jsonString) {
    try {
      final Map<String, dynamic> data = json.decode(jsonString);
      return ActionPacketModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  /// Copies packet to system clipboard for instant Office Kit sync with safe exception handling
  static Future<BridgeResult> copyToClipboard(ActionPacketModel packet) async {
    try {
      final jsonContent = exportEchoPacketJson(packet);
      await Clipboard.setData(ClipboardData(text: jsonContent));
      return BridgeResult(
        success: true,
        message: 'Payload copied to clipboard successfully',
        payload: jsonContent,
      );
    } catch (e) {
      return BridgeResult(
        success: false,
        message: 'Failed to access platform clipboard: $e',
      );
    }
  }
}
