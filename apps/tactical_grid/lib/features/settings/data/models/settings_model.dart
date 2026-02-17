/// Settings Model
///
/// Immutable data class representing all user-configurable settings
/// for the Tactical Grid application. Includes audio volumes, gameplay
/// defaults, and display preferences.
///
/// **Usage:**
/// ```dart
/// final settings = SettingsModel.defaults();
/// final updated = settings.copyWith(bgmVolume: 0.7);
/// ```
library;

import 'package:flutter/material.dart';

import '../../../battle/models/game_state.dart';

/// Immutable settings data class for Tactical Grid.
///
/// Contains all user-configurable values grouped into three sections:
/// - **Audio:** BGM, SFX, and voice volume levels plus master mute.
/// - **Gameplay:** Default AI difficulty and turn timer configuration.
/// - **Display:** Theme mode preference.
///
/// Use [copyWith] to create modified copies. Use [SettingsModel.defaults]
/// for factory defaults matching the original hardcoded values.
class SettingsModel {
  /// Background music volume (0.0 - 1.0).
  final double bgmVolume;

  /// Sound effects volume (0.0 - 1.0).
  final double sfxVolume;

  /// Voice-over volume (0.0 - 1.0).
  final double voiceVolume;

  /// Whether all audio channels are muted.
  final bool isMuted;

  /// Default AI difficulty for VS AI games.
  final AIDifficulty defaultDifficulty;

  /// Turn timer duration in seconds.
  final int turnDuration;

  /// Seconds remaining when the warning zone starts.
  final int warningThreshold;

  /// Seconds remaining when the critical zone starts.
  final int criticalThreshold;

  /// Application theme mode.
  final ThemeMode themeMode;

  /// Creates a [SettingsModel] with the given values.
  const SettingsModel({
    required this.bgmVolume,
    required this.sfxVolume,
    required this.voiceVolume,
    required this.isMuted,
    required this.defaultDifficulty,
    required this.turnDuration,
    required this.warningThreshold,
    required this.criticalThreshold,
    required this.themeMode,
  });

  /// Factory constructor returning sensible defaults.
  ///
  /// These match the original hardcoded values used throughout the app
  /// before the settings feature was introduced.
  factory SettingsModel.defaults() => const SettingsModel(
        bgmVolume: 0.4,
        sfxVolume: 1.0,
        voiceVolume: 1.0,
        isMuted: false,
        defaultDifficulty: AIDifficulty.easy,
        turnDuration: 60,
        warningThreshold: 10,
        criticalThreshold: 5,
        themeMode: ThemeMode.dark,
      );

  /// Creates a copy with optional field overrides.
  SettingsModel copyWith({
    double? bgmVolume,
    double? sfxVolume,
    double? voiceVolume,
    bool? isMuted,
    AIDifficulty? defaultDifficulty,
    int? turnDuration,
    int? warningThreshold,
    int? criticalThreshold,
    ThemeMode? themeMode,
  }) {
    return SettingsModel(
      bgmVolume: bgmVolume ?? this.bgmVolume,
      sfxVolume: sfxVolume ?? this.sfxVolume,
      voiceVolume: voiceVolume ?? this.voiceVolume,
      isMuted: isMuted ?? this.isMuted,
      defaultDifficulty: defaultDifficulty ?? this.defaultDifficulty,
      turnDuration: turnDuration ?? this.turnDuration,
      warningThreshold: warningThreshold ?? this.warningThreshold,
      criticalThreshold: criticalThreshold ?? this.criticalThreshold,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  @override
  String toString() =>
      'SettingsModel(bgm: $bgmVolume, sfx: $sfxVolume, voice: $voiceVolume, '
      'muted: $isMuted, difficulty: ${defaultDifficulty.name}, '
      'timer: ${turnDuration}s, theme: ${themeMode.name})';
}
