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

      test('primary is FDL primary', () {
        expect(colorScheme.primary, FiftyColors.primary);
      });

      test('onPrimary is background', () {
        expect(colorScheme.onPrimary, FiftyColors.background);
      });

      test('surface is backgroundDark', () {
        expect(colorScheme.surface, FiftyColors.backgroundDark);
      });

      test('onSurface is background', () {
        expect(colorScheme.onSurface, FiftyColors.background);
      });

      test('secondary is FDL secondary', () {
        expect(colorScheme.secondary, FiftyColors.secondary);
      });

      test('tertiary is success', () {
        expect(colorScheme.tertiary, FiftyColors.success);
      });

      test('error is FDL error', () {
        expect(colorScheme.error, FiftyColors.primary);
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

      test('inverseSurface is background', () {
        expect(colorScheme.inverseSurface, FiftyColors.background);
      });

      test('onInverseSurface is backgroundDark', () {
        expect(colorScheme.onInverseSurface, FiftyColors.backgroundDark);
      });

      test('inversePrimary is primary', () {
        expect(colorScheme.inversePrimary, FiftyColors.primary);
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
        expect(cs.surface, FiftyColors.backgroundDark);
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

      test('primary is FDL primary (brand maintained)', () {
        expect(colorScheme.primary, FiftyColors.primary);
      });

      test('surface is background', () {
        expect(colorScheme.surface, FiftyColors.background);
      });

      test('onSurface is backgroundDark', () {
        expect(colorScheme.onSurface, FiftyColors.backgroundDark);
      });

      test('shadow is not transparent (shadows enabled in v2)', () {
        expect(colorScheme.shadow, isNot(Colors.transparent));
      });

      test('inverseSurface is backgroundDark', () {
        expect(colorScheme.inverseSurface, FiftyColors.backgroundDark);
      });

      test('onInverseSurface is background', () {
        expect(colorScheme.onInverseSurface, FiftyColors.background);
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
        expect(cs.surface, FiftyColors.background);
      });
    });

    group('token configuration cascading', () {
      setUp(() => FiftyTokens.reset());

      test('configured primary token cascades to color scheme', () {
        const customPrimary = Color(0xFF0000FF);
        FiftyTokens.configure(
          colors: FiftyPreset.fdlV2.colors.copyWith(primary: customPrimary),
        );

        final cs = FiftyColorScheme.dark();
        expect(cs.primary, customPrimary);

        FiftyTokens.reset();
      });

      test('configured secondary token cascades to color scheme', () {
        const customSecondary = Color(0xFF00FF00);
        FiftyTokens.configure(
          colors: FiftyPreset.fdlV2.colors.copyWith(secondary: customSecondary),
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
          colors: FiftyPreset.fdlV2.colors.copyWith(primary: configPrimary),
        );

        final cs = FiftyColorScheme.dark(primary: paramPrimary);
        expect(cs.primary, paramPrimary);

        FiftyTokens.reset();
      });
    });
  });
}
