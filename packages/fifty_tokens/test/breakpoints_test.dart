import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyBreakpoints', () {
    setUp(() => FiftyTokens.reset());

    test('breakpoint values match FDL specification', () {
      expect(FiftyBreakpoints.mobile, equals(768));
      expect(FiftyBreakpoints.tablet, equals(768));
      expect(FiftyBreakpoints.desktop, equals(1024));
    });

    test('all breakpoints are positive', () {
      expect(FiftyBreakpoints.mobile, greaterThan(0));
      expect(FiftyBreakpoints.tablet, greaterThan(0));
      expect(FiftyBreakpoints.desktop, greaterThan(0));
    });

    test('desktop breakpoint is larger than tablet', () {
      expect(FiftyBreakpoints.desktop, greaterThan(FiftyBreakpoints.tablet));
    });

    test('all breakpoints are non-null', () {
      expect(FiftyBreakpoints.mobile, isNotNull);
      expect(FiftyBreakpoints.tablet, isNotNull);
      expect(FiftyBreakpoints.desktop, isNotNull);
    });
  });
}
