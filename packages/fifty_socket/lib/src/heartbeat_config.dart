/// **HeartbeatConfig**
///
/// Configuration for Phoenix ping/pong heartbeat monitoring.
///
/// **Key Features:**
/// - Configurable Phoenix ping interval
/// - Configurable timeout threshold (defaults to 2x ping interval)
/// - Configurable watchdog check frequency
/// - Automatic silent disconnect detection
///
/// **Usage Example:**
/// ```dart
/// // Default: 30s ping, 60s timeout, check every 15s
/// const config = HeartbeatConfig();
///
/// // Fast detection: 15s ping, 30s timeout, check every 10s
/// const fast = HeartbeatConfig(
///   pingIntervalSeconds: 15,
///   timeoutSeconds: 30,
///   watchdogCheckIntervalSeconds: 10,
/// );
///
/// // Custom timeout only (ping interval 30s, timeout 90s)
/// const custom = HeartbeatConfig(timeoutSeconds: 90);
/// ```
///
/// **How It Works:**
/// - Phoenix sends ping every `pingIntervalSeconds`
/// - Watchdog checks connection health every `watchdogCheckIntervalSeconds`
/// - If no ping received for `timeoutSeconds`, triggers reconnection
/// - Timeout defaults to 2x ping interval for one missed ping tolerance
///
// ────────────────────────────────────────────────
class HeartbeatConfig {
  final int pingIntervalSeconds;
  final int timeoutSeconds;
  final int watchdogCheckIntervalSeconds;

  const HeartbeatConfig({
    this.pingIntervalSeconds = 30,
    int? timeoutSeconds,
    this.watchdogCheckIntervalSeconds = 15,
  }) : timeoutSeconds = timeoutSeconds ?? (pingIntervalSeconds * 2);

  static const defaults = HeartbeatConfig();
}
