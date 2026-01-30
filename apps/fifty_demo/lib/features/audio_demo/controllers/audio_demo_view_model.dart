/// Audio Demo ViewModel
///
/// Business logic for the audio demo feature showcasing Audio Engine capabilities.
/// Connected to the actual FiftyAudioEngine for real audio playback.
library;

import 'dart:async';

import 'package:fifty_audio_engine/fifty_audio_engine.dart';
import 'package:get/get.dart';

/// Available audio tracks for BGM demonstration.
enum AudioTrack {
  exploration('Exploration', 'audio/bgm/exploration.mp3'),
  combat('Combat', 'audio/bgm/combat.mp3'),
  peaceful('Peaceful', 'audio/bgm/peaceful.mp3');

  const AudioTrack(this.displayName, this.assetPath);

  final String displayName;
  final String assetPath;
}

/// Sound effect categories for SFX demonstration.
enum SfxCategory {
  ui('UI'),
  combat('Combat'),
  environment('Environment'),
  character('Character');

  const SfxCategory(this.displayName);

  final String displayName;
}

/// Available sound effects for demonstration.
enum SoundEffect {
  // UI sounds
  buttonClick(SfxCategory.ui, 'Button Click', 'audio/sfx/button_click.mp3'),
  menuOpen(SfxCategory.ui, 'Menu Open', 'audio/sfx/menu_open.mp3'),
  menuClose(SfxCategory.ui, 'Menu Close', 'audio/sfx/menu_close.mp3'),
  notification(SfxCategory.ui, 'Notification', 'audio/sfx/notification.mp3'),

  // Combat sounds
  swordSlash(SfxCategory.combat, 'Sword Slash', 'audio/sfx/sword_slash.mp3'),
  bowShot(SfxCategory.combat, 'Bow Shot', 'audio/sfx/bow_shot.mp3'),
  magicCast(SfxCategory.combat, 'Magic Cast', 'audio/sfx/magic_cast.mp3'),
  hit(SfxCategory.combat, 'Hit', 'audio/sfx/hit.mp3'),

  // Environment sounds
  doorOpen(SfxCategory.environment, 'Door Open', 'audio/sfx/door_open.mp3'),
  chestOpen(SfxCategory.environment, 'Chest Open', 'audio/sfx/chest_open.mp3'),
  waterSplash(SfxCategory.environment, 'Water Splash', 'audio/sfx/water_splash.mp3'),
  footsteps(SfxCategory.environment, 'Footsteps', 'audio/sfx/footsteps.mp3'),

  // Character sounds
  jump(SfxCategory.character, 'Jump', 'audio/sfx/jump.mp3'),
  land(SfxCategory.character, 'Land', 'audio/sfx/land.mp3'),
  levelUp(SfxCategory.character, 'Level Up', 'audio/sfx/level_up.mp3'),
  itemPickup(SfxCategory.character, 'Item Pickup', 'audio/sfx/item_pickup.mp3');

  const SoundEffect(this.category, this.displayName, this.assetPath);

  final SfxCategory category;
  final String displayName;
  final String assetPath;
}

/// Available voice lines for demonstration.
enum VoiceLine {
  welcome('Welcome, adventurer!', 'audio/voice/welcome.mp3'),
  journey('The journey begins here.', 'audio/voice/journey.mp3'),
  warning('Watch out for traps ahead.', 'audio/voice/warning.mp3'),
  rareItem('You have found a rare item!', 'audio/voice/rare_item.mp3'),
  questComplete('Quest completed successfully.', 'audio/voice/quest_complete.mp3');

  const VoiceLine(this.displayText, this.assetPath);

  final String displayText;
  final String assetPath;
}

/// ViewModel for the audio demo feature.
///
/// Manages BGM, SFX, and Voice channel states using the actual FiftyAudioEngine.
class AudioDemoViewModel extends GetxController {
  /// Reference to the audio engine.
  FiftyAudioEngine get _engine => FiftyAudioEngine.instance;

  /// Whether the audio engine has been initialized.
  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // ─────────────────────────────────────────────────────────────────────────
  // BGM State
  // ─────────────────────────────────────────────────────────────────────────

  AudioTrack _currentTrack = AudioTrack.exploration;
  bool _bgmMuted = false;
  double _bgmVolume = 0.7;

  AudioTrack get currentTrack => _currentTrack;
  bool get bgmPlaying => _isInitialized && _engine.bgm.isPlaying;
  bool get bgmMuted => _bgmMuted;
  double get bgmVolume => _bgmVolume;

  /// List of available BGM tracks.
  List<AudioTrack> get availableTracks => AudioTrack.values;

  /// Progress of current track (0.0 - 1.0).
  double get bgmProgress {
    if (_bgmDuration.inMilliseconds == 0) return 0.0;
    return (_bgmPosition.inMilliseconds / _bgmDuration.inMilliseconds)
        .clamp(0.0, 1.0);
  }

  /// Formatted current position (e.g., "01:23").
  String get bgmPositionLabel => _formatDuration(_bgmPosition);

  /// Formatted track duration (e.g., "03:45").
  String get bgmDurationLabel => _formatDuration(_bgmDuration);

  /// Formats a Duration as "mm:ss".
  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SFX State
  // ─────────────────────────────────────────────────────────────────────────

  bool _sfxMuted = false;
  double _sfxVolume = 0.8;
  SfxCategory _selectedCategory = SfxCategory.ui;
  SoundEffect? _lastPlayedSfx;

  bool get sfxMuted => _sfxMuted;
  double get sfxVolume => _sfxVolume;
  SfxCategory get selectedCategory => _selectedCategory;
  SoundEffect? get lastPlayedSfx => _lastPlayedSfx;

  /// List of SFX categories.
  List<SfxCategory> get sfxCategories => SfxCategory.values;

  /// Sound effects for selected category.
  List<SoundEffect> get categorySoundEffects {
    return SoundEffect.values.where((sfx) => sfx.category == _selectedCategory).toList();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Voice State
  // ─────────────────────────────────────────────────────────────────────────

  bool _voiceMuted = false;
  double _voiceVolume = 1.0;
  bool _voicePlaying = false;
  String _currentVoiceLine = '';

  bool get voiceMuted => _voiceMuted;
  double get voiceVolume => _voiceVolume;
  bool get voicePlaying => _voicePlaying;
  String get currentVoiceLine => _currentVoiceLine;

  /// Available voice lines with ElevenLabs generated audio.
  List<VoiceLine> get voiceLines => VoiceLine.values;

  // ─────────────────────────────────────────────────────────────────────────
  // Master State
  // ─────────────────────────────────────────────────────────────────────────

  double _masterVolume = 1.0;
  bool _masterMuted = false;

  double get masterVolume => _masterVolume;
  bool get masterMuted => _masterMuted;

  // ─────────────────────────────────────────────────────────────────────────
  // Position Tracking State
  // ─────────────────────────────────────────────────────────────────────────

  Duration _bgmPosition = Duration.zero;
  Duration _bgmDuration = Duration.zero;
  StreamSubscription<Duration>? _positionSubscription;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void onInit() {
    super.onInit();
    _initializeAudioEngine();
  }

  /// Initialize the audio engine.
  Future<void> _initializeAudioEngine() async {
    try {
      // Check if engine is already initialized by testing if bgm channel exists
      var alreadyInitialized = false;
      try {
        // If bgm is accessible, engine is already initialized
        final _ = _engine.bgm;
        alreadyInitialized = true;
      } catch (_) {
        // Engine not yet initialized
        alreadyInitialized = false;
      }

      if (!alreadyInitialized) {
        // Initialize the engine with BGM playlist
        final bgmPaths = AudioTrack.values.map((t) => t.assetPath).toList();
        await _engine.initialize(bgmPaths);
      }

      // Register SFX groups
      _registerSfxGroups();

      // Set initial volumes
      await _engine.bgm.setVolume(_bgmVolume);
      await _engine.sfx.setVolume(_sfxVolume);
      await _engine.voice.setVolume(_voiceVolume);

      _isInitialized = true;

      // Subscribe to BGM position updates
      _positionSubscription = _engine.bgm.onPositionChanged.listen((position) {
        _bgmPosition = position;
        update();
      });

      update();
    } catch (e) {
      // Engine initialization failed - demo will show mock state
      _isInitialized = false;
      update();
    }
  }

  /// Fetches current track duration from engine.
  Future<void> _fetchDuration() async {
    if (!_isInitialized) return;
    final duration = await _engine.bgm.getDuration();
    if (duration != null) {
      _bgmDuration = duration;
      update();
    }
  }

  /// Register SFX groups for each category.
  void _registerSfxGroups() {
    // Register individual sounds as groups (for playGroup API)
    for (final sfx in SoundEffect.values) {
      _engine.sfx.registerGroup(sfx.name, [sfx.assetPath]);
    }

    // Register category groups (all sounds in category)
    for (final category in SfxCategory.values) {
      final sounds = SoundEffect.values
          .where((s) => s.category == category)
          .map((s) => s.assetPath)
          .toList();
      _engine.sfx.registerGroup(category.name, sounds);
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BGM Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Selects a BGM track.
  void selectTrack(AudioTrack track) {
    _currentTrack = track;
    _bgmPosition = Duration.zero;
    update();
  }

  /// Toggles BGM playback.
  Future<void> toggleBgmPlayback() async {
    if (!_isInitialized) return;

    if (_engine.bgm.isPlaying) {
      await _engine.bgm.pause();
    } else {
      await _engine.bgm.play(_currentTrack.assetPath);
      await _fetchDuration();
    }
    update();
  }

  /// Plays BGM.
  Future<void> playBgm() async {
    if (!_isInitialized) return;
    await _engine.bgm.play(_currentTrack.assetPath);
    await _fetchDuration();
    update();
  }

  /// Pauses BGM.
  Future<void> pauseBgm() async {
    if (!_isInitialized) return;
    await _engine.bgm.pause();
    update();
  }

  /// Stops BGM and resets position.
  Future<void> stopBgm() async {
    if (!_isInitialized) return;
    await _engine.bgm.stop();
    _bgmPosition = Duration.zero;
    update();
  }

  /// Toggles BGM mute.
  Future<void> toggleBgmMute() async {
    _bgmMuted = !_bgmMuted;
    if (_isInitialized) {
      if (_bgmMuted) {
        await _engine.bgm.mute();
      } else {
        await _engine.bgm.setVolume(_bgmVolume);
      }
    }
    update();
  }

  /// Sets BGM volume.
  Future<void> setBgmVolume(double volume) async {
    _bgmVolume = volume.clamp(0.0, 1.0);
    if (_isInitialized && !_bgmMuted) {
      await _engine.bgm.setVolume(_bgmVolume);
    }
    update();
  }

  /// Seeks to position in track (0.0 - 1.0).
  ///
  /// Note: Full seek requires engine enhancement. Currently restarts track
  /// if seeking to beginning (< 10%).
  Future<void> seekBgm(double progress) async {
    if (!_isInitialized || _bgmDuration.inMilliseconds == 0) return;

    // Only support restart for now (engine doesn't expose seek)
    if (progress < 0.1) {
      await _engine.bgm.stop();
      _bgmPosition = Duration.zero;
      await _engine.bgm.play(_currentTrack.assetPath);
      await _fetchDuration();
    }

    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SFX Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Selects SFX category.
  void selectSfxCategory(SfxCategory category) {
    _selectedCategory = category;
    update();
  }

  /// Plays a sound effect.
  Future<void> playSfx(SoundEffect sfx) async {
    _lastPlayedSfx = sfx;
    if (_isInitialized && !_sfxMuted) {
      await _engine.sfx.play(sfx.assetPath);
    }
    update();
  }

  /// Toggles SFX mute.
  Future<void> toggleSfxMute() async {
    _sfxMuted = !_sfxMuted;
    if (_isInitialized) {
      if (_sfxMuted) {
        await _engine.sfx.mute();
      } else {
        await _engine.sfx.setVolume(_sfxVolume);
      }
    }
    update();
  }

  /// Sets SFX volume.
  Future<void> setSfxVolume(double volume) async {
    _sfxVolume = volume.clamp(0.0, 1.0);
    if (_isInitialized && !_sfxMuted) {
      await _engine.sfx.setVolume(_sfxVolume);
    }
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Voice Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Plays a voice line through the voice channel.
  Future<void> playVoiceLine(VoiceLine voiceLine) async {
    _currentVoiceLine = voiceLine.displayText;
    _voicePlaying = true;
    update();

    if (!_isInitialized || _voiceMuted) {
      // Simulate short playback when muted
      Future.delayed(const Duration(milliseconds: 500), () {
        _voicePlaying = false;
        update();
      });
      return;
    }

    // Register completion callback
    _engine.voice.onCompleted = () async {
      _voicePlaying = false;
      _currentVoiceLine = '';
      update();
    };

    // Play actual voice file through voice channel
    await _engine.voice.playVoice(voiceLine.assetPath, false);
  }

  /// Stops voice playback.
  void stopVoice() {
    _voicePlaying = false;
    _currentVoiceLine = '';
    update();
  }

  /// Toggles voice mute.
  Future<void> toggleVoiceMute() async {
    _voiceMuted = !_voiceMuted;
    if (_isInitialized) {
      if (_voiceMuted) {
        await _engine.voice.mute();
      } else {
        await _engine.voice.setVolume(_voiceVolume);
      }
    }
    update();
  }

  /// Sets voice volume.
  Future<void> setVoiceVolume(double volume) async {
    _voiceVolume = volume.clamp(0.0, 1.0);
    if (_isInitialized && !_voiceMuted) {
      await _engine.voice.setVolume(_voiceVolume);
    }
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Master Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Sets master volume.
  Future<void> setMasterVolume(double volume) async {
    _masterVolume = volume.clamp(0.0, 1.0);
    // Apply master volume scaling to all channels
    if (_isInitialized) {
      await _engine.bgm.setVolume(_bgmVolume * _masterVolume);
      await _engine.sfx.setVolume(_sfxVolume * _masterVolume);
      await _engine.voice.setVolume(_voiceVolume * _masterVolume);
    }
    update();
  }

  /// Toggles master mute.
  Future<void> toggleMasterMute() async {
    _masterMuted = !_masterMuted;
    if (_isInitialized) {
      if (_masterMuted) {
        await _engine.muteAll();
      } else {
        await _engine.unmuteAll();
      }
    }
    update();
  }

  /// Resets all audio to defaults.
  Future<void> resetAll() async {
    _currentTrack = AudioTrack.exploration;
    _bgmMuted = false;
    _bgmVolume = 0.7;
    _sfxMuted = false;
    _sfxVolume = 0.8;
    _selectedCategory = SfxCategory.ui;
    _lastPlayedSfx = null;
    _voiceMuted = false;
    _voiceVolume = 1.0;
    _voicePlaying = false;
    _currentVoiceLine = '';
    _masterVolume = 1.0;
    _masterMuted = false;

    if (_isInitialized) {
      await _engine.stopAll();
      await _engine.bgm.setVolume(_bgmVolume);
      await _engine.sfx.setVolume(_sfxVolume);
      await _engine.voice.setVolume(_voiceVolume);
    }
    update();
  }

  @override
  void onClose() {
    // Cancel position subscription
    _positionSubscription?.cancel();
    _positionSubscription = null;

    // Stop all audio when leaving the demo
    if (_isInitialized) {
      _engine.stopAll();
    }
    super.onClose();
  }
}
