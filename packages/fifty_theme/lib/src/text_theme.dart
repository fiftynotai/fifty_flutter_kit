import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Fifty.dev text theme builder.
///
/// Creates a Flutter TextTheme using FiftyTypography tokens.
/// Implements the binary type system:
/// - Hype (Monument Extended) - Headlines, impact
/// - Logic (JetBrains Mono) - Body, code, UI
///
/// All display text uses ALL CAPS convention per FDL.
class FiftyTextTheme {
  FiftyTextTheme._();

  /// Creates the Fifty text theme for dark mode.
  ///
  /// Text colors are applied through ColorScheme, not hardcoded here.
  /// This allows the theme to adapt to both dark and light modes.
  ///
  /// Scale:
  /// - `displayLarge`: Hero (64px) - Monument Extended Ultrabold
  /// - `displayMedium`: Display (48px) - Monument Extended Ultrabold
  /// - `displaySmall`: Section (32px) - Monument Extended Regular
  /// - `bodyLarge`: Body (16px) - JetBrains Mono
  /// - `bodySmall`: Mono (12px) - JetBrains Mono
  static TextTheme textTheme() {
    return const TextTheme(
      // Display styles - Monument Extended (Hype)
      displayLarge: TextStyle(
        fontFamily: FiftyTypography.fontFamilyHeadline,
        fontSize: FiftyTypography.hero,
        fontWeight: FiftyTypography.ultrabold,
        letterSpacing: FiftyTypography.hero * FiftyTypography.tight,
        height: FiftyTypography.displayLineHeight,
      ),
      displayMedium: TextStyle(
        fontFamily: FiftyTypography.fontFamilyHeadline,
        fontSize: FiftyTypography.display,
        fontWeight: FiftyTypography.ultrabold,
        letterSpacing: FiftyTypography.display * FiftyTypography.tight,
        height: FiftyTypography.displayLineHeight,
      ),
      displaySmall: TextStyle(
        fontFamily: FiftyTypography.fontFamilyHeadline,
        fontSize: FiftyTypography.section,
        fontWeight: FiftyTypography.regular,
        letterSpacing: FiftyTypography.section * FiftyTypography.tight,
        height: FiftyTypography.headingLineHeight,
      ),

      // Headline styles - Monument Extended (Hype)
      headlineLarge: TextStyle(
        fontFamily: FiftyTypography.fontFamilyHeadline,
        fontSize: FiftyTypography.section,
        fontWeight: FiftyTypography.ultrabold,
        letterSpacing: FiftyTypography.section * FiftyTypography.tight,
        height: FiftyTypography.headingLineHeight,
      ),
      headlineMedium: TextStyle(
        fontFamily: FiftyTypography.fontFamilyHeadline,
        fontSize: 24,
        fontWeight: FiftyTypography.ultrabold,
        letterSpacing: 24 * FiftyTypography.tight,
        height: FiftyTypography.headingLineHeight,
      ),
      headlineSmall: TextStyle(
        fontFamily: FiftyTypography.fontFamilyHeadline,
        fontSize: 20,
        fontWeight: FiftyTypography.medium,
        letterSpacing: 20 * FiftyTypography.tight,
        height: FiftyTypography.headingLineHeight,
      ),

      // Title styles - JetBrains Mono (Logic)
      titleLarge: TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: 20,
        fontWeight: FiftyTypography.medium,
        letterSpacing: FiftyTypography.standard,
        height: FiftyTypography.bodyLineHeight,
      ),
      titleMedium: TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: FiftyTypography.body,
        fontWeight: FiftyTypography.medium,
        letterSpacing: FiftyTypography.standard,
        height: FiftyTypography.bodyLineHeight,
      ),
      titleSmall: TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: 14,
        fontWeight: FiftyTypography.medium,
        letterSpacing: FiftyTypography.standard,
        height: FiftyTypography.bodyLineHeight,
      ),

      // Body styles - JetBrains Mono (Logic)
      bodyLarge: TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: FiftyTypography.body,
        fontWeight: FiftyTypography.regular,
        letterSpacing: FiftyTypography.standard,
        height: FiftyTypography.bodyLineHeight,
      ),
      bodyMedium: TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: 14,
        fontWeight: FiftyTypography.regular,
        letterSpacing: FiftyTypography.standard,
        height: FiftyTypography.bodyLineHeight,
      ),
      bodySmall: TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: FiftyTypography.mono,
        fontWeight: FiftyTypography.regular,
        letterSpacing: FiftyTypography.standard,
        height: FiftyTypography.codeLineHeight,
      ),

      // Label styles - JetBrains Mono (Logic)
      labelLarge: TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: 14,
        fontWeight: FiftyTypography.medium,
        letterSpacing: FiftyTypography.standard,
        height: FiftyTypography.bodyLineHeight,
      ),
      labelMedium: TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: FiftyTypography.mono,
        fontWeight: FiftyTypography.medium,
        letterSpacing: FiftyTypography.standard,
        height: FiftyTypography.bodyLineHeight,
      ),
      labelSmall: TextStyle(
        fontFamily: FiftyTypography.fontFamilyMono,
        fontSize: 10,
        fontWeight: FiftyTypography.medium,
        letterSpacing: FiftyTypography.standard,
        height: FiftyTypography.bodyLineHeight,
      ),
    );
  }
}
