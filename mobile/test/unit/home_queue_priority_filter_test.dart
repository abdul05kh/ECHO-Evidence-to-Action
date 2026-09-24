import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/home/search_filter_state.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';

void main() {
  group('HomeQueue Priority Filter Unit Tests', () {
    late List<ActionPacketModel> sampleTasks;

    setUp(() {
      final now = DateTime.parse('2026-09-25T00:00:00Z');
      sampleTasks = [
        ActionPacketModel(
          id: 'ap-1',
          title: 'Hydraulic Leak',
          category: 'equipment',
          priority: 'urgent',
          priorityReason: 'High pressure safety risk',
          status: 'pending',
          summary: 'High pressure hydraulic line leaking',
          createdAt: now,
          updatedAt: now,
        ),
        ActionPacketModel(
          id: 'ap-2',
          title: 'Power Trip',
          category: 'electrical',
          priority: 'high',
          priorityReason: 'Breaker tripped in zone 3',
          status: 'pending',
          summary: 'Main breaker tripped in zone 3',
          createdAt: now,
          updatedAt: now,
        ),
        ActionPacketModel(
          id: 'ap-3',
          title: 'Water Pipe Drip',
          category: 'plumbing',
          priority: 'low',
          priorityReason: 'Minor non-urgent leak',
          status: 'pending',
          summary: 'Minor drip under sink',
          createdAt: now,
          updatedAt: now,
        ),
      ];
    });

    test('filters tasks by priority level', () {
      const state = SearchFilterState(selectedPriority: 'urgent');
      final filtered = state.apply(sampleTasks);

      expect(filtered.length, equals(1));
      expect(filtered.first.id, equals('ap-1'));
    });

    test('filters tasks by both category and priority', () {
      const state = SearchFilterState(
        selectedCategory: 'electrical',
        selectedPriority: 'high',
      );
      final filtered = state.apply(sampleTasks);

      expect(filtered.length, equals(1));
      expect(filtered.first.id, equals('ap-2'));
    });

    test('clears priority filter', () {
      const state = SearchFilterState(selectedPriority: 'urgent');
      final updated = state.copyWith(clearPriority: true);

      expect(updated.selectedPriority, isNull);
      expect(updated.apply(sampleTasks).length, equals(3));
    });
  });
}
