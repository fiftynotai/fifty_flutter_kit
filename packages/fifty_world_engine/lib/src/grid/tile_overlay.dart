import 'dart:ui' show Color;

/// Visual overlay applied to a tile.
///
/// Overlays render as semi-transparent colored rectangles above the tile
/// but below entities. Use [HighlightStyle] for common presets.
class TileOverlay {
  /// The overlay color.
  final Color color;

  /// Opacity (0.0 = invisible, 1.0 = fully opaque).
  final double opacity;

  /// Group identifier for batch operations (e.g., 'validMoves', 'attackRange').
  ///
  /// Use [OverlayManager.clearGroup] to remove all overlays with the same group.
  final String? group;

  /// Creates a [TileOverlay].
  const TileOverlay({
    required this.color,
    this.opacity = 0.4,
    this.group,
  });

  @override
  bool operator ==(Object other) =>
      other is TileOverlay &&
      color == other.color &&
      opacity == other.opacity &&
      group == other.group;

  @override
  int get hashCode => Object.hash(color, opacity, group);

  @override
  String toString() =>
      'TileOverlay(color: $color, opacity: $opacity, group: $group)';
}

/// Preset highlight styles for common game scenarios.
///
/// Each preset has a sensible color, opacity, and group for batch management.
class HighlightStyle {
  HighlightStyle._();

  /// Green highlight for valid movement destinations.
  static const TileOverlay validMove = TileOverlay(
    color: Color(0xFF4CAF50),
    opacity: 0.4,
    group: 'validMoves',
  );

  /// Red highlight for attack range tiles.
  static const TileOverlay attackRange = TileOverlay(
    color: Color(0xFFF44336),
    opacity: 0.4,
    group: 'attackRange',
  );

  /// Purple highlight for ability target tiles.
  static const TileOverlay abilityTarget = TileOverlay(
    color: Color(0xFF9C27B0),
    opacity: 0.3,
    group: 'abilityTarget',
  );

  /// Yellow highlight for selected tile.
  static const TileOverlay selection = TileOverlay(
    color: Color(0xFFFFC107),
    opacity: 0.5,
    group: 'selection',
  );

  /// Orange-red highlight for danger zones.
  static const TileOverlay danger = TileOverlay(
    color: Color(0xFFFF5722),
    opacity: 0.3,
    group: 'danger',
  );

  /// Creates a custom overlay style.
  static TileOverlay custom({
    required Color color,
    double opacity = 0.4,
    String? group,
  }) {
    return TileOverlay(color: color, opacity: opacity, group: group);
  }
}
