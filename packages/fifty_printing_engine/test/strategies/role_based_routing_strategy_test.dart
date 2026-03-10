import 'package:flutter_test/flutter_test.dart';
import 'package:escpos/escpos.dart' show CapabilityProfile;
import 'package:fifty_printing_engine/src/strategies/role_based_routing_strategy.dart';
import 'package:fifty_printing_engine/src/core/print_ticket.dart';
import 'package:fifty_printing_engine/src/models/paper_size.dart';
import 'package:fifty_printing_engine/src/models/printer_role.dart';

import '../helpers/mock_printer_device.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RoleBasedRoutingStrategy strategy;
  late PrintTicket ticket;

  setUpAll(() async {
    final profile = await CapabilityProfile.load();
    ticket = PrintTicket(PaperSize.mm80, profile);
  });

  setUp(() {
    strategy = RoleBasedRoutingStrategy();
  });

  group('RoleBasedRoutingStrategy', () {
    test('filters printers by target role', () async {
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

      expect(result.totalPrinters, 1);
      expect(result.successCount, 1);
      expect(kitchen.printCallCount, 1);
      expect(receipt.printCallCount, 0);
    });

    test('includes printers with role=both for any target role', () async {
      final kitchen = MockPrinterDevice(
        id: 'k1',
        name: 'Kitchen Only',
        role: PrinterRole.kitchen,
      );
      final both = MockPrinterDevice(
        id: 'b1',
        name: 'Both Roles',
        role: PrinterRole.both,
      );
      final receipt = MockPrinterDevice(
        id: 'r1',
        name: 'Receipt Only',
        role: PrinterRole.receipt,
      );

      final kitchenResult = await strategy.execute(
        ticket: ticket,
        availablePrinters: [kitchen, both, receipt],
        targetRole: PrinterRole.kitchen,
      );

      // Kitchen role should match kitchen + both
      expect(kitchenResult.totalPrinters, 2);
      expect(kitchen.printCallCount, 1);
      expect(both.printCallCount, 1);
      expect(receipt.printCallCount, 0);
    });

    test('both role includes receipt-role printers when targeting receipt',
        () async {
      final receipt = MockPrinterDevice(
        id: 'r1',
        name: 'Receipt',
        role: PrinterRole.receipt,
      );
      final both = MockPrinterDevice(
        id: 'b1',
        name: 'Both',
        role: PrinterRole.both,
      );

      final result = await strategy.execute(
        ticket: ticket,
        availablePrinters: [receipt, both],
        targetRole: PrinterRole.receipt,
      );

      expect(result.totalPrinters, 2);
      expect(receipt.printCallCount, 1);
      expect(both.printCallCount, 1);
    });

    test('defaults to PrinterRole.both when no targetRole specified',
        () async {
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
      final both = MockPrinterDevice(
        id: 'b1',
        name: 'Both',
        role: PrinterRole.both,
      );

      final result = await strategy.execute(
        ticket: ticket,
        availablePrinters: [kitchen, receipt, both],
        // no targetRole specified
      );

      // When targetRole defaults to 'both', filterByRole matches only role==both
      expect(result.totalPrinters, 1);
      expect(both.printCallCount, 1);
    });

    test('further filters by targetPrinterIds after role filter', () async {
      final k1 = MockPrinterDevice(
        id: 'k1',
        name: 'Kitchen 1',
        role: PrinterRole.kitchen,
      );
      final k2 = MockPrinterDevice(
        id: 'k2',
        name: 'Kitchen 2',
        role: PrinterRole.kitchen,
      );

      final result = await strategy.execute(
        ticket: ticket,
        availablePrinters: [k1, k2],
        targetRole: PrinterRole.kitchen,
        targetPrinterIds: ['k2'],
      );

      expect(result.totalPrinters, 1);
      expect(k1.printCallCount, 0);
      expect(k2.printCallCount, 1);
    });

    test('returns empty result when no printers match role', () async {
      final receipt = MockPrinterDevice(
        id: 'r1',
        name: 'Receipt',
        role: PrinterRole.receipt,
      );

      final result = await strategy.execute(
        ticket: ticket,
        availablePrinters: [receipt],
        targetRole: PrinterRole.kitchen,
      );

      expect(result.totalPrinters, 0);
      expect(result.successCount, 0);
      expect(result.failedCount, 0);
      expect(receipt.printCallCount, 0);
    });

    test('returns empty result for empty printer list', () async {
      final result = await strategy.execute(
        ticket: ticket,
        availablePrinters: [],
        targetRole: PrinterRole.kitchen,
      );

      expect(result.totalPrinters, 0);
      expect(result.successCount, 0);
      expect(result.failedCount, 0);
    });

    test('reports mixed success/failure correctly', () async {
      final ok = MockPrinterDevice(
        id: 'k1',
        name: 'OK Kitchen',
        role: PrinterRole.kitchen,
      );
      final fail = MockPrinterDevice(
        id: 'k2',
        name: 'Fail Kitchen',
        role: PrinterRole.kitchen,
        shouldSucceed: false,
      );

      final result = await strategy.execute(
        ticket: ticket,
        availablePrinters: [ok, fail],
        targetRole: PrinterRole.kitchen,
      );

      expect(result.totalPrinters, 2);
      expect(result.successCount, 1);
      expect(result.failedCount, 1);
      expect(result.results['k1']!.success, true);
      expect(result.results['k2']!.success, false);
    });

    test('handles printer exception gracefully', () async {
      final thrower = MockPrinterDevice(
        id: 'k1',
        name: 'Throwing Kitchen',
        role: PrinterRole.kitchen,
        shouldThrow: true,
      );

      final result = await strategy.execute(
        ticket: ticket,
        availablePrinters: [thrower],
        targetRole: PrinterRole.kitchen,
      );

      expect(result.totalPrinters, 1);
      expect(result.failedCount, 1);
      expect(result.results['k1']!.success, false);
      expect(result.results['k1']!.errorMessage, isNotNull);
    });

    test('printers with null role are excluded from role-based routing',
        () async {
      final noRole = MockPrinterDevice(id: 'n1', name: 'No Role');

      final result = await strategy.execute(
        ticket: ticket,
        availablePrinters: [noRole],
        targetRole: PrinterRole.kitchen,
      );

      expect(result.totalPrinters, 0);
      expect(noRole.printCallCount, 0);
    });
  });
}
