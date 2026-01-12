import 'package:fifty_printing_engine/src/core/printer_device.dart';
import 'package:fifty_printing_engine/src/core/print_ticket.dart';
import 'package:fifty_printing_engine/src/models/print_result.dart';
import 'package:fifty_printing_engine/src/models/printer_role.dart';
import 'package:fifty_printing_engine/src/models/paper_size.dart';

/// Abstract base class for printing routing strategies.
///
/// Strategies determine which printers receive a print job and how
/// the results are aggregated.
abstract class PrintingStrategy {
  /// Execute the print operation according to this strategy
  ///
  /// Parameters:
  /// - [ticket]: The ticket to print
  /// - [availablePrinters]: List of all registered printers
  /// - [targetRole]: Optional role filter (for role-based routing)
  /// - [targetPrinterIds]: Optional specific printer IDs (for explicit selection)
  /// - [regenerator]: Optional function to regenerate ticket with different paper size
  ///
  /// Returns a [PrintResult] with aggregated results from all printers.
  Future<PrintResult> execute({
    required PrintTicket ticket,
    required List<PrinterDevice> availablePrinters,
    PrinterRole? targetRole,
    List<String>? targetPrinterIds,
    Future<PrintTicket> Function(PaperSize)? regenerator,
  });

  /// Helper method to filter printers by role
  List<PrinterDevice> filterByRole(
    List<PrinterDevice> printers,
    PrinterRole role,
  ) {
    return printers.where((p) => p.role == role || p.role == PrinterRole.both).toList();
  }

  /// Helper method to filter printers by IDs
  List<PrinterDevice> filterByIds(
    List<PrinterDevice> printers,
    List<String> ids,
  ) {
    return printers.where((p) => ids.contains(p.id)).toList();
  }
}
