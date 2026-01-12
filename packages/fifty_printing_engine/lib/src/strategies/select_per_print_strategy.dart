import 'package:fifty_printing_engine/src/core/printing_strategy.dart';
import 'package:fifty_printing_engine/src/core/printer_device.dart';
import 'package:fifty_printing_engine/src/core/print_ticket.dart';
import 'package:fifty_printing_engine/src/core/printing_engine.dart';
import 'package:fifty_printing_engine/src/models/print_result.dart';
import 'package:fifty_printing_engine/src/models/printer_result.dart';
import 'package:fifty_printing_engine/src/models/printer_role.dart';
import 'package:fifty_printing_engine/src/models/paper_size.dart';
import 'package:fifty_printing_engine/src/models/exceptions.dart';

/// Strategy that prints to user-selected printers
///
/// This strategy requires [targetPrinterIds] OR invokes selection callback.
/// If IDs are provided explicitly, uses them. Otherwise calls registered callback to get selection.
class SelectPerPrintStrategy extends PrintingStrategy {
  @override
  Future<PrintResult> execute({
    required PrintTicket ticket,
    required List<PrinterDevice> availablePrinters,
    PrinterRole? targetRole,
    List<String>? targetPrinterIds,
    Future<PrintTicket> Function(PaperSize)? regenerator,
  }) async {
    // If IDs explicitly provided, use them (for testing/automation)
    if (targetPrinterIds != null && targetPrinterIds.isNotEmpty) {
      // Use explicit IDs - skip to printing
    } else {
      // No IDs provided - request selection via callback
      final callback = PrintingEngine.instance.selectionCallback;

      if (callback == null) {
        throw PrinterSelectionRequiredException(
          'SelectPerPrint mode requires printerSelectionCallback. '
          'Call engine.setPrinterSelectionCallback() to register UI callback.',
        );
      }

      // Call app's selection UI (pass targetRole as suggestion)
      final selectedIds = await callback(availablePrinters, targetRole);

      if (selectedIds == null || selectedIds.isEmpty) {
        // User canceled - return empty result
        return PrintResult(
          totalPrinters: 0,
          successCount: 0,
          failedCount: 0,
          results: {},
        );
      }

      // Use selected IDs
      targetPrinterIds = selectedIds;
    }

    // Filter printers by IDs (user's explicit selection)
    var printers = filterByIds(availablePrinters, targetPrinterIds);

    // DO NOT filter by role - user selection overrides role suggestions
    // In SelectPerPrint mode, the user's explicit choice is the ultimate authority
    // The targetRole parameter is only a HINT for dialog pre-selection, not for filtering

    if (printers.isEmpty) {
      // No selected printers available
      return PrintResult(
        totalPrinters: 0,
        successCount: 0,
        failedCount: 0,
        results: {},
      );
    }

    // Print to selected printers (even disconnected ones)
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
