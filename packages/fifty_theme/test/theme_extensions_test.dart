import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyThemeExtension', () {
    group('standard()', () {
      late FiftyThemeExtension extension;

      setUp(() {
        extension = FiftyThemeExtension.standard();
      });

      group('Colors', () {
        test('igrisGreen is FiftyColors.igrisGreen', () {
          expect(extension.igrisGreen, FiftyColors.igrisGreen);
        });

        test('success is FiftyColors.success', () {
          expect(extension.success, FiftyColors.success);
        });

        test('warning is FiftyColors.warning', () {
          expect(extension.warning, FiftyColors.warning);
        });
      });

      group('Glows', () {
        test('focusGlow is not empty', () {
          expect(extension.focusGlow, isNotEmpty);
          expect(extension.focusGlow, isA<List<BoxShadow>>());
        });

        test('strongFocusGlow is not empty', () {
          expect(extension.strongFocusGlow, isNotEmpty);
          expect(extension.strongFocusGlow, isA<List<BoxShadow>>());
        });

        test('focusGlow equals FiftyElevation.focus', () {
          expect(extension.focusGlow, FiftyElevation.focus);
        });

        test('strongFocusGlow equals FiftyElevation.strongFocus', () {
          expect(extension.strongFocusGlow, FiftyElevation.strongFocus);
        });
      });

      group('Durations', () {
        test('instant is Duration.zero', () {
          expect(extension.instant, Duration.zero);
          expect(extension.instant, FiftyMotion.instant);
        });

        test('fast is 150ms', () {
          expect(extension.fast, const Duration(milliseconds: 150));
          expect(extension.fast, FiftyMotion.fast);
        });

        test('compiling is 300ms', () {
          expect(extension.compiling, const Duration(milliseconds: 300));
          expect(extension.compiling, FiftyMotion.compiling);
        });

        test('systemLoad is 800ms', () {
          expect(extension.systemLoad, const Duration(milliseconds: 800));
          expect(extension.systemLoad, FiftyMotion.systemLoad);
        });
      });

      group('Curves', () {
        test('standardCurve is FiftyMotion.standard', () {
          expect(extension.standardCurve, FiftyMotion.standard);
        });

        test('enterCurve is FiftyMotion.enter', () {
          expect(extension.enterCurve, FiftyMotion.enter);
        });

        test('exitCurve is FiftyMotion.exit', () {
          expect(extension.exitCurve, FiftyMotion.exit);
        });
      });
    });

    group('copyWith()', () {
      late FiftyThemeExtension original;

      setUp(() {
        original = FiftyThemeExtension.standard();
      });

      test('returns new instance with updated igrisGreen', () {
        const newColor = Colors.blue;
        final copied = original.copyWith(igrisGreen: newColor);

        expect(copied.igrisGreen, newColor);
        expect(copied.success, original.success);
        expect(copied.warning, original.warning);
      });

      test('returns new instance with updated success', () {
        const newColor = Colors.green;
        final copied = original.copyWith(success: newColor);

        expect(copied.success, newColor);
        expect(copied.igrisGreen, original.igrisGreen);
      });

      test('returns new instance with updated warning', () {
        const newColor = Colors.orange;
        final copied = original.copyWith(warning: newColor);

        expect(copied.warning, newColor);
        expect(copied.igrisGreen, original.igrisGreen);
      });

      test('returns new instance with updated fast duration', () {
        const newDuration = Duration(milliseconds: 200);
        final copied = original.copyWith(fast: newDuration);

        expect(copied.fast, newDuration);
        expect(copied.compiling, original.compiling);
      });

      test('returns new instance with updated compiling duration', () {
        const newDuration = Duration(milliseconds: 400);
        final copied = original.copyWith(compiling: newDuration);

        expect(copied.compiling, newDuration);
        expect(copied.fast, original.fast);
      });

      test('preserves all values when no parameters passed', () {
        final copied = original.copyWith();

        expect(copied.igrisGreen, original.igrisGreen);
        expect(copied.success, original.success);
        expect(copied.warning, original.warning);
        expect(copied.focusGlow, original.focusGlow);
        expect(copied.strongFocusGlow, original.strongFocusGlow);
        expect(copied.instant, original.instant);
        expect(copied.fast, original.fast);
        expect(copied.compiling, original.compiling);
        expect(copied.systemLoad, original.systemLoad);
        expect(copied.standardCurve, original.standardCurve);
        expect(copied.enterCurve, original.enterCurve);
        expect(copied.exitCurve, original.exitCurve);
      });
    });

    group('lerp()', () {
      late FiftyThemeExtension extensionA;
      late FiftyThemeExtension extensionB;

      setUp(() {
        extensionA = FiftyThemeExtension.standard();
        extensionB = FiftyThemeExtension(
          igrisGreen: Colors.blue,
          focusGlow: const [],
          strongFocusGlow: const [],
          instant: Duration.zero,
          fast: const Duration(milliseconds: 200),
          compiling: const Duration(milliseconds: 400),
          systemLoad: const Duration(milliseconds: 1000),
          standardCurve: Curves.linear,
          enterCurve: Curves.bounceIn,
          exitCurve: Curves.bounceOut,
          success: Colors.green,
          warning: Colors.orange,
        );
      });

      test('lerp at 0.0 returns values from this', () {
        final result = extensionA.lerp(extensionB, 0.0);

        expect(result.igrisGreen, extensionA.igrisGreen);
        expect(result.focusGlow, extensionA.focusGlow);
        expect(result.fast, extensionA.fast);
        expect(result.standardCurve, extensionA.standardCurve);
      });

      test('lerp at 1.0 returns values from other', () {
        final result = extensionA.lerp(extensionB, 1.0);

        expect(result.focusGlow, extensionB.focusGlow);
        expect(result.fast, extensionB.fast);
        expect(result.standardCurve, extensionB.standardCurve);
      });

      test('lerp at 0.5 transitions non-color values to other', () {
        final result = extensionA.lerp(extensionB, 0.5);

        // Non-color values switch at 0.5
        expect(result.fast, extensionB.fast);
        expect(result.standardCurve, extensionB.standardCurve);
      });

      test('lerp with null returns this', () {
        final result = extensionA.lerp(null, 0.5);

        expect(result.igrisGreen, extensionA.igrisGreen);
        expect(result.fast, extensionA.fast);
      });

      test('lerp interpolates colors correctly', () {
        final result = extensionA.lerp(extensionB, 0.5);

        // Colors are lerped
        expect(result.igrisGreen, isNot(extensionA.igrisGreen));
        expect(result.igrisGreen, isNot(extensionB.igrisGreen));
      });
    });

    group('Integration with ThemeData', () {
      test('can be retrieved from dark theme', () {
        final theme = FiftyTheme.dark();
        final extension = theme.extension<FiftyThemeExtension>();

        expect(extension, isNotNull);
        expect(extension!.igrisGreen, FiftyColors.igrisGreen);
      });

      test('can be retrieved from light theme', () {
        final theme = FiftyTheme.light();
        final extension = theme.extension<FiftyThemeExtension>();

        expect(extension, isNotNull);
        expect(extension!.igrisGreen, FiftyColors.igrisGreen);
      });
    });
  });
}
