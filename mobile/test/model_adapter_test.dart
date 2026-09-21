import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/ai/model_adapter.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';

void main() {
  group('EchoModelAdapter Tests', () {
    test('Prototype mode generates grounded Lab 2 Action Packet with evidence links', () async {
      final adapter = EchoModelAdapter(currentMode: ModelRuntimeMode.prototypeRuntime);

      final evidence = EvidencePackage(
        photoPath: '/storage/emulated/0/DCIM/evidence_01.jpg',
        voicePath: '/storage/emulated/0/Music/voice_01.m4a',
        voiceDurationSec: 18,
        voiceTranscript: 'Lab 2 projector is not powering on. The next class starts in about 20 minutes.',
        capturedAt: DateTime.now(),
      );

      final packet = await adapter.generatePacket(evidence, captureDurationMs: 42000);

      expect(packet.title, contains('Lab 2 Projector'));
      expect(packet.category, 'equipment');
      expect(packet.priority, 'high');
      expect(packet.priorityReason, contains('Upcoming operational deadline'));
      expect(packet.requiresHumanApproval, isTrue);

      // Verify Observed Facts have evidence citations
      expect(packet.observations.isNotEmpty, isTrue);
      final photoObs = packet.observations.firstWhere((o) => o.evidenceLinks.any((l) => l.type == 'photo'));
      expect(photoObs.evidenceLinks.first.label, contains('Photo #01'));

      // Verify Missing Information is explicit and not hallucinated
      expect(packet.missingInformation.isNotEmpty, isTrue);
      expect(packet.missingInformation.any((m) => m.prompt.contains('wall switch') || m.prompt.contains('breaker')), isTrue);

      // Verify Checklist items
      expect(packet.checklist.length, greaterThanOrEqualTo(3));
    });

    test('Deterministic fallback mode generates safe manual scaffold', () async {
      final adapter = EchoModelAdapter(currentMode: ModelRuntimeMode.deterministicFallback);

      final evidence = EvidencePackage(
        photoPath: '/local/photo.jpg',
        textNotes: 'Manual inspection required',
        capturedAt: DateTime.now(),
      );

      final packet = await adapter.generatePacket(evidence);

      expect(packet.status, 'needs_review');
      expect(packet.confidenceState, contains('Fallback'));
      expect(packet.priorityReason, contains('Deterministic fallback'));
      expect(packet.requiresHumanApproval, isTrue);
    });

    test('Model status returns honest runtime information', () async {
      final adapter = EchoModelAdapter(currentMode: ModelRuntimeMode.prototypeRuntime);
      final status = await adapter.getStatus();

      expect(status.mode, ModelRuntimeMode.prototypeRuntime);
      expect(status.isAvailable, isTrue);
      expect(status.displayName, contains('Prototype Runtime'));
      expect(status.deviceArchitecture, contains('ARM64'));
    });
  });
}
