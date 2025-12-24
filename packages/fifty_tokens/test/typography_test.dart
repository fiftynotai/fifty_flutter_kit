import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyTypography', () {
    group('Font Families', () {
      test('fontFamilyHeadline is Monument Extended', () {
        expect(FiftyTypography.fontFamilyHeadline, 'Monument Extended');
      });

      test('fontFamilyMono is JetBrains Mono', () {
        expect(FiftyTypography.fontFamilyMono, 'JetBrains Mono');
      });
    });

    group('Font Weights', () {
      test('regular is w400', () {
        expect(FiftyTypography.regular, FontWeight.w400);
      });

      test('medium is w500', () {
        expect(FiftyTypography.medium, FontWeight.w500);
      });

      test('ultrabold is w800', () {
        expect(FiftyTypography.ultrabold, FontWeight.w800);
      });
    });

    group('Type Scale (FDL Brand Sheet)', () {
      test('hero is 64px', () {
        expect(FiftyTypography.hero, 64);
      });

      test('display is 48px', () {
        expect(FiftyTypography.display, 48);
      });

      test('section is 32px', () {
        expect(FiftyTypography.section, 32);
      });

      test('body is 16px', () {
        expect(FiftyTypography.body, 16);
      });

      test('mono is 12px', () {
        expect(FiftyTypography.mono, 12);
      });
    });

    group('Letter Spacing', () {
      test('tight is -2%', () {
        expect(FiftyTypography.tight, -0.02);
      });

      test('standard is 0%', () {
        expect(FiftyTypography.standard, 0.0);
      });
    });

    group('Line Heights', () {
      test('displayLineHeight is 1.1', () {
        expect(FiftyTypography.displayLineHeight, 1.1);
      });

      test('headingLineHeight is 1.2', () {
        expect(FiftyTypography.headingLineHeight, 1.2);
      });

      test('bodyLineHeight is 1.5', () {
        expect(FiftyTypography.bodyLineHeight, 1.5);
      });

      test('codeLineHeight is 1.6', () {
        expect(FiftyTypography.codeLineHeight, 1.6);
      });
    });
  });
}
