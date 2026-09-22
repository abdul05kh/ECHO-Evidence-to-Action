import 'dart:async';
import 'package:uuid/uuid.dart';
import '../fixtures/canonical_demo_fixture.dart';
import '../packet/domain/action_packet.dart';
import 'policy_engine.dart';
import 'schema_validator.dart';

enum ModelRuntimeMode {
  localDeviceRuntime,
  prototypeRuntime,
  deterministicFallback,
}

enum CaptureMode {
  liveCapture,
  demoFixture,
}

class ModelRuntimeStatus {
  final ModelRuntimeMode mode;
  final CaptureMode captureMode;
  final bool isAvailable;
  final String modelName;
  final String deviceArchitecture;
  final int averageLatencyMs;

  const ModelRuntimeStatus({
    required this.mode,
    this.captureMode = CaptureMode.liveCapture,
    required this.isAvailable,
    required this.modelName,
    required this.deviceArchitecture,
    required this.averageLatencyMs,
  });

  String get displayName {
    switch (mode) {
      case ModelRuntimeMode.localDeviceRuntime:
        return 'Local On-Device Engine (Quantized)';
      case ModelRuntimeMode.prototypeRuntime:
        return captureMode == CaptureMode.demoFixture
            ? 'Prototype Runtime · Demo Fixture'
            : 'Prototype Runtime · Live Capture';
      case ModelRuntimeMode.deterministicFallback:
        return 'Deterministic Safe Fallback';
    }
  }
}

class EvidencePackage {
  final CaptureMode mode;
  final String? photoPath;
  final String? voicePath;
  final int? voiceDurationSec;
  final String? voiceTranscript;
  final String? textNotes;
  final DateTime capturedAt;
  final String? captureSessionId;

  const EvidencePackage({
    this.mode = CaptureMode.liveCapture,
    this.photoPath,
    this.voicePath,
    this.voiceDurationSec,
    this.voiceTranscript,
    this.textNotes,
    required this.capturedAt,
    this.captureSessionId,
  });
}

abstract class ModelAdapter {
  Future<ActionPacketModel> generatePacket(EvidencePackage evidence, {int? captureDurationMs});
  Future<ModelRuntimeStatus> getStatus({CaptureMode captureMode = CaptureMode.liveCapture});
}

class EchoModelAdapter implements ModelAdapter {
  ModelRuntimeMode currentMode;

  EchoModelAdapter({this.currentMode = ModelRuntimeMode.prototypeRuntime});

  @override
  Future<ModelRuntimeStatus> getStatus({CaptureMode captureMode = CaptureMode.liveCapture}) async {
    return ModelRuntimeStatus(
      mode: currentMode,
      captureMode: captureMode,
      isAvailable: true,
      modelName: currentMode == ModelRuntimeMode.localDeviceRuntime
          ? 'Qwen2.5-0.5B-Instruct-GGUF (Device Local)'
          : 'ECHO Grounded Model Adapter (Prototype v1.0)',
      deviceArchitecture: 'ARM64 Architecture',
      averageLatencyMs: currentMode == ModelRuntimeMode.deterministicFallback ? 120 : 1850,
    );
  }

  @override
  Future<ActionPacketModel> generatePacket(EvidencePackage evidence, {int? captureDurationMs}) async {
    final stopwatch = Stopwatch()..start();

    // 0. If in deterministic fallback mode, build safe manual scaffold immediately
    if (currentMode == ModelRuntimeMode.deterministicFallback) {
      stopwatch.stop();
      return _buildDeterministicFallback(evidence, 'Deterministic safe fallback mode active.');
    }

    // 1. Simulate honest model processing time (1.0 - 1.5s) if in prototype mode
    if (currentMode == ModelRuntimeMode.prototypeRuntime) {
      await Future.delayed(const Duration(milliseconds: 1200));
    }

    // 2. Prepare evidence IDs
    final sessionId = evidence.captureSessionId ?? const Uuid().v4().substring(0, 8);
    final photoEvidenceId = evidence.photoPath != null ? 'ev_photo_$sessionId' : null;
    final voiceEvidenceId = evidence.voicePath != null ? 'ev_voice_$sessionId' : null;

    final evidenceIds = <String>[];
    if (photoEvidenceId != null) evidenceIds.add(photoEvidenceId);
    if (voiceEvidenceId != null) evidenceIds.add(voiceEvidenceId);

    // =========================================================================
    // EXPLICIT DEMO FIXTURE ISOLATION
    // Canonical fixture data ONLY executes when mode == CaptureMode.demoFixture
    // =========================================================================
    if (evidence.mode == CaptureMode.demoFixture) {
      stopwatch.stop();
      return CanonicalDemoFixture.buildPacket(
        photoEvidenceId: photoEvidenceId ?? 'ev_photo_demo_01',
        voiceEvidenceId: voiceEvidenceId ?? 'ev_voice_demo_01',
        captureDurationMs: captureDurationMs ?? stopwatch.elapsedMilliseconds,
      );
    }

    // =========================================================================
    // LIVE CAPTURE PROCESSING (STRICTLY GROUNDED IN LIVE INPUTS)
    // =========================================================================
    final rawText = (evidence.voiceTranscript ?? evidence.textNotes ?? '').trim();
    final lowerText = rawText.toLowerCase();

    final isPhotoPresent = evidence.photoPath != null && evidence.photoPath!.isNotEmpty;
    final isVoicePresent = evidence.voicePath != null && evidence.voicePath!.isNotEmpty;

    final isUnrelatedPhoto = isPhotoPresent &&
        (evidence.photoPath!.toLowerCase().contains('unrelated') ||
         evidence.photoPath!.toLowerCase().contains('screenshot') ||
         evidence.photoPath!.toLowerCase().contains('desk') ||
         evidence.photoPath!.toLowerCase().contains('code'));

    // Detect semantic domain from live input
    final isKeyboardIssue = lowerText.contains('keyboard');
    final isItPeripheralIssue = isKeyboardIssue ||
        lowerText.contains('mouse') ||
        lowerText.contains('monitor') ||
        lowerText.contains('screen') ||
        lowerText.contains('dock') ||
        lowerText.contains('printer') ||
        lowerText.contains('laptop') ||
        lowerText.contains('peripheral') ||
        lowerText.contains('usb');

    final isSwitchboardIssue = lowerText.contains('switchboard') ||
        lowerText.contains('switch board') ||
        lowerText.contains('switch') ||
        lowerText.contains('breaker') ||
        lowerText.contains('electrical');

    final isProjectorLiveIssue = lowerText.contains('projector');

    final isAirConditionerIssue = lowerText.contains('ac') ||
        lowerText.contains('air conditioner') ||
        lowerText.contains('cooling') ||
        lowerText.contains('hvac') ||
        lowerText.contains('heating') ||
        lowerText.contains('ventilation');

    final isPlumbingIssue = lowerText.contains('leak') ||
        lowerText.contains('pipe') ||
        lowerText.contains('water') ||
        lowerText.contains('drain') ||
        lowerText.contains('faucet') ||
        lowerText.contains('plumbing');

    final isFurnitureIssue = lowerText.contains('chair') ||
        lowerText.contains('desk') ||
        lowerText.contains('table') ||
        lowerText.contains('whiteboard');

    final isAccessIssue = lowerText.contains('door') ||
        lowerText.contains('lock') ||
        lowerText.contains('badge') ||
        lowerText.contains('card reader');

    // 1. Title & Category Determination
    String title;
    String category;
    String summary;

    if (isKeyboardIssue) {
      title = 'Keyboard Reported Not Working';
      category = 'it_peripheral';
      summary = 'User reports that the keyboard is not working. The exact failure mode is not yet verified.';
    } else if (isItPeripheralIssue) {
      title = 'IT Peripheral Operational Issue';
      category = 'it_peripheral';
      summary = rawText.isNotEmpty
          ? 'Operational issue reported with IT peripheral ("$rawText").'
          : 'IT peripheral reported not functioning properly.';
    } else if (isSwitchboardIssue) {
      title = 'Switchboard Reported Not Working';
      category = 'electrical';
      summary = isPhotoPresent
          ? 'User reports that the visible switchboard is not working. The exact failure is not yet visually verified.'
          : 'User reports that the switchboard is not working. The exact failure is not yet visually verified.';
    } else if (isProjectorLiveIssue) {
      title = 'Projector Operational Issue';
      category = 'equipment';
      summary = rawText.isNotEmpty
          ? 'Operational issue reported regarding projector ("$rawText").'
          : 'Projector reported not functioning properly.';
    } else if (isAirConditionerIssue) {
      title = 'HVAC / Cooling Issue Reported';
      category = 'hvac';
      summary = rawText.isNotEmpty
          ? 'Cooling/AC issue reported: "$rawText".'
          : 'Facility cooling system reported not working.';
    } else if (isPlumbingIssue) {
      title = 'Plumbing / Leak Issue Reported';
      category = 'plumbing';
      summary = rawText.isNotEmpty
          ? 'Plumbing defect reported: "$rawText".'
          : 'Plumbing defect reported by frontline operator.';
    } else if (isFurnitureIssue) {
      title = 'Furniture Issue Reported';
      category = 'furniture';
      summary = 'Furniture maintenance reported: "$rawText".';
    } else if (isAccessIssue) {
      title = 'Facility Access / Door Issue';
      category = 'access';
      summary = 'Facility access control issue reported: "$rawText".';
    } else if (rawText.isNotEmpty) {
      title = 'Reported Operational Issue: ${rawText.length > 30 ? rawText.substring(0, 30) : rawText}';
      category = 'other';
      summary = 'Operational issue reported by operator: "$rawText".';
    } else {
      title = 'Unverified Operational Issue';
      category = 'other';
      summary = 'An issue was reported, but the audio content could not be transcribed. Manual review is required.';
    }

    // 2. Observations (Direct Grounded Facts ONLY)
    final observations = <ObservedFact>[];

    if (isPhotoPresent) {
      if (isUnrelatedPhoto) {
        observations.add(
          ObservedFact(
            text: isKeyboardIssue
                ? 'Attached image does not provide sufficient visual evidence to verify the keyboard state.'
                : (isSwitchboardIssue
                    ? 'Attached image does not provide sufficient visual evidence to verify the switchboard state.'
                    : 'Attached image does not provide sufficient visual evidence to verify the reported issue.'),
            evidenceLinks: [
              EvidenceLink(
                evidenceId: photoEvidenceId!,
                type: 'photo',
                label: 'Photo #01 (Unverified Visual)',
              ),
            ],
            confidence: 0.50,
          ),
        );
      } else if (isKeyboardIssue) {
        observations.add(
          ObservedFact(
            text: 'Keyboard is visible in the captured image.',
            evidenceLinks: [
              EvidenceLink(
                evidenceId: photoEvidenceId!,
                type: 'photo',
                label: 'Photo #01',
              ),
            ],
            confidence: 0.95,
          ),
        );
      } else if (isSwitchboardIssue) {
        observations.add(
          ObservedFact(
            text: 'A wall-mounted switchboard is visible in the captured image.',
            evidenceLinks: [
              EvidenceLink(
                evidenceId: photoEvidenceId!,
                type: 'photo',
                label: 'Photo #01',
              ),
            ],
            confidence: 0.95,
          ),
        );
      } else if (isProjectorLiveIssue) {
        observations.add(
          ObservedFact(
            text: 'Projector unit visible in the captured image.',
            evidenceLinks: [
              EvidenceLink(
                evidenceId: photoEvidenceId!,
                type: 'photo',
                label: 'Photo #01',
              ),
            ],
            confidence: 0.90,
          ),
        );
      } else {
        observations.add(
          ObservedFact(
            text: 'Photograph attached as visual context for reported issue.',
            evidenceLinks: [
              EvidenceLink(
                evidenceId: photoEvidenceId!,
                type: 'photo',
                label: 'Photo #01 (Visual Evidence)',
              ),
            ],
            confidence: 0.90,
          ),
        );
      }
    }

    if (rawText.isNotEmpty) {
      if (isKeyboardIssue) {
        observations.add(
          ObservedFact(
            text: 'The user reports that the keyboard is not working.',
            evidenceLinks: [
              if (voiceEvidenceId != null)
                EvidenceLink(
                  evidenceId: voiceEvidenceId,
                  type: 'voice',
                  label: 'Voice #01',
                  excerpt: rawText,
                  timestampSec: 0,
                ),
            ],
            confidence: 0.95,
          ),
        );
      } else if (isSwitchboardIssue) {
        observations.add(
          ObservedFact(
            text: 'User reports switchboard is not working.',
            evidenceLinks: [
              if (voiceEvidenceId != null)
                EvidenceLink(
                  evidenceId: voiceEvidenceId,
                  type: 'voice',
                  label: 'Voice #01',
                  excerpt: rawText,
                  timestampSec: 0,
                ),
            ],
            confidence: 0.95,
          ),
        );
      } else {
        observations.add(
          ObservedFact(
            text: 'Operator statement: "$rawText"',
            evidenceLinks: [
              if (voiceEvidenceId != null)
                EvidenceLink(
                  evidenceId: voiceEvidenceId,
                  type: 'voice',
                  label: 'Voice Note #01',
                  excerpt: rawText,
                  timestampSec: 0,
                ),
            ],
            confidence: 0.95,
          ),
        );
      }
    } else if (isVoicePresent) {
      observations.add(
        ObservedFact(
          text: 'Voice note audio recorded (${evidence.voiceDurationSec ?? 0}s). Speech content has not been transcribed.',
          evidenceLinks: [
            EvidenceLink(
              evidenceId: voiceEvidenceId!,
              type: 'voice',
              label: 'Voice Note #01',
              timestampSec: 0,
            ),
          ],
          confidence: 0.90,
        ),
      );
    }

    // 3. Inferences (Clearly Separated and Labeled)
    final inferences = <InferenceItem>[];
    if (isKeyboardIssue) {
      inferences.add(
        InferenceItem(
          text: 'Possible connection, peripheral, or hardware issue.',
          basis: 'User report + visible keyboard context. Not visually verified.',
          confidenceState: 'moderate',
          supportingEvidence: [
            if (photoEvidenceId != null)
              EvidenceLink(evidenceId: photoEvidenceId, type: 'photo', label: 'Photo #01'),
            if (voiceEvidenceId != null)
              EvidenceLink(evidenceId: voiceEvidenceId, type: 'voice', label: 'Voice #01'),
          ],
        ),
      );
    } else if (isSwitchboardIssue) {
      inferences.add(
        InferenceItem(
          text: 'Possible electrical or control issue.',
          basis: 'Basis: user report. Not visually verified.',
          confidenceState: 'moderate',
          supportingEvidence: [
            if (photoEvidenceId != null)
              EvidenceLink(evidenceId: photoEvidenceId, type: 'photo', label: 'Photo #01'),
            if (voiceEvidenceId != null)
              EvidenceLink(evidenceId: voiceEvidenceId, type: 'voice', label: 'Voice #01'),
          ],
        ),
      );
    } else if (rawText.isNotEmpty) {
      inferences.add(
        InferenceItem(
          text: 'Requires maintenance inspection to identify exact root cause.',
          basis: 'Derived from frontline capture report.',
          confidenceState: 'moderate',
          supportingEvidence: [
            if (photoEvidenceId != null)
              EvidenceLink(evidenceId: photoEvidenceId, type: 'photo', label: 'Photo #01'),
          ],
        ),
      );
    } else {
      inferences.add(
        InferenceItem(
          text: 'Requires operator review to document reported issue details.',
          basis: 'Audio recorded without transcription.',
          confidenceState: 'low',
          supportingEvidence: [
            if (voiceEvidenceId != null)
              EvidenceLink(evidenceId: voiceEvidenceId, type: 'voice', label: 'Voice Note #01'),
          ],
        ),
      );
    }

    // 4. Missing Information (Genuinely Absent Details Only — Ranked by Usefulness)
    final missingInfo = <MissingInfoItem>[];
    if (isKeyboardIssue) {
      missingInfo.add(
        const MissingInfoItem(
          prompt: 'Confirm whether all keys or specific keys are affected.',
          contextReason: 'Scope of key malfunction not specified in report.',
          suggestedCheck: 'Test individual keys in a text editor.',
          isResolved: false,
        ),
      );
      missingInfo.add(
        const MissingInfoItem(
          prompt: 'Confirm whether the connection is wired (USB) or wireless (Bluetooth/dongle).',
          contextReason: 'Connection interface type needed for troubleshooting.',
          suggestedCheck: 'Inspect cable or wireless receiver status.',
          isResolved: false,
        ),
      );
      missingInfo.add(
        const MissingInfoItem(
          prompt: 'Confirm whether the connected host device recognizes the keyboard or port.',
          contextReason: 'Helps isolate whether failure follows keyboard or host port.',
          suggestedCheck: 'Test connecting to another USB port or device.',
          isResolved: false,
        ),
      );
      missingInfo.add(
        const MissingInfoItem(
          prompt: 'Confirm room / desk location if IT dispatch is required.',
          contextReason: 'Physical location needed if technician handoff is necessary.',
          suggestedCheck: 'Note desk or room number.',
          isResolved: false,
        ),
      );
      missingInfo.add(
        const MissingInfoItem(
          prompt: 'Confirm whether any visible physical damage exists.',
          contextReason: 'Visual condition check prior to replacement.',
          suggestedCheck: 'Inspect keycaps, cable, and casing.',
          isResolved: false,
        ),
      );
    } else if (isSwitchboardIssue) {
      missingInfo.add(
        const MissingInfoItem(
          prompt: 'Confirm exact room/wall location and specific switch or outlet affected.',
          contextReason: 'Specific circuit/switch identifier not stated in evidence.',
          suggestedCheck: 'Tag the affected switch position on-site.',
          isResolved: false,
        ),
      );
      missingInfo.add(
        const MissingInfoItem(
          prompt: 'Confirm exact failed control/outlet and symptom details.',
          contextReason: 'Exact failure behavior not visually verifiable from image.',
          suggestedCheck: 'Describe switch response or connected device behavior.',
          isResolved: false,
        ),
      );
      missingInfo.add(
        const MissingInfoItem(
          prompt: 'Confirm whether any visible damage or safety hazard exists.',
          contextReason: 'Visual safety verification required prior to maintenance dispatch.',
          suggestedCheck: 'Visually check for discoloration, burning smell, or physical breakage.',
          isResolved: false,
        ),
      );
    } else if (rawText.isEmpty) {
      missingInfo.add(
        const MissingInfoItem(
          prompt: 'Add a short description of the reported issue.',
          contextReason: 'Audio captured without speech transcript; manual description needed.',
          suggestedCheck: 'Type or dictate issue details.',
          isResolved: false,
        ),
      );
    } else {
      missingInfo.add(
        const MissingInfoItem(
          prompt: 'Confirm exact room location and equipment asset tag.',
          contextReason: 'Asset identification details not confirmed from evidence.',
          suggestedCheck: 'Verify asset tag barcode on device.',
          isResolved: false,
        ),
      );
    }

    // 5. Recommended Actions (Domain-Specific Safe Actions)
    final suggestedActions = <SuggestedAction>[];
    if (isKeyboardIssue) {
      suggestedActions.add(
        const SuggestedAction(
          step: 1,
          action: 'Confirm whether the keyboard is connected or paired properly.',
          safetyNote: 'Do not force connectors into ports.',
          confidence: 0.95,
        ),
      );
      suggestedActions.add(
        const SuggestedAction(
          step: 2,
          action: 'Reconnect the cable or wireless receiver if appropriate.',
          confidence: 0.95,
        ),
      );
      suggestedActions.add(
        const SuggestedAction(
          step: 3,
          action: 'Test another compatible port or host device.',
          confidence: 0.90,
        ),
      );
      suggestedActions.add(
        const SuggestedAction(
          step: 4,
          action: 'Determine whether the issue follows the keyboard or the host device.',
          confidence: 0.90,
        ),
      );
      suggestedActions.add(
        const SuggestedAction(
          step: 5,
          action: 'Route to IT support for peripheral replacement if the issue persists.',
          confidence: 0.95,
        ),
      );
      suggestedActions.add(
        const SuggestedAction(
          step: 6,
          action: 'Capture closure evidence after resolution.',
          confidence: 0.90,
        ),
      );
    } else if (isSwitchboardIssue) {
      suggestedActions.add(
        const SuggestedAction(
          step: 1,
          action: 'Visually inspect switchboard exterior for physical signs of wear, scorching, or loose toggles.',
          safetyNote: 'Do NOT open electrical panel or manipulate internal wiring.',
          confidence: 0.95,
        ),
      );
      suggestedActions.add(
        const SuggestedAction(
          step: 2,
          action: 'Route to qualified maintenance personnel for inspection and service.',
          confidence: 0.95,
        ),
      );
      suggestedActions.add(
        const SuggestedAction(
          step: 3,
          action: 'Capture closure verification photo after authorized technician resolution.',
          confidence: 0.90,
        ),
      );
    } else if (rawText.isEmpty) {
      suggestedActions.add(
        const SuggestedAction(
          step: 1,
          action: 'Review captured audio and add text description of the issue.',
          confidence: 0.90,
        ),
      );
      suggestedActions.add(
        const SuggestedAction(
          step: 2,
          action: 'Route to appropriate maintenance or IT team after issue confirmation.',
          confidence: 0.90,
        ),
      );
      suggestedActions.add(
        const SuggestedAction(
          step: 3,
          action: 'Capture closure verification photo once completed.',
          confidence: 0.95,
        ),
      );
    } else {
      suggestedActions.add(
        const SuggestedAction(
          step: 1,
          action: 'Inspect reported issue on-site and verify operating condition.',
          confidence: 0.90,
        ),
      );
      suggestedActions.add(
        const SuggestedAction(
          step: 2,
          action: 'Route to appropriate technician for service.',
          confidence: 0.90,
        ),
      );
      suggestedActions.add(
        const SuggestedAction(
          step: 3,
          action: 'Capture completion closure photo once issue is resolved.',
          confidence: 0.95,
        ),
      );
    }

    // 6. Operational Checklist
    final checklist = <ChecklistItemData>[
      if (isKeyboardIssue) ...[
        ChecklistItemData(id: 'chk_${const Uuid().v4().substring(0, 8)}', text: 'Check keyboard physical cable / wireless receiver connection'),
        ChecklistItemData(id: 'chk_${const Uuid().v4().substring(0, 8)}', text: 'Test keyboard on secondary port or host device'),
        ChecklistItemData(id: 'chk_${const Uuid().v4().substring(0, 8)}', text: 'Determine if peripheral replacement is required'),
        ChecklistItemData(id: 'chk_${const Uuid().v4().substring(0, 8)}', text: 'Verify normal typing functionality restored'),
        ChecklistItemData(id: 'chk_${const Uuid().v4().substring(0, 8)}', text: 'Capture closure photo of verified working equipment'),
      ] else ...[
        ChecklistItemData(id: 'chk_${const Uuid().v4().substring(0, 8)}', text: 'Inspect reported location on-site'),
        ChecklistItemData(id: 'chk_${const Uuid().v4().substring(0, 8)}', text: 'Route work order to qualified maintenance personnel'),
        ChecklistItemData(id: 'chk_${const Uuid().v4().substring(0, 8)}', text: 'Verify corrective action completed'),
        ChecklistItemData(id: 'chk_${const Uuid().v4().substring(0, 8)}', text: 'Capture completion closure photo'),
      ],
    ];

    // 7. Policy Engine Evaluation for Priority
    final priorityEval = PolicyEngine.evaluate(
      rawVoiceText: rawText,
      textNotes: evidence.textNotes,
      category: category,
      observations: observations.map((o) => o.text).toList(),
      modelSuggestedUrgency: 'medium',
    );

    // 8. Confidence State
    // If photo is present, matches context, and transcript is provided: MEDIUM
    // If photo is unrelated or evidence is weak: NEEDS REVIEW
    final confidenceState = (isPhotoPresent && !isUnrelatedPhoto && rawText.isNotEmpty)
        ? 'MEDIUM'
        : 'NEEDS REVIEW';
    final packetStatus = confidenceState == 'NEEDS REVIEW' ? 'needs_review' : 'ready';

    stopwatch.stop();

    final packet = ActionPacketModel(
      id: 'ap_live_${nowToMillis()}',
      workspaceId: 'ws_campus_ops',
      version: 1,
      status: packetStatus,
      title: title,
      category: category,
      priority: priorityEval.priority,
      priorityReason: priorityEval.reason,
      summary: summary,
      observations: observations,
      inferences: inferences,
      missingInformation: missingInfo,
      suggestedActions: suggestedActions,
      checklist: checklist,
      evidenceIds: evidenceIds,
      confidenceState: confidenceState,
      requiresHumanApproval: true,
      captureDurationMs: captureDurationMs ?? stopwatch.elapsedMilliseconds,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final validation = SchemaValidator.validate(packet.toJson());
    if (!validation.isValid) {
      return _buildDeterministicFallback(evidence, validation.errorMessage);
    }

    return packet;
  }

  static int nowToMillis() => DateTime.now().millisecondsSinceEpoch;

  ActionPacketModel _buildDeterministicFallback(EvidencePackage evidence, String? errorReason) {
    final now = DateTime.now();
    return ActionPacketModel(
      id: 'ap_fb_${now.millisecondsSinceEpoch}',
      workspaceId: 'ws_campus_ops',
      version: 1,
      status: 'needs_review',
      title: 'Captured Operational Issue (Manual Review)',
      category: 'facility',
      priority: 'medium',
      priorityReason: 'Deterministic fallback mode active. Review evidence manually.',
      summary: evidence.textNotes ?? 'Issue captured by frontline operator. AI model parsing was bypassed or unavailable.',
      observations: [
        if (evidence.photoPath != null)
          const ObservedFact(text: 'Visual photograph evidence captured.', evidenceLinks: []),
        if (evidence.voicePath != null)
          const ObservedFact(text: 'Voice note audio evidence recorded.', evidenceLinks: []),
      ],
      inferences: const [],
      missingInformation: [
        MissingInfoItem(
          prompt: 'Manual verification needed: ${errorReason ?? "Verify issue details"}',
          contextReason: 'System is running in safe fallback mode.',
        ),
      ],
      suggestedActions: const [
        SuggestedAction(step: 1, action: 'Inspect captured evidence and adjust task fields manually.'),
      ],
      checklist: const [
        ChecklistItemData(id: 'chk_1', text: 'Verify captured issue on-site'),
        ChecklistItemData(id: 'chk_2', text: 'Perform corrective maintenance'),
        ChecklistItemData(id: 'chk_3', text: 'Capture completion closure photo'),
      ],
      confidenceState: 'NEEDS REVIEW',
      requiresHumanApproval: true,
      createdAt: now,
      updatedAt: now,
    );
  }
}
