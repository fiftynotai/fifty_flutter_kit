import 'package:fifty_printing_engine/fifty_printing_engine.dart';

class KitchenTicketExample {
  static Future<PrintTicket> generate() async {
    final profile = await CapabilityProfile.load();
    final ticket = PrintTicket(PaperSize.mm80, profile);

    // Header
    ticket.text(
      'KITCHEN ORDER',
      styles: const PosStyles(
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
        align: PosAlign.center,
      ),
    );

    ticket.feed(1);

    ticket.text(
      'Order #K-123',
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
        height: PosTextSize.size2,
      ),
    );

    ticket.feed(1);
    ticket.hr();
    ticket.feed(1);

    // Order Details
    ticket.row([
      PosColumn(text: 'Table:', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(text: '5', width: 6),
    ]);

    ticket.row([
      PosColumn(text: 'Time:', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(text: '14:30', width: 6),
    ]);

    ticket.feed(1);
    ticket.hr();
    ticket.feed(1);

    // Items Header
    ticket.row([
      PosColumn(text: 'Item', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(text: 'Qty', width: 3, styles: const PosStyles(bold: true, align: PosAlign.center)),
      PosColumn(text: 'Notes', width: 3, styles: const PosStyles(bold: true)),
    ]);

    ticket.hr(ch: '-');

    // Items
    ticket.row([
      PosColumn(text: 'Burger Deluxe', width: 6),
      PosColumn(text: 'x2', width: 3, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(text: 'Well done', width: 3),
    ]);

    ticket.row([
      PosColumn(text: 'Caesar Salad', width: 6),
      PosColumn(text: 'x1', width: 3, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(text: 'No croutons', width: 3),
    ]);

    ticket.row([
      PosColumn(text: 'Fries', width: 6),
      PosColumn(text: 'x2', width: 3, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(text: 'Extra crispy', width: 3),
    ]);

    ticket.feed(1);
    ticket.hr();
    ticket.feed(1);

    // Special Instructions
    ticket.text(
      'Special Instructions:',
      styles: const PosStyles(bold: true),
    );
    ticket.text('Allergy: Nuts - Please be careful!');

    ticket.feed(2);

    // Footer
    ticket.text(
      'Rush Order - Priority!',
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
        reverse: true,
      ),
    );

    ticket.feed(3);
    ticket.cut();

    return ticket;
  }
}
