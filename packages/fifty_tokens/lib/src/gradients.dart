import 'package:flutter/material.dart';

import 'colors.dart';
import 'config/fifty_tokens_config.dart';

/// Fifty.dev gradient tokens -- reads from the active [FiftyPreset].
///
/// Gradient definitions for the design system. Gradients dynamically
/// reference [FiftyColors] getters, so they respond to color
/// configuration automatically.
class FiftyGradients {
  FiftyGradients._();

  // ============================================================================
  // GRADIENT TOKENS (v2)
  // ============================================================================

  /// Primary gradient - Hero sections.
  ///
  /// Use for: Hero backgrounds, featured cards.
  /// Linear: primary -> primaryEnd
  static LinearGradient get primary => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [FiftyColors.primary, FiftyTokens.active.gradients.primaryEnd],
      );

  /// Progress gradient - Progress indicators.
  ///
  /// Use for: Progress bars, loading indicators.
  /// Linear: accent -> primary
  static LinearGradient get progress => LinearGradient(
        colors: [FiftyColors.accent, FiftyColors.primary],
      );

  /// Surface gradient - Subtle depth (dark mode).
  ///
  /// Use for: Background depth, card overlays.
  /// Linear: backgroundDark -> surfaceDark
  static LinearGradient get surface => LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [FiftyColors.backgroundDark, FiftyColors.surfaceDark],
      );
}
