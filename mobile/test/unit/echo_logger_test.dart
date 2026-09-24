import 'package:flutter_test/flutter_test.dart';
import 'package:echo_mobile/core/utils/echo_logger.dart';

void main() {
  group('EchoLogger & LogEntry Unit Tests', () {
    late EchoLogger logger;

    setUp(() {
      logger =
          EchoLogger.custom(maxBufferCapacity: 5, minimumLevel: LogLevel.debug);
    });

    test('LogEntry formats log message with timestamp, level, and category tag',
        () {
      final entry = LogEntry(
        timestamp: DateTime(2026, 9, 24, 14, 30, 0, 123),
        level: LogLevel.info,
        category: 'STORAGE',
        message: 'Database initialized successfully',
      );

      final formatted = entry.format();
      expect(formatted, contains('[INFO]'));
      expect(formatted, contains('[STORAGE]'));
      expect(formatted, contains('Database initialized successfully'));
    });

    test('EchoLogger logs debug, info, warning, and error events', () {
      logger.debug('AI', 'Model loading started');
      logger.info('SYNC', 'Outbox batch processing complete');
      logger.warning('STT', 'Audio level low');
      logger.error('STORAGE', 'Failed to open sqlite',
          error: 'Database locked');

      expect(logger.logs.length, 4);
      expect(logger.logs.last.error, 'Database locked');
    });

    test('EchoLogger respects minimum log level threshold', () {
      final quietLogger = EchoLogger.custom(minimumLevel: LogLevel.warning);
      quietLogger.debug('AI', 'Debug msg');
      quietLogger.info('AI', 'Info msg');
      quietLogger.warning('AI', 'Warning msg');
      quietLogger.error('AI', 'Error msg');

      expect(quietLogger.logs.length, 2);
      expect(quietLogger.logs.first.level, LogLevel.warning);
      expect(quietLogger.logs.last.level, LogLevel.error);
    });

    test('EchoLogger enforces ring buffer max capacity eviction', () {
      for (int i = 0; i < 10; i++) {
        logger.info('TEST', 'Message $i');
      }

      expect(logger.logs.length, 5);
      expect(logger.logs.first.message, 'Message 5');
      expect(logger.logs.last.message, 'Message 9');
    });

    test('EchoLogger filters logs by level and category', () {
      logger.info('AI', 'AI ready');
      logger.error('AI', 'AI timeout');
      logger.info('SYNC', 'Sync complete');

      final aiLogs = logger.filter(category: 'AI');
      expect(aiLogs.length, 2);

      final errorLogs = logger.filter(minLevel: LogLevel.error);
      expect(errorLogs.length, 1);
      expect(errorLogs.first.message, 'AI timeout');
    });

    test('EchoLogger exports text formatted report', () {
      logger.info('APP', 'App started');
      logger.info('APP', 'User authenticated');

      final export = logger.exportText();
      expect(export, contains('[APP] App started'));
      expect(export, contains('[APP] User authenticated'));
    });
  });
}
