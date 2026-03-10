import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_printing_engine/src/utils/printer_discovery_utils.dart';

void main() {
  group('PrinterDiscoveryUtils', () {
    group('printerNameKeywords', () {
      test('contains expected generic terms', () {
        expect(
          PrinterDiscoveryUtils.printerNameKeywords,
          containsAll(['PRINTER', 'POS', 'THERMAL', 'RECEIPT', 'TICKET']),
        );
      });

      test('contains expected brand names', () {
        expect(
          PrinterDiscoveryUtils.printerNameKeywords,
          containsAll([
            'EPSON',
            'STAR',
            'ZEBRA',
            'BIXOLON',
            'HPRT',
            'CITIZEN',
            'XPRINTER',
          ]),
        );
      });

      test('contains expected series prefixes', () {
        expect(
          PrinterDiscoveryUtils.printerNameKeywords,
          containsAll(['TM-', 'RP-', 'TSP', 'ZD', 'ZQ', 'SRP', 'SPP']),
        );
      });
    });

    group('isPrinterName', () {
      test('returns true for generic printer terms', () {
        expect(PrinterDiscoveryUtils.isPrinterName('My Printer'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('POS Terminal'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('Thermal Receipt'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('Ticket Printer'), true);
      });

      test('returns true for brand names', () {
        expect(PrinterDiscoveryUtils.isPrinterName('Epson TM-T20'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('Star TSP100'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('Zebra ZD420'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('Bixolon SRP-350'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('HPRT TP805'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('Citizen CT-S310'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('XPrinter XP-58'), true);
      });

      test('returns true for series names', () {
        expect(PrinterDiscoveryUtils.isPrinterName('TM-T88V'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('RP-400'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('TSP650II'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('ZD410'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('ZQ520'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('SRP-350'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('SPP-R210'), true);
      });

      test('is case-insensitive', () {
        expect(PrinterDiscoveryUtils.isPrinterName('epson'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('EPSON'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('Epson'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('ePsOn'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('printer'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('PRINTER'), true);
      });

      test('returns false for non-printer device names', () {
        expect(PrinterDiscoveryUtils.isPrinterName('iPhone 15'), false);
        expect(PrinterDiscoveryUtils.isPrinterName('Galaxy Buds'), false);
        expect(PrinterDiscoveryUtils.isPrinterName('AirPods Pro'), false);
        expect(PrinterDiscoveryUtils.isPrinterName('JBL Speaker'), false);
        expect(PrinterDiscoveryUtils.isPrinterName('Fitbit Charge'), false);
        expect(PrinterDiscoveryUtils.isPrinterName('Sony WH-1000XM4'), false);
      });

      test('returns false for empty string', () {
        expect(PrinterDiscoveryUtils.isPrinterName(''), false);
      });

      test('returns true when keyword appears as substring', () {
        expect(
          PrinterDiscoveryUtils.isPrinterName('MyCustomPrinterDevice'),
          true,
        );
        expect(
          PrinterDiscoveryUtils.isPrinterName('BTthermalPrint'),
          true,
        );
      });

      test('returns true for less common brands', () {
        expect(PrinterDiscoveryUtils.isPrinterName('SEWOO LK-P20'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('MPT-II'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('GOOJPRT PT-210'), true);
        expect(PrinterDiscoveryUtils.isPrinterName('CUSTOM K80'), true);
      });
    });
  });
}
