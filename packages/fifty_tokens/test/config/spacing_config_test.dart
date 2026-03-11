import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftySpacingConfig', () {
    setUp(() => FiftyTokens.reset());

    group('defaults match FDL', () {
      test('base unit defaults', () {
        expect(FiftySpacing.base, 4);
        expect(FiftySpacing.tight, 8);
        expect(FiftySpacing.standard, 12);
      });

      test('spacing scale defaults', () {
        expect(FiftySpacing.xxs, 2);
        expect(FiftySpacing.xs, 4);
        expect(FiftySpacing.sm, 8);
        expect(FiftySpacing.md, 12);
        expect(FiftySpacing.lg, 16);
        expect(FiftySpacing.xl, 20);
        expect(FiftySpacing.xxl, 24);
        expect(FiftySpacing.xxxl, 32);
        expect(FiftySpacing.huge, 40);
        expect(FiftySpacing.massive, 48);
      });

      test('gutter defaults', () {
        expect(FiftySpacing.gutterDesktop, 24);
        expect(FiftySpacing.gutterTablet, 16);
        expect(FiftySpacing.gutterMobile, 12);
      });
    });

    group('fromMap()', () {
      final fallback = FiftyPreset.fdlV2.spacing;

      test('full valid map overrides all fields', () {
        final config = FiftySpacingConfig.fromMap(
          {
            'base': 8,
            'tight': 16,
            'standard': 24,
            'xxs': 4,
            'xs': 8,
            'sm': 16,
            'md': 24,
            'lg': 32,
            'xl': 40,
            'xxl': 48,
            'xxxl': 64,
            'huge': 80,
            'massive': 96,
            'gutterDesktop': 48,
            'gutterTablet': 32,
            'gutterMobile': 24,
          },
          fallback: fallback,
        );

        expect(config.base, 8);
        expect(config.tight, 16);
        expect(config.standard, 24);
        expect(config.xxs, 4);
        expect(config.xs, 8);
        expect(config.sm, 16);
        expect(config.md, 24);
        expect(config.lg, 32);
        expect(config.xl, 40);
        expect(config.xxl, 48);
        expect(config.xxxl, 64);
        expect(config.huge, 80);
        expect(config.massive, 96);
        expect(config.gutterDesktop, 48);
        expect(config.gutterTablet, 32);
        expect(config.gutterMobile, 24);
      });

      test('empty map returns all fallback values', () {
        final config = FiftySpacingConfig.fromMap({}, fallback: fallback);

        expect(config.base, fallback.base);
        expect(config.tight, fallback.tight);
        expect(config.lg, fallback.lg);
        expect(config.gutterDesktop, fallback.gutterDesktop);
      });

      test('partial map uses fallback for missing keys', () {
        final config = FiftySpacingConfig.fromMap(
          {'base': 8, 'lg': 32},
          fallback: fallback,
        );

        expect(config.base, 8);
        expect(config.lg, 32);
        expect(config.tight, fallback.tight);
        expect(config.gutterDesktop, fallback.gutterDesktop);
      });

      test('non-num value throws TypeError', () {
        expect(
          () => FiftySpacingConfig.fromMap(
            {'base': 'abc'},
            fallback: fallback,
          ),
          throwsA(isA<TypeError>()),
        );
      });

      test('int values coerce to double', () {
        final config = FiftySpacingConfig.fromMap(
          {'base': 10},
          fallback: fallback,
        );

        expect(config.base, 10.0);
      });
    });

    group('override individual values', () {
      test('override base', () {
        FiftyTokens.configure(
          spacing: FiftyPreset.fdlV2.spacing.copyWith(base: 8),
        );
        expect(FiftySpacing.base, 8);
        // Others unchanged
        expect(FiftySpacing.tight, 8);
        expect(FiftySpacing.lg, 16);
      });

      test('override multiple values', () {
        FiftyTokens.configure(
          spacing: FiftyPreset.fdlV2.spacing.copyWith(
            tight: 4,
            standard: 8,
            gutterDesktop: 32,
          ),
        );
        expect(FiftySpacing.tight, 4);
        expect(FiftySpacing.standard, 8);
        expect(FiftySpacing.gutterDesktop, 32);
        // Others unchanged
        expect(FiftySpacing.base, 4);
        expect(FiftySpacing.lg, 16);
      });
    });

    group('reset', () {
      test('reset restores defaults', () {
        FiftyTokens.configure(
          spacing: FiftyPreset.fdlV2.spacing.copyWith(
            base: 8,
            tight: 4,
            gutterDesktop: 32,
          ),
        );

        FiftyTokens.reset();

        expect(FiftySpacing.base, 4);
        expect(FiftySpacing.tight, 8);
        expect(FiftySpacing.gutterDesktop, 24);
      });
    });
  });
}
