import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_printing_engine/src/core/printing_engine.dart';
import 'package:fifty_printing_engine/src/devices/bluetooth_printer_device.dart';
import 'package:fifty_printing_engine/src/devices/wifi_printer_device.dart';
import 'package:fifty_printing_engine/src/models/printer_role.dart';
import 'package:fifty_printing_engine/src/models/printing_mode.dart';
import 'package:fifty_printing_engine/src/utils/printer_configuration_serializer.dart';

void main() {
  group('PrinterConfigurationSerializer', () {
    late PrintingEngine engine;

    setUp(() {
      engine = PrintingEngine.instance;
      // Clear any existing configuration
      final printers = engine.getAvailablePrinters();
      for (var printer in printers) {
        engine.removePrinter(printer.id);
      }
    });

    test('export returns empty configuration when no printers registered', () {
      final config = PrinterConfigurationSerializer.export(engine);

      expect(config['printers'], isEmpty);
      expect(config['printingMode'], isNotNull);
      expect(config['roleMappings'], isNotNull);
    });

    test('export includes all registered printers', () {
      // Register printers
      engine.registerPrinter(BluetoothPrinterDevice(
        id: 'bt-1',
        name: 'Kitchen Printer',
        macAddress: '00:11:22:33:44:55',
        role: PrinterRole.kitchen,
        defaultCopies: 2,
      ));

      engine.registerPrinter(WiFiPrinterDevice(
        id: 'wifi-1',
        name: 'Receipt Printer',
        ipAddress: '192.168.1.100',
        port: 9100,
        role: PrinterRole.receipt,
        defaultCopies: 1,
      ));

      final config = PrinterConfigurationSerializer.export(engine);
      final printers = config['printers'] as List;

      expect(printers.length, 2);
      expect(printers[0]['type'], 'bluetooth');
      expect(printers[0]['id'], 'bt-1');
      expect(printers[0]['macAddress'], '00:11:22:33:44:55');
      expect(printers[0]['role'], 'kitchen');
      expect(printers[0]['defaultCopies'], 2);

      expect(printers[1]['type'], 'wifi');
      expect(printers[1]['id'], 'wifi-1');
      expect(printers[1]['ipAddress'], '192.168.1.100');
      expect(printers[1]['port'], 9100);
      expect(printers[1]['role'], 'receipt');
      expect(printers[1]['defaultCopies'], 1);
    });

    test('export includes printing mode', () {
      engine.setPrintingMode(PrintingMode.roleBasedRouting);

      final config = PrinterConfigurationSerializer.export(engine);

      expect(config['printingMode'], 'roleBasedRouting');
    });

    test('export includes role mappings', () {
      engine.registerPrinter(BluetoothPrinterDevice(
        id: 'bt-1',
        name: 'Printer 1',
        macAddress: '00:11:22:33:44:55',
      ));

      engine.setRoleMapping(PrinterRole.kitchen, ['bt-1']);

      final config = PrinterConfigurationSerializer.export(engine);
      final mappings = config['roleMappings'] as Map;

      expect(mappings['kitchen'], ['bt-1']);
    });

    test('import restores Bluetooth printer correctly', () {
      final config = {
        'printers': [
          {
            'type': 'bluetooth',
            'id': 'bt-test',
            'name': 'Test Printer',
            'macAddress': 'AA:BB:CC:DD:EE:FF',
            'role': 'kitchen',
            'defaultCopies': 3,
          }
        ],
        'printingMode': 'printToAll',
        'roleMappings': {},
      };

      PrinterConfigurationSerializer.import(engine, config);

      final printers = engine.getAvailablePrinters();
      expect(printers.length, 1);

      final printer = printers.first as BluetoothPrinterDevice;
      expect(printer.id, 'bt-test');
      expect(printer.name, 'Test Printer');
      expect(printer.macAddress, 'AA:BB:CC:DD:EE:FF');
      expect(printer.role, PrinterRole.kitchen);
      expect(printer.defaultCopies, 3);
    });

    test('import restores WiFi printer correctly', () {
      final config = {
        'printers': [
          {
            'type': 'wifi',
            'id': 'wifi-test',
            'name': 'Test WiFi Printer',
            'ipAddress': '10.0.0.1',
            'port': 8080,
            'role': 'receipt',
            'defaultCopies': 1,
          }
        ],
        'printingMode': 'printToAll',
        'roleMappings': {},
      };

      PrinterConfigurationSerializer.import(engine, config);

      final printers = engine.getAvailablePrinters();
      expect(printers.length, 1);

      final printer = printers.first as WiFiPrinterDevice;
      expect(printer.id, 'wifi-test');
      expect(printer.name, 'Test WiFi Printer');
      expect(printer.ipAddress, '10.0.0.1');
      expect(printer.port, 8080);
      expect(printer.role, PrinterRole.receipt);
      expect(printer.defaultCopies, 1);
    });

    test('import restores printing mode correctly', () {
      final config = {
        'printers': [],
        'printingMode': 'roleBasedRouting',
        'roleMappings': {},
      };

      PrinterConfigurationSerializer.import(engine, config);

      expect(engine.printingMode, PrintingMode.roleBasedRouting);
    });

    test('import restores role mappings correctly', () {
      final config = {
        'printers': [],
        'printingMode': 'printToAll',
        'roleMappings': {
          'kitchen': ['bt-1', 'bt-2'],
          'receipt': ['wifi-1'],
        },
      };

      PrinterConfigurationSerializer.import(engine, config);

      expect(engine.getRoleMapping(PrinterRole.kitchen), ['bt-1', 'bt-2']);
      expect(engine.getRoleMapping(PrinterRole.receipt), ['wifi-1']);
    });

    test('import clears existing configuration before restoring', () {
      // Setup existing configuration
      engine.registerPrinter(BluetoothPrinterDevice(
        id: 'old-printer',
        name: 'Old Printer',
        macAddress: '00:00:00:00:00:00',
      ));

      expect(engine.getAvailablePrinters().length, 1);

      // Import new configuration
      final config = {
        'printers': [
          {
            'type': 'bluetooth',
            'id': 'new-printer',
            'name': 'New Printer',
            'macAddress': 'FF:FF:FF:FF:FF:FF',
            'defaultCopies': 1,
          }
        ],
        'printingMode': 'printToAll',
        'roleMappings': {},
      };

      PrinterConfigurationSerializer.import(engine, config);

      // Should only have new printer
      final printers = engine.getAvailablePrinters();
      expect(printers.length, 1);
      expect(printers.first.id, 'new-printer');
    });

    test('import handles mixed printer types correctly', () {
      final config = {
        'printers': [
          {
            'type': 'bluetooth',
            'id': 'bt-1',
            'name': 'BT Printer',
            'macAddress': '00:11:22:33:44:55',
            'defaultCopies': 1,
          },
          {
            'type': 'wifi',
            'id': 'wifi-1',
            'name': 'WiFi Printer',
            'ipAddress': '192.168.1.1',
            'port': 9100,
            'defaultCopies': 1,
          }
        ],
        'printingMode': 'printToAll',
        'roleMappings': {},
      };

      PrinterConfigurationSerializer.import(engine, config);

      final printers = engine.getAvailablePrinters();
      expect(printers.length, 2);
      expect(printers.where((p) => p is BluetoothPrinterDevice).length, 1);
      expect(printers.where((p) => p is WiFiPrinterDevice).length, 1);
    });

    test('import skips unknown printer types', () {
      final config = {
        'printers': [
          {
            'type': 'unknown_type',
            'id': 'unknown-1',
            'name': 'Unknown Printer',
          },
          {
            'type': 'bluetooth',
            'id': 'bt-1',
            'name': 'BT Printer',
            'macAddress': '00:11:22:33:44:55',
            'defaultCopies': 1,
          }
        ],
        'printingMode': 'printToAll',
        'roleMappings': {},
      };

      PrinterConfigurationSerializer.import(engine, config);

      // Should only import the valid Bluetooth printer
      final printers = engine.getAvailablePrinters();
      expect(printers.length, 1);
      expect(printers.first.id, 'bt-1');
    });

    test('export and import round-trip preserves all data', () {
      // Setup complete configuration
      engine.registerPrinter(BluetoothPrinterDevice(
        id: 'bt-1',
        name: 'Kitchen',
        macAddress: '00:11:22:33:44:55',
        role: PrinterRole.kitchen,
        defaultCopies: 2,
      ));

      engine.registerPrinter(WiFiPrinterDevice(
        id: 'wifi-1',
        name: 'Receipt',
        ipAddress: '192.168.1.100',
        port: 9100,
        role: PrinterRole.receipt,
        defaultCopies: 1,
      ));

      engine.setPrintingMode(PrintingMode.roleBasedRouting);
      engine.setRoleMapping(PrinterRole.kitchen, ['bt-1']);
      engine.setRoleMapping(PrinterRole.receipt, ['wifi-1']);

      // Export
      final exported = PrinterConfigurationSerializer.export(engine);

      // Clear and import
      final allPrinters = engine.getAvailablePrinters();
      for (var p in allPrinters) {
        engine.removePrinter(p.id);
      }

      PrinterConfigurationSerializer.import(engine, exported);

      // Verify everything restored
      final printers = engine.getAvailablePrinters();
      expect(printers.length, 2);
      expect(engine.printingMode, PrintingMode.roleBasedRouting);
      expect(engine.getRoleMapping(PrinterRole.kitchen), ['bt-1']);
      expect(engine.getRoleMapping(PrinterRole.receipt), ['wifi-1']);

      final btPrinter = printers.firstWhere((p) => p.id == 'bt-1');
      expect(btPrinter.defaultCopies, 2);

      final wifiPrinter = printers.firstWhere((p) => p.id == 'wifi-1');
      expect(wifiPrinter.defaultCopies, 1);
    });
  });
}
