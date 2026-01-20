import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Disable Google Fonts HTTP requests during tests
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('FiftyTextTheme', () {
    group('Display Styles', () {
      test('displayLarge.fontSize is 32 (displayLarge)', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.displayLarge?.fontSize, FiftyTypography.displayLarge);
        expect(textTheme.displayLarge?.fontSize, 32);
      });

      test('displayMedium.fontSize is 24 (displayMedium)', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.displayMedium?.fontSize, FiftyTypography.displayMedium);
        expect(textTheme.displayMedium?.fontSize, 24);
      });

      test('displaySmall.fontSize is 20 (titleLarge)', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.displaySmall?.fontSize, FiftyTypography.titleLarge);
        expect(textTheme.displaySmall?.fontSize, 20);
      });

      test('displayLarge font is configured', () {
        final textTheme = FiftyTextTheme.textTheme();
        // GoogleFonts creates font styles with dynamic names
        expect(textTheme.displayLarge?.fontFamily, isNotNull);
      });

      test('displayLarge uses extraBold weight', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(
          textTheme.displayLarge?.fontWeight,
          FiftyTypography.extraBold,
        );
      });

      test('displayMedium font is configured', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.displayMedium?.fontFamily, isNotNull);
      });

      test('displaySmall font is configured', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.displaySmall?.fontFamily, isNotNull);
      });
    });

    group('Body Styles', () {
      test('bodyLarge.fontSize is 16 (bodyLarge)', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.bodyLarge?.fontSize, FiftyTypography.bodyLarge);
        expect(textTheme.bodyLarge?.fontSize, 16);
      });

      test('bodyMedium.fontSize is 14', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.bodyMedium?.fontSize, FiftyTypography.bodyMedium);
        expect(textTheme.bodyMedium?.fontSize, 14);
      });

      test('bodySmall.fontSize is 12 (bodySmall)', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.bodySmall?.fontSize, FiftyTypography.bodySmall);
        expect(textTheme.bodySmall?.fontSize, 12);
      });

      test('bodyLarge font is configured', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.bodyLarge?.fontFamily, isNotNull);
      });

      test('bodySmall font is configured', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.bodySmall?.fontFamily, isNotNull);
      });

      test('bodyLarge uses medium weight', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(
          textTheme.bodyLarge?.fontWeight,
          FiftyTypography.medium,
        );
      });
    });

    group('Headline Styles', () {
      test('headlineLarge.fontSize is 20 (titleLarge)', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.headlineLarge?.fontSize, FiftyTypography.titleLarge);
      });

      test('headlineMedium.fontSize is 18 (titleMedium)', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.headlineMedium?.fontSize, FiftyTypography.titleMedium);
      });

      test('headlineSmall.fontSize is 16 (titleSmall)', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.headlineSmall?.fontSize, FiftyTypography.titleSmall);
      });

      test('headlineLarge font is configured', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.headlineLarge?.fontFamily, isNotNull);
      });
    });

    group('Title Styles', () {
      test('titleLarge.fontSize is 20', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.titleLarge?.fontSize, FiftyTypography.titleLarge);
        expect(textTheme.titleLarge?.fontSize, 20);
      });

      test('titleMedium.fontSize is 18 (titleMedium)', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.titleMedium?.fontSize, FiftyTypography.titleMedium);
      });

      test('titleSmall.fontSize is 16 (titleSmall)', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.titleSmall?.fontSize, FiftyTypography.titleSmall);
      });

      test('titleLarge font is configured', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.titleLarge?.fontFamily, isNotNull);
      });
    });

    group('Label Styles', () {
      test('labelLarge.fontSize is 14', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.labelLarge?.fontSize, FiftyTypography.labelLarge);
        expect(textTheme.labelLarge?.fontSize, 14);
      });

      test('labelMedium.fontSize is 12 (labelMedium)', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.labelMedium?.fontSize, FiftyTypography.labelMedium);
        expect(textTheme.labelMedium?.fontSize, 12);
      });

      test('labelSmall.fontSize is 10', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.labelSmall?.fontSize, FiftyTypography.labelSmall);
        expect(textTheme.labelSmall?.fontSize, 10);
      });

      test('labelLarge font is configured', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(textTheme.labelLarge?.fontFamily, isNotNull);
      });

      test('labelMedium uses bold weight', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(
          textTheme.labelMedium?.fontWeight,
          FiftyTypography.bold,
        );
      });
    });

    group('Line Heights', () {
      test('displayLarge has display line height (1.2)', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(
          textTheme.displayLarge?.height,
          FiftyTypography.lineHeightDisplay,
        );
      });

      test('bodyLarge has body line height (1.5)', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(
          textTheme.bodyLarge?.height,
          FiftyTypography.lineHeightBody,
        );
      });

      test('bodySmall has body line height (1.5)', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(
          textTheme.bodySmall?.height,
          FiftyTypography.lineHeightBody,
        );
      });
    });

    group('Letter Spacing', () {
      test('displayLarge has display letter spacing (-0.5)', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(
          textTheme.displayLarge?.letterSpacing,
          FiftyTypography.letterSpacingDisplay,
        );
      });

      test('bodyLarge has body letter spacing (0.5)', () {
        final textTheme = FiftyTextTheme.textTheme();
        expect(
          textTheme.bodyLarge?.letterSpacing,
          FiftyTypography.letterSpacingBody,
        );
      });
    });
  });
}
