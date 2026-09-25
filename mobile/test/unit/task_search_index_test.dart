import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/home/task_search_index.dart';
import 'package:echo_mobile/features/packet/domain/action_packet.dart';

void main() {
  group('TaskSearchIndex Unit Tests', () {
    late TaskSearchIndex searchIndex;
    late List<ActionPacketModel> sampleTasks;

    setUp(() {
      final now = DateTime.parse('2026-09-25T00:00:00Z');
      searchIndex = TaskSearchIndex();
      sampleTasks = [
        ActionPacketModel(
          id: 'ap-101',
          title: 'Generator Overheating',
          category: 'equipment',
          priority: 'high',
          priorityReason: 'Thermal limit warning',
          status: 'pending',
          summary: 'Coolant leak near main turbine',
          createdAt: now,
          updatedAt: now,
        ),
        ActionPacketModel(
          id: 'ap-102',
          title: 'Pressure Valve Leak',
          category: 'plumbing',
          priority: 'medium',
          priorityReason: 'Drip detected',
          status: 'pending',
          summary: 'Safety valve leaking in basement',
          createdAt: now,
          updatedAt: now,
        ),
      ];
      searchIndex.buildIndex(sampleTasks);
    });

    test('indexes tokens correctly', () {
      expect(searchIndex.indexedTokenCount, greaterThan(0));
    });

    test('searches tasks by matching token in inverted index', () {
      final results = searchIndex.search('turbine', sampleTasks);
      expect(results.length, equals(1));
      expect(results.first.id, equals('ap-101'));
    });

    test('returns all tasks for empty query', () {
      final results = searchIndex.search('', sampleTasks);
      expect(results.length, equals(2));
    });
  });
}
