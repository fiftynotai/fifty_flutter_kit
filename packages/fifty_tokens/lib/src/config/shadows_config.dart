import 'package:flutter/material.dart';

import 'parse_helpers.dart';

/// Configuration for shadow tokens.
///
/// All fields are required. Use [FiftyPreset.fdlV2.shadows] as a starting
/// point and [copyWith] for partial overrides.
class FiftyShadowsConfig {
  /// Creates a [FiftyShadowsConfig] with all required fields.
  const FiftyShadowsConfig({
    required this.sm,
    required this.md,
    required this.lg,
    required this.primaryOpacity,
    required this.glowOpacity,
  });

  /// Build a [FiftyShadowsConfig] from a [Map]. Missing keys fall back
  /// to [fallback].
  factory FiftyShadowsConfig.fromMap(
    Map<String, dynamic> map, {
    required FiftyShadowsConfig fallback,
  }) {
    return FiftyShadowsConfig(
      sm: map.containsKey('sm')
          ? _parseBoxShadowList(map['sm'])
          : fallback.sm,
      md: map.containsKey('md')
          ? _parseBoxShadowList(map['md'])
          : fallback.md,
      lg: map.containsKey('lg')
          ? _parseBoxShadowList(map['lg'])
          : fallback.lg,
      primaryOpacity:
          (map['primaryOpacity'] as num?)?.toDouble() ??
          fallback.primaryOpacity,
      glowOpacity:
          (map['glowOpacity'] as num?)?.toDouble() ?? fallback.glowOpacity,
    );
  }

  /// Small shadow list. Default: subtle 1px offset.
  final List<BoxShadow> sm;

  /// Medium shadow list. Default: 4px offset.
  final List<BoxShadow> md;

  /// Large shadow list. Default: 10px offset.
  final List<BoxShadow> lg;

  /// Opacity for primary button shadow. Default: `0.2`.
  final double primaryOpacity;

  /// Opacity for dark-mode glow shadow. Default: `0.1`.
  final double glowOpacity;

  /// Returns a copy with the given fields replaced.
  FiftyShadowsConfig copyWith({
    List<BoxShadow>? sm,
    List<BoxShadow>? md,
    List<BoxShadow>? lg,
    double? primaryOpacity,
    double? glowOpacity,
  }) {
    return FiftyShadowsConfig(
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      primaryOpacity: primaryOpacity ?? this.primaryOpacity,
      glowOpacity: glowOpacity ?? this.glowOpacity,
    );
  }

  static List<BoxShadow> _parseBoxShadowList(dynamic value) {
    if (value is! List) return [];
    return value.whereType<Map<String, dynamic>>().map((m) {
      return BoxShadow(
        offset: Offset(
          (m['dx'] as num?)?.toDouble() ?? 0,
          (m['dy'] as num?)?.toDouble() ?? 0,
        ),
        blurRadius: (m['blurRadius'] as num?)?.toDouble() ?? 0,
        spreadRadius: (m['spreadRadius'] as num?)?.toDouble() ?? 0,
        color: parseColor(m['color']) ?? const Color(0x00000000),
      );
    }).toList();
  }
}
