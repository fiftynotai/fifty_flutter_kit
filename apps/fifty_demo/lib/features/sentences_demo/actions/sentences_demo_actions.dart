/// Sentences Demo Actions
///
/// Handles user interactions for the sentences demo feature.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../controllers/sentences_demo_view_model.dart';

/// Actions for the sentences demo feature.
///
/// Provides playback controls and navigation actions.
class SentencesDemoActions {
  /// Creates sentences demo actions with required dependencies.
  SentencesDemoActions(this._viewModel, this._presenter);

  final SentencesDemoViewModel _viewModel;
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static SentencesDemoActions get instance =>
      Get.find<SentencesDemoActions>();

  // ---------------------------------------------------------------------------
  // Dialogue Selection
  // ---------------------------------------------------------------------------

  /// Called when a dialogue is selected.
  void onDialogueSelected(BuildContext context, String dialogueName) {
    _viewModel.selectDialogue(dialogueName);
    _presenter.showSuccessSnackBar(
      context,
      'Dialogue Loaded',
      'Loaded "$dialogueName" dialogue',
    );
  }

  // ---------------------------------------------------------------------------
  // Playback Actions
  // ---------------------------------------------------------------------------

  /// Called when play button is tapped.
  void onPlayTapped() {
    _viewModel.play();
  }

  /// Called when pause button is tapped.
  void onPauseTapped() {
    _viewModel.pause();
  }

  /// Called when play/pause toggle is tapped.
  void onPlayPauseTapped() {
    _viewModel.togglePlayPause();
  }

  /// Called when next button is tapped.
  void onNextTapped() {
    _viewModel.next();
  }

  /// Called when previous button is tapped.
  void onPreviousTapped() {
    _viewModel.previous();
  }

  /// Called when dialogue display is tapped.
  void onDialogueTapped() {
    _viewModel.onDialogueTap();
  }

  /// Called when a sentence in the queue is tapped.
  void onSentenceTapped(int index) {
    _viewModel.jumpToSentence(index);
  }

  // ---------------------------------------------------------------------------
  // Reset Actions
  // ---------------------------------------------------------------------------

  /// Called when reset button is tapped.
  void onResetTapped(BuildContext context) {
    _viewModel.reset();
    _presenter.showSuccessSnackBar(
      context,
      'Reset Complete',
      'Dialogue has been reset to the beginning.',
    );
  }

  /// Called when clear button is tapped.
  Future<void> onClearTapped(BuildContext context) async {
    final confirmed = await _presenter.showConfirmationDialog(
      context,
      'Clear the entire sentence queue?',
    );
    if (confirmed && context.mounted) {
      _viewModel.clearQueue();
      _presenter.showSuccessSnackBar(
        context,
        'Queue Cleared',
        'All sentences have been removed.',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  /// Goes back to previous screen.
  void onBackTapped() {
    _presenter.back();
  }
}
