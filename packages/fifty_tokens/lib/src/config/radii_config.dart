/// Configuration for border radius tokens.
///
/// All fields are required. Use [FiftyPreset.fdlV2.radii] as a starting
/// point and [copyWith] for partial overrides.
class FiftyRadiiConfig {
  /// Creates a [FiftyRadiiConfig] with all required fields.
  const FiftyRadiiConfig({
    required this.none,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.xxxl,
    required this.full,
  });

  /// Build a [FiftyRadiiConfig] from a [Map]. Missing keys fall back
  /// to [fallback].
  factory FiftyRadiiConfig.fromMap(
    Map<String, dynamic> map, {
    required FiftyRadiiConfig fallback,
  }) {
    return FiftyRadiiConfig(
      none: (map['none'] as num?)?.toDouble() ?? fallback.none,
      sm: (map['sm'] as num?)?.toDouble() ?? fallback.sm,
      md: (map['md'] as num?)?.toDouble() ?? fallback.md,
      lg: (map['lg'] as num?)?.toDouble() ?? fallback.lg,
      xl: (map['xl'] as num?)?.toDouble() ?? fallback.xl,
      xxl: (map['xxl'] as num?)?.toDouble() ?? fallback.xxl,
      xxxl: (map['xxxl'] as num?)?.toDouble() ?? fallback.xxxl,
      full: (map['full'] as num?)?.toDouble() ?? fallback.full,
    );
  }

  /// No radius. Default: `0`.
  final double none;

  /// Small radius. Default: `4`.
  final double sm;

  /// Medium radius. Default: `8`.
  final double md;

  /// Large radius. Default: `12`.
  final double lg;

  /// Extra-large radius. Default: `16`.
  final double xl;

  /// 2X large radius. Default: `24`.
  final double xxl;

  /// 3X large radius. Default: `32`.
  final double xxxl;

  /// Full (pill) radius. Default: `9999`.
  final double full;

  /// Returns a copy with the given fields replaced.
  FiftyRadiiConfig copyWith({
    double? none,
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? xxxl,
    double? full,
  }) {
    return FiftyRadiiConfig(
      none: none ?? this.none,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      xxxl: xxxl ?? this.xxxl,
      full: full ?? this.full,
    );
  }
}
