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

  group('FiftyComponentThemes', () {
    setUp(() => FiftyTokens.reset());

    // Create a custom ColorScheme with distinct, non-FDL colors to prove
    // that component themes read from colorScheme, NOT hardcoded tokens.
    const customScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.blue,
      onPrimary: Colors.white,
      secondary: Colors.green,
      onSecondary: Colors.black,
      tertiary: Colors.teal,
      onTertiary: Colors.white,
      error: Colors.red,
      onError: Colors.white,
      surface: Color(0xFF222222),
      onSurface: Color(0xFFEEEEEE),
      surfaceContainerHighest: Color(0xFF333333),
      onSurfaceVariant: Color(0xFF999999),
      outline: Color(0xFF555555),
      outlineVariant: Color(0xFF444444),
      inverseSurface: Color(0xFFDDDDDD),
      onInverseSurface: Color(0xFF111111),
      inversePrimary: Colors.lightBlue,
      shadow: Colors.black,
      scrim: Colors.black54,
    );

    group('elevatedButtonTheme', () {
      test('uses colorScheme.primary for background', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.elevatedButtonTheme(customScheme);
          final style = theme.style!;
          final bg = style.backgroundColor?.resolve({});
          expect(bg, customScheme.primary);
        });
      });

      test('uses colorScheme.onPrimary for foreground', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.elevatedButtonTheme(customScheme);
          final style = theme.style!;
          final fg = style.foregroundColor?.resolve({});
          expect(fg, customScheme.onPrimary);
        });
      });
    });

    group('outlinedButtonTheme', () {
      test('uses colorScheme.onSurface for foreground', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.outlinedButtonTheme(customScheme);
          final style = theme.style!;
          final fg = style.foregroundColor?.resolve({});
          expect(fg, customScheme.onSurface);
        });
      });

      test('uses colorScheme.outline for border', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.outlinedButtonTheme(customScheme);
          final style = theme.style!;
          final side = style.side?.resolve({});
          expect(side?.color, customScheme.outline);
        });
      });

      test('hovered border uses colorScheme.primary', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.outlinedButtonTheme(customScheme);
          final style = theme.style!;
          final side = style.side?.resolve({WidgetState.hovered});
          expect(side?.color, customScheme.primary);
        });
      });
    });

    group('textButtonTheme', () {
      test('uses colorScheme.primary for foreground', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.textButtonTheme(customScheme);
          final style = theme.style!;
          final fg = style.foregroundColor?.resolve({});
          expect(fg, customScheme.primary);
        });
      });
    });

    group('cardTheme', () {
      test('uses colorScheme.surfaceContainerHighest for color', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.cardTheme(customScheme);
          expect(theme.color, customScheme.surfaceContainerHighest);
        });
      });

      test('uses colorScheme.outline for border', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.cardTheme(customScheme);
          final shape = theme.shape as RoundedRectangleBorder;
          final side = shape.side;
          expect(side.color, customScheme.outline);
        });
      });
    });

    group('inputDecorationTheme', () {
      test('focused border uses colorScheme.primary', () {
        return _withSilencedFontErrors(() {
          final theme =
              FiftyComponentThemes.inputDecorationTheme(customScheme);
          final border = theme.focusedBorder as OutlineInputBorder;
          expect(border.borderSide.color, customScheme.primary);
        });
      });

      test('error border uses colorScheme.error', () {
        return _withSilencedFontErrors(() {
          final theme =
              FiftyComponentThemes.inputDecorationTheme(customScheme);
          final border = theme.errorBorder as OutlineInputBorder;
          expect(border.borderSide.color, customScheme.error);
        });
      });

      test('enabled border uses colorScheme.outline', () {
        return _withSilencedFontErrors(() {
          final theme =
              FiftyComponentThemes.inputDecorationTheme(customScheme);
          final border = theme.enabledBorder as OutlineInputBorder;
          expect(border.borderSide.color, customScheme.outline);
        });
      });
    });

    group('appBarTheme', () {
      test('uses colorScheme.surface for background', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.appBarTheme(customScheme);
          expect(theme.backgroundColor, customScheme.surface);
        });
      });

      test('uses colorScheme.onSurface for foreground', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.appBarTheme(customScheme);
          expect(theme.foregroundColor, customScheme.onSurface);
        });
      });

      test('icon theme uses colorScheme.onSurface', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.appBarTheme(customScheme);
          expect(theme.iconTheme?.color, customScheme.onSurface);
        });
      });
    });

    group('dialogTheme', () {
      test('uses colorScheme.surfaceContainerHighest for background', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.dialogTheme(customScheme);
          expect(theme.backgroundColor, customScheme.surfaceContainerHighest);
        });
      });

      test('uses colorScheme.outline for border', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.dialogTheme(customScheme);
          final shape = theme.shape as RoundedRectangleBorder;
          expect(shape.side.color, customScheme.outline);
        });
      });
    });

    group('snackBarTheme', () {
      test('uses colorScheme.inverseSurface for background', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.snackBarTheme(customScheme);
          expect(theme.backgroundColor, customScheme.inverseSurface);
        });
      });
    });

    group('dividerTheme', () {
      test('uses colorScheme.outline for color', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.dividerTheme(customScheme);
          expect(theme.color, customScheme.outline);
        });
      });
    });

    group('checkboxTheme', () {
      test('selected fill uses colorScheme.primary', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.checkboxTheme(customScheme);
          final fill =
              theme.fillColor?.resolve({WidgetState.selected});
          expect(fill, customScheme.primary);
        });
      });

      test('check color uses colorScheme.onPrimary', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.checkboxTheme(customScheme);
          final check = theme.checkColor?.resolve({});
          expect(check, customScheme.onPrimary);
        });
      });

      test('border uses colorScheme.outline', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.checkboxTheme(customScheme);
          expect(theme.side?.color, customScheme.outline);
        });
      });
    });

    group('radioTheme', () {
      test('selected fill uses colorScheme.primary', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.radioTheme(customScheme);
          final fill =
              theme.fillColor?.resolve({WidgetState.selected});
          expect(fill, customScheme.primary);
        });
      });

      test('unselected fill uses colorScheme.outline', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.radioTheme(customScheme);
          final fill = theme.fillColor?.resolve({});
          expect(fill, customScheme.outline);
        });
      });
    });

    group('switchTheme', () {
      test('selected thumb uses colorScheme.onPrimary', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.switchTheme(customScheme);
          final thumb =
              theme.thumbColor?.resolve({WidgetState.selected});
          expect(thumb, customScheme.onPrimary);
        });
      });

      test('unselected thumb uses colorScheme.secondary', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.switchTheme(customScheme);
          final thumb = theme.thumbColor?.resolve({});
          expect(thumb, customScheme.secondary);
        });
      });

      test('selected track uses colorScheme.secondary', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.switchTheme(customScheme);
          final track =
              theme.trackColor?.resolve({WidgetState.selected});
          expect(track, customScheme.secondary);
        });
      });

      test('unselected track uses colorScheme.surfaceContainerHighest', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.switchTheme(customScheme);
          final track = theme.trackColor?.resolve({});
          expect(track, customScheme.surfaceContainerHighest);
        });
      });
    });

    group('bottomNavigationBarTheme', () {
      test('uses colorScheme.surface for background', () {
        return _withSilencedFontErrors(() {
          final theme =
              FiftyComponentThemes.bottomNavigationBarTheme(customScheme);
          expect(theme.backgroundColor, customScheme.surface);
        });
      });

      test('selected item uses colorScheme.primary', () {
        return _withSilencedFontErrors(() {
          final theme =
              FiftyComponentThemes.bottomNavigationBarTheme(customScheme);
          expect(theme.selectedItemColor, customScheme.primary);
        });
      });

      test('unselected item uses colorScheme.onSurfaceVariant', () {
        return _withSilencedFontErrors(() {
          final theme =
              FiftyComponentThemes.bottomNavigationBarTheme(customScheme);
          expect(theme.unselectedItemColor, customScheme.onSurfaceVariant);
        });
      });
    });

    group('navigationRailTheme', () {
      test('uses colorScheme.surfaceContainerHighest for background', () {
        return _withSilencedFontErrors(() {
          final theme =
              FiftyComponentThemes.navigationRailTheme(customScheme);
          expect(theme.backgroundColor, customScheme.surfaceContainerHighest);
        });
      });

      test('selected icon uses colorScheme.primary', () {
        return _withSilencedFontErrors(() {
          final theme =
              FiftyComponentThemes.navigationRailTheme(customScheme);
          expect(theme.selectedIconTheme?.color, customScheme.primary);
        });
      });

      test('unselected icon uses colorScheme.onSurfaceVariant', () {
        return _withSilencedFontErrors(() {
          final theme =
              FiftyComponentThemes.navigationRailTheme(customScheme);
          expect(
            theme.unselectedIconTheme?.color,
            customScheme.onSurfaceVariant,
          );
        });
      });
    });

    group('tabBarTheme', () {
      test('indicator uses colorScheme.primary', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.tabBarTheme(customScheme);
          expect(theme.indicatorColor, customScheme.primary);
        });
      });

      test('label uses colorScheme.onSurface', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.tabBarTheme(customScheme);
          expect(theme.labelColor, customScheme.onSurface);
        });
      });

      test('unselected label uses colorScheme.onSurfaceVariant', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.tabBarTheme(customScheme);
          expect(theme.unselectedLabelColor, customScheme.onSurfaceVariant);
        });
      });
    });

    group('floatingActionButtonTheme', () {
      test('uses colorScheme.primary for background', () {
        return _withSilencedFontErrors(() {
          final theme =
              FiftyComponentThemes.floatingActionButtonTheme(customScheme);
          expect(theme.backgroundColor, customScheme.primary);
        });
      });

      test('uses colorScheme.onPrimary for foreground', () {
        return _withSilencedFontErrors(() {
          final theme =
              FiftyComponentThemes.floatingActionButtonTheme(customScheme);
          expect(theme.foregroundColor, customScheme.onPrimary);
        });
      });
    });

    group('chipTheme', () {
      test('selected uses primary with alpha', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.chipTheme(customScheme);
          expect(
            theme.selectedColor,
            customScheme.primary.withValues(alpha: 0.15),
          );
        });
      });

      test('border uses colorScheme.outline', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.chipTheme(customScheme);
          expect(theme.side?.color, customScheme.outline);
        });
      });
    });

    group('progressIndicatorTheme', () {
      test('uses colorScheme.primary for indicator', () {
        return _withSilencedFontErrors(() {
          final theme =
              FiftyComponentThemes.progressIndicatorTheme(customScheme);
          expect(theme.color, customScheme.primary);
        });
      });
    });

    group('sliderTheme', () {
      test('active track uses colorScheme.primary', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.sliderTheme(customScheme);
          expect(theme.activeTrackColor, customScheme.primary);
        });
      });

      test('thumb uses colorScheme.primary', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.sliderTheme(customScheme);
          expect(theme.thumbColor, customScheme.primary);
        });
      });
    });

    group('tooltipTheme', () {
      test('uses colorScheme.inverseSurface for background', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.tooltipTheme(customScheme);
          final decoration = theme.decoration as BoxDecoration;
          expect(decoration.color, customScheme.inverseSurface);
        });
      });
    });

    group('popupMenuTheme', () {
      test('uses colorScheme.surfaceContainerHighest for color', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.popupMenuTheme(customScheme);
          expect(theme.color, customScheme.surfaceContainerHighest);
        });
      });
    });

    group('bottomSheetTheme', () {
      test('uses colorScheme.surfaceContainerHighest for background', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.bottomSheetTheme(customScheme);
          expect(theme.backgroundColor, customScheme.surfaceContainerHighest);
        });
      });

      test('modal background uses colorScheme.surfaceContainerHighest', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.bottomSheetTheme(customScheme);
          expect(
            theme.modalBackgroundColor,
            customScheme.surfaceContainerHighest,
          );
        });
      });
    });

    group('drawerTheme', () {
      test('uses colorScheme.surfaceContainerHighest for background', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.drawerTheme(customScheme);
          expect(theme.backgroundColor, customScheme.surfaceContainerHighest);
        });
      });
    });

    group('listTileTheme', () {
      test('selected tile uses primary with alpha', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.listTileTheme(customScheme);
          expect(
            theme.selectedTileColor,
            customScheme.primary.withValues(alpha: 0.1),
          );
        });
      });

      test('icon color uses colorScheme.onSurfaceVariant', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.listTileTheme(customScheme);
          expect(theme.iconColor, customScheme.onSurfaceVariant);
        });
      });

      test('selected color uses colorScheme.primary', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.listTileTheme(customScheme);
          expect(theme.selectedColor, customScheme.primary);
        });
      });

      test('text color uses colorScheme.onSurface', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.listTileTheme(customScheme);
          expect(theme.textColor, customScheme.onSurface);
        });
      });
    });

    group('iconTheme', () {
      test('uses colorScheme.onSurface for color', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.iconTheme(customScheme);
          expect(theme.color, customScheme.onSurface);
        });
      });
    });

    group('scrollbarTheme', () {
      test('thumb uses onSurfaceVariant with alpha', () {
        return _withSilencedFontErrors(() {
          final theme = FiftyComponentThemes.scrollbarTheme(customScheme);
          final thumbColor = theme.thumbColor?.resolve({});
          expect(
            thumbColor,
            customScheme.onSurfaceVariant.withValues(alpha: 0.5),
          );
        });
      });
    });

    group('no FiftyColors references in component themes', () {
      test('dark theme component themes derive from colorScheme', () {
        return _withSilencedFontErrors(() {
          // Build with a non-FDL color scheme to prove no hardcoding
          final theme = FiftyTheme.dark(colorScheme: customScheme);

          // AppBar bg should be customScheme.surface, NOT FiftyColors.darkBurgundy
          expect(theme.appBarTheme.backgroundColor, customScheme.surface);

          // Card color should be customScheme.surfaceContainerHighest
          expect(theme.cardTheme.color, customScheme.surfaceContainerHighest);

          // Scaffold should be customScheme.surface
          expect(theme.scaffoldBackgroundColor, customScheme.surface);

          // FAB should be customScheme.primary
          expect(
            theme.floatingActionButtonTheme.backgroundColor,
            customScheme.primary,
          );
        });
      });

      test('light theme component themes derive from colorScheme', () {
        return _withSilencedFontErrors(() {
          const lightCustom = ColorScheme(
            brightness: Brightness.light,
            primary: Colors.indigo,
            onPrimary: Colors.white,
            secondary: Colors.orange,
            onSecondary: Colors.black,
            tertiary: Colors.teal,
            onTertiary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            surface: Color(0xFFFAFAFA),
            onSurface: Color(0xFF111111),
            surfaceContainerHighest: Color(0xFFEEEEEE),
            onSurfaceVariant: Color(0xFF777777),
            outline: Color(0xFFCCCCCC),
            outlineVariant: Color(0xFFDDDDDD),
            inverseSurface: Color(0xFF222222),
            onInverseSurface: Color(0xFFFFFFFF),
            inversePrimary: Colors.lightBlue,
            shadow: Colors.black12,
            scrim: Colors.black38,
          );

          final theme = FiftyTheme.light(colorScheme: lightCustom);

          expect(theme.appBarTheme.backgroundColor, lightCustom.surface);
          expect(theme.cardTheme.color, lightCustom.surfaceContainerHighest);
          expect(theme.scaffoldBackgroundColor, lightCustom.surface);
          expect(
            theme.floatingActionButtonTheme.backgroundColor,
            lightCustom.primary,
          );
        });
      });
    });
  });
}
