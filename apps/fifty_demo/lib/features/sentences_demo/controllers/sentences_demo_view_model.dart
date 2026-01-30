/// Sentences Demo ViewModel
///
/// Business logic for the sentences demo feature.
/// Demonstrates sentence queue management and typewriter effect.
library;

import 'dart:async';

import 'package:get/get.dart';

import '../service/demo_sentences.dart';

/// Playback state for the sentence engine.
enum PlaybackState {
  /// Engine is idle, not playing.
  idle,

  /// Currently typing a sentence.
  typing,

  /// Finished typing, waiting for user input or auto-advance.
  waiting,

  /// Auto-advancing through sentences.
  playing,
}

/// ViewModel for the sentences demo feature.
///
/// Manages sentence queue, typewriter effect, and playback controls.
class SentencesDemoViewModel extends GetxController {
  /// The list of sentences in the queue.
  final _sentences = <DemoSentence>[].obs;
  List<DemoSentence> get sentences => _sentences;

  /// The current sentence index.
  final _currentIndex = 0.obs;
  int get currentIndex => _currentIndex.value;

  /// The currently displayed text (for typewriter effect).
  final _displayedText = ''.obs;
  String get displayedText => _displayedText.value;

  /// The current playback state.
  final _playbackState = PlaybackState.idle.obs;
  PlaybackState get playbackState => _playbackState.value;

  /// Whether auto-advance is enabled.
  final _isAutoAdvanceEnabled = false.obs;
  bool get isAutoAdvanceEnabled => _isAutoAdvanceEnabled.value;

  /// The currently selected dialogue name.
  final _selectedDialogue = 'Introduction'.obs;
  String get selectedDialogue => _selectedDialogue.value;

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
  DemoSentence? get currentSentence =>
      _currentIndex.value < _sentences.length
          ? _sentences[_currentIndex.value]
          : null;

  /// Whether there are more sentences after the current one.
  bool get hasNext => _currentIndex.value < _sentences.length - 1;

  /// Whether there are sentences before the current one.
  bool get hasPrevious => _currentIndex.value > 0;

  /// Whether the engine is currently typing.
  bool get isTyping => _playbackState.value == PlaybackState.typing;

  /// Whether the engine is playing (auto-advancing).
  bool get isPlaying => _playbackState.value == PlaybackState.playing;

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

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    _loadDialogue(_selectedDialogue.value);
  }

  @override
  void onClose() {
    _typingTimer?.cancel();
    _autoAdvanceTimer?.cancel();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Dialogue Selection
  // ---------------------------------------------------------------------------

  /// Loads a dialogue by name.
  void selectDialogue(String dialogueName) {
    if (!DemoSentences.all.containsKey(dialogueName)) return;

    _selectedDialogue.value = dialogueName;
    _loadDialogue(dialogueName);
  }

  void _loadDialogue(String dialogueName) {
    final sentences = DemoSentences.all[dialogueName];
    if (sentences == null) return;

    // Stop any ongoing playback
    _stopPlayback();

    // Load new sentences
    _sentences.clear();
    _sentences.addAll(sentences);
    _currentIndex.value = 0;
    _displayedText.value = '';
    _playbackState.value = PlaybackState.idle;

    update();
  }

  // ---------------------------------------------------------------------------
  // Playback Controls
  // ---------------------------------------------------------------------------

  /// Starts playing from the current position.
  void play() {
    if (_sentences.isEmpty) return;

    _isAutoAdvanceEnabled.value = true;
    _playbackState.value = PlaybackState.playing;
    _startTyping();
  }

  /// Pauses playback.
  void pause() {
    _isAutoAdvanceEnabled.value = false;
    _autoAdvanceTimer?.cancel();

    if (_playbackState.value == PlaybackState.playing) {
      _playbackState.value = PlaybackState.waiting;
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
      _playbackState.value = PlaybackState.idle;
      _isAutoAdvanceEnabled.value = false;
      update();
      return;
    }

    _typingTimer?.cancel();
    _autoAdvanceTimer?.cancel();

    _currentIndex.value++;
    _displayedText.value = '';

    if (_isAutoAdvanceEnabled.value) {
      _playbackState.value = PlaybackState.playing;
    }

    _startTyping();
  }

  /// Goes back to the previous sentence.
  void previous() {
    if (!hasPrevious) return;

    _typingTimer?.cancel();
    _autoAdvanceTimer?.cancel();

    _currentIndex.value--;
    _displayedText.value = '';

    _startTyping();
  }

  /// Handles tap on the dialogue display.
  ///
  /// If typing, completes the sentence. Otherwise, advances to next.
  void onDialogueTap() {
    if (isTyping) {
      // Skip typing animation
      _skipTyping();
    } else if (hasNext) {
      // Advance to next sentence
      next();
    }
  }

  /// Jumps to a specific sentence in the queue.
  void jumpToSentence(int index) {
    if (index < 0 || index >= _sentences.length) return;

    _typingTimer?.cancel();
    _autoAdvanceTimer?.cancel();

    _currentIndex.value = index;
    _displayedText.value = '';

    _startTyping();
  }

  /// Resets the dialogue to the beginning.
  void reset() {
    _stopPlayback();

    _currentIndex.value = 0;
    _displayedText.value = '';
    _playbackState.value = PlaybackState.idle;
    _isAutoAdvanceEnabled.value = false;

    update();
  }

  /// Clears the queue entirely.
  void clearQueue() {
    _stopPlayback();

    _sentences.clear();
    _currentIndex.value = 0;
    _displayedText.value = '';
    _playbackState.value = PlaybackState.idle;
    _isAutoAdvanceEnabled.value = false;

    update();
  }

  // ---------------------------------------------------------------------------
  // Private Methods
  // ---------------------------------------------------------------------------

  void _stopPlayback() {
    _typingTimer?.cancel();
    _autoAdvanceTimer?.cancel();
    _isAutoAdvanceEnabled.value = false;
  }

  void _startTyping() {
    final sentence = currentSentence;
    if (sentence == null) return;

    _playbackState.value = PlaybackState.typing;
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

    update();
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
    if (_isAutoAdvanceEnabled.value) {
      _playbackState.value = PlaybackState.playing;
      _scheduleAutoAdvance();
    } else {
      _playbackState.value = PlaybackState.waiting;
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
          _playbackState.value = PlaybackState.idle;
          _isAutoAdvanceEnabled.value = false;
          update();
        }
      },
    );
  }
}
