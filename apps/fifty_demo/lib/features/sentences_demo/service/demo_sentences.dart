/// Demo Sentences
///
/// Sample sentence sequences for the demo.
library;

/// A single sentence in the demo.
class DemoSentence {
  const DemoSentence({
    required this.id,
    required this.text,
    this.speaker,
    this.delayMs,
  });

  /// Unique identifier for the sentence.
  final String id;

  /// The text content of the sentence.
  final String text;

  /// Optional speaker name.
  final String? speaker;

  /// Optional delay in milliseconds before showing next sentence (for auto-advance).
  final int? delayMs;
}

/// Sample sentence sequences.
abstract class DemoSentences {
  /// Introduction dialogue.
  static const List<DemoSentence> introduction = [
    DemoSentence(
      id: 'intro_1',
      text: 'Welcome to the Sentences Engine demonstration.',
      speaker: 'SYSTEM',
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'intro_2',
      text:
          'This demo showcases the sentence queue and typewriter effect system.',
      speaker: 'SYSTEM',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'intro_3',
      text: 'Sentences are processed one at a time with smooth animations.',
      speaker: 'SYSTEM',
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'intro_4',
      text: 'You can navigate forward and backward through the queue.',
      speaker: 'SYSTEM',
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'intro_5',
      text: 'Or enable auto-advance for hands-free playback.',
      speaker: 'SYSTEM',
      delayMs: 2000,
    ),
  ];

  /// Tutorial dialogue.
  static const List<DemoSentence> tutorial = [
    DemoSentence(
      id: 'tut_1',
      text: 'Let me show you the basics of the sentence system.',
      speaker: 'GUIDE',
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'tut_2',
      text: 'Tap on the dialogue area to advance to the next sentence.',
      speaker: 'GUIDE',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'tut_3',
      text: 'If text is still typing, tapping will complete it instantly.',
      speaker: 'GUIDE',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'tut_4',
      text: 'Use the control buttons below for more navigation options.',
      speaker: 'GUIDE',
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'tut_5',
      text: 'The queue panel shows all sentences and your current position.',
      speaker: 'GUIDE',
      delayMs: 2500,
    ),
  ];

  /// Story dialogue.
  static const List<DemoSentence> story = [
    DemoSentence(
      id: 'story_1',
      text: 'The terminal flickered to life in the darkness.',
      speaker: 'NARRATOR',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'story_2',
      text: 'Lines of crimson code scrolled across the void black screen.',
      speaker: 'NARRATOR',
      delayMs: 3000,
    ),
    DemoSentence(
      id: 'story_3',
      text: '"System initialized," the voice announced.',
      speaker: 'AI',
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'story_4',
      text: '"Welcome to the Fifty ecosystem, Commander."',
      speaker: 'AI',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'story_5',
      text: 'The grid map illuminated, revealing the path ahead.',
      speaker: 'NARRATOR',
      delayMs: 3000,
    ),
    DemoSentence(
      id: 'story_6',
      text: '"Your journey begins now."',
      speaker: 'AI',
      delayMs: 2000,
    ),
  ];

  /// Conversation dialogue.
  static const List<DemoSentence> conversation = [
    DemoSentence(
      id: 'conv_1',
      text: 'Hello! How can I help you today?',
      speaker: 'ASSISTANT',
      delayMs: 2000,
    ),
    DemoSentence(
      id: 'conv_2',
      text: 'I need to understand how this sentence system works.',
      speaker: 'USER',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'conv_3',
      text: 'Of course! The system manages a queue of sentences.',
      speaker: 'ASSISTANT',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'conv_4',
      text: 'Each sentence is displayed with a typewriter effect.',
      speaker: 'ASSISTANT',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'conv_5',
      text: 'That sounds useful for games and interactive content!',
      speaker: 'USER',
      delayMs: 2500,
    ),
    DemoSentence(
      id: 'conv_6',
      text: 'Exactly! It creates an engaging narrative experience.',
      speaker: 'ASSISTANT',
      delayMs: 2000,
    ),
  ];

  /// All available dialogues with labels.
  static const Map<String, List<DemoSentence>> all = {
    'Introduction': introduction,
    'Tutorial': tutorial,
    'Story': story,
    'Conversation': conversation,
  };

  /// Get dialogue names.
  static List<String> get dialogueNames => all.keys.toList();
}
