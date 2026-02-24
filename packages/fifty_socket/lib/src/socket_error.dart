/// **SocketErrorType**
///
/// Categorizes different types of errors that can occur during WebSocket operations.
///
// ────────────────────────────────────────────────
enum SocketErrorType {
  connection,      // Failed to connect
  authentication,  // Auth token invalid/expired
  channel,         // Channel join/leave failed
  message,         // Message parsing/handling failed
  timeout,         // Operation timeout
  unknown          // Uncategorized error
}

/// **SocketError**
///
/// Represents a WebSocket error with categorization and metadata.
///
/// **Key Features:**
/// - Error type categorization for granular handling
/// - Original error preservation for debugging
/// - Timestamp for error tracking
///
/// **Usage Example:**
/// ```dart
/// socketService.errorStream.listen((error) {
///   if (error.type == SocketErrorType.authentication) {
///     // Token expired, refresh and reconnect
///     refreshToken().then((_) => socketService.connect());
///   }
/// });
/// ```
///
// ────────────────────────────────────────────────
class SocketError {
  final SocketErrorType type;
  final String message;
  final dynamic originalError;
  final DateTime timestamp;

  SocketError({
    required this.type,
    required this.message,
    this.originalError,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  @override
  String toString() => '[$type] $message at ${timestamp.toIso8601String()}';
}
