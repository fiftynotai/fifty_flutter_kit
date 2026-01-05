/// Map Demo Actions
///
/// Handles user interactions for the map demo feature.
library;

import '../service/map_audio_coordinator.dart';

/// Actions for the map demo feature.
///
/// Provides map and audio control actions.
class MapDemoActions {
  MapDemoActions({
    required MapAudioCoordinator coordinator,
  }) : _coordinator = coordinator;

  final MapAudioCoordinator _coordinator;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the demo.
  Future<void> onInitialize() async {
    await _coordinator.initialize();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BGM Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when play BGM button is tapped.
  Future<void> onPlayBgmTapped() async {
    await _coordinator.startExplorationBgm();
  }

  /// Called when stop BGM button is tapped.
  Future<void> onStopBgmTapped() async {
    await _coordinator.stopExplorationBgm();
  }

  /// Called when BGM toggle is tapped.
  void onToggleBgm() {
    _coordinator.toggleBgm();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SFX Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when SFX toggle is tapped.
  void onToggleSfx() {
    _coordinator.toggleSfx();
  }

  /// Called to test SFX.
  Future<void> onTestSfxTapped() async {
    await _coordinator.playEntityTapSfx();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Camera Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when zoom in button is tapped.
  void onZoomInTapped() {
    _coordinator.onZoomIn();
  }

  /// Called when zoom out button is tapped.
  void onZoomOutTapped() {
    _coordinator.onZoomOut();
  }

  /// Called when center button is tapped.
  void onCenterTapped() {
    _coordinator.onCenterCamera();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Entity Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when a map entity is tapped.
  Future<void> onEntityTapped(String entityId) async {
    await _coordinator.onEntityTapped(entityId);
  }
}
