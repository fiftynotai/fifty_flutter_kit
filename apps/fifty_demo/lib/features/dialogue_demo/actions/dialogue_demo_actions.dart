/// Dialogue Demo Actions
///
/// Handles user interactions for the dialogue demo feature.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../controllers/dialogue_demo_view_model.dart';

/// Actions for the dialogue demo feature.
///
/// Provides dialogue playback and control actions.
class DialogueDemoActions {
  DialogueDemoActions(this._viewModel, this._presenter);

  final DialogueDemoViewModel _viewModel;
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static DialogueDemoActions get instance => Get.find<DialogueDemoActions>();

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the demo.
  Future<void> onInitialize(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      await _viewModel.orchestrator.initialize();
      _viewModel.update();
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Playback Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when play button is tapped.
  Future<void> onPlayTapped(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      await _viewModel.orchestrator.startDialogue();
      _viewModel.update();
    });
  }

  /// Called when dialogue area is tapped (advance).
  Future<void> onDialogueTapped(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      if (_viewModel.orchestrator.isProcessing) {
        _viewModel.orchestrator.skipTyping();
      } else {
        await _viewModel.orchestrator.advanceDialogue();
      }
      _viewModel.update();
    });
  }

  /// Called when next button is tapped.
  Future<void> onNextTapped(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      await _viewModel.orchestrator.advanceDialogue();
      _viewModel.update();
    });
  }

  /// Called when previous button is tapped.
  Future<void> onPreviousTapped(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      await _viewModel.orchestrator.previousDialogue();
      _viewModel.update();
    });
  }

  /// Called when skip button is tapped.
  void onSkipTapped() {
    _viewModel.orchestrator.skipTyping();
    _viewModel.update();
  }

  /// Called when stop button is tapped.
  void onStopTapped() {
    _viewModel.orchestrator.stopDialogue();
    _viewModel.update();
  }

  /// Called when reset button is tapped.
  void onResetTapped() {
    _viewModel.orchestrator.resetDialogue();
    _viewModel.update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Settings Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when TTS toggle is tapped.
  void onToggleTts() {
    _viewModel.orchestrator.toggleTts();
    _viewModel.update();
  }

  /// Called when auto-advance toggle is tapped.
  void onToggleAutoAdvance() {
    _viewModel.orchestrator.toggleAutoAdvance();
    _viewModel.update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // STT Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when mic button is tapped.
  Future<void> onMicTapped(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      if (_viewModel.orchestrator.sttListening) {
        await _viewModel.orchestrator.stopListening();
      } else {
        await _viewModel.orchestrator.startListening();
      }
      _viewModel.update();
    });
  }

  /// Called when voice input is received.
  void onVoiceInput(String text) {
    _viewModel.orchestrator.processVoiceCommand(text);
    _viewModel.update();
  }
}
