/// Fifty Map Engine - Flame-based interactive grid map rendering for Flutter games
///
/// This package provides a complete map engine solution for building
/// tile-based games with the Flame game engine.
///
/// ## Core Components
///
/// - [FiftyMapController] - UI-friendly facade for map manipulation
/// - [FiftyMapBuilder] - FlameGame implementation with pan/zoom
/// - [FiftyMapWidget] - Flutter widget embedding the map
/// - [FiftyMapEntity] - Data model for map entities
///
/// ## Entity Components
///
/// - [FiftyBaseComponent] - Abstract base for all entities
/// - [FiftyStaticComponent] - Static entities (furniture, doors)
/// - [FiftyMovableComponent] - Movable entities (characters, monsters)
/// - [FiftyRoomComponent] - Room containers with children
/// - [FiftyEventComponent] - Event markers and overlays
/// - [FiftyTextComponent] - Text overlays
///
/// ## Services
///
/// - [FiftyAssetLoader] - Asset registration and loading
/// - [FiftyMapLoader] - Map JSON loading and serialization
/// - [FiftyMapLogger] - Centralized logging
///
/// ## Usage Example
///
/// ```dart
/// // Register assets first
/// FiftyAssetLoader.registerAssets([
///   'rooms/room1.png',
///   'characters/hero.png',
/// ]);
///
/// // Create controller and widget
/// final controller = FiftyMapController();
/// FiftyMapWidget(
///   controller: controller,
///   initialEntities: myEntities,
///   onEntityTap: (entity) => print('Tapped: ${entity.id}'),
/// );
/// ```
library;

// Config
export 'src/config/map_config.dart';

// Models
export 'src/components/base/model.dart';
export 'src/components/base/extension.dart';
export 'src/components/base/priority.dart';

// Components
export 'src/components/base/component.dart';
export 'src/components/base/spawner.dart';
export 'src/components/room_component.dart';
export 'src/components/event_component.dart';
export 'src/components/text_component.dart';

// Controller
export 'src/controller/controller.dart';

// View
export 'src/view/map_builder.dart';
export 'src/view/widget.dart';

// Services
export 'src/services/asset_loader_service.dart';
export 'src/services/map_loader_service.dart';

// Utils
export 'src/utils/logger.dart';
export 'src/utils/utils.dart';

// Re-export commonly used Flame types
export 'package:flame/components.dart' show Vector2;
