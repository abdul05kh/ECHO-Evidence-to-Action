import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/features/home/search_filter_state.dart';

void main() {
  group('HomeQueue Refresh State Unit Tests', () {
    test(
        'preserves active search query and filter criteria during refresh cycle',
        () {
      const initialFilter = SearchFilterState(
        query: 'hydraulic',
        selectedCategory: 'equipment',
        selectedPriority: 'urgent',
      );

      final refreshedFilter = initialFilter.copyWith();

      expect(refreshedFilter.query, equals('hydraulic'));
      expect(refreshedFilter.selectedCategory, equals('equipment'));
      expect(refreshedFilter.selectedPriority, equals('urgent'));
      expect(refreshedFilter.isFiltered, isTrue);
    });
  });
}
