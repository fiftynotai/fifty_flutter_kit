/// Configuration for spacing tokens.
///
/// All fields are required. Use [FiftyPreset.fdlV2.spacing] as a starting
/// point and [copyWith] for partial overrides.
class FiftySpacingConfig {
  /// Creates a [FiftySpacingConfig] with all required fields.
  const FiftySpacingConfig({
    required this.base,
    required this.tight,
    required this.standard,
    required this.xxs,
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.huge,
    required this.massive,
    required this.gutterDesktop,
    required this.gutterTablet,
    required this.gutterMobile,
  });

  /// Build a [FiftySpacingConfig] from a [Map]. Missing keys fall back
  /// to [fallback].
  factory FiftySpacingConfig.fromMap(
    Map<String, dynamic> map, {
    required FiftySpacingConfig fallback,
  }) {
    return FiftySpacingConfig(
      base: (map['base'] as num?)?.toDouble() ?? fallback.base,
      tight: (map['tight'] as num?)?.toDouble() ?? fallback.tight,
      standard: (map['standard'] as num?)?.toDouble() ?? fallback.standard,
      xxs: (map['xxs'] as num?)?.toDouble() ?? fallback.xxs,
      xs: (map['xs'] as num?)?.toDouble() ?? fallback.xs,
      sm: (map['sm'] as num?)?.toDouble() ?? fallback.sm,
      md: (map['md'] as num?)?.toDouble() ?? fallback.md,
      lg: (map['lg'] as num?)?.toDouble() ?? fallback.lg,
      xl: (map['xl'] as num?)?.toDouble() ?? fallback.xl,
      xxl: (map['xxl'] as num?)?.toDouble() ?? fallback.xxl,
      xxxl: (map['xxxl'] as num?)?.toDouble() ?? fallback.xxxl,
      huge: (map['huge'] as num?)?.toDouble() ?? fallback.huge,
      massive: (map['massive'] as num?)?.toDouble() ?? fallback.massive,
      gutterDesktop:
          (map['gutterDesktop'] as num?)?.toDouble() ?? fallback.gutterDesktop,
      gutterTablet:
          (map['gutterTablet'] as num?)?.toDouble() ?? fallback.gutterTablet,
      gutterMobile:
          (map['gutterMobile'] as num?)?.toDouble() ?? fallback.gutterMobile,
    );
  }

  /// Base spacing unit. Default: `4`.
  final double base;

  /// Tight gap. Default: `8`.
  final double tight;

  /// Standard gap. Default: `12`.
  final double standard;

  /// Extra-extra-small spacing. Default: `2`.
  final double xxs;

  /// Extra-small spacing. Default: `4`.
  final double xs;

  /// Small spacing. Default: `8`.
  final double sm;

  /// Medium spacing. Default: `12`.
  final double md;

  /// Large spacing. Default: `16`.
  final double lg;

  /// Extra-large spacing. Default: `20`.
  final double xl;

  /// 2X large spacing. Default: `24`.
  final double xxl;

  /// 3X large spacing. Default: `32`.
  final double xxxl;

  /// Huge spacing. Default: `40`.
  final double huge;

  /// Massive spacing. Default: `48`.
  final double massive;

  /// Desktop gutter. Default: `24`.
  final double gutterDesktop;

  /// Tablet gutter. Default: `16`.
  final double gutterTablet;

  /// Mobile gutter. Default: `12`.
  final double gutterMobile;

  /// Returns a copy with the given fields replaced.
  FiftySpacingConfig copyWith({
    double? base,
    double? tight,
    double? standard,
    double? xxs,
    double? xs,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
    double? huge,
    double? massive,
    double? gutterDesktop,
    double? gutterTablet,
    double? gutterMobile,
  }) {
    return FiftySpacingConfig(
      base: base ?? this.base,
      tight: tight ?? this.tight,
      standard: standard ?? this.standard,
      xxs: xxs ?? this.xxs,
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
      huge: huge ?? this.huge,
      massive: massive ?? this.massive,
      gutterDesktop: gutterDesktop ?? this.gutterDesktop,
      gutterTablet: gutterTablet ?? this.gutterTablet,
      gutterMobile: gutterMobile ?? this.gutterMobile,
    );
  }
}
