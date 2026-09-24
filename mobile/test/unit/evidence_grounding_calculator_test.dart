import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/ai/evidence_grounding_calculator.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';

void main() {
  group('EvidenceGroundingCalculator Unit Tests', () {
    final now = DateTime.now();

    test('evaluates grounding score as Verified when all facts are grounded',
        () {
      final packet = ActionPacketModel(
        id: 'ap_ground_01',
        title: 'Projector Power Issue',
        category: 'equipment',
        priority: 'high',
        priorityReason: 'Class in 20 min',
        summary: 'Power LED dark.',
        observations: [
          const ObservedFact(
            text: 'Power LED dark',
            evidenceLinks: [
              EvidenceLink(evidenceId: 'ev_p1', label: 'Photo', type: 'photo')
            ],
          ),
        ],
        createdAt: now,
        updatedAt: now,
      );

      final result = EvidenceGroundingCalculator.evaluate(
        packet: packet,
        hasVoiceEvidence: true,
        hasPhotoEvidence: true,
        rawTranscript: 'Power LED dark on Lab 2 projector',
      );

      expect(result.score, 1.0);
      expect(result.confidenceState, 'Verified');
      expect(result.ungroundedClaims, 0);
    });

    test('lowers confidence state to Needs Review when ungrounded claims exist',
        () {
      final packet = ActionPacketModel(
        id: 'ap_ground_02',
        title: 'Unknown Issue',
        category: 'other',
        priority: 'low',
        priorityReason: 'Routine',
        summary: 'No details.',
        observations: [
          const ObservedFact(
              text: 'Internal circuit shorted', confidence: 0.20),
          const ObservedFact(text: 'Capacitor blown', confidence: 0.20),
        ],
        createdAt: now,
        updatedAt: now,
      );

      final result = EvidenceGroundingCalculator.evaluate(
        packet: packet,
        hasVoiceEvidence: false,
        hasPhotoEvidence: false,
        rawTranscript: '',
      );

      expect(result.score, 0.0);
      expect(result.confidenceState, 'Needs Review');
      expect(result.ungroundedClaims, 2);
    });
  });
}
