/// Map Demo ViewModel
///
/// Business logic for the map demo feature.
library;

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

  @override
  void onInit() {
    super.onInit();
    // Listen to coordinator changes
    ever(_coordinator.obs, (_) => update());
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────────────────────────────────

  MapAudioCoordinator get coordinator => _coordinator;
  bool get bgmEnabled => _coordinator.bgmEnabled;
  bool get sfxEnabled => _coordinator.sfxEnabled;
  bool get bgmPlaying => _coordinator.bgmPlaying;
  bool get isInitialized => _coordinator.audioService.isInitialized;

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
    if (_coordinator.mapService.hasEntities) return 'READY';
    return 'EMPTY';
  }

  /// Refresh state from coordinator.
  @override
  void refresh() {
    update();
  }
}
