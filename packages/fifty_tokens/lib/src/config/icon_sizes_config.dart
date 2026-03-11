/// Configuration for icon size tokens.
///
/// All fields are required. Use [FiftyPreset.fdlV2.iconSizes] as a starting
/// point and [copyWith] for partial overrides.
class FiftyIconSizesConfig {
  /// Creates a [FiftyIconSizesConfig] with all required fields.
  const FiftyIconSizesConfig({
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
    required this.xxl,
    required this.hero,
  });

  /// Build a [FiftyIconSizesConfig] from a [Map]. Missing keys fall back
  /// to [fallback].
  factory FiftyIconSizesConfig.fromMap(
    Map<String, dynamic> map, {
    required FiftyIconSizesConfig fallback,
  }) {
    return FiftyIconSizesConfig(
      sm: (map['sm'] as num?)?.toDouble() ?? fallback.sm,
      md: (map['md'] as num?)?.toDouble() ?? fallback.md,
      lg: (map['lg'] as num?)?.toDouble() ?? fallback.lg,
      xl: (map['xl'] as num?)?.toDouble() ?? fallback.xl,
      xxl: (map['xxl'] as num?)?.toDouble() ?? fallback.xxl,
      hero: (map['hero'] as num?)?.toDouble() ?? fallback.hero,
    );
  }

  /// Small icon size. Default: `16`. Use for badges, indicators.
  final double sm;

  /// Medium icon size. Default: `20`. Use for buttons, list tiles.
  final double md;

  /// Large icon size. Default: `24`. Use for nav bar, standard icons.
  final double lg;

  /// Extra-large icon size. Default: `36`. Use for branding.
  final double xl;

  /// 2X large icon size. Default: `44`. Use for hero icons.
  final double xxl;

  /// Hero icon size. Default: `48`. Use for hero action buttons.
  final double hero;

  /// Returns a copy with the given fields replaced.
  FiftyIconSizesConfig copyWith({
    double? sm,
    double? md,
    double? lg,
    double? xl,
    double? xxl,
    double? hero,
  }) {
    return FiftyIconSizesConfig(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
      xxl: xxl ?? this.xxl,
      hero: hero ?? this.hero,
    );
  }
}
