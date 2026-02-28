import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'config/color_config.dart';

/// Fifty.dev color tokens v2 - Sophisticated Warm design system.
///
/// All colors follow the Fifty Design Language (FDL) v2 specification.
/// Supports both dark mode (primary) and light mode.
///
/// Override defaults via [FiftyTokens.configure()] with a [FiftyColorConfig].
class FiftyColors {
  FiftyColors._();

  /// Internal config -- set via [FiftyTokens.configure()].
  /// Do not set directly.
  @internal
  static FiftyColorConfig? config;

  // ============================================================================
  // CORE PALETTE (v2 - Sophisticated Warm)
  // ============================================================================

  static const Color _defaultBurgundy = Color(0xFF88292F);
  static const Color _defaultBurgundyHover = Color(0xFF6E2126);
  static const Color _defaultCream = Color(0xFFFEFEE3);
  static const Color _defaultDarkBurgundy = Color(0xFF1A0D0E);
  static const Color _defaultSlateGrey = Color(0xFF335C67);
  static const Color _defaultSlateGreyHover = Color(0xFF274750);
  static const Color _defaultHunterGreen = Color(0xFF4B644A);
  static const Color _defaultPowderBlush = Color(0xFFFFC9B9);
  static const Color _defaultSurfaceLight = Color(0xFFFAF9DE);
  static const Color _defaultSurfaceDark = Color(0xFF2A1517);
  static const Color _defaultWarning = Color(0xFFF7A100);

  /// Burgundy (#88292F) - Primary brand color.
  ///
  /// Use for:
  /// - Primary buttons and CTAs
  /// - Brand accents and highlights
  /// - Active states
  static Color get burgundy => config?.burgundy ?? _defaultBurgundy;

  /// Burgundy Hover (#6E2126) - Primary hover state.
  static Color get burgundyHover =>
      config?.burgundyHover ?? _defaultBurgundyHover;

  /// Cream (#FEFEE3) - Light background and dark mode text.
  ///
  /// Use for:
  /// - Light mode backgrounds
  /// - Dark mode primary text
  /// - Accent highlights
  static Color get cream => config?.cream ?? _defaultCream;

  /// Dark Burgundy (#1A0D0E) - Dark mode background.
  ///
  /// Use for:
  /// - Dark mode backgrounds
  /// - Deep, immersive dark surfaces
  static Color get darkBurgundy =>
      config?.darkBurgundy ?? _defaultDarkBurgundy;

  /// Slate Grey (#335C67) - Secondary color.
  ///
  /// Use for:
  /// - Secondary buttons
  /// - Switch on-state (NOT primary!)
  /// - Segmented control active state (dark mode)
  static Color get slateGrey => config?.slateGrey ?? _defaultSlateGrey;

  /// Slate Grey Hover (#274750) - Secondary hover state.
  static Color get slateGreyHover =>
      config?.slateGreyHover ?? _defaultSlateGreyHover;

  /// Hunter Green (#4B644A) - Success/positive color.
  ///
  /// Use for:
  /// - Success messages
  /// - Positive indicators
  /// - Confirmation states
  static Color get hunterGreen => config?.hunterGreen ?? _defaultHunterGreen;

  /// Powder Blush (#FFC9B9) - Dark mode accent.
  ///
  /// Use for:
  /// - Dark mode accent color
  /// - Outline button borders (dark mode)
  /// - Focus rings (dark mode)
  static Color get powderBlush => config?.powderBlush ?? _defaultPowderBlush;

  /// Surface Light (#FAF9DE) - Light mode card/surface color.
  ///
  /// Darker cream shade creates contrast against cream background,
  /// giving cards depth while staying in the warm palette.
  static Color get surfaceLight =>
      config?.surfaceLight ?? _defaultSurfaceLight;

  /// Surface Dark (#2A1517) - Dark mode surfaces/cards.
  static Color get surfaceDark => config?.surfaceDark ?? _defaultSurfaceDark;

  // ============================================================================
  // SEMANTIC COLORS
  // ============================================================================

  /// Primary - Alias for burgundy.
  ///
  /// Falls back to [burgundy] getter when not explicitly overridden,
  /// so overriding burgundy also changes primary.
  static Color get primary => config?.primary ?? burgundy;

  /// Primary Hover - Alias for burgundyHover.
  static Color get primaryHover => config?.primaryHover ?? burgundyHover;

  /// Secondary - Alias for slateGrey.
  static Color get secondary => config?.secondary ?? slateGrey;

  /// Secondary Hover - Alias for slateGreyHover.
  static Color get secondaryHover =>
      config?.secondaryHover ?? slateGreyHover;

  /// Success - Alias for hunterGreen.
  static Color get success => config?.success ?? hunterGreen;

  /// Warning (#F7A100) - Caution states.
  static Color get warning => config?.warning ?? _defaultWarning;

  /// Error - Uses primary for consistency.
  ///
  /// Falls back to [primary] getter when not explicitly overridden.
  static Color get error => config?.error ?? primary;

  // ============================================================================
  // MODE-SPECIFIC HELPERS
  // ============================================================================

  /// Border color for light mode (black at 5% opacity).
  static Color get borderLight => Colors.black.withValues(alpha: 0.05);

  /// Border color for dark mode (white at 5% opacity).
  static Color get borderDark => Colors.white.withValues(alpha: 0.05);

  /// Focus border for light mode.
  ///
  /// Falls back to [primary] getter when not explicitly overridden.
  static Color get focusLight => config?.focusLight ?? primary;

  /// Focus border for dark mode (powderBlush at 50% opacity).
  static Color get focusDark => powderBlush.withValues(alpha: 0.5);

  // ============================================================================
  // DEPRECATED (v1 compatibility - remove in v2.0.0)
  // ============================================================================

  /// @deprecated Use [darkBurgundy] or [cream] instead.
  @Deprecated('Use darkBurgundy for dark backgrounds or cream for light backgrounds')
  static const Color voidBlack = Color(0xFF050505);

  /// @deprecated Use [burgundy] instead.
  @Deprecated('Use burgundy instead')
  static const Color crimsonPulse = Color(0xFF960E29);

  /// @deprecated Use [surfaceDark] instead.
  @Deprecated('Use surfaceDark instead')
  static const Color gunmetal = Color(0xFF1A1A1A);

  /// @deprecated Use [cream] instead.
  @Deprecated('Use cream instead')
  static const Color terminalWhite = Color(0xFFEAEAEA);

  /// @deprecated Use [slateGrey] instead.
  @Deprecated('Use slateGrey instead')
  static const Color hyperChrome = Color(0xFF888888);

  /// @deprecated Use [hunterGreen] instead.
  @Deprecated('Use hunterGreen instead')
  static const Color igrisGreen = Color(0xFF00FF41);

  /// @deprecated Use [borderLight] or [borderDark] instead.
  @Deprecated('Use borderLight or borderDark instead')
  static const Color border = Color(0x1A888888);
}
