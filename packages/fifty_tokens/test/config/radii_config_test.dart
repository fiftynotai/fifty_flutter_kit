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

    group('fromMap()', () {
      final fallback = FiftyPreset.fdlV2.radii;

      test('full valid map overrides all fields', () {
        final config = FiftyRadiiConfig.fromMap(
          {
            'none': 1,
            'sm': 6,
            'md': 10,
            'lg': 14,
            'xl': 20,
            'xxl': 28,
            'xxxl': 36,
            'full': 999,
          },
          fallback: fallback,
        );

        expect(config.none, 1);
        expect(config.sm, 6);
        expect(config.md, 10);
        expect(config.lg, 14);
        expect(config.xl, 20);
        expect(config.xxl, 28);
        expect(config.xxxl, 36);
        expect(config.full, 999);
      });

      test('empty map returns all fallback values', () {
        final config = FiftyRadiiConfig.fromMap({}, fallback: fallback);

        expect(config.none, fallback.none);
        expect(config.sm, fallback.sm);
        expect(config.md, fallback.md);
        expect(config.full, fallback.full);
      });

      test('partial map uses fallback for missing keys', () {
        final config = FiftyRadiiConfig.fromMap(
          {'sm': 6, 'xl': 20},
          fallback: fallback,
        );

        expect(config.sm, 6);
        expect(config.xl, 20);
        expect(config.md, fallback.md);
        expect(config.full, fallback.full);
      });

      test('non-num value throws TypeError', () {
        expect(
          () => FiftyRadiiConfig.fromMap(
            {'sm': 'abc'},
            fallback: fallback,
          ),
          throwsA(isA<TypeError>()),
        );
      });
    });

    group('override radius values', () {
      test('override sm', () {
        FiftyTokens.configure(
          radii: FiftyPreset.fdlV2.radii.copyWith(sm: 6),
        );
        expect(FiftyRadii.sm, 6);
        // Others unchanged
        expect(FiftyRadii.md, 8);
        expect(FiftyRadii.lg, 12);
      });

      test('override multiple values', () {
        FiftyTokens.configure(
          radii: FiftyPreset.fdlV2.radii.copyWith(
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
          radii: FiftyPreset.fdlV2.radii.copyWith(sm: 6),
        );
        expect(FiftyRadii.smRadius, BorderRadius.circular(6));
      });

      test('xlRadius uses overridden xl value', () {
        FiftyTokens.configure(
          radii: FiftyPreset.fdlV2.radii.copyWith(xl: 20),
        );
        expect(FiftyRadii.xlRadius, BorderRadius.circular(20));
      });

      test('fullRadius uses overridden full value', () {
        FiftyTokens.configure(
          radii: FiftyPreset.fdlV2.radii.copyWith(full: 100),
        );
        expect(FiftyRadii.fullRadius, BorderRadius.circular(100));
      });

      test('noneRadius uses overridden none value', () {
        FiftyTokens.configure(
          radii: FiftyPreset.fdlV2.radii.copyWith(none: 2),
        );
        expect(FiftyRadii.noneRadius, BorderRadius.circular(2));
      });
    });

    group('reset', () {
      test('reset restores defaults', () {
        FiftyTokens.configure(
          radii: FiftyPreset.fdlV2.radii.copyWith(
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
