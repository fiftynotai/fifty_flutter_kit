import 'config/fifty_tokens_config.dart';

/// Fifty.dev spacing tokens -- reads from the active [FiftyPreset].
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
  static double get base => FiftyTokens.active.spacing.base;

  // ============================================================================
  // PRIMARY GAPS (from FDL Brand Sheet - "tight density")
  // ============================================================================

  /// Tight gap (8px) - Standard gap between elements.
  ///
  /// Use for:
  /// - Compact element spacing
  /// - Dense layouts
  /// - Bento grid gaps
  static double get tight => FiftyTokens.active.spacing.tight;

  /// Standard gap (12px) - Comfortable gap.
  ///
  /// Use for:
  /// - Card internal padding
  /// - Form field spacing
  /// - Moderate breathing room
  static double get standard => FiftyTokens.active.spacing.standard;

  // ============================================================================
  // SPACING SCALE (multiples of base unit)
  // ============================================================================

  /// 1x base (4px) - Minimal spacing.
  static double get xs => FiftyTokens.active.spacing.xs;

  /// 2x base (8px) - Tight spacing.
  static double get sm => FiftyTokens.active.spacing.sm;

  /// 3x base (12px) - Standard spacing.
  static double get md => FiftyTokens.active.spacing.md;

  /// 4x base (16px) - Comfortable spacing.
  static double get lg => FiftyTokens.active.spacing.lg;

  /// 5x base (20px) - Generous spacing.
  static double get xl => FiftyTokens.active.spacing.xl;

  /// 6x base (24px) - Section spacing.
  static double get xxl => FiftyTokens.active.spacing.xxl;

  /// 8x base (32px) - Major section spacing.
  static double get xxxl => FiftyTokens.active.spacing.xxxl;

  /// 10x base (40px) - Hero spacing.
  static double get huge => FiftyTokens.active.spacing.huge;

  /// 12x base (48px) - Page-level spacing.
  static double get massive => FiftyTokens.active.spacing.massive;

  // ============================================================================
  // RESPONSIVE GUTTERS
  // ============================================================================

  /// Desktop gutter (24px) - Wide screen margins.
  static double get gutterDesktop => FiftyTokens.active.spacing.gutterDesktop;

  /// Tablet gutter (16px) - Medium screen margins.
  static double get gutterTablet => FiftyTokens.active.spacing.gutterTablet;

  /// Mobile gutter (12px) - Small screen margins.
  static double get gutterMobile => FiftyTokens.active.spacing.gutterMobile;
}
