import 'package:flutter/material.dart';

import 'colors.dart';

/// Fifty.dev elevation tokens - glows only.
///
/// Philosophy: "No drop shadows. Use Outlines and Overlays."
/// Exception: Crimson glow for focus/hover states (brand signature).
///
/// Depth is created through surface colors (voidBlack -> gunmetal),
/// not through shadow projections.
class FiftyElevation {
  FiftyElevation._();

  // ============================================================================
  // GLOW EFFECTS (Brand Signature)
  // ============================================================================

  /// Crimson glow - Focus and hover states.
  ///
  /// The signature fifty.dev visual effect.
  /// Use for:
  /// - Focus rings
  /// - Hover states
  /// - Active elements
  /// - CMD prompt glow
  ///
  /// Apply sparingly for maximum impact.
  static final BoxShadow crimsonGlow = BoxShadow(
    color: FiftyColors.crimsonPulse.withValues(alpha: 0.45),
    blurRadius: 8,
  );

  /// Focus ring - Keyboard accessibility indicator.
  ///
  /// Use for:
  /// - Keyboard focus states
  /// - Accessibility indicators
  /// - Active element highlighting
  static final BoxShadow focusRing = BoxShadow(
    color: FiftyColors.crimsonPulse.withValues(alpha: 0.6),
    blurRadius: 4,
  );

  // ============================================================================
  // GLOW LISTS (Convenience)
  // ============================================================================

  /// Focus state - Standard crimson glow.
  ///
  /// Use for interactive element focus states.
  static final List<BoxShadow> focus = [crimsonGlow];

  /// Strong focus - Enhanced glow for emphasis.
  ///
  /// Use for active/selected states requiring more prominence.
  static final List<BoxShadow> strongFocus = [focusRing, crimsonGlow];

  // ============================================================================
  // DEPTH WITHOUT SHADOWS
  // ============================================================================
  // Instead of drop shadows, use:
  // - Surface colors: voidBlack (#050505) -> gunmetal (#1A1A1A)
  // - Borders: 1px solid hyperChrome @ 10% opacity
  // - Overlays: Glassmorphism with blur (Blur 20px)
  // - Halftone textures: 5% opacity overlays
}
