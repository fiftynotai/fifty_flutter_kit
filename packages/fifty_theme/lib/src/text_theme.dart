import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Fifty.dev text theme builder v2 - unified font via [FiftyFontResolver].
///
/// Creates a Flutter TextTheme using the configured font family.
/// Defaults to Manrope via google_fonts unless overridden through
/// [FiftyTokens.configure] or the optional parameters below.
class FiftyTextTheme {
  FiftyTextTheme._();

  /// Creates the Fifty v2 text theme.
  ///
  /// Pass optional [fontFamily] and [fontSource] to override the
  /// globally configured values from [FiftyTypography].
  ///
  /// Scale:
  /// - `displayLarge`: 32px, extraBold (800)
  /// - `displayMedium`: 24px, extraBold (800)
  /// - `displaySmall`: 20px, bold (700)
  /// - `headlineLarge`: 20px, bold
  /// - `headlineMedium`: 18px, bold
  /// - `headlineSmall`: 16px, bold
  /// - `titleLarge`: 20px, bold
  /// - `titleMedium`: 18px, bold
  /// - `titleSmall`: 16px, bold
  /// - `bodyLarge`: 16px, medium (500)
  /// - `bodyMedium`: 14px, regular (400)
  /// - `bodySmall`: 12px, regular
  /// - `labelLarge`: 14px, bold
  /// - `labelMedium`: 12px, bold (UPPERCASE, letterSpacing 1.5)
  /// - `labelSmall`: 10px, semiBold (600)
  static TextTheme textTheme({String? fontFamily, FontSource? fontSource}) {
    final family = fontFamily ?? FiftyTypography.fontFamily;
    final source = fontSource ?? FiftyTypography.fontSource;

    TextStyle style({
      required double fontSize,
      required FontWeight fontWeight,
      double? letterSpacing,
      double? height,
    }) {
      return FiftyFontResolver.resolve(
        fontFamily: family,
        source: source,
        baseStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          height: height,
        ),
      );
    }

    return TextTheme(
      // Display styles
      displayLarge: style(
        fontSize: FiftyTypography.displayLarge,
        fontWeight: FiftyTypography.extraBold,
        letterSpacing: FiftyTypography.letterSpacingDisplay,
        height: FiftyTypography.lineHeightDisplay,
      ),
      displayMedium: style(
        fontSize: FiftyTypography.displayMedium,
        fontWeight: FiftyTypography.extraBold,
        letterSpacing: FiftyTypography.letterSpacingDisplayMedium,
        height: FiftyTypography.lineHeightDisplay,
      ),
      displaySmall: style(
        fontSize: FiftyTypography.titleLarge,
        fontWeight: FiftyTypography.bold,
        height: FiftyTypography.lineHeightTitle,
      ),

      // Headline styles
      headlineLarge: style(
        fontSize: FiftyTypography.titleLarge,
        fontWeight: FiftyTypography.bold,
        height: FiftyTypography.lineHeightTitle,
      ),
      headlineMedium: style(
        fontSize: FiftyTypography.titleMedium,
        fontWeight: FiftyTypography.bold,
        height: FiftyTypography.lineHeightTitle,
      ),
      headlineSmall: style(
        fontSize: FiftyTypography.titleSmall,
        fontWeight: FiftyTypography.bold,
        height: FiftyTypography.lineHeightTitle,
      ),

      // Title styles
      titleLarge: style(
        fontSize: FiftyTypography.titleLarge,
        fontWeight: FiftyTypography.bold,
        height: FiftyTypography.lineHeightTitle,
      ),
      titleMedium: style(
        fontSize: FiftyTypography.titleMedium,
        fontWeight: FiftyTypography.bold,
        height: FiftyTypography.lineHeightTitle,
      ),
      titleSmall: style(
        fontSize: FiftyTypography.titleSmall,
        fontWeight: FiftyTypography.bold,
        height: FiftyTypography.lineHeightTitle,
      ),

      // Body styles
      bodyLarge: style(
        fontSize: FiftyTypography.bodyLarge,
        fontWeight: FiftyTypography.medium,
        letterSpacing: FiftyTypography.letterSpacingBody,
        height: FiftyTypography.lineHeightBody,
      ),
      bodyMedium: style(
        fontSize: FiftyTypography.bodyMedium,
        fontWeight: FiftyTypography.regular,
        letterSpacing: FiftyTypography.letterSpacingBodyMedium,
        height: FiftyTypography.lineHeightBody,
      ),
      bodySmall: style(
        fontSize: FiftyTypography.bodySmall,
        fontWeight: FiftyTypography.regular,
        letterSpacing: FiftyTypography.letterSpacingBodySmall,
        height: FiftyTypography.lineHeightBody,
      ),

      // Label styles
      labelLarge: style(
        fontSize: FiftyTypography.labelLarge,
        fontWeight: FiftyTypography.bold,
        letterSpacing: FiftyTypography.letterSpacingLabel,
        height: FiftyTypography.lineHeightLabel,
      ),
      labelMedium: style(
        fontSize: FiftyTypography.labelMedium,
        fontWeight: FiftyTypography.bold,
        letterSpacing: FiftyTypography.letterSpacingLabelMedium,
        height: FiftyTypography.lineHeightLabel,
      ),
      labelSmall: style(
        fontSize: FiftyTypography.labelSmall,
        fontWeight: FiftyTypography.semiBold,
        letterSpacing: FiftyTypography.letterSpacingLabel,
        height: FiftyTypography.lineHeightLabel,
      ),
    );
  }
}
