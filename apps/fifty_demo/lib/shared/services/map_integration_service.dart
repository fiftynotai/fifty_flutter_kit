/// Map Integration Service
///
/// Wraps the fifty_map_engine for use in the demo app.
/// Provides map rendering and entity management.
library;

import 'package:fifty_map_engine/fifty_map_engine.dart';
import 'package:get/get.dart';

/// Service for map integration.
///
/// Manages map controller, entities, and camera.
class MapIntegrationService extends GetxController {
  MapIntegrationService();

  bool _initialized = false;
  FiftyMapController? _controller;
  final List<FiftyMapEntity> _entities = [];
  bool _isLoading = false;
  String? _lastError;
  bool _mapLoaded = false;

  // ─────────────────────────────────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────────────────────────────────

  bool get isInitialized => _initialized;
  FiftyMapController? get controller => _controller;
  List<FiftyMapEntity> get entities => List.unmodifiable(_entities);
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;
  bool get hasError => _lastError != null;
  bool get hasEntities => _entities.isNotEmpty;
  bool get isMapLoaded => _mapLoaded;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the map service with a controller.
  void initialize(FiftyMapController controller) {
    _controller = controller;
    _initialized = true;
    update();
  }

  /// Loads map and entities from an asset path.
  ///
  /// This method:
  /// 1. Creates a FiftyMapController
  /// 2. Registers required assets with FiftyAssetLoader
  /// 3. Loads map JSON using FiftyMapLoader
  /// 4. Stores entities for later use
  Future<void> loadMapFromAssets(String mapPath) async {
    _isLoading = true;
    _lastError = null;
    update();

    try {
      // Create controller if not already created
      _controller ??= FiftyMapController();

      // Register assets needed for the demo map
      FiftyAssetLoader.registerAssets([
        // Rooms
        'rooms/small_room.png',
        'rooms/medium_room.png',
        'rooms/large_room.jpg',
        'rooms/corridor_room.jpg',
        // Furniture
        'furniture/door.png',
        'furniture/box.png',
        'furniture/table.png',
        'furniture/token.png',
        // Monsters
        'monsters/m-1.png',
        'monsters/m-2.png',
        'monsters/m-3.png',
        'monsters/m-4.png',
        // Characters
        'characters/adventurer.png',
      ]);

      // Load entities from map JSON
      final loadedEntities = await FiftyMapLoader.loadFromAssets(mapPath);

      // Store entities
      _entities
        ..clear()
        ..addAll(loadedEntities);

      _mapLoaded = true;
      _isLoading = false;
      _initialized = true;
    } catch (e) {
      _lastError = e.toString();
      _isLoading = false;
      _mapLoaded = false;
    }

    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Entity Management
  // ─────────────────────────────────────────────────────────────────────────

  /// Loads initial entities into the map.
  Future<void> loadEntities(List<FiftyMapEntity> entities) async {
    _isLoading = true;
    _lastError = null;
    update();

    try {
      _entities
        ..clear()
        ..addAll(entities);
      _controller?.addEntities(entities);
      _isLoading = false;
    } catch (e) {
      _lastError = e.toString();
      _isLoading = false;
    }

    update();
  }

  /// Adds an entity to the map.
  void addEntity(FiftyMapEntity entity) {
    _entities.add(entity);
    _controller?.addEntities([entity]);
    update();
  }

  /// Removes an entity from the map.
  void removeEntity(FiftyMapEntity entity) {
    _entities.removeWhere((e) => e.id == entity.id);
    _controller?.removeEntity(entity);
    update();
  }

  /// Clears all entities from the map.
  void clearEntities() {
    _entities.clear();
    _controller?.clear();
    update();
  }

  /// Moves an entity to a new position.
  void moveEntity(FiftyMapEntity entity, double x, double y) {
    _controller?.move(entity, x, y);
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Camera Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Zooms the camera in.
  void zoomIn() {
    _controller?.zoomIn();
    update();
  }

  /// Zooms the camera out.
  void zoomOut() {
    _controller?.zoomOut();
    update();
  }

  /// Centers the camera on the map.
  void centerCamera() {
    _controller?.centerMap();
    update();
  }

  /// Focuses the camera on a specific entity.
  void focusOnEntity(FiftyMapEntity entity) {
    _controller?.centerOnEntity(entity);
    update();
  }
}
