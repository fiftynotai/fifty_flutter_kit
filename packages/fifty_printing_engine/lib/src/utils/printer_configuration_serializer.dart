import 'package:fifty_printing_engine/src/core/printing_engine.dart';
import 'package:fifty_printing_engine/src/devices/bluetooth_printer_device.dart';
import 'package:fifty_printing_engine/src/devices/wifi_printer_device.dart';
import 'package:fifty_printing_engine/src/models/printing_mode.dart';
import 'package:fifty_printing_engine/src/models/printer_role.dart';

/// Internal utility for serializing/deserializing PrintingEngine configuration.
///
/// This class is not exported in the public API. Consumers use PrintingEngine's
/// exportConfiguration() and importConfiguration() methods instead.
class PrinterConfigurationSerializer {
  /// Export PrintingEngine configuration as JSON
  static Map<String, dynamic> export(PrintingEngine engine) {
    return {
      'printers': engine.getAvailablePrinters().map((p) {
        if (p is BluetoothPrinterDevice) {
          return p.toJson();
        } else if (p is WiFiPrinterDevice) {
          return p.toJson();
        }
        throw Exception('Unknown printer type: ${p.runtimeType}');
      }).toList(),
      'printingMode': engine.printingMode.name,
      'roleMappings': engine.roleMappings.map(
        (role, ids) => MapEntry(role.name, ids),
      ),
    };
  }

  /// Import configuration into PrintingEngine
  static void import(PrintingEngine engine, Map<String, dynamic> config) {
    // Clear existing configuration
    final currentPrinters = engine.getAvailablePrinters();
    for (var printer in currentPrinters) {
      engine.removePrinter(printer.id);
    }

    // Import printers
    final printersData = config['printers'] as List<dynamic>? ?? [];
    for (var printerJson in printersData) {
      final type = printerJson['type'] as String;

      if (type == 'bluetooth') {
        engine.registerPrinter(BluetoothPrinterDevice.fromJson(printerJson));
      } else if (type == 'wifi') {
        engine.registerPrinter(WiFiPrinterDevice.fromJson(printerJson));
      }
      // Skip unknown types
    }

    // Import printing mode
    final modeName = config['printingMode'] as String?;
    if (modeName != null) {
      final mode = PrintingMode.values.firstWhere(
        (m) => m.name == modeName,
        orElse: () => PrintingMode.printToAll,
      );
      engine.setPrintingMode(mode);
    }

    // Import role mappings
    final mappingsData = config['roleMappings'];
    if (mappingsData != null && mappingsData is Map) {
      for (var entry in mappingsData.entries) {
        final role = PrinterRole.values.firstWhere(
          (r) => r.name == entry.key,
          orElse: () => PrinterRole.kitchen,
        );
        engine.setRoleMapping(role, List<String>.from(entry.value as List));
      }
    }
  }
}
