import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Fifty.dev color scheme builder.
///
/// Maps FiftyColors tokens to Flutter's ColorScheme for Material Design
/// integration. Dark mode is primary following FDL specification.
///
/// The color scheme uses the "Mecha Cockpit" aesthetic:
/// - Void Black as the primary surface
/// - Crimson Pulse as the brand accent
/// - Terminal White for high-contrast text
class FiftyColorScheme {
  FiftyColorScheme._();

  /// Creates a dark ColorScheme using Fifty design tokens.
  ///
  /// This is the PRIMARY color scheme for the ecosystem.
  /// Optimized for OLED displays and reduced eye strain.
  ///
  /// Color mappings:
  /// - `primary`: Crimson Pulse (brand signature)
  /// - `secondary`: Hyper Chrome (metallic accent)
  /// - `surface`: Void Black (deep background)
  /// - `error`: Crimson Pulse (destructive actions carry brand)
  static ColorScheme dark() {
    return ColorScheme(
      brightness: Brightness.dark,

      // Primary colors - Crimson Pulse (brand signature)
      primary: FiftyColors.crimsonPulse,
      onPrimary: FiftyColors.terminalWhite,
      primaryContainer: FiftyColors.crimsonPulse.withValues(alpha: 0.2),
      onPrimaryContainer: FiftyColors.terminalWhite,

      // Secondary colors - Hyper Chrome (metallic)
      secondary: FiftyColors.hyperChrome,
      onSecondary: FiftyColors.voidBlack,
      secondaryContainer: FiftyColors.gunmetal,
      onSecondaryContainer: FiftyColors.terminalWhite,

      // Tertiary colors - Igris Green (AI/terminal)
      tertiary: FiftyColors.igrisGreen,
      onTertiary: FiftyColors.voidBlack,
      tertiaryContainer: FiftyColors.igrisGreen.withValues(alpha: 0.2),
      onTertiaryContainer: FiftyColors.igrisGreen,

      // Error colors - Crimson Pulse (destructive = brand)
      error: FiftyColors.error,
      onError: FiftyColors.terminalWhite,
      errorContainer: FiftyColors.error.withValues(alpha: 0.2),
      onErrorContainer: FiftyColors.terminalWhite,

      // Surface colors - Void Black base
      surface: FiftyColors.voidBlack,
      onSurface: FiftyColors.terminalWhite,
      surfaceContainerHighest: FiftyColors.gunmetal,
      onSurfaceVariant: FiftyColors.hyperChrome,

      // Outline colors - Hyper Chrome based
      outline: FiftyColors.border,
      outlineVariant: FiftyColors.hyperChrome.withValues(alpha: 0.3),

      // Other
      shadow: Colors.transparent, // No shadows per FDL
      scrim: FiftyColors.voidBlack.withValues(alpha: 0.8),
      inverseSurface: FiftyColors.terminalWhite,
      onInverseSurface: FiftyColors.voidBlack,
      inversePrimary: FiftyColors.crimsonPulse,
    );
  }

  /// Creates a light ColorScheme using Fifty design tokens.
  ///
  /// This is the SECONDARY color scheme, provided for accessibility.
  /// Inverts the dark palette while maintaining brand identity.
  ///
  /// Note: FDL specifies dark mode as primary. Use light mode
  /// only when necessary for accessibility or user preference.
  static ColorScheme light() {
    return ColorScheme(
      brightness: Brightness.light,

      // Primary colors - Crimson Pulse (brand signature maintained)
      primary: FiftyColors.crimsonPulse,
      onPrimary: FiftyColors.terminalWhite,
      primaryContainer: FiftyColors.crimsonPulse.withValues(alpha: 0.15),
      onPrimaryContainer: FiftyColors.crimsonPulse,

      // Secondary colors - Hyper Chrome (metallic)
      secondary: FiftyColors.hyperChrome,
      onSecondary: FiftyColors.terminalWhite,
      secondaryContainer: FiftyColors.hyperChrome.withValues(alpha: 0.2),
      onSecondaryContainer: FiftyColors.voidBlack,

      // Tertiary colors - Igris Green (AI/terminal)
      tertiary: FiftyColors.igrisGreen,
      onTertiary: FiftyColors.voidBlack,
      tertiaryContainer: FiftyColors.igrisGreen.withValues(alpha: 0.15),
      onTertiaryContainer: FiftyColors.voidBlack,

      // Error colors - Crimson Pulse
      error: FiftyColors.error,
      onError: FiftyColors.terminalWhite,
      errorContainer: FiftyColors.error.withValues(alpha: 0.15),
      onErrorContainer: FiftyColors.crimsonPulse,

      // Surface colors - Terminal White base
      surface: FiftyColors.terminalWhite,
      onSurface: FiftyColors.voidBlack,
      surfaceContainerHighest: FiftyColors.hyperChrome.withValues(alpha: 0.2),
      onSurfaceVariant: FiftyColors.hyperChrome,

      // Outline colors
      outline: FiftyColors.hyperChrome.withValues(alpha: 0.3),
      outlineVariant: FiftyColors.hyperChrome.withValues(alpha: 0.15),

      // Other
      shadow: Colors.transparent, // No shadows per FDL
      scrim: FiftyColors.voidBlack.withValues(alpha: 0.4),
      inverseSurface: FiftyColors.voidBlack,
      onInverseSurface: FiftyColors.terminalWhite,
      inversePrimary: FiftyColors.crimsonPulse,
    );
  }
}
