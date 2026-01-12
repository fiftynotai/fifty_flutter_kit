/// **PrinterDiscoveryUtils**
///
/// Utilities for identifying and filtering thermal printers during discovery.
/// Contains printer vendor keywords for Bluetooth device name filtering.
///
/// **Key Features:**
/// - Comprehensive printer keyword list (brands, series, generic terms)
/// - Case-insensitive name matching
/// - Reusable utility methods
///
/// **Usage Example:**
/// ```dart
/// final isPrinter = PrinterDiscoveryUtils.isPrinterName('Epson TM-T20');
/// // Returns: true
/// ```
///
/// **BR-085:** Extracted from PrintingEngine for better separation of concerns
///
// ────────────────────────────────────────────────
class PrinterDiscoveryUtils {
  /// **Bluetooth Printer Name Keywords**
  ///
  /// Keywords commonly found in Bluetooth printer device names.
  /// Used to filter paired devices to likely printers.
  ///
  /// **Keywords:**
  /// - Generic: Printer, POS, Thermal, Receipt, Ticket
  /// - Brands: Epson, Star, Zebra, Bixolon, HPRT, Citizen, etc.
  /// - Series: TM (Epson), RP (Star), TSP (Star), ZD/ZQ (Zebra)
  ///
  static const List<String> printerNameKeywords = [
    // Generic terms
    'PRINTER',
    'POS',
    'THERMAL',
    'RECEIPT',
    'TICKET',

    // Brands
    'EPSON',
    'STAR',
    'ZEBRA',
    'BIXOLON',
    'HPRT',
    'CITIZEN',
    'CUSTOM',
    'SEWOO',
    'MPT',
    'GOOJPRT',
    'XPRINTER',
    'MP',

    // Common series names
    'TM-', // Epson TM series
    'RP-', // Star RP series
    'TSP', // Star TSP series
    'ZD', // Zebra ZD series
    'ZQ', // Zebra ZQ series
    'SRP', // Bixolon SRP series
    'SPP', // Star SPP series
  ];

  /// **Check if device name suggests it's a printer**
  ///
  /// Case-insensitive check for printer keywords in device name.
  ///
  /// **Parameters:**
  /// - `name`: Device name to check
  ///
  /// **Returns:**
  /// True if name contains any printer keyword
  ///
  /// **Usage Example:**
  /// ```dart
  /// if (PrinterDiscoveryUtils.isPrinterName('Epson TM-T20')) {
  ///   print('This is likely a printer');
  /// }
  /// ```
  ///
  // ────────────────────────────────────────────────
  static bool isPrinterName(String name) {
    final upperName = name.toUpperCase();
    return printerNameKeywords.any((keyword) => upperName.contains(keyword));
  }
}
