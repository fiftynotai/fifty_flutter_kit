/// Actions for the Map Demo feature.
///
/// Handles user interactions and delegates to the map service.
/// Following MVVM + Actions pattern: View -> Actions -> Service.
library;

import 'package:fifty_map_engine/fifty_map_engine.dart';

import '../service/map_service.dart';

/// Actions for map demo interactions.
///
/// Provides a clear separation between UI events and business logic.
class MapActions {
  MapActions({
    required MapService mapService,
  }) : _mapService = mapService;

  final MapService _mapService;

  // ─────────────────────────────────────────────────────────────────────────
  // Loading Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called to load the initial map entities.
  Future<void> onLoadInitialEntities() async {
    await _mapService.loadInitialEntities();
  }

  /// Called to load the updated room.
  Future<void> onLoadUpdatedRoom() async {
    await _mapService.loadUpdatedRoom();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Entity Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when the add entity button is tapped.
  void onAddEntityTapped() {
    _mapService.addTestEntity();
  }

  /// Called when the remove entity button is tapped.
  void onRemoveEntityTapped() {
    _mapService.removeTestEntity();
  }

  /// Called when the clear all button is tapped.
  void onClearAllTapped() {
    _mapService.clearAll();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Movement Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when the move up button is tapped.
  void onMoveUpTapped() {
    _mapService.moveUp();
  }

  /// Called when the move down button is tapped.
  void onMoveDownTapped() {
    _mapService.moveDown();
  }

  /// Called when the move left button is tapped.
  void onMoveLeftTapped() {
    _mapService.moveLeft();
  }

  /// Called when the move right button is tapped.
  void onMoveRightTapped() {
    _mapService.moveRight();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Camera Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when the zoom in button is tapped.
  void onZoomInTapped() {
    _mapService.zoomIn();
  }

  /// Called when the zoom out button is tapped.
  void onZoomOutTapped() {
    _mapService.zoomOut();
  }

  /// Called when the center map button is tapped.
  void onCenterMapTapped() {
    _mapService.centerMap();
  }

  /// Called when the focus on entity button is tapped.
  void onFocusOnEntityTapped() {
    _mapService.focusOnTestEntity();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Entity Tap Handler
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when a map entity is tapped.
  void onEntityTapped(FiftyMapEntity entity) {
    if (entity.event != null && entity.event!.clicked) {
      print('Event Tapped: ${entity.id} (${entity.event!.text})');
    } else {
      print('Entity Tapped: ${entity.id} (${entity.type})');
    }
  }
}
