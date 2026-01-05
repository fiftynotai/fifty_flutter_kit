/// Map Audio Coordinator Service
///
/// Coordinates map engine with audio engine for integrated experience.
library;

import 'package:get/get.dart';

import '../../../shared/services/audio_integration_service.dart';
import '../../../shared/services/map_integration_service.dart';

/// Coordinates map interactions with audio playback.
///
/// Plays BGM during exploration and SFX on entity interactions.
class MapAudioCoordinator extends GetxController {
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

  // Local SFX assets (AssetSource prepends 'assets/' automatically)
  static const Map<String, String> sfxSounds = {
    'click': 'audio/sfx/click.mp3',
    'hover': 'audio/sfx/hover.mp3',
    'select': 'audio/sfx/select.mp3',
  };

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the coordinator, audio service, and loads map from assets.
  Future<void> initialize() async {
    await _audioService.initialize();

    // Load map from assets
    try {
      await _mapService.loadMapFromAssets('assets/maps/demo_map.json');
    } catch (e) {
      // Log error but continue - audio still works without map
      // ignore: avoid_print
      print('[MapAudioCoordinator] Failed to load map: $e');
    }

    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BGM Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Starts exploration BGM.
  Future<void> startExplorationBgm({int trackIndex = 0}) async {
    if (!_bgmEnabled) return;
    final url = bgmTracks[trackIndex % bgmTracks.length];
    await _audioService.playBgm(url);
    update();
  }

  /// Stops exploration BGM.
  Future<void> stopExplorationBgm() async {
    await _audioService.stopBgm();
    update();
  }

  /// Toggles BGM on/off.
  void toggleBgm() {
    _bgmEnabled = !_bgmEnabled;
    if (!_bgmEnabled && _audioService.bgmPlaying) {
      _audioService.stopBgm();
    }
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SFX Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Plays entity tap SFX.
  Future<void> playEntityTapSfx() async {
    if (!_sfxEnabled) return;
    final path = sfxSounds['click']!;
    await _audioService.playSfx(path);
  }

  /// Plays entity hover SFX.
  Future<void> playEntityHoverSfx() async {
    if (!_sfxEnabled) return;
    final path = sfxSounds['hover']!;
    await _audioService.playSfx(path);
  }

  /// Plays selection SFX.
  Future<void> playSelectSfx() async {
    if (!_sfxEnabled) return;
    final path = sfxSounds['select']!;
    await _audioService.playSfx(path);
  }

  /// Toggles SFX on/off.
  void toggleSfx() {
    _sfxEnabled = !_sfxEnabled;
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Map Integration
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when an entity is tapped on the map.
  Future<void> onEntityTapped(String entityId) async {
    await playEntityTapSfx();
    // Focus on entity would require the full FiftyMapEntity
    // For demo, we just play the SFX
    update();
  }

  /// Called when camera zooms.
  void onZoomIn() {
    _mapService.zoomIn();
    update();
  }

  /// Called when camera zooms out.
  void onZoomOut() {
    _mapService.zoomOut();
    update();
  }

  /// Centers the camera.
  void onCenterCamera() {
    _mapService.centerCamera();
    update();
  }
}
