import '../packet/domain/action_packet.dart';

class TaskSearchIndex {
  final Map<String, Set<String>> _index = {};

  void buildIndex(List<ActionPacketModel> tasks) {
    _index.clear();
    for (final task in tasks) {
      final tokens = _tokenize(
          '${task.title} ${task.summary} ${task.category} ${task.id}');
      for (final token in tokens) {
        _index.putIfAbsent(token, () => {}).add(task.id);
      }
    }
  }

  Set<String> _tokenize(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), ' ')
        .split(RegExp(r'\s+'))
        .where((t) => t.length >= 2)
        .toSet();
  }

  List<ActionPacketModel> search(String query, List<ActionPacketModel> tasks) {
    final cleanTokens = _tokenize(query);
    if (cleanTokens.isEmpty) return tasks;

    final matchingIds = <String>{};
    for (final token in cleanTokens) {
      final ids = _index[token];
      if (ids != null) {
        matchingIds.addAll(ids);
      }
    }

    return tasks.where((t) => matchingIds.contains(t.id)).toList();
  }

  int get indexedTokenCount => _index.length;
}
