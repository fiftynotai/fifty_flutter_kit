import 'package:flame/components.dart';

import '../../grid/grid_position.dart';
import '../../grid/tile_overlay.dart';
import '../../config/map_config.dart';
import 'tile_overlay_component.dart';

/// Manages tile overlay components for batch operations (internal).
///
/// Tracks overlays by position and group for efficient add/remove/clear.
/// Each grid position can hold multiple overlays (e.g., a selection overlay
/// stacked on a valid-move overlay).
///
/// This class is internal to the engine. Public overlay operations will be
/// exposed through the controller API.
class OverlayManager {
  /// All active overlay components, keyed by grid position.
  final Map<GridPosition, List<TileOverlayComponent>> _overlays = {};

  /// Tile size for positioning.
  final double tileSize;

  /// Creates an [OverlayManager] with the given [tileSize].
  OverlayManager({this.tileSize = FiftyMapConfig.blockSize});

  /// Adds an overlay at [pos] to [parent].
  ///
  /// Multiple overlays can be stacked on the same position.
  void addOverlay(GridPosition pos, TileOverlay overlay, Component parent) {
    final component = TileOverlayComponent(
      gridPos: pos,
      overlay: overlay,
      tileSize: tileSize,
    );
    _overlays.putIfAbsent(pos, () => []).add(component);
    parent.add(component);
  }

  /// Adds overlays at multiple [positions] to [parent].
  ///
  /// Convenience method for batch highlighting (e.g., all valid move tiles).
  void addOverlays(
    List<GridPosition> positions,
    TileOverlay overlay,
    Component parent,
  ) {
    for (final pos in positions) {
      addOverlay(pos, overlay, parent);
    }
  }

  /// Removes all overlays at [pos].
  void removeOverlaysAt(GridPosition pos) {
    final components = _overlays.remove(pos);
    if (components != null) {
      for (final c in components) {
        c.removeFromParent();
      }
    }
  }

  /// Removes all overlays belonging to [group].
  ///
  /// This is the primary way to clear a category of highlights
  /// (e.g., clearing all 'validMoves' overlays when a unit is deselected).
  void clearGroup(String group) {
    final toRemove = <GridPosition>[];
    _overlays.forEach((pos, components) {
      components.removeWhere((c) {
        if (c.overlay.group == group) {
          c.removeFromParent();
          return true;
        }
        return false;
      });
      if (components.isEmpty) toRemove.add(pos);
    });
    for (final pos in toRemove) {
      _overlays.remove(pos);
    }
  }

  /// Removes ALL overlays.
  void clearAll() {
    _overlays.forEach((_, components) {
      for (final c in components) {
        c.removeFromParent();
      }
    });
    _overlays.clear();
  }

  /// Number of positions with at least one overlay.
  int get positionCount => _overlays.length;

  /// Total number of overlay components across all positions.
  int get overlayCount =>
      _overlays.values.fold(0, (sum, list) => sum + list.length);

  /// Whether any overlays are active.
  bool get isEmpty => _overlays.isEmpty;
}
