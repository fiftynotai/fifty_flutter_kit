/// Speech service that wraps FiftySpeechEngine for the example app.
///
/// Provides a high-level interface for TTS and STT operations
/// with state management and event notifications.
library;

import 'dart:ui';

import 'package:fifty_speech_engine/fifty_speech_engine.dart';
import 'package:flutter/foundation.dart';

/// Supported speech languages for the demo.
enum SpeechLanguage {
  englishUS('en', 'US', 'English (US)'),
  englishUK('en', 'GB', 'English (UK)'),
  spanish('es', 'ES', 'Spanish'),
  french('fr', 'FR', 'French'),
  german('de', 'DE', 'German'),
  italian('it', 'IT', 'Italian'),
  japanese('ja', 'JP', 'Japanese'),
  korean('ko', 'KR', 'Korean'),
  chinese('zh', 'CN', 'Chinese');

  const SpeechLanguage(this.languageCode, this.countryCode, this.displayName);

  final String languageCode;
  final String countryCode;
  final String displayName;

  Locale get locale => Locale(languageCode, countryCode);

  String get localeId => '${languageCode}_$countryCode';
}

/// Current speech engine state.
enum SpeechState {
  idle,
  speaking,
  listening,
  processing,
}

/// Speech service singleton for TTS and STT operations.
class SpeechService extends ChangeNotifier {
  SpeechService();

  /// The underlying speech engine.
  FiftySpeechEngine? _engine;

  /// Whether the service is initialized.
  bool _initialized = false;
  bool get isInitialized => _initialized;

  /// Current speech state.
  SpeechState _state = SpeechState.idle;
  SpeechState get state => _state;

  /// Whether currently speaking.
  bool get isSpeaking => _state == SpeechState.speaking;

  /// Whether currently listening.
  bool get isListening => _state == SpeechState.listening;

  /// Whether processing (between listen and result).
  bool get isProcessing => _state == SpeechState.processing;

  /// Current language for TTS and STT.
  SpeechLanguage _language = SpeechLanguage.englishUS;
  SpeechLanguage get language => _language;

  /// Last recognized text from STT.
  String _recognizedText = '';
  String get recognizedText => _recognizedText;

  /// Partial text being recognized.
  String _partialText = '';
  String get partialText => _partialText;

  /// Last error message (if any).
  String? _lastError;
  String? get lastError => _lastError;

  /// Whether continuous listening is enabled.
  bool _continuousListening = true;
  bool get continuousListening => _continuousListening;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the speech engine with the current language.
  Future<void> initialize() async {
    if (_initialized) return;

    debugPrint('SpeechService: Initializing...');

    _engine = FiftySpeechEngine(
      locale: _language.locale,
      onSttResult: _handleSttResult,
      onSttError: _handleSttError,
    );

    await _engine!.initialize();
    _initialized = true;
    _lastError = null;

    debugPrint('SpeechService: Initialized successfully');
    notifyListeners();
  }

  /// Changes the current language.
  ///
  /// Re-initializes the engine with the new locale.
  Future<void> setLanguage(SpeechLanguage newLanguage) async {
    if (_language == newLanguage) return;

    debugPrint('SpeechService: Changing language to ${newLanguage.displayName}');

    // Stop any ongoing operations
    await stopSpeaking();
    await stopListening();

    _language = newLanguage;

    // Re-initialize with new language
    if (_initialized) {
      _engine?.dispose();
      _initialized = false;
      await initialize();
    }

    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TTS Operations
  // ─────────────────────────────────────────────────────────────────────────

  /// Speaks the given text using TTS.
  Future<void> speak(String text) async {
    if (!_initialized || text.isEmpty) return;

    debugPrint('SpeechService: Speaking "$text"');

    // Stop listening if active
    if (isListening) {
      await stopListening();
    }

    _state = SpeechState.speaking;
    _lastError = null;
    notifyListeners();

    try {
      await _engine!.speak(text);

      // Wait for speech to complete
      // TTS manager sets isSpeaking to false on completion
      while (_engine!.isSpeaking) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      _state = SpeechState.idle;
    } catch (e) {
      debugPrint('SpeechService: Speak error - $e');
      _lastError = 'Failed to speak: $e';
      _state = SpeechState.idle;
    }

    notifyListeners();
  }

  /// Stops any ongoing TTS playback.
  Future<void> stopSpeaking() async {
    if (!_initialized || !isSpeaking) return;

    debugPrint('SpeechService: Stopping speech');

    await _engine!.stopSpeaking();
    _state = SpeechState.idle;
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // STT Operations
  // ─────────────────────────────────────────────────────────────────────────

  /// Starts listening for speech input.
  Future<void> startListening() async {
    if (!_initialized || isListening) return;

    debugPrint('SpeechService: Starting to listen');

    // Stop speaking if active
    if (isSpeaking) {
      await stopSpeaking();
    }

    _state = SpeechState.listening;
    _partialText = '';
    _lastError = null;
    notifyListeners();

    try {
      await _engine!.startListening(continuous: _continuousListening);
    } catch (e) {
      debugPrint('SpeechService: Listen error - $e');
      _lastError = 'Failed to start listening: $e';
      _state = SpeechState.idle;
      notifyListeners();
    }
  }

  /// Stops listening and processes the final result.
  Future<void> stopListening() async {
    if (!_initialized || !isListening) return;

    debugPrint('SpeechService: Stopping listen');

    _state = SpeechState.processing;
    notifyListeners();

    await _engine!.stopListening();

    _state = SpeechState.idle;
    notifyListeners();
  }

  /// Cancels listening without processing results.
  Future<void> cancelListening() async {
    if (!_initialized) return;

    debugPrint('SpeechService: Cancelling listen');

    await _engine!.cancelListening();
    _state = SpeechState.idle;
    _partialText = '';
    notifyListeners();
  }

  /// Toggles continuous listening mode.
  void toggleContinuousListening() {
    _continuousListening = !_continuousListening;
    debugPrint('SpeechService: Continuous listening = $_continuousListening');
    notifyListeners();
  }

  /// Clears the recognized text.
  void clearRecognizedText() {
    _recognizedText = '';
    _partialText = '';
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Event Handlers
  // ─────────────────────────────────────────────────────────────────────────

  /// Handles STT recognition results.
  Future<void> _handleSttResult(String text) async {
    debugPrint('SpeechService: STT result - "$text"');

    _partialText = text;
    _recognizedText = text;
    notifyListeners();
  }

  /// Handles STT errors.
  void _handleSttError(String error) {
    debugPrint('SpeechService: STT error - $error');

    _lastError = error;
    _state = SpeechState.idle;
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Cleanup
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    debugPrint('SpeechService: Disposing');
    _engine?.dispose();
    super.dispose();
  }
}
