/// ViewModel for the Speech Demo feature.
///
/// Exposes speech engine state for the view to observe.
/// All state changes flow through the SpeechService.
library;

import 'package:flutter/foundation.dart';

import '../service/speech_service.dart';

/// ViewModel for speech demo feature.
///
/// Provides a reactive interface to the SpeechService state.
class SpeechDemoViewModel extends ChangeNotifier {
  SpeechDemoViewModel({
    required SpeechService speechService,
  }) : _speechService = speechService {
    _speechService.addListener(_onServiceChanged);
  }

  final SpeechService _speechService;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization State
  // ─────────────────────────────────────────────────────────────────────────

  /// Whether the speech service is initialized.
  bool get isInitialized => _speechService.isInitialized;

  // ─────────────────────────────────────────────────────────────────────────
  // Speech State
  // ─────────────────────────────────────────────────────────────────────────

  /// Current speech state (idle, speaking, listening, processing).
  SpeechState get state => _speechService.state;

  /// Whether TTS is currently speaking.
  bool get isSpeaking => _speechService.isSpeaking;

  /// Whether STT is currently listening.
  bool get isListening => _speechService.isListening;

  /// Whether STT is processing results.
  bool get isProcessing => _speechService.isProcessing;

  /// Whether any speech operation is active.
  bool get isActive => isSpeaking || isListening || isProcessing;

  // ─────────────────────────────────────────────────────────────────────────
  // Language
  // ─────────────────────────────────────────────────────────────────────────

  /// Current language for TTS and STT.
  SpeechLanguage get language => _speechService.language;

  /// List of all available languages.
  List<SpeechLanguage> get availableLanguages => SpeechLanguage.values;

  // ─────────────────────────────────────────────────────────────────────────
  // STT Results
  // ─────────────────────────────────────────────────────────────────────────

  /// Last recognized text from STT.
  String get recognizedText => _speechService.recognizedText;

  /// Partial text being recognized (live).
  String get partialText => _speechService.partialText;

  /// Text to display (partial while listening, recognized otherwise).
  String get displayText =>
      isListening ? partialText : recognizedText;

  /// Whether there is recognized text to display.
  bool get hasRecognizedText => recognizedText.isNotEmpty;

  // ─────────────────────────────────────────────────────────────────────────
  // Error State
  // ─────────────────────────────────────────────────────────────────────────

  /// Last error message (if any).
  String? get lastError => _speechService.lastError;

  /// Whether there is an error to display.
  bool get hasError => lastError != null && lastError!.isNotEmpty;

  // ─────────────────────────────────────────────────────────────────────────
  // Settings
  // ─────────────────────────────────────────────────────────────────────────

  /// Whether continuous listening is enabled.
  bool get continuousListening => _speechService.continuousListening;

  // ─────────────────────────────────────────────────────────────────────────
  // Status Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Status label for current state.
  String get statusLabel {
    switch (state) {
      case SpeechState.idle:
        return 'READY';
      case SpeechState.speaking:
        return 'SPEAKING';
      case SpeechState.listening:
        return 'LISTENING';
      case SpeechState.processing:
        return 'PROCESSING';
    }
  }

  /// Status label for TTS panel.
  String get ttsStatusLabel => isSpeaking ? 'SPEAKING' : 'READY';

  /// Status label for STT panel.
  String get sttStatusLabel {
    if (isListening) return 'LISTENING';
    if (isProcessing) return 'PROCESSING';
    return 'READY';
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Listener
  // ─────────────────────────────────────────────────────────────────────────

  void _onServiceChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _speechService.removeListener(_onServiceChanged);
    super.dispose();
  }
}
