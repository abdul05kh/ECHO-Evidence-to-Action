import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/tasks/domain/task_assignment_state_notifier.dart';

void main() {
  group('TaskAssignmentStateNotifier Unit Tests', () {
    late TaskAssignmentStateNotifier notifier;

    setUp(() {
      notifier = TaskAssignmentStateNotifier();
    });

    test('initializes as unassigned', () {
      expect(notifier.state.status, equals(TaskAssignmentStatus.unassigned));
      expect(notifier.state.isClaimed, isFalse);
    });

    test('claims task with assignee ID', () {
      notifier.claimTask('user-101');
      expect(notifier.state.status, equals(TaskAssignmentStatus.claimed));
      expect(notifier.state.assigneeId, equals('user-101'));
      expect(notifier.state.isClaimed, isTrue);
    });

    test('transitions assignment status to inProgress', () {
      notifier.claimTask('user-101');
      notifier.updateStatus(TaskAssignmentStatus.inProgress);
      expect(notifier.state.status, equals(TaskAssignmentStatus.inProgress));
      expect(notifier.state.assigneeId, equals('user-101'));
    });

    test('unassigns task cleanly', () {
      notifier.claimTask('user-101');
      notifier.unassign();
      expect(notifier.state.status, equals(TaskAssignmentStatus.unassigned));
      expect(notifier.state.assigneeId, isNull);
    });
  });
}
