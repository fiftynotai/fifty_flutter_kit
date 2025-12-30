/// Actions for the Sentences Demo feature.
///
/// Handles user interactions and delegates to the sentences service.
/// Following MVVM + Actions pattern: View -> Actions -> ViewModel/Service.
library;

import '../service/sentences_service.dart';

/// Actions for sentences demo interactions.
///
/// Provides a clear separation between UI events and business logic.
class SentencesDemoActions {
  SentencesDemoActions({
    required SentencesService sentencesService,
  }) : _sentencesService = sentencesService;

  final SentencesService _sentencesService;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the sentences service.
  Future<void> onInitialize() async {
    await _sentencesService.initialize();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Queue Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when the "Add Write" button is tapped.
  void onAddWriteTapped() {
    _sentencesService.addWriteSentence();
  }

  /// Called when the "Add Read" button is tapped.
  void onAddReadTapped() {
    _sentencesService.addReadSentence();
  }

  /// Called when the "Add Ask" button is tapped.
  void onAddAskTapped() {
    _sentencesService.addAskSentence();
  }

  /// Called when the "Add Wait" button is tapped.
  void onAddWaitTapped() {
    _sentencesService.addWaitSentence();
  }

  /// Called when the "Clear Queue" button is tapped.
  void onClearQueueTapped() {
    _sentencesService.clearQueue();
  }

  /// Called when the "Clear All" button is tapped.
  void onClearAllTapped() {
    _sentencesService.clearAll();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Processing Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when the "Process" button is tapped.
  Future<void> onProcessTapped() async {
    await _sentencesService.process();
  }

  /// Called when the "Pause" button is tapped.
  void onPauseTapped() {
    _sentencesService.pause();
  }

  /// Called when the "Resume" button is tapped.
  void onResumeTapped() {
    _sentencesService.resume();
  }

  /// Called when the "Cancel" button is tapped.
  void onCancelTapped() {
    _sentencesService.cancel();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // User Input Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when user taps to continue (for wait instruction).
  void onTapToContinue() {
    _sentencesService.continueAfterInput();
  }

  /// Called when user selects a choice (for ask instruction).
  void onChoiceSelected(String choice) {
    _sentencesService.selectChoice(choice);
  }
}
