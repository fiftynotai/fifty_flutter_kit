/// Configuration for [FiftyBreakpoints] token overrides.
///
/// All fields are optional. `null` means "use FDL default".
/// Pass to [FiftyTokens.configure()] before `runApp()`.
class FiftyBreakpointsConfig {
  /// Creates a [FiftyBreakpointsConfig] with optional overrides.
  const FiftyBreakpointsConfig({
    this.mobile,
    this.tablet,
    this.desktop,
  });

  /// Override for [FiftyBreakpoints.mobile]. Default: `768`.
  final double? mobile;

  /// Override for [FiftyBreakpoints.tablet]. Default: `768`.
  final double? tablet;

  /// Override for [FiftyBreakpoints.desktop]. Default: `1024`.
  final double? desktop;
}
