/// Custom exceptions for printing_engine package

/// Thrown when SelectPerPrint mode is used without registering a selection callback
class PrinterSelectionRequiredException implements Exception {
  final String message;

  PrinterSelectionRequiredException(this.message);

  @override
  String toString() => 'PrinterSelectionRequiredException: $message';
}
