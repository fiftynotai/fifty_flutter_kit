import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:fifty_world_engine/fifty_world_engine.dart';

/// Callback for tile tap events.
typedef FiftyTileTapCallback = void Function(GridPosition position);

/// High-level Flutter widget that embeds the interactive Fifty world.
///
/// Supports two modes:
/// - **Legacy mode:** Entities only (rooms, characters, etc.)
/// - **Grid mode:** Tile grid with overlays, tap handling, entities on top
///
/// Usage (grid mode):
/// ```dart
/// FiftyWorldWidget(
///   grid: myGrid,
///   controller: controller,
///   onEntityTap: (entity) => handleEntityTap(entity),
///   onTileTap: (pos) => handleTileTap(pos),
/// )
/// ```
class FiftyWorldWidget extends StatefulWidget {
  /// Initial entities to load into the map.
  final List<FiftyWorldEntity> initialEntities;

  /// Callback for when a map entity is tapped.
  final FiftyWorldTapCallback onEntityTap;

  /// Controller for dynamic map manipulation.
  final FiftyWorldController controller;

  /// Optional tile grid for grid-based games.
  ///
  /// When provided, the map renders a tile grid with overlays.
  /// When null, operates in legacy entity-only mode.
  final TileGrid? grid;

  /// Callback for when any tile is tapped (occupied or empty).
  ///
  /// Only fires in grid mode (when [grid] is provided).
  final FiftyTileTapCallback? onTileTap;

  /// Creates a [FiftyWorldWidget].
  const FiftyWorldWidget({
    super.key,
    this.initialEntities = const [],
    required this.onEntityTap,
    required this.controller,
    this.grid,
    this.onTileTap,
  });

  @override
  State<FiftyWorldWidget> createState() => _FiftyWorldWidgetState();
}

class _FiftyWorldWidgetState extends State<FiftyWorldWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.bind(
      FiftyWorldBuilder(
        initialEntities: widget.initialEntities,
        onEntityTap: widget.onEntityTap,
        grid: widget.grid,
        onTileTap: widget.onTileTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          child: GameWidget(game: widget.controller.game),
        );
      },
    );
  }
}
