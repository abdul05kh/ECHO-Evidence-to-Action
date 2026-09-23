import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/ai/policy_engine.dart';

void main() {
  group('Deterministic PolicyEngine Tests', () {
    test('Safety critical keywords trigger CRITICAL priority', () {
      final result = PolicyEngine.evaluate(
        rawVoiceText:
            'There is an electric spark and smoke near the projector mount.',
        textNotes: null,
        category: 'equipment',
        observations: ['Smoke observed near ceiling mount'],
        modelSuggestedUrgency: 'high',
      );

      expect(result.priority, 'critical');
      expect(result.ruleCode, 'RULE_SAFETY_CRITICAL');
      expect(result.reason, contains('safety hazard'));
    });

    test('Upcoming class deadline keywords trigger HIGH priority', () {
      final result = PolicyEngine.evaluate(
        rawVoiceText:
            'Lab 2 projector is not powering on. The next class starts in about 20 minutes.',
        textNotes: null,
        category: 'equipment',
        observations: ['Power LED unlit', 'Class starts in 20 min'],
        modelSuggestedUrgency: 'high',
      );

      expect(result.priority, 'high');
      expect(result.ruleCode, 'RULE_TIMING_DISRUPTION_HIGH');
      expect(result.reason, contains('Upcoming operational deadline'));
    });

    test(
        'Spare equipment keywords trigger MEDIUM priority when no deadline present',
        () {
      final result = PolicyEngine.evaluate(
        rawVoiceText:
            'Projector flickering occasionally. We have a spare cable in the equipment room.',
        textNotes: null,
        category: 'equipment',
        observations: ['Flickering display'],
        modelSuggestedUrgency: 'low',
      );

      expect(result.priority, 'medium');
      expect(result.ruleCode, 'RULE_STANDARD_MAINTENANCE_MED');
    });

    test('Routine observations default to LOW priority', () {
      final result = PolicyEngine.evaluate(
        rawVoiceText: 'Checked lab inventory; all items present.',
        textNotes: null,
        category: 'facility',
        observations: ['Routine check completed'],
        modelSuggestedUrgency: 'low',
      );

      expect(result.priority, 'low');
      expect(result.ruleCode, 'RULE_ROUTINE_LOW');
    });
  });
}
