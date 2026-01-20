import 'package:flutter/material.dart';
import 'colors.dart';

/// Fifty.dev shadow tokens v2 - Soft, sophisticated shadows.
///
/// Replaces the v1 "no shadows" philosophy with subtle depth.
class FiftyShadows {
  FiftyShadows._();

  // ============================================================================
  // SHADOW TOKENS (v2)
  // ============================================================================

  /// Small shadow - Subtle elevation.
  ///
  /// Use for: Hover states, subtle depth.
  /// Value: 0 1px 2px rgba(0,0,0,0.05)
  static const List<BoxShadow> sm = [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      color: Color(0x0D000000), // 5% opacity
    ),
  ];

  /// Medium shadow - Cards.
  ///
  /// Use for: Cards, elevated containers.
  /// Value: 0 4px 6px rgba(0,0,0,0.07)
  static const List<BoxShadow> md = [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 6,
      color: Color(0x12000000), // 7% opacity
    ),
  ];

  /// Large shadow - Modals and dropdowns.
  ///
  /// Use for: Modals, dropdowns, dialogs.
  /// Value: 0 10px 15px rgba(0,0,0,0.1)
  static const List<BoxShadow> lg = [
    BoxShadow(
      offset: Offset(0, 10),
      blurRadius: 15,
      color: Color(0x1A000000), // 10% opacity
    ),
  ];

  /// Primary shadow - Primary buttons.
  ///
  /// Use for: Primary action buttons.
  /// Value: 0 4px 14px rgba(136,41,47,0.2)
  static List<BoxShadow> get primary => [
    BoxShadow(
      offset: const Offset(0, 4),
      blurRadius: 14,
      color: FiftyColors.burgundy.withValues(alpha: 0.2),
    ),
  ];

  /// Glow shadow - Dark mode accent.
  ///
  /// Use for: Focus states in dark mode, accent highlights.
  /// Value: 0 0 15px rgba(254,254,227,0.1)
  static List<BoxShadow> get glow => [
    BoxShadow(
      blurRadius: 15,
      color: FiftyColors.cream.withValues(alpha: 0.1),
    ),
  ];

  /// No shadow - Explicit none.
  static const List<BoxShadow> none = [];
}

/// @deprecated Use [FiftyShadows] instead.
@Deprecated('Use FiftyShadows instead')
class FiftyElevation {
  FiftyElevation._();

  /// @deprecated Use [FiftyShadows.glow] instead.
  @Deprecated('Use FiftyShadows.glow instead')
  static List<BoxShadow> focusGlow(Color color) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.4),
        blurRadius: 8,
        spreadRadius: 2,
      ),
    ];
  }

  /// @deprecated Scanlines are removed in v2.
  @Deprecated('Scanlines are removed in v2 design system')
  static Widget scanlineOverlay({double opacity = 0.05}) {
    return const SizedBox.shrink();
  }
}
