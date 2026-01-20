import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('FiftyColorScheme', () {
    group('dark()', () {
      late ColorScheme colorScheme;

      setUp(() {
        colorScheme = FiftyColorScheme.dark();
      });

      test('brightness is Brightness.dark', () {
        expect(colorScheme.brightness, Brightness.dark);
      });

      test('primary is burgundy', () {
        expect(colorScheme.primary, FiftyColors.burgundy);
      });

      test('onPrimary is cream', () {
        expect(colorScheme.onPrimary, FiftyColors.cream);
      });

      test('surface is darkBurgundy', () {
        expect(colorScheme.surface, FiftyColors.darkBurgundy);
      });

      test('onSurface is cream', () {
        expect(colorScheme.onSurface, FiftyColors.cream);
      });

      test('secondary is slateGrey', () {
        expect(colorScheme.secondary, FiftyColors.slateGrey);
      });

      test('tertiary is hunterGreen', () {
        expect(colorScheme.tertiary, FiftyColors.hunterGreen);
      });

      test('error is burgundy', () {
        expect(colorScheme.error, FiftyColors.burgundy);
      });

      test('surfaceContainerHighest is surfaceDark', () {
        expect(colorScheme.surfaceContainerHighest, FiftyColors.surfaceDark);
      });

      test('outline is borderDark', () {
        expect(colorScheme.outline, FiftyColors.borderDark);
      });

      test('shadow is not transparent (shadows enabled in v2)', () {
        expect(colorScheme.shadow, isNot(Colors.transparent));
      });

      test('inverseSurface is cream', () {
        expect(colorScheme.inverseSurface, FiftyColors.cream);
      });

      test('onInverseSurface is darkBurgundy', () {
        expect(colorScheme.onInverseSurface, FiftyColors.darkBurgundy);
      });

      test('inversePrimary is burgundy', () {
        expect(colorScheme.inversePrimary, FiftyColors.burgundy);
      });

      test('all ColorScheme properties are non-null', () {
        expect(colorScheme.primary, isNotNull);
        expect(colorScheme.onPrimary, isNotNull);
        expect(colorScheme.secondary, isNotNull);
        expect(colorScheme.onSecondary, isNotNull);
        expect(colorScheme.tertiary, isNotNull);
        expect(colorScheme.onTertiary, isNotNull);
        expect(colorScheme.error, isNotNull);
        expect(colorScheme.onError, isNotNull);
        expect(colorScheme.surface, isNotNull);
        expect(colorScheme.onSurface, isNotNull);
      });
    });

    group('light()', () {
      late ColorScheme colorScheme;

      setUp(() {
        colorScheme = FiftyColorScheme.light();
      });

      test('brightness is Brightness.light', () {
        expect(colorScheme.brightness, Brightness.light);
      });

      test('primary is burgundy (brand maintained)', () {
        expect(colorScheme.primary, FiftyColors.burgundy);
      });

      test('surface is cream', () {
        expect(colorScheme.surface, FiftyColors.cream);
      });

      test('onSurface is darkBurgundy', () {
        expect(colorScheme.onSurface, FiftyColors.darkBurgundy);
      });

      test('shadow is not transparent (shadows enabled in v2)', () {
        expect(colorScheme.shadow, isNot(Colors.transparent));
      });

      test('inverseSurface is darkBurgundy', () {
        expect(colorScheme.inverseSurface, FiftyColors.darkBurgundy);
      });

      test('onInverseSurface is cream', () {
        expect(colorScheme.onInverseSurface, FiftyColors.cream);
      });

      test('all ColorScheme properties are non-null', () {
        expect(colorScheme.primary, isNotNull);
        expect(colorScheme.onPrimary, isNotNull);
        expect(colorScheme.secondary, isNotNull);
        expect(colorScheme.onSecondary, isNotNull);
        expect(colorScheme.error, isNotNull);
        expect(colorScheme.onError, isNotNull);
        expect(colorScheme.surface, isNotNull);
        expect(colorScheme.onSurface, isNotNull);
      });
    });
  });
}
