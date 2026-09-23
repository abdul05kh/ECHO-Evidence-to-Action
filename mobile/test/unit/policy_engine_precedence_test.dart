import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/ai/policy_engine.dart';

void main() {
  group('PolicyEngine Precedence & Rule Description Tests', () {
    test('Emergency keyword "fire" overrides low model urgency to critical', () {
      final eval = PolicyEngine.evaluate(
        rawVoiceText: 'There is smoke and fire coming from the electrical panel!',
        category: 'ELECTRICAL',
        observations: ['Smoke observed'],
        modelSuggestedUrgency: 'low',
      );
      expect(eval.priority, equals('critical'));
      expect(eval.ruleCode, equals('RULE_SAFETY_CRITICAL'));
    });

    test('PolicyEngine.describeRule provides human-readable explanations', () {
      expect(PolicyEngine.describeRule('RULE_SAFETY_CRITICAL'), contains('Safety Critical'));
      expect(PolicyEngine.describeRule('RULE_TIMING_DISRUPTION_HIGH'), contains('High Disruption'));
      expect(PolicyEngine.describeRule('RULE_ROUTINE_LOW'), contains('Routine Observation'));
    });
  });
}
