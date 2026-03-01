import 'package:flutter/material.dart';

/// Parses a color from a dynamic value.
///
/// This is a package-internal helper and is NOT exported from the library
/// barrel.
///
/// Supported input types:
/// - `null` -> returns `null`
/// - `int` -> treated as a 32-bit ARGB value (`Color(value)`)
/// - `String` -> hex string in `#RRGGBB`, `0xAARRGGBB`, `AARRGGBB`, or
///   `RRGGBB` format. Six-digit strings get an `FF` alpha prefix.
///
/// Returns `null` for unrecognised types or malformed hex strings.
Color? parseColor(dynamic value) {
  if (value == null) return null;
  if (value is int) return Color(value);
  if (value is String) {
    var hex = value.replaceFirst('#', '').replaceFirst('0x', '');
    if (hex.length == 6) hex = 'FF$hex';
    try {
      return Color(int.parse(hex, radix: 16));
    } on FormatException {
      return null;
    }
  }
  return null;
}
