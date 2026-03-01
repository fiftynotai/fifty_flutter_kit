import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyTokens Package', () {
    setUp(() => FiftyTokens.reset());

    test('exports FiftyColors (v2)', () {
      expect(FiftyColors.primary, isNotNull);
      expect(FiftyColors.background, isNotNull);
      expect(FiftyColors.secondary, isNotNull);
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

    test('exports FiftyTokens config', () {
      expect(FiftyTokens.isConfigured, isFalse);
    });

    test('exports FontSource enum', () {
      expect(FontSource.googleFonts, isNotNull);
      expect(FontSource.asset, isNotNull);
    });

    test('exports config classes via FiftyPreset.fdlV2', () {
      // Verify all config classes are accessible via the preset
      final colors = FiftyPreset.fdlV2.colors;
      final typography = FiftyPreset.fdlV2.typography;
      final spacing = FiftyPreset.fdlV2.spacing;
      final radii = FiftyPreset.fdlV2.radii;
      final motion = FiftyPreset.fdlV2.motion;
      final breakpoints = FiftyPreset.fdlV2.breakpoints;

      expect(colors, isNotNull);
      expect(typography, isNotNull);
      expect(spacing, isNotNull);
      expect(radii, isNotNull);
      expect(motion, isNotNull);
      expect(breakpoints, isNotNull);
    });
  });
}
