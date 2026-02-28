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

    group('override fontFamily', () {
      test('custom fontFamily', () {
        FiftyTokens.configure(
          typography: const FiftyTypographyConfig(fontFamily: 'Inter'),
        );
        expect(FiftyTypography.fontFamily, 'Inter');
      });
    });

    group('override fontSource', () {
      test('fontSource set to asset', () {
        FiftyTokens.configure(
          typography: const FiftyTypographyConfig(
            fontSource: FontSource.asset,
          ),
        );
        expect(FiftyTypography.fontSource, FontSource.asset);
      });
    });

    group('override individual sizes', () {
      test('only displayLarge overridden', () {
        FiftyTokens.configure(
          typography: const FiftyTypographyConfig(displayLarge: 48),
        );
        expect(FiftyTypography.displayLarge, 48);
        // Others unchanged
        expect(FiftyTypography.displayMedium, 24);
        expect(FiftyTypography.titleLarge, 20);
      });

      test('letter spacing override', () {
        FiftyTokens.configure(
          typography: const FiftyTypographyConfig(
            letterSpacingDisplay: -1.0,
          ),
        );
        expect(FiftyTypography.letterSpacingDisplay, -1.0);
        // Others unchanged
        expect(FiftyTypography.letterSpacingBody, 0.5);
      });

      test('line height override', () {
        FiftyTokens.configure(
          typography: const FiftyTypographyConfig(
            lineHeightBody: 1.8,
          ),
        );
        expect(FiftyTypography.lineHeightBody, 1.8);
        // Others unchanged
        expect(FiftyTypography.lineHeightDisplay, 1.2);
      });

      test('weight override', () {
        FiftyTokens.configure(
          typography: const FiftyTypographyConfig(
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
          typography: const FiftyTypographyConfig(
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
