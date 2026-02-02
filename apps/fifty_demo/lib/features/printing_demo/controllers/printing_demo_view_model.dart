/// Printing Demo ViewModel
///
/// Business logic for the printing demo feature.
/// Demonstrates real printer discovery and ticket printing using fifty_printing_engine.
library;

import 'dart:async';
import 'package:fifty_printing_engine/fifty_printing_engine.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// ViewModel for the printing demo feature.
///
/// Manages printer discovery and print job state using the real
/// [PrintingEngine] from fifty_printing_engine package.
///
/// **Note:** Engine access is lazy to avoid crashes on iOS during app startup.
/// The engine is only accessed when the user explicitly interacts with printing.
class PrintingDemoViewModel extends GetxController {
  /// The printing engine instance (lazy access to avoid startup crashes).
  PrintingEngine? _engine;
  PrintingEngine get engine {
    _engine ??= PrintingEngine.instance;
    return _engine!;
  }

  /// Subscription to printer status events.
  StreamSubscription<PrinterStatusEvent>? _statusSubscription;

  /// Whether the engine has been initialized.
  final _engineInitialized = false.obs;
  bool get engineInitialized => _engineInitialized.value;

  /// Whether discovery is in progress.
  final _isDiscovering = false.obs;
  bool get isDiscovering => _isDiscovering.value;

  /// Discovered printers (from Bluetooth scan).
  final _discoveredPrinters = <DiscoveredPrinter>[].obs;
  List<DiscoveredPrinter> get discoveredPrinters => _discoveredPrinters;

  /// Registered printers (added to engine).
  List<PrinterDevice> get registeredPrinters =>
      _engineInitialized.value ? engine.getAvailablePrinters() : [];

  /// Currently selected printer for printing.
  final _selectedPrinterId = Rxn<String>();
  String? get selectedPrinterId => _selectedPrinterId.value;

  /// Gets the selected printer device.
  PrinterDevice? get selectedPrinter {
    if (selectedPrinterId == null || !_engineInitialized.value) return null;
    return registeredPrinters.firstWhereOrNull((p) => p.id == selectedPrinterId);
  }

  /// Whether a print is in progress.
  final _isPrinting = false.obs;
  bool get isPrinting => _isPrinting.value;

  /// Last print result.
  final _lastResult = Rxn<PrintResult>();
  PrintResult? get lastResult => _lastResult.value;

  /// Error message from last operation.
  final _errorMessage = Rxn<String>();
  String? get errorMessage => _errorMessage.value;

  /// Whether Bluetooth permissions are granted.
  final _hasPermissions = false.obs;
  bool get hasPermissions => _hasPermissions.value;

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

  @override
  void onClose() {
    _statusSubscription?.cancel();
    super.onClose();
  }

  /// Initializes the printing engine (called lazily when user interacts).
  Future<void> _ensureEngineInitialized() async {
    if (_engineInitialized.value) return;

    try {
      // Access engine (triggers lazy initialization)
      final eng = engine;

      // Subscribe to status events
      _statusSubscription = eng.statusStream.listen((event) {
        update();
      });

      // Check permissions
      _hasPermissions.value = await eng.hasBluetoothPermissions();
      _engineInitialized.value = true;
    } catch (e) {
      _errorMessage.value = 'Printing engine not available: $e';
      _hasPermissions.value = false;
    }
    update();
  }

  // ---------------------------------------------------------------------------
  // Discovery
  // ---------------------------------------------------------------------------

  /// Requests Bluetooth permissions.
  Future<bool> requestPermissions() async {
    await _ensureEngineInitialized();
    _errorMessage.value = null;
    try {
      await engine.requestBluetoothPermissions();
      _hasPermissions.value = true;
      update();
      return true;
    } catch (e) {
      _errorMessage.value = e.toString();
      _hasPermissions.value = false;
      update();
      return false;
    }
  }

  /// Opens Bluetooth settings for manual permission grant.
  Future<void> openSettings() async {
    await _ensureEngineInitialized();
    await engine.openBluetoothSettings();
  }

  /// Starts Bluetooth printer discovery.
  Future<void> discoverPrinters() async {
    await _ensureEngineInitialized();

    _isDiscovering.value = true;
    _errorMessage.value = null;
    _discoveredPrinters.clear();
    update();

    try {
      // Check if Bluetooth is enabled
      final bluetoothEnabled = await engine.isBluetoothEnabled();
      if (!bluetoothEnabled) {
        _errorMessage.value = 'Bluetooth is not enabled. Please enable Bluetooth.';
        _isDiscovering.value = false;
        update();
        return;
      }

      // Scan for Bluetooth printers
      final printers = await engine.scanBluetoothPrinters(
        filterPrintersOnly: false, // Show all devices for demo
      );

      _discoveredPrinters.addAll(printers);
    } catch (e) {
      _errorMessage.value = e.toString();
    }

    _isDiscovering.value = false;
    update();
  }

  /// Registers a discovered printer with the engine.
  void registerPrinter(DiscoveredPrinter discovered) {
    final id = 'printer-${DateTime.now().millisecondsSinceEpoch}';
    final device = discovered.toDevice(
      id: id,
      role: PrinterRole.receipt,
      defaultCopies: 1,
      paperSize: PaperSize.mm80,
    );

    engine.registerPrinter(device);
    _selectedPrinterId.value = id;
    _errorMessage.value = null;
    update();
  }

  /// Removes a registered printer from the engine.
  void removePrinter(String printerId) {
    engine.removePrinter(printerId);
    if (_selectedPrinterId.value == printerId) {
      _selectedPrinterId.value = null;
    }
    update();
  }

  /// Selects a printer for printing.
  void selectPrinter(String? printerId) {
    _selectedPrinterId.value = printerId;
    _lastResult.value = null;
    _errorMessage.value = null;
    update();
  }

  /// Connects to the selected printer.
  Future<bool> connectPrinter() async {
    final printer = selectedPrinter;
    if (printer == null) return false;

    _errorMessage.value = null;
    update();

    try {
      final success = await printer.connect();
      if (!success) {
        _errorMessage.value = 'Failed to connect to ${printer.name}';
      }
      update();
      return success;
    } catch (e) {
      _errorMessage.value = 'Connection error: $e';
      update();
      return false;
    }
  }

  /// Disconnects from the selected printer.
  Future<void> disconnectPrinter() async {
    final printer = selectedPrinter;
    if (printer == null) return;

    await printer.disconnect();
    update();
  }

  // ---------------------------------------------------------------------------
  // Printing
  // ---------------------------------------------------------------------------

  /// Prints a sample ticket to the selected printer.
  Future<PrintResult?> printTicket() async {
    if (selectedPrinter == null) {
      _errorMessage.value = 'No printer selected';
      update();
      return null;
    }

    _isPrinting.value = true;
    _lastResult.value = null;
    _errorMessage.value = null;
    update();

    try {
      // Load capability profile for ESC/POS commands
      final profile = await CapabilityProfile.load();

      // Create the ticket
      final ticket = PrintTicket(PaperSize.mm80, profile);

      // Build the receipt content
      ticket.text(
        'FIFTY DEMO RECEIPT',
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      );
      ticket.feed(1);

      ticket.text(
        DateTime.now().toString().substring(0, 19),
        styles: const PosStyles(align: PosAlign.center),
      );
      ticket.feed(1);

      ticket.hr();

      // Items
      ticket.row([
        PosColumn(text: 'Coffee (Large)', width: 8),
        PosColumn(
          text: '\$4.50',
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      ticket.row([
        PosColumn(text: 'Croissant', width: 8),
        PosColumn(
          text: '\$3.25',
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
      ticket.row([
        PosColumn(text: 'Tip', width: 8),
        PosColumn(
          text: '\$1.25',
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);

      ticket.hr();

      ticket.row([
        PosColumn(
          text: 'TOTAL',
          width: 8,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: '\$9.00',
          width: 4,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]);

      ticket.feed(2);

      ticket.text(
        'Thank you for visiting!',
        styles: const PosStyles(align: PosAlign.center),
      );

      ticket.feed(2);
      ticket.cut();

      // Print using the engine
      final result = await engine.print(
        ticket: ticket,
        targetPrinterIds: [selectedPrinterId!],
      );

      _lastResult.value = result;

      if (!result.isSuccess) {
        _errorMessage.value = 'Print failed: ${result.failedCount} printer(s) failed';
      }
    } catch (e) {
      _errorMessage.value = 'Print error: $e';
    }

    _isPrinting.value = false;
    update();

    return _lastResult.value;
  }

  // ---------------------------------------------------------------------------
  // Status Helpers
  // ---------------------------------------------------------------------------

  /// Status label for discovery state.
  String get discoveryStatusLabel {
    if (isDiscovering) return 'SCANNING';
    if (discoveredPrinters.isEmpty && registeredPrinters.isEmpty) {
      return 'NO PRINTERS';
    }
    return '${registeredPrinters.length} REGISTERED';
  }

  /// Status label for print state.
  String get printStatusLabel {
    if (isPrinting) return 'PRINTING';
    if (lastResult?.isSuccess == true) return 'SENT';
    if (lastResult != null && !lastResult!.isSuccess) return 'FAILED';
    return 'READY';
  }

  /// Gets display label for printer status.
  String getStatusLabel(PrinterStatus status) {
    switch (status) {
      case PrinterStatus.connected:
        return 'CONNECTED';
      case PrinterStatus.connecting:
        return 'CONNECTING';
      case PrinterStatus.disconnected:
        return 'DISCONNECTED';
      case PrinterStatus.printing:
        return 'PRINTING';
      case PrinterStatus.error:
        return 'ERROR';
      case PrinterStatus.healthCheckFailed:
        return 'OFFLINE';
    }
  }

  /// Gets color for printer status.
  ///
  /// Accepts theme parameters for theme-aware colors.
  Color getStatusColor(
    PrinterStatus status,
    ColorScheme colorScheme,
    FiftyThemeExtension? fiftyTheme,
  ) {
    switch (status) {
      case PrinterStatus.connected:
        return fiftyTheme?.success ?? colorScheme.tertiary;
      case PrinterStatus.connecting:
      case PrinterStatus.printing:
        return colorScheme.primary;
      case PrinterStatus.disconnected:
        return colorScheme.onSurfaceVariant;
      case PrinterStatus.error:
      case PrinterStatus.healthCheckFailed:
        return fiftyTheme?.warning ?? colorScheme.error;
    }
  }

  /// Gets icon for printer type.
  IconData getPrinterTypeIcon(PrinterType type) {
    switch (type) {
      case PrinterType.bluetooth:
        return Icons.bluetooth;
      case PrinterType.wifi:
        return Icons.wifi;
      case PrinterType.usb:
        return Icons.usb;
    }
  }
}
