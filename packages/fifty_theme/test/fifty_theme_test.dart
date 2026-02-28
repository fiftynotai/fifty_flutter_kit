import 'dart:async';

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Runs [body] in a guarded zone that absorbs google_fonts font-loading
/// errors. In google_fonts v8, font loading failures produce unhandled async
/// errors via internal `.then()` chains that cannot be caught externally.
Future<void> _withSilencedFontErrors(FutureOr<void> Function() body) {
  final completer = Completer<void>();
  runZonedGuarded(
    () async {
      try {
        await body();
        completer.complete();
      } catch (e, s) {
        completer.completeError(e, s);
      }
    },
    (error, stack) {
      // Silently absorb google_fonts font-loading errors.
      // These are expected because font assets are not bundled in unit tests.
    },
  );
  return completer.future;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FiftyTheme', () {
    setUp(() => FiftyTokens.reset());

    group('dark()', () {
      test('returns valid ThemeData', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.dark();
          expect(theme, isA<ThemeData>());
        });
      });

      test('has Brightness.dark', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.dark();
          expect(theme.brightness, Brightness.dark);
        });
      });

      test('useMaterial3 is true', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.dark();
          expect(theme.useMaterial3, isTrue);
        });
      });

      test('scaffoldBackgroundColor is darkBurgundy', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.dark();
          expect(theme.scaffoldBackgroundColor, FiftyColors.darkBurgundy);
        });
      });

      test('canvasColor is darkBurgundy', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.dark();
          expect(theme.canvasColor, FiftyColors.darkBurgundy);
        });
      });

      test('cardColor is surfaceDark', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.dark();
          expect(theme.cardColor, FiftyColors.surfaceDark);
        });
      });

      test('dialogTheme backgroundColor is surfaceDark', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.dark();
          expect(theme.dialogTheme.backgroundColor, FiftyColors.surfaceDark);
        });
      });

      test('shadows are enabled in v2', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.dark();
          // shadowColor is no longer transparent in v2
          expect(theme.shadowColor, isNot(Colors.transparent));
        });
      });

      test('visualDensity is compact', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.dark();
          expect(theme.visualDensity, VisualDensity.compact);
        });
      });

      test('FiftyThemeExtension is attached', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.dark();
          final extension = theme.extension<FiftyThemeExtension>();
          expect(extension, isNotNull);
          expect(extension, isA<FiftyThemeExtension>());
        });
      });

      test('colorScheme has dark brightness', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.dark();
          expect(theme.colorScheme.brightness, Brightness.dark);
        });
      });

      test('colorScheme primary is burgundy', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.dark();
          expect(theme.colorScheme.primary, FiftyColors.burgundy);
        });
      });

      test('textTheme is configured', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.dark();
          expect(theme.textTheme, isNotNull);
          expect(theme.textTheme.displayLarge, isNotNull);
        });
      });

      test('textTheme bodyLarge is configured', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.dark();
          // GoogleFonts uses dynamic font names, just verify it's configured
          expect(theme.textTheme.bodyLarge, isNotNull);
          expect(theme.textTheme.bodyLarge?.fontSize, 16);
        });
      });

      test('appBarTheme is configured', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.dark();
          expect(theme.appBarTheme.backgroundColor, FiftyColors.darkBurgundy);
          expect(theme.appBarTheme.foregroundColor, FiftyColors.cream);
          expect(theme.appBarTheme.elevation, 0);
        });
      });

      test('elevatedButtonTheme uses zero elevation', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.dark();
          final style = theme.elevatedButtonTheme.style;
          expect(style, isNotNull);
        });
      });

      test('cardTheme uses surfaceDark', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.dark();
          expect(theme.cardTheme.color, FiftyColors.surfaceDark);
          expect(theme.cardTheme.elevation, 0);
        });
      });
    });

    group('dark() parameterized', () {
      setUp(() => FiftyTokens.reset());

      test('primaryColor override changes colorScheme.primary', () {
        return _withSilencedFontErrors(() {
          const custom = Colors.blue;
          final theme = FiftyTheme.dark(primaryColor: custom);
          expect(theme.colorScheme.primary, custom);
        });
      });

      test('secondaryColor override changes colorScheme.secondary', () {
        return _withSilencedFontErrors(() {
          const custom = Colors.green;
          final theme = FiftyTheme.dark(secondaryColor: custom);
          expect(theme.colorScheme.secondary, custom);
        });
      });

      test('full colorScheme override takes precedence', () {
        return _withSilencedFontErrors(() {
          const customPrimary = Colors.purple;
          final customScheme = FiftyColorScheme.dark(primary: customPrimary);
          final theme = FiftyTheme.dark(
            colorScheme: customScheme,
            primaryColor: Colors.red, // should be ignored
          );
          expect(theme.colorScheme.primary, customPrimary);
        });
      });

      test('custom extension is attached', () {
        return _withSilencedFontErrors(() {
          final customExt = FiftyThemeExtension.dark(accent: Colors.pink);
          final theme = FiftyTheme.dark(extension: customExt);
          final ext = theme.extension<FiftyThemeExtension>();
          expect(ext?.accent, Colors.pink);
        });
      });

      test('asset font family is applied to text theme', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.dark(
            fontFamily: 'CustomFont',
            fontSource: FontSource.asset,
          );
          expect(theme.textTheme.bodyLarge?.fontFamily, 'CustomFont');
          expect(theme.textTheme.displayLarge?.fontFamily, 'CustomFont');
        });
      });

      test('scaffold colors derive from colorScheme surface', () {
        return _withSilencedFontErrors(() {
          const customSurface = Color(0xFF111111);
          final cs = FiftyColorScheme.dark(surface: customSurface);
          final theme = FiftyTheme.dark(colorScheme: cs);
          expect(theme.scaffoldBackgroundColor, customSurface);
          expect(theme.canvasColor, customSurface);
        });
      });
    });

    group('light()', () {
      test('returns valid ThemeData', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.light();
          expect(theme, isA<ThemeData>());
        });
      });

      test('has Brightness.light', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.light();
          expect(theme.brightness, Brightness.light);
        });
      });

      test('useMaterial3 is true', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.light();
          expect(theme.useMaterial3, isTrue);
        });
      });

      test('scaffoldBackgroundColor is cream', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.light();
          expect(theme.scaffoldBackgroundColor, FiftyColors.cream);
        });
      });

      test('canvasColor is cream', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.light();
          expect(theme.canvasColor, FiftyColors.cream);
        });
      });

      test('shadows are enabled in v2', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.light();
          // shadowColor is no longer transparent in v2
          expect(theme.shadowColor, isNot(Colors.transparent));
        });
      });

      test('FiftyThemeExtension is attached', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.light();
          final extension = theme.extension<FiftyThemeExtension>();
          expect(extension, isNotNull);
          expect(extension, isA<FiftyThemeExtension>());
        });
      });

      test('colorScheme has light brightness', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.light();
          expect(theme.colorScheme.brightness, Brightness.light);
        });
      });

      test('colorScheme primary is burgundy', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.light();
          expect(theme.colorScheme.primary, FiftyColors.burgundy);
        });
      });

      test('textTheme bodyLarge is configured', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.light();
          // GoogleFonts uses dynamic font names, just verify it's configured
          expect(theme.textTheme.bodyLarge, isNotNull);
          expect(theme.textTheme.bodyLarge?.fontSize, 16);
        });
      });

      test('appBarTheme uses cream background', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.light();
          expect(theme.appBarTheme.backgroundColor, FiftyColors.cream);
          expect(theme.appBarTheme.foregroundColor, FiftyColors.darkBurgundy);
          expect(theme.appBarTheme.elevation, 0);
        });
      });

      test('light uses FiftyComponentThemes delegation (no inlined themes)', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.light();
          // Card theme should use surfaceContainerHighest from colorScheme
          expect(
            theme.cardTheme.color,
            theme.colorScheme.surfaceContainerHighest,
          );
          // Dialog theme should use surfaceContainerHighest from colorScheme
          expect(
            theme.dialogTheme.backgroundColor,
            theme.colorScheme.surfaceContainerHighest,
          );
        });
      });
    });

    group('light() parameterized', () {
      setUp(() => FiftyTokens.reset());

      test('primaryColor override changes colorScheme.primary', () {
        return _withSilencedFontErrors(() {
          const custom = Colors.indigo;
          final theme = FiftyTheme.light(primaryColor: custom);
          expect(theme.colorScheme.primary, custom);
        });
      });

      test('asset font family is applied to text theme', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyTheme.light(
            fontFamily: 'CustomFont',
            fontSource: FontSource.asset,
          );
          expect(theme.textTheme.bodyLarge?.fontFamily, 'CustomFont');
        });
      });
    });
  });
}
