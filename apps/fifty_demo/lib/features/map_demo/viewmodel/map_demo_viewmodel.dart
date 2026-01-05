/// Map Demo ViewModel
///
/// Business logic for the map demo feature.
library;

import 'package:flutter/foundation.dart';

import '../service/map_audio_coordinator.dart';

/// ViewModel for the map demo feature.
///
/// Exposes map and audio state for the view.
class MapDemoViewModel extends ChangeNotifier {
  MapDemoViewModel({
    required MapAudioCoordinator coordinator,
  }) : _coordinator = coordinator {
    _coordinator.addListener(_onCoordinatorChanged);
  }

  final MapAudioCoordinator _coordinator;

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

  // ─────────────────────────────────────────────────────────────────────────
  // Listener
  // ─────────────────────────────────────────────────────────────────────────

  void _onCoordinatorChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _coordinator.removeListener(_onCoordinatorChanged);
    super.dispose();
  }
}
