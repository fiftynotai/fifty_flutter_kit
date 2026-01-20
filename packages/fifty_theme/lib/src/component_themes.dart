import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fifty.dev component theme configurations v2.
///
/// Applies FDL v2 design principles to Material components:
/// - Soft shadows (enabled in v2)
/// - Burgundy accents for focus states
/// - Border outlines for depth
/// - Manrope typography
class FiftyComponentThemes {
  FiftyComponentThemes._();

  /// Elevated button theme - Primary CTA style.
  ///
  /// Uses Burgundy background with soft shadow.
  static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: FiftyColors.burgundy,
        foregroundColor: FiftyColors.cream,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: FiftySpacing.lg,
          vertical: FiftySpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: FiftyRadii.xlRadius,
        ),
        textStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.labelLarge,
          fontWeight: FiftyTypography.bold,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return FiftyColors.cream.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.pressed)) {
            return FiftyColors.cream.withValues(alpha: 0.2);
          }
          return null;
        }),
      ),
    );
  }

  /// Outlined button theme - Secondary action style.
  ///
  /// Uses border outline with burgundy hover state.
  static OutlinedButtonThemeData outlinedButtonTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final borderColor = isDark ? FiftyColors.borderDark : FiftyColors.borderLight;
    final foregroundColor = isDark ? FiftyColors.cream : FiftyColors.darkBurgundy;

    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: foregroundColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: FiftySpacing.lg,
          vertical: FiftySpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: FiftyRadii.xlRadius,
        ),
        side: BorderSide(color: borderColor),
        textStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.labelLarge,
          fontWeight: FiftyTypography.bold,
        ),
      ).copyWith(
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return const BorderSide(color: FiftyColors.burgundy);
          }
          return BorderSide(color: borderColor);
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return FiftyColors.burgundy.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.pressed)) {
            return FiftyColors.burgundy.withValues(alpha: 0.2);
          }
          return null;
        }),
      ),
    );
  }

  /// Text button theme - Tertiary action style.
  ///
  /// Uses Burgundy text color for brand consistency.
  static TextButtonThemeData textButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: FiftyColors.burgundy,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: FiftySpacing.md,
          vertical: FiftySpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: FiftyRadii.xlRadius,
        ),
        textStyle: GoogleFonts.manrope(
          fontSize: FiftyTypography.labelLarge,
          fontWeight: FiftyTypography.bold,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return FiftyColors.burgundy.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.pressed)) {
            return FiftyColors.burgundy.withValues(alpha: 0.2);
          }
          return null;
        }),
      ),
    );
  }

  /// Card theme - Surface with border.
  ///
  /// Uses elevation with soft shadow in v2.
  static CardThemeData cardTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final borderColor = isDark ? FiftyColors.borderDark : FiftyColors.borderLight;

    return CardThemeData(
      color: isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: FiftyRadii.xxlRadius,
        side: BorderSide(color: borderColor),
      ),
      margin: EdgeInsets.zero,
    );
  }

  /// Input decoration theme - Surface fill with burgundy focus.
  ///
  /// Uses filled style with border that transitions to burgundy on focus.
  static InputDecorationTheme inputDecorationTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final fillColor = isDark ? FiftyColors.surfaceDark : FiftyColors.slateGrey.withValues(alpha: 0.1);
    final borderColor = isDark ? FiftyColors.borderDark : FiftyColors.borderLight;
    const hintColor = FiftyColors.slateGrey;

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.lg,
        vertical: FiftySpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: FiftyRadii.xlRadius,
        borderSide: BorderSide(color: borderColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: FiftyRadii.xlRadius,
        borderSide: BorderSide(color: borderColor),
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
        color: hintColor,
      ),
      labelStyle: GoogleFonts.manrope(
        fontSize: FiftyTypography.bodyMedium,
        fontWeight: FiftyTypography.regular,
        color: hintColor,
      ),
      floatingLabelStyle: GoogleFonts.manrope(
        fontSize: FiftyTypography.bodyMedium,
        fontWeight: FiftyTypography.medium,
        color: FiftyColors.burgundy,
      ),
    );
  }

  /// AppBar theme - Background color based on mode.
  ///
  /// Maintains deep background for immersive feel.
  static AppBarTheme appBarTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return AppBarTheme(
      backgroundColor: isDark ? FiftyColors.darkBurgundy : FiftyColors.cream,
      foregroundColor: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.manrope(
        fontSize: FiftyTypography.titleMedium,
        fontWeight: FiftyTypography.bold,
        color: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy,
      ),
      iconTheme: IconThemeData(
        color: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy,
        size: 24,
      ),
    );
  }

  /// Dialog theme - Surface with smooth radius.
  ///
  /// Uses larger radius for softer appearance on modals.
  static DialogThemeData dialogTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final borderColor = isDark ? FiftyColors.borderDark : FiftyColors.borderLight;

    return DialogThemeData(
      backgroundColor: isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: FiftyRadii.xxxlRadius,
        side: BorderSide(color: borderColor),
      ),
      titleTextStyle: GoogleFonts.manrope(
        fontSize: FiftyTypography.titleLarge,
        fontWeight: FiftyTypography.bold,
        color: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy,
      ),
      contentTextStyle: GoogleFonts.manrope(
        fontSize: FiftyTypography.bodyLarge,
        fontWeight: FiftyTypography.regular,
        color: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy,
      ),
    );
  }

  /// SnackBar theme - Dark Burgundy surface.
  ///
  /// Consistent appearance across themes.
  static SnackBarThemeData snackBarTheme(ColorScheme colorScheme) {
    return SnackBarThemeData(
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
    );
  }

  /// Divider theme - Border color.
  ///
  /// Uses standard border color for subtle separation.
  static DividerThemeData dividerTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    return DividerThemeData(
      color: isDark ? FiftyColors.borderDark : FiftyColors.borderLight,
      thickness: 1,
      space: FiftySpacing.lg,
    );
  }

  /// Checkbox theme - Burgundy when active.
  ///
  /// Consistent brand color for selected states.
  static CheckboxThemeData checkboxTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final borderColor = isDark ? FiftyColors.borderDark : FiftyColors.borderLight;

    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return FiftyColors.burgundy;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(FiftyColors.cream),
      side: BorderSide(color: borderColor, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: FiftyRadii.smRadius,
      ),
    );
  }

  /// Radio theme - Burgundy when active.
  ///
  /// Consistent brand color for selected states.
  static RadioThemeData radioTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final borderColor = isDark ? FiftyColors.borderDark : FiftyColors.borderLight;

    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return FiftyColors.burgundy;
        }
        return borderColor;
      }),
    );
  }

  /// Switch theme - Slate Grey when active (NOT primary!).
  ///
  /// Per v2 spec, switches use secondary color when on.
  static SwitchThemeData switchTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final borderColor = isDark ? FiftyColors.borderDark : FiftyColors.borderLight;

    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return FiftyColors.cream;
        }
        return FiftyColors.slateGrey;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return FiftyColors.slateGrey;
        }
        return isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }
        return borderColor;
      }),
    );
  }

  /// Bottom navigation bar theme.
  ///
  /// Uses background color based on mode with burgundy selected items.
  static BottomNavigationBarThemeData bottomNavigationBarTheme(
    ColorScheme colorScheme,
  ) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return BottomNavigationBarThemeData(
      backgroundColor: isDark ? FiftyColors.darkBurgundy : FiftyColors.cream,
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
    );
  }

  /// Navigation rail theme.
  ///
  /// Uses surface color with burgundy selected items.
  static NavigationRailThemeData navigationRailTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return NavigationRailThemeData(
      backgroundColor: isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight,
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
    );
  }

  /// Tab bar theme.
  ///
  /// Uses Burgundy for selected tab indicator.
  static TabBarThemeData tabBarTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return TabBarThemeData(
      indicatorColor: FiftyColors.burgundy,
      labelColor: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy,
      unselectedLabelColor: FiftyColors.slateGrey,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: GoogleFonts.manrope(
        fontSize: FiftyTypography.labelLarge,
        fontWeight: FiftyTypography.bold,
      ),
      unselectedLabelStyle: GoogleFonts.manrope(
        fontSize: FiftyTypography.labelLarge,
        fontWeight: FiftyTypography.regular,
      ),
    );
  }

  /// Floating action button theme.
  ///
  /// Uses Burgundy with soft shadow.
  static FloatingActionButtonThemeData floatingActionButtonTheme(
    ColorScheme colorScheme,
  ) {
    return FloatingActionButtonThemeData(
      backgroundColor: FiftyColors.burgundy,
      foregroundColor: FiftyColors.cream,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: FiftyRadii.xlRadius,
      ),
    );
  }

  /// Chip theme.
  ///
  /// Uses surface color with burgundy when selected.
  static ChipThemeData chipTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final borderColor = isDark ? FiftyColors.borderDark : FiftyColors.borderLight;

    return ChipThemeData(
      backgroundColor: isDark ? FiftyColors.surfaceDark : FiftyColors.slateGrey.withValues(alpha: 0.1),
      selectedColor: FiftyColors.burgundy.withValues(alpha: 0.15),
      disabledColor: FiftyColors.slateGrey.withValues(alpha: 0.05),
      labelStyle: GoogleFonts.manrope(
        fontSize: FiftyTypography.bodySmall,
        fontWeight: FiftyTypography.regular,
        color: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy,
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
      side: BorderSide(color: borderColor),
      shape: RoundedRectangleBorder(
        borderRadius: FiftyRadii.fullRadius,
      ),
    );
  }

  /// Progress indicator theme.
  ///
  /// Uses Burgundy for the indicator.
  static ProgressIndicatorThemeData progressIndicatorTheme(
    ColorScheme colorScheme,
  ) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return ProgressIndicatorThemeData(
      color: FiftyColors.burgundy,
      linearTrackColor: isDark ? FiftyColors.surfaceDark : FiftyColors.slateGrey.withValues(alpha: 0.2),
      circularTrackColor: isDark ? FiftyColors.surfaceDark : FiftyColors.slateGrey.withValues(alpha: 0.2),
    );
  }

  /// Slider theme.
  ///
  /// Uses Burgundy for active track and thumb.
  static SliderThemeData sliderTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return SliderThemeData(
      activeTrackColor: FiftyColors.burgundy,
      inactiveTrackColor: isDark ? FiftyColors.surfaceDark : FiftyColors.slateGrey.withValues(alpha: 0.2),
      thumbColor: FiftyColors.burgundy,
      overlayColor: FiftyColors.burgundy.withValues(alpha: 0.2),
      valueIndicatorColor: FiftyColors.burgundy,
      valueIndicatorTextStyle: GoogleFonts.manrope(
        fontSize: FiftyTypography.bodySmall,
        fontWeight: FiftyTypography.medium,
        color: FiftyColors.cream,
      ),
    );
  }

  /// Tooltip theme.
  ///
  /// Uses dark burgundy background for visibility.
  static TooltipThemeData tooltipTheme(ColorScheme colorScheme) {
    return TooltipThemeData(
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
    );
  }

  /// Popup menu theme.
  ///
  /// Uses surface color with border.
  static PopupMenuThemeData popupMenuTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final borderColor = isDark ? FiftyColors.borderDark : FiftyColors.borderLight;

    return PopupMenuThemeData(
      color: isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: FiftyRadii.xlRadius,
        side: BorderSide(color: borderColor),
      ),
      textStyle: GoogleFonts.manrope(
        fontSize: FiftyTypography.bodyMedium,
        fontWeight: FiftyTypography.regular,
        color: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy,
      ),
    );
  }

  /// Dropdown menu theme.
  ///
  /// Uses surface color with border.
  static DropdownMenuThemeData dropdownMenuTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final borderColor = isDark ? FiftyColors.borderDark : FiftyColors.borderLight;

    return DropdownMenuThemeData(
      inputDecorationTheme: inputDecorationTheme(colorScheme),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(
          isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight,
        ),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: FiftyRadii.xlRadius,
            side: BorderSide(color: borderColor),
          ),
        ),
      ),
    );
  }

  /// Bottom sheet theme.
  ///
  /// Uses surface color with smooth radius at top.
  static BottomSheetThemeData bottomSheetTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return BottomSheetThemeData(
      backgroundColor: isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(FiftyRadii.xxxl),
        ),
      ),
      modalBackgroundColor: isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight,
      modalElevation: 0,
    );
  }

  /// Drawer theme.
  ///
  /// Uses surface color based on mode.
  static DrawerThemeData drawerTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return DrawerThemeData(
      backgroundColor: isDark ? FiftyColors.surfaceDark : FiftyColors.surfaceLight,
      elevation: 0,
      shape: const RoundedRectangleBorder(),
    );
  }

  /// List tile theme.
  ///
  /// Uses standard spacing and typography.
  static ListTileThemeData listTileTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: FiftyColors.burgundy.withValues(alpha: 0.1),
      iconColor: FiftyColors.slateGrey,
      selectedColor: FiftyColors.burgundy,
      textColor: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy,
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
        color: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy,
      ),
      subtitleTextStyle: GoogleFonts.manrope(
        fontSize: FiftyTypography.bodySmall,
        fontWeight: FiftyTypography.regular,
        color: FiftyColors.slateGrey,
      ),
    );
  }

  /// Icon theme.
  ///
  /// Uses cream (dark) or dark burgundy (light) as default icon color.
  static IconThemeData iconTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return IconThemeData(
      color: isDark ? FiftyColors.cream : FiftyColors.darkBurgundy,
      size: 24,
    );
  }

  /// Scrollbar theme.
  ///
  /// Uses Slate Grey with subtle appearance.
  static ScrollbarThemeData scrollbarTheme(ColorScheme colorScheme) {
    return ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(
        FiftyColors.slateGrey.withValues(alpha: 0.5),
      ),
      trackColor: WidgetStateProperty.all(Colors.transparent),
      radius: const Radius.circular(4),
      thickness: WidgetStateProperty.all(8),
    );
  }
}
