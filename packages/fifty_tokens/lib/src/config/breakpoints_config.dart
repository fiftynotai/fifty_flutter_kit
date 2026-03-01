/// Configuration for breakpoint tokens.
///
/// All fields are required. Use [FiftyPreset.fdlV2.breakpoints] as a starting
/// point and [copyWith] for partial overrides.
class FiftyBreakpointsConfig {
  /// Creates a [FiftyBreakpointsConfig] with all required fields.
  const FiftyBreakpointsConfig({
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  /// Build a [FiftyBreakpointsConfig] from a [Map]. Missing keys fall back
  /// to [fallback].
  factory FiftyBreakpointsConfig.fromMap(
    Map<String, dynamic> map, {
    required FiftyBreakpointsConfig fallback,
  }) {
    return FiftyBreakpointsConfig(
      mobile: (map['mobile'] as num?)?.toDouble() ?? fallback.mobile,
      tablet: (map['tablet'] as num?)?.toDouble() ?? fallback.tablet,
      desktop: (map['desktop'] as num?)?.toDouble() ?? fallback.desktop,
    );
  }

  /// Mobile breakpoint width. Default: `768`.
  final double mobile;

  /// Tablet breakpoint width. Default: `768`.
  final double tablet;

  /// Desktop breakpoint width. Default: `1024`.
  final double desktop;

  /// Returns a copy with the given fields replaced.
  FiftyBreakpointsConfig copyWith({
    double? mobile,
    double? tablet,
    double? desktop,
  }) {
    return FiftyBreakpointsConfig(
      mobile: mobile ?? this.mobile,
      tablet: tablet ?? this.tablet,
      desktop: desktop ?? this.desktop,
    );
  }
}
