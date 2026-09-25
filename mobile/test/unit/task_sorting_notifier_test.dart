import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/home/task_sorting_notifier.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';

void main() {
  group('TaskSortingNotifier Unit Tests', () {
    late TaskSortingNotifier notifier;
    late List<ActionPacketModel> sampleTasks;

    setUp(() {
      notifier = TaskSortingNotifier();
      final t1 = DateTime.parse('2026-09-25T01:00:00Z');
      final t2 = DateTime.parse('2026-09-25T02:00:00Z');

      sampleTasks = [
        ActionPacketModel(
          id: 'ap-1',
          title: 'Brake Failure',
          category: 'safety',
          priority: 'low',
          priorityReason: 'Minor squeak',
          status: 'pending',
          summary: 'Brake pads worn',
          createdAt: t1,
          updatedAt: t1,
        ),
        ActionPacketModel(
          id: 'ap-2',
          title: 'Air Leak',
          category: 'equipment',
          priority: 'urgent',
          priorityReason: 'Pressure dropping fast',
          status: 'pending',
          summary: 'Main line leak',
          createdAt: t2,
          updatedAt: t2,
        ),
      ];
    });

    test('sorts tasks by highest priority first', () {
      notifier.setSortOption(TaskSortOption.priorityHighest);
      final sorted = notifier.sort(sampleTasks);

      expect(sorted.first.id, equals('ap-2'));
      expect(sorted.first.priority, equals('urgent'));
    });

    test('sorts tasks alphabetically by title A-Z', () {
      notifier.setSortOption(TaskSortOption.titleAZ);
      final sorted = notifier.sort(sampleTasks);

      expect(sorted.first.title, equals('Air Leak'));
      expect(sorted.last.title, equals('Brake Failure'));
    });

    test('sorts tasks by newest date first', () {
      notifier.setSortOption(TaskSortOption.dateNewest);
      final sorted = notifier.sort(sampleTasks);

      expect(sorted.first.id, equals('ap-2'));
    });
  });
}
