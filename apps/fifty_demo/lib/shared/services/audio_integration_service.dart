/// Audio Integration Service
///
/// Wraps the fifty_audio_engine for use in the demo app.
/// Provides a simplified API for audio playback by delegating
/// to the FiftyAudioEngine singleton.
library;

import 'package:audioplayers/audioplayers.dart';
import 'package:fifty_audio_engine/fifty_audio_engine.dart';
import 'package:flutter/foundation.dart';

/// Service for audio integration.
///
/// Manages BGM, SFX, and Voice audio channels by delegating to
/// [FiftyAudioEngine.instance]. This service acts as a thin wrapper
/// that provides ChangeNotifier compatibility for Provider integration.
///
/// **Important:** [FiftyAudioEngine.instance.initialize()] must be called
/// before using this service (typically in main.dart before DI setup).
class AudioIntegrationService extends ChangeNotifier {
  AudioIntegrationService() {
    _configureChannelsForUrlPlayback();
    _setupListeners();
  }

  /// Access to the FiftyAudioEngine singleton.
  FiftyAudioEngine get _engine => FiftyAudioEngine.instance;

  bool _initialized = false;

  // ─────────────────────────────────────────────────────────────────────────
  // Getters (delegate to engine channels)
  // ─────────────────────────────────────────────────────────────────────────

  /// Whether the service is initialized.
  bool get isInitialized => _initialized;

  /// Whether BGM is currently playing.
  bool get bgmPlaying => _engine.bgm.isPlaying;

  /// Whether voice is currently playing.
  bool get voicePlaying => _engine.voice.isPlaying;

  /// Current BGM volume (0.0 to 1.0).
  double get bgmVolume => _engine.bgm.volume;

  /// Current SFX volume (0.0 to 1.0).
  double get sfxVolume => _engine.sfx.volume;

  /// Current voice volume (0.0 to 1.0).
  double get voiceVolume => _engine.voice.volume;

  /// Whether BGM is muted.
  bool get bgmMuted => _engine.bgm.isMuted;

  /// Whether SFX is muted.
  bool get sfxMuted => _engine.sfx.isMuted;

  /// Whether voice is muted.
  bool get voiceMuted => _engine.voice.isMuted;

  // ─────────────────────────────────────────────────────────────────────────
  // Configuration
  // ─────────────────────────────────────────────────────────────────────────

  /// Configures audio channels to use URL sources instead of assets.
  ///
  /// The demo app uses remote URLs for audio playback, so we need to
  /// configure the BGM and SFX channels to resolve paths as UrlSources.
  /// Voice channel already uses UrlSource internally.
  void _configureChannelsForUrlPlayback() {
    _engine.bgm.changeSource(UrlSource.new);
    _engine.sfx.changeSource(UrlSource.new);
  }

  /// Sets up listeners to notify Provider consumers of state changes.
  void _setupListeners() {
    _engine.bgm.onIsPlayingChanged.listen((_) => notifyListeners());
    _engine.voice.onIsPlayingChanged.listen((_) => notifyListeners());
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the audio service.
  ///
  /// This marks the service as ready. The actual engine initialization
  /// should be done in main.dart via [FiftyAudioEngine.instance.initialize()].
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BGM Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Plays BGM from the given URL.
  Future<void> playBgm(String url) async {
    if (!_initialized) return;
    try {
      await _engine.bgm.play(url);
      notifyListeners();
    } catch (e) {
      debugPrint('BGM playback error: $e');
    }
  }

  /// Pauses BGM playback.
  Future<void> pauseBgm() async {
    await _engine.bgm.pause();
    notifyListeners();
  }

  /// Resumes BGM playback.
  Future<void> resumeBgm() async {
    await _engine.bgm.resume();
    notifyListeners();
  }

  /// Stops BGM playback.
  Future<void> stopBgm() async {
    await _engine.bgm.stop();
    notifyListeners();
  }

  /// Sets BGM volume.
  Future<void> setBgmVolume(double volume) async {
    await _engine.bgm.setVolume(volume.clamp(0.0, 1.0));
    notifyListeners();
  }

  /// Toggles BGM mute state.
  Future<void> toggleBgmMute() async {
    if (_engine.bgm.isMuted) {
      await _engine.bgm.unmute();
    } else {
      await _engine.bgm.mute();
    }
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SFX Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Plays a one-shot SFX from the given URL.
  Future<void> playSfx(String url) async {
    if (!_initialized || _engine.sfx.isMuted) return;
    try {
      await _engine.sfx.play(url);
    } catch (e) {
      debugPrint('SFX playback error: $e');
    }
  }

  /// Sets SFX volume.
  void setSfxVolume(double volume) {
    _engine.sfx.setVolume(volume.clamp(0.0, 1.0));
    notifyListeners();
  }

  /// Toggles SFX mute state.
  void toggleSfxMute() {
    if (_engine.sfx.isMuted) {
      _engine.sfx.unmute();
    } else {
      _engine.sfx.mute();
    }
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Voice Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Plays voice audio from the given URL.
  Future<void> playVoice(String url) async {
    if (!_initialized || _engine.voice.isMuted) return;
    try {
      await _engine.voice.playVoice(url);
      notifyListeners();
    } catch (e) {
      debugPrint('Voice playback error: $e');
    }
  }

  /// Stops voice playback.
  Future<void> stopVoice() async {
    await _engine.voice.stop();
    notifyListeners();
  }

  /// Sets voice volume.
  Future<void> setVoiceVolume(double volume) async {
    await _engine.voice.setVolume(volume.clamp(0.0, 1.0));
    notifyListeners();
  }

  /// Toggles voice mute state.
  void toggleVoiceMute() {
    if (_engine.voice.isMuted) {
      _engine.voice.unmute();
    } else {
      _engine.voice.mute();
    }
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Global Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Stops all audio.
  Future<void> stopAll() async {
    await _engine.stopAll();
    notifyListeners();
  }

  /// Mutes all channels.
  Future<void> muteAll() async {
    await _engine.muteAll();
    notifyListeners();
  }

  /// Unmutes all channels.
  Future<void> unmuteAll() async {
    await _engine.unmuteAll();
    notifyListeners();
  }

  @override
  void dispose() {
    // Do NOT dispose the engine singleton - it is shared across the app
    // and managed by main.dart lifecycle.
    super.dispose();
  }
}
