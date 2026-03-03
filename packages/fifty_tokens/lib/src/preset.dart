import 'package:flutter/material.dart';

import 'config/breakpoints_config.dart';
import 'config/color_config.dart';
import 'config/gradients_config.dart';
import 'config/motion_config.dart';
import 'config/radii_config.dart';
import 'config/shadows_config.dart';
import 'config/spacing_config.dart';
import 'config/typography_config.dart';

// ---------------------------------------------------------------------------
// Shared non-color defaults used by every built-in preset.
// Declared at file level so multiple `static const` presets can reference them.
// ---------------------------------------------------------------------------

const _sharedTypography = FiftyTypographyConfig(
  fontFamily: 'Manrope',
  fontSource: FontSource.googleFonts,
  regular: FontWeight.w400,
  medium: FontWeight.w500,
  semiBold: FontWeight.w600,
  bold: FontWeight.w700,
  extraBold: FontWeight.w800,
  displayLarge: 32,
  displayMedium: 24,
  titleLarge: 20,
  titleMedium: 18,
  titleSmall: 16,
  bodyLarge: 16,
  bodyMedium: 14,
  bodySmall: 12,
  labelLarge: 14,
  labelMedium: 12,
  labelSmall: 10,
  letterSpacingDisplay: -0.5,
  letterSpacingDisplayMedium: -0.25,
  letterSpacingBody: 0.5,
  letterSpacingBodyMedium: 0.25,
  letterSpacingBodySmall: 0.4,
  letterSpacingLabel: 0.5,
  letterSpacingLabelMedium: 1.5,
  lineHeightDisplay: 1.2,
  lineHeightTitle: 1.3,
  lineHeightBody: 1.5,
  lineHeightLabel: 1.2,
);

const _sharedSpacing = FiftySpacingConfig(
  base: 4,
  tight: 8,
  standard: 12,
  xs: 4,
  sm: 8,
  md: 12,
  lg: 16,
  xl: 20,
  xxl: 24,
  xxxl: 32,
  huge: 40,
  massive: 48,
  gutterDesktop: 24,
  gutterTablet: 16,
  gutterMobile: 12,
);

const _sharedRadii = FiftyRadiiConfig(
  none: 0,
  sm: 4,
  md: 8,
  lg: 12,
  xl: 16,
  xxl: 24,
  xxxl: 32,
  full: 9999,
);

const _sharedMotion = FiftyMotionConfig(
  instant: Duration.zero,
  fast: Duration(milliseconds: 150),
  compiling: Duration(milliseconds: 300),
  systemLoad: Duration(milliseconds: 800),
  standard: Cubic(0.2, 0, 0, 1),
  enter: Cubic(0.2, 0.8, 0.2, 1),
  exit: Cubic(0.4, 0, 1, 1),
);

const _sharedShadows = FiftyShadowsConfig(
  sm: [
    BoxShadow(
      offset: Offset(0, 1),
      blurRadius: 2,
      color: Color(0x0D000000),
    ),
  ],
  md: [
    BoxShadow(
      offset: Offset(0, 4),
      blurRadius: 6,
      color: Color(0x12000000),
    ),
  ],
  lg: [
    BoxShadow(
      offset: Offset(0, 10),
      blurRadius: 15,
      color: Color(0x1A000000),
    ),
  ],
  primaryOpacity: 0.2,
  glowOpacity: 0.1,
);

const _sharedGradients = FiftyGradientsConfig(
  primaryEnd: Color(0xFF5A1B1F),
);

const _sharedBreakpoints = FiftyBreakpointsConfig(
  mobile: 768,
  tablet: 768,
  desktop: 1024,
);

/// A complete set of design token values.
///
/// The single data type for all theming. Whether built-in (FDL v2),
/// parsed from JSON, or constructed in code -- same type.
///
/// ```dart
/// // Load from JSON
/// FiftyTokens.load(FiftyPreset.fromMap(jsonDecode(json)));
///
/// // Or use the built-in default
/// FiftyTokens.load(FiftyPreset.fdlV2);
/// ```
class FiftyPreset {
  /// Creates a [FiftyPreset] with all required token categories.
  const FiftyPreset({
    required this.colors,
    required this.typography,
    required this.spacing,
    required this.radii,
    required this.motion,
    required this.shadows,
    required this.gradients,
    required this.breakpoints,
  });

  /// Build a preset from a [Map]. Missing keys fall back to [fallback].
  factory FiftyPreset.fromMap(
    Map<String, dynamic> map, {
    FiftyPreset fallback = fdlV2,
  }) {
    return FiftyPreset(
      colors: map.containsKey('colors')
          ? FiftyColorConfig.fromMap(
              map['colors'] as Map<String, dynamic>,
              fallback: fallback.colors,
            )
          : fallback.colors,
      typography: map.containsKey('typography')
          ? FiftyTypographyConfig.fromMap(
              map['typography'] as Map<String, dynamic>,
              fallback: fallback.typography,
            )
          : fallback.typography,
      spacing: map.containsKey('spacing')
          ? FiftySpacingConfig.fromMap(
              map['spacing'] as Map<String, dynamic>,
              fallback: fallback.spacing,
            )
          : fallback.spacing,
      radii: map.containsKey('radii')
          ? FiftyRadiiConfig.fromMap(
              map['radii'] as Map<String, dynamic>,
              fallback: fallback.radii,
            )
          : fallback.radii,
      motion: map.containsKey('motion')
          ? FiftyMotionConfig.fromMap(
              map['motion'] as Map<String, dynamic>,
              fallback: fallback.motion,
            )
          : fallback.motion,
      shadows: map.containsKey('shadows')
          ? FiftyShadowsConfig.fromMap(
              map['shadows'] as Map<String, dynamic>,
              fallback: fallback.shadows,
            )
          : fallback.shadows,
      gradients: map.containsKey('gradients')
          ? FiftyGradientsConfig.fromMap(
              map['gradients'] as Map<String, dynamic>,
              fallback: fallback.gradients,
            )
          : fallback.gradients,
      breakpoints: map.containsKey('breakpoints')
          ? FiftyBreakpointsConfig.fromMap(
              map['breakpoints'] as Map<String, dynamic>,
              fallback: fallback.breakpoints,
            )
          : fallback.breakpoints,
    );
  }

  /// Color token configuration.
  final FiftyColorConfig colors;

  /// Typography token configuration.
  final FiftyTypographyConfig typography;

  /// Spacing token configuration.
  final FiftySpacingConfig spacing;

  /// Border radius token configuration.
  final FiftyRadiiConfig radii;

  /// Motion / animation token configuration.
  final FiftyMotionConfig motion;

  /// Shadow token configuration.
  final FiftyShadowsConfig shadows;

  /// Gradient token configuration.
  final FiftyGradientsConfig gradients;

  /// Responsive breakpoint configuration.
  final FiftyBreakpointsConfig breakpoints;

  /// FDL v2 -- Sophisticated Warm. The built-in default preset.
  static const fdlV2 = FiftyPreset(
    colors: FiftyColorConfig(
      primary: Color(0xFF88292F),
      primaryHover: Color(0xFF6E2126),
      background: Color(0xFFFEFEE3),
      backgroundDark: Color(0xFF1A0D0E),
      secondary: Color(0xFF335C67),
      secondaryHover: Color(0xFF274750),
      success: Color(0xFF4B644A),
      accent: Color(0xFFFFC9B9),
      surface: Color(0xFFFAF9DE),
      surfaceDark: Color(0xFF2A1517),
      warning: Color(0xFFF7A100),
      error: Color(0xFF88292F),
      onPrimary: Color(0xFFFEFEE3),
      onBackground: Color(0xFF1A0D0E),
      borderOpacity: 0.05,
      focusOpacity: 0.5,
    ),
    typography: _sharedTypography,
    spacing: _sharedSpacing,
    radii: _sharedRadii,
    motion: _sharedMotion,
    shadows: _sharedShadows,
    gradients: _sharedGradients,
    breakpoints: _sharedBreakpoints,
  );

  /// Baltic Blue -- Cool Coastal. A steel-blue palette with muted earth tones.
  ///
  /// Only colors differ from [fdlV2]; typography, spacing, radii, motion,
  /// shadows, gradients, and breakpoints are identical.
  static const balticBlue = FiftyPreset(
    colors: FiftyColorConfig(
      primary: Color(0xFF586994),
      primaryHover: Color(0xFF47567A),
      secondary: Color(0xFF7d869c),
      secondaryHover: Color(0xFF656D80),
      success: Color(0xFFb4c4ae),
      accent: Color(0xFFa2abab),
      background: Color(0xFFe5e8b6),
      backgroundDark: Color(0xFF1A1D2B),
      surface: Color(0xFFD5D8A8),
      surfaceDark: Color(0xFF2A2D3B),
      warning: Color(0xFFF7A100),
      error: Color(0xFF88292F),
      onPrimary: Color(0xFFe5e8b6),
      onBackground: Color(0xFF1A1D2B),
      borderOpacity: 0.05,
      focusOpacity: 0.5,
    ),
    typography: _sharedTypography,
    spacing: _sharedSpacing,
    radii: _sharedRadii,
    motion: _sharedMotion,
    shadows: _sharedShadows,
    gradients: _sharedGradients,
    breakpoints: _sharedBreakpoints,
  );

  /// Returns a copy with the given categories replaced.
  FiftyPreset copyWith({
    FiftyColorConfig? colors,
    FiftyTypographyConfig? typography,
    FiftySpacingConfig? spacing,
    FiftyRadiiConfig? radii,
    FiftyMotionConfig? motion,
    FiftyShadowsConfig? shadows,
    FiftyGradientsConfig? gradients,
    FiftyBreakpointsConfig? breakpoints,
  }) {
    return FiftyPreset(
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      spacing: spacing ?? this.spacing,
      radii: radii ?? this.radii,
      motion: motion ?? this.motion,
      shadows: shadows ?? this.shadows,
      gradients: gradients ?? this.gradients,
      breakpoints: breakpoints ?? this.breakpoints,
    );
  }
}
