import 'package:flutter/material.dart';

/// **SneakerColors**
///
/// FDL v2 "Sophisticated Warm" color palette for sneaker marketplace.
/// All colors mapped from FDL tokens - no hardcoded values in widgets.
///
/// **Usage:**
/// ```dart
/// Container(color: SneakerColors.burgundy)
/// ```
abstract class SneakerColors {
  SneakerColors._();

  // Primary Colors
  static const Color burgundy = Color(0xFF88292F);
  static const Color burgundyHover = Color(0xFF6E2126);
  static const Color darkBurgundy = Color(0xFF1A0D0E);

  // Background Colors
  static const Color cream = Color(0xFFFEFEE3);
  static const Color surfaceDark = Color(0xFF2A1517);

  // Accent Colors
  static const Color slateGrey = Color(0xFF335C67);
  static const Color powderBlush = Color(0xFFFFC9B9);
  static const Color hunterGreen = Color(0xFF4B644A);
  static const Color warning = Color(0xFFF7A100);

  // Semantic Colors
  static const Color textPrimary = cream;
  static const Color textSecondary = slateGrey;
  static const Color border = Color(0xFF3D2022);
  static const Color success = hunterGreen;
  static const Color error = burgundy;

  // Glassmorphism
  static Color glassBackground = darkBurgundy.withValues(alpha: 0.7);
  static Color glassBackgroundStrong = darkBurgundy.withValues(alpha: 0.9);
  static Color glassBorder = powderBlush.withValues(alpha: 0.1);

  // Gradients
  static const LinearGradient surfaceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkBurgundy, Color(0xFF0D0607)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [darkBurgundy, Color(0xFF2A1517), darkBurgundy],
  );

  static const LinearGradient grailGradient = LinearGradient(
    colors: [burgundy, Color(0xFF4A1518)],
  );
}
