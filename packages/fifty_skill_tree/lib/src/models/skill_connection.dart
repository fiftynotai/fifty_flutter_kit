import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'connection_style.dart';
import 'connection_type.dart';

/// Represents a connection between two skill nodes.
///
/// Connections define the prerequisite relationships and visual links
/// between nodes in the skill tree.
///
/// **Example:**
/// ```dart
/// final connection = SkillConnection(
///   fromId: 'basic_attack',
///   toId: 'power_strike',
///   type: ConnectionType.required,
/// );
/// ```
@immutable
class SkillConnection {
  /// Creates a new skill connection.
  ///
  /// [fromId] is the source node (prerequisite).
  /// [toId] is the target node (dependent).
  const SkillConnection({
    required this.fromId,
    required this.toId,
    this.type = ConnectionType.required,
    this.bidirectional = false,
    this.color,
    this.thickness,
    this.style = ConnectionStyle.solid,
  });

  /// ID of the source node (the prerequisite).
  final String fromId;

  /// ID of the target node (the dependent).
  final String toId;

  /// The type of relationship between nodes.
  final ConnectionType type;

  /// Whether the connection works in both directions.
  ///
  /// If true, either node can be unlocked first (rare case).
  final bool bidirectional;

  /// Custom color override for this connection.
  ///
  /// If null, uses the theme's default connection color.
  final Color? color;

  /// Custom thickness override for this connection line.
  ///
  /// If null, uses the theme's default thickness.
  final double? thickness;

  /// Visual style for rendering the connection line.
  final ConnectionStyle style;

  /// Creates a copy of this connection with the given fields replaced.
  SkillConnection copyWith({
    String? fromId,
    String? toId,
    ConnectionType? type,
    bool? bidirectional,
    Color? color,
    double? thickness,
    ConnectionStyle? style,
  }) {
    return SkillConnection(
      fromId: fromId ?? this.fromId,
      toId: toId ?? this.toId,
      type: type ?? this.type,
      bidirectional: bidirectional ?? this.bidirectional,
      color: color ?? this.color,
      thickness: thickness ?? this.thickness,
      style: style ?? this.style,
    );
  }

  /// Converts this connection to a JSON map.
  ///
  /// Note: [color] is serialized as an int value.
  Map<String, dynamic> toJson() {
    return {
      'fromId': fromId,
      'toId': toId,
      'type': type.name,
      'bidirectional': bidirectional,
      if (color != null) 'color': color!.toARGB32(),
      if (thickness != null) 'thickness': thickness,
      'style': style.name,
    };
  }

  /// Creates a skill connection from a JSON map.
  factory SkillConnection.fromJson(Map<String, dynamic> json) {
    return SkillConnection(
      fromId: json['fromId'] as String,
      toId: json['toId'] as String,
      type: ConnectionType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => ConnectionType.required,
      ),
      bidirectional: json['bidirectional'] as bool? ?? false,
      color: json['color'] != null ? Color(json['color'] as int) : null,
      thickness: (json['thickness'] as num?)?.toDouble(),
      style: ConnectionStyle.values.firstWhere(
        (s) => s.name == json['style'],
        orElse: () => ConnectionStyle.solid,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SkillConnection) return false;
    return fromId == other.fromId &&
        toId == other.toId &&
        type == other.type &&
        bidirectional == other.bidirectional &&
        color == other.color &&
        thickness == other.thickness &&
        style == other.style;
  }

  @override
  int get hashCode {
    return Object.hash(
      fromId,
      toId,
      type,
      bidirectional,
      color,
      thickness,
      style,
    );
  }

  @override
  String toString() {
    return 'SkillConnection(from: $fromId, to: $toId, type: ${type.name})';
  }
}
