/// Map Demo ViewModel
///
/// Business logic for the map demo feature.
library;

import 'package:fifty_map_engine/fifty_map_engine.dart';
import 'package:get/get.dart';

import '../service/map_audio_coordinator.dart';

/// ViewModel for the map demo feature.
///
/// Exposes map and audio state for the view.
class MapDemoViewModel extends GetxController {
  MapDemoViewModel({
    required MapAudioCoordinator coordinator,
  }) : _coordinator = coordinator;

  final MapAudioCoordinator _coordinator;

  /// Worker subscription for coordinator changes.
  Worker? _coordinatorWorker;

  @override
  void onInit() {
    super.onInit();
    // Listen to coordinator changes
    _coordinatorWorker = ever(_coordinator.obs, (_) => update());
  }

  @override
  void onClose() {
    _coordinatorWorker?.dispose();
    super.onClose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────────────────────────────────

  MapAudioCoordinator get coordinator => _coordinator;
  bool get bgmEnabled => _coordinator.bgmEnabled;
  bool get sfxEnabled => _coordinator.sfxEnabled;
  bool get bgmPlaying => _coordinator.bgmPlaying;

  /// Audio engine is always initialized in main.dart before UI loads.
  bool get isInitialized => true;

  /// Map controller for FiftyMapWidget.
  FiftyMapController? get controller => _coordinator.mapService.controller;

  /// Whether the map has been loaded from assets.
  bool get isMapLoaded => _coordinator.mapService.isMapLoaded;

  /// Whether the map is currently loading.
  bool get isMapLoading => _coordinator.mapService.isLoading;

  /// Map entities for initial load.
  List<FiftyMapEntity> get entities => _coordinator.mapService.entities;

  // ─────────────────────────────────────────────────────────────────────────
  // Status Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Status label for audio.
  String get audioStatusLabel {
    if (!isInitialized) return 'INITIALIZING';
    if (bgmPlaying) return 'PLAYING';
    return 'READY';
  }

  /// Status label for map.
  String get mapStatusLabel {
    if (_coordinator.mapService.isLoading) return 'LOADING';
    if (_coordinator.mapService.isMapLoaded) return 'READY';
    if (_coordinator.mapService.hasEntities) return 'READY';
    return 'EMPTY';
  }
}
