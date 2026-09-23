import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/bridge/office_kit_bridge.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';

void main() {
  group('OfficeKitBridge Unit Tests', () {
    final samplePacket = ActionPacketModel(
      id: 'ap_bridge_001',
      title: 'Lab 2 Projector Not Powering On',
      category: 'equipment',
      priority: 'high',
      priorityReason: 'Class starts in 20 minutes',
      summary: 'Projector ceiling unit in Lab 2 is completely unresponsive.',
      observations: const [
        ObservedFact(text: 'Power LED indicator is unlit', evidenceLinks: []),
      ],
      checklist: const [
        ChecklistItemData(id: 'chk_1', text: 'Check wall switch'),
      ],
      createdAt: DateTime(2026, 9, 24),
      updatedAt: DateTime(2026, 9, 24),
    );

    test('exportEchoPacketJson produces valid formatted JSON string', () {
      final jsonStr = OfficeKitBridge.exportEchoPacketJson(samplePacket);
      expect(jsonStr, contains('ap_bridge_001'));
      expect(jsonStr, contains('Lab 2 Projector Not Powering On'));
      expect(jsonStr, contains('https://echo.app/schemas/echopack-v1.json'));
    });

    test('exportHumanReadableSummary produces markdown structure with headers',
        () {
      final md = OfficeKitBridge.exportHumanReadableSummary(samplePacket);
      expect(md, contains('# ECHO ACTION PACKET — ap_bridge_001'));
      expect(md, contains('**Category:** EQUIPMENT'));
      expect(md, contains('## Observed Facts'));
      expect(md, contains('## Operational Checklist'));
    });

    test('exportToCsv produces valid CSV header and data row', () {
      final csv = OfficeKitBridge.exportToCsv([samplePacket]);
      expect(csv,
          contains('ID,Title,Category,Priority,Status,Created At,Summary'));
      expect(
          csv,
          contains(
              'ap_bridge_001,"Lab 2 Projector Not Powering On",equipment,high,draft'));
    });

    test('importEchoPack successfully deserializes valid JSON payload string',
        () {
      final jsonStr = OfficeKitBridge.exportEchoPacketJson(samplePacket);
      final imported = OfficeKitBridge.importEchoPack(jsonStr);

      expect(imported, isNotNull);
      expect(imported!.id, equals('ap_bridge_001'));
      expect(imported.title, equals('Lab 2 Projector Not Powering On'));
    });
  });
}
