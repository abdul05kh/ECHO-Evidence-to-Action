import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/bridge/office_kit_bridge.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';

void main() {
  group('OfficeKitBridge Tests', () {
    final samplePacket = ActionPacketModel(
      id: 'ap_bridge_test_01',
      version: 1,
      status: 'approved',
      title: 'Lab 2 Projector Power Cable Fault',
      category: 'equipment',
      priority: 'high',
      priorityReason: 'Class starts in 20 min',
      summary: 'Projector unlit with class starting soon.',
      observations: [
        const ObservedFact(
          text: 'Projector LED unlit',
          evidenceLinks: [
            EvidenceLink(evidenceId: 'ev_1', type: 'photo', label: 'Photo #01')
          ],
        ),
      ],
      inferences: [
        const InferenceItem(
          text: 'Cable fault likely',
          basis: 'Observed power symptoms',
          confidenceState: 'high',
          supportingEvidence: [],
        ),
      ],
      missingInformation: [
        const MissingInfoItem(
            prompt: 'Check breaker #4',
            contextReason: 'Breaker status obscured'),
      ],
      checklist: [
        const ChecklistItemData(
            id: 'c1', text: 'Swap power cable', isCompleted: false),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('exportEchoPacketJson generates valid JSON with packet metadata', () {
      final jsonStr = OfficeKitBridge.exportEchoPacketJson(samplePacket);
      final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;

      expect(decoded['packet_id'], 'ap_bridge_test_01');
      expect(decoded['title'], 'Lab 2 Projector Power Cable Fault');
      expect(decoded['priority'], 'high');
      expect(decoded['source_device'], contains('Android'));
      expect(decoded['observations'], isList);
      expect(decoded['checklist'], isList);
    });

    test('exportHumanReadableSummary produces Markdown packet summary', () {
      final summary = OfficeKitBridge.exportHumanReadableSummary(samplePacket);

      expect(summary, contains('# ECHO ACTION PACKET — ap_bridge_test_01'));
      expect(summary, contains('Lab 2 Projector Power Cable Fault'));
      expect(summary, contains('Observed Facts'));
      expect(summary, contains('Missing Information'));
    });
  });
}
