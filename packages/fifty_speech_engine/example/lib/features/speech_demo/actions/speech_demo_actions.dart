/// Actions for the Speech Demo feature.
///
/// Handles user interactions and delegates to the speech service.
/// Following MVVM + Actions pattern: View -> Actions -> ViewModel/Service.
library;

import '../service/speech_service.dart';

/// Actions for speech demo interactions.
///
/// Provides a clear separation between UI events and business logic.
class SpeechDemoActions {
  SpeechDemoActions({
    required SpeechService speechService,
  }) : _speechService = speechService;

  final SpeechService _speechService;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the speech service.
  Future<void> onInitialize() async {
    await _speechService.initialize();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TTS Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when the speak button is tapped.
  Future<void> onSpeakTapped(String text) async {
    if (text.isEmpty) return;
    await _speechService.speak(text);
  }

  /// Called when the stop speaking button is tapped.
  Future<void> onStopSpeakingTapped() async {
    await _speechService.stopSpeaking();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // STT Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when the listen button is tapped.
  ///
  /// Toggles listening state.
  Future<void> onListenTapped() async {
    if (_speechService.isListening) {
      await _speechService.stopListening();
    } else {
      await _speechService.startListening();
    }
  }

  /// Called when the stop listening button is tapped.
  Future<void> onStopListeningTapped() async {
    await _speechService.stopListening();
  }

  /// Called when the cancel listening button is tapped.
  Future<void> onCancelListeningTapped() async {
    await _speechService.cancelListening();
  }

  /// Called to clear recognized text.
  void onClearRecognizedText() {
    _speechService.clearRecognizedText();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Language Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when the language is changed.
  Future<void> onLanguageChanged(SpeechLanguage language) async {
    await _speechService.setLanguage(language);
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Settings Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Toggles continuous listening mode.
  void onContinuousListeningToggled() {
    _speechService.toggleContinuousListening();
  }
}
