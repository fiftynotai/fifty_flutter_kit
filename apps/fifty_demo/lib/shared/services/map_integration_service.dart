/// Map Integration Service
///
/// Wraps the fifty_world_engine for use in the demo app.
/// Provides map rendering and entity management.
library;

import 'package:fifty_world_engine/fifty_world_engine.dart';
import 'package:get/get.dart';

/// Service for map integration.
///
/// Manages map controller, entities, and camera.
class MapIntegrationService extends GetxController {
  MapIntegrationService();

  bool _initialized = false;
  FiftyWorldController? _controller;
  final List<FiftyWorldEntity> _entities = [];
  bool _isLoading = false;
  String? _lastError;
  bool _mapLoaded = false;

  // ─────────────────────────────────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────────────────────────────────

  bool get isInitialized => _initialized;
  FiftyWorldController? get controller => _controller;
  List<FiftyWorldEntity> get entities => List.unmodifiable(_entities);
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;
  bool get hasError => _lastError != null;
  bool get hasEntities => _entities.isNotEmpty;
  bool get isMapLoaded => _mapLoaded;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the map service with a controller.
  void initialize(FiftyWorldController controller) {
    _controller = controller;
    _initialized = true;
    update();
  }

  /// Loads map and entities from an asset path.
  ///
  /// This method:
  /// 1. Creates a FiftyWorldController
  /// 2. Registers required assets with FiftyAssetLoader
  /// 3. Loads map JSON using FiftyWorldLoader
  /// 4. Stores entities for later use
  Future<void> loadMapFromAssets(String mapPath) async {
    _isLoading = true;
    _lastError = null;
    update();

    try {
      // Create controller if not already created
      _controller ??= FiftyWorldController();

      // Register FDL assets needed for the demo map
      FiftyAssetLoader.registerAssets([
        // Rooms (FDL)
        'rooms/room_hall.png',
        'rooms/room_study.png',
        'rooms/room_garden.png',
        'rooms/room_throne.png',
        'rooms/room_cellar.png',
        'rooms/room_sanctuary.png',
        // Characters (FDL)
        'characters/hero.png',
        // Creatures (FDL)
        'creatures/stone_sentinel.png',
        // Furniture (FDL)
        'furniture/door.png',
        'furniture/brazier.png',
        'furniture/chest.png',
        'furniture/pedestal.png',
        // Events (engine-expected names)
        'events/basic.png',
        'events/npc.png',
        'events/master_of_shadow.png',
      ]);

      // Load entities from map JSON
      final loadedEntities = await FiftyWorldLoader.loadFromAssets(mapPath);

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
  Future<void> loadEntities(List<FiftyWorldEntity> entities) async {
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
  void addEntity(FiftyWorldEntity entity) {
    _entities.add(entity);
    _controller?.addEntities([entity]);
    update();
  }

  /// Removes an entity from the map.
  void removeEntity(FiftyWorldEntity entity) {
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
  void moveEntity(FiftyWorldEntity entity, double x, double y) {
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
  void focusOnEntity(FiftyWorldEntity entity) {
    _controller?.centerOnEntity(entity);
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Test Entity Management
  // ─────────────────────────────────────────────────────────────────────────

  /// Counter for generating unique test entity IDs.
  int _testEntityCounter = 0;

  /// List of test entities added by the user.
  final List<FiftyWorldEntity> _testEntities = [];

  /// Gets the list of test entities.
  List<FiftyWorldEntity> get testEntities => List.unmodifiable(_testEntities);

  /// Adds a test monster entity at a random grid position.
  void addTestEntity() {
    _testEntityCounter++;
    final entity = FiftyWorldEntity(
      id: 'test_entity_$_testEntityCounter',
      type: FiftyEntityType.monster.value,
      gridPosition: Vector2(
        5.0 + _testEntityCounter,
        5.0 + _testEntityCounter,
      ),
      blockSize: FiftyBlockSize(1, 1),
      asset: 'creatures/stone_sentinel.png',
    );
    _testEntities.add(entity);
    _entities.add(entity);
    _controller?.addEntities([entity]);
    update();
  }

  /// Removes the last test entity added.
  void removeTestEntity() {
    if (_testEntities.isEmpty) return;
    final entity = _testEntities.removeLast();
    _entities.removeWhere((e) => e.id == entity.id);
    _controller?.removeEntity(entity);
    update();
  }

  /// Focuses the camera on the last test entity.
  void focusOnTestEntity() {
    if (_testEntities.isEmpty) return;
    final entity = _testEntities.last;
    _controller?.centerOnEntity(entity);
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Movement Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Movement step size in grid units.
  static const double _moveStep = 1.0;

  /// Moves the last test entity up.
  void moveUp() {
    if (_testEntities.isEmpty) return;
    final entity = _testEntities.last;
    _controller?.moveUp(entity, _moveStep);
    update();
  }

  /// Moves the last test entity down.
  void moveDown() {
    if (_testEntities.isEmpty) return;
    final entity = _testEntities.last;
    _controller?.moveDown(entity, _moveStep);
    update();
  }

  /// Moves the last test entity left.
  void moveLeft() {
    if (_testEntities.isEmpty) return;
    final entity = _testEntities.last;
    _controller?.moveLeft(entity, _moveStep);
    update();
  }

  /// Moves the last test entity right.
  void moveRight() {
    if (_testEntities.isEmpty) return;
    final entity = _testEntities.last;
    _controller?.moveRight(entity, _moveStep);
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Map Reload
  // ─────────────────────────────────────────────────────────────────────────

  /// Reloads the map from the default asset path.
  Future<void> reloadMap() async {
    // Clear test entities
    _testEntities.clear();
    _testEntityCounter = 0;

    // Clear the map
    _controller?.clear();

    // Reload from assets
    await loadMapFromAssets('assets/maps/fdl_demo_map.json');
  }

  /// Refreshes the current map state by re-adding entities.
  void refreshMap() {
    // Re-add all entities to refresh the map
    if (_entities.isNotEmpty) {
      _controller?.addEntities(_entities);
    }
    update();
  }
}
