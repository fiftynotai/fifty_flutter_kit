import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_printing_engine/src/devices/bluetooth_printer_device.dart';
import 'package:fifty_printing_engine/src/devices/wifi_printer_device.dart';
import 'package:fifty_printing_engine/src/models/printer_role.dart';
import 'package:fifty_printing_engine/src/models/printer_type.dart';
import 'package:fifty_printing_engine/src/models/printer_status.dart';

void main() {
  group('BluetoothPrinterDevice', () {
    test('constructor sets properties correctly', () {
      final device = BluetoothPrinterDevice(
        id: 'bt-1',
        name: 'Kitchen Printer',
        macAddress: '00:11:22:33:44:55',
        role: PrinterRole.kitchen,
        defaultCopies: 2,
      );

      expect(device.id, 'bt-1');
      expect(device.name, 'Kitchen Printer');
      expect(device.macAddress, '00:11:22:33:44:55');
      expect(device.type, PrinterType.bluetooth);
      expect(device.role, PrinterRole.kitchen);
      expect(device.defaultCopies, 2);
      expect(device.status, PrinterStatus.disconnected);
    });

    test('defaultCopies defaults to 1 when not specified', () {
      final device = BluetoothPrinterDevice(
        id: 'bt-1',
        name: 'Test Printer',
        macAddress: '00:11:22:33:44:55',
      );

      expect(device.defaultCopies, 1);
    });

    test('toJson serializes all properties', () {
      final device = BluetoothPrinterDevice(
        id: 'bt-test',
        name: 'Test Printer',
        macAddress: 'AA:BB:CC:DD:EE:FF',
        role: PrinterRole.receipt,
        defaultCopies: 3,
      );

      final json = device.toJson();

      expect(json['type'], 'bluetooth');
      expect(json['id'], 'bt-test');
      expect(json['name'], 'Test Printer');
      expect(json['macAddress'], 'AA:BB:CC:DD:EE:FF');
      expect(json['role'], 'receipt');
      expect(json['defaultCopies'], 3);
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'type': 'bluetooth',
        'id': 'bt-restored',
        'name': 'Restored Printer',
        'macAddress': 'FF:EE:DD:CC:BB:AA',
        'role': 'kitchen',
        'defaultCopies': 2,
      };

      final device = BluetoothPrinterDevice.fromJson(json);

      expect(device.id, 'bt-restored');
      expect(device.name, 'Restored Printer');
      expect(device.macAddress, 'FF:EE:DD:CC:BB:AA');
      expect(device.role, PrinterRole.kitchen);
      expect(device.defaultCopies, 2);
    });

    test('fromJson handles null role', () {
      final json = {
        'id': 'bt-1',
        'name': 'Printer',
        'macAddress': '00:11:22:33:44:55',
        'role': null,
        'defaultCopies': 1,
      };

      final device = BluetoothPrinterDevice.fromJson(json);

      expect(device.role, null);
    });

    test('fromJson defaults to 1 copy when defaultCopies missing', () {
      final json = {
        'id': 'bt-1',
        'name': 'Printer',
        'macAddress': '00:11:22:33:44:55',
      };

      final device = BluetoothPrinterDevice.fromJson(json);

      expect(device.defaultCopies, 1);
    });

    test('round-trip preserves all data', () {
      final original = BluetoothPrinterDevice(
        id: 'bt-roundtrip',
        name: 'Round Trip Test',
        macAddress: '12:34:56:78:90:AB',
        role: PrinterRole.both,
        defaultCopies: 5,
      );

      final json = original.toJson();
      final restored = BluetoothPrinterDevice.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.macAddress, original.macAddress);
      expect(restored.role, original.role);
      expect(restored.defaultCopies, original.defaultCopies);
    });
  });

  group('WiFiPrinterDevice', () {
    test('constructor sets properties correctly', () {
      final device = WiFiPrinterDevice(
        id: 'wifi-1',
        name: 'Receipt Printer',
        ipAddress: '192.168.1.100',
        port: 9100,
        role: PrinterRole.receipt,
        defaultCopies: 1,
      );

      expect(device.id, 'wifi-1');
      expect(device.name, 'Receipt Printer');
      expect(device.ipAddress, '192.168.1.100');
      expect(device.port, 9100);
      expect(device.type, PrinterType.wifi);
      expect(device.role, PrinterRole.receipt);
      expect(device.defaultCopies, 1);
    });

    test('port defaults to 9100 when not specified', () {
      final device = WiFiPrinterDevice(
        id: 'wifi-1',
        name: 'Test Printer',
        ipAddress: '10.0.0.1',
      );

      expect(device.port, 9100);
    });

    test('defaultCopies defaults to 1 when not specified', () {
      final device = WiFiPrinterDevice(
        id: 'wifi-1',
        name: 'Test Printer',
        ipAddress: '10.0.0.1',
      );

      expect(device.defaultCopies, 1);
    });

    test('toJson serializes all properties', () {
      final device = WiFiPrinterDevice(
        id: 'wifi-test',
        name: 'Test WiFi',
        ipAddress: '172.16.0.1',
        port: 8080,
        role: PrinterRole.kitchen,
        defaultCopies: 4,
      );

      final json = device.toJson();

      expect(json['type'], 'wifi');
      expect(json['id'], 'wifi-test');
      expect(json['name'], 'Test WiFi');
      expect(json['ipAddress'], '172.16.0.1');
      expect(json['port'], 8080);
      expect(json['role'], 'kitchen');
      expect(json['defaultCopies'], 4);
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'type': 'wifi',
        'id': 'wifi-restored',
        'name': 'Restored WiFi',
        'ipAddress': '10.10.10.10',
        'port': 7000,
        'role': 'receipt',
        'defaultCopies': 2,
      };

      final device = WiFiPrinterDevice.fromJson(json);

      expect(device.id, 'wifi-restored');
      expect(device.name, 'Restored WiFi');
      expect(device.ipAddress, '10.10.10.10');
      expect(device.port, 7000);
      expect(device.role, PrinterRole.receipt);
      expect(device.defaultCopies, 2);
    });

    test('fromJson defaults port to 9100 when missing', () {
      final json = {
        'id': 'wifi-1',
        'name': 'Printer',
        'ipAddress': '192.168.1.1',
      };

      final device = WiFiPrinterDevice.fromJson(json);

      expect(device.port, 9100);
    });

    test('round-trip preserves all data', () {
      final original = WiFiPrinterDevice(
        id: 'wifi-roundtrip',
        name: 'Round Trip WiFi',
        ipAddress: '192.168.100.50',
        port: 9200,
        role: PrinterRole.both,
        defaultCopies: 3,
      );

      final json = original.toJson();
      final restored = WiFiPrinterDevice.fromJson(json);

      expect(restored.id, original.id);
      expect(restored.name, original.name);
      expect(restored.ipAddress, original.ipAddress);
      expect(restored.port, original.port);
      expect(restored.role, original.role);
      expect(restored.defaultCopies, original.defaultCopies);
    });
  });
}
