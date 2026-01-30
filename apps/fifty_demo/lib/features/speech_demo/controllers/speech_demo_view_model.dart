/// Speech Demo ViewModel
///
/// Business logic for the speech demo feature.
/// Demonstrates TTS (Text-to-Speech) and STT (Speech-to-Text) functionality.
library;

import 'package:get/get.dart';

/// ViewModel for the speech demo feature.
///
/// Manages TTS and STT state including voice settings,
/// speaking/listening states, and recognized text history.
class SpeechDemoViewModel extends GetxController {
  // ---------------------------------------------------------------------------
  // TTS State
  // ---------------------------------------------------------------------------

  /// Whether TTS is enabled.
  final _ttsEnabled = true.obs;
  bool get ttsEnabled => _ttsEnabled.value;

  /// Whether TTS is currently speaking.
  final _isSpeaking = false.obs;
  bool get isSpeaking => _isSpeaking.value;

  /// Current speech rate (0.0 - 2.0, default 1.0).
  final _speechRate = 1.0.obs;
  double get speechRate => _speechRate.value;

  /// Current pitch (0.5 - 2.0, default 1.0).
  final _pitch = 1.0.obs;
  double get pitch => _pitch.value;

  /// Current volume (0.0 - 1.0, default 1.0).
  final _volume = 1.0.obs;
  double get volume => _volume.value;

  /// Current text to speak.
  final _currentText = ''.obs;
  String get currentText => _currentText.value;

  /// Sample phrases for TTS demo.
  List<String> get samplePhrases => [
    'Welcome to the Fifty Design Language demo application.',
    'The speech engine supports multiple languages and voices.',
    'You can adjust the rate, pitch, and volume of the voice.',
    'Press the microphone button to start voice recognition.',
  ];

  // ---------------------------------------------------------------------------
  // STT State
  // ---------------------------------------------------------------------------

  /// Whether STT is enabled.
  final _sttEnabled = true.obs;
  bool get sttEnabled => _sttEnabled.value;

  /// Whether STT is currently listening.
  final _isListening = false.obs;
  bool get isListening => _isListening.value;

  /// Current recognized text (live during recognition).
  final _recognizedText = ''.obs;
  String get recognizedText => _recognizedText.value;

  /// History of recognized phrases.
  final _recognitionHistory = <RecognizedPhrase>[].obs;
  List<RecognizedPhrase> get recognitionHistory => _recognitionHistory;

  /// Confidence threshold for recognition.
  final _confidenceThreshold = 0.7.obs;
  double get confidenceThreshold => _confidenceThreshold.value;

  // ---------------------------------------------------------------------------
  // TTS Methods
  // ---------------------------------------------------------------------------

  /// Sets the TTS enabled state.
  void setTtsEnabled({required bool enabled}) {
    _ttsEnabled.value = enabled;
    if (!enabled && isSpeaking) {
      stopSpeaking();
    }
    update();
  }

  /// Sets the speech rate.
  void setSpeechRate(double rate) {
    _speechRate.value = rate.clamp(0.0, 2.0);
    update();
  }

  /// Sets the pitch.
  void setPitch(double value) {
    _pitch.value = value.clamp(0.5, 2.0);
    update();
  }

  /// Sets the volume.
  void setVolume(double value) {
    _volume.value = value.clamp(0.0, 1.0);
    update();
  }

  /// Sets the current text to speak.
  void setCurrentText(String text) {
    _currentText.value = text;
    update();
  }

  /// Speaks the given text (simulated).
  Future<void> speak(String text) async {
    if (!ttsEnabled || text.isEmpty) return;

    _currentText.value = text;
    _isSpeaking.value = true;
    update();

    // Simulate speaking duration based on text length
    final duration = Duration(
      milliseconds: (text.length * 50 / speechRate).round().clamp(1000, 10000),
    );
    await Future<void>.delayed(duration);

    _isSpeaking.value = false;
    update();
  }

  /// Stops speaking (simulated).
  void stopSpeaking() {
    _isSpeaking.value = false;
    update();
  }

  // ---------------------------------------------------------------------------
  // STT Methods
  // ---------------------------------------------------------------------------

  /// Sets the STT enabled state.
  void setSttEnabled({required bool enabled}) {
    _sttEnabled.value = enabled;
    if (!enabled && isListening) {
      stopListening();
    }
    update();
  }

  /// Sets the confidence threshold.
  void setConfidenceThreshold(double threshold) {
    _confidenceThreshold.value = threshold.clamp(0.0, 1.0);
    update();
  }

  /// Starts listening (simulated).
  Future<void> startListening() async {
    if (!sttEnabled || isListening) return;

    _isListening.value = true;
    _recognizedText.value = '';
    update();

    // Simulate listening and recognition
    await _simulateRecognition();
  }

  /// Stops listening.
  void stopListening() {
    if (!isListening) return;

    _isListening.value = false;

    // Save recognized text to history if not empty
    if (_recognizedText.value.isNotEmpty) {
      _recognitionHistory.insert(
        0,
        RecognizedPhrase(
          text: _recognizedText.value,
          confidence: 0.85 + (0.15 * (DateTime.now().millisecond / 1000)),
          timestamp: DateTime.now(),
        ),
      );

      // Keep only last 10 entries
      if (_recognitionHistory.length > 10) {
        _recognitionHistory.removeLast();
      }
    }

    update();
  }

  /// Clears recognition history.
  void clearHistory() {
    _recognitionHistory.clear();
    _recognizedText.value = '';
    update();
  }

  /// Simulates speech recognition with mock phrases.
  Future<void> _simulateRecognition() async {
    final mockPhrases = [
      'Hello, how are you?',
      'What is the weather today?',
      'Play some music please.',
      'Set a timer for five minutes.',
      'Navigate to the nearest coffee shop.',
    ];

    // Simulate partial recognition over time
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!isListening) return;

    final phrase = mockPhrases[DateTime.now().second % mockPhrases.length];
    final words = phrase.split(' ');

    for (var i = 0; i < words.length && isListening; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 300));
      if (!isListening) return;

      _recognizedText.value = words.sublist(0, i + 1).join(' ');
      update();
    }

    // Auto-stop after recognition completes
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (isListening) {
      stopListening();
    }
  }

  // ---------------------------------------------------------------------------
  // Status Helpers
  // ---------------------------------------------------------------------------

  /// Status label for TTS state.
  String get ttsStatusLabel {
    if (!ttsEnabled) return 'DISABLED';
    if (isSpeaking) return 'SPEAKING';
    return 'READY';
  }

  /// Status label for STT state.
  String get sttStatusLabel {
    if (!sttEnabled) return 'DISABLED';
    if (isListening) return 'LISTENING';
    return 'READY';
  }

  /// Resets all voice settings to defaults.
  void resetVoiceSettings() {
    _speechRate.value = 1.0;
    _pitch.value = 1.0;
    _volume.value = 1.0;
    update();
  }
}

/// Represents a recognized phrase with metadata.
class RecognizedPhrase {
  /// Creates a recognized phrase.
  const RecognizedPhrase({
    required this.text,
    required this.confidence,
    required this.timestamp,
  });

  /// The recognized text.
  final String text;

  /// Recognition confidence (0.0 - 1.0).
  final double confidence;

  /// When the phrase was recognized.
  final DateTime timestamp;
}
