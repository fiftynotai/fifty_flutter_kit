/// Fifty Flutter Kit printing engine for multi-printer ESC/POS printing
///
/// Provides a unified API for managing multiple printers (Bluetooth, WiFi)
/// with flexible routing strategies, health monitoring, and comprehensive
/// result tracking.
///
/// ## Features
///
/// - **Multi-printer management**: Register and manage multiple printers simultaneously
/// - **Flexible routing**: Print to all, select per print, or role-based routing
/// - **Status monitoring**: Real-time printer status updates via stream
/// - **Health checks**: Periodic and manual health monitoring
/// - **Result tracking**: Per-printer success/failure details
///
/// ## Quick Start
///
/// ```dart
/// import 'package:fifty_printing_engine/fifty_printing_engine.dart';
///
/// // Register a printer
/// final printer = WiFiPrinterDevice(
///   id: 'printer-1',
///   name: 'Kitchen Printer',
///   ipAddress: '192.168.1.100',
///   port: 9100,
/// );
///
/// PrintingEngine.instance.registerPrinter(printer);
///
/// // Create a ticket
/// final ticket = PrintTicket(PaperSize.mm80);
/// ticket.text('Hello World!', styles: PosStyles(bold: true));
/// ticket.feed(2);
/// ticket.cut();
///
/// // Print
/// final result = await PrintingEngine.instance.print(ticket: ticket);
/// print(result.isSuccess ? 'Success!' : 'Failed!');
/// ```
library fifty_printing_engine;

// Core classes
export 'src/core/printing_engine.dart';
export 'src/core/print_ticket.dart';
export 'src/core/printer_device.dart';
export 'src/core/printing_strategy.dart';

// Device implementations
export 'src/devices/bluetooth_printer_device.dart';
export 'src/devices/wifi_printer_device.dart';

// Models
export 'src/models/print_result.dart';
export 'src/models/printer_result.dart';
export 'src/models/printer_status.dart';
export 'src/models/printer_status_event.dart';
export 'src/models/printer_type.dart';
export 'src/models/printer_role.dart';
export 'src/models/printing_mode.dart';
export 'src/models/discovered_printer.dart';
export 'src/models/paper_size.dart';
export 'src/models/exceptions.dart';

// Strategies (exported for advanced use cases)
export 'src/strategies/print_to_all_strategy.dart';
export 'src/strategies/role_based_routing_strategy.dart';
export 'src/strategies/select_per_print_strategy.dart';

// Re-export escpos classes that consumers will need
// Note: PaperSize is exported from src/models/paper_size.dart above, not from escpos
export 'package:escpos/escpos.dart'
    show
        PosStyles,
        PosAlign,
        PosColumn,
        PosFontType,
        PosTextSize,
        PosDrawer,
        PosCutMode,
        Barcode,
        BarcodeText,
        CapabilityProfile;
