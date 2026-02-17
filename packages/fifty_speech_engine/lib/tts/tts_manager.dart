import 'dart:developer';
import 'dart:ui';
import 'package:flutter_tts/flutter_tts.dart';

/// **TtsManager - Text-to-Speech (TTS) handler**
///
/// Encapsulates all logic related to voice synthesis using [FlutterTts].
/// This class is designed to be **developer-controlled**, meaning:
/// - No user-selectable voice menu
/// - Predefined voice and language settings per game
///
/// **Key Responsibilities:**
/// - Initialize and configure the TTS engine
/// - Speak text aloud with configured pitch, speed, volume
/// - Handle completion and cancellation callbacks
/// - Expose speaking status via [isSpeaking]
///
/// **Usage Example:**
/// ```dart
/// final tts = TtsManager();
/// await tts.initialize(language: 'en-US');
/// await tts.speak("Welcome to the dungeon.");
/// ```
///
/// Part of the [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).
class TtsManager {
  /// Internal Flutter TTS instance
  final FlutterTts _tts = FlutterTts();

  /// Flag indicating whether TTS is actively speaking
  bool _isSpeaking = false;

  /// Optional callback triggered when speech completes
  VoidCallback? onSpeechComplete;

  // ────────────────────────────────────────────────────────────────────────────────
  // Initialization & Configuration
  // ────────────────────────────────────────────────────────────────────────────────

  /// Initializes the TTS engine with language and voice settings
  ///
  /// - [language]: e.g. `'en-US'`, `'fr-FR'`
  /// - [voiceId]: Optional voice override (must match platform voice)
  Future<void> initialize({
    String language = 'en-US',
    String? voiceId,
  }) async {
    await _tts.setLanguage(language);
    await _tts.awaitSpeakCompletion(true);

    if (voiceId != null) {
      await _tts.setVoice({"name": voiceId, "locale": language});
    }

    _tts.setCompletionHandler(() {
      _isSpeaking = false;
      onSpeechComplete?.call();
    });

    _tts.setCancelHandler(() {
      _isSpeaking = false;
    });

    _tts.setErrorHandler((msg) {
      _isSpeaking = false;
      log('TTS Error: $msg');
    });

    await _tts.setVolume(1.0);
    await _tts.setSpeechRate(0.5);
    await _tts.setPitch(1.0);
  }

  // ────────────────────────────────────────────────────────────────────────────────
  // Speaking
  // ────────────────────────────────────────────────────────────────────────────────

  /// Speaks the given [text] aloud
  ///
  /// - Automatically stops any existing speech first
  /// - Updates [isSpeaking] flag
  Future<void> speak(String text) async {
    await stop(); // ensure no overlap
    _isSpeaking = true;
    await _tts.speak(text);
  }

  /// Immediately stops any ongoing speech
  Future<void> stop() async {
    if (_isSpeaking) {
      await _tts.stop();
      _isSpeaking = false;
    }
  }

  /// Changes the current TTS language and optionally sets a voice override
  ///
  /// Can be used to dynamically switch languages in multilingual games.
  Future<void> changeLanguage(String language, {String? voiceId}) async {
    await _tts.setLanguage(language);
    if (voiceId != null) {
      await _tts.setVoice({"name": voiceId, "locale": language});
    }
  }

  // ────────────────────────────────────────────────────────────────────────────────
  // Utilities
  // ────────────────────────────────────────────────────────────────────────────────

  /// Whether the TTS engine is currently speaking
  bool get isSpeaking => _isSpeaking;

  /// Cleans up and stops any ongoing speech
  void dispose() {
    stop();
  }
}
