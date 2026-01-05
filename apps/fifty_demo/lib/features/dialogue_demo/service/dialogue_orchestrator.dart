/// Dialogue Orchestrator Service
///
/// Coordinates sentence engine with speech engine for dialogue playback.
library;

import 'package:flutter/foundation.dart';

import '../../../shared/services/sentences_integration_service.dart';
import '../../../shared/services/speech_integration_service.dart';

/// Orchestrates dialogue playback with TTS.
///
/// Combines sentence queue with text-to-speech for narrative experience.
class DialogueOrchestrator extends ChangeNotifier {
  DialogueOrchestrator({
    required SpeechIntegrationService speechService,
    required SentencesIntegrationService sentencesService,
  })  : _speechService = speechService,
        _sentencesService = sentencesService;

  final SpeechIntegrationService _speechService;
  final SentencesIntegrationService _sentencesService;

  bool _ttsEnabled = true;
  bool _autoAdvance = false;
  bool _isPlaying = false;

  // ─────────────────────────────────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────────────────────────────────

  bool get ttsEnabled => _ttsEnabled;
  bool get autoAdvance => _autoAdvance;
  bool get isPlaying => _isPlaying;
  bool get ttsPlaying => _speechService.ttsPlaying;
  bool get sttListening => _speechService.sttListening;
  String get recognizedText => _speechService.recognizedText;
  String get displayedText => _sentencesService.displayedText;
  bool get isProcessing => _sentencesService.isProcessing;
  bool get hasMoreSentences => _sentencesService.hasMoreSentences;
  int get currentIndex => _sentencesService.currentIndex;
  int get totalSentences => _sentencesService.queue.length;
  Sentence? get currentSentence => _sentencesService.currentSentence;

  SpeechIntegrationService get speechService => _speechService;
  SentencesIntegrationService get sentencesService => _sentencesService;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes both services.
  Future<void> initialize() async {
    await _speechService.initialize();
    await _sentencesService.initialize();
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Dialogue Control
  // ─────────────────────────────────────────────────────────────────────────

  /// Loads a dialogue sequence.
  void loadDialogue(List<Sentence> sentences) {
    _sentencesService.clearQueue();
    _sentencesService.addSentences(sentences);
    _isPlaying = false;
    notifyListeners();
  }

  /// Starts playing the dialogue.
  Future<void> startDialogue() async {
    if (_sentencesService.queue.isEmpty) return;

    _isPlaying = true;
    _sentencesService.reset();
    await _playCurrentSentence();
    notifyListeners();
  }

  /// Plays the current sentence with optional TTS.
  Future<void> _playCurrentSentence() async {
    _sentencesService.startTyping();

    // Wait for typing to finish
    while (_sentencesService.isProcessing) {
      await Future<void>.delayed(const Duration(milliseconds: 50));
    }

    // Speak the sentence if TTS is enabled
    if (_ttsEnabled && _sentencesService.currentSentence != null) {
      await _speechService.speak(_sentencesService.currentSentence!.text);
    }

    // Auto-advance if enabled
    if (_autoAdvance && _sentencesService.hasMoreSentences) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      await advanceDialogue();
    }
  }

  /// Advances to the next sentence.
  Future<void> advanceDialogue() async {
    if (!_sentencesService.hasMoreSentences) {
      _isPlaying = false;
      notifyListeners();
      return;
    }

    _sentencesService.nextSentence();
    await _playCurrentSentence();
  }

  /// Goes back to the previous sentence.
  Future<void> previousDialogue() async {
    _sentencesService.previousSentence();
    await _playCurrentSentence();
  }

  /// Skips the current typing animation.
  void skipTyping() {
    _sentencesService.skipTyping();
    notifyListeners();
  }

  /// Stops the dialogue.
  void stopDialogue() {
    _isPlaying = false;
    _speechService.stopSpeaking();
    notifyListeners();
  }

  /// Resets the dialogue to the beginning.
  void resetDialogue() {
    _isPlaying = false;
    _sentencesService.reset();
    _speechService.stopSpeaking();
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Settings
  // ─────────────────────────────────────────────────────────────────────────

  /// Toggles TTS on/off.
  void toggleTts() {
    _ttsEnabled = !_ttsEnabled;
    if (!_ttsEnabled) {
      _speechService.stopSpeaking();
    }
    notifyListeners();
  }

  /// Toggles auto-advance on/off.
  void toggleAutoAdvance() {
    _autoAdvance = !_autoAdvance;
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // STT Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Starts listening for voice input.
  Future<void> startListening() async {
    await _speechService.startListening();
    notifyListeners();
  }

  /// Stops listening for voice input.
  Future<void> stopListening() async {
    await _speechService.stopListening();
    notifyListeners();
  }

  /// Processes recognized voice command.
  void processVoiceCommand(String command) {
    final lowerCommand = command.toLowerCase();
    if (lowerCommand.contains('next') || lowerCommand.contains('continue')) {
      advanceDialogue();
    } else if (lowerCommand.contains('back') || lowerCommand.contains('previous')) {
      previousDialogue();
    } else if (lowerCommand.contains('skip')) {
      skipTyping();
    } else if (lowerCommand.contains('stop')) {
      stopDialogue();
    }
    _speechService.clearRecognizedText();
    notifyListeners();
  }

}
