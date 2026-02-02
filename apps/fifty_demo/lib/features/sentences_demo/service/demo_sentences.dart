/// Demo Sentences
///
/// Sample sentence sequences for the demo implementing BaseSentenceModel
/// from the fifty_sentences_engine package.
library;

import 'package:fifty_sentences_engine/fifty_sentences_engine.dart';

/// A single sentence in the demo implementing [BaseSentenceModel].
///
/// Supports all instruction types: read, write, ask, wait, navigate,
/// and combined instructions (e.g., 'read + write').
class DemoSentence implements BaseSentenceModel {
  const DemoSentence({
    required this.id,
    required this.text,
    this.speaker,
    this.delayMs,
    this.instruction = 'write',
    this.waitForUserInput = false,
    this.phase,
    this.choices = const [],
    this.order,
  });

  /// Unique identifier for the sentence.
  final String id;

  /// Optional speaker name.
  final String? speaker;

  /// Optional delay in milliseconds before showing next sentence (for auto-advance).
  final int? delayMs;

  // ─────────────────────────────────────────────────────────────────────────
  // BaseSentenceModel Implementation
  // ─────────────────────────────────────────────────────────────────────────

  @override
  final int? order;

  @override
  final String text;

  @override
  final String instruction;

  @override
  final bool waitForUserInput;

  @override
  final String? phase;

  @override
  final List<String> choices;
}

/// Demo mode representing different instruction types.
enum DemoMode {
  write('Write Mode', 'Display text on screen'),
  read('Read Mode', 'Speak text using TTS'),
  wait('Wait Mode', 'Pause until user taps'),
  ask('Ask Mode', 'Show choices and capture selection'),
  navigate('Navigate Mode', 'Transition between phases'),
  combined('Combined Mode', 'Read + Write simultaneously'),
  orderQueue('Order Queue', 'Demonstrate priority sorting');

  const DemoMode(this.displayName, this.description);

  final String displayName;
  final String description;
}

/// Sample sentence sequences for each instruction type.
abstract class DemoSentences {
  // ─────────────────────────────────────────────────────────────────────────
  // Write Mode - Basic text display
  // ─────────────────────────────────────────────────────────────────────────

  /// Write-only sentences (text display without TTS).
  static const List<DemoSentence> writeMode = [
    DemoSentence(
      id: 'write_1',
      text: 'This sentence is displayed using WRITE mode.',
      speaker: 'SYSTEM',
      instruction: 'write',
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'write_2',
      text: 'Text appears character by character with a typewriter effect.',
      speaker: 'SYSTEM',
      instruction: 'write',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'write_3',
      text: 'This is the most common instruction type for visual novels.',
      speaker: 'SYSTEM',
      instruction: 'write',
      delayMs: 2000,
    ),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // Read Mode - TTS speech
  // ─────────────────────────────────────────────────────────────────────────

  /// Read-only sentences (TTS without text display).
  static const List<DemoSentence> readMode = [
    DemoSentence(
      id: 'read_1',
      text: 'This sentence is spoken aloud using text to speech.',
      speaker: 'NARRATOR',
      instruction: 'read',
      delayMs: 3000,
    ),
    DemoSentence(
      id: 'read_2',
      text: 'Read mode uses the Speech Engine for voice synthesis.',
      speaker: 'NARRATOR',
      instruction: 'read',
      delayMs: 3000,
    ),
    DemoSentence(
      id: 'read_3',
      text: 'Perfect for accessibility or immersive audio experiences.',
      speaker: 'NARRATOR',
      instruction: 'read',
      delayMs: 3000,
    ),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // Wait Mode - User input required
  // ─────────────────────────────────────────────────────────────────────────

  /// Wait sentences (pause until user tap).
  static const List<DemoSentence> waitMode = [
    DemoSentence(
      id: 'wait_1',
      text: 'This message requires you to tap to continue.',
      speaker: 'GUIDE',
      instruction: 'write',
      waitForUserInput: true,
      delayMs: 0,
    ),
    DemoSentence(
      id: 'wait_2',
      text: 'Wait mode pauses the engine until user interaction.',
      speaker: 'GUIDE',
      instruction: 'write',
      waitForUserInput: true,
      delayMs: 0,
    ),
    DemoSentence(
      id: 'wait_3',
      text: 'Useful for important story beats or instructions.',
      speaker: 'GUIDE',
      instruction: 'write',
      waitForUserInput: true,
      delayMs: 0,
    ),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // Ask Mode - Choice selection
  // ─────────────────────────────────────────────────────────────────────────

  /// Ask sentences (present choices to user).
  static const List<DemoSentence> askMode = [
    DemoSentence(
      id: 'ask_1',
      text: 'What would you like to do next?',
      speaker: 'ASSISTANT',
      instruction: 'ask',
      choices: ['Continue the demo', 'Go back', 'Skip ahead'],
      waitForUserInput: true,
      delayMs: 0,
    ),
    DemoSentence(
      id: 'ask_2',
      text: 'How are you enjoying this demo so far?',
      speaker: 'ASSISTANT',
      instruction: 'ask',
      choices: ['Great!', 'Pretty good', 'Could be better'],
      waitForUserInput: true,
      delayMs: 0,
    ),
    DemoSentence(
      id: 'ask_3',
      text: 'Which feature interests you most?',
      speaker: 'ASSISTANT',
      instruction: 'ask',
      choices: ['Typewriter effect', 'TTS integration', 'Choice system', 'All of them!'],
      waitForUserInput: true,
      delayMs: 0,
    ),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // Navigate Mode - Phase transitions
  // ─────────────────────────────────────────────────────────────────────────

  /// Navigate sentences (phase transitions).
  static const List<DemoSentence> navigateMode = [
    DemoSentence(
      id: 'nav_1',
      text: 'You are in PHASE ONE - Introduction',
      speaker: 'SYSTEM',
      instruction: 'write',
      phase: 'phase_1',
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'nav_2',
      text: 'Transitioning to PHASE TWO...',
      speaker: 'SYSTEM',
      instruction: 'navigate',
      phase: 'phase_2',
      waitForUserInput: true,
      delayMs: 0,
    ),
    DemoSentence(
      id: 'nav_3',
      text: 'You are now in PHASE TWO - Exploration',
      speaker: 'SYSTEM',
      instruction: 'write',
      phase: 'phase_2',
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'nav_4',
      text: 'Navigate mode enables scene and chapter transitions.',
      speaker: 'SYSTEM',
      instruction: 'write',
      phase: 'phase_2',
      delayMs: 2000,
    ),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // Combined Mode - Read + Write
  // ─────────────────────────────────────────────────────────────────────────

  /// Combined sentences (both read and write).
  static const List<DemoSentence> combinedMode = [
    DemoSentence(
      id: 'combo_1',
      text: 'This text is displayed AND spoken at the same time.',
      speaker: 'NARRATOR',
      instruction: 'read + write',
      delayMs: 3500,
    ),
    DemoSentence(
      id: 'combo_2',
      text: 'Combined mode provides both visual and audio feedback.',
      speaker: 'NARRATOR',
      instruction: 'read + write',
      delayMs: 3500,
    ),
    DemoSentence(
      id: 'combo_3',
      text: 'Perfect for maximum immersion and accessibility.',
      speaker: 'NARRATOR',
      instruction: 'read + write',
      delayMs: 3500,
    ),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // Order Queue - Priority sorting demonstration
  // ─────────────────────────────────────────────────────────────────────────

  /// Order-based queue demonstration.
  /// These sentences have explicit order values and will be added out-of-order
  /// but processed in order.
  static const List<DemoSentence> orderQueue = [
    DemoSentence(
      id: 'order_3',
      text: 'THIRD: This was added first but has order 3.',
      speaker: 'QUEUE',
      instruction: 'write',
      order: 3,
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'order_1',
      text: 'FIRST: This was added second but has order 1.',
      speaker: 'QUEUE',
      instruction: 'write',
      order: 1,
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'order_2',
      text: 'SECOND: This was added third but has order 2.',
      speaker: 'QUEUE',
      instruction: 'write',
      order: 2,
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'order_4',
      text: 'FOURTH: Order-based sorting ensures correct sequence.',
      speaker: 'QUEUE',
      instruction: 'write',
      order: 4,
      delayMs: 2000,
    ),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // Legacy Dialogues (for backward compatibility)
  // ─────────────────────────────────────────────────────────────────────────

  /// Introduction dialogue.
  static const List<DemoSentence> introduction = [
    DemoSentence(
      id: 'intro_1',
      text: 'Welcome to the Sentences Engine demonstration.',
      speaker: 'SYSTEM',
      instruction: 'write',
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'intro_2',
      text: 'This demo showcases the sentence queue and typewriter effect system.',
      speaker: 'SYSTEM',
      instruction: 'write',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'intro_3',
      text: 'Sentences are processed one at a time with smooth animations.',
      speaker: 'SYSTEM',
      instruction: 'write',
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'intro_4',
      text: 'You can navigate forward and backward through the queue.',
      speaker: 'SYSTEM',
      instruction: 'write',
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'intro_5',
      text: 'Or enable auto-advance for hands-free playback.',
      speaker: 'SYSTEM',
      instruction: 'write',
      delayMs: 2000,
    ),
  ];

  /// Tutorial dialogue.
  static const List<DemoSentence> tutorial = [
    DemoSentence(
      id: 'tut_1',
      text: 'Let me show you the basics of the sentence system.',
      speaker: 'GUIDE',
      instruction: 'write',
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'tut_2',
      text: 'Tap on the dialogue area to advance to the next sentence.',
      speaker: 'GUIDE',
      instruction: 'write',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'tut_3',
      text: 'If text is still typing, tapping will complete it instantly.',
      speaker: 'GUIDE',
      instruction: 'write',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'tut_4',
      text: 'Use the control buttons below for more navigation options.',
      speaker: 'GUIDE',
      instruction: 'write',
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'tut_5',
      text: 'The queue panel shows all sentences and your current position.',
      speaker: 'GUIDE',
      instruction: 'write',
      delayMs: 2500,
    ),
  ];

  /// Story dialogue.
  static const List<DemoSentence> story = [
    DemoSentence(
      id: 'story_1',
      text: 'The terminal flickered to life in the darkness.',
      speaker: 'NARRATOR',
      instruction: 'write',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'story_2',
      text: 'Lines of crimson code scrolled across the void black screen.',
      speaker: 'NARRATOR',
      instruction: 'write',
      delayMs: 3000,
    ),
    DemoSentence(
      id: 'story_3',
      text: '"System initialized," the voice announced.',
      speaker: 'AI',
      instruction: 'write',
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'story_4',
      text: '"Welcome to the Fifty ecosystem, Commander."',
      speaker: 'AI',
      instruction: 'write',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'story_5',
      text: 'The grid map illuminated, revealing the path ahead.',
      speaker: 'NARRATOR',
      instruction: 'write',
      delayMs: 3000,
    ),
    DemoSentence(
      id: 'story_6',
      text: '"Your journey begins now."',
      speaker: 'AI',
      instruction: 'write',
      delayMs: 2000,
    ),
  ];

  /// Conversation dialogue.
  static const List<DemoSentence> conversation = [
    DemoSentence(
      id: 'conv_1',
      text: 'Hello! How can I help you today?',
      speaker: 'ASSISTANT',
      instruction: 'write',
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'conv_2',
      text: 'I need to understand how this sentence system works.',
      speaker: 'USER',
      instruction: 'write',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'conv_3',
      text: 'Of course! The system manages a queue of sentences.',
      speaker: 'ASSISTANT',
      instruction: 'write',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'conv_4',
      text: 'Each sentence is displayed with a typewriter effect.',
      speaker: 'ASSISTANT',
      instruction: 'write',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'conv_5',
      text: 'That sounds useful for games and interactive content!',
      speaker: 'USER',
      instruction: 'write',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'conv_6',
      text: 'Exactly! It creates an engaging narrative experience.',
      speaker: 'ASSISTANT',
      instruction: 'write',
      delayMs: 2000,
    ),
  ];

  // ─────────────────────────────────────────────────────────────────────────
  // Mode-based Access
  // ─────────────────────────────────────────────────────────────────────────

  /// Get sentences for a specific demo mode.
  static List<DemoSentence> forMode(DemoMode mode) {
    return switch (mode) {
      DemoMode.write => writeMode,
      DemoMode.read => readMode,
      DemoMode.wait => waitMode,
      DemoMode.ask => askMode,
      DemoMode.navigate => navigateMode,
      DemoMode.combined => combinedMode,
      DemoMode.orderQueue => orderQueue,
    };
  }

  /// All available dialogues with labels (legacy).
  static const Map<String, List<DemoSentence>> all = {
    'Introduction': introduction,
    'Tutorial': tutorial,
    'Story': story,
    'Conversation': conversation,
  };

  /// Get dialogue names.
  static List<String> get dialogueNames => all.keys.toList();
}
