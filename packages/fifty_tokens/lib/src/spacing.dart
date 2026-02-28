import 'package:meta/meta.dart';

import 'config/spacing_config.dart';

/// Fifty.dev spacing tokens - 4px base grid system.
///
/// High density, tight gaps. Content is contained in modular bento units.
/// Base unit: 4px. Primary gaps: 8px (tight) and 12px (standard).
///
/// Override defaults via [FiftyTokens.configure()] with a [FiftySpacingConfig].
class FiftySpacing {
  FiftySpacing._();

  /// Internal config -- set via [FiftyTokens.configure()].
  /// Do not set directly.
  @internal
  static FiftySpacingConfig? config;

  // ============================================================================
  // BASE UNIT (from FDL Brand Sheet)
  // ============================================================================

  static const double _defaultBase = 4;

  /// Base unit (4px) - Fundamental spacing unit.
  ///
  /// All spacing values are multiples of this base.
  static double get base => config?.base ?? _defaultBase;

  // ============================================================================
  // PRIMARY GAPS (from FDL Brand Sheet - "tight density")
  // ============================================================================

  static const double _defaultTight = 8;
  static const double _defaultStandard = 12;

  /// Tight gap (8px) - Standard gap between elements.
  ///
  /// Use for:
  /// - Compact element spacing
  /// - Dense layouts
  /// - Bento grid gaps
  static double get tight => config?.tight ?? _defaultTight;

  /// Standard gap (12px) - Comfortable gap.
  ///
  /// Use for:
  /// - Card internal padding
  /// - Form field spacing
  /// - Moderate breathing room
  static double get standard => config?.standard ?? _defaultStandard;

  // ============================================================================
  // SPACING SCALE (multiples of base unit)
  // ============================================================================

  static const double _defaultXs = 4;
  static const double _defaultSm = 8;
  static const double _defaultMd = 12;
  static const double _defaultLg = 16;
  static const double _defaultXl = 20;
  static const double _defaultXxl = 24;
  static const double _defaultXxxl = 32;
  static const double _defaultHuge = 40;
  static const double _defaultMassive = 48;

  /// 1x base (4px) - Minimal spacing.
  static double get xs => config?.xs ?? _defaultXs;

  /// 2x base (8px) - Tight spacing.
  static double get sm => config?.sm ?? _defaultSm;

  /// 3x base (12px) - Standard spacing.
  static double get md => config?.md ?? _defaultMd;

  /// 4x base (16px) - Comfortable spacing.
  static double get lg => config?.lg ?? _defaultLg;

  /// 5x base (20px) - Generous spacing.
  static double get xl => config?.xl ?? _defaultXl;

  /// 6x base (24px) - Section spacing.
  static double get xxl => config?.xxl ?? _defaultXxl;

  /// 8x base (32px) - Major section spacing.
  static double get xxxl => config?.xxxl ?? _defaultXxxl;

  /// 10x base (40px) - Hero spacing.
  static double get huge => config?.huge ?? _defaultHuge;

  /// 12x base (48px) - Page-level spacing.
  static double get massive => config?.massive ?? _defaultMassive;

  // ============================================================================
  // RESPONSIVE GUTTERS
  // ============================================================================

  static const double _defaultGutterDesktop = 24;
  static const double _defaultGutterTablet = 16;
  static const double _defaultGutterMobile = 12;

  /// Desktop gutter (24px) - Wide screen margins.
  static double get gutterDesktop =>
      config?.gutterDesktop ?? _defaultGutterDesktop;

  /// Tablet gutter (16px) - Medium screen margins.
  static double get gutterTablet =>
      config?.gutterTablet ?? _defaultGutterTablet;

  /// Mobile gutter (12px) - Small screen margins.
  static double get gutterMobile =>
      config?.gutterMobile ?? _defaultGutterMobile;
}
