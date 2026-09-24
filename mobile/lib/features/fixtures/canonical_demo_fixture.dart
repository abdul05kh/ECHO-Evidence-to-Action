import 'package:uuid/uuid.dart';
import '../packet/domain/action_packet.dart';

/// Isolated canonical demo fixture module.
/// This module is ONLY executed when explicit DEMO_FIXTURE mode is active.
/// Live capture workflows must NEVER import or fall back to this module.
class CanonicalDemoFixture {
  static ActionPacketModel buildPacket({
    required String photoEvidenceId,
    required String voiceEvidenceId,
    int? captureDurationMs,
  }) {
    final now = DateTime.now();

    return ActionPacketModel(
      id: 'ap_demo_fixture_${now.millisecondsSinceEpoch}',
      workspaceId: 'ws_campus_ops',
      version: 1,
      status: 'ready',
      title: 'Lab 2 Projector Not Powering On',
      category: 'equipment',
      priority: 'high',
      priorityReason:
          'Academic session in Lab 2 scheduled to commence in ~20 minutes.',
      summary:
          'Projector ceiling unit in Lab 2 is completely unresponsive. Spare cable available in equipment room.',
      observations: [
        ObservedFact(
          text:
              'Projector ceiling unit in Lab 2 shows no active power LED indicator.',
          evidenceLinks: [
            EvidenceLink(
              evidenceId: photoEvidenceId,
              type: 'photo',
              label: 'Photo #01 (Projector Unit)',
            ),
          ],
          confidence: 0.98,
        ),
        ObservedFact(
          text:
              'Academic session in Lab 2 scheduled to commence in ~20 minutes.',
          evidenceLinks: [
            EvidenceLink(
              evidenceId: voiceEvidenceId,
              type: 'voice',
              label: 'Voice Note #01',
              excerpt: 'next class starts in about 20 minutes',
              timestampSec: 6,
            ),
          ],
          confidence: 0.95,
        ),
        ObservedFact(
          text: 'Spare cable reported available in the equipment room.',
          evidenceLinks: [
            EvidenceLink(
              evidenceId: voiceEvidenceId,
              type: 'voice',
              label: 'Voice Note #01',
              excerpt: 'spare cable in the equipment room',
              timestampSec: 12,
            ),
          ],
          confidence: 0.92,
        ),
      ],
      inferences: [
        InferenceItem(
          text:
              'Probable power delivery or cable seating issue rather than internal hardware defect.',
          basis:
              'Inferred from lack of power and mention of spare cabling in voice note.',
          confidenceState: 'high',
          supportingEvidence: [
            EvidenceLink(
              evidenceId: photoEvidenceId,
              type: 'photo',
              label: 'Photo #01',
            ),
            EvidenceLink(
              evidenceId: voiceEvidenceId,
              type: 'voice',
              label: 'Voice Note #01',
              timestampSec: 2,
            ),
          ],
        ),
      ],
      missingInformation: const [
        MissingInfoItem(
          prompt: 'Confirm whether the visible wall power switch is ON.',
          contextReason:
              'Wall socket switch state is not confirmed from evidence.',
          suggestedCheck: 'Visually check the wall socket power toggle.',
          isResolved: false,
        ),
        MissingInfoItem(
          prompt:
              'Confirm projector model and connector compatibility with the spare cable.',
          contextReason:
              'Cable interface type was not specified in the voice note.',
          suggestedCheck:
              'Inspect projector input panel before retrieving cable.',
          isResolved: false,
        ),
      ],
      suggestedActions: const [
        SuggestedAction(
          step: 1,
          action: 'Confirm visible wall power switch state is ON.',
          safetyNote: 'Ensure dry hands when checking wall switches.',
          confidence: 0.95,
        ),
        SuggestedAction(
          step: 2,
          action:
              'Retrieve the spare cable mentioned in the voice note from the equipment room.',
          confidence: 0.92,
        ),
        SuggestedAction(
          step: 3,
          action: 'Test the projector with the spare cable.',
          confidence: 0.90,
        ),
        SuggestedAction(
          step: 4,
          action: 'Confirm successful projection.',
          confidence: 0.95,
        ),
        SuggestedAction(
          step: 5,
          action: 'Capture closure evidence photo showing active display.',
          confidence: 0.98,
        ),
      ],
      checklist: [
        ChecklistItemData(
            id: 'chk_${const Uuid().v4().substring(0, 8)}',
            text: 'Confirm visible wall power switch state'),
        ChecklistItemData(
            id: 'chk_${const Uuid().v4().substring(0, 8)}',
            text: 'Retrieve spare cable from equipment room'),
        ChecklistItemData(
            id: 'chk_${const Uuid().v4().substring(0, 8)}',
            text: 'Connect spare cable to projector'),
        ChecklistItemData(
            id: 'chk_${const Uuid().v4().substring(0, 8)}',
            text: 'Confirm display output and projection'),
        ChecklistItemData(
            id: 'chk_${const Uuid().v4().substring(0, 8)}',
            text: 'Capture closure photo of working projection'),
      ],
      evidenceIds: [photoEvidenceId, voiceEvidenceId],
      confidenceState: 'HIGH',
      requiresHumanApproval: true,
      captureDurationMs: captureDurationMs ?? 35000,
      createdAt: now,
      updatedAt: now,
    );
  }
}
