import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyTypography', () {
    setUp(() => FiftyTokens.reset());

    group('Font Family (v2)', () {
      test('fontFamily is Manrope', () {
        expect(FiftyTypography.fontFamily, 'Manrope');
      });
    });

    group('Font Weights (v2)', () {
      test('regular is w400', () {
        expect(FiftyTypography.regular, FontWeight.w400);
      });

      test('medium is w500', () {
        expect(FiftyTypography.medium, FontWeight.w500);
      });

      test('semiBold is w600', () {
        expect(FiftyTypography.semiBold, FontWeight.w600);
      });

      test('bold is w700', () {
        expect(FiftyTypography.bold, FontWeight.w700);
      });

      test('extraBold is w800', () {
        expect(FiftyTypography.extraBold, FontWeight.w800);
      });
    });

    group('Type Scale (v2)', () {
      test('displayLarge is 32px', () {
        expect(FiftyTypography.displayLarge, 32);
      });

      test('displayMedium is 24px', () {
        expect(FiftyTypography.displayMedium, 24);
      });

      test('titleLarge is 20px', () {
        expect(FiftyTypography.titleLarge, 20);
      });

      test('titleMedium is 18px', () {
        expect(FiftyTypography.titleMedium, 18);
      });

      test('titleSmall is 16px', () {
        expect(FiftyTypography.titleSmall, 16);
      });

      test('bodyLarge is 16px', () {
        expect(FiftyTypography.bodyLarge, 16);
      });

      test('bodyMedium is 14px', () {
        expect(FiftyTypography.bodyMedium, 14);
      });

      test('bodySmall is 12px', () {
        expect(FiftyTypography.bodySmall, 12);
      });

      test('labelLarge is 14px', () {
        expect(FiftyTypography.labelLarge, 14);
      });

      test('labelMedium is 12px', () {
        expect(FiftyTypography.labelMedium, 12);
      });

      test('labelSmall is 10px', () {
        expect(FiftyTypography.labelSmall, 10);
      });
    });

    group('Letter Spacing (v2)', () {
      test('letterSpacingDisplay is -0.5', () {
        expect(FiftyTypography.letterSpacingDisplay, -0.5);
      });

      test('letterSpacingDisplayMedium is -0.25', () {
        expect(FiftyTypography.letterSpacingDisplayMedium, -0.25);
      });

      test('letterSpacingBody is 0.5', () {
        expect(FiftyTypography.letterSpacingBody, 0.5);
      });

      test('letterSpacingBodyMedium is 0.25', () {
        expect(FiftyTypography.letterSpacingBodyMedium, 0.25);
      });

      test('letterSpacingBodySmall is 0.4', () {
        expect(FiftyTypography.letterSpacingBodySmall, 0.4);
      });

      test('letterSpacingLabel is 0.5', () {
        expect(FiftyTypography.letterSpacingLabel, 0.5);
      });

      test('letterSpacingLabelMedium is 1.5', () {
        expect(FiftyTypography.letterSpacingLabelMedium, 1.5);
      });
    });

    group('Line Heights (v2)', () {
      test('lineHeightDisplay is 1.2', () {
        expect(FiftyTypography.lineHeightDisplay, 1.2);
      });

      test('lineHeightTitle is 1.3', () {
        expect(FiftyTypography.lineHeightTitle, 1.3);
      });

      test('lineHeightBody is 1.5', () {
        expect(FiftyTypography.lineHeightBody, 1.5);
      });

      test('lineHeightLabel is 1.2', () {
        expect(FiftyTypography.lineHeightLabel, 1.2);
      });
    });

    group('Font Source', () {
      test('default fontSource is googleFonts', () {
        expect(FiftyTypography.fontSource, FontSource.googleFonts);
      });
    });

    group('Deprecated v1 Typography (backward compatibility)', () {
      test('fontFamilyHeadline still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyTypography.fontFamilyHeadline, 'Monument Extended');
      });

      test('fontFamilyMono still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyTypography.fontFamilyMono, 'JetBrains Mono');
      });

      test('ultrabold still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyTypography.ultrabold, FontWeight.w800);
      });

      test('hero still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyTypography.hero, 64);
      });

      test('display still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyTypography.display, 48);
      });

      test('section still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyTypography.section, 32);
      });

      test('body still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyTypography.body, 16);
      });

      test('mono still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyTypography.mono, 12);
      });

      test('tight still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyTypography.tight, -0.02);
      });

      test('standard still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyTypography.standard, 0.0);
      });

      test('displayLineHeight still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyTypography.displayLineHeight, 1.1);
      });

      test('headingLineHeight still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyTypography.headingLineHeight, 1.2);
      });

      test('bodyLineHeight still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyTypography.bodyLineHeight, 1.5);
      });

      test('codeLineHeight still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyTypography.codeLineHeight, 1.6);
      });
    });
  });
}
