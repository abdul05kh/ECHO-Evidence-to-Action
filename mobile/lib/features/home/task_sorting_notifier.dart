import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../packet/domain/action_packet.dart';

enum TaskSortOption {
  dateNewest,
  dateOldest,
  priorityHighest,
  titleAZ,
}

class TaskSortingNotifier extends StateNotifier<TaskSortOption> {
  TaskSortingNotifier() : super(TaskSortOption.dateNewest);

  void setSortOption(TaskSortOption option) {
    state = option;
  }

  List<ActionPacketModel> sort(List<ActionPacketModel> tasks) {
    final list = List<ActionPacketModel>.from(tasks);
    switch (state) {
      case TaskSortOption.dateNewest:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case TaskSortOption.dateOldest:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case TaskSortOption.priorityHighest:
        list.sort((a, b) =>
            _priorityScore(b.priority).compareTo(_priorityScore(a.priority)));
        break;
      case TaskSortOption.titleAZ:
        list.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
    }
    return list;
  }

  int _priorityScore(String priority) {
    switch (priority.toLowerCase()) {
      case 'urgent':
        return 4;
      case 'high':
        return 3;
      case 'medium':
        return 2;
      case 'low':
      default:
        return 1;
    }
  }
}

final taskSortingProvider =
    StateNotifierProvider<TaskSortingNotifier, TaskSortOption>(
        (ref) => TaskSortingNotifier());
