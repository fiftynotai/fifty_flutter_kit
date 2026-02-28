import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'typography_config.dart';

/// Resolves font family based on [FontSource].
///
/// For [FontSource.googleFonts], uses the google_fonts package to
/// fetch and cache the font. For [FontSource.asset], uses the
/// local font family name directly.
class FiftyFontResolver {
  FiftyFontResolver._();

  /// Resolves a [TextStyle] with the correct font family applied.
  ///
  /// Pass [fontFamily] and [source] from [FiftyTypographyConfig].
  /// The [baseStyle] is the TextStyle to apply the font to.
  static TextStyle resolve({
    required String fontFamily,
    required FontSource source,
    TextStyle? baseStyle,
  }) {
    switch (source) {
      case FontSource.googleFonts:
        return GoogleFonts.getFont(fontFamily, textStyle: baseStyle);
      case FontSource.asset:
        return (baseStyle ?? const TextStyle()).copyWith(
          fontFamily: fontFamily,
        );
    }
  }

  /// Returns the resolved font family name as a [String].
  ///
  /// For Google Fonts, this triggers font registration and returns
  /// the registered family name. For asset fonts, returns the name as-is.
  static String resolveFamilyName({
    required String fontFamily,
    required FontSource source,
  }) {
    switch (source) {
      case FontSource.googleFonts:
        return GoogleFonts.getFont(fontFamily).fontFamily ?? fontFamily;
      case FontSource.asset:
        return fontFamily;
    }
  }
}
