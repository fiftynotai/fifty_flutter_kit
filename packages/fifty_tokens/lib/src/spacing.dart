/// Fifty.dev spacing tokens - 4px base grid system.
///
/// High density, tight gaps. Content is contained in modular bento units.
/// Base unit: 4px. Primary gaps: 8px (tight) and 12px (standard).
class FiftySpacing {
  FiftySpacing._();

  // ============================================================================
  // BASE UNIT (from FDL Brand Sheet)
  // ============================================================================

  /// Base unit (4px) - Fundamental spacing unit.
  ///
  /// All spacing values are multiples of this base.
  static const double base = 4;

  // ============================================================================
  // PRIMARY GAPS (from FDL Brand Sheet - "tight density")
  // ============================================================================

  /// Tight gap (8px) - Standard gap between elements.
  ///
  /// Use for:
  /// - Compact element spacing
  /// - Dense layouts
  /// - Bento grid gaps
  static const double tight = 8;

  /// Standard gap (12px) - Comfortable gap.
  ///
  /// Use for:
  /// - Card internal padding
  /// - Form field spacing
  /// - Moderate breathing room
  static const double standard = 12;

  // ============================================================================
  // SPACING SCALE (multiples of base unit)
  // ============================================================================

  /// 1x base (4px) - Minimal spacing.
  static const double xs = 4;

  /// 2x base (8px) - Tight spacing.
  static const double sm = 8;

  /// 3x base (12px) - Standard spacing.
  static const double md = 12;

  /// 4x base (16px) - Comfortable spacing.
  static const double lg = 16;

  /// 5x base (20px) - Generous spacing.
  static const double xl = 20;

  /// 6x base (24px) - Section spacing.
  static const double xxl = 24;

  /// 8x base (32px) - Major section spacing.
  static const double xxxl = 32;

  /// 10x base (40px) - Hero spacing.
  static const double huge = 40;

  /// 12x base (48px) - Page-level spacing.
  static const double massive = 48;

  // ============================================================================
  // RESPONSIVE GUTTERS
  // ============================================================================

  /// Desktop gutter (24px) - Wide screen margins.
  static const double gutterDesktop = 24;

  /// Tablet gutter (16px) - Medium screen margins.
  static const double gutterTablet = 16;

  /// Mobile gutter (12px) - Small screen margins.
  static const double gutterMobile = 12;
}
