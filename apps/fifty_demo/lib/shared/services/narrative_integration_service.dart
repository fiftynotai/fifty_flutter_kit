/// Sentences Integration Service
///
/// Wraps the fifty_narrative_engine for use in the demo app.
/// Provides dialogue and sentence queue functionality.
library;

import 'dart:async';

import 'package:get/get.dart';

/// A single sentence in the queue.
class Sentence {
  const Sentence({
    required this.id,
    required this.text,
    this.speaker,
    this.duration,
  });

  final String id;
  final String text;
  final String? speaker;
  final Duration? duration;
}

/// Service for sentences integration.
///
/// Manages dialogue queues and sentence processing.
class NarrativeIntegrationService extends GetxController {
  NarrativeIntegrationService();

  bool _initialized = false;
  bool _processing = false;
  int _currentIndex = 0;
  String _displayedText = '';
  Timer? _typingTimer;
  final List<Sentence> _queue = [];
  final int _typingSpeedMs = 30;

  // ─────────────────────────────────────────────────────────────────────────
  // Getters
  // ─────────────────────────────────────────────────────────────────────────

  bool get isInitialized => _initialized;
  bool get isProcessing => _processing;
  int get currentIndex => _currentIndex;
  String get displayedText => _displayedText;
  List<Sentence> get queue => List.unmodifiable(_queue);
  bool get hasMoreSentences => _currentIndex < _queue.length;

  Sentence? get currentSentence =>
      _currentIndex < _queue.length ? _queue[_currentIndex] : null;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the sentences service.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Queue Management
  // ─────────────────────────────────────────────────────────────────────────

  /// Adds a sentence to the queue.
  void addSentence(Sentence sentence) {
    _queue.add(sentence);
    update();
  }

  /// Adds multiple sentences to the queue.
  void addSentences(List<Sentence> sentences) {
    _queue.addAll(sentences);
    update();
  }

  /// Clears the sentence queue.
  void clearQueue() {
    _queue.clear();
    _currentIndex = 0;
    _displayedText = '';
    _typingTimer?.cancel();
    _processing = false;
    update();
  }

  /// Resets to the beginning of the queue.
  void reset() {
    _currentIndex = 0;
    _displayedText = '';
    _typingTimer?.cancel();
    _processing = false;
    update();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Playback Controls
  // ─────────────────────────────────────────────────────────────────────────

  /// Starts processing the current sentence with typing animation.
  void startTyping() {
    if (!_initialized || _processing) return;
    if (_currentIndex >= _queue.length) return;

    _processing = true;
    _displayedText = '';
    final sentence = _queue[_currentIndex];
    var charIndex = 0;

    _typingTimer = Timer.periodic(
      Duration(milliseconds: _typingSpeedMs),
      (timer) {
        if (charIndex < sentence.text.length) {
          _displayedText = sentence.text.substring(0, charIndex + 1);
          charIndex++;
          update();
        } else {
          timer.cancel();
          _processing = false;
          update();
        }
      },
    );

    update();
  }

  /// Skips the typing animation and shows full text.
  void skipTyping() {
    _typingTimer?.cancel();
    if (_currentIndex < _queue.length) {
      _displayedText = _queue[_currentIndex].text;
    }
    _processing = false;
    update();
  }

  /// Advances to the next sentence.
  void nextSentence() {
    _typingTimer?.cancel();
    _processing = false;

    if (_currentIndex < _queue.length - 1) {
      _currentIndex++;
      _displayedText = '';
      startTyping();
    } else {
      // End of queue
      _displayedText = '';
      update();
    }
  }

  /// Goes back to the previous sentence.
  void previousSentence() {
    _typingTimer?.cancel();
    _processing = false;

    if (_currentIndex > 0) {
      _currentIndex--;
      _displayedText = '';
      startTyping();
    }
  }

  @override
  void onClose() {
    _typingTimer?.cancel();
    super.onClose();
  }
}
