import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/ai/schema_validator.dart';
import 'package:echo_mobile/features/tasks/domain/task_state_machine.dart';

void main() {
  group('SchemaValidator Tests', () {
    test('Valid Action Packet JSON passes validation', () {
      final validJson = {
        'title': 'Lab 2 Projector Power Failure',
        'summary': 'Projector is unresponsive before next class.',
        'category': 'equipment',
        'observations': [
          {'text': 'Power light unlit'}
        ],
        'inferences': [],
        'missing_information': [],
        'suggested_actions': [],
        'checklist': [],
      };

      final result = SchemaValidator.validate(validJson);
      expect(result.isValid, isTrue);
      expect(result.errorMessage, isNull);
    });

    test('Missing title fails schema validation', () {
      final invalidJson = {
        'summary': 'Projector is unresponsive before next class.',
        'category': 'equipment',
      };

      final result = SchemaValidator.validate(invalidJson);
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('title'));
    });

    test('Malformed JSON string returns descriptive error', () {
      const malformedJson = '{"title": "Broken Projector", summary: broken}';

      final result = SchemaValidator.validate(malformedJson);
      expect(result.isValid, isFalse);
      expect(result.errorMessage, contains('Malformed JSON'));
    });
  });

  group('TaskStateMachine Lifecycle Tests', () {
    test('Valid lifecycle transitions are permitted', () {
      expect(TaskStateMachine.canTransition('draft', 'processing'), isTrue);
      expect(TaskStateMachine.canTransition('processing', 'ready'), isTrue);
      expect(TaskStateMachine.canTransition('ready', 'approved'), isTrue);
      expect(TaskStateMachine.canTransition('approved', 'in_progress'), isTrue);
      expect(
          TaskStateMachine.canTransition('in_progress', 'completed'), isTrue);
      expect(TaskStateMachine.canTransition('completed', 'reopened'), isTrue);
    });

    test('Illegal state transitions are blocked with exception', () {
      expect(TaskStateMachine.canTransition('draft', 'completed'), isFalse);
      expect(TaskStateMachine.canTransition('completed', 'approved'), isFalse);

      expect(
        () => TaskStateMachine.validateTransition('draft', 'completed'),
        throwsA(isA<IllegalStateTransitionException>()),
      );
    });
  });
}
