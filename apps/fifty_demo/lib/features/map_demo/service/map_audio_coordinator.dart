/// Map Audio Coordinator Service
///
/// Coordinates map engine with audio engine for integrated experience.
library;

import 'package:flutter/foundation.dart';

import '../../../shared/services/audio_integration_service.dart';
import '../../../shared/services/map_integration_service.dart';

/// Coordinates map interactions with audio playback.
///
/// Plays BGM during exploration and SFX on entity interactions.
class MapAudioCoordinator extends ChangeNotifier {
  MapAudioCoordinator({
    required AudioIntegrationService audioService,
    required MapIntegrationService mapService,
  })  : _audioService = audioService,
        _mapService = mapService;

  final AudioIntegrationService _audioService;
  final MapIntegrationService _mapService;

  bool _bgmEnabled = true;
  bool _sfxEnabled = true;

  // ─────────────────────────────────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────────────────────────────────

  bool get bgmEnabled => _bgmEnabled;
  bool get sfxEnabled => _sfxEnabled;
  bool get bgmPlaying => _audioService.bgmPlaying;
  AudioIntegrationService get audioService => _audioService;
  MapIntegrationService get mapService => _mapService;

  // Sample BGM tracks for demo
  static const List<String> bgmTracks = [
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
  ];

  // SFX disabled - external URLs unreliable for demo
  // To enable SFX, add local audio files to assets/audio/sfx/
  // and update these paths to 'assets/audio/sfx/click.mp3', etc.
  static const Map<String, String?> sfxSounds = {
    'click': null, // Disabled - was blocking hotlink
    'hover': null,
    'select': null,
  };

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the coordinator and audio service.
  Future<void> initialize() async {
    await _audioService.initialize();
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BGM Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Starts exploration BGM.
  Future<void> startExplorationBgm({int trackIndex = 0}) async {
    if (!_bgmEnabled) return;
    final url = bgmTracks[trackIndex % bgmTracks.length];
    await _audioService.playBgm(url);
    notifyListeners();
  }

  /// Stops exploration BGM.
  Future<void> stopExplorationBgm() async {
    await _audioService.stopBgm();
    notifyListeners();
  }

  /// Toggles BGM on/off.
  void toggleBgm() {
    _bgmEnabled = !_bgmEnabled;
    if (!_bgmEnabled && _audioService.bgmPlaying) {
      _audioService.stopBgm();
    }
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SFX Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Plays entity tap SFX.
  Future<void> playEntityTapSfx() async {
    if (!_sfxEnabled) return;
    final url = sfxSounds['click'];
    if (url != null) {
      await _audioService.playSfx(url);
    }
  }

  /// Plays entity hover SFX.
  Future<void> playEntityHoverSfx() async {
    if (!_sfxEnabled) return;
    final url = sfxSounds['hover'];
    if (url != null) {
      await _audioService.playSfx(url);
    }
  }

  /// Plays selection SFX.
  Future<void> playSelectSfx() async {
    if (!_sfxEnabled) return;
    final url = sfxSounds['select'];
    if (url != null) {
      await _audioService.playSfx(url);
    }
  }

  /// Toggles SFX on/off.
  void toggleSfx() {
    _sfxEnabled = !_sfxEnabled;
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Map Integration
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when an entity is tapped on the map.
  Future<void> onEntityTapped(String entityId) async {
    await playEntityTapSfx();
    // Focus on entity would require the full FiftyMapEntity
    // For demo, we just play the SFX
    notifyListeners();
  }

  /// Called when camera zooms.
  void onZoomIn() {
    _mapService.zoomIn();
    notifyListeners();
  }

  /// Called when camera zooms out.
  void onZoomOut() {
    _mapService.zoomOut();
    notifyListeners();
  }

  /// Centers the camera.
  void onCenterCamera() {
    _mapService.centerCamera();
    notifyListeners();
  }
}
