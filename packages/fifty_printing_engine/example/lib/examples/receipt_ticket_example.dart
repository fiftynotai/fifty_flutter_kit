import 'package:fifty_printing_engine/fifty_printing_engine.dart';

class ReceiptTicketExample {
  static Future<PrintTicket> generate() async {
    final profile = await CapabilityProfile.load();
    final ticket = PrintTicket(PaperSize.mm80, profile);

    // Header - Restaurant Name
    ticket.text(
      'Restaurant Demo',
      styles: const PosStyles(
        bold: true,
        height: PosTextSize.size2,
        width: PosTextSize.size2,
        align: PosAlign.center,
      ),
    );

    ticket.text(
      '123 Main Street, City',
      styles: const PosStyles(align: PosAlign.center),
    );

    ticket.text(
      'Tel: (555) 123-4567',
      styles: const PosStyles(align: PosAlign.center),
    );

    ticket.feed(1);
    ticket.hr();
    ticket.feed(1);

    // Order Info
    ticket.row([
      PosColumn(text: 'Order #:', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(text: 'R-456', width: 6),
    ]);

    ticket.row([
      PosColumn(text: 'Table:', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(text: '5', width: 6),
    ]);

    ticket.row([
      PosColumn(text: 'Date:', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(text: '2024-11-07 14:30', width: 6),
    ]);

    ticket.feed(1);
    ticket.hr();
    ticket.feed(1);

    // Items Header
    ticket.row([
      PosColumn(text: 'Item', width: 6, styles: const PosStyles(bold: true)),
      PosColumn(text: 'Qty', width: 2, styles: const PosStyles(bold: true, align: PosAlign.center)),
      PosColumn(text: 'Price', width: 4, styles: const PosStyles(bold: true, align: PosAlign.right)),
    ]);

    ticket.hr(ch: '-');

    // Items
    ticket.row([
      PosColumn(text: 'Burger Deluxe', width: 6),
      PosColumn(text: '2', width: 2, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(text: '\$25.00', width: 4, styles: const PosStyles(align: PosAlign.right)),
    ]);

    ticket.row([
      PosColumn(text: 'Caesar Salad', width: 6),
      PosColumn(text: '1', width: 2, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(text: '\$12.00', width: 4, styles: const PosStyles(align: PosAlign.right)),
    ]);

    ticket.row([
      PosColumn(text: 'Fries', width: 6),
      PosColumn(text: '2', width: 2, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(text: '\$8.00', width: 4, styles: const PosStyles(align: PosAlign.right)),
    ]);

    ticket.row([
      PosColumn(text: 'Soft Drink', width: 6),
      PosColumn(text: '2', width: 2, styles: const PosStyles(align: PosAlign.center)),
      PosColumn(text: '\$6.00', width: 4, styles: const PosStyles(align: PosAlign.right)),
    ]);

    ticket.feed(1);
    ticket.hr(ch: '-');

    // Totals
    ticket.row([
      PosColumn(text: 'Subtotal:', width: 8, styles: const PosStyles(bold: true)),
      PosColumn(text: '\$51.00', width: 4, styles: const PosStyles(bold: true, align: PosAlign.right)),
    ]);

    ticket.row([
      PosColumn(text: 'Tax (10%):', width: 8),
      PosColumn(text: '\$5.10', width: 4, styles: const PosStyles(align: PosAlign.right)),
    ]);

    ticket.row([
      PosColumn(text: 'Service (5%):', width: 8),
      PosColumn(text: '\$2.55', width: 4, styles: const PosStyles(align: PosAlign.right)),
    ]);

    ticket.hr(ch: '-');

    ticket.row([
      PosColumn(
        text: 'TOTAL:',
        width: 8,
        styles: const PosStyles(
          bold: true,
          height: PosTextSize.size2,
        ),
      ),
      PosColumn(
        text: '\$58.65',
        width: 4,
        styles: const PosStyles(
          bold: true,
          height: PosTextSize.size2,
          align: PosAlign.right,
        ),
      ),
    ]);

    ticket.feed(1);
    ticket.hr();
    ticket.feed(1);

    // Payment
    ticket.row([
      PosColumn(text: 'Payment Method:', width: 7, styles: const PosStyles(bold: true)),
      PosColumn(text: 'Card', width: 5, styles: const PosStyles(align: PosAlign.right)),
    ]);

    ticket.feed(2);

    // Footer
    ticket.text(
      'Thank you for dining with us!',
      styles: const PosStyles(
        bold: true,
        align: PosAlign.center,
      ),
    );

    ticket.text(
      'Visit us again soon',
      styles: const PosStyles(align: PosAlign.center),
    );

    ticket.feed(3);
    ticket.cut();

    return ticket;
  }
}
