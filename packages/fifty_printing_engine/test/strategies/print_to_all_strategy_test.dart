import 'package:flutter_test/flutter_test.dart';
import 'package:escpos/escpos.dart' show CapabilityProfile;
import 'package:fifty_printing_engine/src/strategies/print_to_all_strategy.dart';
import 'package:fifty_printing_engine/src/core/print_ticket.dart';
import 'package:fifty_printing_engine/src/models/paper_size.dart';
import 'package:fifty_printing_engine/src/models/printer_role.dart';

import '../helpers/mock_printer_device.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PrintToAllStrategy strategy;
  late PrintTicket ticket;

  setUpAll(() async {
    final profile = await CapabilityProfile.load();
    ticket = PrintTicket(PaperSize.mm80, profile);
  });

  setUp(() {
    strategy = PrintToAllStrategy();
  });

  group('PrintToAllStrategy', () {
    test('prints to all available printers', () async {
      final printer1 = MockPrinterDevice(id: 'p1', name: 'Printer 1');
      final printer2 = MockPrinterDevice(id: 'p2', name: 'Printer 2');
      final printer3 = MockPrinterDevice(id: 'p3', name: 'Printer 3');

      final result = await strategy.execute(
        ticket: ticket,
        availablePrinters: [printer1, printer2, printer3],
      );

      expect(result.totalPrinters, 3);
      expect(result.successCount, 3);
      expect(result.failedCount, 0);
      expect(printer1.printCallCount, 1);
      expect(printer2.printCallCount, 1);
      expect(printer3.printCallCount, 1);
    });

    test('returns empty result for empty printer list', () async {
      final result = await strategy.execute(
        ticket: ticket,
        availablePrinters: [],
      );

      expect(result.totalPrinters, 0);
      expect(result.successCount, 0);
      expect(result.failedCount, 0);
      expect(result.results, isEmpty);
    });

    test('ignores targetRole and prints to all printers', () async {
      final kitchen = MockPrinterDevice(
        id: 'k1',
        name: 'Kitchen',
        role: PrinterRole.kitchen,
      );
      final receipt = MockPrinterDevice(
        id: 'r1',
        name: 'Receipt',
        role: PrinterRole.receipt,
      );

      final result = await strategy.execute(
        ticket: ticket,
        availablePrinters: [kitchen, receipt],
        targetRole: PrinterRole.kitchen,
      );

      // Both printers printed regardless of targetRole
      expect(result.totalPrinters, 2);
      expect(result.successCount, 2);
      expect(kitchen.printCallCount, 1);
      expect(receipt.printCallCount, 1);
    });

    test('filters by targetPrinterIds when provided', () async {
      final printer1 = MockPrinterDevice(id: 'p1', name: 'Printer 1');
      final printer2 = MockPrinterDevice(id: 'p2', name: 'Printer 2');
      final printer3 = MockPrinterDevice(id: 'p3', name: 'Printer 3');

      final result = await strategy.execute(
        ticket: ticket,
        availablePrinters: [printer1, printer2, printer3],
        targetPrinterIds: ['p1', 'p3'],
      );

      expect(result.totalPrinters, 2);
      expect(result.successCount, 2);
      expect(printer1.printCallCount, 1);
      expect(printer2.printCallCount, 0);
      expect(printer3.printCallCount, 1);
    });

    test('handles empty targetPrinterIds as no filter', () async {
      final printer1 = MockPrinterDevice(id: 'p1', name: 'Printer 1');
      final printer2 = MockPrinterDevice(id: 'p2', name: 'Printer 2');

      final result = await strategy.execute(
        ticket: ticket,
        availablePrinters: [printer1, printer2],
        targetPrinterIds: [],
      );

      // Empty list means no filter applied
      expect(result.totalPrinters, 2);
      expect(result.successCount, 2);
    });

    test('reports failed printers in result', () async {
      final success = MockPrinterDevice(id: 'ok', name: 'OK Printer');
      final failure = MockPrinterDevice(
        id: 'fail',
        name: 'Failing Printer',
        shouldSucceed: false,
      );

      final result = await strategy.execute(
        ticket: ticket,
        availablePrinters: [success, failure],
      );

      expect(result.totalPrinters, 2);
      expect(result.successCount, 1);
      expect(result.failedCount, 1);
      expect(result.results['ok']!.success, true);
      expect(result.results['fail']!.success, false);
    });

    test('handles printer that throws exception', () async {
      final thrower = MockPrinterDevice(
        id: 'throw',
        name: 'Throwing Printer',
        shouldThrow: true,
        throwMessage: 'Connection lost',
      );

      final result = await strategy.execute(
        ticket: ticket,
        availablePrinters: [thrower],
      );

      expect(result.totalPrinters, 1);
      expect(result.failedCount, 1);
      expect(result.results['throw']!.success, false);
      expect(result.results['throw']!.errorMessage, isNotNull);
    });

    test('records duration for each printer result', () async {
      final printer = MockPrinterDevice(id: 'p1', name: 'Printer 1');

      final result = await strategy.execute(
        ticket: ticket,
        availablePrinters: [printer],
      );

      expect(result.results['p1']!.duration, isNotNull);
      expect(
        result.results['p1']!.duration.inMilliseconds,
        greaterThanOrEqualTo(0),
      );
    });

    test('returns empty result when IDs filter matches no printers', () async {
      final printer1 = MockPrinterDevice(id: 'p1', name: 'Printer 1');

      final result = await strategy.execute(
        ticket: ticket,
        availablePrinters: [printer1],
        targetPrinterIds: ['nonexistent'],
      );

      expect(result.totalPrinters, 0);
      expect(result.successCount, 0);
      expect(result.failedCount, 0);
      expect(printer1.printCallCount, 0);
    });
  });
}
