import '../packet/domain/action_packet.dart';

/// Result object holding evidence grounding assessment details.
class EvidenceGroundingResult {
  final double score; // 0.0 to 1.0
  final String confidenceState; // 'Verified', 'High Confidence', 'Needs Review'
  final int totalObservedFacts;
  final int groundedFacts;
  final int ungroundedClaims;
  final bool hasVoiceEvidence;
  final bool hasPhotoEvidence;
  final List<String> ungroundedClaimList;

  const EvidenceGroundingResult({
    required this.score,
    required this.confidenceState,
    required this.totalObservedFacts,
    required this.groundedFacts,
    required this.ungroundedClaims,
    required this.hasVoiceEvidence,
    required this.hasPhotoEvidence,
    required this.ungroundedClaimList,
  });
}

/// Evaluates evidence grounding for Action Packets against captured multimodal artifacts.
class EvidenceGroundingCalculator {
  /// Computes grounding confidence score and returns a detailed [EvidenceGroundingResult].
  static EvidenceGroundingResult evaluate({
    required ActionPacketModel packet,
    required bool hasVoiceEvidence,
    required bool hasPhotoEvidence,
    String? rawTranscript,
  }) {
    final observations = packet.observations;
    final total = observations.length;

    if (total == 0) {
      final defaultState = (hasVoiceEvidence || hasPhotoEvidence)
          ? 'High Confidence'
          : 'Needs Review';
      return EvidenceGroundingResult(
        score: (hasVoiceEvidence || hasPhotoEvidence) ? 0.85 : 0.50,
        confidenceState: defaultState,
        totalObservedFacts: 0,
        groundedFacts: 0,
        ungroundedClaims: 0,
        hasVoiceEvidence: hasVoiceEvidence,
        hasPhotoEvidence: hasPhotoEvidence,
        ungroundedClaimList: const [],
      );
    }

    int grounded = 0;
    final ungroundedList = <String>[];

    final cleanTranscript = (rawTranscript ?? '').toLowerCase();

    for (final fact in observations) {
      final factText = fact.fact.toLowerCase();
      // Fact is grounded if it appears in transcript or has linked evidence
      final isGroundedInTranscript =
          cleanTranscript.isNotEmpty && cleanTranscript.contains(factText);
      final isGroundedInEvidence = fact.evidenceLinks.isNotEmpty ||
          (hasPhotoEvidence && fact.confidence >= 0.90);

      if (isGroundedInTranscript || isGroundedInEvidence) {
        grounded++;
      } else {
        ungroundedList.add(fact.fact);
      }
    }

    final ratio = total > 0 ? grounded / total : 1.0;

    String confidenceState;
    if (ratio >= 0.90 && (hasVoiceEvidence || hasPhotoEvidence)) {
      confidenceState = 'Verified';
    } else if (ratio >= 0.70) {
      confidenceState = 'High Confidence';
    } else {
      confidenceState = 'Needs Review';
    }

    return EvidenceGroundingResult(
      score: ratio,
      confidenceState: confidenceState,
      totalObservedFacts: total,
      groundedFacts: grounded,
      ungroundedClaims: total - grounded,
      hasVoiceEvidence: hasVoiceEvidence,
      hasPhotoEvidence: hasPhotoEvidence,
      ungroundedClaimList: ungroundedList,
    );
  }
}
