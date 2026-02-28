import 'package:flutter/material.dart';

import 'colors.dart';

/// Fifty.dev gradient tokens v2.
///
/// Gradient definitions for the Sophisticated Warm design system.
/// Gradients dynamically reference [FiftyColors] getters, so they
/// respond to color configuration automatically.
class FiftyGradients {
  FiftyGradients._();

  /// Private gradient endpoint color not in the core palette.
  static const Color _defaultPrimaryEnd = Color(0xFF5A1B1F);

  // ============================================================================
  // GRADIENT TOKENS (v2)
  // ============================================================================

  /// Primary gradient - Hero sections.
  ///
  /// Use for: Hero backgrounds, featured cards.
  /// Linear: burgundy -> darker burgundy (#5A1B1F)
  static LinearGradient get primary => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          FiftyColors.burgundy,
          _defaultPrimaryEnd,
        ],
      );

  /// Progress gradient - Progress indicators.
  ///
  /// Use for: Progress bars, loading indicators.
  /// Linear: powderBlush -> burgundy
  static LinearGradient get progress => LinearGradient(
        colors: [
          FiftyColors.powderBlush,
          FiftyColors.burgundy,
        ],
      );

  /// Surface gradient - Subtle depth (dark mode).
  ///
  /// Use for: Background depth, card overlays.
  /// Linear: darkBurgundy -> surfaceDark
  static LinearGradient get surface => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          FiftyColors.darkBurgundy,
          FiftyColors.surfaceDark,
        ],
      );
}
