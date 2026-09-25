enum TimelineStage {
  captured,
  grounded,
  policyChecked,
  exported,
  completed,
}

class TaskTimelineStepModel {
  final TimelineStage stage;
  final String label;
  final String description;
  final bool isCompleted;
  final DateTime? completedAt;

  const TaskTimelineStepModel({
    required this.stage,
    required this.label,
    required this.description,
    required this.isCompleted,
    this.completedAt,
  });

  TaskTimelineStepModel copyWith({
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return TaskTimelineStepModel(
      stage: stage,
      label: label,
      description: description,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'stage': stage.name,
        'label': label,
        'description': description,
        'isCompleted': isCompleted,
        'completedAt': completedAt?.toIso8601String(),
      };
}
