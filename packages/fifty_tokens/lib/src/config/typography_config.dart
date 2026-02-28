import 'package:flutter/material.dart';

/// Determines how a font family is loaded.
enum FontSource {
  /// Use the google_fonts package to fetch/cache fonts at runtime.
  googleFonts,

  /// Use local font assets bundled with the app.
  asset,
}

/// Configuration for [FiftyTypography] token overrides.
///
/// All fields are optional. `null` means "use FDL default".
/// Pass to [FiftyTokens.configure()] before `runApp()`.
class FiftyTypographyConfig {
  /// Creates a [FiftyTypographyConfig] with optional overrides.
  const FiftyTypographyConfig({
    this.fontFamily,
    this.fontSource = FontSource.googleFonts,
    this.regular,
    this.medium,
    this.semiBold,
    this.bold,
    this.extraBold,
    this.displayLarge,
    this.displayMedium,
    this.titleLarge,
    this.titleMedium,
    this.titleSmall,
    this.bodyLarge,
    this.bodyMedium,
    this.bodySmall,
    this.labelLarge,
    this.labelMedium,
    this.labelSmall,
    this.letterSpacingDisplay,
    this.letterSpacingDisplayMedium,
    this.letterSpacingBody,
    this.letterSpacingBodyMedium,
    this.letterSpacingBodySmall,
    this.letterSpacingLabel,
    this.letterSpacingLabelMedium,
    this.lineHeightDisplay,
    this.lineHeightTitle,
    this.lineHeightBody,
    this.lineHeightLabel,
  });

  /// Override for [FiftyTypography.fontFamily]. Default: `'Manrope'`.
  final String? fontFamily;

  /// How the font family should be loaded. Default: [FontSource.googleFonts].
  final FontSource fontSource;

  /// Override for [FiftyTypography.regular]. Default: `FontWeight.w400`.
  final FontWeight? regular;

  /// Override for [FiftyTypography.medium]. Default: `FontWeight.w500`.
  final FontWeight? medium;

  /// Override for [FiftyTypography.semiBold]. Default: `FontWeight.w600`.
  final FontWeight? semiBold;

  /// Override for [FiftyTypography.bold]. Default: `FontWeight.w700`.
  final FontWeight? bold;

  /// Override for [FiftyTypography.extraBold]. Default: `FontWeight.w800`.
  final FontWeight? extraBold;

  /// Override for [FiftyTypography.displayLarge]. Default: `32`.
  final double? displayLarge;

  /// Override for [FiftyTypography.displayMedium]. Default: `24`.
  final double? displayMedium;

  /// Override for [FiftyTypography.titleLarge]. Default: `20`.
  final double? titleLarge;

  /// Override for [FiftyTypography.titleMedium]. Default: `18`.
  final double? titleMedium;

  /// Override for [FiftyTypography.titleSmall]. Default: `16`.
  final double? titleSmall;

  /// Override for [FiftyTypography.bodyLarge]. Default: `16`.
  final double? bodyLarge;

  /// Override for [FiftyTypography.bodyMedium]. Default: `14`.
  final double? bodyMedium;

  /// Override for [FiftyTypography.bodySmall]. Default: `12`.
  final double? bodySmall;

  /// Override for [FiftyTypography.labelLarge]. Default: `14`.
  final double? labelLarge;

  /// Override for [FiftyTypography.labelMedium]. Default: `12`.
  final double? labelMedium;

  /// Override for [FiftyTypography.labelSmall]. Default: `10`.
  final double? labelSmall;

  /// Override for [FiftyTypography.letterSpacingDisplay]. Default: `-0.5`.
  final double? letterSpacingDisplay;

  /// Override for [FiftyTypography.letterSpacingDisplayMedium]. Default: `-0.25`.
  final double? letterSpacingDisplayMedium;

  /// Override for [FiftyTypography.letterSpacingBody]. Default: `0.5`.
  final double? letterSpacingBody;

  /// Override for [FiftyTypography.letterSpacingBodyMedium]. Default: `0.25`.
  final double? letterSpacingBodyMedium;

  /// Override for [FiftyTypography.letterSpacingBodySmall]. Default: `0.4`.
  final double? letterSpacingBodySmall;

  /// Override for [FiftyTypography.letterSpacingLabel]. Default: `0.5`.
  final double? letterSpacingLabel;

  /// Override for [FiftyTypography.letterSpacingLabelMedium]. Default: `1.5`.
  final double? letterSpacingLabelMedium;

  /// Override for [FiftyTypography.lineHeightDisplay]. Default: `1.2`.
  final double? lineHeightDisplay;

  /// Override for [FiftyTypography.lineHeightTitle]. Default: `1.3`.
  final double? lineHeightTitle;

  /// Override for [FiftyTypography.lineHeightBody]. Default: `1.5`.
  final double? lineHeightBody;

  /// Override for [FiftyTypography.lineHeightLabel]. Default: `1.2`.
  final double? lineHeightLabel;
}
