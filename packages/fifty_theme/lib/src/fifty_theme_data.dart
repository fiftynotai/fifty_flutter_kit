import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import 'color_scheme.dart';
import 'component_themes.dart';
import 'text_theme.dart';
import 'theme_extensions.dart';

/// Fifty.dev theme builder v2 - the main entry point.
///
/// Creates complete Flutter ThemeData using Fifty v2 design tokens.
/// Assembles color scheme, text theme, component themes, and extensions.
///
/// Usage:
/// ```dart
/// MaterialApp(
///   theme: FiftyTheme.dark(),
///   darkTheme: FiftyTheme.dark(),
///   themeMode: ThemeMode.dark, // FDL: Dark mode is primary
/// );
/// ```
///
/// Customizing:
/// ```dart
/// FiftyTheme.dark(
///   primaryColor: Colors.blue,
///   fontFamily: 'Inter',
///   fontSource: FontSource.asset,
/// );
/// ```
///
/// Accessing custom extensions:
/// ```dart
/// final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;
/// print(fifty.accent);
/// ```
class FiftyTheme {
  FiftyTheme._();

  /// Creates the dark ThemeData - PRIMARY theme.
  ///
  /// This is the main theme for the fifty.dev ecosystem.
  /// Dark mode is optimized for OLED displays and reduced eye strain.
  ///
  /// Optional parameters:
  /// - [colorScheme]: Full ColorScheme override (takes precedence).
  /// - [primaryColor]: Shorthand to set the primary slot only.
  /// - [secondaryColor]: Shorthand to set the secondary slot only.
  /// - [fontFamily]: Override for font family name.
  /// - [fontSource]: Override for font source (google_fonts or asset).
  /// - [extension]: Full [FiftyThemeExtension] override.
  ///
  /// Features:
  /// - Material 3 enabled
  /// - Compact visual density
  /// - Soft shadows (v2)
  /// - Primary accents
  /// - Configurable typography
  static ThemeData dark({
    ColorScheme? colorScheme,
    Color? primaryColor,
    Color? secondaryColor,
    String? fontFamily,
    FontSource? fontSource,
    FiftyThemeExtension? extension,
  }) {
    final scheme = colorScheme ??
        FiftyColorScheme.dark(
          primary: primaryColor,
          secondary: secondaryColor,
        );
    final textTheme = FiftyTextTheme.textTheme(
      fontFamily: fontFamily,
      fontSource: fontSource,
    );
    final resolvedFamily = FiftyFontResolver.resolveFamilyName(
      fontFamily: fontFamily ?? FiftyTypography.fontFamily,
      source: fontSource ?? FiftyTypography.fontSource,
    );

    return ThemeData(
      // Core configuration
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      visualDensity: VisualDensity.compact,

      // Scaffold and surfaces - derived from colorScheme
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      cardColor: scheme.surfaceContainerHighest,

      // Typography
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      fontFamily: resolvedFamily,

      // Shadows enabled in v2 (removed shadowColor: Colors.transparent)

      // Component themes - all derived from colorScheme
      appBarTheme: FiftyComponentThemes.appBarTheme(scheme),
      elevatedButtonTheme: FiftyComponentThemes.elevatedButtonTheme(scheme),
      outlinedButtonTheme: FiftyComponentThemes.outlinedButtonTheme(scheme),
      textButtonTheme: FiftyComponentThemes.textButtonTheme(scheme),
      cardTheme: FiftyComponentThemes.cardTheme(scheme),
      inputDecorationTheme: FiftyComponentThemes.inputDecorationTheme(scheme),
      dialogTheme: FiftyComponentThemes.dialogTheme(scheme),
      snackBarTheme: FiftyComponentThemes.snackBarTheme(scheme),
      dividerTheme: FiftyComponentThemes.dividerTheme(scheme),
      checkboxTheme: FiftyComponentThemes.checkboxTheme(scheme),
      radioTheme: FiftyComponentThemes.radioTheme(scheme),
      switchTheme: FiftyComponentThemes.switchTheme(scheme),
      bottomNavigationBarTheme:
          FiftyComponentThemes.bottomNavigationBarTheme(scheme),
      navigationRailTheme: FiftyComponentThemes.navigationRailTheme(scheme),
      tabBarTheme: FiftyComponentThemes.tabBarTheme(scheme),
      floatingActionButtonTheme:
          FiftyComponentThemes.floatingActionButtonTheme(scheme),
      chipTheme: FiftyComponentThemes.chipTheme(scheme),
      progressIndicatorTheme:
          FiftyComponentThemes.progressIndicatorTheme(scheme),
      sliderTheme: FiftyComponentThemes.sliderTheme(scheme),
      tooltipTheme: FiftyComponentThemes.tooltipTheme(scheme),
      popupMenuTheme: FiftyComponentThemes.popupMenuTheme(scheme),
      dropdownMenuTheme: FiftyComponentThemes.dropdownMenuTheme(scheme),
      bottomSheetTheme: FiftyComponentThemes.bottomSheetTheme(scheme),
      drawerTheme: FiftyComponentThemes.drawerTheme(scheme),
      listTileTheme: FiftyComponentThemes.listTileTheme(scheme),
      iconTheme: FiftyComponentThemes.iconTheme(scheme),
      scrollbarTheme: FiftyComponentThemes.scrollbarTheme(scheme),

      // Extensions for custom properties - v2 dark
      extensions: [
        extension ?? FiftyThemeExtension.dark(),
      ],
    );
  }

  /// Creates the light ThemeData - SECONDARY theme.
  ///
  /// Provided for accessibility and user preference.
  /// Inverts the dark palette while maintaining brand identity.
  ///
  /// Accepts the same optional parameters as [dark].
  ///
  /// Note: FDL specifies dark mode as primary. Use light mode
  /// only when necessary for accessibility or user preference.
  static ThemeData light({
    ColorScheme? colorScheme,
    Color? primaryColor,
    Color? secondaryColor,
    String? fontFamily,
    FontSource? fontSource,
    FiftyThemeExtension? extension,
  }) {
    final scheme = colorScheme ??
        FiftyColorScheme.light(
          primary: primaryColor,
          secondary: secondaryColor,
        );
    final textTheme = FiftyTextTheme.textTheme(
      fontFamily: fontFamily,
      fontSource: fontSource,
    );
    final resolvedFamily = FiftyFontResolver.resolveFamilyName(
      fontFamily: fontFamily ?? FiftyTypography.fontFamily,
      source: fontSource ?? FiftyTypography.fontSource,
    );

    return ThemeData(
      // Core configuration
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      visualDensity: VisualDensity.compact,

      // Scaffold and surfaces - derived from colorScheme
      scaffoldBackgroundColor: scheme.surface,
      canvasColor: scheme.surface,
      cardColor: scheme.surfaceContainerHighest,

      // Typography
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      fontFamily: resolvedFamily,

      // Shadows enabled in v2 (removed shadowColor: Colors.transparent)

      // Component themes - all derived from colorScheme (no inlined themes)
      appBarTheme: FiftyComponentThemes.appBarTheme(scheme),
      elevatedButtonTheme: FiftyComponentThemes.elevatedButtonTheme(scheme),
      outlinedButtonTheme: FiftyComponentThemes.outlinedButtonTheme(scheme),
      textButtonTheme: FiftyComponentThemes.textButtonTheme(scheme),
      cardTheme: FiftyComponentThemes.cardTheme(scheme),
      inputDecorationTheme: FiftyComponentThemes.inputDecorationTheme(scheme),
      dialogTheme: FiftyComponentThemes.dialogTheme(scheme),
      snackBarTheme: FiftyComponentThemes.snackBarTheme(scheme),
      dividerTheme: FiftyComponentThemes.dividerTheme(scheme),
      checkboxTheme: FiftyComponentThemes.checkboxTheme(scheme),
      radioTheme: FiftyComponentThemes.radioTheme(scheme),
      switchTheme: FiftyComponentThemes.switchTheme(scheme),
      bottomNavigationBarTheme:
          FiftyComponentThemes.bottomNavigationBarTheme(scheme),
      navigationRailTheme: FiftyComponentThemes.navigationRailTheme(scheme),
      tabBarTheme: FiftyComponentThemes.tabBarTheme(scheme),
      floatingActionButtonTheme:
          FiftyComponentThemes.floatingActionButtonTheme(scheme),
      chipTheme: FiftyComponentThemes.chipTheme(scheme),
      progressIndicatorTheme:
          FiftyComponentThemes.progressIndicatorTheme(scheme),
      sliderTheme: FiftyComponentThemes.sliderTheme(scheme),
      tooltipTheme: FiftyComponentThemes.tooltipTheme(scheme),
      popupMenuTheme: FiftyComponentThemes.popupMenuTheme(scheme),
      dropdownMenuTheme: FiftyComponentThemes.dropdownMenuTheme(scheme),
      bottomSheetTheme: FiftyComponentThemes.bottomSheetTheme(scheme),
      drawerTheme: FiftyComponentThemes.drawerTheme(scheme),
      listTileTheme: FiftyComponentThemes.listTileTheme(scheme),
      iconTheme: FiftyComponentThemes.iconTheme(scheme),
      scrollbarTheme: FiftyComponentThemes.scrollbarTheme(scheme),

      // Extensions for custom properties - v2 light
      extensions: [
        extension ?? FiftyThemeExtension.light(),
      ],
    );
  }
}
