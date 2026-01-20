import 'package:flutter/material.dart';

/// Fifty.dev gradient tokens v2.
///
/// Gradient definitions for the Sophisticated Warm design system.
class FiftyGradients {
  FiftyGradients._();

  // ============================================================================
  // GRADIENT TOKENS (v2)
  // ============================================================================

  /// Primary gradient - Hero sections.
  ///
  /// Use for: Hero backgrounds, featured cards.
  /// Linear: burgundy (#88292F) → darker burgundy (#5A1B1F)
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF88292F),
      Color(0xFF5A1B1F),
    ],
  );

  /// Progress gradient - Progress indicators.
  ///
  /// Use for: Progress bars, loading indicators.
  /// Linear: powderBlush (#FFC9B9) → burgundy (#88292F)
  static const LinearGradient progress = LinearGradient(
    colors: [
      Color(0xFFFFC9B9),
      Color(0xFF88292F),
    ],
  );

  /// Surface gradient - Subtle depth (dark mode).
  ///
  /// Use for: Background depth, card overlays.
  /// Linear: darkBurgundy (#1A0D0E) → surfaceDark (#2A1517)
  static const LinearGradient surface = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1A0D0E),
      Color(0xFF2A1517),
    ],
  );
}
