/// Map Service
///
/// Handles map loading and state management for the map demo feature.
/// Acts as the bridge between the UI layer and the fifty_map_engine package.
library;

import 'package:fifty_map_engine/fifty_map_engine.dart';
import 'package:flutter/foundation.dart';

/// Service for managing map state and operations.
///
/// Provides a reactive interface to map entities and controller state.
/// Uses [ChangeNotifier] to notify listeners of state changes.
class MapService extends ChangeNotifier {
  MapService();

  // ─────────────────────────────────────────────────────────────────────────
  // Map Controller
  // ─────────────────────────────────────────────────────────────────────────

  final FiftyMapController _controller = FiftyMapController();

  /// The map controller for direct map manipulation.
  FiftyMapController get controller => _controller;

  // ─────────────────────────────────────────────────────────────────────────
  // Entities State
  // ─────────────────────────────────────────────────────────────────────────

  List<FiftyMapEntity> _initialEntities = [];

  /// Current list of initial entities loaded into the map.
  List<FiftyMapEntity> get initialEntities => _initialEntities;

  /// Whether entities have been loaded.
  bool get hasEntities => _initialEntities.isNotEmpty;

  // ─────────────────────────────────────────────────────────────────────────
  // Test Entity
  // ─────────────────────────────────────────────────────────────────────────

  /// Example test entity for add/remove/move demonstrations.
  ///
  /// A monster entity with a parent room reference.
  final FiftyMapEntity testEntity = FiftyMapEntity.fromJson(const {
    'parent_id': '4d35059b-a417-46f3-b12a-de8b48e801ce',
    'id': '6e6a60b3-81ae-4a56-bad4-c203874c8a4a',
    'type': 'monster',
    'asset': 'monsters/m-3.png',
    'grid_position': {'x': 1.0, 'y': 1.0},
    'z_index': 0,
    'size': {'width': 1.0, 'height': 1.0},
    'quarter_turns': 0,
    'event': null,
    'components': [],
    'metadata': null,
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Loading State
  // ─────────────────────────────────────────────────────────────────────────

  bool _isLoading = false;

  /// Whether a map load operation is in progress.
  bool get isLoading => _isLoading;

  String? _lastError;

  /// Last error message (if any).
  String? get lastError => _lastError;

  /// Whether there is an error to display.
  bool get hasError => _lastError != null && _lastError!.isNotEmpty;

  // ─────────────────────────────────────────────────────────────────────────
  // Map Loading Operations
  // ─────────────────────────────────────────────────────────────────────────

  /// Loads entities from the default map asset.
  Future<void> loadInitialEntities() async {
    await _loadEntities('assets/maps/example.json');
  }

  /// Loads entities from the updated room asset.
  Future<void> loadUpdatedRoom() async {
    await _loadEntities('assets/maps/updated_room.json');
  }

  Future<void> _loadEntities(String path) async {
    _isLoading = true;
    _lastError = null;
    notifyListeners();

    try {
      final loaded = await FiftyMapLoader.loadFromAssets(path);
      _initialEntities = loaded;
      _controller.addEntities(_initialEntities);
    } catch (e) {
      _lastError = 'Failed to load map: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Entity Operations
  // ─────────────────────────────────────────────────────────────────────────

  /// Adds the test entity to the map.
  void addTestEntity() {
    final newEntity = testEntity.changePosition(gridPosition: Vector2(1, 1));
    _controller.addEntities([newEntity]);
    notifyListeners();
  }

  /// Removes the test entity from the map.
  void removeTestEntity() {
    _controller.removeEntity(testEntity);
    notifyListeners();
  }

  /// Clears all entities from the map.
  void clearAll() {
    _controller.clear();
    _initialEntities = [];
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Movement Operations
  // ─────────────────────────────────────────────────────────────────────────

  /// Moves the test entity up by one grid block.
  void moveUp() {
    _controller.moveUp(testEntity, 1);
  }

  /// Moves the test entity down by one grid block.
  void moveDown() {
    _controller.moveDown(testEntity, 1);
  }

  /// Moves the test entity left by one grid block.
  void moveLeft() {
    _controller.moveLeft(testEntity, 1);
  }

  /// Moves the test entity right by one grid block.
  void moveRight() {
    _controller.moveRight(testEntity, 1);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Camera Operations
  // ─────────────────────────────────────────────────────────────────────────

  /// Zooms the camera in.
  void zoomIn() {
    _controller.zoomIn();
  }

  /// Zooms the camera out.
  void zoomOut() {
    _controller.zoomOut();
  }

  /// Centers the camera on all entities.
  void centerMap() {
    _controller.centerMap();
  }

  /// Centers the camera on the test entity.
  void focusOnTestEntity() {
    _controller.centerOnEntity(testEntity);
  }
}
