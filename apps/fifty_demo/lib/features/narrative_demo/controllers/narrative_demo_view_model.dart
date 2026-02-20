/// Sentences Demo ViewModel
///
/// Business logic for the sentences demo feature.
/// Demonstrates all NarrativeEngine features including:
/// - write, read, wait, ask, navigate modes
/// - Combined read + write
/// - Order-based queue sorting
/// - Processing status tracking
/// - Pause/resume controls
library;

import 'dart:async';

import 'package:fifty_narrative_engine/fifty_narrative_engine.dart';
import 'package:get/get.dart';

import '../../../shared/services/speech_integration_service.dart';
import '../service/demo_narratives.dart';

/// Processing status mapped from NarrativeEngine.
enum DemoProcessingStatus {
  idle,
  processing,
  paused,
  cancelled,
  completed,
}

/// ViewModel for the sentences demo feature.
///
/// Manages sentence queue, typewriter effect, and playback controls
/// using the actual NarrativeEngine from fifty_narrative_engine.
class NarrativeDemoViewModel extends GetxController {
  NarrativeDemoViewModel({
    SpeechIntegrationService? speechService,
  }) : _speechService = speechService;

  /// Optional speech service for TTS in read mode.
  final SpeechIntegrationService? _speechService;

  /// The narrative engine instance.
  late final NarrativeEngine _engine;

  /// The sentence interpreter for handling instructions.
  late final NarrativeInterpreter _interpreter;

  // ---------------------------------------------------------------------------
  // State
  // ---------------------------------------------------------------------------

  /// The list of sentences in the queue.
  final _sentences = <DemoNarrative>[].obs;
  List<DemoNarrative> get sentences => _sentences;

  /// The current sentence index.
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  /// The currently displayed text (for typewriter effect).
  final _displayedText = ''.obs;
  String get displayedText => _displayedText.value;

  /// The current processing status.
  final _processingStatus = DemoProcessingStatus.idle.obs;
  DemoProcessingStatus get processingStatus => _processingStatus.value;

  /// Whether auto-advance is enabled.
  final _isAutoAdvanceEnabled = false.obs;
  bool get isAutoAdvanceEnabled => _isAutoAdvanceEnabled.value;

  /// The currently selected demo mode.
  final _selectedMode = DemoMode.write.obs;
  DemoMode get selectedMode => _selectedMode.value;

  /// The currently selected dialogue name (legacy).
  final _selectedDialogue = 'Introduction'.obs;
  String get selectedDialogue => _selectedDialogue.value;

  /// Current phase for navigate mode.
  final _currentPhase = ''.obs;
  String get currentPhase => _currentPhase.value;

  /// Last selected choice in ask mode.
  final _lastSelectedChoice = ''.obs;
  String get lastSelectedChoice => _lastSelectedChoice.value;

  /// Available choices for current ask sentence.
  final _currentChoices = <String>[].obs;
  List<String> get currentChoices => _currentChoices;

  /// Whether TTS is enabled for read mode.
  final _ttsEnabled = true.obs;
  bool get ttsEnabled => _ttsEnabled.value;

  /// Typing speed in milliseconds per character.
  final int _typingSpeedMs = 30;

  /// Timer for typewriter effect.
  Timer? _typingTimer;

  /// Timer for auto-advance delay.
  Timer? _autoAdvanceTimer;

  // ---------------------------------------------------------------------------
  // Computed Properties
  // ---------------------------------------------------------------------------

  /// The current sentence being displayed.
  DemoNarrative? get currentSentence =>
      _currentIndex.value < _sentences.length
          ? _sentences[_currentIndex.value]
          : null;

  /// Whether there are more sentences after the current one.
  bool get hasNext => _currentIndex.value < _sentences.length - 1;

  /// Whether there are sentences before the current one.
  bool get hasPrevious => _currentIndex.value > 0;

  /// Whether the engine is currently typing.
  bool get isTyping => _processingStatus.value == DemoProcessingStatus.processing;

  /// Whether the engine is paused.
  bool get isPaused => _processingStatus.value == DemoProcessingStatus.paused;

  /// Whether the engine is playing (auto-advancing).
  bool get isPlaying =>
      _processingStatus.value == DemoProcessingStatus.processing &&
      _isAutoAdvanceEnabled.value;

  /// Progress through the queue (0.0 to 1.0).
  double get progress =>
      _sentences.isEmpty ? 0.0 : (_currentIndex.value + 1) / _sentences.length;

  /// Progress text (e.g., "3/10").
  String get progressText =>
      '${_currentIndex.value + 1}/${_sentences.length}';

  /// Whether the queue is empty.
  bool get isEmpty => _sentences.isEmpty;

  /// Whether at the end of the queue.
  bool get isAtEnd =>
      _sentences.isNotEmpty && _currentIndex.value >= _sentences.length - 1;

  /// Whether currently waiting for user input.
  bool get isWaitingForInput =>
      _processingStatus.value == DemoProcessingStatus.paused &&
      currentSentence?.waitForUserInput == true;

  /// Whether currently showing choices.
  bool get isShowingChoices => _currentChoices.isNotEmpty;

  /// Status label for the processing state.
  String get statusLabel {
    return switch (_processingStatus.value) {
      DemoProcessingStatus.idle => 'IDLE',
      DemoProcessingStatus.processing => 'PROCESSING',
      DemoProcessingStatus.paused => isWaitingForInput ? 'WAITING' : 'PAUSED',
      DemoProcessingStatus.cancelled => 'CANCELLED',
      DemoProcessingStatus.completed => 'COMPLETED',
    };
  }

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    _initializeEngine();
    _loadMode(_selectedMode.value);
  }

  /// Initializes the NarrativeEngine and NarrativeInterpreter.
  void _initializeEngine() {
    // Create the engine with callbacks
    _engine = NarrativeEngine(
      onStatusChange: _handleStatusChange,
      onSentencesChanged: _handleSentencesChanged,
      onProcessingIndexChanged: _handleIndexChanged,
    );

    // Create the interpreter with handlers for each instruction type
    _interpreter = NarrativeInterpreter(
      engine: _engine,
      onRead: _handleRead,
      onWrite: _handleWrite,
      onAsk: _handleAsk,
      onWait: _handleWait,
      onNavigate: _handleNavigate,
      onUnhandled: _handleUnhandled,
    );

    // Register the interpreter with the engine
    _engine.registerInterpreter(_interpreter);
  }

  @override
  void onClose() {
    _typingTimer?.cancel();
    _autoAdvanceTimer?.cancel();
    _engine.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Engine Handlers
  // ---------------------------------------------------------------------------

  /// Handles status changes from the engine.
  void _handleStatusChange(ProcessingStatus status) {
    _processingStatus.value = switch (status) {
      ProcessingStatus.idle => DemoProcessingStatus.idle,
      ProcessingStatus.processing => DemoProcessingStatus.processing,
      ProcessingStatus.paused => DemoProcessingStatus.paused,
      ProcessingStatus.cancelled => DemoProcessingStatus.cancelled,
      ProcessingStatus.completed => DemoProcessingStatus.completed,
    };
    update();
  }

  /// Handles sentence list changes from the engine.
  void _handleSentencesChanged(List<BaseNarrativeModel> sentences) {
    // Engine tracks processed sentences, we track all sentences
    update();
  }

  /// Handles processing index changes from the engine.
  void _handleIndexChanged(int index) {
    // Engine index is 1-based for current processing, we use 0-based
    update();
  }

  /// Handles read instruction (TTS).
  Future<void> _handleRead(String text) async {
    final speechService = _speechService;
    if (_ttsEnabled.value && speechService != null) {
      await speechService.speak(text);
    }
  }

  /// Handles write instruction (display text).
  Future<void> _handleWrite(BaseNarrativeModel sentence) async {
    // Start typewriter effect
    await _typeText(sentence.text);
    _engine.addSentenceToWritten(sentence);
  }

  /// Handles ask instruction (show choices).
  Future<void> _handleAsk(BaseNarrativeModel sentence) async {
    // Display the question
    await _typeText(sentence.text);

    // Show choices and pause
    _currentChoices.clear();
    _currentChoices.addAll(sentence.choices.cast<String>());
    _engine.pause();
    update();

    // Wait for user to select a choice
    await _engine.pauseUntilUserContinues();
  }

  /// Handles wait instruction (pause until tap).
  Future<void> _handleWait(BaseNarrativeModel sentence) async {
    // Display text first
    await _typeText(sentence.text);

    // Then wait for user input
    await _engine.pauseUntilUserContinues();
  }

  /// Handles navigate instruction (phase transition).
  Future<void> _handleNavigate(BaseNarrativeModel sentence) async {
    if (sentence.phase != null) {
      _currentPhase.value = sentence.phase!;
    }
    update();
  }

  /// Handles unhandled instructions.
  Future<void> _handleUnhandled(BaseNarrativeModel sentence) async {
    // Default to write behavior
    await _typeText(sentence.text);
  }

  // ---------------------------------------------------------------------------
  // Mode Selection
  // ---------------------------------------------------------------------------

  /// Selects a demo mode and loads its sentences.
  void selectMode(DemoMode mode) {
    _selectedMode.value = mode;
    _loadMode(mode);
  }

  void _loadMode(DemoMode mode) {
    // Stop any ongoing playback
    _stopPlayback();

    // Get sentences for the mode
    var sentences = DemoNarratives.forMode(mode);

    // For order queue mode, sort by order
    if (mode == DemoMode.orderQueue) {
      sentences = List.from(sentences)
        ..sort((a, b) => (a.order ?? 0).compareTo(b.order ?? 0));
    }

    // Load new sentences
    _sentences.clear();
    _sentences.addAll(sentences);
    _currentIndex.value = 0;
    _displayedText.value = '';
    _currentChoices.clear();
    _currentPhase.value = '';
    _processingStatus.value = DemoProcessingStatus.idle;

    update();
  }

  // ---------------------------------------------------------------------------
  // Legacy Dialogue Selection (backward compatibility)
  // ---------------------------------------------------------------------------

  /// Loads a dialogue by name.
  void selectDialogue(String dialogueName) {
    if (!DemoNarratives.all.containsKey(dialogueName)) return;

    _selectedDialogue.value = dialogueName;
    _loadDialogue(dialogueName);
  }

  void _loadDialogue(String dialogueName) {
    final sentences = DemoNarratives.all[dialogueName];
    if (sentences == null) return;

    _stopPlayback();

    _sentences.clear();
    _sentences.addAll(sentences);
    _currentIndex.value = 0;
    _displayedText.value = '';
    _currentChoices.clear();
    _processingStatus.value = DemoProcessingStatus.idle;

    update();
  }

  // ---------------------------------------------------------------------------
  // Playback Controls
  // ---------------------------------------------------------------------------

  /// Starts playing from the current position.
  void play() {
    if (_sentences.isEmpty) return;

    _isAutoAdvanceEnabled.value = true;
    _processingStatus.value = DemoProcessingStatus.processing;
    _startTyping();
  }

  /// Pauses playback.
  void pause() {
    _isAutoAdvanceEnabled.value = false;
    _autoAdvanceTimer?.cancel();
    _engine.pause();

    if (_processingStatus.value == DemoProcessingStatus.processing) {
      _processingStatus.value = DemoProcessingStatus.paused;
    }

    update();
  }

  /// Resumes playback.
  void resume() {
    _engine.resume();
    if (_processingStatus.value == DemoProcessingStatus.paused) {
      _processingStatus.value = DemoProcessingStatus.processing;
    }
    update();
  }

  /// Toggles play/pause.
  void togglePlayPause() {
    if (isPlaying || _isAutoAdvanceEnabled.value) {
      pause();
    } else {
      play();
    }
  }

  /// Advances to the next sentence.
  void next() {
    if (!hasNext) {
      // At end of queue
      _processingStatus.value = DemoProcessingStatus.completed;
      _isAutoAdvanceEnabled.value = false;
      update();
      return;
    }

    _typingTimer?.cancel();
    _autoAdvanceTimer?.cancel();
    _currentChoices.clear();

    _currentIndex.value++;
    _displayedText.value = '';

    if (_isAutoAdvanceEnabled.value) {
      _processingStatus.value = DemoProcessingStatus.processing;
    }

    _startTyping();
  }

  /// Goes back to the previous sentence.
  void previous() {
    if (!hasPrevious) return;

    _typingTimer?.cancel();
    _autoAdvanceTimer?.cancel();
    _currentChoices.clear();

    _currentIndex.value--;
    _displayedText.value = '';

    _startTyping();
  }

  /// Handles tap on the dialogue display.
  void onDialogueTap() {
    if (isTyping) {
      _skipTyping();
    } else if (isWaitingForInput) {
      continueAfterInput();
    } else if (hasNext) {
      next();
    }
  }

  /// Continues after user input (for wait mode).
  void continueAfterInput() {
    _engine.continueAfterUserInput();
    _currentChoices.clear();

    if (hasNext) {
      next();
    } else {
      _processingStatus.value = DemoProcessingStatus.completed;
      _isAutoAdvanceEnabled.value = false;
    }

    update();
  }

  /// Handles choice selection in ask mode.
  void selectChoice(String choice) {
    _lastSelectedChoice.value = choice;
    _currentChoices.clear();
    _engine.continueAfterUserInput();

    if (hasNext) {
      next();
    } else {
      _processingStatus.value = DemoProcessingStatus.completed;
    }

    update();
  }

  /// Jumps to a specific sentence in the queue.
  void jumpToSentence(int index) {
    if (index < 0 || index >= _sentences.length) return;

    _typingTimer?.cancel();
    _autoAdvanceTimer?.cancel();
    _currentChoices.clear();

    _currentIndex.value = index;
    _displayedText.value = '';

    _startTyping();
  }

  /// Resets the dialogue to the beginning.
  void reset() {
    _stopPlayback();

    _currentIndex.value = 0;
    _displayedText.value = '';
    _currentChoices.clear();
    _currentPhase.value = '';
    _lastSelectedChoice.value = '';
    _processingStatus.value = DemoProcessingStatus.idle;
    _isAutoAdvanceEnabled.value = false;

    _engine.reset();
    update();
  }

  /// Clears the queue entirely.
  void clearQueue() {
    _stopPlayback();

    _sentences.clear();
    _currentIndex.value = 0;
    _displayedText.value = '';
    _currentChoices.clear();
    _processingStatus.value = DemoProcessingStatus.idle;
    _isAutoAdvanceEnabled.value = false;

    update();
  }

  /// Toggles TTS for read mode.
  void toggleTts() {
    _ttsEnabled.value = !_ttsEnabled.value;
    update();
  }

  // ---------------------------------------------------------------------------
  // Private Methods
  // ---------------------------------------------------------------------------

  void _stopPlayback() {
    _typingTimer?.cancel();
    _autoAdvanceTimer?.cancel();
    _isAutoAdvanceEnabled.value = false;
    _engine.cancel();
  }

  void _startTyping() {
    final sentence = currentSentence;
    if (sentence == null) return;

    _processingStatus.value = DemoProcessingStatus.processing;
    _displayedText.value = '';
    var charIndex = 0;

    _typingTimer = Timer.periodic(
      Duration(milliseconds: _typingSpeedMs),
      (timer) {
        if (charIndex < sentence.text.length) {
          _displayedText.value = sentence.text.substring(0, charIndex + 1);
          charIndex++;
          update();
        } else {
          timer.cancel();
          _onTypingComplete();
        }
      },
    );

    // Handle TTS for read instructions
    if (sentence.instruction.contains('read') && _ttsEnabled.value) {
      _handleRead(sentence.text);
    }

    update();
  }

  Future<void> _typeText(String text) async {
    final completer = Completer<void>();

    _displayedText.value = '';
    var charIndex = 0;

    _typingTimer = Timer.periodic(
      Duration(milliseconds: _typingSpeedMs),
      (timer) {
        if (charIndex < text.length) {
          _displayedText.value = text.substring(0, charIndex + 1);
          charIndex++;
          update();
        } else {
          timer.cancel();
          completer.complete();
        }
      },
    );

    return completer.future;
  }

  void _skipTyping() {
    _typingTimer?.cancel();
    final sentence = currentSentence;
    if (sentence != null) {
      _displayedText.value = sentence.text;
    }
    _onTypingComplete();
  }

  void _onTypingComplete() {
    final sentence = currentSentence;

    // Check if waiting for user input
    if (sentence?.waitForUserInput == true) {
      _processingStatus.value = DemoProcessingStatus.paused;

      // Show choices if this is an ask instruction
      if (sentence!.choices.isNotEmpty) {
        _currentChoices.clear();
        _currentChoices.addAll(sentence.choices);
      }

      update();
      return;
    }

    if (_isAutoAdvanceEnabled.value) {
      _processingStatus.value = DemoProcessingStatus.processing;
      _scheduleAutoAdvance();
    } else {
      _processingStatus.value = DemoProcessingStatus.paused;
    }
    update();
  }

  void _scheduleAutoAdvance() {
    final sentence = currentSentence;
    final delayMs = sentence?.delayMs ?? 2000;

    _autoAdvanceTimer = Timer(
      Duration(milliseconds: delayMs),
      () {
        if (_isAutoAdvanceEnabled.value && hasNext) {
          next();
        } else {
          _processingStatus.value = DemoProcessingStatus.completed;
          _isAutoAdvanceEnabled.value = false;
          update();
        }
      },
    );
  }
}
