import '../breakpoints.dart';
import '../colors.dart';
import '../motion.dart';
import '../radii.dart';
import '../spacing.dart';
import '../typography.dart';
import 'breakpoints_config.dart';
import 'color_config.dart';
import 'motion_config.dart';
import 'radii_config.dart';
import 'spacing_config.dart';
import 'typography_config.dart';

/// Centralized configuration entry point for fifty_tokens.
///
/// Call [configure] before `runApp()` to override FDL default values.
/// All token classes will use configured values or fall back to FDL defaults.
///
/// ```dart
/// void main() {
///   FiftyTokens.configure(
///     colors: FiftyColorConfig(primary: Color(0xFF0000FF)),
///     typography: FiftyTypographyConfig(fontFamily: 'Inter'),
///   );
///   runApp(MyApp());
/// }
/// ```
class FiftyTokens {
  FiftyTokens._();

  /// Applies configuration overrides to token classes.
  ///
  /// Only non-null parameters are applied. Calling [configure] multiple
  /// times replaces the previous config for each provided category.
  static void configure({
    FiftyColorConfig? colors,
    FiftyTypographyConfig? typography,
    FiftySpacingConfig? spacing,
    FiftyRadiiConfig? radii,
    FiftyMotionConfig? motion,
    FiftyBreakpointsConfig? breakpoints,
  }) {
    if (colors != null) FiftyColors.config = colors;
    if (typography != null) FiftyTypography.config = typography;
    if (spacing != null) FiftySpacing.config = spacing;
    if (radii != null) FiftyRadii.config = radii;
    if (motion != null) FiftyMotion.config = motion;
    if (breakpoints != null) FiftyBreakpoints.config = breakpoints;
  }

  /// Resets all token configurations to FDL defaults.
  ///
  /// After calling [reset], all token getters return their original
  /// hardcoded FDL values.
  static void reset() {
    FiftyColors.config = null;
    FiftyTypography.config = null;
    FiftySpacing.config = null;
    FiftyRadii.config = null;
    FiftyMotion.config = null;
    FiftyBreakpoints.config = null;
  }

  /// Whether any configuration has been applied.
  ///
  /// Returns `true` if [configure] has been called with at least one
  /// non-null category and [reset] has not been called since.
  static bool get isConfigured =>
      FiftyColors.config != null ||
      FiftyTypography.config != null ||
      FiftySpacing.config != null ||
      FiftyRadii.config != null ||
      FiftyMotion.config != null ||
      FiftyBreakpoints.config != null;
}
