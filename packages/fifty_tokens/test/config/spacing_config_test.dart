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

    group('override individual values', () {
      test('override base', () {
        FiftyTokens.configure(
          spacing: const FiftySpacingConfig(base: 8),
        );
        expect(FiftySpacing.base, 8);
        // Others unchanged
        expect(FiftySpacing.tight, 8);
        expect(FiftySpacing.lg, 16);
      });

      test('override multiple values', () {
        FiftyTokens.configure(
          spacing: const FiftySpacingConfig(
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
          spacing: const FiftySpacingConfig(
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
