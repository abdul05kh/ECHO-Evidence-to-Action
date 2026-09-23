library policy_engine;

/// Deterministic Policy Engine & Task State Machine for ECHO
///
/// Principle: The AI model may recommend urgency signals, but a deterministic
/// policy rule engine determines the final operational priority.
/// This prevents LLM hallucination and builds trust for operators and supervisors.

class TaskStateMachine {
  static const Map<String, List<String>> _validTransitions = {
    'draft': ['ready', 'needs_review'],
    'ready': ['approved', 'needs_review', 'rejected'],
    'needs_review': ['ready', 'approved', 'rejected'],
    'approved': ['in_progress', 'blocked'],
    'in_progress': ['completed', 'blocked'],
    'blocked': ['in_progress', 'approved'],
    'completed': ['reopened', 'in_progress'],
    'reopened': ['in_progress', 'approved'],
    'rejected': ['draft', 'needs_review'],
  };

  static bool canTransition(String currentStatus, String targetStatus) {
    if (currentStatus == targetStatus) return true;
    final allowed = _validTransitions[currentStatus] ?? [];
    return allowed.contains(targetStatus);
  }
}

class PolicyEngine {
  static PriorityEvaluation evaluate({
    String? rawVoiceText,
    String? textNotes,
    required String category,
    required List<String> observations,
    required String? modelSuggestedUrgency,
  }) {
    final combinedText = [
      rawVoiceText ?? '',
      textNotes ?? '',
      ...observations,
    ].join(' ').toLowerCase();

    // Critical Priority Rules: Safety hazards, active flooding, electrical fire risk
    final criticalKeywords = [
      'fire',
      'smoke',
      'spark',
      'sparking',
      'electric shock',
      'hazard',
      'gas leak',
      'structural damage',
      'emergency',
      'flooding',
      'exposed wire'
    ];
    for (final kw in criticalKeywords) {
      if (combinedText.contains(kw)) {
        return const PriorityEvaluation(
          priority: 'critical',
          reason: 'Direct safety hazard or environmental risk detected',
          ruleCode: 'RULE_SAFETY_CRITICAL',
          confidence: 1.0,
        );
      }
    }

    // High Priority Rules: Imminent operational disruption (<60 min deadline, classroom/lab in use)
    final highKeywords = [
      'starts in',
      'starting in',
      'class in',
      'exam',
      'presentation',
      'lab 2',
      'lab 1',
      'lecture hall',
      '20 minutes',
      '15 minutes',
      '30 minutes',
      'not powering on',
      'no power',
      'urgent',
      'blocked'
    ];
    for (final kw in highKeywords) {
      if (combinedText.contains(kw)) {
        return const PriorityEvaluation(
          priority: 'high',
          reason:
              'Upcoming operational deadline or scheduled academic session impacted',
          ruleCode: 'RULE_TIMING_DISRUPTION_HIGH',
          confidence: 0.95,
        );
      }
    }

    // Medium Priority Rules: Non-blocking equipment failure with alternatives or non-immediate deadline
    final mediumKeywords = [
      'spare cable',
      'alternative',
      'flickering',
      'low toner',
      'slow',
      'chair broken',
      'door handle',
      'projector'
    ];
    for (final kw in mediumKeywords) {
      if (combinedText.contains(kw)) {
        return const PriorityEvaluation(
          priority: 'medium',
          reason:
              'Equipment requires service before next major cycle; partial workaround may exist',
          ruleCode: 'RULE_STANDARD_MAINTENANCE_MED',
          confidence: 0.85,
        );
      }
    }

    // Default to Low Priority for routine observations
    return const PriorityEvaluation(
      priority: 'low',
      reason:
          'Routine observation; no immediate deadline or safety risk detected',
      ruleCode: 'RULE_ROUTINE_LOW',
      confidence: 0.80,
    );
  }

  static String describeRule(String ruleCode) {
    switch (ruleCode) {
      case 'RULE_SAFETY_CRITICAL':
        return 'Safety Critical: Immediate hazard to personnel or facility environment.';
      case 'RULE_TIMING_DISRUPTION_HIGH':
        return 'High Disruption: Academic session or operational deadline imminent.';
      case 'RULE_STANDARD_MAINTENANCE_MED':
        return 'Medium Maintenance: Equipment requires service before next operational cycle.';
      case 'RULE_ROUTINE_LOW':
      default:
        return 'Routine Observation: Non-urgent observation; routine queue placement.';
    }
  }
}

class PriorityEvaluation {
  final String priority; // 'critical', 'high', 'medium', 'low'
  final String reason;
  final String ruleCode;
  final double confidence;

  const PriorityEvaluation({
    required this.priority,
    required this.reason,
    required this.ruleCode,
    required this.confidence,
  });
}
