import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyTokens Package', () {
    test('exports FiftyColors (v2)', () {
      expect(FiftyColors.burgundy, isNotNull);
      expect(FiftyColors.cream, isNotNull);
      expect(FiftyColors.slateGrey, isNotNull);
    });

    test('exports FiftyTypography (v2)', () {
      expect(FiftyTypography.fontFamily, isNotNull);
      expect(FiftyTypography.displayLarge, isNotNull);
    });

    test('exports FiftySpacing', () {
      expect(FiftySpacing.base, isNotNull);
    });

    test('exports FiftyRadii (v2)', () {
      expect(FiftyRadii.xl, isNotNull);
      expect(FiftyRadii.xxl, isNotNull);
    });

    test('exports FiftyMotion', () {
      expect(FiftyMotion.fast, isNotNull);
    });

    test('exports FiftyShadows (v2)', () {
      expect(FiftyShadows.sm, isNotNull);
      expect(FiftyShadows.md, isNotNull);
      expect(FiftyShadows.lg, isNotNull);
    });

    test('exports FiftyGradients (v2)', () {
      expect(FiftyGradients.primary, isNotNull);
      expect(FiftyGradients.progress, isNotNull);
      expect(FiftyGradients.surface, isNotNull);
    });

    test('exports FiftyBreakpoints', () {
      expect(FiftyBreakpoints.desktop, isNotNull);
    });
  });
}
