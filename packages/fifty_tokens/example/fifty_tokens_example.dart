// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:fifty_tokens/fifty_tokens.dart';

void main() {
  // ============================================================================
  // FIFTY TOKENS EXAMPLE
  // Demonstrating FDL-aligned design tokens
  // ============================================================================

  // ---------------------------------------------------------------------------
  // COLORS (Mecha Cockpit / Server Room palette)
  // ---------------------------------------------------------------------------

  // Core palette
  print('VOID_BLACK: ${FiftyColors.voidBlack}'); // #050505
  print('CRIMSON_PULSE: ${FiftyColors.crimsonPulse}'); // #960E29
  print('GUNMETAL: ${FiftyColors.gunmetal}'); // #1A1A1A
  print('TERMINAL_WHITE: ${FiftyColors.terminalWhite}'); // #EAEAEA
  print('HYPER_CHROME: ${FiftyColors.hyperChrome}'); // #888888
  print('IGRIS_GREEN: ${FiftyColors.igrisGreen}'); // #00FF41

  // ---------------------------------------------------------------------------
  // TYPOGRAPHY (Monument Extended + JetBrains Mono)
  // ---------------------------------------------------------------------------

  // Font families
  print(
    'Headline font: ${FiftyTypography.fontFamilyHeadline}',
  ); // Monument Extended
  print('Mono font: ${FiftyTypography.fontFamilyMono}'); // JetBrains Mono

  // Type scale
  print('Hero: ${FiftyTypography.hero}px'); // 64px
  print('Display: ${FiftyTypography.display}px'); // 48px
  print('Section: ${FiftyTypography.section}px'); // 32px
  print('Body: ${FiftyTypography.body}px'); // 16px
  print('Mono: ${FiftyTypography.mono}px'); // 12px

  // ---------------------------------------------------------------------------
  // SPACING (4px base, tight density)
  // ---------------------------------------------------------------------------

  print('Base unit: ${FiftySpacing.base}px'); // 4px
  print('Tight gap: ${FiftySpacing.tight}px'); // 8px
  print('Standard gap: ${FiftySpacing.standard}px'); // 12px

  // ---------------------------------------------------------------------------
  // RADII (12px standard, 24px smooth)
  // ---------------------------------------------------------------------------

  print('Standard radius: ${FiftyRadii.standard}px'); // 12px
  print('Smooth radius: ${FiftyRadii.smooth}px'); // 24px

  // ---------------------------------------------------------------------------
  // MOTION (NO FADES - Kinetic)
  // ---------------------------------------------------------------------------

  print('Instant: ${FiftyMotion.instant}'); // 0ms
  print('Fast: ${FiftyMotion.fast}'); // 150ms
  print('Compiling: ${FiftyMotion.compiling}'); // 300ms
  print('System Load: ${FiftyMotion.systemLoad}'); // 800ms

  // ---------------------------------------------------------------------------
  // EXAMPLE: Building a "Data Slate" Card (FDL Component)
  // ---------------------------------------------------------------------------

  final dataSlateDecoration = BoxDecoration(
    color: FiftyColors.gunmetal,
    borderRadius: FiftyRadii.standardRadius,
    border: Border.all(
      color: FiftyColors.border, // hyperChrome @ 10%
      width: 1,
    ),
  );

  print('Data Slate decoration: $dataSlateDecoration');

  // ---------------------------------------------------------------------------
  // EXAMPLE: Focus State with Crimson Glow
  // ---------------------------------------------------------------------------

  final focusDecoration = BoxDecoration(
    color: FiftyColors.gunmetal,
    borderRadius: FiftyRadii.standardRadius,
    boxShadow: FiftyElevation.focus,
  );

  print('Focus decoration: $focusDecoration');

  // ---------------------------------------------------------------------------
  // EXAMPLE: Terminal Text Style
  // ---------------------------------------------------------------------------

  const terminalStyle = TextStyle(
    fontFamily: FiftyTypography.fontFamilyMono,
    fontSize: FiftyTypography.mono,
    fontWeight: FiftyTypography.regular,
    color: FiftyColors.igrisGreen,
    height: FiftyTypography.codeLineHeight,
  );

  print('Terminal style: $terminalStyle');
}
