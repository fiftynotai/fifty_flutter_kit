import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  /// Features:
  /// - Material 3 enabled
  /// - Compact visual density
  /// - Soft shadows (v2)
  /// - Burgundy accents
  /// - Manrope typography
  static ThemeData dark() {
    final colorScheme = FiftyColorScheme.dark();
    final textTheme = FiftyTextTheme.textTheme();

    return ThemeData(
      // Core configuration
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      visualDensity: VisualDensity.compact,

      // Scaffold and surfaces - v2 colors
      scaffoldBackgroundColor: FiftyColors.darkBurgundy,
      canvasColor: FiftyColors.darkBurgundy,
      cardColor: FiftyColors.surfaceDark,

      // Typography - Manrope
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      fontFamily: GoogleFonts.manrope().fontFamily,

      // Shadows enabled in v2 (removed shadowColor: Colors.transparent)

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

      // Extensions for custom properties - v2 dark
      extensions: [
        FiftyThemeExtension.dark(),
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

      // Scaffold and surfaces - v2 colors
      scaffoldBackgroundColor: FiftyColors.cream,
      canvasColor: FiftyColors.cream,
      cardColor: FiftyColors.surfaceLight,

      // Typography - Manrope
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      fontFamily: GoogleFonts.manrope().fontFamily,

      // Shadows enabled in v2 (removed shadowColor: Colors.transparent)

      // Component themes (reuse dark themes - they adapt via colorScheme)
      appBarTheme: AppBarTheme(
        backgroundColor: FiftyColors.cream,
        foregroundColor: FiftyColors.darkBurgundy,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.titleMedium,
          fontWeight: FiftyTypography.bold,
          color: FiftyColors.darkBurgundy,
        ),
        iconTheme: const IconThemeData(
          color: FiftyColors.darkBurgundy,
          size: 24,
        ),
      ),
      elevatedButtonTheme: FiftyComponentThemes.elevatedButtonTheme(colorScheme),
      outlinedButtonTheme: FiftyComponentThemes.outlinedButtonTheme(colorScheme),
      textButtonTheme: FiftyComponentThemes.textButtonTheme(colorScheme),
      cardTheme: CardThemeData(
        color: FiftyColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: FiftyRadii.xxlRadius,
          side: BorderSide(color: FiftyColors.borderLight),
        ),
        margin: EdgeInsets.zero,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: FiftyColors.slateGrey.withValues(alpha: 0.1),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FiftySpacing.lg,
          vertical: FiftySpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: FiftyRadii.xlRadius,
          borderSide: BorderSide(color: FiftyColors.borderLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: FiftyRadii.xlRadius,
          borderSide: BorderSide(color: FiftyColors.borderLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: FiftyRadii.xlRadius,
          borderSide: const BorderSide(color: FiftyColors.burgundy, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: FiftyRadii.xlRadius,
          borderSide: const BorderSide(color: FiftyColors.burgundy),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: FiftyRadii.xlRadius,
          borderSide: const BorderSide(color: FiftyColors.burgundy, width: 2),
        ),
        hintStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.bodyMedium,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.slateGrey,
        ),
        labelStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.bodyMedium,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.slateGrey,
        ),
        floatingLabelStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.bodyMedium,
          fontWeight: FiftyTypography.medium,
          color: FiftyColors.burgundy,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: FiftyColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: FiftyRadii.xxxlRadius,
          side: BorderSide(color: FiftyColors.borderLight),
        ),
        titleTextStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.titleLarge,
          fontWeight: FiftyTypography.bold,
          color: FiftyColors.darkBurgundy,
        ),
        contentTextStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.bodyLarge,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.darkBurgundy,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: FiftyColors.darkBurgundy,
        contentTextStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.bodyMedium,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.cream,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: FiftyRadii.xlRadius,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 0,
      ),
      dividerTheme: DividerThemeData(
        color: FiftyColors.borderLight,
        thickness: 1,
        space: FiftySpacing.lg,
      ),
      checkboxTheme: FiftyComponentThemes.checkboxTheme(colorScheme),
      radioTheme: FiftyComponentThemes.radioTheme(colorScheme),
      switchTheme: FiftyComponentThemes.switchTheme(colorScheme),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: FiftyColors.cream,
        selectedItemColor: FiftyColors.burgundy,
        unselectedItemColor: FiftyColors.slateGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.labelSmall,
          fontWeight: FiftyTypography.semiBold,
        ),
        unselectedLabelStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.labelSmall,
          fontWeight: FiftyTypography.regular,
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: FiftyColors.surfaceLight,
        selectedIconTheme: const IconThemeData(color: FiftyColors.burgundy),
        unselectedIconTheme: const IconThemeData(color: FiftyColors.slateGrey),
        selectedLabelTextStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.labelSmall,
          fontWeight: FiftyTypography.semiBold,
          color: FiftyColors.burgundy,
        ),
        unselectedLabelTextStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.labelSmall,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.slateGrey,
        ),
        elevation: 0,
        indicatorColor: FiftyColors.burgundy.withValues(alpha: 0.15),
      ),
      tabBarTheme: FiftyComponentThemes.tabBarTheme(colorScheme),
      floatingActionButtonTheme:
          FiftyComponentThemes.floatingActionButtonTheme(colorScheme),
      chipTheme: ChipThemeData(
        backgroundColor: FiftyColors.slateGrey.withValues(alpha: 0.1),
        selectedColor: FiftyColors.burgundy.withValues(alpha: 0.15),
        disabledColor: FiftyColors.slateGrey.withValues(alpha: 0.05),
        labelStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.bodySmall,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.darkBurgundy,
        ),
        secondaryLabelStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.bodySmall,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.slateGrey,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: FiftySpacing.md,
          vertical: FiftySpacing.xs,
        ),
        side: BorderSide(color: FiftyColors.borderLight),
        shape: RoundedRectangleBorder(
          borderRadius: FiftyRadii.fullRadius,
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: FiftyColors.burgundy,
        linearTrackColor: FiftyColors.slateGrey.withValues(alpha: 0.2),
        circularTrackColor: FiftyColors.slateGrey.withValues(alpha: 0.2),
      ),
      sliderTheme: FiftyComponentThemes.sliderTheme(colorScheme),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: FiftyColors.darkBurgundy,
          borderRadius: FiftyRadii.xlRadius,
        ),
        textStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.bodySmall,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.cream,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: FiftySpacing.md,
          vertical: FiftySpacing.sm,
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: FiftyColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: FiftyRadii.xlRadius,
          side: BorderSide(color: FiftyColors.borderLight),
        ),
        textStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.bodyMedium,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.darkBurgundy,
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        menuStyle: MenuStyle(
          backgroundColor: WidgetStateProperty.all(FiftyColors.surfaceLight),
          elevation: WidgetStateProperty.all(0),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: FiftyRadii.xlRadius,
              side: BorderSide(color: FiftyColors.borderLight),
            ),
          ),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: FiftyColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(FiftyRadii.xxxl),
          ),
        ),
        modalBackgroundColor: FiftyColors.surfaceLight,
        modalElevation: 0,
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: FiftyColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(),
      ),
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: FiftyColors.burgundy.withValues(alpha: 0.1),
        iconColor: FiftyColors.slateGrey,
        selectedColor: FiftyColors.burgundy,
        textColor: FiftyColors.darkBurgundy,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: FiftySpacing.lg,
          vertical: FiftySpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: FiftyRadii.xlRadius,
        ),
        titleTextStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.bodyLarge,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.darkBurgundy,
        ),
        subtitleTextStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.bodySmall,
          fontWeight: FiftyTypography.regular,
          color: FiftyColors.slateGrey,
        ),
      ),
      iconTheme: const IconThemeData(
        color: FiftyColors.darkBurgundy,
        size: 24,
      ),
      scrollbarTheme: ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(
          FiftyColors.slateGrey.withValues(alpha: 0.3),
        ),
        trackColor: WidgetStateProperty.all(Colors.transparent),
        radius: const Radius.circular(4),
        thickness: WidgetStateProperty.all(8),
      ),

      // Extensions for custom properties - v2 light
      extensions: [
        FiftyThemeExtension.light(),
      ],
    );
  }
}
