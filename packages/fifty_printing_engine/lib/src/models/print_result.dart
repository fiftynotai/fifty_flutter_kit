import 'printer_result.dart';

/// Aggregated result of a print operation across multiple printers
class PrintResult {
  /// Total number of printers that attempted to print
  final int totalPrinters;

  /// Number of printers that successfully printed
  final int successCount;

  /// Number of printers that failed to print
  final int failedCount;

  /// Detailed results for each printer
  final Map<String, PrinterResult> results;

  PrintResult({
    required this.totalPrinters,
    required this.successCount,
    required this.failedCount,
    required this.results,
  });

  /// Returns true if all printers succeeded
  bool get isSuccess => failedCount == 0 && successCount > 0;

  /// Returns true if some printers succeeded and some failed
  bool get isPartialSuccess => successCount > 0 && failedCount > 0;

  /// Returns true if all printers failed
  bool get isFailure => successCount == 0;

  @override
  String toString() {
    return 'PrintResult(total: $totalPrinters, success: $successCount, '
        'failed: $failedCount)';
  }

  /// Creates a PrintResult from a list of PrinterResults
  factory PrintResult.fromResults(List<PrinterResult> printerResults) {
    final successCount = printerResults.where((r) => r.success).length;
    final failedCount = printerResults.where((r) => !r.success).length;

    return PrintResult(
      totalPrinters: printerResults.length,
      successCount: successCount,
      failedCount: failedCount,
      results: {
        for (var result in printerResults) result.printerId: result,
      },
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'totalPrinters': totalPrinters,
      'successCount': successCount,
      'failedCount': failedCount,
      'results': results.map((id, result) => MapEntry(id, result.toJson())),
    };
  }

  /// Deserialize from JSON
  factory PrintResult.fromJson(Map<String, dynamic> json) {
    return PrintResult(
      totalPrinters: json['totalPrinters'] as int,
      successCount: json['successCount'] as int,
      failedCount: json['failedCount'] as int,
      results: (json['results'] as Map<String, dynamic>).map(
        (id, resultJson) => MapEntry(id, PrinterResult.fromJson(resultJson)),
      ),
    );
  }
}
