import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftySpacing', () {
    group('Base Unit', () {
      test('base is 4px', () {
        expect(FiftySpacing.base, 4);
      });
    });

    group('Primary Gaps (FDL tight density)', () {
      test('tight is 8px', () {
        expect(FiftySpacing.tight, 8);
      });

      test('standard is 12px', () {
        expect(FiftySpacing.standard, 12);
      });
    });

    group('Spacing Scale (multiples of base)', () {
      test('xs is 1x base (4px)', () {
        expect(FiftySpacing.xs, FiftySpacing.base * 1);
      });

      test('sm is 2x base (8px)', () {
        expect(FiftySpacing.sm, FiftySpacing.base * 2);
      });

      test('md is 3x base (12px)', () {
        expect(FiftySpacing.md, FiftySpacing.base * 3);
      });

      test('lg is 4x base (16px)', () {
        expect(FiftySpacing.lg, FiftySpacing.base * 4);
      });

      test('xl is 5x base (20px)', () {
        expect(FiftySpacing.xl, FiftySpacing.base * 5);
      });

      test('xxl is 6x base (24px)', () {
        expect(FiftySpacing.xxl, FiftySpacing.base * 6);
      });

      test('xxxl is 8x base (32px)', () {
        expect(FiftySpacing.xxxl, FiftySpacing.base * 8);
      });

      test('huge is 10x base (40px)', () {
        expect(FiftySpacing.huge, FiftySpacing.base * 10);
      });

      test('massive is 12x base (48px)', () {
        expect(FiftySpacing.massive, FiftySpacing.base * 12);
      });
    });

    group('Responsive Gutters', () {
      test('gutterDesktop is 24px', () {
        expect(FiftySpacing.gutterDesktop, 24);
      });

      test('gutterTablet is 16px', () {
        expect(FiftySpacing.gutterTablet, 16);
      });

      test('gutterMobile is 12px', () {
        expect(FiftySpacing.gutterMobile, 12);
      });
    });
  });
}
