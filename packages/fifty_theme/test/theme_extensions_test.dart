import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('FiftyThemeExtension', () {
    group('dark()', () {
      late FiftyThemeExtension extension;

      setUp(() {
        extension = FiftyThemeExtension.dark();
      });

      group('Colors', () {
        test('accent is FiftyColors.powderBlush in dark mode', () {
          expect(extension.accent, FiftyColors.powderBlush);
        });

        test('success is FiftyColors.hunterGreen', () {
          expect(extension.success, FiftyColors.hunterGreen);
        });

        test('warning is FiftyColors.warning', () {
          expect(extension.warning, FiftyColors.warning);
        });

        test('info is FiftyColors.slateGrey', () {
          expect(extension.info, FiftyColors.slateGrey);
        });
      });

      group('Shadows', () {
        test('shadowSm is not empty', () {
          expect(extension.shadowSm, isNotEmpty);
          expect(extension.shadowSm, isA<List<BoxShadow>>());
        });

        test('shadowMd is not empty', () {
          expect(extension.shadowMd, isNotEmpty);
          expect(extension.shadowMd, isA<List<BoxShadow>>());
        });

        test('shadowLg is not empty', () {
          expect(extension.shadowLg, isNotEmpty);
          expect(extension.shadowLg, isA<List<BoxShadow>>());
        });

        test('shadowPrimary is not empty', () {
          expect(extension.shadowPrimary, isNotEmpty);
          expect(extension.shadowPrimary, isA<List<BoxShadow>>());
        });

        test('shadowGlow is not empty in dark mode', () {
          expect(extension.shadowGlow, isNotEmpty);
          expect(extension.shadowGlow, isA<List<BoxShadow>>());
        });

        test('shadowSm equals FiftyShadows.sm', () {
          expect(extension.shadowSm, FiftyShadows.sm);
        });

        test('shadowMd equals FiftyShadows.md', () {
          expect(extension.shadowMd, FiftyShadows.md);
        });

        test('shadowLg equals FiftyShadows.lg', () {
          expect(extension.shadowLg, FiftyShadows.lg);
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

    group('light()', () {
      late FiftyThemeExtension extension;

      setUp(() {
        extension = FiftyThemeExtension.light();
      });

      test('accent is FiftyColors.burgundy in light mode', () {
        expect(extension.accent, FiftyColors.burgundy);
      });

      test('shadowGlow is empty in light mode', () {
        expect(extension.shadowGlow, isEmpty);
      });
    });

    group('copyWith()', () {
      late FiftyThemeExtension original;

      setUp(() {
        original = FiftyThemeExtension.dark();
      });

      test('returns new instance with updated accent', () {
        const newColor = Colors.blue;
        final copied = original.copyWith(accent: newColor);

        expect(copied.accent, newColor);
        expect(copied.success, original.success);
        expect(copied.warning, original.warning);
      });

      test('returns new instance with updated success', () {
        const newColor = Colors.green;
        final copied = original.copyWith(success: newColor);

        expect(copied.success, newColor);
        expect(copied.accent, original.accent);
      });

      test('returns new instance with updated warning', () {
        const newColor = Colors.orange;
        final copied = original.copyWith(warning: newColor);

        expect(copied.warning, newColor);
        expect(copied.accent, original.accent);
      });

      test('returns new instance with updated info', () {
        const newColor = Colors.blueGrey;
        final copied = original.copyWith(info: newColor);

        expect(copied.info, newColor);
        expect(copied.accent, original.accent);
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

        expect(copied.accent, original.accent);
        expect(copied.success, original.success);
        expect(copied.warning, original.warning);
        expect(copied.info, original.info);
        expect(copied.shadowSm, original.shadowSm);
        expect(copied.shadowMd, original.shadowMd);
        expect(copied.shadowLg, original.shadowLg);
        expect(copied.shadowPrimary, original.shadowPrimary);
        expect(copied.shadowGlow, original.shadowGlow);
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
        extensionA = FiftyThemeExtension.dark();
        extensionB = const FiftyThemeExtension(
          accent: Colors.blue,
          shadowSm: [],
          shadowMd: [],
          shadowLg: [],
          shadowPrimary: [],
          shadowGlow: [],
          instant: Duration.zero,
          fast: Duration(milliseconds: 200),
          compiling: Duration(milliseconds: 400),
          systemLoad: Duration(milliseconds: 1000),
          standardCurve: Curves.linear,
          enterCurve: Curves.bounceIn,
          exitCurve: Curves.bounceOut,
          success: Colors.green,
          warning: Colors.orange,
          info: Colors.grey,
        );
      });

      test('lerp at 0.0 returns values from this', () {
        final result = extensionA.lerp(extensionB, 0.0);

        expect(result.accent, extensionA.accent);
        expect(result.shadowSm, extensionA.shadowSm);
        expect(result.fast, extensionA.fast);
        expect(result.standardCurve, extensionA.standardCurve);
      });

      test('lerp at 1.0 returns values from other', () {
        final result = extensionA.lerp(extensionB, 1.0);

        expect(result.shadowSm, extensionB.shadowSm);
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

        expect(result.accent, extensionA.accent);
        expect(result.fast, extensionA.fast);
      });

      test('lerp interpolates colors correctly', () {
        final result = extensionA.lerp(extensionB, 0.5);

        // Colors are lerped
        expect(result.accent, isNot(extensionA.accent));
        expect(result.accent, isNot(extensionB.accent));
      });
    });

    // Note: Integration tests with FiftyTheme.dark()/light() are skipped because
    // GoogleFonts requires network access to load fonts during tests.
    // The functionality is verified in widget tests with proper setup.
    group('Integration with ThemeData', () {
      test('dark extension has correct accent color', () {
        // Test the extension factory directly (without FiftyTheme which uses GoogleFonts)
        final extension = FiftyThemeExtension.dark();
        expect(extension.accent, FiftyColors.powderBlush);
      });

      test('light extension has correct accent color', () {
        // Test the extension factory directly (without FiftyTheme which uses GoogleFonts)
        final extension = FiftyThemeExtension.light();
        expect(extension.accent, FiftyColors.burgundy);
      });
    });
  });
}
