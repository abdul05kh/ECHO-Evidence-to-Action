import '../../packet/domain/action_packet.dart';

/// State notifier managing checklist item completion state and progress statistics.
class ChecklistStateNotifier {
  final List<ChecklistItemData> _items;

  ChecklistStateNotifier([List<ChecklistItemData>? initialItems])
      : _items = List.from(initialItems ?? []);

  /// Unmodifiable view of current checklist items.
  List<ChecklistItemData> get items => List.unmodifiable(_items);

  /// Number of completed items.
  int get completedCount => _items.where((item) => item.isCompleted).length;

  /// Total number of checklist items.
  int get totalCount => _items.length;

  /// Completion ratio from 0.0 to 1.0.
  double get progressRatio =>
      totalCount > 0 ? completedCount / totalCount : 0.0;

  /// Completion percentage string (e.g., "75%").
  String get progressPercentage => '${(progressRatio * 100).round()}%';

  /// Toggles the completion state of a item by [id].
  bool toggleItem(String id) {
    final idx = _items.indexWhere((item) => item.id == id);
    if (idx == -1) return false;

    final target = _items[idx];
    _items[idx] = target.copyWith(isCompleted: !target.isCompleted);
    return true;
  }

  /// Appends a new checklist item.
  void addItem(String text) {
    final clean = text.trim();
    if (clean.isEmpty) return;

    final newItem = ChecklistItemData(
      id: 'check_${DateTime.now().millisecondsSinceEpoch}',
      text: clean,
      isCompleted: false,
    );
    _items.add(newItem);
  }

  /// Removes an item by [id].
  bool removeItem(String id) {
    final initialLen = _items.length;
    _items.removeWhere((item) => item.id == id);
    return _items.length < initialLen;
  }
}
