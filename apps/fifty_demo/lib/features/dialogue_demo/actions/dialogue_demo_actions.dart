/// Dialogue Demo Actions
///
/// Handles user interactions for the dialogue demo feature.
library;

import '../service/dialogue_orchestrator.dart';

/// Actions for the dialogue demo feature.
///
/// Provides dialogue playback and control actions.
class DialogueDemoActions {
  DialogueDemoActions({
    required DialogueOrchestrator orchestrator,
  }) : _orchestrator = orchestrator;

  final DialogueOrchestrator _orchestrator;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the demo.
  Future<void> onInitialize() async {
    await _orchestrator.initialize();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Playback Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when play button is tapped.
  Future<void> onPlayTapped() async {
    await _orchestrator.startDialogue();
  }

  /// Called when dialogue area is tapped (advance).
  Future<void> onDialogueTapped() async {
    if (_orchestrator.isProcessing) {
      _orchestrator.skipTyping();
    } else {
      await _orchestrator.advanceDialogue();
    }
  }

  /// Called when next button is tapped.
  Future<void> onNextTapped() async {
    await _orchestrator.advanceDialogue();
  }

  /// Called when previous button is tapped.
  Future<void> onPreviousTapped() async {
    await _orchestrator.previousDialogue();
  }

  /// Called when skip button is tapped.
  void onSkipTapped() {
    _orchestrator.skipTyping();
  }

  /// Called when stop button is tapped.
  void onStopTapped() {
    _orchestrator.stopDialogue();
  }

  /// Called when reset button is tapped.
  void onResetTapped() {
    _orchestrator.resetDialogue();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Settings Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when TTS toggle is tapped.
  void onToggleTts() {
    _orchestrator.toggleTts();
  }

  /// Called when auto-advance toggle is tapped.
  void onToggleAutoAdvance() {
    _orchestrator.toggleAutoAdvance();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // STT Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when mic button is tapped.
  Future<void> onMicTapped() async {
    if (_orchestrator.sttListening) {
      await _orchestrator.stopListening();
    } else {
      await _orchestrator.startListening();
    }
  }

  /// Called when voice input is received.
  void onVoiceInput(String text) {
    _orchestrator.processVoiceCommand(text);
  }
}
