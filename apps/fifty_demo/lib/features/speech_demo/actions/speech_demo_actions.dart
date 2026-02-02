/// Speech Demo Actions
///
/// Handles user interactions for the speech demo feature.
/// Uses real fifty_speech_engine for TTS and STT operations.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../controllers/speech_demo_view_model.dart';

/// Actions for the speech demo feature.
///
/// Provides TTS and STT control actions using real speech engine.
class SpeechDemoActions {
  /// Creates speech demo actions with required dependencies.
  SpeechDemoActions(this._viewModel, this._presenter);

  final SpeechDemoViewModel _viewModel;
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static SpeechDemoActions get instance => Get.find<SpeechDemoActions>();

  // ---------------------------------------------------------------------------
  // TTS Actions
  // ---------------------------------------------------------------------------

  /// Called when TTS toggle is changed.
  void onTtsToggled({required bool enabled}) {
    _viewModel.setTtsEnabled(enabled: enabled);
  }

  /// Called when speak button is tapped.
  Future<void> onSpeakTapped(BuildContext context, String text) async {
    if (text.isEmpty) {
      _presenter.showErrorSnackBar(
        context,
        'Error',
        'Please enter text to speak',
      );
      return;
    }

    await _viewModel.speak(text);

    // Check for errors after speaking
    if (_viewModel.errorMessage.isNotEmpty) {
      if (context.mounted) {
        _presenter.showErrorSnackBar(
          context,
          'TTS Error',
          _viewModel.errorMessage,
        );
      }
    }
  }

  /// Called when stop speaking button is tapped.
  Future<void> onStopSpeakingTapped() async {
    await _viewModel.stopSpeaking();
  }

  /// Called when a preset phrase is tapped.
  Future<void> onPresetPhraseTapped(BuildContext context, String phrase) async {
    _viewModel.setCurrentText(phrase);
    await _viewModel.speak(phrase);

    // Check for errors after speaking
    if (_viewModel.errorMessage.isNotEmpty && context.mounted) {
      _presenter.showErrorSnackBar(
        context,
        'TTS Error',
        _viewModel.errorMessage,
      );
    }
  }

  /// Called when speech rate slider changes.
  void onSpeechRateChanged(double value) {
    _viewModel.setSpeechRate(value);
  }

  /// Called when pitch slider changes.
  void onPitchChanged(double value) {
    _viewModel.setPitch(value);
  }

  /// Called when volume slider changes.
  void onVolumeChanged(double value) {
    _viewModel.setVolume(value);
  }

  /// Called when text input changes.
  void onTextChanged(String text) {
    _viewModel.setCurrentText(text);
  }

  /// Called when reset settings button is tapped.
  void onResetSettingsTapped() {
    _viewModel.resetVoiceSettings();
  }

  // ---------------------------------------------------------------------------
  // STT Actions
  // ---------------------------------------------------------------------------

  /// Called when STT toggle is changed.
  void onSttToggled({required bool enabled}) {
    _viewModel.setSttEnabled(enabled: enabled);
  }

  /// Called when microphone button is tapped.
  Future<void> onMicTapped(BuildContext context) async {
    // Check STT availability first
    if (!_viewModel.sttAvailable) {
      _presenter.showErrorSnackBar(
        context,
        'STT Unavailable',
        'Speech recognition is not available on this device',
      );
      return;
    }

    if (_viewModel.isListening) {
      await _viewModel.stopListening();
    } else {
      final success = await _viewModel.startListening();

      if (!success && context.mounted) {
        _presenter.showErrorSnackBar(
          context,
          'STT Error',
          _viewModel.errorMessage.isNotEmpty
              ? _viewModel.errorMessage
              : 'Failed to start listening',
        );
      }
    }
  }

  /// Called when confidence threshold slider changes.
  void onConfidenceThresholdChanged(double value) {
    _viewModel.setConfidenceThreshold(value);
  }

  /// Called when clear history button is tapped.
  void onClearHistoryTapped() {
    _viewModel.clearHistory();
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  /// Goes back to previous screen.
  void onBackTapped() {
    _presenter.back();
  }
}
