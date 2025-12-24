import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import 'color_scheme.dart';
import 'component_themes.dart';
import 'text_theme.dart';
import 'theme_extensions.dart';

/// Fifty.dev theme builder - the main entry point.
///
/// Creates complete Flutter ThemeData using Fifty design tokens.
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
/// Accessing custom extensions:
/// ```dart
/// final fifty = Theme.of(context).extension<FiftyThemeExtension>()!;
/// print(fifty.igrisGreen);
/// ```
class FiftyTheme {
  FiftyTheme._();

  /// Creates the dark ThemeData - PRIMARY theme.
  ///
  /// This is the main theme for the fifty.dev ecosystem.
  /// Dark mode is optimized for OLED displays and reduced eye strain.
  ///
  /// Features:
  /// - Material 3 enabled
  /// - Compact visual density
  /// - Zero elevation (no drop shadows)
  /// - Crimson Pulse accents
  /// - Monument Extended + JetBrains Mono typography
  static ThemeData dark() {
    final colorScheme = FiftyColorScheme.dark();
    final textTheme = FiftyTextTheme.textTheme();

    return ThemeData(
      // Core configuration
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      visualDensity: VisualDensity.compact,

      // Scaffold and surfaces
      scaffoldBackgroundColor: FiftyColors.voidBlack,
      canvasColor: FiftyColors.voidBlack,
      cardColor: FiftyColors.gunmetal,
      dialogBackgroundColor: FiftyColors.gunmetal,

      // Typography
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      fontFamily: FiftyTypography.fontFamilyMono,

      // Disable shadows globally
      shadowColor: Colors.transparent,

      // Component themes
      appBarTheme: FiftyComponentThemes.appBarTheme(colorScheme),
      elevatedButtonTheme: FiftyComponentThemes.elevatedButtonTheme(colorScheme),
      outlinedButtonTheme: FiftyComponentThemes.outlinedButtonTheme(colorScheme),
      textButtonTheme: FiftyComponentThemes.textButtonTheme(colorScheme),
      cardTheme: FiftyComponentThemes.cardTheme(colorScheme),
      inputDecorationTheme: FiftyComponentThemes.inputDecorationTheme(colorScheme),
      dialogTheme: FiftyComponentThemes.dialogTheme(colorScheme),
      snackBarTheme: FiftyComponentThemes.snackBarTheme(colorScheme),
      dividerTheme: FiftyComponentThemes.dividerTheme(colorScheme),
      checkboxTheme: FiftyComponentThemes.checkboxTheme(colorScheme),
      radioTheme: FiftyComponentThemes.radioTheme(colorScheme),
      switchTheme: FiftyComponentThemes.switchTheme(colorScheme),
      bottomNavigationBarTheme:
          FiftyComponentThemes.bottomNavigationBarTheme(colorScheme),
      navigationRailTheme: FiftyComponentThemes.navigationRailTheme(colorScheme),
      tabBarTheme: FiftyComponentThemes.tabBarTheme(colorScheme),
      floatingActionButtonTheme:
          FiftyComponentThemes.floatingActionButtonTheme(colorScheme),
      chipTheme: FiftyComponentThemes.chipTheme(colorScheme),
      progressIndicatorTheme:
          FiftyComponentThemes.progressIndicatorTheme(colorScheme),
      sliderTheme: FiftyComponentThemes.sliderTheme(colorScheme),
      tooltipTheme: FiftyComponentThemes.tooltipTheme(colorScheme),
      popupMenuTheme: FiftyComponentThemes.popupMenuTheme(colorScheme),
      dropdownMenuTheme: FiftyComponentThemes.dropdownMenuTheme(colorScheme),
      bottomSheetTheme: FiftyComponentThemes.bottomSheetTheme(colorScheme),
      drawerTheme: FiftyComponentThemes.drawerTheme(colorScheme),
      listTileTheme: FiftyComponentThemes.listTileTheme(colorScheme),
      iconTheme: FiftyComponentThemes.iconTheme(colorScheme),
      scrollbarTheme: FiftyComponentThemes.scrollbarTheme(colorScheme),

      // Extensions for custom properties
      extensions: [
        FiftyThemeExtension.standard(),
      ],
    );
  }

  /// Creates the light ThemeData - SECONDARY theme.
  ///
  /// Provided for accessibility and user preference.
  /// Inverts the dark palette while maintaining brand identity.
  ///
  /// Note: FDL specifies dark mode as primary. Use light mode
  /// only when necessary for accessibility or user preference.
  static ThemeData light() {
    final colorScheme = FiftyColorScheme.light();
    final textTheme = FiftyTextTheme.textTheme();

    return ThemeData(
      // Core configuration
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      visualDensity: VisualDensity.compact,

      // Scaffold and surfaces
      scaffoldBackgroundColor: FiftyColors.terminalWhite,
      canvasColor: FiftyColors.terminalWhite,
      cardColor: Colors.white,
      dialogBackgroundColor: Colors.white,

      // Typography
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      fontFamily: FiftyTypography.fontFamilyMono,

      // Disable shadows globally
      shadowColor: Colors.transparent,

      // Component themes (reuse dark themes - they adapt via colorScheme)
      appBarTheme: AppBarTheme(
        backgroundColor: FiftyColors.terminalWhite,
        foregroundColor: FiftyColors.voidBlack,
        elevation: 0,
        shadowColor: Colors.transparent,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: 18,
          fontWeight: FiftyTypography.medium,
          color: FiftyColors.voidBlack,
        ),
        iconTheme: const IconThemeData(
          color: FiftyColors.voidBlack,
          size: 24,
        ),
      ),
      elevatedButtonTheme: FiftyComponentThemes.elevatedButtonTheme(colorScheme),
      outlinedButtonTheme: FiftyComponentThemes.outlinedButtonTheme(colorScheme),
      textButtonTheme: FiftyComponentThemes.textButtonTheme(colorScheme),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FiftyRadii.standard),
          side: BorderSide(color: FiftyColors.hyperChrome.withValues(alpha: 0.2)),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FiftyColors.hyperChrome.withValues(alpha: 0.1),
        contentPadding: EdgeInsets.symmetric(
          horizontal: FiftySpacing.lg,
          vertical: FiftySpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FiftyRadii.standard),
          borderSide: BorderSide(color: FiftyColors.hyperChrome.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FiftyRadii.standard),
          borderSide: BorderSide(color: FiftyColors.hyperChrome.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FiftyRadii.standard),
          borderSide: const BorderSide(color: FiftyColors.crimsonPulse, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FiftyRadii.standard),
          borderSide: const BorderSide(color: FiftyColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(FiftyRadii.standard),
          borderSide: const BorderSide(color: FiftyColors.error, width: 2),
        ),
        hintStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: 14,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.hyperChrome,
        ),
        labelStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: 14,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.hyperChrome,
        ),
        floatingLabelStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: 14,
          fontWeight: FiftyTypography.medium,
          color: FiftyColors.crimsonPulse,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FiftyRadii.smooth),
          side: BorderSide(color: FiftyColors.hyperChrome.withValues(alpha: 0.2)),
        ),
        titleTextStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyHeadline,
          fontSize: 20,
          fontWeight: FiftyTypography.ultrabold,
          color: FiftyColors.voidBlack,
        ),
        contentTextStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: FiftyTypography.body,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.voidBlack,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: FiftyColors.voidBlack,
        contentTextStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: 14,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.terminalWhite,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FiftyRadii.standard),
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),
      dividerTheme: DividerThemeData(
        color: FiftyColors.hyperChrome.withValues(alpha: 0.2),
        thickness: 1,
        space: FiftySpacing.lg,
      ),
      checkboxTheme: FiftyComponentThemes.checkboxTheme(colorScheme),
      radioTheme: FiftyComponentThemes.radioTheme(colorScheme),
      switchTheme: FiftyComponentThemes.switchTheme(colorScheme),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: FiftyColors.terminalWhite,
        selectedItemColor: FiftyColors.crimsonPulse,
        unselectedItemColor: FiftyColors.hyperChrome,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: FiftyTypography.mono,
          fontWeight: FiftyTypography.medium,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: FiftyTypography.mono,
          fontWeight: FiftyTypography.regular,
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.white,
        selectedIconTheme: const IconThemeData(color: FiftyColors.crimsonPulse),
        unselectedIconTheme: const IconThemeData(color: FiftyColors.hyperChrome),
        selectedLabelTextStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: FiftyTypography.mono,
          fontWeight: FiftyTypography.medium,
          color: FiftyColors.crimsonPulse,
        ),
        unselectedLabelTextStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: FiftyTypography.mono,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.hyperChrome,
        ),
        elevation: 0,
        indicatorColor: FiftyColors.crimsonPulse.withValues(alpha: 0.15),
      ),
      tabBarTheme: FiftyComponentThemes.tabBarTheme(colorScheme),
      floatingActionButtonTheme:
          FiftyComponentThemes.floatingActionButtonTheme(colorScheme),
      chipTheme: ChipThemeData(
        backgroundColor: FiftyColors.hyperChrome.withValues(alpha: 0.1),
        selectedColor: FiftyColors.crimsonPulse.withValues(alpha: 0.15),
        disabledColor: FiftyColors.hyperChrome.withValues(alpha: 0.05),
        labelStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: FiftyTypography.mono,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.voidBlack,
        ),
        secondaryLabelStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: FiftyTypography.mono,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.hyperChrome,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: FiftySpacing.md,
          vertical: FiftySpacing.xs,
        ),
        side: BorderSide(color: FiftyColors.hyperChrome.withValues(alpha: 0.2)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FiftyRadii.full),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: FiftyColors.crimsonPulse,
        linearTrackColor: FiftyColors.hyperChrome.withValues(alpha: 0.2),
        circularTrackColor: FiftyColors.hyperChrome.withValues(alpha: 0.2),
      ),
      sliderTheme: FiftyComponentThemes.sliderTheme(colorScheme),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: FiftyColors.voidBlack,
          borderRadius: BorderRadius.circular(FiftyRadii.standard),
        ),
        textStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: FiftyTypography.mono,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.terminalWhite,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: FiftySpacing.md,
          vertical: FiftySpacing.sm,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FiftyRadii.standard),
          side: BorderSide(color: FiftyColors.hyperChrome.withValues(alpha: 0.2)),
        ),
        textStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: 14,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.voidBlack,
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(Colors.white),
          elevation: WidgetStateProperty.all(0),
          shadowColor: WidgetStateProperty.all(Colors.transparent),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(FiftyRadii.standard),
              side: BorderSide(color: FiftyColors.hyperChrome.withValues(alpha: 0.2)),
            ),
          ),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(FiftyRadii.smooth),
          ),
        ),
        modalBackgroundColor: Colors.white,
        modalElevation: 0,
      ),
      drawerTheme: DrawerThemeData(
        backgroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: FiftyColors.crimsonPulse.withValues(alpha: 0.1),
        iconColor: FiftyColors.hyperChrome,
        selectedColor: FiftyColors.crimsonPulse,
        textColor: FiftyColors.voidBlack,
        contentPadding: EdgeInsets.symmetric(
          horizontal: FiftySpacing.lg,
          vertical: FiftySpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FiftyRadii.standard),
        ),
        titleTextStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: FiftyTypography.body,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.voidBlack,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: FiftyTypography.mono,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.hyperChrome,
        ),
      ),
      iconTheme: const IconThemeData(
        color: FiftyColors.voidBlack,
        size: 24,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(
          FiftyColors.hyperChrome.withValues(alpha: 0.3),
        ),
        trackColor: WidgetStateProperty.all(Colors.transparent),
        radius: const Radius.circular(4),
        thickness: WidgetStateProperty.all(8),
      ),

      // Extensions for custom properties
      extensions: [
        FiftyThemeExtension.standard(),
      ],
    );
  }
}
