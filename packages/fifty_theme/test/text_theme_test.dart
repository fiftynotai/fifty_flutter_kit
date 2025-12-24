import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyTextTheme', () {
    late TextTheme textTheme;

    setUp(() {
      textTheme = FiftyTextTheme.textTheme();
    });

    group('Display Styles', () {
      test('displayLarge.fontSize is 64 (hero)', () {
        expect(textTheme.displayLarge?.fontSize, FiftyTypography.hero);
        expect(textTheme.displayLarge?.fontSize, 64);
      });

      test('displayMedium.fontSize is 48 (display)', () {
        expect(textTheme.displayMedium?.fontSize, FiftyTypography.display);
        expect(textTheme.displayMedium?.fontSize, 48);
      });

      test('displaySmall.fontSize is 32 (section)', () {
        expect(textTheme.displaySmall?.fontSize, FiftyTypography.section);
        expect(textTheme.displaySmall?.fontSize, 32);
      });

      test('displayLarge uses Monument Extended font', () {
        expect(
          textTheme.displayLarge?.fontFamily,
          FiftyTypography.fontFamilyHeadline,
        );
      });

      test('displayLarge uses ultrabold weight', () {
        expect(
          textTheme.displayLarge?.fontWeight,
          FiftyTypography.ultrabold,
        );
      });

      test('displayMedium uses Monument Extended font', () {
        expect(
          textTheme.displayMedium?.fontFamily,
          FiftyTypography.fontFamilyHeadline,
        );
      });

      test('displaySmall uses Monument Extended font', () {
        expect(
          textTheme.displaySmall?.fontFamily,
          FiftyTypography.fontFamilyHeadline,
        );
      });
    });

    group('Body Styles', () {
      test('bodyLarge.fontSize is 16 (body)', () {
        expect(textTheme.bodyLarge?.fontSize, FiftyTypography.body);
        expect(textTheme.bodyLarge?.fontSize, 16);
      });

      test('bodyMedium.fontSize is 14', () {
        expect(textTheme.bodyMedium?.fontSize, 14);
      });

      test('bodySmall.fontSize is 12 (mono)', () {
        expect(textTheme.bodySmall?.fontSize, FiftyTypography.mono);
        expect(textTheme.bodySmall?.fontSize, 12);
      });

      test('bodyLarge uses JetBrains Mono font', () {
        expect(
          textTheme.bodyLarge?.fontFamily,
          FiftyTypography.fontFamilyMono,
        );
      });

      test('bodySmall uses JetBrains Mono font', () {
        expect(
          textTheme.bodySmall?.fontFamily,
          FiftyTypography.fontFamilyMono,
        );
      });

      test('bodyLarge uses regular weight', () {
        expect(
          textTheme.bodyLarge?.fontWeight,
          FiftyTypography.regular,
        );
      });
    });

    group('Headline Styles', () {
      test('headlineLarge.fontSize is 32 (section)', () {
        expect(textTheme.headlineLarge?.fontSize, FiftyTypography.section);
      });

      test('headlineMedium.fontSize is 24', () {
        expect(textTheme.headlineMedium?.fontSize, 24);
      });

      test('headlineSmall.fontSize is 20', () {
        expect(textTheme.headlineSmall?.fontSize, 20);
      });

      test('headlineLarge uses Monument Extended font', () {
        expect(
          textTheme.headlineLarge?.fontFamily,
          FiftyTypography.fontFamilyHeadline,
        );
      });
    });

    group('Title Styles', () {
      test('titleLarge.fontSize is 20', () {
        expect(textTheme.titleLarge?.fontSize, 20);
      });

      test('titleMedium.fontSize is 16 (body)', () {
        expect(textTheme.titleMedium?.fontSize, FiftyTypography.body);
      });

      test('titleSmall.fontSize is 14', () {
        expect(textTheme.titleSmall?.fontSize, 14);
      });

      test('titleLarge uses JetBrains Mono font', () {
        expect(
          textTheme.titleLarge?.fontFamily,
          FiftyTypography.fontFamilyMono,
        );
      });
    });

    group('Label Styles', () {
      test('labelLarge.fontSize is 14', () {
        expect(textTheme.labelLarge?.fontSize, 14);
      });

      test('labelMedium.fontSize is 12 (mono)', () {
        expect(textTheme.labelMedium?.fontSize, FiftyTypography.mono);
      });

      test('labelSmall.fontSize is 10', () {
        expect(textTheme.labelSmall?.fontSize, 10);
      });

      test('labelLarge uses JetBrains Mono font', () {
        expect(
          textTheme.labelLarge?.fontFamily,
          FiftyTypography.fontFamilyMono,
        );
      });

      test('labelMedium uses medium weight', () {
        expect(
          textTheme.labelMedium?.fontWeight,
          FiftyTypography.medium,
        );
      });
    });

    group('Line Heights', () {
      test('displayLarge has display line height (1.1)', () {
        expect(
          textTheme.displayLarge?.height,
          FiftyTypography.displayLineHeight,
        );
      });

      test('bodyLarge has body line height (1.5)', () {
        expect(
          textTheme.bodyLarge?.height,
          FiftyTypography.bodyLineHeight,
        );
      });

      test('bodySmall has code line height (1.6)', () {
        expect(
          textTheme.bodySmall?.height,
          FiftyTypography.codeLineHeight,
        );
      });
    });

    group('Letter Spacing', () {
      test('displayLarge has tight letter spacing', () {
        expect(
          textTheme.displayLarge?.letterSpacing,
          FiftyTypography.hero * FiftyTypography.tight,
        );
      });

      test('bodyLarge has standard letter spacing', () {
        expect(
          textTheme.bodyLarge?.letterSpacing,
          FiftyTypography.standard,
        );
      });
    });
  });
}
