import 'dart:async';
import 'dart:collection';
import 'package:fifty_sentences_engine/data/base_sentence.dart';
import 'package:flutter/material.dart';
import 'sentence_interpreter.dart';

/// **ProcessingStatus** - Enum representing engine state
///
/// Used to indicate the current state of the sentence engine.
/// This allows reactive updates to UI and logic via listeners.
///
/// **States:**
/// - `idle`: Engine is idle and not processing
/// - `processing`: Actively processing sentences
/// - `paused`: Temporarily paused mid-processing
/// - `cancelled`: Cancelled before finishing
/// - `completed`: Finished all sentences
enum ProcessingStatus {
  idle,
  processing,
  paused,
  cancelled,
  completed,
}

/// **SentenceEngine** - Core processor for in-game sentence execution
///
/// This class is responsible for executing in-game sentences one by one,
/// enabling narration, player interaction, and navigation control.
///
/// It uses a `ListQueue` to manage upcoming sentences and exposes
/// processed ones through callbacks for display.
/// Each sentence is delegated to a [SentenceInterpreter] for instruction parsing.
///
/// **Key Responsibilities:**
/// - Manage sentence queue (enqueue, process, clear)
/// - Control execution flow (pause, resume, cancel, complete)
/// - Support external stream listeners for engine status updates
/// - Integrate blocking flow (e.g., wait for user tap)
/// - Deduplicate writing using external `SafeSentenceWriter`
///
/// **Usage Example:**
/// ```dart
/// final engine = SentenceEngine(
///   onStatusChange: (status) => print('Status: $status'),
///   onSentencesChanged: (sentences) => setState(() {}),
/// );
/// engine.registerInterpreter(myInterpreter);
/// engine.enqueue(sentences);
/// engine.process(onComplete: () => print("Done"));
/// ```
class SentenceEngine {
  /// Constructor with optional status change and sentences changed callbacks.
  SentenceEngine({
    this.onStatusChange,
    this.onSentencesChanged,
    this.onProcessingIndexChanged,
    this.interpreter,
  });

  /// List of sentences that have been processed and written.
  final List<BaseSentenceModel> _processedSentences = <BaseSentenceModel>[];

  /// Interpreter responsible for executing sentence logic (read, write, ask, etc.)
  SentenceInterpreter? interpreter;

  /// Callback for status changes (idle, processing, paused, etc.)
  final ValueChanged<ProcessingStatus>? onStatusChange;

  /// Callback when processed sentences list changes.
  final ValueChanged<List<BaseSentenceModel>>? onSentencesChanged;

  /// Callback when processing index changes.
  final ValueChanged<int>? onProcessingIndexChanged;

  /// Internal index of the current sentence being processed.
  int _processingIndex = 0;

  /// Current processing status.
  ProcessingStatus _status = ProcessingStatus.idle;

  /// Stream to broadcast status changes to external listeners.
  final StreamController<ProcessingStatus> _statusStream =
      StreamController<ProcessingStatus>.broadcast();

  /// Internal queue of sentences waiting to be processed.
  final ListQueue<BaseSentenceModel> _queue = ListQueue();

  /// Used to block processing until user input is received.
  Completer<void>? _blocker;

  /// Registers or replaces the sentence interpreter.
  void registerInterpreter(SentenceInterpreter interpreter) {
    this.interpreter = interpreter;
  }

  // -------- Public Getters --------

  /// List of displayed/written sentences.
  List<BaseSentenceModel> get sentences =>
      List.unmodifiable(_processedSentences);

  /// Index of the currently processing sentence.
  int get processingIndex => _processingIndex;

  /// Current processing status.
  ProcessingStatus get status => _status;

  /// Stream of status changes (useful for UI or controllers).
  Stream<ProcessingStatus> get onStatusChanged => _statusStream.stream;

  // -------- Core Engine Methods --------

  /// Adds new sentences to the queue to be processed.
  void enqueue(List<BaseSentenceModel> newSentences) {
    for (final sentence in newSentences) {
      _queue.addLast(sentence);
    }
  }

  /// Starts processing the sentence queue.
  ///
  /// - Sentences are interpreted one by one
  /// - Will pause if user interaction is required
  /// - Automatically completes and resets if queue is done
  Future<void> process({
    VoidCallback? onComplete,
    VoidCallback? onInterrupted,
  }) async {
    if (_status == ProcessingStatus.processing) return;

    _updateStatus(ProcessingStatus.processing);

    while (_queue.isNotEmpty) {
      if (_status == ProcessingStatus.cancelled) {
        _handleInterruption(onInterrupted);
        return;
      }

      while (_status == ProcessingStatus.paused) {
        await Future.delayed(const Duration(milliseconds: 200));
      }

      final current = _queue.removeFirst();
      _processingIndex++;
      onProcessingIndexChanged?.call(_processingIndex);

      if (interpreter != null) {
        await interpreter!.interpret(current);
      }

      _notifySentencesChanged();
    }

    _finish(onComplete);
  }

  // -------- Sentence Flow Control --------

  /// Pauses the engine (useful for "tap to continue" style interactions).
  void pause() {
    if (_status == ProcessingStatus.processing) {
      _updateStatus(ProcessingStatus.paused);
    }
  }

  /// Resumes the engine from a paused state.
  void resume() {
    if (_status == ProcessingStatus.paused) {
      _updateStatus(ProcessingStatus.processing);
    }
  }

  /// Cancels sentence processing and resets everything.
  void cancel() {
    if (_status == ProcessingStatus.processing ||
        _status == ProcessingStatus.paused) {
      _updateStatus(ProcessingStatus.cancelled);
    }
  }

  /// Completely clears all internal state.
  void reset() {
    _queue.clear();
    _processingIndex = 0;
    onProcessingIndexChanged?.call(_processingIndex);
    _updateStatus(ProcessingStatus.idle);
    _notifySentencesChanged();
  }

  // -------- User-Blocking Helpers --------

  /// Pauses execution and blocks until `continueAfterUserInput()` is called.
  Future<void> pauseUntilUserContinues() async {
    _updateStatus(ProcessingStatus.paused);
    _blocker = Completer();
    return _blocker!.future;
  }

  /// Resumes processing if waiting on user input.
  void continueAfterUserInput() {
    if (_blocker != null && !_blocker!.isCompleted) {
      _blocker!.complete();
      _updateStatus(ProcessingStatus.processing);
    }
  }

  // -------- Sentence Handling --------

  /// Appends a sentence to the visible list of written sentences.
  void addSentenceToWritten(BaseSentenceModel baseSentenceModel) {
    _processedSentences.add(baseSentenceModel);
    _notifySentencesChanged();
  }

  /// Clears all processed sentences.
  void clearProcessedSentences() {
    _processedSentences.clear();
    _notifySentencesChanged();
  }

  // -------- Internal Helpers --------

  /// Marks processing as finished and resets state.
  void _finish(VoidCallback? onComplete) {
    _updateStatus(ProcessingStatus.completed);
    onComplete?.call();
    reset();
  }

  /// Handles interruption from cancel or system-level exit.
  void _handleInterruption(VoidCallback? onInterrupted) {
    _queue.clear();
    onInterrupted?.call();
    reset();
  }

  /// Updates engine status and notifies all observers.
  void _updateStatus(ProcessingStatus status) {
    _status = status;
    _statusStream.add(status);
    onStatusChange?.call(status);
  }

  /// Notifies listeners that the sentences list has changed.
  void _notifySentencesChanged() {
    onSentencesChanged?.call(List.unmodifiable(_processedSentences));
  }

  /// Disposes resources (call when done with the engine).
  void dispose() {
    _statusStream.close();
  }
}
