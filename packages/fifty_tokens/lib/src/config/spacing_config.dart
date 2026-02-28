/// Configuration for [FiftySpacing] token overrides.
///
/// All fields are optional. `null` means "use FDL default".
/// Pass to [FiftyTokens.configure()] before `runApp()`.
class FiftySpacingConfig {
  /// Creates a [FiftySpacingConfig] with optional overrides.
  const FiftySpacingConfig({
    this.base,
    this.tight,
    this.standard,
    this.xs,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
    this.xxxl,
    this.huge,
    this.massive,
    this.gutterDesktop,
    this.gutterTablet,
    this.gutterMobile,
  });

  /// Override for [FiftySpacing.base]. Default: `4`.
  final double? base;

  /// Override for [FiftySpacing.tight]. Default: `8`.
  final double? tight;

  /// Override for [FiftySpacing.standard]. Default: `12`.
  final double? standard;

  /// Override for [FiftySpacing.xs]. Default: `4`.
  final double? xs;

  /// Override for [FiftySpacing.sm]. Default: `8`.
  final double? sm;

  /// Override for [FiftySpacing.md]. Default: `12`.
  final double? md;

  /// Override for [FiftySpacing.lg]. Default: `16`.
  final double? lg;

  /// Override for [FiftySpacing.xl]. Default: `20`.
  final double? xl;

  /// Override for [FiftySpacing.xxl]. Default: `24`.
  final double? xxl;

  /// Override for [FiftySpacing.xxxl]. Default: `32`.
  final double? xxxl;

  /// Override for [FiftySpacing.huge]. Default: `40`.
  final double? huge;

  /// Override for [FiftySpacing.massive]. Default: `48`.
  final double? massive;

  /// Override for [FiftySpacing.gutterDesktop]. Default: `24`.
  final double? gutterDesktop;

  /// Override for [FiftySpacing.gutterTablet]. Default: `16`.
  final double? gutterTablet;

  /// Override for [FiftySpacing.gutterMobile]. Default: `12`.
  final double? gutterMobile;
}
