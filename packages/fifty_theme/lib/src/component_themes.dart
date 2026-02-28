import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Fifty.dev component theme configurations v2.
///
/// Applies FDL v2 design principles to Material components:
/// - Soft shadows (enabled in v2)
/// - Primary accents for focus states
/// - Border outlines for depth
/// - Font-resolved typography via [FiftyFontResolver]
///
/// All color values are derived from the incoming [ColorScheme],
/// making every component theme fully parameterizable.
class FiftyComponentThemes {
  FiftyComponentThemes._();

  /// Helper to create font-aware text styles.
  ///
  /// Uses [FiftyFontResolver] to resolve the configured font family
  /// (defaults to Manrope via google_fonts unless overridden).
  static TextStyle _font({
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return FiftyFontResolver.resolve(
      fontFamily: FiftyTypography.fontFamily,
      source: FiftyTypography.fontSource,
      baseStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      ),
    );
  }

  /// Elevated button theme - Primary CTA style.
  ///
  /// Uses primary background with soft shadow.
  static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: FiftySpacing.lg,
          vertical: FiftySpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: FiftyRadii.xlRadius,
        ),
        textStyle: _font(
          fontSize: FiftyTypography.labelLarge,
          fontWeight: FiftyTypography.bold,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.onPrimary.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.onPrimary.withValues(alpha: 0.2);
          }
          return null;
        }),
      ),
    );
  }

  /// Outlined button theme - Secondary action style.
  ///
  /// Uses border outline with primary hover state.
  static OutlinedButtonThemeData outlinedButtonTheme(ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: FiftySpacing.lg,
          vertical: FiftySpacing.md,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: FiftyRadii.xlRadius,
        ),
        side: BorderSide(color: colorScheme.outline),
        textStyle: _font(
          fontSize: FiftyTypography.labelLarge,
          fontWeight: FiftyTypography.bold,
        ),
      ).copyWith(
        side: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return BorderSide(color: colorScheme.primary);
          }
          return BorderSide(color: colorScheme.outline);
        }),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.primary.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.primary.withValues(alpha: 0.2);
          }
          return null;
        }),
      ),
    );
  }

  /// Text button theme - Tertiary action style.
  ///
  /// Uses primary text color for brand consistency.
  static TextButtonThemeData textButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        elevation: 0,
        padding: EdgeInsets.symmetric(
          horizontal: FiftySpacing.md,
          vertical: FiftySpacing.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: FiftyRadii.xlRadius,
        ),
        textStyle: _font(
          fontSize: FiftyTypography.labelLarge,
          fontWeight: FiftyTypography.bold,
        ),
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.hovered)) {
            return colorScheme.primary.withValues(alpha: 0.1);
          }
          if (states.contains(WidgetState.pressed)) {
            return colorScheme.primary.withValues(alpha: 0.2);
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
    return CardThemeData(
      color: colorScheme.surfaceContainerHighest,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: FiftyRadii.xxlRadius,
        side: BorderSide(color: colorScheme.outline),
      ),
      margin: EdgeInsets.zero,
    );
  }

  /// Input decoration theme - Surface fill with primary focus.
  ///
  /// Uses filled style with border that transitions to primary on focus.
  static InputDecorationTheme inputDecorationTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;
    final fillColor = isDark
        ? colorScheme.surfaceContainerHighest
        : colorScheme.secondary.withValues(alpha: 0.1);

    return InputDecorationTheme(
      filled: true,
      fillColor: fillColor,
      contentPadding: EdgeInsets.symmetric(
        horizontal: FiftySpacing.lg,
        vertical: FiftySpacing.md,
      ),
      border: OutlineInputBorder(
        borderRadius: FiftyRadii.xlRadius,
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: FiftyRadii.xlRadius,
        borderSide: BorderSide(color: colorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: FiftyRadii.xlRadius,
        borderSide: BorderSide(color: colorScheme.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: FiftyRadii.xlRadius,
        borderSide: BorderSide(color: colorScheme.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: FiftyRadii.xlRadius,
        borderSide: BorderSide(color: colorScheme.error, width: 2),
      ),
      hintStyle: _font(
        fontSize: FiftyTypography.bodyMedium,
        fontWeight: FiftyTypography.regular,
        color: colorScheme.onSurfaceVariant,
      ),
      labelStyle: _font(
        fontSize: FiftyTypography.bodyMedium,
        fontWeight: FiftyTypography.regular,
        color: colorScheme.onSurfaceVariant,
      ),
      floatingLabelStyle: _font(
        fontSize: FiftyTypography.bodyMedium,
        fontWeight: FiftyTypography.medium,
        color: colorScheme.primary,
      ),
    );
  }

  /// AppBar theme - Background color based on mode.
  ///
  /// Maintains deep background for immersive feel.
  static AppBarTheme appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: _font(
        fontSize: FiftyTypography.titleMedium,
        fontWeight: FiftyTypography.bold,
        color: colorScheme.onSurface,
      ),
      iconTheme: IconThemeData(
        color: colorScheme.onSurface,
        size: 24,
      ),
    );
  }

  /// Dialog theme - Surface with smooth radius.
  ///
  /// Uses larger radius for softer appearance on modals.
  static DialogThemeData dialogTheme(ColorScheme colorScheme) {
    return DialogThemeData(
      backgroundColor: colorScheme.surfaceContainerHighest,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: FiftyRadii.xxxlRadius,
        side: BorderSide(color: colorScheme.outline),
      ),
      titleTextStyle: _font(
        fontSize: FiftyTypography.titleLarge,
        fontWeight: FiftyTypography.bold,
        color: colorScheme.onSurface,
      ),
      contentTextStyle: _font(
        fontSize: FiftyTypography.bodyLarge,
        fontWeight: FiftyTypography.regular,
        color: colorScheme.onSurface,
      ),
    );
  }

  /// SnackBar theme - Inverse surface.
  ///
  /// Consistent appearance across themes.
  static SnackBarThemeData snackBarTheme(ColorScheme colorScheme) {
    return SnackBarThemeData(
      backgroundColor: colorScheme.inverseSurface,
      contentTextStyle: _font(
        fontSize: FiftyTypography.bodyMedium,
        fontWeight: FiftyTypography.regular,
        color: colorScheme.onInverseSurface,
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
    return DividerThemeData(
      color: colorScheme.outline,
      thickness: 1,
      space: FiftySpacing.lg,
    );
  }

  /// Checkbox theme - Primary when active.
  ///
  /// Consistent brand color for selected states.
  static CheckboxThemeData checkboxTheme(ColorScheme colorScheme) {
    return CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
      side: BorderSide(color: colorScheme.outline, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: FiftyRadii.smRadius,
      ),
    );
  }

  /// Radio theme - Primary when active.
  ///
  /// Consistent brand color for selected states.
  static RadioThemeData radioTheme(ColorScheme colorScheme) {
    return RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.primary;
        }
        return colorScheme.outline;
      }),
    );
  }

  /// Switch theme - Secondary when active (NOT primary!).
  ///
  /// Per v2 spec, switches use secondary color when on.
  static SwitchThemeData switchTheme(ColorScheme colorScheme) {
    return SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.onPrimary;
        }
        return colorScheme.secondary;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return colorScheme.secondary;
        }
        return colorScheme.surfaceContainerHighest;
      }),
      trackOutlineColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.transparent;
        }
        return colorScheme.outline;
      }),
    );
  }

  /// Bottom navigation bar theme.
  ///
  /// Uses background color based on mode with primary selected items.
  static BottomNavigationBarThemeData bottomNavigationBarTheme(
    ColorScheme colorScheme,
  ) {
    return BottomNavigationBarThemeData(
      backgroundColor: colorScheme.surface,
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: colorScheme.onSurfaceVariant,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: _font(
        fontSize: FiftyTypography.labelSmall,
        fontWeight: FiftyTypography.semiBold,
      ),
      unselectedLabelStyle: _font(
        fontSize: FiftyTypography.labelSmall,
        fontWeight: FiftyTypography.regular,
      ),
    );
  }

  /// Navigation rail theme.
  ///
  /// Uses surface container with primary selected items.
  static NavigationRailThemeData navigationRailTheme(ColorScheme colorScheme) {
    return NavigationRailThemeData(
      backgroundColor: colorScheme.surfaceContainerHighest,
      selectedIconTheme: IconThemeData(color: colorScheme.primary),
      unselectedIconTheme: IconThemeData(color: colorScheme.onSurfaceVariant),
      selectedLabelTextStyle: _font(
        fontSize: FiftyTypography.labelSmall,
        fontWeight: FiftyTypography.semiBold,
        color: colorScheme.primary,
      ),
      unselectedLabelTextStyle: _font(
        fontSize: FiftyTypography.labelSmall,
        fontWeight: FiftyTypography.regular,
        color: colorScheme.onSurfaceVariant,
      ),
      elevation: 0,
      indicatorColor: colorScheme.primary.withValues(alpha: 0.15),
    );
  }

  /// Tab bar theme.
  ///
  /// Uses primary for selected tab indicator.
  static TabBarThemeData tabBarTheme(ColorScheme colorScheme) {
    return TabBarThemeData(
      indicatorColor: colorScheme.primary,
      labelColor: colorScheme.onSurface,
      unselectedLabelColor: colorScheme.onSurfaceVariant,
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: _font(
        fontSize: FiftyTypography.labelLarge,
        fontWeight: FiftyTypography.bold,
      ),
      unselectedLabelStyle: _font(
        fontSize: FiftyTypography.labelLarge,
        fontWeight: FiftyTypography.regular,
      ),
    );
  }

  /// Floating action button theme.
  ///
  /// Uses primary with soft shadow.
  static FloatingActionButtonThemeData floatingActionButtonTheme(
    ColorScheme colorScheme,
  ) {
    return FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
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
  /// Uses surface container color with primary when selected.
  static ChipThemeData chipTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return ChipThemeData(
      backgroundColor: isDark
          ? colorScheme.surfaceContainerHighest
          : colorScheme.secondary.withValues(alpha: 0.1),
      selectedColor: colorScheme.primary.withValues(alpha: 0.15),
      disabledColor: colorScheme.onSurfaceVariant.withValues(alpha: 0.05),
      labelStyle: _font(
        fontSize: FiftyTypography.bodySmall,
        fontWeight: FiftyTypography.regular,
        color: colorScheme.onSurface,
      ),
      secondaryLabelStyle: _font(
        fontSize: FiftyTypography.bodySmall,
        fontWeight: FiftyTypography.regular,
        color: colorScheme.onSurfaceVariant,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: FiftySpacing.md,
        vertical: FiftySpacing.xs,
      ),
      side: BorderSide(color: colorScheme.outline),
      shape: RoundedRectangleBorder(
        borderRadius: FiftyRadii.fullRadius,
      ),
    );
  }

  /// Progress indicator theme.
  ///
  /// Uses primary for the indicator.
  static ProgressIndicatorThemeData progressIndicatorTheme(
    ColorScheme colorScheme,
  ) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return ProgressIndicatorThemeData(
      color: colorScheme.primary,
      linearTrackColor: isDark
          ? colorScheme.surfaceContainerHighest
          : colorScheme.secondary.withValues(alpha: 0.2),
      circularTrackColor: isDark
          ? colorScheme.surfaceContainerHighest
          : colorScheme.secondary.withValues(alpha: 0.2),
    );
  }

  /// Slider theme.
  ///
  /// Uses primary for active track and thumb.
  static SliderThemeData sliderTheme(ColorScheme colorScheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return SliderThemeData(
      activeTrackColor: colorScheme.primary,
      inactiveTrackColor: isDark
          ? colorScheme.surfaceContainerHighest
          : colorScheme.secondary.withValues(alpha: 0.2),
      thumbColor: colorScheme.primary,
      overlayColor: colorScheme.primary.withValues(alpha: 0.2),
      valueIndicatorColor: colorScheme.primary,
      valueIndicatorTextStyle: _font(
        fontSize: FiftyTypography.bodySmall,
        fontWeight: FiftyTypography.medium,
        color: colorScheme.onPrimary,
      ),
    );
  }

  /// Tooltip theme.
  ///
  /// Uses inverse surface for visibility.
  static TooltipThemeData tooltipTheme(ColorScheme colorScheme) {
    return TooltipThemeData(
      decoration: BoxDecoration(
        color: colorScheme.inverseSurface,
        borderRadius: FiftyRadii.xlRadius,
      ),
      textStyle: _font(
        fontSize: FiftyTypography.bodySmall,
        fontWeight: FiftyTypography.regular,
        color: colorScheme.onInverseSurface,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: FiftySpacing.md,
        vertical: FiftySpacing.sm,
      ),
    );
  }

  /// Popup menu theme.
  ///
  /// Uses surface container with border.
  static PopupMenuThemeData popupMenuTheme(ColorScheme colorScheme) {
    return PopupMenuThemeData(
      color: colorScheme.surfaceContainerHighest,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: FiftyRadii.xlRadius,
        side: BorderSide(color: colorScheme.outline),
      ),
      textStyle: _font(
        fontSize: FiftyTypography.bodyMedium,
        fontWeight: FiftyTypography.regular,
        color: colorScheme.onSurface,
      ),
    );
  }

  /// Dropdown menu theme.
  ///
  /// Uses surface container with border.
  static DropdownMenuThemeData dropdownMenuTheme(ColorScheme colorScheme) {
    return DropdownMenuThemeData(
      inputDecorationTheme: inputDecorationTheme(colorScheme),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(
          colorScheme.surfaceContainerHighest,
        ),
        elevation: WidgetStateProperty.all(0),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: FiftyRadii.xlRadius,
            side: BorderSide(color: colorScheme.outline),
          ),
        ),
      ),
    );
  }

  /// Bottom sheet theme.
  ///
  /// Uses surface container with smooth radius at top.
  static BottomSheetThemeData bottomSheetTheme(ColorScheme colorScheme) {
    return BottomSheetThemeData(
      backgroundColor: colorScheme.surfaceContainerHighest,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(FiftyRadii.xxxl),
        ),
      ),
      modalBackgroundColor: colorScheme.surfaceContainerHighest,
      modalElevation: 0,
    );
  }

  /// Drawer theme.
  ///
  /// Uses surface container based on mode.
  static DrawerThemeData drawerTheme(ColorScheme colorScheme) {
    return DrawerThemeData(
      backgroundColor: colorScheme.surfaceContainerHighest,
      elevation: 0,
      shape: const RoundedRectangleBorder(),
    );
  }

  /// List tile theme.
  ///
  /// Uses standard spacing and typography.
  static ListTileThemeData listTileTheme(ColorScheme colorScheme) {
    return ListTileThemeData(
      tileColor: Colors.transparent,
      selectedTileColor: colorScheme.primary.withValues(alpha: 0.1),
      iconColor: colorScheme.onSurfaceVariant,
      selectedColor: colorScheme.primary,
      textColor: colorScheme.onSurface,
      contentPadding: EdgeInsets.symmetric(
        horizontal: FiftySpacing.lg,
        vertical: FiftySpacing.sm,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: FiftyRadii.xlRadius,
      ),
      titleTextStyle: _font(
        fontSize: FiftyTypography.bodyLarge,
        fontWeight: FiftyTypography.regular,
        color: colorScheme.onSurface,
      ),
      subtitleTextStyle: _font(
        fontSize: FiftyTypography.bodySmall,
        fontWeight: FiftyTypography.regular,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// Icon theme.
  ///
  /// Uses onSurface as default icon color.
  static IconThemeData iconTheme(ColorScheme colorScheme) {
    return IconThemeData(
      color: colorScheme.onSurface,
      size: 24,
    );
  }

  /// Scrollbar theme.
  ///
  /// Uses onSurfaceVariant with subtle appearance.
  static ScrollbarThemeData scrollbarTheme(ColorScheme colorScheme) {
    return ScrollbarThemeData(
      thumbColor: WidgetStateProperty.all(
        colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
      ),
      trackColor: WidgetStateProperty.all(Colors.transparent),
      radius: const Radius.circular(4),
      thickness: WidgetStateProperty.all(8),
    );
  }
}
