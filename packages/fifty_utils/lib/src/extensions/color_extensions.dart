import 'dart:ui';

/// **HexColor Extension**
///
/// Extension to convert between hex color strings and `Color` objects.
///
/// **Usage**:
/// ```dart
/// // From hex string to Color
/// Color color = HexColor.fromHex("#aabbcc");
///
/// // From Color to hex string
/// String hex = color.toHex(); // "#ffaabbcc"
/// ```
extension HexColor on Color {
  /// Converts a hex string to a [Color] object.
  ///
  /// The hex string can be in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  /// If the string is only 6 or 7 characters long, an opaque alpha value of "ff" is added by default.
  ///
  /// Example:
  /// ```dart
  /// Color color = HexColor.fromHex("#aabbcc");
  /// Color withAlpha = HexColor.fromHex("#80aabbcc");
  /// ```
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) {
      buffer.write('ff'); // Default alpha value.
    }
    buffer.write(hexString.replaceFirst('#', '')); // Remove the hash if present.
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Converts a [Color] object to a hex string.
  ///
  /// If [leadingHashSign] is set to `true` (default), the string will start with "#".
  ///
  /// Example:
  /// ```dart
  /// String hex = color.toHex(); // "#ffaabbcc"
  /// String noHash = color.toHex(leadingHashSign: false); // "ffaabbcc"
  /// ```
  String toHex({bool leadingHashSign = true}) {
    return '${leadingHashSign ? '#' : ''}'
        '${((a * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}'
        '${((r * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}'
        '${((g * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}'
        '${((b * 255.0).round() & 0xff).toRadixString(16).padLeft(2, '0')}';
  }
}
