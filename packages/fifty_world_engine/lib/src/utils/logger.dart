import 'dart:developer' as developer;
import 'package:logging/logging.dart';

/// **Fifty World Engine Logger**
///
/// Centralized logging utility for the Fifty World Engine.
/// - Provides convenience methods for different log levels.
/// - Outputs logs via `dart:developer.log`.
///
/// **Usage:**
/// ```dart
/// FiftyWorldLogger.instance.info('Game started');
/// FiftyWorldLogger.instance.warning('Entity not found');
/// ```
class FiftyWorldLogger {
  /// Singleton instance
  static final FiftyWorldLogger instance = FiftyWorldLogger._internal();

  late final Logger _logger;

  /// Private constructor: sets up the logger and its listener.
  FiftyWorldLogger._internal() {
    _logger = Logger('Fifty World Engine');
    _logger.onRecord.listen(_handleRecord);
  }

  /// Forwards each [LogRecord] to `dart:developer.log`.
  void _handleRecord(LogRecord record) {
    developer.log(
      record.message,
      name: record.loggerName,
      level: record.level.value,
      error: record.error,
      stackTrace: record.stackTrace,
    );
  }

  /// Logs a message at the INFO level.
  void info(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.info(message, error, stackTrace);
  }

  /// Logs a message at the WARNING level.
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.warning(message, error, stackTrace);
  }

  /// Logs a message at the SEVERE level.
  void severe(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }

  /// Logs a message at the FINE (debug) level.
  void fine(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.fine(message, error, stackTrace);
  }

  /// Configures the global logging level for all loggers.
  static void configure({Level level = Level.ALL}) {
    Logger.root.level = level;
  }
}
