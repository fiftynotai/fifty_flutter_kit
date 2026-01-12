import 'package:fifty_printing_engine/src/core/printing_strategy.dart';
import 'package:fifty_printing_engine/src/core/printer_device.dart';
import 'package:fifty_printing_engine/src/core/print_ticket.dart';
import 'package:fifty_printing_engine/src/models/print_result.dart';
import 'package:fifty_printing_engine/src/models/printer_result.dart';
import 'package:fifty_printing_engine/src/models/printer_role.dart';
import 'package:fifty_printing_engine/src/models/paper_size.dart';

/// Strategy that prints to all available printers
class PrintToAllStrategy extends PrintingStrategy {
  @override
  Future<PrintResult> execute({
    required PrintTicket ticket,
    required List<PrinterDevice> availablePrinters,
    PrinterRole? targetRole,
    List<String>? targetPrinterIds,
    Future<PrintTicket> Function(PaperSize)? regenerator,
  }) async {
    // PrintToAll ALWAYS prints to all printers (ignores targetRole hint)
    // targetRole is provided by caller but ignored in this strategy
    var printers = availablePrinters;

    // Filter by IDs if specified (for explicit printer selection)
    if (targetPrinterIds != null && targetPrinterIds.isNotEmpty) {
      printers = filterByIds(printers, targetPrinterIds);
    }

    if (printers.isEmpty) {
      // No printers available
      return PrintResult(
        totalPrinters: 0,
        successCount: 0,
        failedCount: 0,
        results: {},
      );
    }

    // Print to all printers concurrently (even disconnected ones)
    // Disconnected printers will fail and show in results with error message
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
