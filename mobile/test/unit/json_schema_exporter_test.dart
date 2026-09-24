import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/bridge/json_schema_exporter.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';

void main() {
  group('JSONSchemaExporter Unit Tests', () {
    final now = DateTime(2026, 9, 25, 12, 0, 0);

    test(
        'generates valid JSON schema payload string with schema URI and metadata',
        () {
      final packet = ActionPacketModel(
        id: 'ap_schema_01',
        title: 'Electrical Outlet Sparking',
        category: 'electrical',
        priority: 'critical',
        priorityReason: 'Sparking reported near server rack',
        summary: 'Wall socket loose.',
        createdAt: now,
        updatedAt: now,
      );

      final jsonStr =
          JSONSchemaExporter.toJsonSchemaString(packet, pretty: true);
      expect(
          jsonStr,
          contains(
              r'"$schema": "https://echo.internal/schemas/v1/action_packet.json"'));

      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
      expect(decoded['packet_id'], 'ap_schema_01');
      expect(decoded['priority'], 'critical');
      expect(decoded['category'], 'electrical');
      expect(decoded['generation_metadata']['source'], 'PROTOTYPE_RUNTIME');
    });
  });
}
