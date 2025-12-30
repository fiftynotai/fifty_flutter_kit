/// ViewModel for the Sentences Demo feature.
///
/// Exposes sentence engine state for the view to observe.
/// All state changes flow through the SentencesService.
library;

import 'package:fifty_sentences_engine/fifty_sentences_engine.dart';
import 'package:flutter/foundation.dart';

import '../service/demo_sentence.dart';
import '../service/sentences_service.dart';

/// ViewModel for sentences demo feature.
///
/// Provides a reactive interface to the SentencesService state.
class SentencesDemoViewModel extends ChangeNotifier {
  SentencesDemoViewModel({
    required SentencesService sentencesService,
  }) : _sentencesService = sentencesService {
    _sentencesService.addListener(_onServiceChanged);
  }

  final SentencesService _sentencesService;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization State
  // ─────────────────────────────────────────────────────────────────────────

  /// Whether the sentences service is initialized.
  bool get isInitialized => _sentencesService.isInitialized;

  // ─────────────────────────────────────────────────────────────────────────
  // Processing State
  // ─────────────────────────────────────────────────────────────────────────

  /// Current service state.
  SentencesServiceState get state => _sentencesService.state;

  /// Whether the engine is idle.
  bool get isIdle => _sentencesService.state == SentencesServiceState.idle;

  /// Whether the engine is processing.
  bool get isProcessing =>
      _sentencesService.state == SentencesServiceState.processing;

  /// Whether the engine is paused.
  bool get isPaused => _sentencesService.state == SentencesServiceState.paused;

  /// Whether waiting for user input (tap to continue).
  bool get isWaitingForInput =>
      _sentencesService.state == SentencesServiceState.waitingForInput;

  /// Whether waiting for choice selection.
  bool get isWaitingForChoice =>
      _sentencesService.state == SentencesServiceState.waitingForChoice;

  /// Whether any operation is active.
  bool get isActive => isProcessing || isPaused || isWaitingForInput || isWaitingForChoice;

  // ─────────────────────────────────────────────────────────────────────────
  // Queue State
  // ─────────────────────────────────────────────────────────────────────────

  /// List of sentences in the queue (pending).
  List<DemoSentence> get queue => _sentencesService.queue;

  /// Whether the queue is empty.
  bool get isQueueEmpty => _sentencesService.queue.isEmpty;

  /// Number of sentences in the queue.
  int get queueLength => _sentencesService.queue.length;

  // ─────────────────────────────────────────────────────────────────────────
  // Processed Sentences
  // ─────────────────────────────────────────────────────────────────────────

  /// List of processed sentences.
  List<BaseSentenceModel> get processedSentences =>
      _sentencesService.processedSentences;

  /// Whether there are processed sentences.
  bool get hasProcessedSentences => _sentencesService.processedSentences.isNotEmpty;

  /// Number of processed sentences.
  int get processedCount => _sentencesService.processedSentences.length;

  // ─────────────────────────────────────────────────────────────────────────
  // Current Sentence
  // ─────────────────────────────────────────────────────────────────────────

  /// Currently processing sentence.
  DemoSentence? get currentSentence => _sentencesService.currentSentence;

  /// Whether there is a current sentence.
  bool get hasCurrentSentence => _sentencesService.currentSentence != null;

  /// Current sentence text.
  String get currentText => _sentencesService.currentSentence?.text ?? '';

  /// Current sentence instruction.
  String get currentInstruction =>
      _sentencesService.currentSentence?.instruction ?? '';

  /// Current sentence choices (for ask instruction).
  List<String> get currentChoices =>
      (_sentencesService.currentSentence?.choices ?? []).cast<String>();

  /// Whether current sentence has choices.
  bool get hasChoices => currentChoices.isNotEmpty;

  // ─────────────────────────────────────────────────────────────────────────
  // Selection State
  // ─────────────────────────────────────────────────────────────────────────

  /// Selected choice (for ask instructions).
  String? get selectedChoice => _sentencesService.selectedChoice;

  /// Whether a choice has been selected.
  bool get hasSelectedChoice => _sentencesService.selectedChoice != null;

  // ─────────────────────────────────────────────────────────────────────────
  // Status Helpers
  // ─────────────────────────────────────────────────────────────────────────

  /// Status label for current state.
  String get statusLabel {
    switch (state) {
      case SentencesServiceState.idle:
        return 'IDLE';
      case SentencesServiceState.processing:
        return 'PROCESSING';
      case SentencesServiceState.paused:
        return 'PAUSED';
      case SentencesServiceState.waitingForInput:
        return 'WAITING';
      case SentencesServiceState.waitingForChoice:
        return 'CHOOSE';
    }
  }

  /// Instruction label for display.
  String getInstructionLabel(String instruction) {
    final lower = instruction.toLowerCase();
    if (lower.contains('write') && lower.contains('read')) {
      return 'WRITE+READ';
    }
    if (lower.contains('write')) return 'WRITE';
    if (lower.contains('read')) return 'READ';
    if (lower.contains('ask')) return 'ASK';
    if (lower.contains('wait')) return 'WAIT';
    if (lower.contains('navigate')) return 'NAVIGATE';
    return instruction.toUpperCase();
  }

  /// Whether processing can be started.
  bool get canProcess => !isQueueEmpty && isIdle;

  /// Whether processing can be paused.
  bool get canPause => isProcessing;

  /// Whether processing can be resumed.
  bool get canResume => isPaused;

  /// Whether the queue can be cleared.
  bool get canClearQueue => !isQueueEmpty && !isActive;

  // ─────────────────────────────────────────────────────────────────────────
  // Listener
  // ─────────────────────────────────────────────────────────────────────────

  void _onServiceChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _sentencesService.removeListener(_onServiceChanged);
    super.dispose();
  }
}
