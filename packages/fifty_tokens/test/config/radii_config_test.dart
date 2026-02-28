import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyRadiiConfig', () {
    setUp(() => FiftyTokens.reset());

    group('defaults match FDL', () {
      test('radius value defaults', () {
        expect(FiftyRadii.none, 0);
        expect(FiftyRadii.sm, 4);
        expect(FiftyRadii.md, 8);
        expect(FiftyRadii.lg, 12);
        expect(FiftyRadii.xl, 16);
        expect(FiftyRadii.xxl, 24);
        expect(FiftyRadii.xxxl, 32);
        expect(FiftyRadii.full, 9999);
      });
    });

    group('override radius values', () {
      test('override sm', () {
        FiftyTokens.configure(
          radii: const FiftyRadiiConfig(sm: 6),
        );
        expect(FiftyRadii.sm, 6);
        // Others unchanged
        expect(FiftyRadii.md, 8);
        expect(FiftyRadii.lg, 12);
      });

      test('override multiple values', () {
        FiftyTokens.configure(
          radii: const FiftyRadiiConfig(
            sm: 6,
            md: 10,
            xl: 20,
          ),
        );
        expect(FiftyRadii.sm, 6);
        expect(FiftyRadii.md, 10);
        expect(FiftyRadii.xl, 20);
      });
    });

    group('BorderRadius getters recompute from overridden doubles', () {
      test('smRadius uses overridden sm value', () {
        FiftyTokens.configure(
          radii: const FiftyRadiiConfig(sm: 6),
        );
        expect(FiftyRadii.smRadius, BorderRadius.circular(6));
      });

      test('xlRadius uses overridden xl value', () {
        FiftyTokens.configure(
          radii: const FiftyRadiiConfig(xl: 20),
        );
        expect(FiftyRadii.xlRadius, BorderRadius.circular(20));
      });

      test('fullRadius uses overridden full value', () {
        FiftyTokens.configure(
          radii: const FiftyRadiiConfig(full: 100),
        );
        expect(FiftyRadii.fullRadius, BorderRadius.circular(100));
      });

      test('noneRadius uses overridden none value', () {
        FiftyTokens.configure(
          radii: const FiftyRadiiConfig(none: 2),
        );
        expect(FiftyRadii.noneRadius, BorderRadius.circular(2));
      });
    });

    group('reset', () {
      test('reset restores defaults', () {
        FiftyTokens.configure(
          radii: const FiftyRadiiConfig(
            sm: 6,
            md: 10,
            full: 100,
          ),
        );

        FiftyTokens.reset();

        expect(FiftyRadii.sm, 4);
        expect(FiftyRadii.md, 8);
        expect(FiftyRadii.full, 9999);
        expect(FiftyRadii.smRadius, BorderRadius.circular(4));
      });
    });
  });
}
