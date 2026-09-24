import 'dart:async';

/// Log levels for EchoLogger.
enum LogLevel {
  debug,
  info,
  warning,
  error,
}

extension LogLevelExtension on LogLevel {
  String get nameUpper => name.toUpperCase();

  int get priority {
    switch (this) {
      case LogLevel.debug:
        return 0;
      case LogLevel.info:
        return 1;
      case LogLevel.warning:
        return 2;
      case LogLevel.error:
        return 3;
    }
  }
}

/// Immutable record of a single log event.
class LogEntry {
  final DateTime timestamp;
  final LogLevel level;
  final String category;
  final String message;
  final Object? error;
  final StackTrace? stackTrace;

  const LogEntry({
    required this.timestamp,
    required this.level,
    required this.category,
    required this.message,
    this.error,
    this.stackTrace,
  });

  String format() {
    final timeStr = timestamp.toIso8601String().substring(11, 23);
    final errorPart = error != null ? ' | Error: $error' : '';
    return '[$timeStr] [${level.nameUpper}] [$category] $message$errorPart';
  }

  @override
  String toString() => format();
}

/// Structured diagnostic logger with ring buffer in-memory retention and listener streams.
class EchoLogger {
  static final EchoLogger instance = EchoLogger._internal();

  final int maxBufferCapacity;
  LogLevel minimumLevel;
  final List<LogEntry> _buffer = [];
  final StreamController<LogEntry> _logStreamController =
      StreamController<LogEntry>.broadcast();

  EchoLogger._internal({
    this.maxBufferCapacity = 200,
    this.minimumLevel = LogLevel.debug,
  });

  /// Factory constructor for testing custom capacity and log level thresholds.
  factory EchoLogger.custom({
    int maxBufferCapacity = 200,
    LogLevel minimumLevel = LogLevel.debug,
  }) {
    return EchoLogger._internal(
      maxBufferCapacity: maxBufferCapacity,
      minimumLevel: minimumLevel,
    );
  }

  /// Unmodifiable view of all captured log entries.
  List<LogEntry> get logs => List.unmodifiable(_buffer);

  /// Stream of new log entries.
  Stream<LogEntry> get logStream => _logStreamController.stream;

  void log(
    LogLevel level,
    String category,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.priority < minimumLevel.priority) return;

    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      category: category.toUpperCase(),
      message: message,
      error: error,
      stackTrace: stackTrace,
    );

    if (_buffer.length >= maxBufferCapacity) {
      _buffer.removeAt(0); // Evict oldest log entry
    }
    _buffer.add(entry);
    _logStreamController.add(entry);
  }

  void debug(String category, String message) =>
      log(LogLevel.debug, category, message);

  void info(String category, String message) =>
      log(LogLevel.info, category, message);

  void warning(String category, String message, {Object? error}) =>
      log(LogLevel.warning, category, message, error: error);

  void error(String category, String message,
          {Object? error, StackTrace? stackTrace}) =>
      log(LogLevel.error, category, message,
          error: error, stackTrace: stackTrace);

  /// Filter captured logs by minimum level or category tag.
  List<LogEntry> filter({LogLevel? minLevel, String? category}) {
    return _buffer.where((entry) {
      if (minLevel != null && entry.level.priority < minLevel.priority) {
        return false;
      }
      if (category != null &&
          entry.category.toLowerCase() != category.toLowerCase()) {
        return false;
      }
      return true;
    }).toList();
  }

  /// Exports all stored logs as plain text output for diagnostics.
  String exportText() {
    return _buffer.map((e) => e.format()).join('\n');
  }

  /// Clears in-memory log buffer.
  void clear() {
    _buffer.clear();
  }

  void dispose() {
    _logStreamController.close();
  }
}
