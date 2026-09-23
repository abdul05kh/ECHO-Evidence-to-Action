import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/ai/policy_engine.dart';

void main() {
  group('TaskStateMachine Matrix Tests', () {
    test(
        'Valid state transitions: draft -> ready -> approved -> in_progress -> completed',
        () {
      expect(TaskStateMachine.canTransition('draft', 'ready'), isTrue);
      expect(TaskStateMachine.canTransition('ready', 'approved'), isTrue);
      expect(TaskStateMachine.canTransition('approved', 'in_progress'), isTrue);
      expect(
          TaskStateMachine.canTransition('in_progress', 'completed'), isTrue);
    });

    test('Invalid state transitions: draft -> completed without approval', () {
      expect(TaskStateMachine.canTransition('draft', 'completed'), isFalse);
      expect(
          TaskStateMachine.canTransition('needs_review', 'completed'), isFalse);
    });

    test('Blocked state transition allowed from in_progress', () {
      expect(TaskStateMachine.canTransition('in_progress', 'blocked'), isTrue);
      expect(TaskStateMachine.canTransition('blocked', 'in_progress'), isTrue);
    });
  });
}
