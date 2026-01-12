/// Result of a print operation for a single printer
class PrinterResult {
  /// ID of the printer
  final String printerId;

  /// Whether the print operation succeeded
  final bool success;

  /// Error message if print failed
  final String? errorMessage;

  /// Duration of the print operation
  final Duration duration;

  PrinterResult({
    required this.printerId,
    required this.success,
    this.errorMessage,
    required this.duration,
  });

  @override
  String toString() {
    return 'PrinterResult(printerId: $printerId, success: $success, '
        'duration: ${duration.inMilliseconds}ms, error: $errorMessage)';
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'printerId': printerId,
      'success': success,
      'errorMessage': errorMessage,
      'durationMs': duration.inMilliseconds,
    };
  }

  /// Deserialize from JSON
  factory PrinterResult.fromJson(Map<String, dynamic> json) {
    return PrinterResult(
      printerId: json['printerId'] as String,
      success: json['success'] as bool,
      errorMessage: json['errorMessage'] as String?,
      duration: Duration(milliseconds: json['durationMs'] as int),
    );
  }
}
