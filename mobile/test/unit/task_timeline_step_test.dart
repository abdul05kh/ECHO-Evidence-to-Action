import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/tasks/domain/task_timeline_step.dart';

void main() {
  group('TaskTimelineStepModel Unit Tests', () {
    test('creates timeline step and updates completion state via copyWith', () {
      const step = TaskTimelineStepModel(
        stage: TimelineStage.grounded,
        label: 'Claim Grounding',
        description: 'Verify claims against captured evidence',
        isCompleted: false,
      );

      final now = DateTime.parse('2026-09-25T12:00:00Z');
      final completedStep = step.copyWith(isCompleted: true, completedAt: now);

      expect(completedStep.isCompleted, isTrue);
      expect(completedStep.completedAt, equals(now));
      expect(completedStep.label, equals('Claim Grounding'));
    });

    test('serializes TaskTimelineStepModel to JSON', () {
      final now = DateTime.parse('2026-09-25T12:00:00Z');
      final step = TaskTimelineStepModel(
        stage: TimelineStage.policyChecked,
        label: 'Policy Check',
        description: 'Sanitize prompt injection risks',
        isCompleted: true,
        completedAt: now,
      );

      final json = step.toJson();
      expect(json['stage'], equals('policyChecked'));
      expect(json['label'], equals('Policy Check'));
      expect(json['isCompleted'], isTrue);
      expect(json['completedAt'], equals('2026-09-25T12:00:00.000Z'));
    });
  });
}
