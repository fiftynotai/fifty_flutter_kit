import 'package:flutter/material.dart';

import 'sneaker_colors.dart';

/// **SneakerTypography**
///
/// FDL v2 Manrope typography scale for sneaker marketplace.
/// All text styles use Manrope font family.
abstract class SneakerTypography {
  SneakerTypography._();

  // Font Family
  static const String fontFamily = 'Manrope';

  // Font Weights
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;

  // Text Theme
  static TextTheme get textTheme => const TextTheme(
        // Display styles - Hero headlines
        displayLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 32,
          fontWeight: extraBold,
          letterSpacing: -0.5,
          color: SneakerColors.cream,
          height: 1.1,
        ),
        displayMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 24,
          fontWeight: extraBold,
          letterSpacing: -0.25,
          color: SneakerColors.cream,
          height: 1.2,
        ),
        displaySmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: bold,
          letterSpacing: 0,
          color: SneakerColors.cream,
          height: 1.2,
        ),

        // Title styles - Product titles, section headers
        titleLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 20,
          fontWeight: bold,
          letterSpacing: 0,
          color: SneakerColors.cream,
        ),
        titleMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 18,
          fontWeight: bold,
          letterSpacing: 0,
          color: SneakerColors.cream,
        ),
        titleSmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: bold,
          letterSpacing: 0,
          color: SneakerColors.cream,
        ),

        // Body styles - Descriptions, content
        bodyLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 16,
          fontWeight: medium,
          letterSpacing: 0.5,
          color: SneakerColors.cream,
          height: 1.5,
        ),
        bodyMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: regular,
          letterSpacing: 0.25,
          color: SneakerColors.cream,
          height: 1.5,
        ),
        bodySmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: regular,
          letterSpacing: 0.4,
          color: SneakerColors.slateGrey,
          height: 1.5,
        ),

        // Label styles - Buttons, tags, badges
        labelLarge: TextStyle(
          fontFamily: fontFamily,
          fontSize: 14,
          fontWeight: bold,
          letterSpacing: 1.5,
          color: SneakerColors.cream,
        ),
        labelMedium: TextStyle(
          fontFamily: fontFamily,
          fontSize: 12,
          fontWeight: bold,
          letterSpacing: 1.5,
          color: SneakerColors.cream,
        ),
        labelSmall: TextStyle(
          fontFamily: fontFamily,
          fontSize: 10,
          fontWeight: semiBold,
          letterSpacing: 0.5,
          color: SneakerColors.cream,
        ),
      );

  // Semantic Text Styles
  static TextStyle get heroHeadline => textTheme.displayLarge!;
  static TextStyle get sectionTitle => textTheme.displayMedium!;
  static TextStyle get productTitle => textTheme.titleLarge!;
  static TextStyle get cardTitle => textTheme.titleMedium!;
  static TextStyle get price => textTheme.titleSmall!;
  static TextStyle get body => textTheme.bodyLarge!;
  static TextStyle get description => textTheme.bodyMedium!;
  static TextStyle get label => textTheme.labelMedium!;
  static TextStyle get badge => textTheme.labelSmall!;
}
