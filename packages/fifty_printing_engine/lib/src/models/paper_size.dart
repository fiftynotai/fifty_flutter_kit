/// **PaperSize**
///
/// Defines thermal printer paper width sizes.
///
/// **Key Features:**
/// - Standard thermal printer paper widths
/// - Used for ticket formatting and layout
/// - Stored in printer configuration
///
/// **Supported Sizes:**
/// - `mm58`: 58mm width (compact receipts, small printers)
/// - `mm80`: 80mm width (standard receipts, kitchen orders)
///
/// **Usage Example:**
/// ```dart
/// final printer = BluetoothPrinterDevice(
///   id: 'kitchen-1',
///   name: 'Kitchen Printer',
///   macAddress: '00:11:22:33:44:55',
///   paperSize: PaperSize.mm80,
/// );
///
/// final ticket = PrintTicket(PaperSize.mm80);
/// ```
///
/// ─────────────────────────────────────────────────────────────────────────────
enum PaperSize {
  /// 58mm paper width (compact receipts)
  mm58,

  /// 80mm paper width (standard receipts)
  mm80,
}
