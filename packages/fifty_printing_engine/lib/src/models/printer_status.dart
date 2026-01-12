/// Current status of a printer
enum PrinterStatus {
  /// Printer is disconnected
  disconnected,

  /// Printer is attempting to connect
  connecting,

  /// Printer is connected and ready
  connected,

  /// Printer is currently printing
  printing,

  /// Printer encountered an error
  error,

  /// Printer failed health check
  healthCheckFailed,
}
