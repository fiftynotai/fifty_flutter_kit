/// **LogLevel**
///
/// Configures the verbosity of socket service logging.
///
// ────────────────────────────────────────────────
enum LogLevel {
  none,     // No logging
  error,    // Only errors
  info,     // Errors + important events (connect, disconnect)
  debug,    // Everything including messages
}
