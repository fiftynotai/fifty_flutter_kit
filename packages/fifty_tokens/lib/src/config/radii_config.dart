/// Configuration for [FiftyRadii] token overrides.
///
/// All fields are optional. `null` means "use FDL default".
/// Pass to [FiftyTokens.configure()] before `runApp()`.
class FiftyRadiiConfig {
  /// Creates a [FiftyRadiiConfig] with optional overrides.
  const FiftyRadiiConfig({
    this.none,
    this.sm,
    this.md,
    this.lg,
    this.xl,
    this.xxl,
    this.xxxl,
    this.full,
  });

  /// Override for [FiftyRadii.none]. Default: `0`.
  final double? none;

  /// Override for [FiftyRadii.sm]. Default: `4`.
  final double? sm;

  /// Override for [FiftyRadii.md]. Default: `8`.
  final double? md;

  /// Override for [FiftyRadii.lg]. Default: `12`.
  final double? lg;

  /// Override for [FiftyRadii.xl]. Default: `16`.
  final double? xl;

  /// Override for [FiftyRadii.xxl]. Default: `24`.
  final double? xxl;

  /// Override for [FiftyRadii.xxxl]. Default: `32`.
  final double? xxxl;

  /// Override for [FiftyRadii.full]. Default: `9999`.
  final double? full;
}
