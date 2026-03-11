import 'dart:math';

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Computes WCAG 2.x relative luminance of [color].
double _relativeLuminance(Color color) {
  double linearize(double c) {
    return c <= 0.04045 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4).toDouble();
  }

  final r = linearize(color.r);
  final g = linearize(color.g);
  final b = linearize(color.b);
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

/// Returns WCAG contrast ratio between two colors (>=1.0).
double _contrastRatio(Color a, Color b) {
  final la = _relativeLuminance(a);
  final lb = _relativeLuminance(b);
  final lighter = max(la, lb);
  final darker = min(la, lb);
  return (lighter + 0.05) / (darker + 0.05);
}

/// Derives an `onSurfaceVariant` color from [source] that has >=4.5:1
/// contrast against [surface], staying in the hue family of [source].
Color _deriveOnSurfaceVariant(
  Color source,
  Color surface,
  Brightness brightness,
) {
  final hsl = HSLColor.fromColor(source);
  final reducedSat = hsl.saturation * 0.6;
  var targetLightness = brightness == Brightness.dark ? 0.75 : 0.35;

  var candidate =
      HSLColor.fromAHSL(1.0, hsl.hue, reducedSat, targetLightness).toColor();

  // Nudge lightness until contrast is met
  final step = brightness == Brightness.dark ? 0.05 : -0.05;
  final cap = brightness == Brightness.dark ? 0.95 : 0.10;

  while (_contrastRatio(candidate, surface) < 4.5) {
    targetLightness += step;
    if ((brightness == Brightness.dark && targetLightness >= cap) ||
        (brightness == Brightness.light && targetLightness <= cap)) {
      targetLightness = cap;
      candidate =
          HSLColor.fromAHSL(1.0, hsl.hue, reducedSat, targetLightness)
              .toColor();
      break;
    }
    candidate =
        HSLColor.fromAHSL(1.0, hsl.hue, reducedSat, targetLightness).toColor();
  }

  return candidate;
}

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
  /// - `primary`: Brand primary (brand signature)
  /// - `secondary`: Secondary (secondary actions)
  /// - `surface`: Background dark (deep background)
  /// - `tertiary`: Success (success)
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

      // Primary colors
      primary: primary ?? FiftyColors.primary,
      onPrimary: onPrimary ?? FiftyColors.background,
      primaryContainer:
          (primary ?? FiftyColors.primary).withValues(alpha: 0.2),
      onPrimaryContainer: onPrimary ?? FiftyColors.background,

      // Secondary colors
      secondary: secondary ?? FiftyColors.secondary,
      onSecondary: onSecondary ?? FiftyColors.background,
      secondaryContainer:
          (secondary ?? FiftyColors.secondary).withValues(alpha: 0.2),
      onSecondaryContainer: onSecondary ?? FiftyColors.background,

      // Tertiary colors (success)
      tertiary: tertiary ?? FiftyColors.success,
      onTertiary: onTertiary ?? FiftyColors.background,
      tertiaryContainer:
          (tertiary ?? FiftyColors.success).withValues(alpha: 0.2),
      onTertiaryContainer: tertiary ?? FiftyColors.success,

      // Error colors
      error: error ?? FiftyColors.error,
      onError: onError ?? FiftyColors.background,
      errorContainer: (error ?? FiftyColors.error).withValues(alpha: 0.2),
      onErrorContainer: onError ?? FiftyColors.background,

      // Surface colors - dark background base
      surface: surface ?? FiftyColors.backgroundDark,
      onSurface: onSurface ?? FiftyColors.background,
      surfaceContainerHighest:
          surfaceContainerHighest ?? FiftyColors.surfaceDark,
      onSurfaceVariant: onSurfaceVariant ??
          _deriveOnSurfaceVariant(
            secondary ?? FiftyColors.secondary,
            surface ?? FiftyColors.backgroundDark,
            Brightness.dark,
          ),

      // Outline colors - White 5%
      outline: FiftyColors.borderDark,
      outlineVariant: Colors.white.withValues(alpha: 0.1),

      // Other - NOW using shadows
      shadow: Colors.black.withValues(alpha: 0.1),
      scrim: (surface ?? FiftyColors.backgroundDark).withValues(alpha: 0.8),
      inverseSurface: onSurface ?? FiftyColors.background,
      onInverseSurface: surface ?? FiftyColors.backgroundDark,
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

      // Primary colors
      primary: primary ?? FiftyColors.primary,
      onPrimary: onPrimary ?? FiftyColors.background,
      primaryContainer:
          (primary ?? FiftyColors.primary).withValues(alpha: 0.15),
      onPrimaryContainer: primary ?? FiftyColors.primary,

      // Secondary colors
      secondary: secondary ?? FiftyColors.secondary,
      onSecondary: onSecondary ?? FiftyColors.background,
      secondaryContainer:
          (secondary ?? FiftyColors.secondary).withValues(alpha: 0.2),
      onSecondaryContainer: onSurface ?? FiftyColors.backgroundDark,

      // Tertiary colors (success)
      tertiary: tertiary ?? FiftyColors.success,
      onTertiary: onTertiary ?? FiftyColors.background,
      tertiaryContainer:
          (tertiary ?? FiftyColors.success).withValues(alpha: 0.15),
      onTertiaryContainer: onSurface ?? FiftyColors.backgroundDark,

      // Error colors
      error: error ?? FiftyColors.error,
      onError: onError ?? FiftyColors.background,
      errorContainer: (error ?? FiftyColors.error).withValues(alpha: 0.15),
      onErrorContainer: error ?? FiftyColors.error,

      // Surface colors - light background base
      surface: surface ?? FiftyColors.background,
      onSurface: onSurface ?? FiftyColors.backgroundDark,
      surfaceContainerHighest:
          surfaceContainerHighest ?? FiftyColors.surface,
      onSurfaceVariant: onSurfaceVariant ??
          _deriveOnSurfaceVariant(
            secondary ?? FiftyColors.secondary,
            surface ?? FiftyColors.background,
            Brightness.light,
          ),

      // Outline colors - Black 5%
      outline: FiftyColors.borderLight,
      outlineVariant: Colors.black.withValues(alpha: 0.1),

      // Other
      shadow: Colors.black.withValues(alpha: 0.05),
      scrim: (onSurface ?? FiftyColors.backgroundDark).withValues(alpha: 0.4),
      inverseSurface: onSurface ?? FiftyColors.backgroundDark,
      onInverseSurface: surface ?? FiftyColors.background,
      inversePrimary: primary ?? FiftyColors.primary,
    );
  }
}
