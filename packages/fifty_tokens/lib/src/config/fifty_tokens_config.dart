import '../preset.dart';
import 'breakpoints_config.dart';
import 'color_config.dart';
import 'gradients_config.dart';
import 'motion_config.dart';
import 'radii_config.dart';
import 'shadows_config.dart';
import 'spacing_config.dart';
import 'typography_config.dart';

/// Central token manager for the fifty_tokens package.
///
/// Manages the active [FiftyPreset]. Token classes read from [active].
///
/// ```dart
/// // Load a complete preset
/// FiftyTokens.load(FiftyPreset.fromMap(jsonDecode(json)));
///
/// // Or configure individual categories
/// FiftyTokens.configure(colors: myColors);
///
/// // Reset to FDL v2 defaults
/// FiftyTokens.reset();
/// ```
class FiftyTokens {
  FiftyTokens._();

  static FiftyPreset _active = FiftyPreset.fdlV2;

  /// The currently active preset.
  static FiftyPreset get active => _active;

  /// Load a complete preset.
  static void load(FiftyPreset preset) {
    _active = preset;
  }

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
    FiftyShadowsConfig? shadows,
    FiftyGradientsConfig? gradients,
  }) {
    _active = FiftyPreset(
      colors: colors ?? _active.colors,
      typography: typography ?? _active.typography,
      spacing: spacing ?? _active.spacing,
      radii: radii ?? _active.radii,
      motion: motion ?? _active.motion,
      shadows: shadows ?? _active.shadows,
      gradients: gradients ?? _active.gradients,
      breakpoints: breakpoints ?? _active.breakpoints,
    );
  }

  /// Resets all token configurations to FDL defaults.
  ///
  /// After calling [reset], all token getters return their original
  /// hardcoded FDL values.
  static void reset() {
    _active = FiftyPreset.fdlV2;
  }

  /// Whether any configuration has been applied.
  ///
  /// Returns `true` if [configure] or [load] has been called with custom
  /// values and [reset] has not been called since.
  static bool get isConfigured => !identical(_active, FiftyPreset.fdlV2);
}
