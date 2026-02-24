/// **ReconnectConfig**
///
/// Configuration for automatic reconnection behavior.
///
/// **Key Features:**
/// - Enable/disable auto-reconnect
/// - Configurable retry strategy
/// - Exponential backoff support
/// - Max retry limit
///
/// **Usage Example:**
/// ```dart
/// // Auto-reconnect with exponential backoff
/// const config = ReconnectConfig(
///   enabled: true,
///   baseRetrySeconds: 5,
///   maxRetries: 10,
///   exponentialBackoff: true,
/// );
///
/// // Disable auto-reconnect
/// const disabled = ReconnectConfig.disabled;
/// ```
///
// ────────────────────────────────────────────────
class ReconnectConfig {
  final bool enabled;
  final int baseRetrySeconds;
  final int maxRetries;
  final bool exponentialBackoff;
  final int maxBackoffSeconds;

  const ReconnectConfig({
    this.enabled = true,
    this.baseRetrySeconds = 5,
    this.maxRetries = 10,
    this.exponentialBackoff = true,
    this.maxBackoffSeconds = 60,
  });

  static const disabled = ReconnectConfig(enabled: false);
  static const defaults = ReconnectConfig();
}
