import 'package:fifty_printing_engine/src/core/printing_strategy.dart';
import 'package:fifty_printing_engine/src/core/printer_device.dart';
import 'package:fifty_printing_engine/src/core/print_ticket.dart';
import 'package:fifty_printing_engine/src/models/print_result.dart';
import 'package:fifty_printing_engine/src/models/printer_result.dart';
import 'package:fifty_printing_engine/src/models/printer_role.dart';
import 'package:fifty_printing_engine/src/models/paper_size.dart';

/// Strategy that routes print jobs based on printer roles
class RoleBasedRoutingStrategy extends PrintingStrategy {
  @override
  Future<PrintResult> execute({
    required PrintTicket ticket,
    required List<PrinterDevice> availablePrinters,
    PrinterRole? targetRole,
    List<String>? targetPrinterIds,
    Future<PrintTicket> Function(PaperSize)? regenerator,
  }) async {
    // Role-based routing requires a target role
    // Fallback: print to all if no role specified
    targetRole ??= PrinterRole.both;

    // Filter printers by role
    var printers = filterByRole(availablePrinters, targetRole);

    // Further filter by IDs if specified
    if (targetPrinterIds != null && targetPrinterIds.isNotEmpty) {
      printers = filterByIds(printers, targetPrinterIds);
    }

    if (printers.isEmpty) {
      // No printers available for this role
      return PrintResult(
        totalPrinters: 0,
        successCount: 0,
        failedCount: 0,
        results: {},
      );
    }

    // Print to all printers with matching role (even disconnected ones)
    // Disconnected printers will attempt auto-connect, then fail gracefully if unreachable
    final results = await Future.wait(
      printers.map((printer) => _printToPrinter(printer, ticket, regenerator)),
    );

    return PrintResult.fromResults(results);
  }

  Future<PrinterResult> _printToPrinter(
    PrinterDevice printer,
    PrintTicket ticket,
    Future<PrintTicket> Function(PaperSize)? regenerator,
  ) async {
    final stopwatch = Stopwatch()..start();

    try {
      final success = await printer.print(ticket, regenerator: regenerator);
      stopwatch.stop();

      return PrinterResult(
        printerId: printer.id,
        success: success,
        errorMessage: success ? null : 'Print operation returned false',
        duration: stopwatch.elapsed,
      );
    } catch (e) {
      stopwatch.stop();

      return PrinterResult(
        printerId: printer.id,
        success: false,
        errorMessage: e.toString(),
        duration: stopwatch.elapsed,
      );
    }
  }
}
