/// Map Audio Coordinator Service
///
/// Coordinates map engine with audio engine for integrated experience.
library;

import 'dart:async';

import 'package:fifty_audio_engine/fifty_audio_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../shared/services/map_integration_service.dart';

/// Coordinates map interactions with audio playback.
///
/// Uses FiftyAudioEngine directly for seamless integration with the
/// Fifty Flutter Kit audio system. Shares playlist state with other
/// features using the same engine singleton.
class MapAudioCoordinator extends GetxController {
  MapAudioCoordinator({
    required MapIntegrationService mapService,
  }) : _mapService = mapService;

  /// Direct access to the audio engine singleton.
  FiftyAudioEngine get _engine => FiftyAudioEngine.instance;

  final MapIntegrationService _mapService;

  bool _bgmEnabled = true;
  bool _sfxEnabled = true;

  /// Subscription to BGM playing state changes for reactive UI updates.
  StreamSubscription<bool>? _bgmPlayingSubscription;

  // ─────────────────────────────────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────────────────────────────────

  bool get bgmEnabled => _bgmEnabled;
  bool get sfxEnabled => _sfxEnabled;
  bool get bgmPlaying => _engine.bgm.isPlaying;
  MapIntegrationService get mapService => _mapService;

  // Local SFX assets (AssetSource prepends 'assets/' automatically)
  static const Map<String, String> sfxSounds = {
    'click': 'audio/sfx/click.mp3',
    'hover': 'audio/sfx/hover.mp3',
    'select': 'audio/sfx/select.mp3',
  };

  // Default BGM playlist (shared with Audio Demo)
  static const List<String> _defaultBgmPlaylist = [
    'audio/bgm/clockwork_grove.mp3',
    'audio/bgm/clockwork_grove_alt.mp3',
    'audio/bgm/path_of_first_light.mp3',
    'audio/bgm/path_of_first_light_alt.mp3',
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the coordinator and loads map from assets.
  ///
  /// Note: FiftyAudioEngine is initialized in main.dart before DI setup.
  /// Ensures the default BGM playlist is loaded so play works even if
  /// Audio Demo was never visited.
  Future<void> initialize() async {
    // Subscribe to BGM playing state for reactive UI updates
    _bgmPlayingSubscription = _engine.bgm.onIsPlayingChanged.listen((_) {
      update();
    });

    // Ensure default playlist is loaded (idempotent - safe to call multiple times)
    await _engine.bgm.loadDefaultPlaylist(_defaultBgmPlaylist);

    // Load map from assets
    try {
      await _mapService.loadMapFromAssets('assets/maps/fdl_demo_map.json');
    } catch (e) {
      // Log error but continue - audio still works without map
      if (kDebugMode) {
        debugPrint('[MapAudioCoordinator] Failed to load map: $e');
      }
    }

    update();
  }

  @override
  void onClose() {
    _bgmPlayingSubscription?.cancel();
    super.onClose();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BGM Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Pauses currently playing BGM (from playlist).
  Future<void> pauseBgm() async {
    await _engine.bgm.pause();
    update();
  }

  /// Resumes or starts BGM playback from playlist.
  ///
  /// Uses [resumeDefaultPlaylist] which works whether audio was paused
  /// or never started. This ensures the play button works regardless
  /// of whether the user visited Audio Demo first.
  Future<void> resumeBgm() async {
    if (!_bgmEnabled) return;
    await _engine.bgm.resumeDefaultPlaylist();
    update();
  }

  /// Toggles BGM on/off.
  void toggleBgm() {
    _bgmEnabled = !_bgmEnabled;
    if (!_bgmEnabled && _engine.bgm.isPlaying) {
      _engine.bgm.pause();
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
    await _engine.sfx.play(path);
  }

  /// Plays entity hover SFX.
  Future<void> playEntityHoverSfx() async {
    if (!_sfxEnabled) return;
    final path = sfxSounds['hover']!;
    await _engine.sfx.play(path);
  }

  /// Plays selection SFX.
  Future<void> playSelectSfx() async {
    if (!_sfxEnabled) return;
    final path = sfxSounds['select']!;
    await _engine.sfx.play(path);
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

  // ─────────────────────────────────────────────────────────────────────────
  // Entity Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Adds a test entity to the map.
  void onAddEntity() {
    _mapService.addTestEntity();
    update();
  }

  /// Removes the last test entity from the map.
  void onRemoveEntity() {
    _mapService.removeTestEntity();
    update();
  }

  /// Focuses camera on the last test entity.
  void onFocusEntity() {
    _mapService.focusOnTestEntity();
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Map Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Refreshes the map display.
  void onRefresh() {
    _mapService.refreshMap();
    update();
  }

  /// Reloads the map from JSON.
  Future<void> onReload() async {
    await _mapService.reloadMap();
    update();
  }

  /// Clears all entities from the map.
  void onClear() {
    _mapService.clearEntities();
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Movement Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Moves the selected entity up.
  void onMoveUp() {
    _mapService.moveUp();
    update();
  }

  /// Moves the selected entity down.
  void onMoveDown() {
    _mapService.moveDown();
    update();
  }

  /// Moves the selected entity left.
  void onMoveLeft() {
    _mapService.moveLeft();
    update();
  }

  /// Moves the selected entity right.
  void onMoveRight() {
    _mapService.moveRight();
    update();
  }
}
