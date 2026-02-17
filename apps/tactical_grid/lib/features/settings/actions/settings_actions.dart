/// Settings Actions
///
/// Thin orchestration layer that delegates user interactions from the
/// settings UI to the [SettingsViewModel]. Following the MVVM + Actions
/// architecture pattern, this layer handles UX concerns (type conversions,
/// parameter mapping) while the ViewModel contains the business logic.
///
/// **Usage:**
/// ```dart
/// final actions = Get.find<SettingsActions>();
/// actions.onBgmVolumeChanged(0.7);
/// actions.onResetToDefaults();
/// ```
library;

import 'package:flutter/material.dart';

import '../../battle/models/game_state.dart';
import '../controllers/settings_view_model.dart';

/// Orchestrates settings UI interactions.
///
/// Each method maps a UI event to the corresponding [SettingsViewModel]
/// setter. Slider callbacks receive `double` values which are cast to
/// `int` where needed (turn duration, thresholds).
///
/// **Architecture Note:**
/// This is an ACTIONS layer component. It contains no business logic --
/// only delegation and type conversion. The View calls Actions; Actions
/// call ViewModel.
class SettingsActions {
  /// Creates [SettingsActions].
  ///
  /// [viewModel] is the app-wide [SettingsViewModel] registered in
  /// [InitialBindings].
  SettingsActions(this._viewModel);

  final SettingsViewModel _viewModel;

  /// Called when the BGM volume slider changes.
  void onBgmVolumeChanged(double v) => _viewModel.setBgmVolume(v);

  /// Called when the SFX volume slider changes.
  void onSfxVolumeChanged(double v) => _viewModel.setSfxVolume(v);

  /// Called when the voice volume slider changes.
  void onVoiceVolumeChanged(double v) => _viewModel.setVoiceVolume(v);

  /// Called when the master mute toggle is tapped.
  void onMuteToggled() => _viewModel.toggleMute();

  /// Called when an AI difficulty button is selected.
  void onDifficultyChanged(AIDifficulty d) =>
      _viewModel.setDefaultDifficulty(d);

  /// Called when the turn duration slider changes.
  ///
  /// Converts the slider's `double` value to `int` seconds.
  void onTurnDurationChanged(double v) => _viewModel.setTurnDuration(v.toInt());

  /// Called when the warning threshold slider changes.
  ///
  /// Converts the slider's `double` value to `int` seconds.
  void onWarningThresholdChanged(double v) =>
      _viewModel.setWarningThreshold(v.toInt());

  /// Called when the critical threshold slider changes.
  ///
  /// Converts the slider's `double` value to `int` seconds.
  void onCriticalThresholdChanged(double v) =>
      _viewModel.setCriticalThreshold(v.toInt());

  /// Called when a theme mode option is selected.
  void onThemeModeChanged(ThemeMode m) => _viewModel.setThemeMode(m);

  /// Called when the "Reset to Defaults" button is tapped.
  void onResetToDefaults() => _viewModel.resetToDefaults();
}
