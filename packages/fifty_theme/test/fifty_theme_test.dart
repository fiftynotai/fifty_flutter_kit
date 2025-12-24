import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FiftyTheme', () {
    group('dark()', () {
      late ThemeData theme;

      setUp(() {
        theme = FiftyTheme.dark();
      });

      test('returns valid ThemeData', () {
        expect(theme, isA<ThemeData>());
      });

      test('has Brightness.dark', () {
        expect(theme.brightness, Brightness.dark);
      });

      test('useMaterial3 is true', () {
        expect(theme.useMaterial3, isTrue);
      });

      test('scaffoldBackgroundColor is voidBlack', () {
        expect(theme.scaffoldBackgroundColor, FiftyColors.voidBlack);
      });

      test('canvasColor is voidBlack', () {
        expect(theme.canvasColor, FiftyColors.voidBlack);
      });

      test('cardColor is gunmetal', () {
        expect(theme.cardColor, FiftyColors.gunmetal);
      });

      test('dialogBackgroundColor is gunmetal', () {
        expect(theme.dialogBackgroundColor, FiftyColors.gunmetal);
      });

      test('shadowColor is transparent', () {
        expect(theme.shadowColor, Colors.transparent);
      });

      test('visualDensity is compact', () {
        expect(theme.visualDensity, VisualDensity.compact);
      });

      test('FiftyThemeExtension is attached', () {
        final extension = theme.extension<FiftyThemeExtension>();
        expect(extension, isNotNull);
        expect(extension, isA<FiftyThemeExtension>());
      });

      test('colorScheme has dark brightness', () {
        expect(theme.colorScheme.brightness, Brightness.dark);
      });

      test('colorScheme primary is crimsonPulse', () {
        expect(theme.colorScheme.primary, FiftyColors.crimsonPulse);
      });

      test('textTheme is configured', () {
        expect(theme.textTheme, isNotNull);
        expect(theme.textTheme.displayLarge, isNotNull);
      });

      test('textTheme bodyLarge uses JetBrains Mono', () {
        expect(
          theme.textTheme.bodyLarge?.fontFamily,
          FiftyTypography.fontFamilyMono,
        );
      });

      test('appBarTheme is configured', () {
        expect(theme.appBarTheme.backgroundColor, FiftyColors.voidBlack);
        expect(theme.appBarTheme.foregroundColor, FiftyColors.terminalWhite);
        expect(theme.appBarTheme.elevation, 0);
      });

      test('elevatedButtonTheme uses zero elevation', () {
        final style = theme.elevatedButtonTheme.style;
        expect(style, isNotNull);
      });

      test('cardTheme uses gunmetal', () {
        expect(theme.cardTheme.color, FiftyColors.gunmetal);
        expect(theme.cardTheme.elevation, 0);
      });
    });

    group('light()', () {
      late ThemeData theme;

      setUp(() {
        theme = FiftyTheme.light();
      });

      test('returns valid ThemeData', () {
        expect(theme, isA<ThemeData>());
      });

      test('has Brightness.light', () {
        expect(theme.brightness, Brightness.light);
      });

      test('useMaterial3 is true', () {
        expect(theme.useMaterial3, isTrue);
      });

      test('scaffoldBackgroundColor is terminalWhite', () {
        expect(theme.scaffoldBackgroundColor, FiftyColors.terminalWhite);
      });

      test('canvasColor is terminalWhite', () {
        expect(theme.canvasColor, FiftyColors.terminalWhite);
      });

      test('shadowColor is transparent', () {
        expect(theme.shadowColor, Colors.transparent);
      });

      test('FiftyThemeExtension is attached', () {
        final extension = theme.extension<FiftyThemeExtension>();
        expect(extension, isNotNull);
        expect(extension, isA<FiftyThemeExtension>());
      });

      test('colorScheme has light brightness', () {
        expect(theme.colorScheme.brightness, Brightness.light);
      });

      test('colorScheme primary is crimsonPulse', () {
        expect(theme.colorScheme.primary, FiftyColors.crimsonPulse);
      });

      test('textTheme bodyLarge uses JetBrains Mono', () {
        expect(
          theme.textTheme.bodyLarge?.fontFamily,
          FiftyTypography.fontFamilyMono,
        );
      });

      test('appBarTheme uses terminalWhite background', () {
        expect(theme.appBarTheme.backgroundColor, FiftyColors.terminalWhite);
        expect(theme.appBarTheme.foregroundColor, FiftyColors.voidBlack);
        expect(theme.appBarTheme.elevation, 0);
      });
    });
  });
}
