/// Fifty World Engine - Grid game toolkit for Flutter/Flame
///
/// Provides tile grids, overlays, entity decorators, input handling,
/// animation queues, sprite animation, and A* pathfinding.
///
/// ## Quick Start
///
/// ```dart
/// final grid = TileGrid(width: 8, height: 8);
/// grid.fill(TileType(id: 'grass', walkable: true));
///
/// final controller = FiftyWorldController();
/// FiftyWorldWidget(
///   grid: grid,
///   controller: controller,
///   onEntityTap: (entity) => print(entity.id),
///   onTileTap: (pos) => print(pos),
/// );
/// ```
library;

// Config
export 'src/config/world_config.dart';

// Grid (PUBLIC)
export 'src/grid/grid_position.dart';
export 'src/grid/tile_type.dart';
export 'src/grid/tile_grid.dart';
export 'src/grid/tile_overlay.dart';

// Models
export 'src/components/base/model.dart';
export 'src/components/base/extension.dart';
export 'src/components/base/priority.dart';

// Components (legacy)
export 'src/components/base/component.dart';
export 'src/components/base/spawner.dart';
export 'src/components/room_component.dart';
export 'src/components/event_component.dart';
export 'src/components/text_component.dart';

// Controller
export 'src/controller/controller.dart';

// View
export 'src/view/world_builder.dart';
export 'src/view/widget.dart';

// Services
export 'src/services/asset_loader_service.dart';
export 'src/services/world_loader_service.dart';

// Utils
export 'src/utils/logger.dart';
export 'src/utils/utils.dart';

// Animation (PUBLIC)
export 'src/animation/animation_queue.dart';
export 'src/animation/sprite_animation_config.dart';

// Pathfinding (PUBLIC)
export 'src/pathfinding/grid_graph.dart';
export 'src/pathfinding/pathfinder.dart';
export 'src/pathfinding/movement_range.dart';

// Input (PUBLIC - InputManager)
export 'src/input/input_manager.dart';

// Re-export commonly used Flame types (deprecated - use GridPosition instead)
@Deprecated('Use GridPosition instead of Vector2 for grid coordinates. '
    'Vector2 will be removed in the next major version.')
export 'package:flame/components.dart' show Vector2;
