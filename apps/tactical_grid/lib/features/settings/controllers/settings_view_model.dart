/// Settings ViewModel
///
/// GetX controller that manages all user-configurable settings state.
/// Registered as a permanent app-wide dependency via [InitialBindings].
///
/// Audio volumes are read/written through [FiftyAudioEngine]'s storage.
/// Non-audio settings (timer, difficulty, theme) are persisted via
/// [SettingsService] using a dedicated GetStorage box.
///
/// **Usage:**
/// ```dart
/// final vm = Get.find<SettingsViewModel>();
/// vm.setBgmVolume(0.7);
/// vm.setDefaultDifficulty(AIDifficulty.hard);
/// ```
library;

import 'package:fifty_audio_engine/engine/storage/audio_storage.dart';
import 'package:fifty_audio_engine/fifty_audio_engine.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../battle/models/game_state.dart';
import '../data/models/settings_model.dart';
import '../data/services/settings_service.dart';

/// Reactive settings state manager for Tactical Grid.
///
/// **Responsibilities:**
/// - Exposes reactive Rx fields for all settings values.
/// - Syncs audio volume changes with [FiftyAudioEngine] channels.
/// - Persists non-audio settings via [SettingsService].
/// - Applies theme changes via [Get.changeThemeMode].
///
/// **Architecture Note:**
/// This is a VIEWMODEL layer component. The [SettingsActions] layer
/// delegates to this controller; the UI reads reactive state via `Obx()`.
class SettingsViewModel extends GetxController {
  /// Creates a [SettingsViewModel].
  ///
  /// [service] provides persistence for non-audio settings.
  SettingsViewModel(this._service);

  final SettingsService _service;

  /// Direct access to the audio engine singleton.
  FiftyAudioEngine get _engine => FiftyAudioEngine.instance;

  // ---------------------------------------------------------------------------
  // Reactive State
  // ---------------------------------------------------------------------------

  /// Background music volume (0.0 - 1.0).
  final RxDouble bgmVolume = 0.4.obs;

  /// Sound effects volume (0.0 - 1.0).
  final RxDouble sfxVolume = 1.0.obs;

  /// Voice-over volume (0.0 - 1.0).
  final RxDouble voiceVolume = 1.0.obs;

  /// Whether all audio channels are muted.
  final RxBool isMuted = false.obs;

  /// Default AI difficulty for VS AI games.
  final Rx<AIDifficulty> defaultDifficulty = AIDifficulty.easy.obs;

  /// Turn timer duration in seconds.
  final RxInt turnDuration = 60.obs;

  /// Seconds remaining when the warning zone starts.
  final RxInt warningThreshold = 10.obs;

  /// Seconds remaining when the critical zone starts.
  final RxInt criticalThreshold = 5.obs;

  /// Application theme mode.
  final Rx<ThemeMode> themeMode = ThemeMode.dark.obs;

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
  }

  /// Loads all persisted settings into reactive state.
  ///
  /// Audio volumes are read from the engine's [AudioStorage].
  /// Non-audio settings are read from [SettingsService].
  void _loadSettings() {
    // Audio volumes from engine storage.
    final audioStorage = AudioStorage.instance;
    bgmVolume.value = audioStorage.bgmVolume;
    sfxVolume.value = audioStorage.sfxVolume;
    voiceVolume.value = audioStorage.voiceVolume;

    // Mute state from service.
    isMuted.value = _service.loadMuteState();

    // Gameplay settings from service.
    turnDuration.value = _service.loadTurnDuration();
    warningThreshold.value = _service.loadWarningThreshold();
    criticalThreshold.value = _service.loadCriticalThreshold();

    // Difficulty from service (stored as string name).
    final difficultyName = _service.loadDefaultDifficulty();
    defaultDifficulty.value = AIDifficulty.values.firstWhere(
      (d) => d.name == difficultyName,
      orElse: () => AIDifficulty.easy,
    );

    // Theme mode from service.
    final themeName = _service.loadThemeMode();
    themeMode.value = themeName == 'light' ? ThemeMode.light : ThemeMode.dark;
    Get.changeThemeMode(themeMode.value);

    // Apply mute state to engine if needed.
    if (isMuted.value) {
      _engine.muteAll();
    }
  }

  // ---------------------------------------------------------------------------
  // Audio Setters
  // ---------------------------------------------------------------------------

  /// Sets the BGM volume and updates the engine channel.
  ///
  /// The engine's [BgmChannel.setVolume] also persists to [AudioStorage].
  void setBgmVolume(double v) {
    bgmVolume.value = v;
    _engine.bgm.setVolume(v);
  }

  /// Sets the SFX volume and updates the engine channel.
  void setSfxVolume(double v) {
    sfxVolume.value = v;
    _engine.sfx.setVolume(v);
  }

  /// Sets the voice volume and updates the engine channel.
  void setVoiceVolume(double v) {
    voiceVolume.value = v;
    _engine.voice.setVolume(v);
  }

  /// Toggles the master mute state for all audio channels.
  ///
  /// When muted, all channels are silenced via [FiftyAudioEngine.muteAll].
  /// When unmuted, channels are restored via [FiftyAudioEngine.unmuteAll].
  /// The mute state is persisted via [SettingsService].
  void toggleMute() {
    isMuted.value = !isMuted.value;
    _service.saveMuteState(isMuted.value);

    if (isMuted.value) {
      _engine.muteAll();
    } else {
      _engine.unmuteAll();
    }
  }

  // ---------------------------------------------------------------------------
  // Gameplay Setters
  // ---------------------------------------------------------------------------

  /// Sets the default AI difficulty and persists it.
  void setDefaultDifficulty(AIDifficulty d) {
    defaultDifficulty.value = d;
    _service.saveDefaultDifficulty(d.name);
  }

  /// Sets the turn timer duration (in seconds) and persists it.
  void setTurnDuration(int s) {
    turnDuration.value = s;
    _service.saveTurnDuration(s);
  }

  /// Sets the warning threshold (in seconds) and persists it.
  ///
  /// Clamped to be at least [criticalThreshold] + 1 to ensure
  /// the warning zone always precedes the critical zone.
  void setWarningThreshold(int s) {
    final clamped = s.clamp(criticalThreshold.value + 1, 30);
    warningThreshold.value = clamped;
    _service.saveWarningThreshold(clamped);
  }

  /// Sets the critical threshold (in seconds) and persists it.
  ///
  /// Clamped to be less than [warningThreshold] to maintain
  /// zone ordering.
  void setCriticalThreshold(int s) {
    final clamped = s.clamp(3, warningThreshold.value - 1);
    criticalThreshold.value = clamped;
    _service.saveCriticalThreshold(clamped);
  }

  // ---------------------------------------------------------------------------
  // Display Setters
  // ---------------------------------------------------------------------------

  /// Sets the theme mode and applies it immediately.
  ///
  /// Persists the preference and calls [Get.changeThemeMode] so the
  /// change propagates without an app restart.
  void setThemeMode(ThemeMode m) {
    themeMode.value = m;
    _service.saveThemeMode(m == ThemeMode.light ? 'light' : 'dark');
    Get.changeThemeMode(m);
  }

  // ---------------------------------------------------------------------------
  // Reset
  // ---------------------------------------------------------------------------

  /// Resets all settings to factory defaults.
  ///
  /// Clears persisted non-audio settings and resets audio volumes
  /// to their default values via the engine channels.
  void resetToDefaults() {
    final defaults = SettingsModel.defaults();

    // Reset non-audio persistence.
    _service.resetToDefaults();

    // Reset audio volumes via engine (which also persists to AudioStorage).
    setBgmVolume(defaults.bgmVolume);
    setSfxVolume(defaults.sfxVolume);
    setVoiceVolume(defaults.voiceVolume);

    // Reset mute state.
    if (isMuted.value) {
      isMuted.value = false;
      _service.saveMuteState(false);
      _engine.unmuteAll();
    }

    // Reset gameplay settings.
    defaultDifficulty.value = defaults.defaultDifficulty;
    turnDuration.value = defaults.turnDuration;
    warningThreshold.value = defaults.warningThreshold;
    criticalThreshold.value = defaults.criticalThreshold;

    // Reset display settings.
    themeMode.value = defaults.themeMode;
    Get.changeThemeMode(defaults.themeMode);
  }
}
