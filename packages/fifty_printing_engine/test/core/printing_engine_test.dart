import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_printing_engine/src/core/printing_engine.dart';
import 'package:fifty_printing_engine/src/devices/bluetooth_printer_device.dart';
import 'package:fifty_printing_engine/src/devices/wifi_printer_device.dart';
import 'package:fifty_printing_engine/src/models/printer_role.dart';
import 'package:fifty_printing_engine/src/models/printer_status.dart';
import 'package:fifty_printing_engine/src/models/printing_mode.dart';

void main() {
  group('PrintingEngine', () {
    late PrintingEngine engine;

    setUp(() {
      engine = PrintingEngine.instance;
      // Clear any existing printers
      final printers = engine.getAvailablePrinters();
      for (var printer in printers) {
        engine.removePrinter(printer.id);
      }
    });

    group('Printer Management', () {
      test('registerPrinter adds printer to available printers', () {
        expect(engine.getAvailablePrinters(), isEmpty);

        engine.registerPrinter(BluetoothPrinterDevice(
          id: 'test-1',
          name: 'Test Printer',
          macAddress: '00:11:22:33:44:55',
        ));

        expect(engine.getAvailablePrinters().length, 1);
        expect(engine.getAvailablePrinters().first.id, 'test-1');
      });

      test('removePrinter removes printer from available printers', () {
        engine.registerPrinter(BluetoothPrinterDevice(
          id: 'test-1',
          name: 'Test Printer',
          macAddress: '00:11:22:33:44:55',
        ));

        expect(engine.getAvailablePrinters().length, 1);

        engine.removePrinter('test-1');

        expect(engine.getAvailablePrinters(), isEmpty);
      });

      test('registerPrinter with same ID replaces existing printer', () {
        engine.registerPrinter(BluetoothPrinterDevice(
          id: 'test-1',
          name: 'Old Name',
          macAddress: '00:11:22:33:44:55',
        ));

        engine.registerPrinter(BluetoothPrinterDevice(
          id: 'test-1',
          name: 'New Name',
          macAddress: 'AA:BB:CC:DD:EE:FF',
        ));

        final printers = engine.getAvailablePrinters();
        expect(printers.length, 1);
        expect(printers.first.name, 'New Name');
      });

      test('getAvailablePrinters returns all printers when no filter', () {
        engine.registerPrinter(BluetoothPrinterDevice(
          id: 'bt-1',
          name: 'BT Printer',
          macAddress: '00:11:22:33:44:55',
        ));

        engine.registerPrinter(WiFiPrinterDevice(
          id: 'wifi-1',
          name: 'WiFi Printer',
          ipAddress: '192.168.1.100',
        ));

        expect(engine.getAvailablePrinters().length, 2);
      });

      test('getAvailablePrinters filters by status correctly', () {
        final btPrinter = BluetoothPrinterDevice(
          id: 'bt-1',
          name: 'BT Printer',
          macAddress: '00:11:22:33:44:55',
        );

        final wifiPrinter = WiFiPrinterDevice(
          id: 'wifi-1',
          name: 'WiFi Printer',
          ipAddress: '192.168.1.100',
        );

        engine.registerPrinter(btPrinter);
        engine.registerPrinter(wifiPrinter);

        // Manually update status for testing
        btPrinter.updateStatus(PrinterStatus.connected);

        final connectedPrinters = engine.getAvailablePrinters(
          filterByStatus: PrinterStatus.connected,
        );

        expect(connectedPrinters.length, 1);
        expect(connectedPrinters.first.id, 'bt-1');
      });
    });

    group('Role Management', () {
      test('getPrintersByRole returns printers with matching role', () {
        engine.registerPrinter(BluetoothPrinterDevice(
          id: 'kitchen-1',
          name: 'Kitchen Printer',
          macAddress: '00:11:22:33:44:55',
          role: PrinterRole.kitchen,
        ));

        engine.registerPrinter(WiFiPrinterDevice(
          id: 'receipt-1',
          name: 'Receipt Printer',
          ipAddress: '192.168.1.100',
          role: PrinterRole.receipt,
        ));

        final kitchenPrinters = engine.getPrintersByRole(PrinterRole.kitchen);

        expect(kitchenPrinters.length, 1);
        expect(kitchenPrinters.first.id, 'kitchen-1');
      });

      test('getPrintersByRole includes printers with role=both', () {
        engine.registerPrinter(BluetoothPrinterDevice(
          id: 'both-1',
          name: 'Multi-purpose Printer',
          macAddress: '00:11:22:33:44:55',
          role: PrinterRole.both,
        ));

        final kitchenPrinters = engine.getPrintersByRole(PrinterRole.kitchen);
        final receiptPrinters = engine.getPrintersByRole(PrinterRole.receipt);

        expect(kitchenPrinters.length, 1);
        expect(receiptPrinters.length, 1);
      });

      test('setRoleMapping and getRoleMapping work correctly', () {
        engine.setRoleMapping(PrinterRole.kitchen, ['printer-1', 'printer-2']);

        expect(engine.getRoleMapping(PrinterRole.kitchen), ['printer-1', 'printer-2']);
      });

      test('getPrintersByRole uses role mappings', () {
        engine.registerPrinter(BluetoothPrinterDevice(
          id: 'bt-1',
          name: 'Printer 1',
          macAddress: '00:11:22:33:44:55',
        ));

        engine.setRoleMapping(PrinterRole.kitchen, ['bt-1']);

        final kitchenPrinters = engine.getPrintersByRole(PrinterRole.kitchen);

        expect(kitchenPrinters.length, 1);
        expect(kitchenPrinters.first.id, 'bt-1');
      });
    });

    group('Printing Mode', () {
      test('setPrintingMode updates printing mode', () {
        expect(engine.printingMode, PrintingMode.printToAll); // Default

        engine.setPrintingMode(PrintingMode.roleBasedRouting);

        expect(engine.printingMode, PrintingMode.roleBasedRouting);
      });

      test('setPrintingMode accepts all PrintingMode values', () {
        for (var mode in PrintingMode.values) {
          engine.setPrintingMode(mode);
          expect(engine.printingMode, mode);
        }
      });
    });

    group('Default Copies', () {
      test('printer default copies is respected', () {
        final printer = BluetoothPrinterDevice(
          id: 'test-1',
          name: 'Test Printer',
          macAddress: '00:11:22:33:44:55',
          defaultCopies: 3,
        );

        engine.registerPrinter(printer);

        expect(printer.defaultCopies, 3);
      });

      test('default copies defaults to 1 if not specified', () {
        final printer = WiFiPrinterDevice(
          id: 'test-1',
          name: 'Test Printer',
          ipAddress: '192.168.1.100',
        );

        engine.registerPrinter(printer);

        expect(printer.defaultCopies, 1);
      });
    });

    group('Role Mappings', () {
      test('roleMappings returns unmodifiable map', () {
        engine.setRoleMapping(PrinterRole.kitchen, ['printer-1']);

        final mappings = engine.roleMappings;

        expect(mappings[PrinterRole.kitchen], ['printer-1']);

        // Should throw when trying to modify
        expect(
          () => mappings[PrinterRole.receipt] = ['printer-2'],
          throwsUnsupportedError,
        );
      });
    });
  });
}
