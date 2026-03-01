import 'package:flutter/material.dart';

/// Configuration for gradient tokens.
///
/// All fields are required. Use [FiftyPreset.fdlV2.gradients] as a starting
/// point and [copyWith] for partial overrides.
class FiftyGradientsConfig {
  /// Creates a [FiftyGradientsConfig] with all required fields.
  const FiftyGradientsConfig({
    required this.primaryEnd,
  });

  /// Build a [FiftyGradientsConfig] from a [Map]. Missing keys fall back
  /// to [fallback].
  factory FiftyGradientsConfig.fromMap(
    Map<String, dynamic> map, {
    required FiftyGradientsConfig fallback,
  }) {
    return FiftyGradientsConfig(
      primaryEnd: map.containsKey('primaryEnd')
          ? _parseColor(map['primaryEnd'])
          : fallback.primaryEnd,
    );
  }

  /// End color for the primary gradient. Default: `Color(0xFF5A1B1F)`.
  final Color primaryEnd;

  /// Returns a copy with the given fields replaced.
  FiftyGradientsConfig copyWith({
    Color? primaryEnd,
  }) {
    return FiftyGradientsConfig(
      primaryEnd: primaryEnd ?? this.primaryEnd,
    );
  }

  static Color _parseColor(dynamic value) {
    if (value is int) return Color(value);
    if (value is String) {
      var hex = value.replaceFirst('#', '').replaceFirst('0x', '');
      if (hex.length == 6) hex = 'FF$hex';
      return Color(int.parse(hex, radix: 16));
    }
    throw ArgumentError('Cannot parse color from: $value');
  }
}
