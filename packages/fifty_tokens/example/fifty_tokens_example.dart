// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:fifty_tokens/fifty_tokens.dart';

void main() {
  // ============================================================================
  // FIFTY TOKENS V2 EXAMPLE
  // Demonstrating FDL v2 "Sophisticated Warm" design tokens
  // ============================================================================

  // ---------------------------------------------------------------------------
  // COLORS (Sophisticated Warm palette)
  // ---------------------------------------------------------------------------

  // Core palette
  print('BURGUNDY (primary): ${FiftyColors.burgundy}'); // #88292F
  print('BURGUNDY_HOVER: ${FiftyColors.burgundyHover}'); // #6E2126
  print('CREAM: ${FiftyColors.cream}'); // #FEFEE3
  print('DARK_BURGUNDY: ${FiftyColors.darkBurgundy}'); // #1A0D0E
  print('SLATE_GREY (secondary): ${FiftyColors.slateGrey}'); // #335C67
  print('HUNTER_GREEN (success): ${FiftyColors.hunterGreen}'); // #4B644A
  print('POWDER_BLUSH: ${FiftyColors.powderBlush}'); // #FFC9B9
  print('SURFACE_DARK: ${FiftyColors.surfaceDark}'); // #2A1517

  // Semantic aliases
  print('Primary: ${FiftyColors.primary}');
  print('Secondary: ${FiftyColors.secondary}');
  print('Success: ${FiftyColors.success}');

  // ---------------------------------------------------------------------------
  // TYPOGRAPHY (Manrope unified font)
  // ---------------------------------------------------------------------------

  // Font family
  print('Font family: ${FiftyTypography.fontFamily}'); // Manrope

  // Type scale (v2)
  print('Display Large: ${FiftyTypography.displayLarge}px'); // 32px
  print('Display Medium: ${FiftyTypography.displayMedium}px'); // 24px
  print('Title Large: ${FiftyTypography.titleLarge}px'); // 20px
  print('Title Medium: ${FiftyTypography.titleMedium}px'); // 18px
  print('Body Large: ${FiftyTypography.bodyLarge}px'); // 16px
  print('Body Medium: ${FiftyTypography.bodyMedium}px'); // 14px
  print('Label Large: ${FiftyTypography.labelLarge}px'); // 14px

  // Font weights
  print('Regular: ${FiftyTypography.regular}');
  print('Medium: ${FiftyTypography.medium}');
  print('Bold: ${FiftyTypography.bold}');
  print('Extra Bold: ${FiftyTypography.extraBold}');

  // ---------------------------------------------------------------------------
  // SPACING (4px base, tight density)
  // ---------------------------------------------------------------------------

  print('Base unit: ${FiftySpacing.base}px'); // 4px
  print('Tight gap: ${FiftySpacing.tight}px'); // 8px
  print('Standard gap: ${FiftySpacing.standard}px'); // 12px

  // ---------------------------------------------------------------------------
  // RADII (Complete scale)
  // ---------------------------------------------------------------------------

  print('None: ${FiftyRadii.none}px'); // 0px
  print('Small: ${FiftyRadii.sm}px'); // 4px
  print('Medium: ${FiftyRadii.md}px'); // 8px
  print('Large: ${FiftyRadii.lg}px'); // 12px
  print('XL: ${FiftyRadii.xl}px'); // 16px
  print('XXL: ${FiftyRadii.xxl}px'); // 24px
  print('XXXL: ${FiftyRadii.xxxl}px'); // 32px
  print('Full: ${FiftyRadii.full}px'); // 9999px

  // ---------------------------------------------------------------------------
  // MOTION
  // ---------------------------------------------------------------------------

  print('Instant: ${FiftyMotion.instant}'); // 0ms
  print('Fast: ${FiftyMotion.fast}'); // 150ms
  print('Compiling: ${FiftyMotion.compiling}'); // 300ms
  print('System Load: ${FiftyMotion.systemLoad}'); // 800ms

  // ---------------------------------------------------------------------------
  // SHADOWS (v2 - Soft, sophisticated)
  // ---------------------------------------------------------------------------

  print('Shadow SM: ${FiftyShadows.sm}');
  print('Shadow MD: ${FiftyShadows.md}');
  print('Shadow LG: ${FiftyShadows.lg}');
  print('Shadow Primary: ${FiftyShadows.primary}');
  print('Shadow Glow: ${FiftyShadows.glow}');

  // ---------------------------------------------------------------------------
  // GRADIENTS (v2 - New)
  // ---------------------------------------------------------------------------

  print('Gradient Primary: ${FiftyGradients.primary}');
  print('Gradient Progress: ${FiftyGradients.progress}');
  print('Gradient Surface: ${FiftyGradients.surface}');

  // ---------------------------------------------------------------------------
  // EXAMPLE: Building a Card (v2 style)
  // ---------------------------------------------------------------------------

  final cardDecoration = BoxDecoration(
    color: FiftyColors.surfaceDark,
    borderRadius: FiftyRadii.xxlRadius,
    border: Border.all(
      color: FiftyColors.borderDark,
      width: 1,
    ),
    boxShadow: FiftyShadows.md,
  );

  print('Card decoration: $cardDecoration');

  // ---------------------------------------------------------------------------
  // EXAMPLE: Primary Button with Shadow
  // ---------------------------------------------------------------------------

  final buttonDecoration = BoxDecoration(
    color: FiftyColors.burgundy,
    borderRadius: FiftyRadii.xlRadius,
    boxShadow: FiftyShadows.primary,
  );

  print('Button decoration: $buttonDecoration');

  // ---------------------------------------------------------------------------
  // EXAMPLE: Display Text Style
  // ---------------------------------------------------------------------------

  final displayStyle = TextStyle(
    fontFamily: FiftyTypography.fontFamily,
    fontSize: FiftyTypography.displayLarge,
    fontWeight: FiftyTypography.extraBold,
    color: FiftyColors.cream,
    height: FiftyTypography.lineHeightDisplay,
    letterSpacing: FiftyTypography.letterSpacingDisplay,
  );

  print('Display style: $displayStyle');

  // ---------------------------------------------------------------------------
  // EXAMPLE: Body Text Style
  // ---------------------------------------------------------------------------

  final bodyStyle = TextStyle(
    fontFamily: FiftyTypography.fontFamily,
    fontSize: FiftyTypography.bodyLarge,
    fontWeight: FiftyTypography.medium,
    color: FiftyColors.cream,
    height: FiftyTypography.lineHeightBody,
    letterSpacing: FiftyTypography.letterSpacingBody,
  );

  print('Body style: $bodyStyle');
}
