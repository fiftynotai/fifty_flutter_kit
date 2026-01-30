/// Audio Demo ViewModel
///
/// Business logic for the audio demo feature showcasing Audio Engine capabilities.
library;

import 'package:get/get.dart';

/// Available audio tracks for BGM demonstration.
enum AudioTrack {
  exploration('Exploration', 'ambient_exploration.mp3', Duration(minutes: 3, seconds: 24)),
  combat('Combat', 'combat_theme.mp3', Duration(minutes: 2, seconds: 45)),
  peaceful('Peaceful', 'peaceful_village.mp3', Duration(minutes: 4, seconds: 12)),
  mystery('Mystery', 'mystery_dungeon.mp3', Duration(minutes: 3, seconds: 56)),
  victory('Victory', 'victory_fanfare.mp3', Duration(seconds: 15));

  const AudioTrack(this.displayName, this.fileName, this.duration);

  final String displayName;
  final String fileName;
  final Duration duration;
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
  buttonClick(SfxCategory.ui, 'Button Click', 'ui_click.wav'),
  menuOpen(SfxCategory.ui, 'Menu Open', 'ui_menu_open.wav'),
  menuClose(SfxCategory.ui, 'Menu Close', 'ui_menu_close.wav'),
  notification(SfxCategory.ui, 'Notification', 'ui_notification.wav'),

  // Combat sounds
  swordSlash(SfxCategory.combat, 'Sword Slash', 'combat_sword.wav'),
  bowShot(SfxCategory.combat, 'Bow Shot', 'combat_bow.wav'),
  magicCast(SfxCategory.combat, 'Magic Cast', 'combat_magic.wav'),
  hit(SfxCategory.combat, 'Hit', 'combat_hit.wav'),

  // Environment sounds
  doorOpen(SfxCategory.environment, 'Door Open', 'env_door.wav'),
  chestOpen(SfxCategory.environment, 'Chest Open', 'env_chest.wav'),
  waterSplash(SfxCategory.environment, 'Water Splash', 'env_water.wav'),
  footsteps(SfxCategory.environment, 'Footsteps', 'env_footsteps.wav'),

  // Character sounds
  jump(SfxCategory.character, 'Jump', 'char_jump.wav'),
  land(SfxCategory.character, 'Land', 'char_land.wav'),
  levelUp(SfxCategory.character, 'Level Up', 'char_levelup.wav'),
  itemPickup(SfxCategory.character, 'Item Pickup', 'char_pickup.wav');

  const SoundEffect(this.category, this.displayName, this.fileName);

  final SfxCategory category;
  final String displayName;
  final String fileName;
}

/// ViewModel for the audio demo feature.
///
/// Manages BGM, SFX, and Voice channel states for demonstration.
class AudioDemoViewModel extends GetxController {
  // ─────────────────────────────────────────────────────────────────────────
  // BGM State
  // ─────────────────────────────────────────────────────────────────────────

  AudioTrack _currentTrack = AudioTrack.exploration;
  bool _bgmPlaying = false;
  bool _bgmMuted = false;
  double _bgmVolume = 0.7;
  Duration _bgmPosition = Duration.zero;

  AudioTrack get currentTrack => _currentTrack;
  bool get bgmPlaying => _bgmPlaying;
  bool get bgmMuted => _bgmMuted;
  double get bgmVolume => _bgmVolume;
  Duration get bgmPosition => _bgmPosition;

  /// List of available BGM tracks.
  List<AudioTrack> get availableTracks => AudioTrack.values;

  /// Progress of current track (0.0 - 1.0).
  double get bgmProgress {
    if (_currentTrack.duration.inMilliseconds == 0) return 0.0;
    return _bgmPosition.inMilliseconds / _currentTrack.duration.inMilliseconds;
  }

  /// Formatted current position.
  String get bgmPositionLabel {
    final minutes = _bgmPosition.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _bgmPosition.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Formatted track duration.
  String get bgmDurationLabel {
    final minutes = _currentTrack.duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = _currentTrack.duration.inSeconds.remainder(60).toString().padLeft(2, '0');
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

  /// Demo voice lines.
  List<String> get voiceLines => const [
        'Welcome, adventurer!',
        'The journey begins here.',
        'Watch out for traps ahead.',
        'You have found a rare item!',
        'Quest completed successfully.',
      ];

  // ─────────────────────────────────────────────────────────────────────────
  // Master State
  // ─────────────────────────────────────────────────────────────────────────

  double _masterVolume = 1.0;
  bool _masterMuted = false;

  double get masterVolume => _masterVolume;
  bool get masterMuted => _masterMuted;

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
  void toggleBgmPlayback() {
    _bgmPlaying = !_bgmPlaying;
    update();
  }

  /// Plays BGM.
  void playBgm() {
    _bgmPlaying = true;
    update();
  }

  /// Pauses BGM.
  void pauseBgm() {
    _bgmPlaying = false;
    update();
  }

  /// Stops BGM and resets position.
  void stopBgm() {
    _bgmPlaying = false;
    _bgmPosition = Duration.zero;
    update();
  }

  /// Toggles BGM mute.
  void toggleBgmMute() {
    _bgmMuted = !_bgmMuted;
    update();
  }

  /// Sets BGM volume.
  void setBgmVolume(double volume) {
    _bgmVolume = volume.clamp(0.0, 1.0);
    update();
  }

  /// Seeks to position in track (0.0 - 1.0).
  void seekBgm(double progress) {
    final newPosition = Duration(
      milliseconds: (progress * _currentTrack.duration.inMilliseconds).toInt(),
    );
    _bgmPosition = newPosition;
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
  void playSfx(SoundEffect sfx) {
    _lastPlayedSfx = sfx;
    update();
    // In a real implementation, this would trigger the audio engine
  }

  /// Toggles SFX mute.
  void toggleSfxMute() {
    _sfxMuted = !_sfxMuted;
    update();
  }

  /// Sets SFX volume.
  void setSfxVolume(double volume) {
    _sfxVolume = volume.clamp(0.0, 1.0);
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Voice Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Plays a voice line.
  void playVoiceLine(String line) {
    _currentVoiceLine = line;
    _voicePlaying = true;
    update();
    // Simulate voice playback ending after a delay
    Future.delayed(const Duration(seconds: 2), () {
      _voicePlaying = false;
      update();
    });
  }

  /// Stops voice playback.
  void stopVoice() {
    _voicePlaying = false;
    _currentVoiceLine = '';
    update();
  }

  /// Toggles voice mute.
  void toggleVoiceMute() {
    _voiceMuted = !_voiceMuted;
    update();
  }

  /// Sets voice volume.
  void setVoiceVolume(double volume) {
    _voiceVolume = volume.clamp(0.0, 1.0);
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Master Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Sets master volume.
  void setMasterVolume(double volume) {
    _masterVolume = volume.clamp(0.0, 1.0);
    update();
  }

  /// Toggles master mute.
  void toggleMasterMute() {
    _masterMuted = !_masterMuted;
    update();
  }

  /// Resets all audio to defaults.
  void resetAll() {
    _currentTrack = AudioTrack.exploration;
    _bgmPlaying = false;
    _bgmMuted = false;
    _bgmVolume = 0.7;
    _bgmPosition = Duration.zero;
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
    update();
  }
}
