# Fifty Printing Engine

Production-grade Flutter package for multi-printer ESC/POS printing with Bluetooth and WiFi support.

**Part of the Fifty Ecosystem** - A collection of high-quality Flutter packages for building enterprise-grade applications.

## Features

- **Multi-printer management** - Register and manage multiple printers simultaneously
- **Flexible routing strategies** - Print to all, select per print, or role-based routing
- **Bluetooth & WiFi support** - Works with thermal printers over Bluetooth and network printers over WiFi
- **Status monitoring** - Real-time printer status updates via stream
- **Health checks** - Periodic and manual health monitoring
- **Result tracking** - Per-printer success/failure details with error messages
- **Simple API** - Uses familiar escpos.Ticket API for ticket creation

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_printing_engine: ^1.0.0
```

## Quick Start

```dart
import 'package:fifty_printing_engine/fifty_printing_engine.dart';

void main() async {
  final engine = PrintingEngine.instance;

  // 1. Register a printer
  engine.registerPrinter(WiFiPrinterDevice(
    id: 'printer-1',
    name: 'Kitchen Printer',
    ipAddress: '192.168.1.100',
    port: 9100,
  ));

  // 2. Create a ticket (standard escpos API)
  final ticket = PrintTicket(PaperSize.mm80);
  ticket.text('Hello World!', styles: PosStyles(bold: true));
  ticket.feed(2);
  ticket.cut();

  // 3. Print
  final result = await engine.print(ticket: ticket);

  if (result.isSuccess) {
    print('Printed successfully!');
  } else {
    print('Print failed');
  }
}
```

## Usage Examples

### Discover Bluetooth Printers

```dart
try {
  // Scan for Bluetooth printers (handles permissions automatically)
  final discovered = await engine.scanBluetoothPrinters(filterPrintersOnly: true);

  for (final printer in discovered) {
    print('Found: ${printer.name} - ${printer.macAddress}');
  }

  // Register discovered printer
  if (discovered.isNotEmpty) {
    final device = discovered.first.toDevice(
      id: 'printer-1',
      role: PrinterRole.kitchen,
    );
    engine.registerPrinter(device);
  }
} catch (e) {
  // If permission error, direct user to settings
  if (e.toString().contains('permission') || e.toString().contains('Settings')) {
    await engine.openBluetoothSettings();
  }
  print('Error: $e');
}
```

**Note:** The package automatically checks permissions before scanning. On Android 12+, if permissions are missing, you'll get a helpful error message directing users to App Settings.

### Register Multiple Printers

```dart
// Kitchen printer - print 2 copies by default
engine.registerPrinter(BluetoothPrinterDevice(
  id: 'bt-1',
  name: 'Kitchen Bluetooth Printer',
  macAddress: '00:11:22:33:44:55',
  role: PrinterRole.kitchen,
  defaultCopies: 2,  // Kitchen always prints 2 copies
));

// Receipt printer - 1 copy (default)
engine.registerPrinter(WiFiPrinterDevice(
  id: 'wifi-1',
  name: 'Receipt WiFi Printer',
  ipAddress: '192.168.1.100',
  port: 9100,
  role: PrinterRole.receipt,
  defaultCopies: 1,
));
```

### Configure Routing Mode

```dart
// Print to all printers
engine.setPrintingMode(PrintingMode.printToAll);

// Role-based routing
engine.setPrintingMode(PrintingMode.roleBasedRouting);
engine.setRoleMapping(PrinterRole.kitchen, ['bt-1']);
engine.setRoleMapping(PrinterRole.receipt, ['wifi-1']);

// Select per print (requires targetPrinterIds in print call)
engine.setPrintingMode(PrintingMode.selectPerPrint);
```

### Create Tickets

```dart
// Kitchen ticket
final kitchenTicket = PrintTicket(PaperSize.mm80);
kitchenTicket.text('ORDER #123',
  styles: PosStyles(bold: true, height: PosTextSize.size2, align: PosAlign.center));
kitchenTicket.text('Table: 5');
kitchenTicket.hr();
kitchenTicket.row([
  PosColumn(text: 'Item', width: 8),
  PosColumn(text: 'Qty', width: 4),
]);
kitchenTicket.row([
  PosColumn(text: 'Burger', width: 8),
  PosColumn(text: 'x2', width: 4),
]);
kitchenTicket.feed(2);
kitchenTicket.cut();

// Print to kitchen printers only
await engine.print(
  ticket: kitchenTicket,
  targetRole: PrinterRole.kitchen,
);
```

### Monitor Printer Status

```dart
// Listen to status events
engine.statusStream.listen((event) {
  print('Printer ${event.printerId}: ${event.oldStatus} -> ${event.newStatus}');
});

// Enable periodic health checks
engine.enableHealthChecks(interval: Duration(minutes: 5));

// Manual health check
final isHealthy = await engine.checkPrinterHealth('printer-1');
```

### Print with Copy Control

```dart
// Use printer defaults (kitchen prints 2, receipt prints 1)
await engine.print(ticket: ticket);

// Override: print 3 copies on all target printers
await engine.print(ticket: ticket, copies: 3);

// Role-based with copies override
await engine.print(
  ticket: ticket,
  targetRole: PrinterRole.kitchen,
  copies: 1,  // Override kitchen's default of 2
);
```

### Handle Print Results

```dart
final result = await engine.print(ticket: ticket);

if (result.isSuccess) {
  print('Printed to ${result.successCount} printer(s)');
} else if (result.isPartialSuccess) {
  print('Partial success: ${result.successCount}/${result.totalPrinters}');

  // Show which printers failed
  result.results.forEach((id, printerResult) {
    if (!printerResult.success) {
      print('$id failed: ${printerResult.errorMessage}');
    }
  });
} else {
  print('All printers failed');
}
```

### Auto-Connect Behavior

**The package attempts ALL registered printers, regardless of connection status.**

When you print:
1. Each registered printer is attempted
2. If disconnected, the printer **automatically tries to reconnect**
3. If reconnection succeeds - Prints successfully
4. If reconnection fails - Shows in results with error

**Example:**
```dart
// 2 printers: WiFi (connected), Bluetooth (disconnected)
final result = await engine.print(ticket: ticket);

// Result.totalPrinters = 2 (both attempted)
// Result.successCount = 1 (WiFi succeeded)
// Result.failedCount = 1 (Bluetooth couldn't reconnect)
```

**Important:** Simply disconnecting a printer doesn't stop it from being attempted. To exclude a printer from print jobs, **unregister it**:

```dart
engine.removePrinter('printer-id');  // Now it won't be attempted
```

### Persistence (Save/Load Configuration)

The package is in-memory only. Use `exportConfiguration()` and `importConfiguration()` to persist printers across app restarts:

```dart
import 'dart:convert';

// Save configuration (on app pause/exit)
final config = engine.exportConfiguration();
await storage.save('printer_config', jsonEncode(config));

// Load configuration (on app start)
final configJson = await storage.load('printer_config');
if (configJson != null) {
  final config = jsonDecode(configJson);
  engine.importConfiguration(config);
}
```

**What's included:**
- All registered printers (type, name, address, role, defaultCopies)
- Printing mode (printToAll, roleBasedRouting, selectPerPrint)
- Role mappings (which printers for which roles)

**Storage flexibility:** Use any storage you want (shared_preferences, get_storage, backend API, SQLite, etc.)

## API Reference

### PrintingEngine

Main orchestrator class (singleton).

**Methods:**
- `scanBluetoothPrinters({bool filterPrintersOnly})` - Discover Bluetooth printers
- `requestBluetoothPermissions()` - Check Bluetooth permissions (throws if missing)
- `isBluetoothEnabled()` - Check if Bluetooth is enabled
- `hasBluetoothPermissions()` - Check if Bluetooth permissions granted
- `openBluetoothSettings()` - Open app settings (for denied permissions)
- `registerPrinter(PrinterDevice device)` - Register a printer
- `removePrinter(String printerId)` - Remove a printer
- `getAvailablePrinters({PrinterStatus? filterByStatus})` - Get all printers
- `getPrintersByRole(PrinterRole role)` - Get printers by role
- `setPrintingMode(PrintingMode mode)` - Set routing mode
- `setRoleMapping(PrinterRole role, List<String> printerIds)` - Configure role mapping
- `print({required PrintTicket ticket, int? copies, ...})` - Print a ticket with optional copy override
- `exportConfiguration()` - Export printers and settings as JSON (for saving)
- `importConfiguration(Map<String, dynamic>)` - Restore printers and settings from JSON
- `enableHealthChecks({Duration interval})` - Enable periodic health checks
- `checkPrinterHealth(String printerId)` - Manual health check

**Properties:**
- `statusStream` - Stream of printer status events

### PrintTicket

Ticket class that extends `escpos.Ticket`. Use standard escpos API.

### PrinterDevice

Abstract base class for printer implementations.

**Implementations:**
- `BluetoothPrinterDevice` - Bluetooth thermal printer
- `WiFiPrinterDevice` - Network ESC/POS printer

### PrintResult

Result of a print operation.

**Properties:**
- `totalPrinters` - Total printers attempted
- `successCount` - Number of successful prints
- `failedCount` - Number of failed prints
- `results` - Map of printer ID to `PrinterResult`
- `isSuccess` - True if all printers succeeded
- `isPartialSuccess` - True if some succeeded, some failed
- `isFailure` - True if all printers failed

## Part of the Fifty Ecosystem

This package is part of the Fifty Ecosystem, which includes:

- **fifty_tokens** - Design tokens for consistent UI
- **fifty_theme** - Theme system
- **fifty_ui** - UI component library
- **fifty_cache** - HTTP caching
- **fifty_storage** - Secure storage
- **fifty_utils** - Utilities and helpers
- **fifty_connectivity** - Network monitoring
- **fifty_printing_engine** - Multi-printer support (this package)

## Dependencies

This package relies on the following packages:

- **`escpos`** - ESC/POS ticket generation (our PrintTicket extends escpos.Ticket)
- **`print_bluetooth_thermal`** (^1.1.6) - Bluetooth thermal printer support
- **`permission_handler`** (^12.0.1) - Bluetooth permission handling (Android/iOS)
- **Dart sockets** - WiFi/network printer support (built-in, no external dependency)

## License

MIT License - see LICENSE file

## Contributing

Contributions welcome! Please open an issue or submit a PR at [github.com/fiftynotai/fifty_eco_system](https://github.com/fiftynotai/fifty_eco_system).
