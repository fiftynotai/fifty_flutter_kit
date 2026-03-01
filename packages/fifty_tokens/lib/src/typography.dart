import 'package:flutter/material.dart';

import 'config/fifty_tokens_config.dart';
import 'config/typography_config.dart';

/// Fifty.dev typography tokens -- reads from the active [FiftyPreset].
///
/// Unified font system using Manrope for all text styles.
/// Requires google_fonts package.
class FiftyTypography {
  FiftyTypography._();

  // ============================================================================
  // FONT FAMILY (v2)
  // ============================================================================

  /// Manrope - The unified font family for all text.
  ///
  /// Use via GoogleFonts.manrope() for proper loading.
  static String get fontFamily => FiftyTokens.active.typography.fontFamily;

  /// How the font family should be loaded.
  ///
  /// Defaults to [FontSource.googleFonts]. Override to [FontSource.asset]
  /// when bundling fonts locally.
  static FontSource get fontSource => FiftyTokens.active.typography.fontSource;

  // ============================================================================
  // FONT WEIGHTS
  // ============================================================================

  /// Regular (400) - Body text.
  static FontWeight get regular => FiftyTokens.active.typography.regular;

  /// Medium (500) - Body emphasis.
  static FontWeight get medium => FiftyTokens.active.typography.medium;

  /// Semi-bold (600) - Small labels.
  static FontWeight get semiBold => FiftyTokens.active.typography.semiBold;

  /// Bold (700) - Titles and labels.
  static FontWeight get bold => FiftyTokens.active.typography.bold;

  /// Extra-bold (800) - Display headlines.
  static FontWeight get extraBold => FiftyTokens.active.typography.extraBold;

  // ============================================================================
  // TYPE SCALE (v2)
  // ============================================================================

  /// Display Large (32px) - Hero headlines.
  ///
  /// Weight: 800 (extraBold)
  /// Letter spacing: -0.5
  static double get displayLarge =>
      FiftyTokens.active.typography.displayLarge;

  /// Display Medium (24px) - Section headlines.
  ///
  /// Weight: 800 (extraBold)
  /// Letter spacing: -0.25
  static double get displayMedium =>
      FiftyTokens.active.typography.displayMedium;

  /// Title Large (20px) - Card titles.
  ///
  /// Weight: 700 (bold)
  static double get titleLarge => FiftyTokens.active.typography.titleLarge;

  /// Title Medium (18px) - App bar titles.
  ///
  /// Weight: 700 (bold)
  static double get titleMedium => FiftyTokens.active.typography.titleMedium;

  /// Title Small (16px) - List item titles.
  ///
  /// Weight: 700 (bold)
  static double get titleSmall => FiftyTokens.active.typography.titleSmall;

  /// Body Large (16px) - Primary body text.
  ///
  /// Weight: 500 (medium)
  /// Letter spacing: 0.5
  static double get bodyLarge => FiftyTokens.active.typography.bodyLarge;

  /// Body Medium (14px) - Secondary body text.
  ///
  /// Weight: 400 (regular)
  /// Letter spacing: 0.25
  static double get bodyMedium => FiftyTokens.active.typography.bodyMedium;

  /// Body Small (12px) - Captions, hints.
  ///
  /// Weight: 400 (regular)
  /// Letter spacing: 0.4
  static double get bodySmall => FiftyTokens.active.typography.bodySmall;

  /// Label Large (14px) - Button labels.
  ///
  /// Weight: 700 (bold)
  /// Letter spacing: 0.5
  static double get labelLarge => FiftyTokens.active.typography.labelLarge;

  /// Label Medium (12px) - Input labels (UPPERCASE).
  ///
  /// Weight: 700 (bold)
  /// Letter spacing: 1.5 (wide for uppercase)
  static double get labelMedium => FiftyTokens.active.typography.labelMedium;

  /// Label Small (10px) - Bottom nav, badges.
  ///
  /// Weight: 600 (semiBold)
  /// Letter spacing: 0.5
  static double get labelSmall => FiftyTokens.active.typography.labelSmall;

  // ============================================================================
  // LETTER SPACING
  // ============================================================================

  /// Display letter spacing (-0.5) - Headlines.
  static double get letterSpacingDisplay =>
      FiftyTokens.active.typography.letterSpacingDisplay;

  /// Display medium letter spacing (-0.25).
  static double get letterSpacingDisplayMedium =>
      FiftyTokens.active.typography.letterSpacingDisplayMedium;

  /// Body letter spacing (0.5) - Body text.
  static double get letterSpacingBody =>
      FiftyTokens.active.typography.letterSpacingBody;

  /// Body medium letter spacing (0.25).
  static double get letterSpacingBodyMedium =>
      FiftyTokens.active.typography.letterSpacingBodyMedium;

  /// Body small letter spacing (0.4).
  static double get letterSpacingBodySmall =>
      FiftyTokens.active.typography.letterSpacingBodySmall;

  /// Label letter spacing (0.5) - Labels.
  static double get letterSpacingLabel =>
      FiftyTokens.active.typography.letterSpacingLabel;

  /// Label medium letter spacing (1.5) - UPPERCASE labels.
  static double get letterSpacingLabelMedium =>
      FiftyTokens.active.typography.letterSpacingLabelMedium;

  // ============================================================================
  // LINE HEIGHTS
  // ============================================================================

  /// Display line height (1.2) - Headlines.
  static double get lineHeightDisplay =>
      FiftyTokens.active.typography.lineHeightDisplay;

  /// Title line height (1.3) - Titles.
  static double get lineHeightTitle =>
      FiftyTokens.active.typography.lineHeightTitle;

  /// Body line height (1.5) - Comfortable reading.
  static double get lineHeightBody =>
      FiftyTokens.active.typography.lineHeightBody;

  /// Label line height (1.2) - Compact labels.
  static double get lineHeightLabel =>
      FiftyTokens.active.typography.lineHeightLabel;

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
