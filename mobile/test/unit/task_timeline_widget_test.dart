import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/shared/widgets/task_timeline_widget.dart';
import 'package:echo_mobile/features/tasks/domain/task_timeline_step.dart';

void main() {
  group('TaskTimelineWidget Widget Tests', () {
    testWidgets('renders all timeline steps correctly',
        (WidgetTester tester) async {
      const steps = [
        TaskTimelineStepModel(
          stage: TimelineStage.captured,
          label: 'Evidence Captured',
          description: 'Photo and voice recorded',
          isCompleted: true,
        ),
        TaskTimelineStepModel(
          stage: TimelineStage.grounded,
          label: 'Claim Grounded',
          description: 'Verified with LLM grounding engine',
          isCompleted: false,
        ),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TaskTimelineWidget(steps: steps),
          ),
        ),
      );

      expect(find.text('Evidence Captured'), findsOneWidget);
      expect(find.text('Photo and voice recorded'), findsOneWidget);
      expect(find.text('Claim Grounded'), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });
  });
}
