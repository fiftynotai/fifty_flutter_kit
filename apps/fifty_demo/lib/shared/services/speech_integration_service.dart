/// Speech Integration Service
///
/// Wraps the fifty_speech_engine for use in the demo app.
/// Provides TTS and STT functionality.
library;

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

/// Service for speech integration.
///
/// Manages text-to-speech (TTS) and speech-to-text (STT).
class SpeechIntegrationService extends GetxController {
  SpeechIntegrationService();

  bool _initialized = false;
  bool _ttsPlaying = false;
  bool _sttListening = false;
  String _recognizedText = '';
  double _speechRate = 0.5;
  double _pitch = 1.0;
  String _language = 'en-US';

  // ─────────────────────────────────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────────────────────────────────

  bool get isInitialized => _initialized;
  bool get ttsPlaying => _ttsPlaying;
  bool get sttListening => _sttListening;
  String get recognizedText => _recognizedText;
  double get speechRate => _speechRate;
  double get pitch => _pitch;
  String get language => _language;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the speech service.
  Future<void> initialize() async {
    if (_initialized) return;

    // In a real implementation, initialize TTS/STT engines here
    _initialized = true;
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TTS Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Speaks the given text using TTS.
  Future<void> speak(String text) async {
    if (!_initialized) return;

    _ttsPlaying = true;
    update();

    // Simulate TTS playback
    debugPrint('TTS Speaking: $text');

    // In a real implementation, use fifty_speech_engine TTS
    await Future<void>.delayed(Duration(milliseconds: text.length * 50));

    _ttsPlaying = false;
    update();
  }

  /// Stops TTS playback.
  Future<void> stopSpeaking() async {
    _ttsPlaying = false;
    update();
  }

  /// Sets the TTS speech rate.
  void setSpeechRate(double rate) {
    _speechRate = rate.clamp(0.0, 1.0);
    update();
  }

  /// Sets the TTS pitch.
  void setPitch(double pitch) {
    _pitch = pitch.clamp(0.5, 2.0);
    update();
  }

  /// Sets the TTS language.
  void setLanguage(String language) {
    _language = language;
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // STT Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Starts listening for speech input.
  Future<void> startListening() async {
    if (!_initialized || _sttListening) return;

    _sttListening = true;
    _recognizedText = '';
    update();

    debugPrint('STT Listening started');
  }

  /// Stops listening for speech input.
  Future<void> stopListening() async {
    _sttListening = false;
    update();

    debugPrint('STT Listening stopped');
  }

  /// Simulates recognized speech (for demo purposes).
  void simulateRecognition(String text) {
    _recognizedText = text;
    update();
  }

  /// Clears the recognized text.
  void clearRecognizedText() {
    _recognizedText = '';
    update();
  }
}
