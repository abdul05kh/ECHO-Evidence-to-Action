import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TaskAssignmentStatus {
  unassigned,
  claimed,
  inProgress,
  handoffReady,
}

class TaskAssignmentState {
  final TaskAssignmentStatus status;
  final String? assigneeId;
  final DateTime? claimedAt;

  const TaskAssignmentState({
    required this.status,
    this.assigneeId,
    this.claimedAt,
  });

  bool get isClaimed => status != TaskAssignmentStatus.unassigned;

  TaskAssignmentState copyWith({
    TaskAssignmentStatus? status,
    String? assigneeId,
    DateTime? claimedAt,
  }) {
    return TaskAssignmentState(
      status: status ?? this.status,
      assigneeId: assigneeId ?? this.assigneeId,
      claimedAt: claimedAt ?? this.claimedAt,
    );
  }
}

class TaskAssignmentStateNotifier extends StateNotifier<TaskAssignmentState> {
  TaskAssignmentStateNotifier()
      : super(
            const TaskAssignmentState(status: TaskAssignmentStatus.unassigned));

  void claimTask(String userId) {
    state = TaskAssignmentState(
      status: TaskAssignmentStatus.claimed,
      assigneeId: userId,
      claimedAt: DateTime.now(),
    );
  }

  void updateStatus(TaskAssignmentStatus newStatus) {
    state = state.copyWith(status: newStatus);
  }

  void unassign() {
    state = const TaskAssignmentState(status: TaskAssignmentStatus.unassigned);
  }
}

final taskAssignmentProvider =
    StateNotifierProvider<TaskAssignmentStateNotifier, TaskAssignmentState>(
        (ref) => TaskAssignmentStateNotifier());
