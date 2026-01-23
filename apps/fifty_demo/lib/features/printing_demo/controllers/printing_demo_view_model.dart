/// Printing Demo ViewModel
///
/// Business logic for the printing demo feature.
/// Demonstrates printer discovery and ticket printing.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Mock printer device for demo purposes.
class MockPrinterDevice {
  /// Creates a mock printer device.
  const MockPrinterDevice({
    required this.id,
    required this.name,
    required this.type,
    required this.status,
  });

  /// Unique printer identifier.
  final String id;

  /// Display name of the printer.
  final String name;

  /// Connection type (WiFi/Bluetooth).
  final PrinterConnectionType type;

  /// Current printer status.
  final PrinterStatus status;

  /// Icon for this printer type.
  IconData get icon {
    switch (type) {
      case PrinterConnectionType.wifi:
        return Icons.wifi;
      case PrinterConnectionType.bluetooth:
        return Icons.bluetooth;
      case PrinterConnectionType.usb:
        return Icons.usb;
    }
  }
}

/// Printer connection types.
enum PrinterConnectionType {
  /// WiFi network printer.
  wifi,

  /// Bluetooth printer.
  bluetooth,

  /// USB connected printer.
  usb,
}

/// Printer status states.
enum PrinterStatus {
  /// Printer is online and ready.
  online,

  /// Printer is offline.
  offline,

  /// Printer is busy.
  busy,

  /// Printer has an error.
  error,
}

/// Print job result.
class PrintResult {
  /// Creates a print result.
  const PrintResult({
    required this.success,
    required this.message,
    this.jobId,
  });

  /// Whether the print was successful.
  final bool success;

  /// Result message.
  final String message;

  /// Job ID if successful.
  final String? jobId;
}

/// ViewModel for the printing demo feature.
///
/// Manages printer discovery and print job state.
class PrintingDemoViewModel extends GetxController {
  /// Whether discovery is in progress.
  final _isDiscovering = false.obs;
  bool get isDiscovering => _isDiscovering.value;

  /// Discovered printers.
  final _printers = <MockPrinterDevice>[].obs;
  List<MockPrinterDevice> get printers => _printers;

  /// Currently selected printer.
  final _selectedPrinter = Rxn<MockPrinterDevice>();
  MockPrinterDevice? get selectedPrinter => _selectedPrinter.value;

  /// Whether a print is in progress.
  final _isPrinting = false.obs;
  bool get isPrinting => _isPrinting.value;

  /// Last print result.
  final _lastResult = Rxn<PrintResult>();
  PrintResult? get lastResult => _lastResult.value;

  /// Sample ticket content lines.
  List<String> get sampleTicketLines => [
    '================================',
    '        FIFTY DEMO RECEIPT',
    '================================',
    '',
    'Date: ${DateTime.now().toString().substring(0, 16)}',
    '',
    'Item                     Price',
    '--------------------------------',
    'Coffee (Large)          \$4.50',
    'Croissant               \$3.25',
    'Tip                     \$1.25',
    '--------------------------------',
    'TOTAL                   \$9.00',
    '',
    '================================',
    '      Thank you for visiting!',
    '================================',
  ];

  // ---------------------------------------------------------------------------
  // Discovery
  // ---------------------------------------------------------------------------

  /// Starts printer discovery (simulated).
  Future<void> discoverPrinters() async {
    _isDiscovering.value = true;
    _printers.clear();
    update();

    // Simulate discovery delay
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    // Add mock discovered printers
    _printers.addAll([
      const MockPrinterDevice(
        id: 'printer-1',
        name: 'Office Printer (WiFi)',
        type: PrinterConnectionType.wifi,
        status: PrinterStatus.online,
      ),
      const MockPrinterDevice(
        id: 'printer-2',
        name: 'Portable BT Printer',
        type: PrinterConnectionType.bluetooth,
        status: PrinterStatus.online,
      ),
      const MockPrinterDevice(
        id: 'printer-3',
        name: 'Kitchen Printer',
        type: PrinterConnectionType.wifi,
        status: PrinterStatus.busy,
      ),
      const MockPrinterDevice(
        id: 'printer-4',
        name: 'USB Receipt Printer',
        type: PrinterConnectionType.usb,
        status: PrinterStatus.offline,
      ),
    ]);

    _isDiscovering.value = false;
    update();
  }

  /// Selects a printer for printing.
  void selectPrinter(MockPrinterDevice? printer) {
    _selectedPrinter.value = printer;
    _lastResult.value = null;
    update();
  }

  // ---------------------------------------------------------------------------
  // Printing
  // ---------------------------------------------------------------------------

  /// Prints a sample ticket (simulated).
  Future<PrintResult> printTicket() async {
    if (selectedPrinter == null) {
      const result = PrintResult(
        success: false,
        message: 'No printer selected',
      );
      _lastResult.value = result;
      update();
      return result;
    }

    if (selectedPrinter!.status != PrinterStatus.online) {
      final result = PrintResult(
        success: false,
        message: 'Printer ${selectedPrinter!.name} is not available',
      );
      _lastResult.value = result;
      update();
      return result;
    }

    _isPrinting.value = true;
    _lastResult.value = null;
    update();

    // Simulate print delay
    await Future<void>.delayed(const Duration(milliseconds: 2000));

    final jobId = 'JOB-${DateTime.now().millisecondsSinceEpoch}';
    final result = PrintResult(
      success: true,
      message: 'Print job sent to ${selectedPrinter!.name}',
      jobId: jobId,
    );

    _isPrinting.value = false;
    _lastResult.value = result;
    update();

    return result;
  }

  // ---------------------------------------------------------------------------
  // Status Helpers
  // ---------------------------------------------------------------------------

  /// Status label for discovery state.
  String get discoveryStatusLabel {
    if (isDiscovering) return 'DISCOVERING';
    if (printers.isEmpty) return 'NO PRINTERS';
    return '${printers.length} FOUND';
  }

  /// Status label for print state.
  String get printStatusLabel {
    if (isPrinting) return 'PRINTING';
    if (lastResult?.success == true) return 'SENT';
    if (lastResult?.success == false) return 'FAILED';
    return 'READY';
  }

  /// Gets color for printer status.
  Color getStatusColor(PrinterStatus status) {
    switch (status) {
      case PrinterStatus.online:
        return const Color(0xFF4A6741); // hunterGreen
      case PrinterStatus.busy:
        return const Color(0xFFF5A623); // warning
      case PrinterStatus.offline:
        return const Color(0xFF6B7280); // slateGrey
      case PrinterStatus.error:
        return const Color(0xFF722F37); // burgundy
    }
  }

  /// Gets label for printer status.
  String getStatusLabel(PrinterStatus status) {
    switch (status) {
      case PrinterStatus.online:
        return 'ONLINE';
      case PrinterStatus.busy:
        return 'BUSY';
      case PrinterStatus.offline:
        return 'OFFLINE';
      case PrinterStatus.error:
        return 'ERROR';
    }
  }
}
