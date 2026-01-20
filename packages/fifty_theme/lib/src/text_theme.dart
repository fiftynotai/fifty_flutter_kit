import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Fifty.dev text theme builder v2 - Manrope unified font.
///
/// Creates a Flutter TextTheme using Manrope via google_fonts.
/// Replaces the binary type system (Monument/JetBrains) with unified Manrope.
class FiftyTextTheme {
  FiftyTextTheme._();

  /// Creates the Fifty v2 text theme.
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
  static TextTheme textTheme() {
    return TextTheme(
      // Display styles
      displayLarge: GoogleFonts.manrope(
        fontSize: FiftyTypography.displayLarge,
        fontWeight: FiftyTypography.extraBold,
        letterSpacing: FiftyTypography.letterSpacingDisplay,
        height: FiftyTypography.lineHeightDisplay,
      ),
      displayMedium: GoogleFonts.manrope(
        fontSize: FiftyTypography.displayMedium,
        fontWeight: FiftyTypography.extraBold,
        letterSpacing: FiftyTypography.letterSpacingDisplayMedium,
        height: FiftyTypography.lineHeightDisplay,
      ),
      displaySmall: GoogleFonts.manrope(
        fontSize: FiftyTypography.titleLarge,
        fontWeight: FiftyTypography.bold,
        height: FiftyTypography.lineHeightTitle,
      ),

      // Headline styles
      headlineLarge: GoogleFonts.manrope(
        fontSize: FiftyTypography.titleLarge,
        fontWeight: FiftyTypography.bold,
        height: FiftyTypography.lineHeightTitle,
      ),
      headlineMedium: GoogleFonts.manrope(
        fontSize: FiftyTypography.titleMedium,
        fontWeight: FiftyTypography.bold,
        height: FiftyTypography.lineHeightTitle,
      ),
      headlineSmall: GoogleFonts.manrope(
        fontSize: FiftyTypography.titleSmall,
        fontWeight: FiftyTypography.bold,
        height: FiftyTypography.lineHeightTitle,
      ),

      // Title styles
      titleLarge: GoogleFonts.manrope(
        fontSize: FiftyTypography.titleLarge,
        fontWeight: FiftyTypography.bold,
        height: FiftyTypography.lineHeightTitle,
      ),
      titleMedium: GoogleFonts.manrope(
        fontSize: FiftyTypography.titleMedium,
        fontWeight: FiftyTypography.bold,
        height: FiftyTypography.lineHeightTitle,
      ),
      titleSmall: GoogleFonts.manrope(
        fontSize: FiftyTypography.titleSmall,
        fontWeight: FiftyTypography.bold,
        height: FiftyTypography.lineHeightTitle,
      ),

      // Body styles
      bodyLarge: GoogleFonts.manrope(
        fontSize: FiftyTypography.bodyLarge,
        fontWeight: FiftyTypography.medium,
        letterSpacing: FiftyTypography.letterSpacingBody,
        height: FiftyTypography.lineHeightBody,
      ),
      bodyMedium: GoogleFonts.manrope(
        fontSize: FiftyTypography.bodyMedium,
        fontWeight: FiftyTypography.regular,
        letterSpacing: FiftyTypography.letterSpacingBodyMedium,
        height: FiftyTypography.lineHeightBody,
      ),
      bodySmall: GoogleFonts.manrope(
        fontSize: FiftyTypography.bodySmall,
        fontWeight: FiftyTypography.regular,
        letterSpacing: FiftyTypography.letterSpacingBodySmall,
        height: FiftyTypography.lineHeightBody,
      ),

      // Label styles
      labelLarge: GoogleFonts.manrope(
        fontSize: FiftyTypography.labelLarge,
        fontWeight: FiftyTypography.bold,
        letterSpacing: FiftyTypography.letterSpacingLabel,
        height: FiftyTypography.lineHeightLabel,
      ),
      labelMedium: GoogleFonts.manrope(
        fontSize: FiftyTypography.labelMedium,
        fontWeight: FiftyTypography.bold,
        letterSpacing: FiftyTypography.letterSpacingLabelMedium,
        height: FiftyTypography.lineHeightLabel,
      ),
      labelSmall: GoogleFonts.manrope(
        fontSize: FiftyTypography.labelSmall,
        fontWeight: FiftyTypography.semiBold,
        letterSpacing: FiftyTypography.letterSpacingLabel,
        height: FiftyTypography.lineHeightLabel,
      ),
    );
  }
}
