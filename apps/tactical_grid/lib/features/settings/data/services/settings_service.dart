/// Settings Service
///
/// Persistence layer for non-audio settings using [GetStorage].
/// Audio volumes are already persisted by [FiftyAudioEngine]'s
/// [AudioStorage] -- this service only handles gameplay and display
/// preferences.
///
/// Uses the `TacticalGridSettings` storage box with `tg_` prefixed keys.
///
/// **Usage:**
/// ```dart
/// // In main.dart: await GetStorage.init('TacticalGridSettings');
/// final service = SettingsService();
/// final duration = service.loadTurnDuration();
/// service.saveTurnDuration(45);
/// ```
library;

import 'package:get_storage/get_storage.dart';

/// Persists non-audio settings to local storage.
///
/// **Persisted keys:**
/// - `tg_turn_duration` - Turn timer duration in seconds.
/// - `tg_warning_threshold` - Warning zone threshold in seconds.
/// - `tg_critical_threshold` - Critical zone threshold in seconds.
/// - `tg_default_difficulty` - AI difficulty as string name.
/// - `tg_theme_mode` - Theme mode as 'dark' or 'light'.
/// - `tg_mute_state` - Master mute toggle.
///
/// Audio volumes are NOT stored here. They are managed by
/// [FiftyAudioEngine]'s [AudioStorage] via its own GetStorage box.
class SettingsService {
  /// The name of the GetStorage box for settings.
  static const String _boxName = 'TacticalGridSettings';

  // Storage keys (prefixed with `tg_` to avoid collisions).
  static const String _keyTurnDuration = 'tg_turn_duration';
  static const String _keyWarningThreshold = 'tg_warning_threshold';
  static const String _keyCriticalThreshold = 'tg_critical_threshold';
  static const String _keyDefaultDifficulty = 'tg_default_difficulty';
  static const String _keyThemeMode = 'tg_theme_mode';
  static const String _keyMuteState = 'tg_mute_state';

  // Default values matching original hardcoded constants.
  static const int _defaultTurnDuration = 60;
  static const int _defaultWarningThreshold = 10;
  static const int _defaultCriticalThreshold = 5;
  static const String _defaultDifficulty = 'easy';
  static const String _defaultThemeMode = 'dark';
  static const bool _defaultMuteState = false;

  /// The GetStorage instance for this box.
  ///
  /// Requires `GetStorage.init('TacticalGridSettings')` to have been
  /// called before this service is constructed (typically in `main.dart`).
  final GetStorage _storage = GetStorage(_boxName);

  // ---------------------------------------------------------------------------
  // Turn Duration
  // ---------------------------------------------------------------------------

  /// Loads the persisted turn duration in seconds.
  int loadTurnDuration() =>
      _storage.read<int>(_keyTurnDuration) ?? _defaultTurnDuration;

  /// Saves the turn duration in seconds.
  void saveTurnDuration(int value) => _storage.write(_keyTurnDuration, value);

  // ---------------------------------------------------------------------------
  // Warning Threshold
  // ---------------------------------------------------------------------------

  /// Loads the persisted warning threshold in seconds.
  int loadWarningThreshold() =>
      _storage.read<int>(_keyWarningThreshold) ?? _defaultWarningThreshold;

  /// Saves the warning threshold in seconds.
  void saveWarningThreshold(int value) =>
      _storage.write(_keyWarningThreshold, value);

  // ---------------------------------------------------------------------------
  // Critical Threshold
  // ---------------------------------------------------------------------------

  /// Loads the persisted critical threshold in seconds.
  int loadCriticalThreshold() =>
      _storage.read<int>(_keyCriticalThreshold) ?? _defaultCriticalThreshold;

  /// Saves the critical threshold in seconds.
  void saveCriticalThreshold(int value) =>
      _storage.write(_keyCriticalThreshold, value);

  // ---------------------------------------------------------------------------
  // Default Difficulty
  // ---------------------------------------------------------------------------

  /// Loads the persisted default AI difficulty as a string name.
  String loadDefaultDifficulty() =>
      _storage.read<String>(_keyDefaultDifficulty) ?? _defaultDifficulty;

  /// Saves the default AI difficulty as a string name.
  void saveDefaultDifficulty(String value) =>
      _storage.write(_keyDefaultDifficulty, value);

  // ---------------------------------------------------------------------------
  // Theme Mode
  // ---------------------------------------------------------------------------

  /// Loads the persisted theme mode as a string ('dark' or 'light').
  String loadThemeMode() =>
      _storage.read<String>(_keyThemeMode) ?? _defaultThemeMode;

  /// Saves the theme mode as a string ('dark' or 'light').
  void saveThemeMode(String value) => _storage.write(_keyThemeMode, value);

  // ---------------------------------------------------------------------------
  // Mute State
  // ---------------------------------------------------------------------------

  /// Loads the persisted master mute state.
  bool loadMuteState() =>
      _storage.read<bool>(_keyMuteState) ?? _defaultMuteState;

  /// Saves the master mute state.
  void saveMuteState(bool value) => _storage.write(_keyMuteState, value);

  // ---------------------------------------------------------------------------
  // Reset
  // ---------------------------------------------------------------------------

  /// Erases all persisted settings keys, restoring defaults on next load.
  void resetToDefaults() {
    _storage.remove(_keyTurnDuration);
    _storage.remove(_keyWarningThreshold);
    _storage.remove(_keyCriticalThreshold);
    _storage.remove(_keyDefaultDifficulty);
    _storage.remove(_keyThemeMode);
    _storage.remove(_keyMuteState);
  }
}
