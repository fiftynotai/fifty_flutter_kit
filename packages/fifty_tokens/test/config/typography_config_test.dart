import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyTypographyConfig', () {
    setUp(() => FiftyTokens.reset());

    group('defaults', () {
      test('default fontFamily is Manrope', () {
        expect(FiftyTypography.fontFamily, 'Manrope');
      });

      test('default fontSource is googleFonts', () {
        expect(FiftyTypography.fontSource, FontSource.googleFonts);
      });

      test('default weights', () {
        expect(FiftyTypography.regular, FontWeight.w400);
        expect(FiftyTypography.medium, FontWeight.w500);
        expect(FiftyTypography.semiBold, FontWeight.w600);
        expect(FiftyTypography.bold, FontWeight.w700);
        expect(FiftyTypography.extraBold, FontWeight.w800);
      });

      test('default type scale sizes', () {
        expect(FiftyTypography.displayLarge, 32);
        expect(FiftyTypography.displayMedium, 24);
        expect(FiftyTypography.titleLarge, 20);
        expect(FiftyTypography.titleMedium, 18);
        expect(FiftyTypography.titleSmall, 16);
        expect(FiftyTypography.bodyLarge, 16);
        expect(FiftyTypography.bodyMedium, 14);
        expect(FiftyTypography.bodySmall, 12);
        expect(FiftyTypography.labelLarge, 14);
        expect(FiftyTypography.labelMedium, 12);
        expect(FiftyTypography.labelSmall, 10);
      });

      test('default letter spacings', () {
        expect(FiftyTypography.letterSpacingDisplay, -0.5);
        expect(FiftyTypography.letterSpacingDisplayMedium, -0.25);
        expect(FiftyTypography.letterSpacingBody, 0.5);
        expect(FiftyTypography.letterSpacingBodyMedium, 0.25);
        expect(FiftyTypography.letterSpacingBodySmall, 0.4);
        expect(FiftyTypography.letterSpacingLabel, 0.5);
        expect(FiftyTypography.letterSpacingLabelMedium, 1.5);
      });

      test('default line heights', () {
        expect(FiftyTypography.lineHeightDisplay, 1.2);
        expect(FiftyTypography.lineHeightTitle, 1.3);
        expect(FiftyTypography.lineHeightBody, 1.5);
        expect(FiftyTypography.lineHeightLabel, 1.2);
      });
    });

    group('fromMap()', () {
      final fallback = FiftyPreset.fdlV2.typography;

      test('full valid map overrides all fields', () {
        final config = FiftyTypographyConfig.fromMap(
          {
            'fontFamily': 'Inter',
            'fontSource': 'asset',
            'regular': 400,
            'medium': 500,
            'semiBold': 600,
            'bold': 700,
            'extraBold': 800,
            'displayLarge': 48,
            'displayMedium': 36,
            'titleLarge': 28,
            'titleMedium': 22,
            'titleSmall': 18,
            'bodyLarge': 18,
            'bodyMedium': 16,
            'bodySmall': 14,
            'labelLarge': 16,
            'labelMedium': 14,
            'labelSmall': 12,
            'letterSpacingDisplay': -1.0,
            'letterSpacingDisplayMedium': -0.5,
            'letterSpacingBody': 0.75,
            'letterSpacingBodyMedium': 0.5,
            'letterSpacingBodySmall': 0.6,
            'letterSpacingLabel': 0.75,
            'letterSpacingLabelMedium': 2.0,
            'lineHeightDisplay': 1.4,
            'lineHeightTitle': 1.5,
            'lineHeightBody': 1.8,
            'lineHeightLabel': 1.4,
          },
          fallback: fallback,
        );

        expect(config.fontFamily, 'Inter');
        expect(config.fontSource, FontSource.asset);
        expect(config.regular, FontWeight.w400);
        expect(config.bold, FontWeight.w700);
        expect(config.displayLarge, 48);
        expect(config.bodyMedium, 16);
        expect(config.letterSpacingDisplay, -1.0);
        expect(config.lineHeightBody, 1.8);
      });

      test('empty map returns all fallback values', () {
        final config = FiftyTypographyConfig.fromMap({}, fallback: fallback);

        expect(config.fontFamily, fallback.fontFamily);
        expect(config.fontSource, fallback.fontSource);
        expect(config.regular, fallback.regular);
        expect(config.displayLarge, fallback.displayLarge);
        expect(config.letterSpacingDisplay, fallback.letterSpacingDisplay);
        expect(config.lineHeightBody, fallback.lineHeightBody);
      });

      test('partial map uses fallback for missing keys', () {
        final config = FiftyTypographyConfig.fromMap(
          {'fontFamily': 'Roboto', 'displayLarge': 40},
          fallback: fallback,
        );

        expect(config.fontFamily, 'Roboto');
        expect(config.displayLarge, 40);
        expect(config.fontSource, fallback.fontSource);
        expect(config.bodyMedium, fallback.bodyMedium);
      });

      test('parses fontSource "asset" string', () {
        final config = FiftyTypographyConfig.fromMap(
          {'fontSource': 'asset'},
          fallback: fallback,
        );

        expect(config.fontSource, FontSource.asset);
      });

      test('parses fontSource "googleFonts" string', () {
        final config = FiftyTypographyConfig.fromMap(
          {'fontSource': 'googleFonts'},
          fallback: fallback,
        );

        expect(config.fontSource, FontSource.googleFonts);
      });

      test('unknown fontSource string uses fallback', () {
        final config = FiftyTypographyConfig.fromMap(
          {'fontSource': 'unknown'},
          fallback: fallback,
        );

        expect(config.fontSource, fallback.fontSource);
      });

      test('parses FontWeight int values', () {
        final config = FiftyTypographyConfig.fromMap(
          {'regular': 300, 'bold': 900},
          fallback: fallback,
        );

        expect(config.regular, FontWeight.w300);
        expect(config.bold, FontWeight.w900);
      });

      test('invalid FontWeight int falls back to w400', () {
        final config = FiftyTypographyConfig.fromMap(
          {'regular': 999},
          fallback: fallback,
        );

        expect(config.regular, FontWeight.w400);
      });

      test('null FontWeight uses fallback', () {
        final config = FiftyTypographyConfig.fromMap(
          {'regular': null},
          fallback: fallback,
        );

        expect(config.regular, fallback.regular);
      });
    });

    group('override fontFamily', () {
      test('custom fontFamily', () {
        FiftyTokens.configure(
          typography: FiftyPreset.fdlV2.typography.copyWith(
            fontFamily: 'Inter',
          ),
        );
        expect(FiftyTypography.fontFamily, 'Inter');
      });
    });

    group('override fontSource', () {
      test('fontSource set to asset', () {
        FiftyTokens.configure(
          typography: FiftyPreset.fdlV2.typography.copyWith(
            fontSource: FontSource.asset,
          ),
        );
        expect(FiftyTypography.fontSource, FontSource.asset);
      });
    });

    group('override individual sizes', () {
      test('only displayLarge overridden', () {
        FiftyTokens.configure(
          typography: FiftyPreset.fdlV2.typography.copyWith(
            displayLarge: 48,
          ),
        );
        expect(FiftyTypography.displayLarge, 48);
        // Others unchanged
        expect(FiftyTypography.displayMedium, 24);
        expect(FiftyTypography.titleLarge, 20);
      });

      test('letter spacing override', () {
        FiftyTokens.configure(
          typography: FiftyPreset.fdlV2.typography.copyWith(
            letterSpacingDisplay: -1.0,
          ),
        );
        expect(FiftyTypography.letterSpacingDisplay, -1.0);
        // Others unchanged
        expect(FiftyTypography.letterSpacingBody, 0.5);
      });

      test('line height override', () {
        FiftyTokens.configure(
          typography: FiftyPreset.fdlV2.typography.copyWith(
            lineHeightBody: 1.8,
          ),
        );
        expect(FiftyTypography.lineHeightBody, 1.8);
        // Others unchanged
        expect(FiftyTypography.lineHeightDisplay, 1.2);
      });

      test('weight override', () {
        FiftyTokens.configure(
          typography: FiftyPreset.fdlV2.typography.copyWith(
            bold: FontWeight.w900,
          ),
        );
        expect(FiftyTypography.bold, FontWeight.w900);
        // Others unchanged
        expect(FiftyTypography.regular, FontWeight.w400);
      });
    });

    group('reset', () {
      test('reset restores all defaults', () {
        FiftyTokens.configure(
          typography: FiftyPreset.fdlV2.typography.copyWith(
            fontFamily: 'Inter',
            fontSource: FontSource.asset,
            displayLarge: 48,
            letterSpacingDisplay: -1.0,
            lineHeightBody: 1.8,
          ),
        );

        FiftyTokens.reset();

        expect(FiftyTypography.fontFamily, 'Manrope');
        expect(FiftyTypography.fontSource, FontSource.googleFonts);
        expect(FiftyTypography.displayLarge, 32);
        expect(FiftyTypography.letterSpacingDisplay, -0.5);
        expect(FiftyTypography.lineHeightBody, 1.5);
      });
    });
  });
}
