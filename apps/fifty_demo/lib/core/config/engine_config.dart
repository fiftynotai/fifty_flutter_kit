/// Engine Configuration
///
/// Configuration constants for Fifty engine initialization.
library;

/// Audio engine configuration.
abstract class AudioEngineConfig {
  /// Default BGM volume.
  static const double defaultBgmVolume = 0.7;

  /// Default SFX volume.
  static const double defaultSfxVolume = 0.8;

  /// Default voice volume.
  static const double defaultVoiceVolume = 0.9;

  /// Enable voice ducking by default.
  static const bool enableVoiceDucking = true;
}

/// Speech engine configuration.
abstract class SpeechEngineConfig {
  /// Default TTS speech rate.
  static const double defaultSpeechRate = 0.5;

  /// Default TTS pitch.
  static const double defaultPitch = 1.0;

  /// Default TTS volume.
  static const double defaultVolume = 1.0;

  /// Default language code.
  static const String defaultLanguage = 'en-US';
}

/// Sentences engine configuration.
abstract class SentencesEngineConfig {
  /// Default typing speed (ms per character).
  static const int typingSpeedMs = 30;

  /// Default pause between sentences (ms).
  static const int sentencePauseMs = 500;

  /// Enable auto-advance by default.
  static const bool enableAutoAdvance = false;
}

/// Map engine configuration.
abstract class MapEngineConfig {
  /// Default grid cell size.
  static const double defaultCellSize = 64.0;

  /// Default camera zoom level.
  static const double defaultZoom = 1.0;

  /// Minimum zoom level.
  static const double minZoom = 0.5;

  /// Maximum zoom level.
  static const double maxZoom = 3.0;

  /// Enable smooth camera transitions.
  static const bool enableSmoothCamera = true;
}
