import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FiftyColorScheme', () {
    setUp(() => FiftyTokens.reset());

    group('dark()', () {
      late ColorScheme colorScheme;

      setUp(() {
        FiftyTokens.reset();
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

    group('dark() parameterized overrides', () {
      setUp(() => FiftyTokens.reset());

      test('primary override is applied', () {
        const custom = Colors.blue;
        final cs = FiftyColorScheme.dark(primary: custom);
        expect(cs.primary, custom);
        expect(cs.primaryContainer, custom.withValues(alpha: 0.2));
        expect(cs.inversePrimary, custom);
      });

      test('onPrimary override is applied', () {
        const custom = Colors.black;
        final cs = FiftyColorScheme.dark(onPrimary: custom);
        expect(cs.onPrimary, custom);
        expect(cs.onPrimaryContainer, custom);
      });

      test('secondary override is applied', () {
        const custom = Colors.green;
        final cs = FiftyColorScheme.dark(secondary: custom);
        expect(cs.secondary, custom);
        expect(cs.secondaryContainer, custom.withValues(alpha: 0.2));
      });

      test('surface override is applied', () {
        const custom = Colors.grey;
        final cs = FiftyColorScheme.dark(surface: custom);
        expect(cs.surface, custom);
      });

      test('onSurface override is applied', () {
        const custom = Colors.white;
        final cs = FiftyColorScheme.dark(onSurface: custom);
        expect(cs.onSurface, custom);
        expect(cs.inverseSurface, custom);
      });

      test('error override is applied', () {
        const custom = Colors.red;
        final cs = FiftyColorScheme.dark(error: custom);
        expect(cs.error, custom);
        expect(cs.errorContainer, custom.withValues(alpha: 0.2));
      });

      test('surfaceContainerHighest override is applied', () {
        const custom = Color(0xFF333333);
        final cs = FiftyColorScheme.dark(surfaceContainerHighest: custom);
        expect(cs.surfaceContainerHighest, custom);
      });

      test('non-overridden fields use FDL defaults', () {
        final cs = FiftyColorScheme.dark(primary: Colors.blue);
        // secondary should still be FDL default
        expect(cs.secondary, FiftyColors.secondary);
        // surface should still be FDL default
        expect(cs.surface, FiftyColors.darkBurgundy);
      });
    });

    group('light()', () {
      late ColorScheme colorScheme;

      setUp(() {
        FiftyTokens.reset();
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

    group('light() parameterized overrides', () {
      setUp(() => FiftyTokens.reset());

      test('primary override is applied', () {
        const custom = Colors.blue;
        final cs = FiftyColorScheme.light(primary: custom);
        expect(cs.primary, custom);
        expect(cs.primaryContainer, custom.withValues(alpha: 0.15));
        expect(cs.onPrimaryContainer, custom);
        expect(cs.inversePrimary, custom);
      });

      test('surface override is applied', () {
        const custom = Colors.white;
        final cs = FiftyColorScheme.light(surface: custom);
        expect(cs.surface, custom);
        expect(cs.onInverseSurface, custom);
      });

      test('non-overridden fields use FDL defaults', () {
        final cs = FiftyColorScheme.light(primary: Colors.blue);
        expect(cs.secondary, FiftyColors.secondary);
        expect(cs.surface, FiftyColors.cream);
      });
    });

    group('token configuration cascading', () {
      setUp(() => FiftyTokens.reset());

      test('configured primary token cascades to color scheme', () {
        const customPrimary = Color(0xFF0000FF);
        FiftyTokens.configure(
          colors: const FiftyColorConfig(primary: customPrimary),
        );

        final cs = FiftyColorScheme.dark();
        expect(cs.primary, customPrimary);

        FiftyTokens.reset();
      });

      test('configured secondary token cascades to color scheme', () {
        const customSecondary = Color(0xFF00FF00);
        FiftyTokens.configure(
          colors: const FiftyColorConfig(secondary: customSecondary),
        );

        final cs = FiftyColorScheme.dark();
        expect(cs.secondary, customSecondary);
        expect(cs.onSurfaceVariant, customSecondary);

        FiftyTokens.reset();
      });

      test('explicit parameter overrides configured token', () {
        const configPrimary = Color(0xFF0000FF);
        const paramPrimary = Color(0xFFFF0000);
        FiftyTokens.configure(
          colors: const FiftyColorConfig(primary: configPrimary),
        );

        final cs = FiftyColorScheme.dark(primary: paramPrimary);
        expect(cs.primary, paramPrimary);

        FiftyTokens.reset();
      });
    });
  });
}
