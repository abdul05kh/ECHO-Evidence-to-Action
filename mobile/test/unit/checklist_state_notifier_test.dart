import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';
import 'package:echo_mobile/features/tasks/domain/checklist_state_notifier.dart';

void main() {
  group('ChecklistStateNotifier Unit Tests', () {
    test('calculates completion ratio and percentage correctly', () {
      final notifier = ChecklistStateNotifier([
        const ChecklistItemData(id: 'c1', text: 'Task 1', isCompleted: true),
        const ChecklistItemData(id: 'c2', text: 'Task 2', isCompleted: false),
      ]);

      expect(notifier.completedCount, 1);
      expect(notifier.totalCount, 2);
      expect(notifier.progressRatio, 0.5);
      expect(notifier.progressPercentage, '50%');
    });

    test('toggles item completion state by ID', () {
      final notifier = ChecklistStateNotifier([
        const ChecklistItemData(id: 'c1', text: 'Task 1', isCompleted: false),
      ]);

      notifier.toggleItem('c1');
      expect(notifier.items.first.isCompleted, isTrue);

      notifier.toggleItem('c1');
      expect(notifier.items.first.isCompleted, isFalse);
    });

    test('adds and removes checklist items', () {
      final notifier = ChecklistStateNotifier();
      notifier.addItem('Check main breaker');

      expect(notifier.totalCount, 1);
      expect(notifier.items.first.text, 'Check main breaker');

      final removed = notifier.removeItem(notifier.items.first.id);
      expect(removed, isTrue);
      expect(notifier.totalCount, 0);
    });
  });
}
