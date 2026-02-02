/// Speech Integration Service
///
/// Wraps the fifty_speech_engine for use in the demo app.
/// Provides real TTS and STT functionality.
library;

import 'dart:ui';
import 'package:fifty_speech_engine/fifty_speech_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Service for speech integration.
///
/// Manages text-to-speech (TTS) and speech-to-text (STT) using
/// the real [FiftySpeechEngine] from fifty_speech_engine package.
class SpeechIntegrationService extends GetxController {
  SpeechIntegrationService();

  /// The speech engine instance.
  FiftySpeechEngine? _engine;

  bool _initialized = false;
  bool _sttAvailable = false;
  String _recognizedText = '';
  String _errorMessage = '';
  String _language = 'en-US';
  Locale _locale = const Locale('en', 'US');

  /// Callback for STT results (partial and final).
  void Function(String text, bool isFinal)? onSttResult;

  /// Callback for STT errors.
  void Function(String error)? onSttError;

  /// Callback for TTS completion.
  VoidCallback? onTtsComplete;

  // ─────────────────────────────────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────────────────────────────────

  bool get isInitialized => _initialized;
  bool get sttAvailable => _sttAvailable;
  bool get ttsPlaying => _engine?.isSpeaking ?? false;
  bool get sttListening => _engine?.isListening ?? false;
  String get recognizedText => _recognizedText;
  String get errorMessage => _errorMessage;
  String get language => _language;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the speech service with real engine.
  Future<bool> initialize() async {
    if (_initialized) return true;

    _errorMessage = '';

    try {
      // Create the engine with callbacks
      _engine = FiftySpeechEngine(
        locale: _locale,
        onSttResult: _handleSttResult,
        onSttError: _handleSttError,
      );

      // Set up TTS completion callback
      _engine!.tts.onSpeechComplete = () {
        onTtsComplete?.call();
        update();
      };

      // Initialize both TTS and STT
      await _engine!.initialize();

      // Check STT availability
      _sttAvailable = _engine!.stt.isAvailable;

      _initialized = true;

      if (kDebugMode) {
        debugPrint('[SpeechIntegrationService] Initialized successfully');
        debugPrint('[SpeechIntegrationService] STT available: $_sttAvailable');
      }
    } catch (e) {
      _errorMessage = 'Failed to initialize speech engine: $e';
      if (kDebugMode) {
        debugPrint('[SpeechIntegrationService] Error: $_errorMessage');
      }
      return false;
    }

    update();
    return true;
  }

  /// Handles STT recognition results.
  Future<void> _handleSttResult(String text) async {
    _recognizedText = text;
    // Notify listeners (isFinal is approximated - engine doesn't distinguish)
    onSttResult?.call(text, !sttListening);
    update();
  }

  /// Handles STT errors.
  void _handleSttError(String error) {
    _errorMessage = error;
    onSttError?.call(error);
    if (kDebugMode) {
      debugPrint('[SpeechIntegrationService] STT Error: $error');
    }
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TTS Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Speaks the given text using TTS.
  Future<void> speak(String text) async {
    if (!_initialized || _engine == null) {
      _errorMessage = 'Speech engine not initialized';
      update();
      return;
    }

    _errorMessage = '';

    try {
      if (kDebugMode) {
        debugPrint('[SpeechIntegrationService] Speaking: $text');
      }
      update(); // Update UI before speaking starts
      await _engine!.speak(text);
    } catch (e) {
      _errorMessage = 'TTS error: $e';
      if (kDebugMode) {
        debugPrint('[SpeechIntegrationService] TTS Error: $e');
      }
    }

    update();
  }

  /// Stops TTS playback.
  Future<void> stopSpeaking() async {
    if (_engine == null) return;

    try {
      await _engine!.stopSpeaking();
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[SpeechIntegrationService] Stop speaking error: $e');
      }
    }
    update();
  }

  /// Sets the TTS language.
  Future<void> setLanguage(String language) async {
    _language = language;

    // Parse language code (e.g., 'en-US' -> Locale('en', 'US'))
    final parts = language.split('-');
    if (parts.length == 2) {
      _locale = Locale(parts[0], parts[1]);
    } else {
      _locale = Locale(language);
    }

    // If already initialized, update the engine
    if (_engine != null) {
      try {
        await _engine!.tts.changeLanguage(language);
      } catch (e) {
        if (kDebugMode) {
          debugPrint('[SpeechIntegrationService] Language change error: $e');
        }
      }
    }

    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // STT Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Starts listening for speech input.
  Future<bool> startListening({bool continuous = false}) async {
    if (!_initialized || _engine == null) {
      _errorMessage = 'Speech engine not initialized';
      update();
      return false;
    }

    if (!_sttAvailable) {
      _errorMessage = 'Speech recognition not available on this device';
      update();
      return false;
    }

    if (sttListening) return true;

    _errorMessage = '';
    _recognizedText = '';

    try {
      if (kDebugMode) {
        debugPrint('[SpeechIntegrationService] Starting listening (continuous: $continuous)');
      }
      await _engine!.startListening(continuous: continuous);
      update();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to start listening: $e';
      if (kDebugMode) {
        debugPrint('[SpeechIntegrationService] Start listening error: $e');
      }
      update();
      return false;
    }
  }

  /// Stops listening for speech input.
  Future<void> stopListening() async {
    if (_engine == null || !sttListening) return;

    try {
      await _engine!.stopListening();
      if (kDebugMode) {
        debugPrint('[SpeechIntegrationService] Stopped listening');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[SpeechIntegrationService] Stop listening error: $e');
      }
    }
    update();
  }

  /// Cancels listening without returning a result.
  Future<void> cancelListening() async {
    if (_engine == null || !sttListening) return;

    try {
      await _engine!.cancelListening();
      _recognizedText = '';
    } catch (e) {
      if (kDebugMode) {
        debugPrint('[SpeechIntegrationService] Cancel listening error: $e');
      }
    }
    update();
  }

  /// Clears the recognized text.
  void clearRecognizedText() {
    _recognizedText = '';
    _errorMessage = '';
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Cleanup
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void onClose() {
    _engine?.dispose();
    _engine = null;
    _initialized = false;
    super.onClose();
  }
}
