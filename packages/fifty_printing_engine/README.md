# Fifty Printing Engine

Production-grade Flutter package for multi-printer ESC/POS printing with Bluetooth and WiFi support.

**Part of the Fifty Ecosystem** - A collection of high-quality Flutter packages for building enterprise-grade applications.

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Core Concepts](#core-concepts)
  - [PrintingEngine](#printingengine)
  - [PrinterDevice](#printerdevice)
  - [PrintTicket](#printticket)
  - [PrintingStrategy](#printingstrategy)
- [Printing Strategies](#printing-strategies)
  - [PrintToAllStrategy](#printtoallstrategy)
  - [RoleBasedRoutingStrategy](#rolebasedroutingstrategy)
  - [SelectPerPrintStrategy](#selectperprintstrategy)
- [Printer Management](#printer-management)
  - [Registering Printers](#registering-printers)
  - [Bluetooth Discovery](#bluetooth-discovery)
  - [Connecting and Disconnecting](#connecting-and-disconnecting)
  - [Health Checks](#health-checks)
  - [Status Monitoring](#status-monitoring)
- [Configuration](#configuration)
  - [Paper Sizes](#paper-sizes)
  - [Printer Roles](#printer-roles)
  - [Copy Control](#copy-control)
  - [Persistence](#persistence-exportimport)
- [Usage Examples](#usage-examples)
- [API Reference](#api-reference)
- [Platform Setup](#platform-setup)
- [Part of Fifty Ecosystem](#part-of-the-fifty-ecosystem)
- [License](#license)

---

## Features

- **Multi-printer management** - Register and manage multiple printers simultaneously
- **Flexible routing strategies** - Print to all, select per print, or role-based routing
- **Bluetooth and WiFi support** - Works with thermal printers over Bluetooth and network printers over WiFi
- **Auto-connect** - Automatically reconnects disconnected printers during print operations
- **Status monitoring** - Real-time printer status updates via stream
- **Health checks** - Periodic and manual health monitoring
- **Result tracking** - Per-printer success/failure details with error messages
- **Copy control** - Per-printer default copies with per-job override
- **Paper size conversion** - Automatic ticket regeneration for different paper widths
- **Persistence ready** - Export/import configuration for storage-agnostic persistence
- **Simple API** - Uses familiar escpos Ticket API for ticket creation

---

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_printing_engine: ^1.0.0
```

Then run:

```bash
flutter pub get
```

---

## Quick Start

```dart
import 'package:fifty_printing_engine/fifty_printing_engine.dart';
import 'package:escpos/escpos.dart';

void main() async {
  final engine = PrintingEngine.instance;
  final profile = await CapabilityProfile.load();

  // 1. Register a printer
  engine.registerPrinter(WiFiPrinterDevice(
    id: 'printer-1',
    name: 'Kitchen Printer',
    ipAddress: '192.168.1.100',
    port: 9100,
  ));

  // 2. Create a ticket
  final ticket = PrintTicket(PaperSize.mm80, profile);
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

---

## Core Concepts

### PrintingEngine

The main orchestrator class (singleton). Manages all printer operations including registration, routing, printing, and health monitoring.

```dart
final engine = PrintingEngine.instance;

// Register printers
engine.registerPrinter(myPrinter);

// Configure routing
engine.setPrintingMode(PrintingMode.roleBasedRouting);

// Print
final result = await engine.print(ticket: ticket);
```

**Key Responsibilities:**
- Printer registration and lifecycle management
- Routing strategy execution
- Bluetooth discovery and permissions
- Configuration export/import
- Health check scheduling

### PrinterDevice

Abstract base class for printer implementations. Manages connection lifecycle, status tracking, and print execution with automatic reconnection.

**Implementations:**
- `BluetoothPrinterDevice` - Bluetooth thermal printers via MAC address
- `WiFiPrinterDevice` - Network ESC/POS printers via IP address and port

```dart
// Bluetooth printer
final btPrinter = BluetoothPrinterDevice(
  id: 'bt-kitchen',
  name: 'Kitchen Printer',
  macAddress: '00:11:22:33:44:55',
  role: PrinterRole.kitchen,
  paperSize: PaperSize.mm80,
  defaultCopies: 2,
);

// WiFi printer
final wifiPrinter = WiFiPrinterDevice(
  id: 'wifi-receipt',
  name: 'Receipt Printer',
  ipAddress: '192.168.1.100',
  port: 9100,
  role: PrinterRole.receipt,
  paperSize: PaperSize.mm80,
  defaultCopies: 1,
);
```

**Properties:**
| Property | Type | Description |
|----------|------|-------------|
| `id` | String | Unique identifier |
| `name` | String | Human-readable name |
| `type` | PrinterType | bluetooth or wifi |
| `role` | PrinterRole? | kitchen, receipt, or both |
| `status` | PrinterStatus | Current connection status |
| `paperSize` | PaperSize | mm58 or mm80 |
| `defaultCopies` | int | Default copies per print job |
| `metadata` | Map? | App-specific settings |

### PrintTicket

Wrapper around `escpos.Ticket` that adds paper size tracking for automatic conversion. Use standard escpos API methods.

```dart
final profile = await CapabilityProfile.load();
final ticket = PrintTicket(PaperSize.mm80, profile);

ticket.text('ORDER #123', styles: PosStyles(
  bold: true,
  height: PosTextSize.size2,
  align: PosAlign.center,
));
ticket.hr();
ticket.row([
  PosColumn(text: 'Item', width: 8),
  PosColumn(text: 'Qty', width: 4),
]);
ticket.row([
  PosColumn(text: 'Burger', width: 8),
  PosColumn(text: 'x2', width: 4),
]);
ticket.feed(2);
ticket.cut();
```

**Available Methods (from escpos):**
- `text()` - Print text with styles
- `row()` - Print columnar data
- `hr()` - Horizontal rule
- `feed()` - Line feeds
- `cut()` - Cut paper
- `qrcode()` - QR codes
- `barcode()` - Barcodes
- `image()` - Images

### PrintingStrategy

Abstract base class for routing strategies. Determines which printers receive a print job and aggregates results.

Built-in strategies:
- `PrintToAllStrategy` - Print to all registered printers
- `RoleBasedRoutingStrategy` - Route by printer role
- `SelectPerPrintStrategy` - User selects printers per job

---

## Printing Strategies

### PrintToAllStrategy

Sends print jobs to all registered printers. Ignores role hints.

```dart
engine.setPrintingMode(PrintingMode.printToAll);

// Prints to ALL registered printers
await engine.print(ticket: ticket);
```

**Use Case:** Small setups where every printer should receive every ticket.

### RoleBasedRoutingStrategy

Routes print jobs based on printer roles. Printers with `PrinterRole.both` receive all role-targeted jobs.

```dart
engine.setPrintingMode(PrintingMode.roleBasedRouting);

// Route to kitchen printers only
await engine.print(
  ticket: kitchenTicket,
  targetRole: PrinterRole.kitchen,
);

// Route to receipt printers only
await engine.print(
  ticket: receiptTicket,
  targetRole: PrinterRole.receipt,
);
```

**Use Case:** Restaurant/retail with dedicated kitchen and receipt printers.

### SelectPerPrintStrategy

Prompts user to select printers for each print job via callback. Requires registering a selection callback.

```dart
engine.setPrintingMode(PrintingMode.selectPerPrint);

// Register selection callback (shows UI dialog)
engine.setPrinterSelectionCallback((printers, suggestedRole) async {
  // Show your selection dialog
  final selected = await showPrinterSelectionDialog(
    printers: printers,
    preselectedRole: suggestedRole,
  );
  return selected?.map((p) => p.id).toList();
});

// Print - callback is invoked for user selection
await engine.print(
  ticket: ticket,
  targetRole: PrinterRole.kitchen, // Hint for dialog pre-selection
);
```

**Use Case:** Flexible setups where operators choose destination per job.

---

## Printer Management

### Registering Printers

```dart
// Register Bluetooth printer
engine.registerPrinter(BluetoothPrinterDevice(
  id: 'bt-1',
  name: 'Kitchen Bluetooth',
  macAddress: '00:11:22:33:44:55',
  role: PrinterRole.kitchen,
  defaultCopies: 2,
));

// Register WiFi printer
engine.registerPrinter(WiFiPrinterDevice(
  id: 'wifi-1',
  name: 'Receipt WiFi',
  ipAddress: '192.168.1.100',
  port: 9100,
  role: PrinterRole.receipt,
));

// Get all printers
final printers = engine.getAvailablePrinters();

// Get printers by status
final connected = engine.getAvailablePrinters(
  filterByStatus: PrinterStatus.connected,
);

// Get printers by role
final kitchenPrinters = engine.getPrintersByRole(PrinterRole.kitchen);

// Remove printer
engine.removePrinter('bt-1');

// Clear all printers
engine.clear();
```

### Bluetooth Discovery

```dart
try {
  // Scan for Bluetooth printers (handles permissions automatically)
  final discovered = await engine.scanBluetoothPrinters(
    filterPrintersOnly: true, // Filter to printer-like devices
  );

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
  // Permission error - direct user to settings
  if (e.toString().contains('permission') || e.toString().contains('Settings')) {
    await engine.openBluetoothSettings();
  }
  print('Error: $e');
}
```

**Permission Handling:**
- **Android 12+:** Requires Bluetooth and Nearby Devices permissions. Package checks but cannot request (Android limitation). Throws helpful error directing to App Settings.
- **iOS:** Permission dialog shown automatically when scanning. Uses `NSBluetoothAlwaysUsageDescription` from Info.plist.

### Connecting and Disconnecting

Printers auto-connect when printing. Manual control available:

```dart
// Manual connect
final success = await printer.connect();

// Manual disconnect
await printer.disconnect();

// Check status
if (printer.status == PrinterStatus.connected) {
  print('Printer is ready');
}
```

**Printer Status Values:**
| Status | Description |
|--------|-------------|
| `disconnected` | Not connected |
| `connecting` | Connection in progress |
| `connected` | Ready to print |
| `printing` | Print job in progress |
| `error` | Connection or print error |
| `healthCheckFailed` | Health check failed |

### Health Checks

```dart
// Enable periodic health checks (every 5 minutes)
engine.enableHealthChecks(interval: Duration(minutes: 5));

// Disable health checks
engine.disableHealthChecks();

// Manual health check for specific printer
final isHealthy = await engine.checkPrinterHealth('printer-1');

// Check all printers
final results = await engine.checkAllPrinters();
// Returns: {'printer-1': true, 'printer-2': false}
```

### Status Monitoring

```dart
// Listen to status events
engine.statusStream.listen((event) {
  print('Printer ${event.printerId}: ${event.oldStatus} -> ${event.newStatus}');

  if (event.newStatus == PrinterStatus.error) {
    showErrorNotification('Printer ${event.printerId} has an error');
  }
});
```

---

## Configuration

### Paper Sizes

```dart
// 58mm paper (compact receipts)
final printer58 = WiFiPrinterDevice(
  id: 'compact-1',
  name: 'Compact Printer',
  ipAddress: '192.168.1.101',
  paperSize: PaperSize.mm58,
);

// 80mm paper (standard receipts)
final printer80 = WiFiPrinterDevice(
  id: 'standard-1',
  name: 'Standard Printer',
  ipAddress: '192.168.1.102',
  paperSize: PaperSize.mm80,
);
```

**Automatic Paper Size Conversion:**

If ticket paper size differs from printer paper size, provide a regenerator function:

```dart
await engine.print(
  ticket: ticket, // Created for mm80
  regenerator: (paperSize) async {
    // Regenerate ticket for printer's paper size
    return generateTicket(order, paperSize);
  },
);
```

### Printer Roles

```dart
enum PrinterRole {
  kitchen,  // Kitchen order tickets
  receipt,  // Customer receipts
  both,     // Handles any print job
}
```

**Role Mapping (for role-based routing):**

```dart
engine.setRoleMapping(PrinterRole.kitchen, ['bt-1', 'bt-2']);
engine.setRoleMapping(PrinterRole.receipt, ['wifi-1']);

// Get role mapping
final kitchenIds = engine.getRoleMapping(PrinterRole.kitchen);
```

### Copy Control

```dart
// Per-printer default copies
final kitchenPrinter = BluetoothPrinterDevice(
  id: 'kitchen-1',
  name: 'Kitchen',
  macAddress: '00:11:22:33:44:55',
  defaultCopies: 2, // Kitchen always prints 2 copies
);

// Print with defaults (uses printer's defaultCopies)
await engine.print(ticket: ticket);

// Override: print 3 copies on all target printers
await engine.print(ticket: ticket, copies: 3);

// Role-based with override
await engine.print(
  ticket: ticket,
  targetRole: PrinterRole.kitchen,
  copies: 1, // Override kitchen's default of 2
);
```

### Persistence (Export/Import)

The package is in-memory only. Use export/import for persistence with your preferred storage:

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

**Exported Data:**
- All registered printers (type, name, address, role, defaultCopies, paperSize, metadata)
- Printing mode (printToAll, roleBasedRouting, selectPerPrint)
- Role mappings (which printers for which roles)

**Storage Options:** shared_preferences, get_storage, Hive, SQLite, backend API - your choice.

---

## Usage Examples

### Complete Kitchen/Receipt Setup

```dart
import 'package:fifty_printing_engine/fifty_printing_engine.dart';
import 'package:escpos/escpos.dart';

class PrintingService {
  final engine = PrintingEngine.instance;
  late CapabilityProfile profile;

  Future<void> initialize() async {
    profile = await CapabilityProfile.load();

    // Register kitchen printer (Bluetooth)
    engine.registerPrinter(BluetoothPrinterDevice(
      id: 'kitchen-1',
      name: 'Kitchen Printer',
      macAddress: '00:11:22:33:44:55',
      role: PrinterRole.kitchen,
      paperSize: PaperSize.mm80,
      defaultCopies: 2,
    ));

    // Register receipt printer (WiFi)
    engine.registerPrinter(WiFiPrinterDevice(
      id: 'receipt-1',
      name: 'Receipt Printer',
      ipAddress: '192.168.1.100',
      port: 9100,
      role: PrinterRole.receipt,
      paperSize: PaperSize.mm80,
      defaultCopies: 1,
    ));

    // Configure role-based routing
    engine.setPrintingMode(PrintingMode.roleBasedRouting);

    // Enable health monitoring
    engine.enableHealthChecks(interval: Duration(minutes: 5));

    // Monitor status
    engine.statusStream.listen((event) {
      print('${event.printerId}: ${event.newStatus}');
    });
  }

  Future<void> printKitchenOrder(Order order) async {
    final ticket = _createKitchenTicket(order);
    final result = await engine.print(
      ticket: ticket,
      targetRole: PrinterRole.kitchen,
    );

    if (!result.isSuccess) {
      _handlePrintFailure(result);
    }
  }

  Future<void> printReceipt(Order order) async {
    final ticket = _createReceiptTicket(order);
    final result = await engine.print(
      ticket: ticket,
      targetRole: PrinterRole.receipt,
    );

    if (!result.isSuccess) {
      _handlePrintFailure(result);
    }
  }

  PrintTicket _createKitchenTicket(Order order) {
    final ticket = PrintTicket(PaperSize.mm80, profile);
    ticket.text('ORDER #${order.id}', styles: PosStyles(
      bold: true,
      height: PosTextSize.size2,
      align: PosAlign.center,
    ));
    ticket.text('Table: ${order.table}');
    ticket.hr();
    for (final item in order.items) {
      ticket.row([
        PosColumn(text: item.name, width: 8),
        PosColumn(text: 'x${item.quantity}', width: 4),
      ]);
    }
    ticket.feed(2);
    ticket.cut();
    return ticket;
  }

  PrintTicket _createReceiptTicket(Order order) {
    final ticket = PrintTicket(PaperSize.mm80, profile);
    ticket.text('RECEIPT', styles: PosStyles(bold: true, align: PosAlign.center));
    ticket.text('Order #${order.id}');
    ticket.hr();
    for (final item in order.items) {
      ticket.row([
        PosColumn(text: item.name, width: 6),
        PosColumn(text: 'x${item.quantity}', width: 2),
        PosColumn(text: '\$${item.price}', width: 4),
      ]);
    }
    ticket.hr();
    ticket.text('Total: \$${order.total}', styles: PosStyles(bold: true));
    ticket.feed(2);
    ticket.cut();
    return ticket;
  }

  void _handlePrintFailure(PrintResult result) {
    result.results.forEach((id, printerResult) {
      if (!printerResult.success) {
        print('Printer $id failed: ${printerResult.errorMessage}');
      }
    });
  }
}
```

### Handling Print Results

```dart
final result = await engine.print(ticket: ticket);

if (result.isSuccess) {
  // All printers succeeded
  print('Printed to ${result.successCount} printer(s)');
} else if (result.isPartialSuccess) {
  // Some succeeded, some failed
  print('Partial: ${result.successCount}/${result.totalPrinters} succeeded');

  result.results.forEach((id, printerResult) {
    if (!printerResult.success) {
      print('$id failed: ${printerResult.errorMessage}');
      print('Duration: ${printerResult.duration}');
    }
  });
} else if (result.isFailure) {
  // All printers failed
  print('All ${result.totalPrinters} printer(s) failed');
}
```

### Auto-Connect Behavior

The package attempts ALL registered printers, regardless of connection status:

```dart
// 2 printers: WiFi (connected), Bluetooth (disconnected)
final result = await engine.print(ticket: ticket);

// Bluetooth printer auto-attempts reconnection:
// - If reconnection succeeds: prints successfully
// - If reconnection fails: shows in results with error

// result.totalPrinters = 2 (both attempted)
// result.successCount = 1 (WiFi succeeded)
// result.failedCount = 1 (Bluetooth couldn't reconnect)
```

**To exclude a printer from print jobs, unregister it:**

```dart
engine.removePrinter('printer-id'); // Now it won't be attempted
```

---

## API Reference

### PrintingEngine

| Method | Description |
|--------|-------------|
| `instance` | Singleton instance |
| `registerPrinter(device)` | Register a printer |
| `updatePrinter(id, device)` | Update printer config (preserves connection) |
| `removePrinter(id)` | Remove a printer |
| `clear()` | Remove all printers |
| `reset()` | Reset all configs to defaults |
| `getAvailablePrinters({filterByStatus})` | Get all/filtered printers |
| `getPrintersByRole(role)` | Get printers by role |
| `setPrintingMode(mode)` | Set routing mode |
| `setRoleMapping(role, ids)` | Configure role mapping |
| `getRoleMapping(role)` | Get role mapping |
| `setPrinterSelectionCallback(callback)` | Set SelectPerPrint callback |
| `print({ticket, copies, targetRole, targetPrinterIds, regenerator})` | Print a ticket |
| `scanBluetoothPrinters({filterPrintersOnly})` | Discover Bluetooth printers |
| `requestBluetoothPermissions()` | Check/request permissions |
| `isBluetoothEnabled()` | Check Bluetooth enabled |
| `hasBluetoothPermissions()` | Check permissions granted |
| `openBluetoothSettings()` | Open app settings |
| `enableHealthChecks({interval})` | Enable periodic health checks |
| `disableHealthChecks()` | Disable health checks |
| `checkPrinterHealth(id)` | Manual health check |
| `checkAllPrinters()` | Check all printers |
| `exportConfiguration()` | Export config as JSON |
| `importConfiguration(config)` | Import config from JSON |
| `dispose()` | Clean up resources |

| Property | Description |
|----------|-------------|
| `statusStream` | Stream of printer status events |
| `printingMode` | Current routing mode |
| `roleMappings` | Current role mappings |
| `selectionCallback` | Registered selection callback |

### PrintResult

| Property | Type | Description |
|----------|------|-------------|
| `totalPrinters` | int | Total printers attempted |
| `successCount` | int | Successful prints |
| `failedCount` | int | Failed prints |
| `results` | Map | Per-printer results |
| `isSuccess` | bool | All succeeded |
| `isPartialSuccess` | bool | Some succeeded |
| `isFailure` | bool | All failed |

### PrinterResult

| Property | Type | Description |
|----------|------|-------------|
| `printerId` | String | Printer ID |
| `success` | bool | Print succeeded |
| `errorMessage` | String? | Error description |
| `duration` | Duration | Time taken |

---

## Platform Setup

### Android

Add to `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.BLUETOOTH" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_SCAN" />
<uses-permission android:name="android.permission.NEARBY_WIFI_DEVICES" />
```

### iOS

Add to `ios/Runner/Info.plist`:

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>This app uses Bluetooth to connect to thermal printers.</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>This app uses Bluetooth to connect to thermal printers.</string>
```

---

## Part of the Fifty Ecosystem

This package is part of the Fifty Ecosystem:

| Package | Description |
|---------|-------------|
| **fifty_tokens** | Design tokens for consistent UI |
| **fifty_theme** | Theme system |
| **fifty_ui** | UI component library |
| **fifty_cache** | HTTP caching |
| **fifty_storage** | Secure storage |
| **fifty_utils** | Utilities and helpers |
| **fifty_connectivity** | Network monitoring |
| **fifty_audio_engine** | Audio playback |
| **fifty_speech_engine** | Text-to-speech |
| **fifty_sentences_engine** | Dynamic sentence building |
| **fifty_map_engine** | Map integration |
| **fifty_printing_engine** | Multi-printer support (this package) |

---

## Dependencies

| Package | Purpose |
|---------|---------|
| `escpos` | ESC/POS ticket generation |
| `print_bluetooth_thermal` | Bluetooth thermal printer support |
| `permission_handler` | Bluetooth permission handling |
| Dart sockets | WiFi/network printer support (built-in) |

---

## License

MIT License - see LICENSE file

---

## Contributing

Contributions welcome! Please open an issue or submit a PR at [github.com/fiftynotai/fifty_eco_system](https://github.com/fiftynotai/fifty_eco_system).
