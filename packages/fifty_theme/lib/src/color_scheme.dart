import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Fifty.dev color scheme builder v2 - Sophisticated Warm.
///
/// Maps FiftyColors v2 tokens to Flutter's ColorScheme.
/// Dark mode remains primary following FDL specification.
class FiftyColorScheme {
  FiftyColorScheme._();

  /// Creates a dark ColorScheme using Fifty v2 design tokens.
  ///
  /// Color mappings:
  /// - `primary`: Burgundy (brand signature)
  /// - `secondary`: Slate Grey (secondary actions)
  /// - `surface`: Dark Burgundy (deep background)
  /// - `tertiary`: Hunter Green (success)
  static ColorScheme dark() {
    return ColorScheme(
      brightness: Brightness.dark,

      // Primary colors - Burgundy
      primary: FiftyColors.burgundy,
      onPrimary: FiftyColors.cream,
      primaryContainer: FiftyColors.burgundy.withValues(alpha: 0.2),
      onPrimaryContainer: FiftyColors.cream,

      // Secondary colors - Slate Grey
      secondary: FiftyColors.slateGrey,
      onSecondary: FiftyColors.cream,
      secondaryContainer: FiftyColors.slateGrey.withValues(alpha: 0.2),
      onSecondaryContainer: FiftyColors.cream,

      // Tertiary colors - Hunter Green (success)
      tertiary: FiftyColors.hunterGreen,
      onTertiary: FiftyColors.cream,
      tertiaryContainer: FiftyColors.hunterGreen.withValues(alpha: 0.2),
      onTertiaryContainer: FiftyColors.hunterGreen,

      // Error colors - Burgundy (consistent with primary)
      error: FiftyColors.burgundy,
      onError: FiftyColors.cream,
      errorContainer: FiftyColors.burgundy.withValues(alpha: 0.2),
      onErrorContainer: FiftyColors.cream,

      // Surface colors - Dark Burgundy base
      surface: FiftyColors.darkBurgundy,
      onSurface: FiftyColors.cream,
      surfaceContainerHighest: FiftyColors.surfaceDark,
      onSurfaceVariant: FiftyColors.slateGrey,

      // Outline colors - White 5%
      outline: FiftyColors.borderDark,
      outlineVariant: Colors.white.withValues(alpha: 0.1),

      // Other - NOW using shadows
      shadow: Colors.black.withValues(alpha: 0.1),
      scrim: FiftyColors.darkBurgundy.withValues(alpha: 0.8),
      inverseSurface: FiftyColors.cream,
      onInverseSurface: FiftyColors.darkBurgundy,
      inversePrimary: FiftyColors.burgundy,
    );
  }

  /// Creates a light ColorScheme using Fifty v2 design tokens.
  static ColorScheme light() {
    return ColorScheme(
      brightness: Brightness.light,

      // Primary colors - Burgundy
      primary: FiftyColors.burgundy,
      onPrimary: FiftyColors.cream,
      primaryContainer: FiftyColors.burgundy.withValues(alpha: 0.15),
      onPrimaryContainer: FiftyColors.burgundy,

      // Secondary colors - Slate Grey
      secondary: FiftyColors.slateGrey,
      onSecondary: FiftyColors.cream,
      secondaryContainer: FiftyColors.slateGrey.withValues(alpha: 0.2),
      onSecondaryContainer: FiftyColors.darkBurgundy,

      // Tertiary colors - Hunter Green (success)
      tertiary: FiftyColors.hunterGreen,
      onTertiary: FiftyColors.cream,
      tertiaryContainer: FiftyColors.hunterGreen.withValues(alpha: 0.15),
      onTertiaryContainer: FiftyColors.darkBurgundy,

      // Error colors - Burgundy
      error: FiftyColors.burgundy,
      onError: FiftyColors.cream,
      errorContainer: FiftyColors.burgundy.withValues(alpha: 0.15),
      onErrorContainer: FiftyColors.burgundy,

      // Surface colors - Warm cream base
      surface: FiftyColors.cream,
      onSurface: FiftyColors.darkBurgundy,
      surfaceContainerHighest: FiftyColors.surfaceLight,
      onSurfaceVariant: FiftyColors.slateGrey,

      // Outline colors - Black 5%
      outline: FiftyColors.borderLight,
      outlineVariant: Colors.black.withValues(alpha: 0.1),

      // Other
      shadow: Colors.black.withValues(alpha: 0.05),
      scrim: FiftyColors.darkBurgundy.withValues(alpha: 0.4),
      inverseSurface: FiftyColors.darkBurgundy,
      onInverseSurface: FiftyColors.cream,
      inversePrimary: FiftyColors.burgundy,
    );
  }
}
