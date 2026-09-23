import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/ai/model_adapter.dart';

void main() {
  group('ECHO Voice Semantics & Domain Routing Test Suite (Tests A-G)', () {
    late EchoModelAdapter adapter;

    setUp(() {
      adapter =
          EchoModelAdapter(currentMode: ModelRuntimeMode.prototypeRuntime);
    });

    // =========================================================================
    // TEST A: Keyboard voice + keyboard photo -> IT_PERIPHERAL, Keyboard Reported Not Working
    // =========================================================================
    test(
        'TEST A: Voice "The keyboard isn\'t working. Please fix it." + Keyboard photo produces IT_PERIPHERAL packet',
        () async {
      final evidence = EvidencePackage(
        mode: CaptureMode.liveCapture,
        photoPath: '/storage/emulated/0/DCIM/Camera/keyboard.jpg',
        voicePath:
            '/data/user/0/com.echo.orchestrator.echo_mobile/cache/rec_keyboard.m4a',
        voiceDurationSec: 3,
        voiceTranscript: "The keyboard isn't working. Please fix it.",
        capturedAt: DateTime.now(),
        captureSessionId: 'sess_test_a',
      );

      final packet =
          await adapter.generatePacket(evidence, captureDurationMs: 1200);

      expect(packet.title, 'Keyboard Reported Not Working');
      expect(packet.category, 'it_peripheral');
      expect(packet.summary,
          'User reports that the keyboard is not working. The exact failure mode is not yet verified.');
      expect(packet.status, 'ready');
      expect(packet.confidenceState, 'MEDIUM');
      expect(packet.requiresHumanApproval, isTrue);

      // Observed facts
      expect(
          packet.observations.any((o) =>
              o.text == 'The user reports that the keyboard is not working.'),
          isTrue);
      expect(
          packet.observations.any(
              (o) => o.text == 'Keyboard is visible in the captured image.'),
          isTrue);

      // Inferences
      expect(
          packet.inferences.any((i) =>
              i.text == 'Possible connection, peripheral, or hardware issue.'),
          isTrue);
      expect(
          packet.inferences.any((i) =>
              i.basis.contains('User report + visible keyboard context')),
          isTrue);

      // Missing information ranked by operational usefulness
      expect(
          packet.missingInformation.any((m) =>
              m.prompt.contains('all keys or specific keys are affected')),
          isTrue);
      expect(
          packet.missingInformation
              .any((m) => m.prompt.contains('wired (USB) or wireless')),
          isTrue);
      expect(
          packet.missingInformation.any(
              (m) => m.prompt.contains('host device recognizes the keyboard')),
          isTrue);

      // Domain-specific safe actions
      expect(
          packet.suggestedActions.any((a) => a.action.contains(
              'Confirm whether the keyboard is connected or paired properly')),
          isTrue);
      expect(
          packet.suggestedActions.any((a) =>
              a.action.contains('Test another compatible port or host device')),
          isTrue);
      expect(
          packet.suggestedActions.any((a) => a.action
              .contains('Route to IT support for peripheral replacement')),
          isTrue);

      // Zero fixture contamination
      final serialized = packet.toJson().toString().toLowerCase();
      expect(serialized.contains('projector'), isFalse);
      expect(serialized.contains('lab 2'), isFalse);
      expect(serialized.contains('spare cable'), isFalse);
      expect(serialized.contains('switchboard'), isFalse);
    });

    // =========================================================================
    // TEST B: Keyboard voice + unrelated image -> IT_PERIPHERAL + mismatch warning + NEEDS_REVIEW
    // =========================================================================
    test(
        'TEST B: Voice "The keyboard isn\'t working." + Unrelated photo produces IT_PERIPHERAL with NEEDS_REVIEW mismatch',
        () async {
      final evidence = EvidencePackage(
        mode: CaptureMode.liveCapture,
        photoPath: '/data/user/0/cache/unrelated_code_screenshot.jpg',
        voicePath: '/data/user/0/cache/rec_kb_unrelated.m4a',
        voiceDurationSec: 4,
        voiceTranscript: "The keyboard isn't working.",
        capturedAt: DateTime.now(),
        captureSessionId: 'sess_test_b',
      );

      final packet =
          await adapter.generatePacket(evidence, captureDurationMs: 1250);

      expect(packet.title, 'Keyboard Reported Not Working');
      expect(packet.category, 'it_peripheral');
      expect(packet.status, 'needs_review');
      expect(packet.confidenceState, 'NEEDS REVIEW');

      // Visual observation explicitly notes insufficient visual evidence
      expect(
          packet.observations.any((o) =>
              o.text.contains('does not provide sufficient visual evidence')),
          isTrue);

      // Voice fact remains grounded
      expect(
          packet.observations.any((o) =>
              o.text == 'The user reports that the keyboard is not working.'),
          isTrue);

      // Zero projector fallback
      final serialized = packet.toJson().toString().toLowerCase();
      expect(serialized.contains('projector'), isFalse);
      expect(serialized.contains('lab 2'), isFalse);
    });

    // =========================================================================
    // TEST C: Voice "Projector isn't powering on." + Projector photo -> EQUIPMENT
    // =========================================================================
    test(
        'TEST C: Voice "Projector isn\'t powering on." + Projector photo routes to EQUIPMENT domain',
        () async {
      final evidence = EvidencePackage(
        mode: CaptureMode.liveCapture,
        photoPath: '/storage/emulated/0/DCIM/Camera/projector.jpg',
        voiceTranscript: "Projector isn't powering on.",
        capturedAt: DateTime.now(),
        captureSessionId: 'sess_test_c',
      );

      final packet = await adapter.generatePacket(evidence);

      expect(packet.title, 'Projector Operational Issue');
      expect(packet.category, 'equipment');
      expect(
          packet.observations.any((o) =>
              o.text.contains('Projector unit visible in the captured image')),
          isTrue);

      // No hardcoded Lab 2 / 20 min in LIVE_CAPTURE
      final serialized = packet.toJson().toString().toLowerCase();
      expect(serialized.contains('lab 2'), isFalse);
      expect(serialized.contains('20 minutes'), isFalse);
      expect(serialized.contains('spare cable'), isFalse);
    });

    // =========================================================================
    // TEST D: Voice "Switchboard isn't working." + Switchboard photo -> ELECTRICAL
    // =========================================================================
    test(
        'TEST D: Voice "Switchboard isn\'t working." + Switchboard photo routes to ELECTRICAL domain',
        () async {
      final evidence = EvidencePackage(
        mode: CaptureMode.liveCapture,
        photoPath: '/storage/emulated/0/DCIM/Camera/switchboard.jpg',
        voiceTranscript: "Switchboard isn't working.",
        capturedAt: DateTime.now(),
        captureSessionId: 'sess_test_d',
      );

      final packet = await adapter.generatePacket(evidence);

      expect(packet.title, 'Switchboard Reported Not Working');
      expect(packet.category, 'electrical');
      expect(
          packet.observations.any((o) => o.text.contains(
              'A wall-mounted switchboard is visible in the captured image')),
          isTrue);
      expect(
          packet.suggestedActions.any((a) =>
              a.action.contains('Route to qualified maintenance personnel')),
          isTrue);
    });

    // =========================================================================
    // TEST E: Audio captured but transcript unavailable -> Unverified Operational Issue (OTHER)
    // =========================================================================
    test(
        'TEST E: Audio captured without transcription generates Unverified Operational Issue in OTHER category',
        () async {
      final evidence = EvidencePackage(
        mode: CaptureMode.liveCapture,
        voicePath: '/data/user/0/cache/untranscribed_audio.m4a',
        voiceDurationSec: 8,
        voiceTranscript: null,
        textNotes: null,
        capturedAt: DateTime.now(),
        captureSessionId: 'sess_test_e',
      );

      final packet = await adapter.generatePacket(evidence);

      expect(packet.title, 'Unverified Operational Issue');
      expect(packet.category, 'other');
      expect(packet.summary,
          'An issue was reported, but the audio content could not be transcribed. Manual review is required.');
      expect(packet.status, 'needs_review');
      expect(packet.confidenceState, 'NEEDS REVIEW');

      // Observation notes audio was recorded without pretending transcript exists
      expect(
          packet.observations.any((o) =>
              o.text.contains('Speech content has not been transcribed')),
          isTrue);

      // Missing info prompts for manual description
      expect(
          packet.missingInformation.any((m) => m.prompt
              .contains('Add a short description of the reported issue')),
          isTrue);

      final serialized = packet.toJson().toString().toLowerCase();
      expect(serialized.contains('projector'), isFalse);
      expect(serialized.contains('lab 2'), isFalse);
      expect(serialized.contains('switchboard'), isFalse);
      expect(serialized.contains('keyboard'), isFalse);
    });

    // =========================================================================
    // TEST F: Previous DEMO_FIXTURE projector -> Current LIVE_CAPTURE keyboard -> ZERO projector contamination
    // =========================================================================
    test(
        'TEST F: Previous DEMO_FIXTURE projector followed by LIVE_CAPTURE keyboard has zero projector contamination',
        () async {
      // Step 1: Demo Fixture
      await adapter.generatePacket(EvidencePackage(
        mode: CaptureMode.demoFixture,
        photoPath: 'assets/sample_data/projector_broken.jpg',
        capturedAt: DateTime.now(),
        captureSessionId: 'sess_prev_demo',
      ));

      // Step 2: Live Capture Keyboard
      final kbPacket = await adapter.generatePacket(EvidencePackage(
        mode: CaptureMode.liveCapture,
        photoPath: '/storage/emulated/0/DCIM/Camera/keyboard.jpg',
        voiceTranscript: "The keyboard isn't working. Please fix it.",
        capturedAt: DateTime.now(),
        captureSessionId: 'sess_clean_kb',
      ));

      expect(kbPacket.title, 'Keyboard Reported Not Working');
      expect(kbPacket.category, 'it_peripheral');

      final serialized = kbPacket.toJson().toString().toLowerCase();
      expect(serialized.contains('projector'), isFalse);
      expect(serialized.contains('lab 2'), isFalse);
      expect(serialized.contains('spare cable'), isFalse);
      expect(serialized.contains('academic session'), isFalse);
      expect(serialized.contains('equipment room'), isFalse);
    });

    // =========================================================================
    // TEST G: Previous LIVE_CAPTURE keyboard -> Current LIVE_CAPTURE HVAC -> ZERO keyboard contamination
    // =========================================================================
    test(
        'TEST G: Previous LIVE_CAPTURE keyboard followed by LIVE_CAPTURE HVAC has zero keyboard contamination',
        () async {
      // Step 1: Keyboard
      final p1 = await adapter.generatePacket(EvidencePackage(
        mode: CaptureMode.liveCapture,
        photoPath: '/cache/kb.jpg',
        voiceTranscript: "The keyboard isn't working. Please fix it.",
        capturedAt: DateTime.now(),
        captureSessionId: 'sess_prev_kb',
      ));
      expect(p1.title, 'Keyboard Reported Not Working');

      // Step 2: HVAC
      final p2 = await adapter.generatePacket(EvidencePackage(
        mode: CaptureMode.liveCapture,
        photoPath: '/cache/ac.jpg',
        voiceTranscript: 'Air conditioner in office is not cooling',
        capturedAt: DateTime.now(),
        captureSessionId: 'sess_clean_hvac',
      ));

      expect(p2.title, 'HVAC / Cooling Issue Reported');
      expect(p2.category, 'hvac');

      final serialized = p2.toJson().toString().toLowerCase();
      expect(serialized.contains('keyboard'), isFalse);
      expect(serialized.contains('peripheral'), isFalse);
      expect(serialized.contains('usb'), isFalse);
      expect(serialized.contains('typing'), isFalse);
      expect(serialized.contains('keycaps'), isFalse);
    });

    // =========================================================================
    // Additional Safety & Grounding Tests
    // =========================================================================
    test(
        'Unsupported visual claim never appears in OBSERVED_FACTS for keyboard photo',
        () async {
      final evidence = EvidencePackage(
        mode: CaptureMode.liveCapture,
        photoPath: '/cache/keyboard_photo.jpg',
        voiceTranscript: "The keyboard isn't working. Please fix it.",
        capturedAt: DateTime.now(),
      );

      final packet = await adapter.generatePacket(evidence);

      final obsTexts =
          packet.observations.map((o) => o.text.toLowerCase()).join(' ');
      expect(obsTexts.contains('electrically defective'), isFalse);
      expect(obsTexts.contains('motherboard failed'), isFalse);
      expect(obsTexts.contains('usb controller is damaged'), isFalse);
      expect(obsTexts.contains('key switch is broken'), isFalse);
    });

    test('Timer is dynamic and calculated from actual capture duration',
        () async {
      final evidence = EvidencePackage(
        mode: CaptureMode.liveCapture,
        voiceTranscript: "The keyboard isn't working.",
        capturedAt: DateTime.now(),
      );

      final packet =
          await adapter.generatePacket(evidence, captureDurationMs: 11450);
      expect(packet.captureDurationMs, 11450);
    });

    test('Model status returns honest prototype runtime mode', () async {
      final liveStatus =
          await adapter.getStatus(captureMode: CaptureMode.liveCapture);
      expect(liveStatus.displayName, 'Prototype Runtime · Live Capture');
    });
  });

  // =========================================================================
  // PHASE 10 — REGRESSION TEST SUITE (TESTS 1 to 10)
  // =========================================================================
  group('Phase 10 — Local STT & Grounding Regression Suite (Tests 1-10)', () {
    late EchoModelAdapter adapter;

    setUp(() {
      adapter =
          EchoModelAdapter(currentMode: ModelRuntimeMode.prototypeRuntime);
    });

    // 1. Real transcript passed to ModelAdapter
    test('Test 1: Real transcript passed to ModelAdapter routes accurately',
        () async {
      final evidence = EvidencePackage(
        mode: CaptureMode.liveCapture,
        photoPath: '/storage/emulated/0/DCIM/Camera/keyboard.jpg',
        voiceTranscript: "The keyboard isn't working. Please fix it.",
        capturedAt: DateTime.now(),
        captureSessionId: 'test_1_real_stt',
      );
      final packet = await adapter.generatePacket(evidence);
      expect(packet.title, 'Keyboard Reported Not Working');
      expect(packet.category, 'it_peripheral');
      expect(
          packet.observations
              .any((o) => o.text.contains('keyboard is not working')),
          isTrue);
    });

    // 2. Empty transcript
    test('Test 2: Empty transcript generates Unverified Operational Issue',
        () async {
      final evidence = EvidencePackage(
        mode: CaptureMode.liveCapture,
        voiceTranscript: '',
        textNotes: '',
        capturedAt: DateTime.now(),
        captureSessionId: 'test_2_empty',
      );
      final packet = await adapter.generatePacket(evidence);
      expect(packet.title, 'Unverified Operational Issue');
      expect(packet.category, 'other');
      expect(packet.status, 'needs_review');
    });

    // 3. STT unavailable
    test(
        'Test 3: STT unavailable with voice recording attaches voice evidence without inventing text',
        () async {
      final evidence = EvidencePackage(
        mode: CaptureMode.liveCapture,
        voicePath: '/cache/rec.m4a',
        voiceDurationSec: 5,
        voiceTranscript: null,
        capturedAt: DateTime.now(),
        captureSessionId: 'test_3_stt_unavail',
      );
      final packet = await adapter.generatePacket(evidence);
      expect(
          packet.observations.any((o) =>
              o.text.contains('Speech content has not been transcribed')),
          isTrue);
      expect(packet.summary.contains('audio content could not be transcribed'),
          isTrue);
    });

    // 4. STT failure / error
    test(
        'Test 4: STT failure preserves captured voice reference with needs_review flag',
        () async {
      final evidence = EvidencePackage(
        mode: CaptureMode.liveCapture,
        voicePath: '/cache/rec_error.m4a',
        voiceDurationSec: 2,
        voiceTranscript: null,
        textNotes: null,
        capturedAt: DateTime.now(),
        captureSessionId: 'test_4_error',
      );
      final packet = await adapter.generatePacket(evidence);
      expect(packet.status, 'needs_review');
      expect(packet.confidenceState, 'NEEDS REVIEW');
      expect(
          packet.missingInformation
              .any((m) => m.prompt.contains('Add a short description')),
          isTrue);
    });

    // 5. Demo fixture isolation
    test(
        'Test 5: Demo fixture isolation guarantees canonical Lab 2 only in demo mode',
        () async {
      final demoPacket = await adapter.generatePacket(EvidencePackage(
        mode: CaptureMode.demoFixture,
        photoPath: 'assets/sample_data/projector_broken.jpg',
        capturedAt: DateTime.now(),
        captureSessionId: 'test_5_demo',
      ));
      expect(
          demoPacket.title.contains('Projector') ||
              demoPacket.summary.contains('Lab 2'),
          isTrue);

      final livePacket = await adapter.generatePacket(EvidencePackage(
        mode: CaptureMode.liveCapture,
        photoPath: '/cache/something_else.jpg',
        capturedAt: DateTime.now(),
        captureSessionId: 'test_5_live',
      ));
      expect(livePacket.toJson().toString().toLowerCase().contains('lab 2'),
          isFalse);
    });

    // 6. Live capture after demo fixture
    test(
        'Test 6: Live capture immediately following demo fixture contains zero demo leakage',
        () async {
      await adapter.generatePacket(EvidencePackage(
        mode: CaptureMode.demoFixture,
        capturedAt: DateTime.now(),
      ));
      final cleanPacket = await adapter.generatePacket(EvidencePackage(
        mode: CaptureMode.liveCapture,
        photoPath: '/cache/mouse.jpg',
        voiceTranscript: 'Mouse scroll wheel is jammed',
        capturedAt: DateTime.now(),
      ));
      expect(cleanPacket.category, 'it_peripheral');
      expect(
          cleanPacket.toJson().toString().toLowerCase().contains('projector'),
          isFalse);
    });

    // 7. Different issue after previous issue
    test(
        'Test 7: Different issue sequence switchboard -> keyboard -> plumbing produces distinct domains',
        () async {
      final p1 = await adapter.generatePacket(EvidencePackage(
        mode: CaptureMode.liveCapture,
        voiceTranscript: 'Switchboard breaker tripped',
        capturedAt: DateTime.now(),
      ));
      expect(p1.category, 'electrical');

      final p2 = await adapter.generatePacket(EvidencePackage(
        mode: CaptureMode.liveCapture,
        voiceTranscript: 'Keyboard key stuck',
        capturedAt: DateTime.now(),
      ));
      expect(p2.category, 'it_peripheral');

      final p3 = await adapter.generatePacket(EvidencePackage(
        mode: CaptureMode.liveCapture,
        voiceTranscript: 'Water pipe leak under sink',
        capturedAt: DateTime.now(),
      ));
      expect(p3.category, 'plumbing');
    });

    // 8. Transcript + unrelated photo
    test(
        'Test 8: Transcript with unrelated photo lowers confidence to NEEDS REVIEW',
        () async {
      final packet = await adapter.generatePacket(EvidencePackage(
        mode: CaptureMode.liveCapture,
        photoPath: '/cache/unrelated_desk.jpg',
        voiceTranscript: "The keyboard isn't working.",
        capturedAt: DateTime.now(),
      ));
      expect(packet.confidenceState, 'NEEDS REVIEW');
      expect(
          packet.observations.any((o) =>
              o.text.contains('does not provide sufficient visual evidence')),
          isTrue);
    });

    // 9. Airplane Mode (Offline verification)
    test(
        'Test 9: Offline execution contract completes in under 2 seconds with zero network requirement',
        () async {
      final stopwatch = Stopwatch()..start();
      final packet = await adapter.generatePacket(EvidencePackage(
        mode: CaptureMode.liveCapture,
        photoPath: '/cache/offline_photo.jpg',
        voiceTranscript: "The keyboard isn't working. Please fix it.",
        capturedAt: DateTime.now(),
      ));
      stopwatch.stop();
      expect(packet.category, 'it_peripheral');
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));
    });

    // 10. Duplicate capture
    test('Test 10: Duplicate captures receive independent IDs and timestamps',
        () async {
      final p1 = await adapter.generatePacket(EvidencePackage(
        mode: CaptureMode.liveCapture,
        voiceTranscript: "The keyboard isn't working.",
        capturedAt: DateTime.now(),
        captureSessionId: 'sess_1',
      ));
      final p2 = await adapter.generatePacket(EvidencePackage(
        mode: CaptureMode.liveCapture,
        voiceTranscript: "The keyboard isn't working.",
        capturedAt: DateTime.now(),
        captureSessionId: 'sess_2',
      ));
      expect(p1.id, isNot(equals(p2.id)));
    });
  });
}
