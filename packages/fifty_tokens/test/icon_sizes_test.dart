import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyIconSizes', () {
    setUp(() => FiftyTokens.reset());

    group('defaults', () {
      test('sm is 16', () {
        expect(FiftyIconSizes.sm, 16);
      });

      test('md is 20', () {
        expect(FiftyIconSizes.md, 20);
      });

      test('lg is 24', () {
        expect(FiftyIconSizes.lg, 24);
      });

      test('xl is 36', () {
        expect(FiftyIconSizes.xl, 36);
      });

      test('xxl is 44', () {
        expect(FiftyIconSizes.xxl, 44);
      });

      test('hero is 48', () {
        expect(FiftyIconSizes.hero, 48);
      });
    });

    group('custom config', () {
      test('configure with custom values updates getters', () {
        FiftyTokens.configure(
          iconSizes: const FiftyIconSizesConfig(
            sm: 12,
            md: 16,
            lg: 20,
            xl: 32,
            xxl: 40,
            hero: 56,
          ),
        );

        expect(FiftyIconSizes.sm, 12);
        expect(FiftyIconSizes.md, 16);
        expect(FiftyIconSizes.lg, 20);
        expect(FiftyIconSizes.xl, 32);
        expect(FiftyIconSizes.xxl, 40);
        expect(FiftyIconSizes.hero, 56);
      });

      test('reset restores defaults', () {
        FiftyTokens.configure(
          iconSizes: const FiftyIconSizesConfig(
            sm: 10,
            md: 14,
            lg: 18,
            xl: 28,
            xxl: 36,
            hero: 64,
          ),
        );

        FiftyTokens.reset();

        expect(FiftyIconSizes.sm, 16);
        expect(FiftyIconSizes.md, 20);
        expect(FiftyIconSizes.lg, 24);
        expect(FiftyIconSizes.xl, 36);
        expect(FiftyIconSizes.xxl, 44);
        expect(FiftyIconSizes.hero, 48);
      });
    });
  });
}
