import 'package:escpos/escpos.dart' hide PaperSize;
import 'package:escpos/escpos.dart' as escpos show PaperSize;
import 'package:fifty_printing_engine/src/models/paper_size.dart';

/// Print ticket that extends escpos.Ticket for ESC/POS thermal printing.
///
/// This class provides a simple, familiar API for creating print tickets
/// using the standard escpos package. Consumers use standard escpos methods
/// like text(), row(), feed(), cut(), etc.
///
/// Example:
/// ```dart
/// final profile = await CapabilityProfile.load();
/// final ticket = PrintTicket(PaperSize.mm80, profile);
/// ticket.text('Order #123', styles: PosStyles(bold: true));
/// ticket.row([
///   PosColumn(text: 'Item', width: 6),
///   PosColumn(text: 'Qty', width: 3),
/// ]);
/// ticket.feed(2);
/// ticket.cut();
/// ```
class PrintTicket extends Ticket {
  /// The paper size this ticket was created for
  final PaperSize paperSize;

  /// Creates a new print ticket with the specified paper size and capability profile
  PrintTicket(this.paperSize, CapabilityProfile profile)
      : super(_convertPaperSize(paperSize), profile);

  /// Convert our PaperSize enum to escpos PaperSize enum
  static escpos.PaperSize _convertPaperSize(PaperSize size) {
    switch (size) {
      case PaperSize.mm58:
        return escpos.PaperSize.mm58;
      case PaperSize.mm80:
        return escpos.PaperSize.mm80;
    }
  }

  // Inherits all methods from escpos.Ticket:
  // - text(String text, {PosStyles? styles})
  // - row(List<PosColumn> cols)
  // - feed(int n)
  // - cut()
  // - hr({String? ch, int? len, int? linesAfter})
  // - qrcode(String text)
  // - barcode(Barcode barcode)
  // - image(Image image)
  // And many more...

  // The bytes property is inherited from Ticket and contains the ESC/POS commands
}
