/// Audio Integration Service
///
/// Wraps the fifty_audio_engine for use in the demo app.
/// Provides a simplified API for audio playback while delegating
/// to FiftyAudioEngine.instance for actual audio operations.
library;

import 'dart:async';

import 'package:fifty_audio_engine/fifty_audio_engine.dart';
import 'package:flutter/foundation.dart';

/// Service for audio integration.
///
/// Manages BGM, SFX, and Voice audio channels by delegating to
/// FiftyAudioEngine singleton. Preserves the same public API for
/// backward compatibility with existing demo app code.
///
/// **Note:** Engine initialization happens in main.dart before DI setup.
/// Channels are pre-configured for URL-based playback (not assets).
class AudioIntegrationService extends ChangeNotifier {
  AudioIntegrationService();

  /// Access the FiftyAudioEngine singleton.
  FiftyAudioEngine get _engine => FiftyAudioEngine.instance;

  bool _initialized = false;
  bool _bgmMuted = false;
  bool _sfxMuted = false;
  bool _voiceMuted = false;
  double _bgmVolume = 0.7;
  double _sfxVolume = 0.8;
  double _voiceVolume = 0.9;

  StreamSubscription<bool>? _bgmPlayingSub;
  StreamSubscription<bool>? _voicePlayingSub;

  // ─────────────────────────────────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────────────────────────────────

  bool get isInitialized => _initialized;
  bool get bgmPlaying => _engine.bgm.isPlaying;
  bool get voicePlaying => _engine.voice.isPlaying;
  double get bgmVolume => _bgmVolume;
  double get sfxVolume => _sfxVolume;
  double get voiceVolume => _voiceVolume;
  bool get bgmMuted => _bgmMuted;
  bool get sfxMuted => _sfxMuted;
  bool get voiceMuted => _voiceMuted;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the audio service.
  ///
  /// Engine initialization happens in main.dart. This method sets up
  /// state listeners and applies initial volume levels.
  Future<void> initialize() async {
    if (_initialized) return;

    // Subscribe to playing state changes for notifications
    _bgmPlayingSub = _engine.bgm.onIsPlayingChanged.listen((_) {
      notifyListeners();
    });

    _voicePlayingSub = _engine.voice.onIsPlayingChanged.listen((_) {
      notifyListeners();
    });

    // Apply initial volumes
    await _engine.bgm.setVolume(_bgmVolume);
    await _engine.sfx.setVolume(_sfxVolume);
    await _engine.voice.setVolume(_voiceVolume);

    _initialized = true;
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BGM Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Plays BGM from the given URL.
  Future<void> playBgm(String url) async {
    if (!_initialized || _bgmMuted) return;
    try {
      await _engine.bgm.setVolume(_bgmVolume);
      await _engine.bgm.play(url);
    } catch (e) {
      debugPrint('BGM playback error: $e');
    }
  }

  /// Pauses BGM playback.
  Future<void> pauseBgm() async {
    await _engine.bgm.pause();
  }

  /// Resumes BGM playback.
  Future<void> resumeBgm() async {
    await _engine.bgm.resume();
  }

  /// Stops BGM playback.
  Future<void> stopBgm() async {
    await _engine.bgm.stop();
    notifyListeners();
  }

  /// Sets BGM volume.
  Future<void> setBgmVolume(double volume) async {
    _bgmVolume = volume.clamp(0.0, 1.0);
    if (!_bgmMuted) {
      await _engine.bgm.setVolume(_bgmVolume);
    }
    notifyListeners();
  }

  /// Toggles BGM mute state.
  Future<void> toggleBgmMute() async {
    _bgmMuted = !_bgmMuted;
    if (_bgmMuted) {
      await _engine.bgm.mute();
    } else {
      await _engine.bgm.setVolume(_bgmVolume);
    }
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SFX Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Plays a one-shot SFX from the given URL.
  Future<void> playSfx(String url) async {
    if (!_initialized || _sfxMuted) return;
    try {
      await _engine.sfx.setVolume(_sfxVolume);
      await _engine.sfx.play(url);
    } catch (e) {
      debugPrint('SFX playback error: $e');
    }
  }

  /// Sets SFX volume.
  void setSfxVolume(double volume) {
    _sfxVolume = volume.clamp(0.0, 1.0);
    _engine.sfx.setVolume(_sfxVolume);
    notifyListeners();
  }

  /// Toggles SFX mute state.
  void toggleSfxMute() {
    _sfxMuted = !_sfxMuted;
    if (_sfxMuted) {
      _engine.sfx.mute();
    } else {
      _engine.sfx.setVolume(_sfxVolume);
    }
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Voice Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Plays voice audio from the given URL.
  Future<void> playVoice(String url) async {
    if (!_initialized || _voiceMuted) return;
    try {
      await _engine.voice.setVolume(_voiceVolume);
      await _engine.voice.playVoice(url);
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
    _voiceVolume = volume.clamp(0.0, 1.0);
    await _engine.voice.setVolume(_voiceVolume);
    notifyListeners();
  }

  /// Toggles voice mute state.
  void toggleVoiceMute() {
    _voiceMuted = !_voiceMuted;
    if (_voiceMuted) {
      _engine.voice.mute();
    } else {
      _engine.voice.setVolume(_voiceVolume);
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
  void muteAll() {
    _bgmMuted = true;
    _sfxMuted = true;
    _voiceMuted = true;
    _engine.muteAll();
    notifyListeners();
  }

  /// Unmutes all channels.
  void unmuteAll() {
    _bgmMuted = false;
    _sfxMuted = false;
    _voiceMuted = false;
    _engine.unmuteAll();
    notifyListeners();
  }

  @override
  void dispose() {
    _bgmPlayingSub?.cancel();
    _voicePlayingSub?.cancel();
    super.dispose();
  }
}
