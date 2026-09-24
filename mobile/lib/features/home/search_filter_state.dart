import '../packet/domain/action_packet.dart';

/// Value object representing filter criteria for the Home Queue.
class SearchFilterState {
  final String query;
  final String? selectedCategory;
  final String? selectedPriority;

  const SearchFilterState({
    this.query = '',
    this.selectedCategory,
    this.selectedPriority,
  });

  bool get isFiltered =>
      query.trim().isNotEmpty ||
      selectedCategory != null ||
      selectedPriority != null;

  SearchFilterState copyWith({
    String? query,
    String? selectedCategory,
    String? selectedPriority,
    bool clearCategory = false,
    bool clearPriority = false,
  }) {
    return SearchFilterState(
      query: query ?? this.query,
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      selectedPriority:
          clearPriority ? null : (selectedPriority ?? this.selectedPriority),
    );
  }

  /// Filters a list of ActionPacketModel tasks based on query, category, and priority filters.
  List<ActionPacketModel> apply(List<ActionPacketModel> tasks) {
    final cleanQuery = query.trim().toLowerCase();

    return tasks.where((task) {
      // Category check
      if (selectedCategory != null &&
          selectedCategory!.isNotEmpty &&
          task.category.toLowerCase() != selectedCategory!.toLowerCase()) {
        return false;
      }

      // Priority check
      if (selectedPriority != null &&
          selectedPriority!.isNotEmpty &&
          task.priority.toLowerCase() != selectedPriority!.toLowerCase()) {
        return false;
      }

      // Search query check
      if (cleanQuery.isNotEmpty) {
        final titleMatch = task.title.toLowerCase().contains(cleanQuery);
        final summaryMatch = task.summary.toLowerCase().contains(cleanQuery);
        final idMatch = task.id.toLowerCase().contains(cleanQuery);
        final categoryMatch = task.category.toLowerCase().contains(cleanQuery);
        if (!titleMatch && !summaryMatch && !idMatch && !categoryMatch) {
          return false;
        }
      }

      return true;
    }).toList();
  }
}
