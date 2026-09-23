import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';

void main() {
  group('ActionPacketModel Unit Tests', () {
    test('ActionPacketModel toJson and fromJson roundtrip preserves all fields',
        () {
      final now = DateTime.now();
      final packet = ActionPacketModel(
        id: 'ap_test_101',
        title: 'Projector Power Issue',
        category: 'equipment',
        priority: 'high',
        priorityReason: 'Classroom in use',
        summary: 'Projector power light flickering',
        observations: const [
          ObservedFact(
            text: 'Power indicator blinks red',
            evidenceLinks: [
              EvidenceLink(
                  evidenceId: 'photo_1',
                  type: 'photo',
                  label: 'Photo Evidence'),
            ],
          ),
        ],
        inferences: const [
          InferenceItem(
            text: 'Faulty power supply board',
            basis: 'Blinking red LED code',
            confidenceState: 'high',
            supportingEvidence: [],
          ),
        ],
        missingInformation: const [
          MissingInfoItem(
              prompt: 'Check secondary power outlet',
              contextReason: 'Rule out wall socket issue'),
        ],
        suggestedActions: const [
          SuggestedAction(step: 1, action: 'Replace power cable'),
        ],
        checklist: const [
          ChecklistItemData(id: 'chk_1', text: 'Inspect outlet voltage'),
        ],
        evidenceIds: const ['ev_1', 'ev_2'],
        confidenceState: 'HIGH',
        createdAt: now,
        updatedAt: now,
      );

      final json = packet.toJson();
      final restored = ActionPacketModel.fromJson(json);

      expect(restored.id, equals(packet.id));
      expect(restored.title, equals(packet.title));
      expect(restored.category, equals(packet.category));
      expect(restored.priority, equals(packet.priority));
      expect(restored.observations.length, equals(1));
      expect(restored.observations.first.text,
          equals('Power indicator blinks red'));
      expect(
          restored.inferences.first.text, equals('Faulty power supply board'));
      expect(restored.missingInformation.first.prompt,
          equals('Check secondary power outlet'));
      expect(restored.suggestedActions.first.action,
          equals('Replace power cable'));
      expect(restored.checklist.first.text, equals('Inspect outlet voltage'));
    });

    test(
        'ActionPacketModel.fromJson handles null and missing optional keys safely',
        () {
      final json = <String, dynamic>{
        'id': 'ap_minimal',
        'title': 'Minimal Packet',
      };

      final packet = ActionPacketModel.fromJson(json);

      expect(packet.id, equals('ap_minimal'));
      expect(packet.title, equals('Minimal Packet'));
      expect(packet.category, equals('equipment'));
      expect(packet.priority, equals('medium'));
      expect(packet.observations, isEmpty);
      expect(packet.inferences, isEmpty);
      expect(packet.checklist, isEmpty);
    });

    test(
        'ActionPacketModel copyWith updates specified fields while keeping existing',
        () {
      final packet = ActionPacketModel(
        id: 'ap_1',
        title: 'Original Title',
        category: 'it',
        priority: 'low',
        priorityReason: 'Routine',
        summary: 'Summary',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final updated = packet.copyWith(
        title: 'Updated Title',
        priority: 'critical',
      );

      expect(updated.id, equals('ap_1'));
      expect(updated.title, equals('Updated Title'));
      expect(updated.priority, equals('critical'));
      expect(updated.category, equals('it'));
    });
  });
}
