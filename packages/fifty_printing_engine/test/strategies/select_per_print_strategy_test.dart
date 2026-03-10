import 'package:flutter_test/flutter_test.dart';
import 'package:escpos/escpos.dart' show CapabilityProfile;
import 'package:fifty_printing_engine/src/strategies/select_per_print_strategy.dart';
import 'package:fifty_printing_engine/src/core/print_ticket.dart';
import 'package:fifty_printing_engine/src/core/printing_engine.dart';
import 'package:fifty_printing_engine/src/models/paper_size.dart';
import 'package:fifty_printing_engine/src/models/printer_role.dart';
import 'package:fifty_printing_engine/src/models/exceptions.dart';

import '../helpers/mock_printer_device.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SelectPerPrintStrategy strategy;
  late PrintTicket ticket;

  setUpAll(() async {
    final profile = await CapabilityProfile.load();
    ticket = PrintTicket(PaperSize.mm80, profile);
  });

  setUp(() {
    strategy = SelectPerPrintStrategy();
    // Clear callback between tests
    PrintingEngine.instance.setPrinterSelectionCallback(null);
  });

  tearDown(() {
    PrintingEngine.instance.setPrinterSelectionCallback(null);
  });

  group('SelectPerPrintStrategy', () {
    group('with explicit targetPrinterIds', () {
      test('prints to explicitly specified printers bypassing callback',
          () async {
        final printer1 = MockPrinterDevice(id: 'p1', name: 'Printer 1');
        final printer2 = MockPrinterDevice(id: 'p2', name: 'Printer 2');

        // No callback registered -- should still work with explicit IDs
        final result = await strategy.execute(
          ticket: ticket,
          availablePrinters: [printer1, printer2],
          targetPrinterIds: ['p1'],
        );

        expect(result.totalPrinters, 1);
        expect(result.successCount, 1);
        expect(printer1.printCallCount, 1);
        expect(printer2.printCallCount, 0);
      });

      test('returns empty result when explicit IDs match no printers',
          () async {
        final printer = MockPrinterDevice(id: 'p1', name: 'Printer 1');

        final result = await strategy.execute(
          ticket: ticket,
          availablePrinters: [printer],
          targetPrinterIds: ['nonexistent'],
        );

        expect(result.totalPrinters, 0);
        expect(printer.printCallCount, 0);
      });
    });

    group('with selection callback', () {
      test('invokes callback when no targetPrinterIds provided', () async {
        final printer1 = MockPrinterDevice(id: 'p1', name: 'Printer 1');
        final printer2 = MockPrinterDevice(id: 'p2', name: 'Printer 2');

        bool callbackInvoked = false;

        PrintingEngine.instance.setPrinterSelectionCallback(
          (printers, suggestedRole) async {
            callbackInvoked = true;
            return ['p2'];
          },
        );

        final result = await strategy.execute(
          ticket: ticket,
          availablePrinters: [printer1, printer2],
        );

        expect(callbackInvoked, true);
        expect(result.totalPrinters, 1);
        expect(result.successCount, 1);
        expect(printer1.printCallCount, 0);
        expect(printer2.printCallCount, 1);
      });

      test('passes available printers and role hint to callback', () async {
        final printer = MockPrinterDevice(id: 'p1', name: 'Printer 1');

        PrintingEngine.instance.setPrinterSelectionCallback(
          (printers, suggestedRole) async {
            expect(printers.length, 1);
            expect(printers.first.id, 'p1');
            expect(suggestedRole, PrinterRole.kitchen);
            return ['p1'];
          },
        );

        await strategy.execute(
          ticket: ticket,
          availablePrinters: [printer],
          targetRole: PrinterRole.kitchen,
        );
      });

      test('returns empty result when callback returns null (user cancel)',
          () async {
        final printer = MockPrinterDevice(id: 'p1', name: 'Printer 1');

        PrintingEngine.instance.setPrinterSelectionCallback(
          (printers, suggestedRole) async => null,
        );

        final result = await strategy.execute(
          ticket: ticket,
          availablePrinters: [printer],
        );

        expect(result.totalPrinters, 0);
        expect(result.successCount, 0);
        expect(result.failedCount, 0);
        expect(printer.printCallCount, 0);
      });

      test('returns empty result when callback returns empty list', () async {
        final printer = MockPrinterDevice(id: 'p1', name: 'Printer 1');

        PrintingEngine.instance.setPrinterSelectionCallback(
          (printers, suggestedRole) async => [],
        );

        final result = await strategy.execute(
          ticket: ticket,
          availablePrinters: [printer],
        );

        expect(result.totalPrinters, 0);
        expect(result.successCount, 0);
        expect(printer.printCallCount, 0);
      });

      test('callback can select multiple printers', () async {
        final p1 = MockPrinterDevice(id: 'p1', name: 'Printer 1');
        final p2 = MockPrinterDevice(id: 'p2', name: 'Printer 2');
        final p3 = MockPrinterDevice(id: 'p3', name: 'Printer 3');

        PrintingEngine.instance.setPrinterSelectionCallback(
          (printers, suggestedRole) async => ['p1', 'p3'],
        );

        final result = await strategy.execute(
          ticket: ticket,
          availablePrinters: [p1, p2, p3],
        );

        expect(result.totalPrinters, 2);
        expect(p1.printCallCount, 1);
        expect(p2.printCallCount, 0);
        expect(p3.printCallCount, 1);
      });
    });

    group('error handling', () {
      test('throws PrinterSelectionRequiredException when no callback and no IDs',
          () async {
        final printer = MockPrinterDevice(id: 'p1', name: 'Printer 1');

        expect(
          () => strategy.execute(
            ticket: ticket,
            availablePrinters: [printer],
          ),
          throwsA(isA<PrinterSelectionRequiredException>()),
        );
      });

      test('reports printer failure in result', () async {
        final fail = MockPrinterDevice(
          id: 'p1',
          name: 'Failing',
          shouldSucceed: false,
        );

        final result = await strategy.execute(
          ticket: ticket,
          availablePrinters: [fail],
          targetPrinterIds: ['p1'],
        );

        expect(result.totalPrinters, 1);
        expect(result.failedCount, 1);
        expect(result.results['p1']!.success, false);
      });

      test('handles printer exception gracefully', () async {
        final thrower = MockPrinterDevice(
          id: 'p1',
          name: 'Thrower',
          shouldThrow: true,
        );

        final result = await strategy.execute(
          ticket: ticket,
          availablePrinters: [thrower],
          targetPrinterIds: ['p1'],
        );

        expect(result.totalPrinters, 1);
        expect(result.failedCount, 1);
        expect(result.results['p1']!.errorMessage, isNotNull);
      });
    });

    group('role hint behavior', () {
      test('does not filter by role -- user selection overrides role hint',
          () async {
        // User selects a kitchen printer for a receipt role target
        final kitchen = MockPrinterDevice(
          id: 'k1',
          name: 'Kitchen',
          role: PrinterRole.kitchen,
        );

        final result = await strategy.execute(
          ticket: ticket,
          availablePrinters: [kitchen],
          targetRole: PrinterRole.receipt,
          targetPrinterIds: ['k1'],
        );

        // User's explicit selection overrides role
        expect(result.totalPrinters, 1);
        expect(result.successCount, 1);
        expect(kitchen.printCallCount, 1);
      });
    });
  });
}
