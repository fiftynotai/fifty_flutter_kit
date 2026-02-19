import 'dart:ui' show Color;

/// Defines properties of a tile type.
///
/// Each tile on the grid has a [TileType] that determines its appearance
/// and game properties (walkability, movement cost).
class TileType {
  /// Unique identifier (e.g., 'grass', 'water', 'wall').
  final String id;

  /// Sprite asset path. If null, [color] is used as fallback.
  final String? asset;

  /// Solid fill color. Used when [asset] is null.
  final Color? color;

  /// Whether entities can traverse this tile.
  final bool walkable;

  /// Movement cost for pathfinding (default 1.0). Higher = harder to traverse.
  final double movementCost;

  /// Arbitrary game-specific metadata.
  final Map<String, dynamic>? metadata;

  /// Creates a [TileType] with the given properties.
  ///
  /// At minimum, an [id] is required. Provide either [asset] for sprite-based
  /// rendering or [color] for solid-fill rendering.
  const TileType({
    required this.id,
    this.asset,
    this.color,
    this.walkable = true,
    this.movementCost = 1.0,
    this.metadata,
  });

  @override
  bool operator ==(Object other) => other is TileType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'TileType($id)';
}
