import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyTokens Package', () {
    test('exports FiftyColors', () {
      expect(FiftyColors.crimsonPulse, isNotNull);
    });

    test('exports FiftyTypography', () {
      expect(FiftyTypography.fontFamilyHeadline, isNotNull);
    });

    test('exports FiftySpacing', () {
      expect(FiftySpacing.base, isNotNull);
    });

    test('exports FiftyRadii', () {
      expect(FiftyRadii.standard, isNotNull);
    });

    test('exports FiftyMotion', () {
      expect(FiftyMotion.fast, isNotNull);
    });

    test('exports FiftyElevation', () {
      expect(FiftyElevation.crimsonGlow, isNotNull);
    });

    test('exports FiftyBreakpoints', () {
      expect(FiftyBreakpoints.desktop, isNotNull);
    });
  });
}
