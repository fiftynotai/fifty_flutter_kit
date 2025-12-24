import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Fifty.dev component theme configurations.
///
/// Applies FDL design principles to Material components:
/// - Zero elevation (no drop shadows)
/// - Crimson glow for focus states
/// - Border outlines for depth
/// - Tight density (compact)
class FiftyComponentThemes {
  FiftyComponentThemes._();

  /// Elevated button theme - Primary CTA style.
  ///
  /// Uses Crimson Pulse background with zero elevation.
  /// Glow effect applied via overlayColor on focus/hover.
  static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: FiftyColors.crimsonPulse,
        foregroundColor: FiftyColors.terminalWhite,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: FiftySpacing.lg,
          vertical: FiftySpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FiftyRadii.standard),
        ),
        textStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: 14,
          fontWeight: FiftyTypography.medium,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return FiftyColors.terminalWhite.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.pressed)) {
            return FiftyColors.terminalWhite.withValues(alpha: 0.2);
          }
          return null;
        }),
      ),
    );
  }

  /// Outlined button theme - Secondary action style.
  ///
  /// Uses border outline with crimson hover state.
  static OutlinedButtonThemeData outlinedButtonTheme(ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: FiftyColors.terminalWhite,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: FiftySpacing.lg,
          vertical: FiftySpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FiftyRadii.standard),
        ),
        side: BorderSide(color: FiftyColors.border),
        textStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: 14,
          fontWeight: FiftyTypography.medium,
        ),
      ).copyWith(
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return const BorderSide(color: FiftyColors.crimsonPulse);
          }
          return BorderSide(color: FiftyColors.border);
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return FiftyColors.crimsonPulse.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.pressed)) {
            return FiftyColors.crimsonPulse.withValues(alpha: 0.2);
          }
          return null;
        }),
      ),
    );
  }

  /// Text button theme - Tertiary action style.
  ///
  /// Uses Crimson Pulse text color for brand consistency.
  static TextButtonThemeData textButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: FiftyColors.crimsonPulse,
        elevation: 0,
        shadowColor: Colors.transparent,
        padding: EdgeInsets.symmetric(
          horizontal: FiftySpacing.md,
          vertical: FiftySpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(FiftyRadii.standard),
        ),
        textStyle: TextStyle(
          fontFamily: FiftyTypography.fontFamilyMono,
          fontSize: 14,
          fontWeight: FiftyTypography.medium,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return FiftyColors.crimsonPulse.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.pressed)) {
            return FiftyColors.crimsonPulse.withValues(alpha: 0.2);
          }
          return null;
        }),
      ),
    );
  }

  /// Card theme - Gunmetal surface with border.
  ///
  /// Zero elevation with border outline for depth.
  static CardThemeData cardTheme(ColorScheme colorScheme) {
    return CardThemeData(
      color: FiftyColors.gunmetal,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FiftyRadii.standard),
        side: BorderSide(color: FiftyColors.border),
      ),
      margin: EdgeInsets.zero,
    );
  }

  /// Input decoration theme - Gunmetal fill with crimson focus.
  ///
  /// Uses filled style with border that transitions to crimson on focus.
  static InputDecorationTheme inputDecorationTheme(ColorScheme colorScheme) {
    return InputDecorationTheme(
      filled: true,
      fillColor: FiftyColors.gunmetal,
      contentPadding: EdgeInsets.symmetric(
        horizontal: FiftySpacing.lg,
        vertical: FiftySpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FiftyRadii.standard),
        borderSide: BorderSide(color: FiftyColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(FiftyRadii.standard),
        borderSide: BorderSide(color: FiftyColors.border),
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
    );
  }

  /// AppBar theme - Void Black with zero elevation.
  ///
  /// Maintains deep background for immersive feel.
  static AppBarTheme appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      backgroundColor: FiftyColors.voidBlack,
      foregroundColor: FiftyColors.terminalWhite,
      elevation: 0,
      shadowColor: Colors.transparent,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: 18,
        fontWeight: FiftyTypography.medium,
        color: FiftyColors.terminalWhite,
      ),
      iconTheme: const IconThemeData(
        color: FiftyColors.terminalWhite,
        size: 24,
      ),
    );
  }

  /// Dialog theme - Gunmetal with smooth radius.
  ///
  /// Uses larger radius for softer appearance on modals.
  static DialogThemeData dialogTheme(ColorScheme colorScheme) {
    return DialogThemeData(
      backgroundColor: FiftyColors.gunmetal,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FiftyRadii.smooth),
        side: BorderSide(color: FiftyColors.border),
      ),
      titleTextStyle: TextStyle(
        fontFamily: FiftyTypography.fontFamilyHeadline,
        fontSize: 20,
        fontWeight: FiftyTypography.ultrabold,
        color: FiftyColors.terminalWhite,
      ),
      contentTextStyle: TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: FiftyTypography.body,
        fontWeight: FiftyTypography.regular,
        color: FiftyColors.terminalWhite,
      ),
    );
  }

  /// SnackBar theme - Gunmetal surface.
  ///
  /// Consistent with card styling.
  static SnackBarThemeData snackBarTheme(ColorScheme colorScheme) {
    return SnackBarThemeData(
      backgroundColor: FiftyColors.gunmetal,
      contentTextStyle: TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: 14,
        fontWeight: FiftyTypography.regular,
        color: FiftyColors.terminalWhite,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FiftyRadii.standard),
        side: BorderSide(color: FiftyColors.border),
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 0,
    );
  }

  /// Divider theme - Border color.
  ///
  /// Uses standard border color for subtle separation.
  static DividerThemeData dividerTheme(ColorScheme colorScheme) {
    return DividerThemeData(
      color: FiftyColors.border,
      thickness: 1,
      space: FiftySpacing.lg,
    );
  }

  /// Checkbox theme - Crimson Pulse when active.
  ///
  /// Consistent brand color for selected states.
  static CheckboxThemeData checkboxTheme(ColorScheme colorScheme) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return FiftyColors.crimsonPulse;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(FiftyColors.terminalWhite),
      side: BorderSide(color: FiftyColors.border, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  /// Radio theme - Crimson Pulse when active.
  ///
  /// Consistent brand color for selected states.
  static RadioThemeData radioTheme(ColorScheme colorScheme) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return FiftyColors.crimsonPulse;
        }
        return FiftyColors.border;
      }),
    );
  }

  /// Switch theme - Crimson Pulse when active.
  ///
  /// Consistent brand color for toggled states.
  static SwitchThemeData switchTheme(ColorScheme colorScheme) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return FiftyColors.crimsonPulse;
        }
        return FiftyColors.hyperChrome;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return FiftyColors.crimsonPulse.withValues(alpha: 0.3);
        }
        return FiftyColors.gunmetal;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }
        return FiftyColors.border;
      }),
    );
  }

  /// Bottom navigation bar theme.
  ///
  /// Uses Void Black background with Crimson Pulse selected items.
  static BottomNavigationBarThemeData bottomNavigationBarTheme(
    ColorScheme colorScheme,
  ) {
    return BottomNavigationBarThemeData(
      backgroundColor: FiftyColors.voidBlack,
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
    );
  }

  /// Navigation rail theme.
  ///
  /// Uses Gunmetal background with Crimson Pulse selected items.
  static NavigationRailThemeData navigationRailTheme(ColorScheme colorScheme) {
    return NavigationRailThemeData(
      backgroundColor: FiftyColors.gunmetal,
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
      indicatorColor: FiftyColors.crimsonPulse.withValues(alpha: 0.2),
    );
  }

  /// Tab bar theme.
  ///
  /// Uses Crimson Pulse for selected tab indicator.
  static TabBarThemeData tabBarTheme(ColorScheme colorScheme) {
    return TabBarThemeData(
      indicatorColor: FiftyColors.crimsonPulse,
      labelColor: FiftyColors.terminalWhite,
      unselectedLabelColor: FiftyColors.hyperChrome,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: const TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: 14,
        fontWeight: FiftyTypography.medium,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: 14,
        fontWeight: FiftyTypography.regular,
      ),
    );
  }

  /// Floating action button theme.
  ///
  /// Uses Crimson Pulse with zero elevation.
  static FloatingActionButtonThemeData floatingActionButtonTheme(
    ColorScheme colorScheme,
  ) {
    return FloatingActionButtonThemeData(
      backgroundColor: FiftyColors.crimsonPulse,
      foregroundColor: FiftyColors.terminalWhite,
      elevation: 0,
      focusElevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FiftyRadii.standard),
      ),
    );
  }

  /// Chip theme.
  ///
  /// Uses Gunmetal background with Crimson Pulse when selected.
  static ChipThemeData chipTheme(ColorScheme colorScheme) {
    return ChipThemeData(
      backgroundColor: FiftyColors.gunmetal,
      selectedColor: FiftyColors.crimsonPulse.withValues(alpha: 0.2),
      disabledColor: FiftyColors.gunmetal.withValues(alpha: 0.5),
      labelStyle: TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: FiftyTypography.mono,
        fontWeight: FiftyTypography.regular,
        color: FiftyColors.terminalWhite,
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
      side: BorderSide(color: FiftyColors.border),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FiftyRadii.full),
      ),
    );
  }

  /// Progress indicator theme.
  ///
  /// Uses Crimson Pulse for the indicator.
  static ProgressIndicatorThemeData progressIndicatorTheme(
    ColorScheme colorScheme,
  ) {
    return ProgressIndicatorThemeData(
      color: FiftyColors.crimsonPulse,
      linearTrackColor: FiftyColors.gunmetal,
      circularTrackColor: FiftyColors.gunmetal,
    );
  }

  /// Slider theme.
  ///
  /// Uses Crimson Pulse for active track and thumb.
  static SliderThemeData sliderTheme(ColorScheme colorScheme) {
    return SliderThemeData(
      activeTrackColor: FiftyColors.crimsonPulse,
      inactiveTrackColor: FiftyColors.gunmetal,
      thumbColor: FiftyColors.crimsonPulse,
      overlayColor: FiftyColors.crimsonPulse.withValues(alpha: 0.2),
      valueIndicatorColor: FiftyColors.crimsonPulse,
      valueIndicatorTextStyle: TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: FiftyTypography.mono,
        fontWeight: FiftyTypography.medium,
        color: FiftyColors.terminalWhite,
      ),
    );
  }

  /// Tooltip theme.
  ///
  /// Uses Gunmetal background with standard radius.
  static TooltipThemeData tooltipTheme(ColorScheme colorScheme) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: FiftyColors.gunmetal,
        borderRadius: BorderRadius.circular(FiftyRadii.standard),
        border: Border.all(color: FiftyColors.border),
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
    );
  }

  /// Popup menu theme.
  ///
  /// Uses Gunmetal background with border.
  static PopupMenuThemeData popupMenuTheme(ColorScheme colorScheme) {
    return PopupMenuThemeData(
      color: FiftyColors.gunmetal,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(FiftyRadii.standard),
        side: BorderSide(color: FiftyColors.border),
      ),
      textStyle: TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: 14,
        fontWeight: FiftyTypography.regular,
        color: FiftyColors.terminalWhite,
      ),
    );
  }

  /// Dropdown menu theme.
  ///
  /// Uses Gunmetal background with border.
  static DropdownMenuThemeData dropdownMenuTheme(ColorScheme colorScheme) {
    return DropdownMenuThemeData(
      inputDecorationTheme: inputDecorationTheme(colorScheme),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(FiftyColors.gunmetal),
        elevation: WidgetStateProperty.all(0),
        shadowColor: WidgetStateProperty.all(Colors.transparent),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(FiftyRadii.standard),
            side: BorderSide(color: FiftyColors.border),
          ),
        ),
      ),
    );
  }

  /// Bottom sheet theme.
  ///
  /// Uses Gunmetal background with smooth radius at top.
  static BottomSheetThemeData bottomSheetTheme(ColorScheme colorScheme) {
    return BottomSheetThemeData(
      backgroundColor: FiftyColors.gunmetal,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(FiftyRadii.smooth),
        ),
      ),
      modalBackgroundColor: FiftyColors.gunmetal,
      modalElevation: 0,
    );
  }

  /// Drawer theme.
  ///
  /// Uses Gunmetal background.
  static DrawerThemeData drawerTheme(ColorScheme colorScheme) {
    return DrawerThemeData(
      backgroundColor: FiftyColors.gunmetal,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: const RoundedRectangleBorder(),
    );
  }

  /// List tile theme.
  ///
  /// Uses standard spacing and typography.
  static ListTileThemeData listTileTheme(ColorScheme colorScheme) {
    return ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: FiftyColors.crimsonPulse.withValues(alpha: 0.1),
      iconColor: FiftyColors.hyperChrome,
      selectedColor: FiftyColors.crimsonPulse,
      textColor: FiftyColors.terminalWhite,
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
        color: FiftyColors.terminalWhite,
      ),
      subtitleTextStyle: TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: FiftyTypography.mono,
        fontWeight: FiftyTypography.regular,
        color: FiftyColors.hyperChrome,
      ),
    );
  }

  /// Icon theme.
  ///
  /// Uses Terminal White as default icon color.
  static IconThemeData iconTheme(ColorScheme colorScheme) {
    return const IconThemeData(
      color: FiftyColors.terminalWhite,
      size: 24,
    );
  }

  /// Scrollbar theme.
  ///
  /// Uses Hyper Chrome with subtle appearance.
  static ScrollbarThemeData scrollbarTheme(ColorScheme colorScheme) {
    return ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(
        FiftyColors.hyperChrome.withValues(alpha: 0.5),
      ),
      trackColor: WidgetStateProperty.all(Colors.transparent),
      radius: const Radius.circular(4),
      thickness: WidgetStateProperty.all(8),
    );
  }
}
