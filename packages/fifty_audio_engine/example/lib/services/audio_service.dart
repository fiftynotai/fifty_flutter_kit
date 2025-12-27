/// Audio service that wraps FiftyAudioEngine for the example app.
///
/// Uses URL-based audio samples for demonstration. In production,
/// replace with bundled assets.
library;

import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Fade preset durations matching FiftyAudioEngine.
enum DemoFadePreset {
  fast(Duration(milliseconds: 150)),
  panel(Duration(milliseconds: 300)),
  normal(Duration(milliseconds: 800)),
  cinematic(Duration(milliseconds: 2000)),
  ambient(Duration(milliseconds: 3000));

  const DemoFadePreset(this.duration);
  final Duration duration;

  String get label {
    switch (this) {
      case DemoFadePreset.fast:
        return 'FAST (150ms)';
      case DemoFadePreset.panel:
        return 'PANEL (300ms)';
      case DemoFadePreset.normal:
        return 'NORMAL (800ms)';
      case DemoFadePreset.cinematic:
        return 'CINEMATIC (2s)';
      case DemoFadePreset.ambient:
        return 'AMBIENT (3s)';
    }
  }
}

/// Audio service singleton using real audio players.
class AudioService extends ChangeNotifier {
  AudioService._();

  static final AudioService instance = AudioService._();

  /// Audio players for each channel.
  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  final AudioPlayer _voicePlayer = AudioPlayer();

  /// State.
  bool _initialized = false;
  bool get isInitialized => _initialized;

  /// BGM state.
  bool _bgmPlaying = false;
  bool _bgmPaused = false;
  bool _bgmMuted = false;
  bool _bgmShuffled = false;
  double _bgmVolume = 0.8;
  int _bgmTrackIndex = 0;
  Duration _bgmPosition = Duration.zero;
  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _stateSub;

  bool get bgmPlaying => _bgmPlaying && !_bgmPaused;
  bool get bgmPaused => _bgmPaused;
  bool get bgmMuted => _bgmMuted;
  bool get bgmShuffled => _bgmShuffled;
  double get bgmVolume => _bgmVolume;
  int get bgmTrackIndex => _bgmTrackIndex;
  Duration get bgmPosition => _bgmPosition;
  TrackInfo get currentTrack => bgmTracks[_bgmTrackIndex];

  double get bgmProgress {
    final total = currentTrack.duration.inMilliseconds;
    if (total == 0) return 0;
    return (_bgmPosition.inMilliseconds / total).clamp(0.0, 1.0);
  }

  /// SFX state.
  bool _sfxMuted = false;
  double _sfxVolume = 0.8;
  String? _lastSfxPlayed;

  bool get sfxMuted => _sfxMuted;
  double get sfxVolume => _sfxVolume;
  String? get lastSfxPlayed => _lastSfxPlayed;

  /// Voice state.
  bool _voicePlaying = false;
  bool _voiceMuted = false;
  bool _voiceDuckingEnabled = true;
  double _voiceVolume = 0.8;

  bool get voicePlaying => _voicePlaying;
  bool get voiceMuted => _voiceMuted;
  bool get voiceDuckingEnabled => _voiceDuckingEnabled;
  double get voiceVolume => _voiceVolume;

  /// Global state.
  bool _allMuted = false;
  DemoFadePreset _fadePreset = DemoFadePreset.normal;
  bool _isFading = false;

  bool get allMuted => _allMuted;
  DemoFadePreset get fadePreset => _fadePreset;
  bool get isFading => _isFading;

  /// Sample tracks using royalty-free audio URLs.
  /// These are short sample clips for demonstration.
  final List<TrackInfo> bgmTracks = const [
    TrackInfo(
      id: 'track_01',
      title: 'VOID AMBIENT',
      artist: 'Fifty.ai',
      // Royalty-free ambient sample
      url:
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
      duration: Duration(minutes: 6, seconds: 0),
    ),
    TrackInfo(
      id: 'track_02',
      title: 'NEON DRIFT',
      artist: 'Fifty.ai',
      url:
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
      duration: Duration(minutes: 6, seconds: 30),
    ),
    TrackInfo(
      id: 'track_03',
      title: 'TERMINAL PULSE',
      artist: 'Fifty.ai',
      url:
          'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3',
      duration: Duration(minutes: 5, seconds: 45),
    ),
  ];

  /// SFX sounds using sample MP3 URLs (iOS compatible).
  /// Using SoundHelix samples which are reliable and MP3 format.
  final List<SfxInfo> sfxSounds = const [
    SfxInfo(
      id: 'click',
      label: 'CLICK',
      icon: 0xe1e8,
      url: 'https://www.soundjay.com/buttons/sounds/button-09a.mp3',
    ),
    SfxInfo(
      id: 'hover',
      label: 'HOVER',
      icon: 0xe5ca,
      url: 'https://www.soundjay.com/buttons/sounds/button-16.mp3',
    ),
    SfxInfo(
      id: 'success',
      label: 'SUCCESS',
      icon: 0xe876,
      url: 'https://www.soundjay.com/misc/sounds/bell-ringing-05.mp3',
    ),
    SfxInfo(
      id: 'error',
      label: 'ERROR',
      icon: 0xe000,
      url: 'https://www.soundjay.com/buttons/sounds/button-10.mp3',
    ),
    SfxInfo(
      id: 'notification',
      label: 'NOTIFY',
      icon: 0xe7f4,
      url: 'https://www.soundjay.com/buttons/sounds/button-35.mp3',
    ),
    SfxInfo(
      id: 'toggle',
      label: 'TOGGLE',
      icon: 0xe9f6,
      url: 'https://www.soundjay.com/buttons/sounds/button-21.mp3',
    ),
  ];

  /// Voice lines using MP3 format.
  final List<VoiceInfo> voiceLines = const [
    VoiceInfo(
      id: 'greeting',
      label: 'GREETING',
      url: 'https://www.soundjay.com/communication/sounds/telephone-ring-04.mp3',
      duration: Duration(seconds: 3),
    ),
  ];

  /// Initialize the audio service.
  Future<void> initialize() async {
    if (_initialized) return;

    // Set up position tracking for BGM
    _positionSub = _bgmPlayer.onPositionChanged.listen((pos) {
      _bgmPosition = pos;
      notifyListeners();
    });

    _stateSub = _bgmPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed) {
        // Auto-advance to next track
        playNextBgm();
      }
    });

    _initialized = true;
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BGM Controls
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> playBgm() async {
    final track = bgmTracks[_bgmTrackIndex];
    try {
      await _bgmPlayer.play(UrlSource(track.url));
      await _bgmPlayer.setVolume(_bgmMuted ? 0 : _bgmVolume);
      _bgmPlaying = true;
      _bgmPaused = false;
    } catch (e) {
      debugPrint('BGM playback error: $e');
    }
    notifyListeners();
  }

  Future<void> pauseBgm() async {
    await _bgmPlayer.pause();
    _bgmPaused = true;
    notifyListeners();
  }

  Future<void> resumeBgm() async {
    await _bgmPlayer.resume();
    _bgmPaused = false;
    notifyListeners();
  }

  Future<void> stopBgm() async {
    await _bgmPlayer.stop();
    _bgmPlaying = false;
    _bgmPaused = false;
    _bgmPosition = Duration.zero;
    notifyListeners();
  }

  Future<void> playNextBgm() async {
    _bgmTrackIndex = (_bgmTrackIndex + 1) % bgmTracks.length;
    _bgmPosition = Duration.zero;
    if (_bgmPlaying) {
      await playBgm();
    }
    notifyListeners();
  }

  Future<void> playPreviousBgm() async {
    _bgmTrackIndex = (_bgmTrackIndex - 1 + bgmTracks.length) % bgmTracks.length;
    _bgmPosition = Duration.zero;
    if (_bgmPlaying) {
      await playBgm();
    }
    notifyListeners();
  }

  Future<void> playBgmAtIndex(int index) async {
    if (index >= 0 && index < bgmTracks.length) {
      _bgmTrackIndex = index;
      _bgmPosition = Duration.zero;
      await playBgm();
    }
  }

  Future<void> setBgmVolume(double value) async {
    _bgmVolume = value.clamp(0.0, 1.0);
    if (!_bgmMuted) {
      await _bgmPlayer.setVolume(_bgmVolume);
    }
    notifyListeners();
  }

  Future<void> toggleBgmMute() async {
    _bgmMuted = !_bgmMuted;
    await _bgmPlayer.setVolume(_bgmMuted ? 0 : _bgmVolume);
    notifyListeners();
  }

  void toggleBgmShuffle() {
    _bgmShuffled = !_bgmShuffled;
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SFX Controls
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> playSfx(String soundId) async {
    final sound = sfxSounds.firstWhere(
      (s) => s.id == soundId,
      orElse: () => sfxSounds.first,
    );
    if (!_sfxMuted) {
      try {
        await _sfxPlayer.setVolume(_sfxVolume);
        await _sfxPlayer.play(UrlSource(sound.url));
      } catch (e) {
        debugPrint('SFX playback error: $e');
      }
    }
    _lastSfxPlayed = soundId;
    notifyListeners();
  }

  Future<void> setSfxVolume(double value) async {
    _sfxVolume = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  Future<void> toggleSfxMute() async {
    _sfxMuted = !_sfxMuted;
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Voice Controls
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> playVoice(String voiceId) async {
    final voice = voiceLines.firstWhere(
      (v) => v.id == voiceId,
      orElse: () => voiceLines.first,
    );

    // Duck BGM if enabled
    if (_voiceDuckingEnabled && _bgmPlaying) {
      await _bgmPlayer.setVolume(_bgmVolume * 0.3);
    }

    _voicePlaying = true;
    notifyListeners();

    if (!_voiceMuted) {
      try {
        await _voicePlayer.setVolume(_voiceVolume);
        await _voicePlayer.play(UrlSource(voice.url));

        // Restore BGM after voice completes
        _voicePlayer.onPlayerComplete.first.then((_) async {
          _voicePlaying = false;
          if (_voiceDuckingEnabled && _bgmPlaying && !_bgmMuted) {
            await _bgmPlayer.setVolume(_bgmVolume);
          }
          notifyListeners();
        });
      } catch (e) {
        debugPrint('Voice playback error: $e');
        _voicePlaying = false;
        if (_voiceDuckingEnabled && _bgmPlaying && !_bgmMuted) {
          await _bgmPlayer.setVolume(_bgmVolume);
        }
        notifyListeners();
      }
    }
  }

  Future<void> stopVoice() async {
    await _voicePlayer.stop();
    _voicePlaying = false;
    if (_voiceDuckingEnabled && _bgmPlaying && !_bgmMuted) {
      await _bgmPlayer.setVolume(_bgmVolume);
    }
    notifyListeners();
  }

  Future<void> setVoiceVolume(double value) async {
    _voiceVolume = value.clamp(0.0, 1.0);
    notifyListeners();
  }

  Future<void> toggleVoiceMute() async {
    _voiceMuted = !_voiceMuted;
    notifyListeners();
  }

  void toggleVoiceDucking() {
    _voiceDuckingEnabled = !_voiceDuckingEnabled;
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Global Controls
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> muteAll() async {
    _allMuted = true;
    _bgmMuted = true;
    _sfxMuted = true;
    _voiceMuted = true;
    await _bgmPlayer.setVolume(0);
    notifyListeners();
  }

  Future<void> unmuteAll() async {
    _allMuted = false;
    _bgmMuted = false;
    _sfxMuted = false;
    _voiceMuted = false;
    await _bgmPlayer.setVolume(_bgmVolume);
    notifyListeners();
  }

  Future<void> toggleMuteAll() async {
    if (_allMuted) {
      await unmuteAll();
    } else {
      await muteAll();
    }
  }

  Future<void> stopAll() async {
    await stopBgm();
    await _sfxPlayer.stop();
    await stopVoice();
  }

  void setFadePreset(DemoFadePreset preset) {
    _fadePreset = preset;
    notifyListeners();
  }

  Future<void> fadeAllOut({DemoFadePreset? preset}) async {
    final duration = (preset ?? _fadePreset).duration;
    _isFading = true;
    notifyListeners();

    // Animate volume to 0
    const steps = 20;
    final stepDuration = duration ~/ steps;
    final startVolume = _bgmVolume;

    for (var i = 1; i <= steps; i++) {
      await Future.delayed(stepDuration);
      final newVolume = startVolume * (1 - i / steps);
      await _bgmPlayer.setVolume(newVolume);
    }

    await stopAll();
    _isFading = false;
    notifyListeners();
  }

  Future<void> fadeAllIn({DemoFadePreset? preset}) async {
    final duration = (preset ?? _fadePreset).duration;
    _isFading = true;
    notifyListeners();

    await playBgm();

    // Animate volume from 0 to target
    const steps = 20;
    final stepDuration = duration ~/ steps;

    for (var i = 1; i <= steps; i++) {
      await Future.delayed(stepDuration);
      final newVolume = _bgmVolume * (i / steps);
      await _bgmPlayer.setVolume(newVolume);
    }

    _isFading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _positionSub?.cancel();
    _stateSub?.cancel();
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
    _voicePlayer.dispose();
    super.dispose();
  }
}

/// Track metadata for BGM.
class TrackInfo {
  const TrackInfo({
    required this.id,
    required this.title,
    required this.artist,
    required this.url,
    required this.duration,
  });

  final String id;
  final String title;
  final String artist;
  final String url;
  final Duration duration;
}

/// SFX sound metadata.
class SfxInfo {
  const SfxInfo({
    required this.id,
    required this.label,
    required this.icon,
    required this.url,
  });

  final String id;
  final String label;
  final int icon;
  final String url;
}

/// Voice line metadata.
class VoiceInfo {
  const VoiceInfo({
    required this.id,
    required this.label,
    required this.url,
    required this.duration,
  });

  final String id;
  final String label;
  final String url;
  final Duration duration;
}
