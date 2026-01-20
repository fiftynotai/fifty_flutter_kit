import 'package:flutter/material.dart';

/// Fifty.dev typography tokens v2 - Manrope font family.
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
  static const String fontFamily = 'Manrope';

  // ============================================================================
  // FONT WEIGHTS
  // ============================================================================

  /// Regular (400) - Body text.
  static const FontWeight regular = FontWeight.w400;

  /// Medium (500) - Body emphasis.
  static const FontWeight medium = FontWeight.w500;

  /// Semi-bold (600) - Small labels.
  static const FontWeight semiBold = FontWeight.w600;

  /// Bold (700) - Titles and labels.
  static const FontWeight bold = FontWeight.w700;

  /// Extra-bold (800) - Display headlines.
  static const FontWeight extraBold = FontWeight.w800;

  // ============================================================================
  // TYPE SCALE (v2)
  // ============================================================================

  /// Display Large (32px) - Hero headlines.
  ///
  /// Weight: 800 (extraBold)
  /// Letter spacing: -0.5
  static const double displayLarge = 32;

  /// Display Medium (24px) - Section headlines.
  ///
  /// Weight: 800 (extraBold)
  /// Letter spacing: -0.25
  static const double displayMedium = 24;

  /// Title Large (20px) - Card titles.
  ///
  /// Weight: 700 (bold)
  static const double titleLarge = 20;

  /// Title Medium (18px) - App bar titles.
  ///
  /// Weight: 700 (bold)
  static const double titleMedium = 18;

  /// Title Small (16px) - List item titles.
  ///
  /// Weight: 700 (bold)
  static const double titleSmall = 16;

  /// Body Large (16px) - Primary body text.
  ///
  /// Weight: 500 (medium)
  /// Letter spacing: 0.5
  static const double bodyLarge = 16;

  /// Body Medium (14px) - Secondary body text.
  ///
  /// Weight: 400 (regular)
  /// Letter spacing: 0.25
  static const double bodyMedium = 14;

  /// Body Small (12px) - Captions, hints.
  ///
  /// Weight: 400 (regular)
  /// Letter spacing: 0.4
  static const double bodySmall = 12;

  /// Label Large (14px) - Button labels.
  ///
  /// Weight: 700 (bold)
  /// Letter spacing: 0.5
  static const double labelLarge = 14;

  /// Label Medium (12px) - Input labels (UPPERCASE).
  ///
  /// Weight: 700 (bold)
  /// Letter spacing: 1.5 (wide for uppercase)
  static const double labelMedium = 12;

  /// Label Small (10px) - Bottom nav, badges.
  ///
  /// Weight: 600 (semiBold)
  /// Letter spacing: 0.5
  static const double labelSmall = 10;

  // ============================================================================
  // LETTER SPACING
  // ============================================================================

  /// Display letter spacing (-0.5) - Headlines.
  static const double letterSpacingDisplay = -0.5;

  /// Display medium letter spacing (-0.25).
  static const double letterSpacingDisplayMedium = -0.25;

  /// Body letter spacing (0.5) - Body text.
  static const double letterSpacingBody = 0.5;

  /// Body medium letter spacing (0.25).
  static const double letterSpacingBodyMedium = 0.25;

  /// Body small letter spacing (0.4).
  static const double letterSpacingBodySmall = 0.4;

  /// Label letter spacing (0.5) - Labels.
  static const double letterSpacingLabel = 0.5;

  /// Label medium letter spacing (1.5) - UPPERCASE labels.
  static const double letterSpacingLabelMedium = 1.5;

  // ============================================================================
  // LINE HEIGHTS
  // ============================================================================

  /// Display line height (1.2) - Headlines.
  static const double lineHeightDisplay = 1.2;

  /// Title line height (1.3) - Titles.
  static const double lineHeightTitle = 1.3;

  /// Body line height (1.5) - Comfortable reading.
  static const double lineHeightBody = 1.5;

  /// Label line height (1.2) - Compact labels.
  static const double lineHeightLabel = 1.2;

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
