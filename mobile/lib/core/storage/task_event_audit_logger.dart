import 'package:flutter_riverpod/flutter_riverpod.dart';

enum TaskAuditEventType {
  created,
  claimed,
  evidenceAdded,
  statusChanged,
  completed,
  synced,
}

class TaskAuditEvent {
  final String id;
  final String taskId;
  final TaskAuditEventType type;
  final String actorId;
  final DateTime timestamp;
  final Map<String, dynamic> metadata;

  TaskAuditEvent({
    required this.id,
    required this.taskId,
    required this.type,
    required this.actorId,
    required this.timestamp,
    this.metadata = const {},
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'taskId': taskId,
        'type': type.name,
        'actorId': actorId,
        'timestamp': timestamp.toIso8601String(),
        'metadata': metadata,
      };
}

class TaskEventAuditLogger {
  final List<TaskAuditEvent> _events = [];

  List<TaskAuditEvent> get events => List.unmodifiable(_events);

  void logEvent({
    required String id,
    required String taskId,
    required TaskAuditEventType type,
    required String actorId,
    Map<String, dynamic> metadata = const {},
  }) {
    _events.add(
      TaskAuditEvent(
        id: id,
        taskId: taskId,
        type: type,
        actorId: actorId,
        timestamp: DateTime.now(),
        metadata: metadata,
      ),
    );
  }

  List<TaskAuditEvent> getEventsForTask(String taskId) {
    return _events.where((e) => e.taskId == taskId).toList();
  }

  void clear() {
    _events.clear();
  }
}

final taskEventAuditLoggerProvider = Provider((ref) => TaskEventAuditLogger());
