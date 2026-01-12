import 'printer_status.dart';

/// Event emitted when a printer's status changes
class PrinterStatusEvent {
  /// ID of the printer
  final String printerId;

  /// Previous status
  final PrinterStatus oldStatus;

  /// New status
  final PrinterStatus newStatus;

  /// Timestamp of the status change
  final DateTime timestamp;

  /// Optional message providing context for the status change
  final String? message;

  PrinterStatusEvent({
    required this.printerId,
    required this.oldStatus,
    required this.newStatus,
    required this.timestamp,
    this.message,
  });

  @override
  String toString() {
    return 'PrinterStatusEvent(printer: $printerId, '
        '$oldStatus → $newStatus, time: $timestamp'
        '${message != null ? ', message: $message' : ''})';
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      'printerId': printerId,
      'oldStatus': oldStatus.name,
      'newStatus': newStatus.name,
      'timestamp': timestamp.toIso8601String(),
      'message': message,
    };
  }

  /// Deserialize from JSON
  factory PrinterStatusEvent.fromJson(Map<String, dynamic> json) {
    return PrinterStatusEvent(
      printerId: json['printerId'] as String,
      oldStatus: PrinterStatus.values.firstWhere(
        (s) => s.name == json['oldStatus'],
      ),
      newStatus: PrinterStatus.values.firstWhere(
        (s) => s.name == json['newStatus'],
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      message: json['message'] as String?,
    );
  }
}
