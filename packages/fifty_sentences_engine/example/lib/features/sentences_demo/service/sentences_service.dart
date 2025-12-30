/// Sentences service that wraps SentenceEngine for the example app.
///
/// Provides a high-level interface for sentence queue operations
/// with state management and event notifications.
library;

import 'dart:async';

import 'package:fifty_sentences_engine/fifty_sentences_engine.dart';
import 'package:flutter/foundation.dart';

import 'demo_sentence.dart';

/// Current processing state for the service.
enum SentencesServiceState {
  idle,
  processing,
  paused,
  waitingForInput,
  waitingForChoice,
}

/// Sentences service for managing the sentence engine.
class SentencesService extends ChangeNotifier {
  SentencesService();

  /// The underlying sentence engine.
  late SentenceEngine _engine;

  /// The sentence interpreter.
  late SentenceInterpreter _interpreter;

  /// Whether the service is initialized.
  bool _initialized = false;
  bool get isInitialized => _initialized;

  /// Current service state.
  SentencesServiceState _state = SentencesServiceState.idle;
  SentencesServiceState get state => _state;

  /// List of sentences in the queue (pending processing).
  final List<DemoSentence> _queue = [];
  List<DemoSentence> get queue => List.unmodifiable(_queue);

  /// List of processed sentences.
  List<BaseSentenceModel> _processedSentences = [];
  List<BaseSentenceModel> get processedSentences =>
      List.unmodifiable(_processedSentences);

  /// Currently processing sentence.
  DemoSentence? _currentSentence;
  DemoSentence? get currentSentence => _currentSentence;

  /// Current processing index.
  int _processingIndex = 0;
  int get processingIndex => _processingIndex;

  /// Selected choice (for ask instructions).
  String? _selectedChoice;
  String? get selectedChoice => _selectedChoice;

  /// Completer for choice selection.
  Completer<String>? _choiceCompleter;

  /// Counter for generating unique sentence IDs.
  int _sentenceCounter = 0;

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes the sentence engine.
  Future<void> initialize() async {
    if (_initialized) return;

    debugPrint('SentencesService: Initializing...');

    _engine = SentenceEngine(
      onStatusChange: _handleStatusChange,
      onSentencesChanged: _handleSentencesChanged,
      onProcessingIndexChanged: _handleProcessingIndexChanged,
    );

    _interpreter = SentenceInterpreter(
      engine: _engine,
      onWrite: _handleWrite,
      onRead: _handleRead,
      onAsk: _handleAsk,
      onWait: _handleWait,
      onNavigate: _handleNavigate,
    );

    _engine.registerInterpreter(_interpreter);

    _initialized = true;
    debugPrint('SentencesService: Initialized successfully');
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Queue Management
  // ─────────────────────────────────────────────────────────────────────────

  /// Adds a write instruction sentence to the queue.
  void addWriteSentence() {
    final sentence = DemoSentence.write(
      id: _nextId(),
      text: _getWriteSampleText(),
      order: _queue.length + 1,
    );
    _addToQueue(sentence);
  }

  /// Adds a read instruction sentence to the queue.
  void addReadSentence() {
    final sentence = DemoSentence.read(
      id: _nextId(),
      text: _getReadSampleText(),
      order: _queue.length + 1,
    );
    _addToQueue(sentence);
  }

  /// Adds an ask instruction sentence to the queue.
  void addAskSentence() {
    final sentence = DemoSentence.ask(
      id: _nextId(),
      text: _getAskSampleText(),
      choices: ['Continue', 'Go back', 'Exit'],
      order: _queue.length + 1,
    );
    _addToQueue(sentence);
  }

  /// Adds a wait instruction sentence to the queue.
  void addWaitSentence() {
    final sentence = DemoSentence.wait(
      id: _nextId(),
      text: _getWaitSampleText(),
      order: _queue.length + 1,
    );
    _addToQueue(sentence);
  }

  /// Adds a custom sentence to the queue.
  void addSentence(DemoSentence sentence) {
    _addToQueue(sentence);
  }

  /// Loads a complete demo story with multiple instruction types.
  ///
  /// This creates an immersive dialogue flow demonstrating how the
  /// sentence engine can be used for game narratives.
  void loadDemoStory() {
    clearAll();
    _sentenceCounter = 0;

    final story = <DemoSentence>[
      // Opening narration (WRITE)
      DemoSentence.write(
        id: _nextId(),
        text: 'The ancient temple stands before you, shrouded in mist.',
        order: 1,
      ),

      // Narrator speaks (READ + WRITE)
      DemoSentence(
        id: _nextId(),
        text: 'A voice echoes from within the darkness...',
        instruction: 'read + write',
        order: 2,
      ),

      // Dramatic pause (WAIT)
      DemoSentence.wait(
        id: _nextId(),
        text: '...',
        order: 3,
      ),

      // Character dialogue (WRITE)
      DemoSentence.write(
        id: _nextId(),
        text: '"Traveler... you have come seeking answers."',
        order: 4,
      ),

      // Narration with voice (READ + WRITE)
      DemoSentence(
        id: _nextId(),
        text: '"But first, you must prove your worth."',
        instruction: 'read + write',
        order: 5,
      ),

      // Pause for effect (WAIT)
      DemoSentence.wait(
        id: _nextId(),
        text: 'Tap to continue...',
        order: 6,
      ),

      // Scene description (WRITE)
      DemoSentence.write(
        id: _nextId(),
        text: 'Three paths emerge from the shadows.',
        order: 7,
      ),

      // First choice (ASK)
      DemoSentence.ask(
        id: _nextId(),
        text: 'Which path do you choose?',
        choices: ['Path of Wisdom', 'Path of Courage', 'Path of Mystery'],
        order: 8,
      ),

      // Response to choice (WRITE)
      DemoSentence.write(
        id: _nextId(),
        text: 'You step forward with determination.',
        order: 9,
      ),

      // Narration (READ + WRITE)
      DemoSentence(
        id: _nextId(),
        text: 'The path illuminates before you, revealing ancient symbols.',
        instruction: 'read + write',
        order: 10,
      ),

      // Discovery (WRITE)
      DemoSentence.write(
        id: _nextId(),
        text: 'A glowing artifact hovers at the end of the corridor.',
        order: 11,
      ),

      // Dramatic moment (WAIT)
      DemoSentence.wait(
        id: _nextId(),
        text: 'Tap to approach...',
        order: 12,
      ),

      // Character speaks (READ + WRITE)
      DemoSentence(
        id: _nextId(),
        text: '"The Orb of Igris... it has chosen you."',
        instruction: 'read + write',
        order: 13,
      ),

      // Second choice (ASK)
      DemoSentence.ask(
        id: _nextId(),
        text: 'Do you accept the orb\'s power?',
        choices: ['Accept the power', 'Refuse and leave', 'Ask for more information'],
        order: 14,
      ),

      // Response (WRITE)
      DemoSentence.write(
        id: _nextId(),
        text: 'Energy surges through your body as you make your choice.',
        order: 15,
      ),

      // Narration (READ)
      DemoSentence.read(
        id: _nextId(),
        text: 'Your destiny has been forever altered.',
        order: 16,
      ),

      // Final message (WRITE)
      DemoSentence.write(
        id: _nextId(),
        text: 'The temple begins to rumble...',
        order: 17,
      ),

      // Closing (WAIT)
      DemoSentence.wait(
        id: _nextId(),
        text: 'To be continued... (Tap to finish)',
        order: 18,
      ),

      // End (WRITE)
      DemoSentence.write(
        id: _nextId(),
        text: '--- Demo Complete ---',
        order: 19,
      ),
    ];

    for (final sentence in story) {
      _addToQueue(sentence);
    }

    debugPrint('SentencesService: Loaded demo story with ${story.length} sentences');
  }

  void _addToQueue(DemoSentence sentence) {
    _queue.add(sentence);
    debugPrint('SentencesService: Added sentence - ${sentence.instruction}: ${sentence.text}');
    notifyListeners();
  }

  /// Clears the queue.
  void clearQueue() {
    _queue.clear();
    debugPrint('SentencesService: Queue cleared');
    notifyListeners();
  }

  /// Clears processed sentences.
  void clearProcessed() {
    _engine.clearProcessedSentences();
    _processedSentences = [];
    _processingIndex = 0;
    notifyListeners();
  }

  /// Clears everything.
  void clearAll() {
    clearQueue();
    clearProcessed();
    _currentSentence = null;
    _selectedChoice = null;
    _state = SentencesServiceState.idle;
    notifyListeners();
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Processing Control
  // ─────────────────────────────────────────────────────────────────────────

  /// Starts processing the queue.
  Future<void> process() async {
    if (_queue.isEmpty) {
      debugPrint('SentencesService: Queue is empty, nothing to process');
      return;
    }

    if (_state == SentencesServiceState.processing) {
      debugPrint('SentencesService: Already processing');
      return;
    }

    debugPrint('SentencesService: Starting processing');

    // Transfer queue to engine
    _engine.enqueue(_queue.cast<BaseSentenceModel>());
    _queue.clear();
    notifyListeners();

    // Start processing
    await _engine.process(
      onComplete: () {
        debugPrint('SentencesService: Processing complete');
        _state = SentencesServiceState.idle;
        _currentSentence = null;
        notifyListeners();
      },
      onInterrupted: () {
        debugPrint('SentencesService: Processing interrupted');
        _state = SentencesServiceState.idle;
        _currentSentence = null;
        notifyListeners();
      },
    );
  }

  /// Pauses processing.
  void pause() {
    if (_state != SentencesServiceState.processing) return;
    _engine.pause();
    _state = SentencesServiceState.paused;
    debugPrint('SentencesService: Paused');
    notifyListeners();
  }

  /// Resumes processing.
  void resume() {
    if (_state != SentencesServiceState.paused) return;
    _engine.resume();
    _state = SentencesServiceState.processing;
    debugPrint('SentencesService: Resumed');
    notifyListeners();
  }

  /// Cancels processing.
  void cancel() {
    _engine.cancel();
    _state = SentencesServiceState.idle;
    _currentSentence = null;
    debugPrint('SentencesService: Cancelled');
    notifyListeners();
  }

  /// Continues after user input (tap to continue).
  void continueAfterInput() {
    if (_state == SentencesServiceState.waitingForInput) {
      _engine.continueAfterUserInput();
      _state = SentencesServiceState.processing;
      debugPrint('SentencesService: Continued after user input');
      notifyListeners();
    }
  }

  /// Selects a choice for ask instructions.
  void selectChoice(String choice) {
    if (_state == SentencesServiceState.waitingForChoice &&
        _choiceCompleter != null) {
      _selectedChoice = choice;
      _choiceCompleter!.complete(choice);
      _choiceCompleter = null;
      _state = SentencesServiceState.processing;
      debugPrint('SentencesService: Selected choice - $choice');
      notifyListeners();
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Engine Handlers
  // ─────────────────────────────────────────────────────────────────────────

  void _handleStatusChange(ProcessingStatus status) {
    debugPrint('SentencesService: Engine status changed to $status');

    switch (status) {
      case ProcessingStatus.idle:
        _state = SentencesServiceState.idle;
      case ProcessingStatus.processing:
        _state = SentencesServiceState.processing;
      case ProcessingStatus.paused:
        if (_state != SentencesServiceState.waitingForInput &&
            _state != SentencesServiceState.waitingForChoice) {
          _state = SentencesServiceState.paused;
        }
      case ProcessingStatus.cancelled:
        _state = SentencesServiceState.idle;
      case ProcessingStatus.completed:
        _state = SentencesServiceState.idle;
    }

    notifyListeners();
  }

  void _handleSentencesChanged(List<BaseSentenceModel> sentences) {
    _processedSentences = sentences;
    debugPrint('SentencesService: Processed sentences updated - ${sentences.length} items');
    notifyListeners();
  }

  void _handleProcessingIndexChanged(int index) {
    _processingIndex = index;
    debugPrint('SentencesService: Processing index - $index');
    notifyListeners();
  }

  Future<void> _handleWrite(BaseSentenceModel sentence) async {
    debugPrint('SentencesService: Write handler - ${sentence.text}');
    _currentSentence = sentence as DemoSentence;
    _engine.addSentenceToWritten(sentence);

    // Simulate typing delay for visual effect
    await Future.delayed(const Duration(milliseconds: 300));
    notifyListeners();
  }

  Future<void> _handleRead(String text) async {
    debugPrint('SentencesService: Read handler - $text');
    // In a real app, this would trigger TTS
    // For demo, we just simulate a delay
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _handleAsk(BaseSentenceModel sentence) async {
    debugPrint('SentencesService: Ask handler - ${sentence.text}');
    _currentSentence = sentence as DemoSentence;
    _state = SentencesServiceState.waitingForChoice;
    _selectedChoice = null;
    notifyListeners();

    // Wait for user to select a choice
    _choiceCompleter = Completer<String>();
    await _choiceCompleter!.future;
  }

  Future<void> _handleWait(BaseSentenceModel sentence) async {
    debugPrint('SentencesService: Wait handler - ${sentence.text}');
    _currentSentence = sentence as DemoSentence;
    _state = SentencesServiceState.waitingForInput;
    notifyListeners();

    // Engine handles blocking via pauseUntilUserContinues
    await _engine.pauseUntilUserContinues();
  }

  Future<void> _handleNavigate(BaseSentenceModel sentence) async {
    debugPrint('SentencesService: Navigate handler - phase: ${sentence.phase}');
    // In a real app, this would trigger navigation
    await Future.delayed(const Duration(milliseconds: 200));
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Sample Text Generators
  // ─────────────────────────────────────────────────────────────────────────

  String _nextId() => 'demo_${++_sentenceCounter}';

  final List<String> _writeSamples = [
    'Welcome to the Fifty Sentences Engine demo.',
    'The engine processes sentences one by one.',
    'Each sentence has an instruction type.',
    'Write instructions display text on screen.',
    'The system supports multiple instruction types.',
  ];

  final List<String> _readSamples = [
    'This sentence would be spoken aloud.',
    'TTS integration enables voice output.',
    'Read instructions trigger text-to-speech.',
    'Voice narration enhances game immersion.',
    'Audio feedback provides accessibility.',
  ];

  final List<String> _askSamples = [
    'What would you like to do?',
    'How shall we proceed?',
    'Which path will you choose?',
    'What is your decision?',
    'Select your response.',
  ];

  final List<String> _waitSamples = [
    'Tap anywhere to continue...',
    'Press to proceed...',
    'Touch to advance...',
    'Tap when ready...',
    'Continue when ready...',
  ];

  String _getWriteSampleText() =>
      _writeSamples[_sentenceCounter % _writeSamples.length];

  String _getReadSampleText() =>
      _readSamples[_sentenceCounter % _readSamples.length];

  String _getAskSampleText() =>
      _askSamples[_sentenceCounter % _askSamples.length];

  String _getWaitSampleText() =>
      _waitSamples[_sentenceCounter % _waitSamples.length];

  // ─────────────────────────────────────────────────────────────────────────
  // Cleanup
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void dispose() {
    debugPrint('SentencesService: Disposing');
    _engine.dispose();
    super.dispose();
  }
}
