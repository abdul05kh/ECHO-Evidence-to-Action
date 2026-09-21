/// Enforces valid state transitions across the task lifecycle.
///
/// Lifecycle:
/// Draft -> Processing -> NeedsReview -> Ready -> Approved -> Assigned -> InProgress -> Blocked -> InProgress -> Completed -> Reopened -> InProgress
class TaskStateMachine {
  static const Map<String, List<String>> _validTransitions = {
    'draft': ['processing', 'needs_review', 'ready'],
    'processing': ['needs_review', 'ready'],
    'needs_review': ['ready', 'approved'],
    'ready': ['approved', 'needs_review'],
    'approved': ['assigned', 'in_progress'],
    'assigned': ['in_progress', 'blocked'],
    'in_progress': ['blocked', 'completed'],
    'blocked': ['in_progress'],
    'completed': ['reopened'],
    'reopened': ['in_progress'],
  };

  static bool canTransition(String currentStatus, String targetStatus) {
    final allowed = _validTransitions[currentStatus.toLowerCase()];
    if (allowed == null) return false;
    return allowed.contains(targetStatus.toLowerCase());
  }

  static void validateTransition(String currentStatus, String targetStatus) {
    if (!canTransition(currentStatus, targetStatus)) {
      throw IllegalStateTransitionException(
        'Cannot transition task state from "$currentStatus" to "$targetStatus". Allowed: ${_validTransitions[currentStatus.toLowerCase()]}',
      );
    }
  }
}

class IllegalStateTransitionException implements Exception {
  final String message;
  IllegalStateTransitionException(this.message);

  @override
  String toString() => message;
}
