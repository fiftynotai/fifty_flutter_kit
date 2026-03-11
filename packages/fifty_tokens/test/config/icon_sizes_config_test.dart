import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyIconSizesConfig', () {
    setUp(() => FiftyTokens.reset());

    group('construction', () {
      test('stores all 6 fields', () {
        const config = FiftyIconSizesConfig(
          sm: 16,
          md: 20,
          lg: 24,
          xl: 36,
          xxl: 44,
          hero: 48,
        );

        expect(config.sm, 16);
        expect(config.md, 20);
        expect(config.lg, 24);
        expect(config.xl, 36);
        expect(config.xxl, 44);
        expect(config.hero, 48);
      });
    });

    group('fromMap()', () {
      const fallback = FiftyIconSizesConfig(
        sm: 16,
        md: 20,
        lg: 24,
        xl: 36,
        xxl: 44,
        hero: 48,
      );

      test('full map overrides all fields', () {
        final config = FiftyIconSizesConfig.fromMap(
          {
            'sm': 12.0,
            'md': 16.0,
            'lg': 20.0,
            'xl': 32.0,
            'xxl': 40.0,
            'hero': 56.0,
          },
          fallback: fallback,
        );

        expect(config.sm, 12);
        expect(config.md, 16);
        expect(config.lg, 20);
        expect(config.xl, 32);
        expect(config.xxl, 40);
        expect(config.hero, 56);
      });

      test('empty map returns all fallback values', () {
        final config = FiftyIconSizesConfig.fromMap({}, fallback: fallback);

        expect(config.sm, fallback.sm);
        expect(config.md, fallback.md);
        expect(config.lg, fallback.lg);
        expect(config.xl, fallback.xl);
        expect(config.xxl, fallback.xxl);
        expect(config.hero, fallback.hero);
      });

      test('partial map uses fallback for missing keys', () {
        final config = FiftyIconSizesConfig.fromMap(
          {'sm': 10.0, 'hero': 64.0},
          fallback: fallback,
        );

        expect(config.sm, 10);
        expect(config.md, fallback.md);
        expect(config.lg, fallback.lg);
        expect(config.xl, fallback.xl);
        expect(config.xxl, fallback.xxl);
        expect(config.hero, 64);
      });

      test('int values coerce to double', () {
        final config = FiftyIconSizesConfig.fromMap(
          {'sm': 14},
          fallback: fallback,
        );

        expect(config.sm, 14.0);
      });
    });

    group('copyWith()', () {
      const config = FiftyIconSizesConfig(
        sm: 16,
        md: 20,
        lg: 24,
        xl: 36,
        xxl: 44,
        hero: 48,
      );

      test('replaces one field', () {
        final copy = config.copyWith(sm: 12);

        expect(copy.sm, 12);
        expect(copy.md, 20);
        expect(copy.lg, 24);
        expect(copy.xl, 36);
        expect(copy.xxl, 44);
        expect(copy.hero, 48);
      });

      test('no-args returns equivalent', () {
        final copy = config.copyWith();

        expect(copy.sm, config.sm);
        expect(copy.md, config.md);
        expect(copy.lg, config.lg);
        expect(copy.xl, config.xl);
        expect(copy.xxl, config.xxl);
        expect(copy.hero, config.hero);
      });
    });
  });
}
