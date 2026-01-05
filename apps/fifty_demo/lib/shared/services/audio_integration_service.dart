/// Audio Integration Service
///
/// Wraps the fifty_audio_engine for use in the demo app.
/// Provides a simplified API for audio playback.
library;

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Service for audio integration.
///
/// Manages BGM, SFX, and Voice audio channels.
class AudioIntegrationService extends ChangeNotifier {
  AudioIntegrationService();

  // Audio players
  AudioPlayer? _bgmPlayer;
  AudioPlayer? _sfxPlayer;
  AudioPlayer? _voicePlayer;

  bool _initialized = false;
  bool _bgmPlaying = false;
  bool _voicePlaying = false;
  double _bgmVolume = 0.7;
  double _sfxVolume = 0.8;
  double _voiceVolume = 0.9;
  bool _bgmMuted = false;
  bool _sfxMuted = false;
  bool _voiceMuted = false;

  StreamSubscription<PlayerState>? _bgmStateSub;
  StreamSubscription<PlayerState>? _voiceStateSub;

  // ─────────────────────────────────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────────────────────────────────

  bool get isInitialized => _initialized;
  bool get bgmPlaying => _bgmPlaying;
  bool get voicePlaying => _voicePlaying;
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
  Future<void> initialize() async {
    if (_initialized) return;

    _bgmPlayer = AudioPlayer();
    await _bgmPlayer!.setPlayerMode(PlayerMode.mediaPlayer);
    _sfxPlayer = AudioPlayer();
    await _sfxPlayer!.setPlayerMode(PlayerMode.lowLatency);
    _voicePlayer = AudioPlayer();
    await _voicePlayer!.setPlayerMode(PlayerMode.mediaPlayer);

    _bgmStateSub = _bgmPlayer!.onPlayerStateChanged.listen((state) {
      _bgmPlaying = state == PlayerState.playing;
      notifyListeners();
    });

    _voiceStateSub = _voicePlayer!.onPlayerStateChanged.listen((state) {
      _voicePlaying = state == PlayerState.playing;
      notifyListeners();
    });

    _initialized = true;
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BGM Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Plays BGM from the given URL.
  Future<void> playBgm(String url) async {
    if (!_initialized || _bgmPlayer == null) return;
    try {
      await _bgmPlayer!.play(UrlSource(url));
      await _bgmPlayer!.setVolume(_bgmMuted ? 0 : _bgmVolume);
    } catch (e) {
      debugPrint('BGM playback error: $e');
    }
  }

  /// Pauses BGM playback.
  Future<void> pauseBgm() async {
    await _bgmPlayer?.pause();
  }

  /// Resumes BGM playback.
  Future<void> resumeBgm() async {
    await _bgmPlayer?.resume();
  }

  /// Stops BGM playback.
  Future<void> stopBgm() async {
    await _bgmPlayer?.stop();
    _bgmPlaying = false;
    notifyListeners();
  }

  /// Sets BGM volume.
  Future<void> setBgmVolume(double volume) async {
    _bgmVolume = volume.clamp(0.0, 1.0);
    if (!_bgmMuted) {
      await _bgmPlayer?.setVolume(_bgmVolume);
    }
    notifyListeners();
  }

  /// Toggles BGM mute state.
  Future<void> toggleBgmMute() async {
    _bgmMuted = !_bgmMuted;
    await _bgmPlayer?.setVolume(_bgmMuted ? 0 : _bgmVolume);
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SFX Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Plays a one-shot SFX from the given URL.
  Future<void> playSfx(String url) async {
    if (!_initialized || _sfxPlayer == null || _sfxMuted) return;
    try {
      await _sfxPlayer!.setVolume(_sfxVolume);
      await _sfxPlayer!.play(UrlSource(url));
    } catch (e) {
      debugPrint('SFX playback error: $e');
    }
  }

  /// Sets SFX volume.
  void setSfxVolume(double volume) {
    _sfxVolume = volume.clamp(0.0, 1.0);
    notifyListeners();
  }

  /// Toggles SFX mute state.
  void toggleSfxMute() {
    _sfxMuted = !_sfxMuted;
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Voice Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Plays voice audio from the given URL.
  Future<void> playVoice(String url) async {
    if (!_initialized || _voicePlayer == null || _voiceMuted) return;
    try {
      await _voicePlayer!.setVolume(_voiceVolume);
      await _voicePlayer!.play(UrlSource(url));
    } catch (e) {
      debugPrint('Voice playback error: $e');
    }
  }

  /// Stops voice playback.
  Future<void> stopVoice() async {
    await _voicePlayer?.stop();
    _voicePlaying = false;
    notifyListeners();
  }

  /// Sets voice volume.
  Future<void> setVoiceVolume(double volume) async {
    _voiceVolume = volume.clamp(0.0, 1.0);
    await _voicePlayer?.setVolume(_voiceVolume);
    notifyListeners();
  }

  /// Toggles voice mute state.
  void toggleVoiceMute() {
    _voiceMuted = !_voiceMuted;
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Global Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Stops all audio.
  Future<void> stopAll() async {
    await stopBgm();
    await _sfxPlayer?.stop();
    await stopVoice();
  }

  /// Mutes all channels.
  void muteAll() {
    _bgmMuted = true;
    _sfxMuted = true;
    _voiceMuted = true;
    _bgmPlayer?.setVolume(0);
    notifyListeners();
  }

  /// Unmutes all channels.
  void unmuteAll() {
    _bgmMuted = false;
    _sfxMuted = false;
    _voiceMuted = false;
    _bgmPlayer?.setVolume(_bgmVolume);
    notifyListeners();
  }

  @override
  void dispose() {
    _bgmStateSub?.cancel();
    _voiceStateSub?.cancel();
    _bgmPlayer?.dispose();
    _sfxPlayer?.dispose();
    _voicePlayer?.dispose();
    super.dispose();
  }
}
