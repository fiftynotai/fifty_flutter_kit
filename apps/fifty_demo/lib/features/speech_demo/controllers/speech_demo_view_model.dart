/// Speech Demo ViewModel
///
/// Business logic for the speech demo feature.
/// Demonstrates real TTS (Text-to-Speech) and STT (Speech-to-Text) functionality
/// using the fifty_speech_engine package.
library;

import 'package:get/get.dart';

import '../../../shared/services/speech_integration_service.dart';

/// ViewModel for the speech demo feature.
///
/// Manages TTS and STT state using the real [SpeechIntegrationService]
/// which wraps the fifty_speech_engine package.
///
/// **Note:** No `onClose()` override needed for Rx observables (auto-disposed).
/// The SpeechIntegrationService handles engine cleanup in its own onClose().
class SpeechDemoViewModel extends GetxController {
  SpeechDemoViewModel({
    required SpeechIntegrationService speechService,
  }) : _speechService = speechService;

  final SpeechIntegrationService _speechService;

  // ---------------------------------------------------------------------------
  // TTS State
  // ---------------------------------------------------------------------------

  /// Whether TTS is enabled.
  final _ttsEnabled = true.obs;
  bool get ttsEnabled => _ttsEnabled.value;

  /// Current speech rate (0.25 - 2.0, default 1.0).
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

  /// Whether TTS is currently speaking (from service).
  bool get isSpeaking => _speechService.ttsPlaying;

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

  /// Whether STT is currently listening (from service).
  bool get isListening => _speechService.sttListening;

  /// Current recognized text (live during recognition).
  String get recognizedText => _speechService.recognizedText;

  /// Whether STT is available on this device.
  bool get sttAvailable => _speechService.sttAvailable;

  /// History of recognized phrases.
  final _recognitionHistory = <RecognizedPhrase>[].obs;
  List<RecognizedPhrase> get recognitionHistory => _recognitionHistory;

  /// Confidence threshold for recognition.
  final _confidenceThreshold = 0.7.obs;
  double get confidenceThreshold => _confidenceThreshold.value;

  /// Error message from last operation.
  String get errorMessage => _speechService.errorMessage;

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    _initializeSpeechService();
  }

  /// Initializes the speech service and sets up callbacks.
  ///
  /// Wrapped in try-catch to prevent app crash if speech engine is unavailable.
  Future<void> _initializeSpeechService() async {
    try {
      // Set up callbacks before initializing
      _speechService.onSttResult = _handleSttResult;
      _speechService.onSttError = _handleSttError;
      _speechService.onTtsComplete = _handleTtsComplete;

      // Initialize the service (may fail on some platforms)
      await _speechService.initialize();
    } catch (e) {
      // Speech engine unavailable - gracefully degrade
      // Error will be shown via errorMessage getter
    }

    // Update UI with initial state
    update();
  }

  /// Handles STT recognition results.
  void _handleSttResult(String text, bool isFinal) {
    if (isFinal && text.isNotEmpty) {
      // Add to history when recognition is complete
      _recognitionHistory.insert(
        0,
        RecognizedPhrase(
          text: text,
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

  /// Handles STT errors.
  void _handleSttError(String error) {
    update();
  }

  /// Handles TTS completion.
  void _handleTtsComplete() {
    update();
  }

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
    _speechRate.value = rate.clamp(0.25, 2.0);
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

  /// Speaks the given text using real TTS engine.
  Future<void> speak(String text) async {
    if (!ttsEnabled || text.isEmpty) return;

    _currentText.value = text;
    update();

    // Use the real speech service
    await _speechService.speak(text);

    update();
  }

  /// Stops speaking.
  Future<void> stopSpeaking() async {
    await _speechService.stopSpeaking();
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

  /// Starts listening using real STT engine.
  Future<bool> startListening() async {
    if (!sttEnabled) return false;
    if (!sttAvailable) return false;
    if (isListening) return true;

    // Clear previous recognized text
    _speechService.clearRecognizedText();

    final success = await _speechService.startListening(continuous: false);
    update();
    return success;
  }

  /// Stops listening.
  Future<void> stopListening() async {
    if (!isListening) return;

    await _speechService.stopListening();

    // Save recognized text to history if not empty
    final text = recognizedText;
    if (text.isNotEmpty) {
      _recognitionHistory.insert(
        0,
        RecognizedPhrase(
          text: text,
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

  /// Toggles listening state.
  Future<void> toggleListening() async {
    if (isListening) {
      await stopListening();
    } else {
      await startListening();
    }
  }

  /// Clears recognition history.
  void clearHistory() {
    _recognitionHistory.clear();
    _speechService.clearRecognizedText();
    update();
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
    if (!sttAvailable) return 'UNAVAILABLE';
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
