import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Fifty.dev color scheme builder v2 - Sophisticated Warm.
///
/// Maps FiftyColors v2 tokens to Flutter's ColorScheme.
/// Dark mode remains primary following FDL specification.
///
/// All parameters are optional. When omitted, the corresponding
/// [FiftyColors] getter is used as the default (which itself reads
/// from [FiftyTokens.configure] if set, or falls back to the FDL
/// default).
class FiftyColorScheme {
  FiftyColorScheme._();

  /// Creates a dark ColorScheme using Fifty v2 design tokens.
  ///
  /// Color mappings:
  /// - `primary`: Burgundy (brand signature)
  /// - `secondary`: Slate Grey (secondary actions)
  /// - `surface`: Dark Burgundy (deep background)
  /// - `tertiary`: Hunter Green (success)
  ///
  /// Pass optional overrides to customize individual slots.
  static ColorScheme dark({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? tertiary,
    Color? onTertiary,
    Color? error,
    Color? onError,
    Color? surface,
    Color? onSurface,
    Color? surfaceContainerHighest,
    Color? onSurfaceVariant,
  }) {
    return ColorScheme(
      brightness: Brightness.dark,

      // Primary colors - Burgundy
      primary: primary ?? FiftyColors.primary,
      onPrimary: onPrimary ?? FiftyColors.cream,
      primaryContainer:
          (primary ?? FiftyColors.primary).withValues(alpha: 0.2),
      onPrimaryContainer: onPrimary ?? FiftyColors.cream,

      // Secondary colors - Slate Grey
      secondary: secondary ?? FiftyColors.secondary,
      onSecondary: onSecondary ?? FiftyColors.cream,
      secondaryContainer:
          (secondary ?? FiftyColors.secondary).withValues(alpha: 0.2),
      onSecondaryContainer: onSecondary ?? FiftyColors.cream,

      // Tertiary colors - Hunter Green (success)
      tertiary: tertiary ?? FiftyColors.success,
      onTertiary: onTertiary ?? FiftyColors.cream,
      tertiaryContainer:
          (tertiary ?? FiftyColors.success).withValues(alpha: 0.2),
      onTertiaryContainer: tertiary ?? FiftyColors.success,

      // Error colors
      error: error ?? FiftyColors.error,
      onError: onError ?? FiftyColors.cream,
      errorContainer: (error ?? FiftyColors.error).withValues(alpha: 0.2),
      onErrorContainer: onError ?? FiftyColors.cream,

      // Surface colors - Dark Burgundy base
      surface: surface ?? FiftyColors.darkBurgundy,
      onSurface: onSurface ?? FiftyColors.cream,
      surfaceContainerHighest:
          surfaceContainerHighest ?? FiftyColors.surfaceDark,
      onSurfaceVariant: onSurfaceVariant ?? FiftyColors.secondary,

      // Outline colors - White 5%
      outline: FiftyColors.borderDark,
      outlineVariant: Colors.white.withValues(alpha: 0.1),

      // Other - NOW using shadows
      shadow: Colors.black.withValues(alpha: 0.1),
      scrim: (surface ?? FiftyColors.darkBurgundy).withValues(alpha: 0.8),
      inverseSurface: onSurface ?? FiftyColors.cream,
      onInverseSurface: surface ?? FiftyColors.darkBurgundy,
      inversePrimary: primary ?? FiftyColors.primary,
    );
  }

  /// Creates a light ColorScheme using Fifty v2 design tokens.
  ///
  /// Pass optional overrides to customize individual slots.
  static ColorScheme light({
    Color? primary,
    Color? onPrimary,
    Color? secondary,
    Color? onSecondary,
    Color? tertiary,
    Color? onTertiary,
    Color? error,
    Color? onError,
    Color? surface,
    Color? onSurface,
    Color? surfaceContainerHighest,
    Color? onSurfaceVariant,
  }) {
    return ColorScheme(
      brightness: Brightness.light,

      // Primary colors - Burgundy
      primary: primary ?? FiftyColors.primary,
      onPrimary: onPrimary ?? FiftyColors.cream,
      primaryContainer:
          (primary ?? FiftyColors.primary).withValues(alpha: 0.15),
      onPrimaryContainer: primary ?? FiftyColors.primary,

      // Secondary colors - Slate Grey
      secondary: secondary ?? FiftyColors.secondary,
      onSecondary: onSecondary ?? FiftyColors.cream,
      secondaryContainer:
          (secondary ?? FiftyColors.secondary).withValues(alpha: 0.2),
      onSecondaryContainer: onSurface ?? FiftyColors.darkBurgundy,

      // Tertiary colors - Hunter Green (success)
      tertiary: tertiary ?? FiftyColors.success,
      onTertiary: onTertiary ?? FiftyColors.cream,
      tertiaryContainer:
          (tertiary ?? FiftyColors.success).withValues(alpha: 0.15),
      onTertiaryContainer: onSurface ?? FiftyColors.darkBurgundy,

      // Error colors
      error: error ?? FiftyColors.error,
      onError: onError ?? FiftyColors.cream,
      errorContainer: (error ?? FiftyColors.error).withValues(alpha: 0.15),
      onErrorContainer: error ?? FiftyColors.error,

      // Surface colors - Warm cream base
      surface: surface ?? FiftyColors.cream,
      onSurface: onSurface ?? FiftyColors.darkBurgundy,
      surfaceContainerHighest:
          surfaceContainerHighest ?? FiftyColors.surfaceLight,
      onSurfaceVariant: onSurfaceVariant ?? FiftyColors.secondary,

      // Outline colors - Black 5%
      outline: FiftyColors.borderLight,
      outlineVariant: Colors.black.withValues(alpha: 0.1),

      // Other
      shadow: Colors.black.withValues(alpha: 0.05),
      scrim: (onSurface ?? FiftyColors.darkBurgundy).withValues(alpha: 0.4),
      inverseSurface: onSurface ?? FiftyColors.darkBurgundy,
      onInverseSurface: surface ?? FiftyColors.cream,
      inversePrimary: primary ?? FiftyColors.primary,
    );
  }
}
