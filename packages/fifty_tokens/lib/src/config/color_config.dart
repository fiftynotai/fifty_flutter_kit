import 'package:flutter/material.dart';

import 'parse_helpers.dart';

/// Configuration for color tokens.
///
/// All fields are required. Use [FiftyPreset.fdlV2.colors] as a starting
/// point and [copyWith] for partial overrides.
class FiftyColorConfig {
  /// Creates a [FiftyColorConfig] with all required fields.
  const FiftyColorConfig({
    required this.primary,
    required this.primaryHover,
    required this.background,
    required this.backgroundDark,
    required this.secondary,
    required this.secondaryHover,
    required this.success,
    required this.accent,
    required this.surface,
    required this.surfaceDark,
    required this.warning,
    required this.error,
    required this.onPrimary,
    required this.onBackground,
    required this.borderOpacity,
    required this.focusOpacity,
  });

  /// Build a [FiftyColorConfig] from a [Map]. Missing keys fall back
  /// to [fallback].
  factory FiftyColorConfig.fromMap(
    Map<String, dynamic> map, {
    required FiftyColorConfig fallback,
  }) {
    return FiftyColorConfig(
      primary: parseColor(map['primary']) ?? fallback.primary,
      primaryHover: parseColor(map['primaryHover']) ?? fallback.primaryHover,
      background: parseColor(map['background']) ?? fallback.background,
      backgroundDark:
          parseColor(map['backgroundDark']) ?? fallback.backgroundDark,
      secondary: parseColor(map['secondary']) ?? fallback.secondary,
      secondaryHover:
          parseColor(map['secondaryHover']) ?? fallback.secondaryHover,
      success: parseColor(map['success']) ?? fallback.success,
      accent: parseColor(map['accent']) ?? fallback.accent,
      surface: parseColor(map['surface']) ?? fallback.surface,
      surfaceDark: parseColor(map['surfaceDark']) ?? fallback.surfaceDark,
      warning: parseColor(map['warning']) ?? fallback.warning,
      error: parseColor(map['error']) ?? fallback.error,
      onPrimary: parseColor(map['onPrimary']) ?? fallback.onPrimary,
      onBackground:
          parseColor(map['onBackground']) ?? fallback.onBackground,
      borderOpacity:
          (map['borderOpacity'] as num?)?.toDouble() ?? fallback.borderOpacity,
      focusOpacity:
          (map['focusOpacity'] as num?)?.toDouble() ?? fallback.focusOpacity,
    );
  }

  /// Primary brand color.
  final Color primary;

  /// Primary hover state.
  final Color primaryHover;

  /// Light background color.
  final Color background;

  /// Dark background color.
  final Color backgroundDark;

  /// Secondary color.
  final Color secondary;

  /// Secondary hover state.
  final Color secondaryHover;

  /// Success / positive color.
  final Color success;

  /// Accent color (dark mode highlights, outline borders).
  final Color accent;

  /// Light mode card / surface color.
  final Color surface;

  /// Dark mode card / surface color.
  final Color surfaceDark;

  /// Warning color.
  final Color warning;

  /// Error color.
  final Color error;

  /// Color used on top of primary (e.g. button text).
  final Color onPrimary;

  /// Color used on top of background.
  final Color onBackground;

  /// Opacity for light/dark border helpers. Default: `0.05`.
  final double borderOpacity;

  /// Opacity for focus-dark helper. Default: `0.5`.
  final double focusOpacity;

  /// Returns a copy with the given fields replaced.
  FiftyColorConfig copyWith({
    Color? primary,
    Color? primaryHover,
    Color? background,
    Color? backgroundDark,
    Color? secondary,
    Color? secondaryHover,
    Color? success,
    Color? accent,
    Color? surface,
    Color? surfaceDark,
    Color? warning,
    Color? error,
    Color? onPrimary,
    Color? onBackground,
    double? borderOpacity,
    double? focusOpacity,
  }) {
    return FiftyColorConfig(
      primary: primary ?? this.primary,
      primaryHover: primaryHover ?? this.primaryHover,
      background: background ?? this.background,
      backgroundDark: backgroundDark ?? this.backgroundDark,
      secondary: secondary ?? this.secondary,
      secondaryHover: secondaryHover ?? this.secondaryHover,
      success: success ?? this.success,
      accent: accent ?? this.accent,
      surface: surface ?? this.surface,
      surfaceDark: surfaceDark ?? this.surfaceDark,
      warning: warning ?? this.warning,
      error: error ?? this.error,
      onPrimary: onPrimary ?? this.onPrimary,
      onBackground: onBackground ?? this.onBackground,
      borderOpacity: borderOpacity ?? this.borderOpacity,
      focusOpacity: focusOpacity ?? this.focusOpacity,
    );
  }
}
