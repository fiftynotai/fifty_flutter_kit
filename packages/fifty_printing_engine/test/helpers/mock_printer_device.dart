import 'package:fifty_printing_engine/src/core/printer_device.dart';
import 'package:fifty_printing_engine/src/core/print_ticket.dart';
import 'package:fifty_printing_engine/src/models/printer_role.dart';
import 'package:fifty_printing_engine/src/models/printer_type.dart';
import 'package:fifty_printing_engine/src/models/printer_status.dart';
import 'package:fifty_printing_engine/src/models/paper_size.dart';

/// Mock printer device for strategy tests.
///
/// Allows controlling print results and tracking print calls
/// without real hardware dependencies.
class MockPrinterDevice extends PrinterDevice {
  /// Whether [print] should succeed
  bool shouldSucceed;

  /// Whether [print] should throw an exception
  bool shouldThrow;

  /// Exception message when [shouldThrow] is true
  final String throwMessage;

  /// Number of times [printInternal] was called
  int printCallCount = 0;

  /// The last ticket passed to [printInternal]
  PrintTicket? lastPrintedTicket;

  MockPrinterDevice({
    required super.id,
    required super.name,
    super.role,
    super.paperSize = PaperSize.mm80,
    super.defaultCopies = 1,
    this.shouldSucceed = true,
    this.shouldThrow = false,
    this.throwMessage = 'Mock print error',
  }) : super(type: PrinterType.bluetooth);

  @override
  Future<bool> connect() async {
    updateStatus(PrinterStatus.connected);
    return true;
  }

  @override
  Future<void> disconnect() async {
    updateStatus(PrinterStatus.disconnected);
  }

  @override
  Future<bool> printInternal(PrintTicket ticket) async {
    printCallCount++;
    lastPrintedTicket = ticket;

    if (shouldThrow) {
      throw Exception(throwMessage);
    }

    return shouldSucceed;
  }

  @override
  Future<bool> checkHealth() async => shouldSucceed;

  @override
  PrinterDevice copyWith({
    PrinterRole? role,
    int? defaultCopies,
    PaperSize? paperSize,
    Map<String, dynamic>? metadata,
  }) {
    return MockPrinterDevice(
      id: id,
      name: name,
      role: role ?? this.role,
      paperSize: paperSize ?? this.paperSize,
      defaultCopies: defaultCopies ?? this.defaultCopies,
      shouldSucceed: shouldSucceed,
      shouldThrow: shouldThrow,
      throwMessage: throwMessage,
    );
  }

  @override
  PrinterDevice reset() {
    return MockPrinterDevice(
      id: id,
      name: name,
      shouldSucceed: shouldSucceed,
    );
  }
}
