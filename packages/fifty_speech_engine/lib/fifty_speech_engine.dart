import 'dart:ui';
import 'tts/tts_manager.dart';
import 'stt/stt_manager.dart';

// Export widgets
export 'src/widgets/widgets.dart';

/// **FiftySpeechEngine**
///
/// A unified interface that combines both **Text-to-Speech (TTS)** and **Speech-to-Text (STT)**
/// capabilities for games and voice-driven applications.
///
/// Built on top of:
/// - [TtsManager] for speech synthesis
/// - [SttManager] for speech recognition
///
/// **Key Responsibilities:**
/// - Initialize and manage both TTS and STT engines
/// - Speak game content with predefined voice
/// - Listen to user speech with language and mode control
/// - Expose utility flags such as `isSpeaking` and `isListening`
///
/// **Use Cases:**
/// - Voice-controlled game commands
/// - Interactive storytelling with narration + voice prompts
/// - Speech-based puzzles, quizzes, or learning interfaces
/// - Accessibility features for visually impaired users
///
/// **Example:**
/// ```dart
/// final engine = FiftySpeechEngine(locale: Locale('en', 'US'));
/// await engine.initialize();
///
/// // Speak text
/// await engine.speak('Welcome to the game!');
///
/// // Listen for user input
/// engine.stt.onResult = (text) async => print('Heard: $text');
/// await engine.startListening();
/// ```
///
/// Part of the [Fifty Design Language](https://github.com/fiftynotai/fifty_eco_system) ecosystem.
class FiftySpeechEngine {
  /// Internal text-to-speech manager
  final TtsManager tts;

  /// Internal speech-to-text manager
  final SttManager stt;

  /// The locale used for both TTS and STT (e.g. `Locale('en', 'US')`)
  Locale locale;

  /// Creates a new instance of the unified speech engine.
  ///
  /// You can optionally provide callbacks for:
  /// - `onSttResult`: returns partial or final recognition results
  /// - `onSttError`: returns error messages during recognition
  FiftySpeechEngine({
    required this.locale,
    Future Function(String text)? onSttResult,
    void Function(String error)? onSttError,
  })  : tts = TtsManager(),
        stt = SttManager() {
    stt.onResult = onSttResult;
    stt.onError = onSttError;
  }

  /// Initializes both [TtsManager] and [SttManager] with the configured locale
  ///
  /// - TTS will use the specified language code (e.g. `'en-US'`)
  /// - STT will check availability and set up listeners
  Future<void> initialize() async {
    await tts.initialize(language: '${locale.languageCode}-${locale.countryCode}');
    await stt.initialize();
  }

  /// Speaks the given [text] using the preconfigured TTS voice
  ///
  /// This will interrupt any current speech in progress.
  Future<void> speak(String text) => tts.speak(text);

  /// Stops any ongoing TTS playback
  Future<void> stopSpeaking() => tts.stop();

  /// Begins listening to user input using STT
  ///
  /// - If [continuous] is `true`, uses dictation mode for longer speech input
  /// - Automatically uses the configured locale
  Future<void> startListening({
    bool continuous = false,
  }) =>
      stt.startListening(
        localeId: '${locale.languageCode}_${locale.countryCode}',
        listenContinuously: continuous,
      );

  /// Stops current listening session and returns the final result
  Future<void> stopListening() => stt.stopListening();

  /// Cancels current listening without returning a result
  Future<void> cancelListening() => stt.cancelListening();

  /// Whether the STT engine is currently listening
  bool get isListening => stt.isListening;

  /// Whether the TTS engine is currently speaking
  bool get isSpeaking => tts.isSpeaking;

  /// Disposes all speech resources (STT engine only for now)
  void dispose() {
    stt.dispose();
  }
}
