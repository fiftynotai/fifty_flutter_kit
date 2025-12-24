import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyColorScheme', () {
    group('dark()', () {
      late ColorScheme colorScheme;

      setUp(() {
        colorScheme = FiftyColorScheme.dark();
      });

      test('brightness is Brightness.dark', () {
        expect(colorScheme.brightness, Brightness.dark);
      });

      test('primary is crimsonPulse', () {
        expect(colorScheme.primary, FiftyColors.crimsonPulse);
      });

      test('onPrimary is terminalWhite', () {
        expect(colorScheme.onPrimary, FiftyColors.terminalWhite);
      });

      test('surface is voidBlack', () {
        expect(colorScheme.surface, FiftyColors.voidBlack);
      });

      test('onSurface is terminalWhite', () {
        expect(colorScheme.onSurface, FiftyColors.terminalWhite);
      });

      test('secondary is hyperChrome', () {
        expect(colorScheme.secondary, FiftyColors.hyperChrome);
      });

      test('tertiary is igrisGreen', () {
        expect(colorScheme.tertiary, FiftyColors.igrisGreen);
      });

      test('error is FiftyColors.error', () {
        expect(colorScheme.error, FiftyColors.error);
      });

      test('surfaceContainerHighest is gunmetal', () {
        expect(colorScheme.surfaceContainerHighest, FiftyColors.gunmetal);
      });

      test('outline is border color', () {
        expect(colorScheme.outline, FiftyColors.border);
      });

      test('shadow is transparent (no shadows per FDL)', () {
        expect(colorScheme.shadow, Colors.transparent);
      });

      test('inverseSurface is terminalWhite', () {
        expect(colorScheme.inverseSurface, FiftyColors.terminalWhite);
      });

      test('onInverseSurface is voidBlack', () {
        expect(colorScheme.onInverseSurface, FiftyColors.voidBlack);
      });

      test('inversePrimary is crimsonPulse', () {
        expect(colorScheme.inversePrimary, FiftyColors.crimsonPulse);
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

      test('primary is crimsonPulse (brand maintained)', () {
        expect(colorScheme.primary, FiftyColors.crimsonPulse);
      });

      test('surface is terminalWhite', () {
        expect(colorScheme.surface, FiftyColors.terminalWhite);
      });

      test('onSurface is voidBlack', () {
        expect(colorScheme.onSurface, FiftyColors.voidBlack);
      });

      test('shadow is transparent (no shadows per FDL)', () {
        expect(colorScheme.shadow, Colors.transparent);
      });

      test('inverseSurface is voidBlack', () {
        expect(colorScheme.inverseSurface, FiftyColors.voidBlack);
      });

      test('onInverseSurface is terminalWhite', () {
        expect(colorScheme.onInverseSurface, FiftyColors.terminalWhite);
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
