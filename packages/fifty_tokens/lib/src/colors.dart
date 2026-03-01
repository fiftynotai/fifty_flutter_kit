import 'package:flutter/material.dart';

import 'config/fifty_tokens_config.dart';

/// Fifty.dev color tokens -- reads from the active [FiftyPreset].
///
/// All getters read from [FiftyTokens.active.colors]. Token class has
/// zero knowledge of FDL v2 or any preset -- it just reads.
class FiftyColors {
  FiftyColors._();

  // ============================================================================
  // SEMANTIC COLORS (agnostic readers)
  // ============================================================================

  /// Primary brand color.
  ///
  /// Use for:
  /// - Primary buttons and CTAs
  /// - Brand accents and highlights
  /// - Active states
  static Color get primary => FiftyTokens.active.colors.primary;

  /// Primary hover state.
  static Color get primaryHover => FiftyTokens.active.colors.primaryHover;

  /// Light background color.
  ///
  /// Use for:
  /// - Light mode backgrounds
  /// - Dark mode primary text
  /// - Accent highlights
  static Color get background => FiftyTokens.active.colors.background;

  /// Dark background color.
  ///
  /// Use for:
  /// - Dark mode backgrounds
  /// - Deep, immersive dark surfaces
  static Color get backgroundDark => FiftyTokens.active.colors.backgroundDark;

  /// Secondary color.
  ///
  /// Use for:
  /// - Secondary buttons
  /// - Switch on-state (NOT primary!)
  /// - Segmented control active state (dark mode)
  static Color get secondary => FiftyTokens.active.colors.secondary;

  /// Secondary hover state.
  static Color get secondaryHover => FiftyTokens.active.colors.secondaryHover;

  /// Success / positive color.
  ///
  /// Use for:
  /// - Success messages
  /// - Positive indicators
  /// - Confirmation states
  static Color get success => FiftyTokens.active.colors.success;

  /// Accent color (dark mode highlights, outline borders).
  ///
  /// Use for:
  /// - Dark mode accent color
  /// - Outline button borders (dark mode)
  /// - Focus rings (dark mode)
  static Color get accent => FiftyTokens.active.colors.accent;

  /// Light mode card / surface color.
  ///
  /// Darker shade creates contrast against background,
  /// giving cards depth while staying in the warm palette.
  static Color get surface => FiftyTokens.active.colors.surface;

  /// Dark mode card / surface color.
  static Color get surfaceDark => FiftyTokens.active.colors.surfaceDark;

  /// Warning color.
  static Color get warning => FiftyTokens.active.colors.warning;

  /// Error color.
  static Color get error => FiftyTokens.active.colors.error;

  /// Color used on top of primary (e.g. button text).
  static Color get onPrimary => FiftyTokens.active.colors.onPrimary;

  /// Color used on top of background.
  static Color get onBackground => FiftyTokens.active.colors.onBackground;

  // ============================================================================
  // COMPUTED COLORS
  // ============================================================================

  /// Border color for light mode (black at configurable opacity).
  static Color get borderLight =>
      Colors.black.withValues(alpha: FiftyTokens.active.colors.borderOpacity);

  /// Border color for dark mode (white at configurable opacity).
  static Color get borderDark =>
      Colors.white.withValues(alpha: FiftyTokens.active.colors.borderOpacity);

  /// Focus border for light mode -- same as primary.
  static Color get focusLight => primary;

  /// Focus border for dark mode (accent at configurable opacity).
  static Color get focusDark =>
      accent.withValues(alpha: FiftyTokens.active.colors.focusOpacity);

  // ============================================================================
  // DEPRECATED v2 palette names (use semantic names above)
  // ============================================================================

  /// @deprecated Use [primary] instead.
  @Deprecated('Use primary instead')
  static Color get burgundy => primary;

  /// @deprecated Use [primaryHover] instead.
  @Deprecated('Use primaryHover instead')
  static Color get burgundyHover => primaryHover;

  /// @deprecated Use [background] instead.
  @Deprecated('Use background instead')
  static Color get cream => background;

  /// @deprecated Use [backgroundDark] instead.
  @Deprecated('Use backgroundDark instead')
  static Color get darkBurgundy => backgroundDark;

  /// @deprecated Use [secondary] instead.
  @Deprecated('Use secondary instead')
  static Color get slateGrey => secondary;

  /// @deprecated Use [secondaryHover] instead.
  @Deprecated('Use secondaryHover instead')
  static Color get slateGreyHover => secondaryHover;

  /// @deprecated Use [success] instead.
  @Deprecated('Use success instead')
  static Color get hunterGreen => success;

  /// @deprecated Use [accent] instead.
  @Deprecated('Use accent instead')
  static Color get powderBlush => accent;

  /// @deprecated Use [surface] instead.
  @Deprecated('Use surface instead')
  static Color get surfaceLight => surface;

  // ============================================================================
  // DEPRECATED v1 colors (backward compatibility -- remove in next major)
  // ============================================================================

  /// @deprecated Use [backgroundDark] for dark backgrounds or [background] for light backgrounds.
  @Deprecated(
      'Use backgroundDark for dark backgrounds or background for light backgrounds')
  static const Color voidBlack = Color(0xFF050505);

  /// @deprecated Use [primary] instead.
  @Deprecated('Use primary instead')
  static const Color crimsonPulse = Color(0xFF960E29);

  /// @deprecated Use [surfaceDark] instead.
  @Deprecated('Use surfaceDark instead')
  static const Color gunmetal = Color(0xFF1A1A1A);

  /// @deprecated Use [background] instead.
  @Deprecated('Use background instead')
  static const Color terminalWhite = Color(0xFFEAEAEA);

  /// @deprecated Use [secondary] instead.
  @Deprecated('Use secondary instead')
  static const Color hyperChrome = Color(0xFF888888);

  /// @deprecated Use [success] instead.
  @Deprecated('Use success instead')
  static const Color igrisGreen = Color(0xFF00FF41);

  /// @deprecated Use [borderLight] or [borderDark] instead.
  @Deprecated('Use borderLight or borderDark instead')
  static const Color border = Color(0x1A888888);
}
