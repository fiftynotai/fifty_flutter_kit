import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_printing_engine/src/models/printer_result.dart';
import 'package:fifty_printing_engine/src/models/print_result.dart';
import 'package:fifty_printing_engine/src/models/printer_status_event.dart';
import 'package:fifty_printing_engine/src/models/printer_status.dart';
import 'package:fifty_printing_engine/src/models/discovered_printer.dart';
import 'package:fifty_printing_engine/src/models/printer_role.dart';

void main() {
  group('PrinterResult', () {
    test('toJson serializes correctly', () {
      final result = PrinterResult(
        printerId: 'printer-1',
        success: true,
        errorMessage: null,
        duration: const Duration(milliseconds: 150),
      );

      final json = result.toJson();

      expect(json['printerId'], 'printer-1');
      expect(json['success'], true);
      expect(json['errorMessage'], null);
      expect(json['durationMs'], 150);
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'printerId': 'printer-2',
        'success': false,
        'errorMessage': 'Connection failed',
        'durationMs': 300,
      };

      final result = PrinterResult.fromJson(json);

      expect(result.printerId, 'printer-2');
      expect(result.success, false);
      expect(result.errorMessage, 'Connection failed');
      expect(result.duration, const Duration(milliseconds: 300));
    });

    test('round-trip preserves data', () {
      final original = PrinterResult(
        printerId: 'test',
        success: true,
        errorMessage: 'Test error',
        duration: const Duration(milliseconds: 500),
      );

      final json = original.toJson();
      final restored = PrinterResult.fromJson(json);

      expect(restored.printerId, original.printerId);
      expect(restored.success, original.success);
      expect(restored.errorMessage, original.errorMessage);
      expect(restored.duration, original.duration);
    });
  });

  group('PrintResult', () {
    test('fromResults creates correct aggregation', () {
      final printerResults = [
        PrinterResult(
          printerId: 'p1',
          success: true,
          duration: const Duration(milliseconds: 100),
        ),
        PrinterResult(
          printerId: 'p2',
          success: false,
          errorMessage: 'Error',
          duration: const Duration(milliseconds: 200),
        ),
        PrinterResult(
          printerId: 'p3',
          success: true,
          duration: const Duration(milliseconds: 150),
        ),
      ];

      final result = PrintResult.fromResults(printerResults);

      expect(result.totalPrinters, 3);
      expect(result.successCount, 2);
      expect(result.failedCount, 1);
      expect(result.results.length, 3);
    });

    test('isSuccess returns true when all succeeded', () {
      final result = PrintResult(
        totalPrinters: 2,
        successCount: 2,
        failedCount: 0,
        results: {},
      );

      expect(result.isSuccess, true);
      expect(result.isPartialSuccess, false);
      expect(result.isFailure, false);
    });

    test('isPartialSuccess returns true when some succeeded', () {
      final result = PrintResult(
        totalPrinters: 2,
        successCount: 1,
        failedCount: 1,
        results: {},
      );

      expect(result.isSuccess, false);
      expect(result.isPartialSuccess, true);
      expect(result.isFailure, false);
    });

    test('isFailure returns true when all failed', () {
      final result = PrintResult(
        totalPrinters: 2,
        successCount: 0,
        failedCount: 2,
        results: {},
      );

      expect(result.isSuccess, false);
      expect(result.isPartialSuccess, false);
      expect(result.isFailure, true);
    });

    test('toJson and fromJson round-trip preserves data', () {
      final original = PrintResult(
        totalPrinters: 2,
        successCount: 1,
        failedCount: 1,
        results: {
          'p1': PrinterResult(
            printerId: 'p1',
            success: true,
            duration: const Duration(milliseconds: 100),
          ),
          'p2': PrinterResult(
            printerId: 'p2',
            success: false,
            errorMessage: 'Failed',
            duration: const Duration(milliseconds: 200),
          ),
        },
      );

      final json = original.toJson();
      final restored = PrintResult.fromJson(json);

      expect(restored.totalPrinters, original.totalPrinters);
      expect(restored.successCount, original.successCount);
      expect(restored.failedCount, original.failedCount);
      expect(restored.results.length, original.results.length);
      expect(restored.results['p1']!.success, true);
      expect(restored.results['p2']!.success, false);
    });
  });

  group('PrinterStatusEvent', () {
    test('toJson serializes correctly', () {
      final event = PrinterStatusEvent(
        printerId: 'printer-1',
        oldStatus: PrinterStatus.disconnected,
        newStatus: PrinterStatus.connected,
        timestamp: DateTime(2024, 11, 7, 10, 30),
        message: 'Connected successfully',
      );

      final json = event.toJson();

      expect(json['printerId'], 'printer-1');
      expect(json['oldStatus'], 'disconnected');
      expect(json['newStatus'], 'connected');
      expect(json['timestamp'], '2024-11-07T10:30:00.000');
      expect(json['message'], 'Connected successfully');
    });

    test('fromJson deserializes correctly', () {
      final json = {
        'printerId': 'printer-2',
        'oldStatus': 'connecting',
        'newStatus': 'error',
        'timestamp': '2024-11-07T15:45:00.000',
        'message': 'Connection timeout',
      };

      final event = PrinterStatusEvent.fromJson(json);

      expect(event.printerId, 'printer-2');
      expect(event.oldStatus, PrinterStatus.connecting);
      expect(event.newStatus, PrinterStatus.error);
      expect(event.timestamp, DateTime(2024, 11, 7, 15, 45));
      expect(event.message, 'Connection timeout');
    });
  });

  group('DiscoveredPrinter', () {
    test('toDevice creates BluetoothPrinterDevice correctly', () {
      const discovered = DiscoveredPrinter(
        name: 'Kitchen Printer',
        macAddress: '00:11:22:33:44:55',
      );

      final device = discovered.toDevice(
        id: 'printer-1',
        role: PrinterRole.kitchen,
        defaultCopies: 2,
      );

      expect(device.id, 'printer-1');
      expect(device.name, 'Kitchen Printer');
      expect(device.macAddress, '00:11:22:33:44:55');
      expect(device.role, PrinterRole.kitchen);
      expect(device.defaultCopies, 2);
    });

    test('toDevice uses default copies of 1 if not specified', () {
      const discovered = DiscoveredPrinter(
        name: 'Test Printer',
        macAddress: 'AA:BB:CC:DD:EE:FF',
      );

      final device = discovered.toDevice(id: 'test-1');

      expect(device.defaultCopies, 1);
    });

    test('equality works correctly', () {
      const printer1 = DiscoveredPrinter(
        name: 'Printer A',
        macAddress: '00:11:22:33:44:55',
      );

      const printer2 = DiscoveredPrinter(
        name: 'Printer A',
        macAddress: '00:11:22:33:44:55',
      );

      const printer3 = DiscoveredPrinter(
        name: 'Printer B',
        macAddress: '00:11:22:33:44:55',
      );

      expect(printer1, equals(printer2));
      expect(printer1, isNot(equals(printer3)));
    });
  });
}
