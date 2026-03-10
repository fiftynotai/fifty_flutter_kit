import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_printing_engine/src/models/exceptions.dart';

void main() {
  group('PrinterSelectionRequiredException', () {
    test('stores message', () {
      const msg = 'Selection callback required';
      final exception = PrinterSelectionRequiredException(msg);
      expect(exception.message, msg);
    });

    test('toString includes class name and message', () {
      const msg = 'No callback registered';
      final exception = PrinterSelectionRequiredException(msg);
      expect(
        exception.toString(),
        'PrinterSelectionRequiredException: No callback registered',
      );
    });

    test('implements Exception', () {
      final exception = PrinterSelectionRequiredException('test');
      expect(exception, isA<Exception>());
    });

    test('can be caught as Exception', () {
      expect(
        () => throw PrinterSelectionRequiredException('test error'),
        throwsA(isA<Exception>()),
      );
    });

    test('can be caught specifically', () {
      expect(
        () => throw PrinterSelectionRequiredException('specific'),
        throwsA(isA<PrinterSelectionRequiredException>()),
      );
    });

    test('preserves full message with formatting', () {
      const msg = 'SelectPerPrint mode requires printerSelectionCallback. '
          'Call engine.setPrinterSelectionCallback() to register UI callback.';
      final exception = PrinterSelectionRequiredException(msg);
      expect(exception.message, msg);
      expect(exception.toString(), contains('setPrinterSelectionCallback'));
    });
  });
}
