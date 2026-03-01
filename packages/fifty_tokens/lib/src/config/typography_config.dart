import 'package:flutter/material.dart';

/// Determines how a font family is loaded.
enum FontSource {
  /// Use the google_fonts package to fetch/cache fonts at runtime.
  googleFonts,

  /// Use local font assets bundled with the app.
  asset,
}

/// Configuration for typography tokens.
///
/// All fields are required. Use [FiftyPreset.fdlV2.typography] as a starting
/// point and [copyWith] for partial overrides.
class FiftyTypographyConfig {
  /// Creates a [FiftyTypographyConfig] with all required fields.
  const FiftyTypographyConfig({
    required this.fontFamily,
    required this.fontSource,
    required this.regular,
    required this.medium,
    required this.semiBold,
    required this.bold,
    required this.extraBold,
    required this.displayLarge,
    required this.displayMedium,
    required this.titleLarge,
    required this.titleMedium,
    required this.titleSmall,
    required this.bodyLarge,
    required this.bodyMedium,
    required this.bodySmall,
    required this.labelLarge,
    required this.labelMedium,
    required this.labelSmall,
    required this.letterSpacingDisplay,
    required this.letterSpacingDisplayMedium,
    required this.letterSpacingBody,
    required this.letterSpacingBodyMedium,
    required this.letterSpacingBodySmall,
    required this.letterSpacingLabel,
    required this.letterSpacingLabelMedium,
    required this.lineHeightDisplay,
    required this.lineHeightTitle,
    required this.lineHeightBody,
    required this.lineHeightLabel,
  });

  /// Build a [FiftyTypographyConfig] from a [Map]. Missing keys fall back
  /// to [fallback].
  factory FiftyTypographyConfig.fromMap(
    Map<String, dynamic> map, {
    required FiftyTypographyConfig fallback,
  }) {
    return FiftyTypographyConfig(
      fontFamily: map['fontFamily'] as String? ?? fallback.fontFamily,
      fontSource: _parseFontSource(map['fontSource'], fallback.fontSource),
      regular: _parseFontWeight(map['regular']) ?? fallback.regular,
      medium: _parseFontWeight(map['medium']) ?? fallback.medium,
      semiBold: _parseFontWeight(map['semiBold']) ?? fallback.semiBold,
      bold: _parseFontWeight(map['bold']) ?? fallback.bold,
      extraBold: _parseFontWeight(map['extraBold']) ?? fallback.extraBold,
      displayLarge:
          (map['displayLarge'] as num?)?.toDouble() ?? fallback.displayLarge,
      displayMedium:
          (map['displayMedium'] as num?)?.toDouble() ?? fallback.displayMedium,
      titleLarge:
          (map['titleLarge'] as num?)?.toDouble() ?? fallback.titleLarge,
      titleMedium:
          (map['titleMedium'] as num?)?.toDouble() ?? fallback.titleMedium,
      titleSmall:
          (map['titleSmall'] as num?)?.toDouble() ?? fallback.titleSmall,
      bodyLarge: (map['bodyLarge'] as num?)?.toDouble() ?? fallback.bodyLarge,
      bodyMedium:
          (map['bodyMedium'] as num?)?.toDouble() ?? fallback.bodyMedium,
      bodySmall: (map['bodySmall'] as num?)?.toDouble() ?? fallback.bodySmall,
      labelLarge:
          (map['labelLarge'] as num?)?.toDouble() ?? fallback.labelLarge,
      labelMedium:
          (map['labelMedium'] as num?)?.toDouble() ?? fallback.labelMedium,
      labelSmall:
          (map['labelSmall'] as num?)?.toDouble() ?? fallback.labelSmall,
      letterSpacingDisplay:
          (map['letterSpacingDisplay'] as num?)?.toDouble() ??
          fallback.letterSpacingDisplay,
      letterSpacingDisplayMedium:
          (map['letterSpacingDisplayMedium'] as num?)?.toDouble() ??
          fallback.letterSpacingDisplayMedium,
      letterSpacingBody:
          (map['letterSpacingBody'] as num?)?.toDouble() ??
          fallback.letterSpacingBody,
      letterSpacingBodyMedium:
          (map['letterSpacingBodyMedium'] as num?)?.toDouble() ??
          fallback.letterSpacingBodyMedium,
      letterSpacingBodySmall:
          (map['letterSpacingBodySmall'] as num?)?.toDouble() ??
          fallback.letterSpacingBodySmall,
      letterSpacingLabel:
          (map['letterSpacingLabel'] as num?)?.toDouble() ??
          fallback.letterSpacingLabel,
      letterSpacingLabelMedium:
          (map['letterSpacingLabelMedium'] as num?)?.toDouble() ??
          fallback.letterSpacingLabelMedium,
      lineHeightDisplay:
          (map['lineHeightDisplay'] as num?)?.toDouble() ??
          fallback.lineHeightDisplay,
      lineHeightTitle:
          (map['lineHeightTitle'] as num?)?.toDouble() ??
          fallback.lineHeightTitle,
      lineHeightBody:
          (map['lineHeightBody'] as num?)?.toDouble() ??
          fallback.lineHeightBody,
      lineHeightLabel:
          (map['lineHeightLabel'] as num?)?.toDouble() ??
          fallback.lineHeightLabel,
    );
  }

  /// Font family name. Default: `'Manrope'`.
  final String fontFamily;

  /// How the font family should be loaded. Default: [FontSource.googleFonts].
  final FontSource fontSource;

  /// Regular weight. Default: `FontWeight.w400`.
  final FontWeight regular;

  /// Medium weight. Default: `FontWeight.w500`.
  final FontWeight medium;

  /// Semi-bold weight. Default: `FontWeight.w600`.
  final FontWeight semiBold;

  /// Bold weight. Default: `FontWeight.w700`.
  final FontWeight bold;

  /// Extra-bold weight. Default: `FontWeight.w800`.
  final FontWeight extraBold;

  /// Display large size. Default: `32`.
  final double displayLarge;

  /// Display medium size. Default: `24`.
  final double displayMedium;

  /// Title large size. Default: `20`.
  final double titleLarge;

  /// Title medium size. Default: `18`.
  final double titleMedium;

  /// Title small size. Default: `16`.
  final double titleSmall;

  /// Body large size. Default: `16`.
  final double bodyLarge;

  /// Body medium size. Default: `14`.
  final double bodyMedium;

  /// Body small size. Default: `12`.
  final double bodySmall;

  /// Label large size. Default: `14`.
  final double labelLarge;

  /// Label medium size. Default: `12`.
  final double labelMedium;

  /// Label small size. Default: `10`.
  final double labelSmall;

  /// Display letter spacing. Default: `-0.5`.
  final double letterSpacingDisplay;

  /// Display medium letter spacing. Default: `-0.25`.
  final double letterSpacingDisplayMedium;

  /// Body letter spacing. Default: `0.5`.
  final double letterSpacingBody;

  /// Body medium letter spacing. Default: `0.25`.
  final double letterSpacingBodyMedium;

  /// Body small letter spacing. Default: `0.4`.
  final double letterSpacingBodySmall;

  /// Label letter spacing. Default: `0.5`.
  final double letterSpacingLabel;

  /// Label medium letter spacing. Default: `1.5`.
  final double letterSpacingLabelMedium;

  /// Display line height. Default: `1.2`.
  final double lineHeightDisplay;

  /// Title line height. Default: `1.3`.
  final double lineHeightTitle;

  /// Body line height. Default: `1.5`.
  final double lineHeightBody;

  /// Label line height. Default: `1.2`.
  final double lineHeightLabel;

  /// Returns a copy with the given fields replaced.
  FiftyTypographyConfig copyWith({
    String? fontFamily,
    FontSource? fontSource,
    FontWeight? regular,
    FontWeight? medium,
    FontWeight? semiBold,
    FontWeight? bold,
    FontWeight? extraBold,
    double? displayLarge,
    double? displayMedium,
    double? titleLarge,
    double? titleMedium,
    double? titleSmall,
    double? bodyLarge,
    double? bodyMedium,
    double? bodySmall,
    double? labelLarge,
    double? labelMedium,
    double? labelSmall,
    double? letterSpacingDisplay,
    double? letterSpacingDisplayMedium,
    double? letterSpacingBody,
    double? letterSpacingBodyMedium,
    double? letterSpacingBodySmall,
    double? letterSpacingLabel,
    double? letterSpacingLabelMedium,
    double? lineHeightDisplay,
    double? lineHeightTitle,
    double? lineHeightBody,
    double? lineHeightLabel,
  }) {
    return FiftyTypographyConfig(
      fontFamily: fontFamily ?? this.fontFamily,
      fontSource: fontSource ?? this.fontSource,
      regular: regular ?? this.regular,
      medium: medium ?? this.medium,
      semiBold: semiBold ?? this.semiBold,
      bold: bold ?? this.bold,
      extraBold: extraBold ?? this.extraBold,
      displayLarge: displayLarge ?? this.displayLarge,
      displayMedium: displayMedium ?? this.displayMedium,
      titleLarge: titleLarge ?? this.titleLarge,
      titleMedium: titleMedium ?? this.titleMedium,
      titleSmall: titleSmall ?? this.titleSmall,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodyMedium: bodyMedium ?? this.bodyMedium,
      bodySmall: bodySmall ?? this.bodySmall,
      labelLarge: labelLarge ?? this.labelLarge,
      labelMedium: labelMedium ?? this.labelMedium,
      labelSmall: labelSmall ?? this.labelSmall,
      letterSpacingDisplay:
          letterSpacingDisplay ?? this.letterSpacingDisplay,
      letterSpacingDisplayMedium:
          letterSpacingDisplayMedium ?? this.letterSpacingDisplayMedium,
      letterSpacingBody: letterSpacingBody ?? this.letterSpacingBody,
      letterSpacingBodyMedium:
          letterSpacingBodyMedium ?? this.letterSpacingBodyMedium,
      letterSpacingBodySmall:
          letterSpacingBodySmall ?? this.letterSpacingBodySmall,
      letterSpacingLabel: letterSpacingLabel ?? this.letterSpacingLabel,
      letterSpacingLabelMedium:
          letterSpacingLabelMedium ?? this.letterSpacingLabelMedium,
      lineHeightDisplay: lineHeightDisplay ?? this.lineHeightDisplay,
      lineHeightTitle: lineHeightTitle ?? this.lineHeightTitle,
      lineHeightBody: lineHeightBody ?? this.lineHeightBody,
      lineHeightLabel: lineHeightLabel ?? this.lineHeightLabel,
    );
  }

  static FontWeight? _parseFontWeight(dynamic value) {
    if (value == null) return null;
    if (value is int) {
      return FontWeight.values.firstWhere(
        (w) => w.value == value,
        orElse: () => FontWeight.w400,
      );
    }
    return null;
  }

  static FontSource _parseFontSource(dynamic value, FontSource fallback) {
    if (value == 'asset') return FontSource.asset;
    if (value == 'googleFonts') return FontSource.googleFonts;
    return fallback;
  }
}
