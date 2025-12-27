/// Mock audio engine that simulates the FiftyAudioEngine API.
///
/// This provides a demonstration interface for the example app while
/// the actual audio engine package is under development.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';

/// Fade duration presets for audio transitions.
enum FadePreset {
  /// Fast fade (150ms) - Quick UI feedback.
  fast(Duration(milliseconds: 150)),

  /// Panel fade (300ms) - Standard transitions.
  panel(Duration(milliseconds: 300)),

  /// Normal fade (800ms) - Default crossfade.
  normal(Duration(milliseconds: 800)),

  /// Cinematic fade (2000ms) - Scene transitions.
  cinematic(Duration(milliseconds: 2000)),

  /// Ambient fade (3000ms) - Slow atmospheric.
  ambient(Duration(milliseconds: 3000));

  const FadePreset(this.duration);
  final Duration duration;

  String get label {
    switch (this) {
      case FadePreset.fast:
        return 'FAST (150ms)';
      case FadePreset.panel:
        return 'PANEL (300ms)';
      case FadePreset.normal:
        return 'NORMAL (800ms)';
      case FadePreset.cinematic:
        return 'CINEMATIC (2s)';
      case FadePreset.ambient:
        return 'AMBIENT (3s)';
    }
  }
}

/// Mock BGM track for demonstration.
class BgmTrack {
  const BgmTrack({
    required this.id,
    required this.title,
    required this.artist,
    required this.duration,
  });

  final String id;
  final String title;
  final String artist;
  final Duration duration;
}

/// Mock SFX sound for demonstration.
class SfxSound {
  const SfxSound({
    required this.id,
    required this.label,
    required this.icon,
  });

  final String id;
  final String label;
  final int icon;
}

/// Mock BGM channel controller.
class MockBgmChannel extends ChangeNotifier {
  bool _isPlaying = false;
  bool _isPaused = false;
  bool _isMuted = false;
  bool _isShuffled = false;
  double _volume = 0.8;
  int _currentTrackIndex = 0;
  Duration _position = Duration.zero;
  Timer? _progressTimer;

  final List<BgmTrack> tracks = const [
    BgmTrack(
      id: 'track_01',
      title: 'VOID AMBIENT',
      artist: 'Fifty.ai',
      duration: Duration(minutes: 3, seconds: 45),
    ),
    BgmTrack(
      id: 'track_02',
      title: 'NEON DRIFT',
      artist: 'Fifty.ai',
      duration: Duration(minutes: 4, seconds: 12),
    ),
    BgmTrack(
      id: 'track_03',
      title: 'TERMINAL PULSE',
      artist: 'Fifty.ai',
      duration: Duration(minutes: 2, seconds: 58),
    ),
  ];

  bool get isPlaying => _isPlaying && !_isPaused;
  bool get isPaused => _isPaused;
  bool get isMuted => _isMuted;
  bool get isShuffled => _isShuffled;
  double get volume => _volume;
  int get currentTrackIndex => _currentTrackIndex;
  BgmTrack get currentTrack => tracks[_currentTrackIndex];
  Duration get position => _position;
  double get progress {
    final total = currentTrack.duration.inMilliseconds;
    if (total == 0) return 0;
    return (_position.inMilliseconds / total).clamp(0.0, 1.0);
  }

  void play() {
    _isPlaying = true;
    _isPaused = false;
    _startProgressTimer();
    notifyListeners();
  }

  void pause() {
    _isPaused = true;
    _stopProgressTimer();
    notifyListeners();
  }

  void resume() {
    _isPaused = false;
    _startProgressTimer();
    notifyListeners();
  }

  void stop() {
    _isPlaying = false;
    _isPaused = false;
    _position = Duration.zero;
    _stopProgressTimer();
    notifyListeners();
  }

  void next() {
    _currentTrackIndex = (_currentTrackIndex + 1) % tracks.length;
    _position = Duration.zero;
    notifyListeners();
  }

  void previous() {
    _currentTrackIndex =
        (_currentTrackIndex - 1 + tracks.length) % tracks.length;
    _position = Duration.zero;
    notifyListeners();
  }

  void playAtIndex(int index) {
    if (index >= 0 && index < tracks.length) {
      _currentTrackIndex = index;
      _position = Duration.zero;
      _isPlaying = true;
      _isPaused = false;
      _startProgressTimer();
      notifyListeners();
    }
  }

  void setVolume(double value) {
    _volume = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  void mute() {
    _isMuted = true;
    notifyListeners();
  }

  void unmute() {
    _isMuted = false;
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  void toggleShuffle() {
    _isShuffled = !_isShuffled;
    notifyListeners();
  }

  void _startProgressTimer() {
    _stopProgressTimer();
    _progressTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      if (_isPlaying && !_isPaused) {
        _position += const Duration(milliseconds: 100);
        if (_position >= currentTrack.duration) {
          next();
        }
        notifyListeners();
      }
    });
  }

  void _stopProgressTimer() {
    _progressTimer?.cancel();
    _progressTimer = null;
  }

  @override
  void dispose() {
    _stopProgressTimer();
    super.dispose();
  }
}

/// Mock SFX channel controller.
class MockSfxChannel extends ChangeNotifier {
  bool _isMuted = false;
  double _volume = 0.8;
  String? _lastPlayed;
  DateTime? _lastPlayedAt;

  final List<SfxSound> sounds = const [
    SfxSound(id: 'click', label: 'CLICK', icon: 0xe1e8),
    SfxSound(id: 'hover', label: 'HOVER', icon: 0xe5ca),
    SfxSound(id: 'success', label: 'SUCCESS', icon: 0xe876),
    SfxSound(id: 'error', label: 'ERROR', icon: 0xe000),
    SfxSound(id: 'notification', label: 'NOTIFY', icon: 0xe7f4),
    SfxSound(id: 'toggle', label: 'TOGGLE', icon: 0xe9f6),
  ];

  bool get isMuted => _isMuted;
  double get volume => _volume;
  String? get lastPlayed => _lastPlayed;
  DateTime? get lastPlayedAt => _lastPlayedAt;

  void play(String soundId) {
    _lastPlayed = soundId;
    _lastPlayedAt = DateTime.now();
    notifyListeners();
  }

  void setVolume(double value) {
    _volume = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  void mute() {
    _isMuted = true;
    notifyListeners();
  }

  void unmute() {
    _isMuted = false;
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }
}

/// Mock Voice channel controller.
class MockVoiceChannel extends ChangeNotifier {
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _duckingEnabled = true;
  double _volume = 0.8;
  String? _currentVoice;

  bool get isPlaying => _isPlaying;
  bool get isMuted => _isMuted;
  bool get duckingEnabled => _duckingEnabled;
  double get volume => _volume;
  String? get currentVoice => _currentVoice;

  void playVoice(String voiceId, {bool withDucking = true}) {
    _isPlaying = true;
    _currentVoice = voiceId;
    notifyListeners();

    // Simulate voice playback ending after 2 seconds
    Future.delayed(const Duration(seconds: 2), () {
      _isPlaying = false;
      _currentVoice = null;
      notifyListeners();
    });
  }

  void stop() {
    _isPlaying = false;
    _currentVoice = null;
    notifyListeners();
  }

  void setVolume(double value) {
    _volume = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  void mute() {
    _isMuted = true;
    notifyListeners();
  }

  void unmute() {
    _isMuted = false;
    notifyListeners();
  }

  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  void toggleDucking() {
    _duckingEnabled = !_duckingEnabled;
    notifyListeners();
  }
}

/// Mock audio engine singleton.
class MockAudioEngine extends ChangeNotifier {
  MockAudioEngine._();

  static final MockAudioEngine instance = MockAudioEngine._();

  final MockBgmChannel bgm = MockBgmChannel();
  final MockSfxChannel sfx = MockSfxChannel();
  final MockVoiceChannel voice = MockVoiceChannel();

  bool _allMuted = false;
  FadePreset _fadePreset = FadePreset.normal;
  bool _isFading = false;

  bool get allMuted => _allMuted;
  FadePreset get fadePreset => _fadePreset;
  bool get isFading => _isFading;

  Future<void> initialize() async {
    // Simulate initialization delay
    await Future.delayed(const Duration(milliseconds: 100));
    notifyListeners();
  }

  void muteAll() {
    _allMuted = true;
    bgm.mute();
    sfx.mute();
    voice.mute();
    notifyListeners();
  }

  void unmuteAll() {
    _allMuted = false;
    bgm.unmute();
    sfx.unmute();
    voice.unmute();
    notifyListeners();
  }

  void toggleMuteAll() {
    if (_allMuted) {
      unmuteAll();
    } else {
      muteAll();
    }
  }

  void stopAll() {
    bgm.stop();
    voice.stop();
    notifyListeners();
  }

  void setFadePreset(FadePreset preset) {
    _fadePreset = preset;
    notifyListeners();
  }

  Future<void> fadeAllOut({FadePreset? preset}) async {
    final duration = (preset ?? _fadePreset).duration;
    _isFading = true;
    notifyListeners();

    await Future.delayed(duration);

    bgm.stop();
    voice.stop();
    _isFading = false;
    notifyListeners();
  }

  Future<void> fadeAllIn({FadePreset? preset}) async {
    final duration = (preset ?? _fadePreset).duration;
    _isFading = true;
    notifyListeners();

    bgm.play();
    await Future.delayed(duration);

    _isFading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    bgm.dispose();
    sfx.dispose();
    voice.dispose();
    super.dispose();
  }
}
