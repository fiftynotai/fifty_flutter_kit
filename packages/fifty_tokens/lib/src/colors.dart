import 'package:flutter/material.dart';

/// Fifty.dev color tokens v2 - Sophisticated Warm design system.
///
/// All colors follow the Fifty Design Language (FDL) v2 specification.
/// Supports both dark mode (primary) and light mode.
class FiftyColors {
  FiftyColors._();

  // ============================================================================
  // CORE PALETTE (v2 - Sophisticated Warm)
  // ============================================================================

  /// Burgundy (#88292F) - Primary brand color.
  ///
  /// Use for:
  /// - Primary buttons and CTAs
  /// - Brand accents and highlights
  /// - Active states
  static const Color burgundy = Color(0xFF88292F);

  /// Burgundy Hover (#6E2126) - Primary hover state.
  static const Color burgundyHover = Color(0xFF6E2126);

  /// Cream (#FEFEE3) - Light background and dark mode text.
  ///
  /// Use for:
  /// - Light mode backgrounds
  /// - Dark mode primary text
  /// - Accent highlights
  static const Color cream = Color(0xFFFEFEE3);

  /// Dark Burgundy (#1A0D0E) - Dark mode background.
  ///
  /// Use for:
  /// - Dark mode backgrounds
  /// - Deep, immersive dark surfaces
  static const Color darkBurgundy = Color(0xFF1A0D0E);

  /// Slate Grey (#335C67) - Secondary color.
  ///
  /// Use for:
  /// - Secondary buttons
  /// - Switch on-state (NOT primary!)
  /// - Segmented control active state (dark mode)
  static const Color slateGrey = Color(0xFF335C67);

  /// Slate Grey Hover (#274750) - Secondary hover state.
  static const Color slateGreyHover = Color(0xFF274750);

  /// Hunter Green (#4B644A) - Success/positive color.
  ///
  /// Use for:
  /// - Success messages
  /// - Positive indicators
  /// - Confirmation states
  static const Color hunterGreen = Color(0xFF4B644A);

  /// Powder Blush (#FFC9B9) - Dark mode accent.
  ///
  /// Use for:
  /// - Dark mode accent color
  /// - Outline button borders (dark mode)
  /// - Focus rings (dark mode)
  static const Color powderBlush = Color(0xFFFFC9B9);

  /// Surface Light (#FAF9DE) - Light mode card/surface color.
  ///
  /// Darker cream shade creates contrast against cream background,
  /// giving cards depth while staying in the warm palette.
  static const Color surfaceLight = Color(0xFFFAF9DE);

  /// Surface Dark (#2A1517) - Dark mode surfaces/cards.
  static const Color surfaceDark = Color(0xFF2A1517);

  // ============================================================================
  // SEMANTIC COLORS
  // ============================================================================

  /// Primary - Alias for burgundy.
  static const Color primary = burgundy;

  /// Primary Hover - Alias for burgundyHover.
  static const Color primaryHover = burgundyHover;

  /// Secondary - Alias for slateGrey.
  static const Color secondary = slateGrey;

  /// Secondary Hover - Alias for slateGreyHover.
  static const Color secondaryHover = slateGreyHover;

  /// Success - Alias for hunterGreen.
  static const Color success = hunterGreen;

  /// Warning (#F7A100) - Caution states.
  static const Color warning = Color(0xFFF7A100);

  /// Error - Uses burgundy for consistency.
  static const Color error = burgundy;

  // ============================================================================
  // MODE-SPECIFIC HELPERS
  // ============================================================================

  /// Border color for light mode (black at 5% opacity).
  static Color get borderLight => Colors.black.withValues(alpha: 0.05);

  /// Border color for dark mode (white at 5% opacity).
  static Color get borderDark => Colors.white.withValues(alpha: 0.05);

  /// Focus border for light mode.
  static const Color focusLight = burgundy;

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
