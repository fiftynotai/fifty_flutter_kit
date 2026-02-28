import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import 'config/typography_config.dart';

/// Fifty.dev typography tokens v2 - Manrope font family.
///
/// Unified font system using Manrope for all text styles.
/// Requires google_fonts package.
///
/// Override defaults via [FiftyTokens.configure()] with a [FiftyTypographyConfig].
class FiftyTypography {
  FiftyTypography._();

  /// Internal config -- set via [FiftyTokens.configure()].
  /// Do not set directly.
  @internal
  static FiftyTypographyConfig? config;

  // ============================================================================
  // FONT FAMILY (v2)
  // ============================================================================

  static const String _defaultFontFamily = 'Manrope';

  /// Manrope - The unified font family for all text.
  ///
  /// Use via GoogleFonts.manrope() for proper loading.
  static String get fontFamily => config?.fontFamily ?? _defaultFontFamily;

  /// How the font family should be loaded.
  ///
  /// Defaults to [FontSource.googleFonts]. Override to [FontSource.asset]
  /// when bundling fonts locally.
  static FontSource get fontSource =>
      config?.fontSource ?? FontSource.googleFonts;

  // ============================================================================
  // FONT WEIGHTS
  // ============================================================================

  static const FontWeight _defaultRegular = FontWeight.w400;
  static const FontWeight _defaultMedium = FontWeight.w500;
  static const FontWeight _defaultSemiBold = FontWeight.w600;
  static const FontWeight _defaultBold = FontWeight.w700;
  static const FontWeight _defaultExtraBold = FontWeight.w800;

  /// Regular (400) - Body text.
  static FontWeight get regular => config?.regular ?? _defaultRegular;

  /// Medium (500) - Body emphasis.
  static FontWeight get medium => config?.medium ?? _defaultMedium;

  /// Semi-bold (600) - Small labels.
  static FontWeight get semiBold => config?.semiBold ?? _defaultSemiBold;

  /// Bold (700) - Titles and labels.
  static FontWeight get bold => config?.bold ?? _defaultBold;

  /// Extra-bold (800) - Display headlines.
  static FontWeight get extraBold => config?.extraBold ?? _defaultExtraBold;

  // ============================================================================
  // TYPE SCALE (v2)
  // ============================================================================

  static const double _defaultDisplayLarge = 32;
  static const double _defaultDisplayMedium = 24;
  static const double _defaultTitleLarge = 20;
  static const double _defaultTitleMedium = 18;
  static const double _defaultTitleSmall = 16;
  static const double _defaultBodyLarge = 16;
  static const double _defaultBodyMedium = 14;
  static const double _defaultBodySmall = 12;
  static const double _defaultLabelLarge = 14;
  static const double _defaultLabelMedium = 12;
  static const double _defaultLabelSmall = 10;

  /// Display Large (32px) - Hero headlines.
  ///
  /// Weight: 800 (extraBold)
  /// Letter spacing: -0.5
  static double get displayLarge =>
      config?.displayLarge ?? _defaultDisplayLarge;

  /// Display Medium (24px) - Section headlines.
  ///
  /// Weight: 800 (extraBold)
  /// Letter spacing: -0.25
  static double get displayMedium =>
      config?.displayMedium ?? _defaultDisplayMedium;

  /// Title Large (20px) - Card titles.
  ///
  /// Weight: 700 (bold)
  static double get titleLarge => config?.titleLarge ?? _defaultTitleLarge;

  /// Title Medium (18px) - App bar titles.
  ///
  /// Weight: 700 (bold)
  static double get titleMedium => config?.titleMedium ?? _defaultTitleMedium;

  /// Title Small (16px) - List item titles.
  ///
  /// Weight: 700 (bold)
  static double get titleSmall => config?.titleSmall ?? _defaultTitleSmall;

  /// Body Large (16px) - Primary body text.
  ///
  /// Weight: 500 (medium)
  /// Letter spacing: 0.5
  static double get bodyLarge => config?.bodyLarge ?? _defaultBodyLarge;

  /// Body Medium (14px) - Secondary body text.
  ///
  /// Weight: 400 (regular)
  /// Letter spacing: 0.25
  static double get bodyMedium => config?.bodyMedium ?? _defaultBodyMedium;

  /// Body Small (12px) - Captions, hints.
  ///
  /// Weight: 400 (regular)
  /// Letter spacing: 0.4
  static double get bodySmall => config?.bodySmall ?? _defaultBodySmall;

  /// Label Large (14px) - Button labels.
  ///
  /// Weight: 700 (bold)
  /// Letter spacing: 0.5
  static double get labelLarge => config?.labelLarge ?? _defaultLabelLarge;

  /// Label Medium (12px) - Input labels (UPPERCASE).
  ///
  /// Weight: 700 (bold)
  /// Letter spacing: 1.5 (wide for uppercase)
  static double get labelMedium => config?.labelMedium ?? _defaultLabelMedium;

  /// Label Small (10px) - Bottom nav, badges.
  ///
  /// Weight: 600 (semiBold)
  /// Letter spacing: 0.5
  static double get labelSmall => config?.labelSmall ?? _defaultLabelSmall;

  // ============================================================================
  // LETTER SPACING
  // ============================================================================

  static const double _defaultLetterSpacingDisplay = -0.5;
  static const double _defaultLetterSpacingDisplayMedium = -0.25;
  static const double _defaultLetterSpacingBody = 0.5;
  static const double _defaultLetterSpacingBodyMedium = 0.25;
  static const double _defaultLetterSpacingBodySmall = 0.4;
  static const double _defaultLetterSpacingLabel = 0.5;
  static const double _defaultLetterSpacingLabelMedium = 1.5;

  /// Display letter spacing (-0.5) - Headlines.
  static double get letterSpacingDisplay =>
      config?.letterSpacingDisplay ?? _defaultLetterSpacingDisplay;

  /// Display medium letter spacing (-0.25).
  static double get letterSpacingDisplayMedium =>
      config?.letterSpacingDisplayMedium ?? _defaultLetterSpacingDisplayMedium;

  /// Body letter spacing (0.5) - Body text.
  static double get letterSpacingBody =>
      config?.letterSpacingBody ?? _defaultLetterSpacingBody;

  /// Body medium letter spacing (0.25).
  static double get letterSpacingBodyMedium =>
      config?.letterSpacingBodyMedium ?? _defaultLetterSpacingBodyMedium;

  /// Body small letter spacing (0.4).
  static double get letterSpacingBodySmall =>
      config?.letterSpacingBodySmall ?? _defaultLetterSpacingBodySmall;

  /// Label letter spacing (0.5) - Labels.
  static double get letterSpacingLabel =>
      config?.letterSpacingLabel ?? _defaultLetterSpacingLabel;

  /// Label medium letter spacing (1.5) - UPPERCASE labels.
  static double get letterSpacingLabelMedium =>
      config?.letterSpacingLabelMedium ?? _defaultLetterSpacingLabelMedium;

  // ============================================================================
  // LINE HEIGHTS
  // ============================================================================

  static const double _defaultLineHeightDisplay = 1.2;
  static const double _defaultLineHeightTitle = 1.3;
  static const double _defaultLineHeightBody = 1.5;
  static const double _defaultLineHeightLabel = 1.2;

  /// Display line height (1.2) - Headlines.
  static double get lineHeightDisplay =>
      config?.lineHeightDisplay ?? _defaultLineHeightDisplay;

  /// Title line height (1.3) - Titles.
  static double get lineHeightTitle =>
      config?.lineHeightTitle ?? _defaultLineHeightTitle;

  /// Body line height (1.5) - Comfortable reading.
  static double get lineHeightBody =>
      config?.lineHeightBody ?? _defaultLineHeightBody;

  /// Label line height (1.2) - Compact labels.
  static double get lineHeightLabel =>
      config?.lineHeightLabel ?? _defaultLineHeightLabel;

  // ============================================================================
  // DEPRECATED (v1 compatibility)
  // ============================================================================

  /// @deprecated Use [fontFamily] instead.
  @Deprecated('Use fontFamily (Manrope) instead')
  static const String fontFamilyHeadline = 'Monument Extended';

  /// @deprecated Use [fontFamily] instead.
  @Deprecated('Use fontFamily (Manrope) instead')
  static const String fontFamilyMono = 'JetBrains Mono';

  /// @deprecated Use [extraBold] instead.
  @Deprecated('Use extraBold instead')
  static const FontWeight ultrabold = FontWeight.w800;

  /// @deprecated Use [displayLarge] instead.
  @Deprecated('Use displayLarge (32) instead')
  static const double hero = 64;

  /// @deprecated Use [displayMedium] instead.
  @Deprecated('Use displayMedium (24) instead')
  static const double display = 48;

  /// @deprecated Use [titleLarge] instead.
  @Deprecated('Use titleLarge (20) instead')
  static const double section = 32;

  /// @deprecated Use [bodyLarge] instead.
  @Deprecated('Use bodyLarge (16) instead')
  static const double body = 16;

  /// @deprecated Use [bodySmall] instead.
  @Deprecated('Use bodySmall (12) instead')
  static const double mono = 12;

  /// @deprecated Use [letterSpacingDisplay] instead.
  @Deprecated('Use letterSpacingDisplay instead')
  static const double tight = -0.02;

  /// @deprecated Use 0 instead.
  @Deprecated('Use 0 for standard spacing')
  static const double standard = 0;

  /// @deprecated Use [lineHeightDisplay] instead.
  @Deprecated('Use lineHeightDisplay instead')
  static const double displayLineHeight = 1.1;

  /// @deprecated Use [lineHeightTitle] instead.
  @Deprecated('Use lineHeightTitle instead')
  static const double headingLineHeight = 1.2;

  /// @deprecated Use [lineHeightBody] instead.
  @Deprecated('Use lineHeightBody instead')
  static const double bodyLineHeight = 1.5;

  /// @deprecated Use [lineHeightBody] instead.
  @Deprecated('Use lineHeightBody instead')
  static const double codeLineHeight = 1.6;
}
