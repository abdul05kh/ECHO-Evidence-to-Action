import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/home/search_filter_state.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';

void main() {
  group('SearchFilterState Unit Tests', () {
    final task1 = ActionPacketModel(
      id: 'ap_100',
      title: 'HVAC Air Handler B2 Leaking',
      category: 'equipment',
      priority: 'critical',
      priorityReason: 'Active water leak',
      summary: 'Main supply valve ruptured on 2nd floor.',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final task2 = ActionPacketModel(
      id: 'ap_101',
      title: 'Server Room Electrical Outlet',
      category: 'electrical',
      priority: 'high',
      priorityReason: 'Sparking reported',
      summary: 'Wall socket in Rack 4 loose and sparking.',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final task3 = ActionPacketModel(
      id: 'ap_102',
      title: 'Facility Door Handle Broken',
      category: 'facility',
      priority: 'low',
      priorityReason: 'Cosmetic wear',
      summary: 'Main entrance door latch sticky.',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final allTasks = [task1, task2, task3];

    test('returns all tasks when query and filters are empty', () {
      const state = SearchFilterState();
      expect(state.isFiltered, isFalse);
      expect(state.apply(allTasks), allTasks);
    });

    test('filters tasks by query text in title, summary, or ID', () {
      const stateTitle = SearchFilterState(query: 'HVAC');
      expect(stateTitle.apply(allTasks), [task1]);

      const stateSummary = SearchFilterState(query: 'sparking');
      expect(stateSummary.apply(allTasks), [task2]);

      const stateId = SearchFilterState(query: 'ap_102');
      expect(stateId.apply(allTasks), [task3]);
    });

    test('filters tasks by category', () {
      const state = SearchFilterState(selectedCategory: 'electrical');
      expect(state.isFiltered, isTrue);
      expect(state.apply(allTasks), [task2]);
    });

    test('filters tasks by priority', () {
      const state = SearchFilterState(selectedPriority: 'critical');
      expect(state.apply(allTasks), [task1]);
    });

    test('combines search query and category filter', () {
      const state =
          SearchFilterState(query: 'Handler', selectedCategory: 'equipment');
      expect(state.apply(allTasks), [task1]);

      const stateNoMatch =
          SearchFilterState(query: 'Handler', selectedCategory: 'electrical');
      expect(stateNoMatch.apply(allTasks), isEmpty);
    });

    test('copyWith allows clearing category and priority filters', () {
      const state = SearchFilterState(
          query: 'HVAC',
          selectedCategory: 'equipment',
          selectedPriority: 'critical');
      final cleared = state.copyWith(clearCategory: true, clearPriority: true);

      expect(cleared.query, 'HVAC');
      expect(cleared.selectedCategory, isNull);
      expect(cleared.selectedPriority, isNull);
    });
  });
}
