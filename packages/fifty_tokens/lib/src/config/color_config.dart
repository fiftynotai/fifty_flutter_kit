import 'package:flutter/material.dart';

/// Configuration for [FiftyColors] token overrides.
///
/// All fields are optional. `null` means "use FDL default".
/// Pass to [FiftyTokens.configure()] before `runApp()`.
class FiftyColorConfig {
  /// Creates a [FiftyColorConfig] with optional overrides.
  const FiftyColorConfig({
    this.burgundy,
    this.burgundyHover,
    this.cream,
    this.darkBurgundy,
    this.slateGrey,
    this.slateGreyHover,
    this.hunterGreen,
    this.powderBlush,
    this.surfaceLight,
    this.surfaceDark,
    this.primary,
    this.primaryHover,
    this.secondary,
    this.secondaryHover,
    this.success,
    this.warning,
    this.error,
    this.focusLight,
  });

  /// Override for [FiftyColors.burgundy]. Default: `Color(0xFF88292F)`.
  final Color? burgundy;

  /// Override for [FiftyColors.burgundyHover]. Default: `Color(0xFF6E2126)`.
  final Color? burgundyHover;

  /// Override for [FiftyColors.cream]. Default: `Color(0xFFFEFEE3)`.
  final Color? cream;

  /// Override for [FiftyColors.darkBurgundy]. Default: `Color(0xFF1A0D0E)`.
  final Color? darkBurgundy;

  /// Override for [FiftyColors.slateGrey]. Default: `Color(0xFF335C67)`.
  final Color? slateGrey;

  /// Override for [FiftyColors.slateGreyHover]. Default: `Color(0xFF274750)`.
  final Color? slateGreyHover;

  /// Override for [FiftyColors.hunterGreen]. Default: `Color(0xFF4B644A)`.
  final Color? hunterGreen;

  /// Override for [FiftyColors.powderBlush]. Default: `Color(0xFFFFC9B9)`.
  final Color? powderBlush;

  /// Override for [FiftyColors.surfaceLight]. Default: `Color(0xFFFAF9DE)`.
  final Color? surfaceLight;

  /// Override for [FiftyColors.surfaceDark]. Default: `Color(0xFF2A1517)`.
  final Color? surfaceDark;

  /// Override for [FiftyColors.primary]. Default: falls back to [burgundy].
  final Color? primary;

  /// Override for [FiftyColors.primaryHover]. Default: falls back to [burgundyHover].
  final Color? primaryHover;

  /// Override for [FiftyColors.secondary]. Default: falls back to [slateGrey].
  final Color? secondary;

  /// Override for [FiftyColors.secondaryHover]. Default: falls back to [slateGreyHover].
  final Color? secondaryHover;

  /// Override for [FiftyColors.success]. Default: falls back to [hunterGreen].
  final Color? success;

  /// Override for [FiftyColors.warning]. Default: `Color(0xFFF7A100)`.
  final Color? warning;

  /// Override for [FiftyColors.error]. Default: falls back to [primary].
  final Color? error;

  /// Override for [FiftyColors.focusLight]. Default: falls back to [primary].
  final Color? focusLight;
}
