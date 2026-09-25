import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../features/tasks/domain/task_timeline_step.dart';

class TaskTimelineWidget extends StatelessWidget {
  final List<TaskTimelineStepModel> steps;

  const TaskTimelineWidget({
    super.key,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: steps.asMap().entries.map((entry) {
        final idx = entry.key;
        final step = entry.value;
        final isLast = idx == steps.length - 1;

        final stepColor =
            step.isCompleted ? EchoTheme.successGreen : EchoTheme.textTertiary;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color:
                          step.isCompleted ? stepColor : EchoTheme.surfaceColor,
                      shape: BoxShape.circle,
                      border: Border.all(color: stepColor, width: 2),
                    ),
                    child: Icon(
                      step.isCompleted
                          ? Icons.check_rounded
                          : Icons.circle_outlined,
                      size: 14,
                      color: step.isCompleted ? Colors.white : stepColor,
                    ),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: step.isCompleted
                            ? EchoTheme.successGreen
                            : EchoTheme.borderColor,
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        step.label,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: step.isCompleted
                              ? EchoTheme.textPrimary
                              : EchoTheme.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        step.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: EchoTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
