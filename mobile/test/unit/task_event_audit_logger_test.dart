import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/core/storage/task_event_audit_logger.dart';

void main() {
  group('TaskEventAuditLogger Unit Tests', () {
    late TaskEventAuditLogger logger;

    setUp(() {
      logger = TaskEventAuditLogger();
    });

    test('logs audit events and retrieves them by taskId', () {
      logger.logEvent(
        id: 'evt-1',
        taskId: 'task-101',
        type: TaskAuditEventType.created,
        actorId: 'user-001',
        metadata: {'priority': 'high'},
      );

      logger.logEvent(
        id: 'evt-2',
        taskId: 'task-102',
        type: TaskAuditEventType.claimed,
        actorId: 'user-002',
      );

      expect(logger.events.length, equals(2));

      final task101Events = logger.getEventsForTask('task-101');
      expect(task101Events.length, equals(1));
      expect(task101Events.first.type, equals(TaskAuditEventType.created));
      expect(task101Events.first.metadata['priority'], equals('high'));
    });

    test('serializes TaskAuditEvent to JSON correctly', () {
      final event = TaskAuditEvent(
        id: 'evt-3',
        taskId: 'task-103',
        type: TaskAuditEventType.completed,
        actorId: 'user-001',
        timestamp: DateTime.parse('2026-09-25T00:00:00Z'),
        metadata: {'notes': 'Done'},
      );

      final json = event.toJson();
      expect(json['id'], equals('evt-3'));
      expect(json['type'], equals('completed'));
      expect(json['actorId'], equals('user-001'));
      expect(json['metadata']['notes'], equals('Done'));
    });

    test('clears logged audit events', () {
      logger.logEvent(
        id: 'evt-4',
        taskId: 'task-104',
        type: TaskAuditEventType.synced,
        actorId: 'system',
      );

      expect(logger.events.length, equals(1));
      logger.clear();
      expect(logger.events.isEmpty, isTrue);
    });
  });
}
