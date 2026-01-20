import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyRadii', () {
    group('Radius Values (v2 Complete Scale)', () {
      test('none is 0px', () {
        expect(FiftyRadii.none, 0);
      });

      test('sm is 4px', () {
        expect(FiftyRadii.sm, 4);
      });

      test('md is 8px', () {
        expect(FiftyRadii.md, 8);
      });

      test('lg is 12px', () {
        expect(FiftyRadii.lg, 12);
      });

      test('xl is 16px', () {
        expect(FiftyRadii.xl, 16);
      });

      test('xxl is 24px', () {
        expect(FiftyRadii.xxl, 24);
      });

      test('xxxl is 32px', () {
        expect(FiftyRadii.xxxl, 32);
      });

      test('full is 9999px', () {
        expect(FiftyRadii.full, 9999);
      });
    });

    group('BorderRadius Objects (v2)', () {
      test('noneRadius is zero', () {
        expect(FiftyRadii.noneRadius, BorderRadius.zero);
      });

      test('smRadius uses sm value', () {
        expect(FiftyRadii.smRadius, BorderRadius.circular(4));
      });

      test('mdRadius uses md value', () {
        expect(FiftyRadii.mdRadius, BorderRadius.circular(8));
      });

      test('lgRadius uses lg value', () {
        expect(FiftyRadii.lgRadius, BorderRadius.circular(12));
      });

      test('xlRadius uses xl value', () {
        expect(FiftyRadii.xlRadius, BorderRadius.circular(16));
      });

      test('xxlRadius uses xxl value', () {
        expect(FiftyRadii.xxlRadius, BorderRadius.circular(24));
      });

      test('xxxlRadius uses xxxl value', () {
        expect(FiftyRadii.xxxlRadius, BorderRadius.circular(32));
      });

      test('fullRadius uses full value', () {
        expect(FiftyRadii.fullRadius, BorderRadius.circular(9999));
      });
    });

    group('Deprecated v1 Radii (backward compatibility)', () {
      test('standard still exists (maps to lg)', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyRadii.standard, 12);
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyRadii.standard, FiftyRadii.lg);
      });

      test('smooth still exists (maps to xxl)', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyRadii.smooth, 24);
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyRadii.smooth, FiftyRadii.xxl);
      });

      test('standardRadius still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyRadii.standardRadius, BorderRadius.circular(12));
      });

      test('smoothRadius still exists', () {
        // ignore: deprecated_member_use_from_same_package
        expect(FiftyRadii.smoothRadius, BorderRadius.circular(24));
      });
    });
  });
}
