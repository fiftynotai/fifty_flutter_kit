/// Demo Dialogues
///
/// Sample dialogue sequences for the demo.
library;

import '../../../shared/services/sentences_integration_service.dart';

/// Sample dialogue sequences.
abstract class DemoDialogues {
  /// Introduction dialogue.
  static const List<Sentence> introduction = [
    Sentence(
      id: 'intro_1',
      text: 'Welcome to the Fifty Flutter Kit demonstration.',
      speaker: 'SYSTEM',
    ),
    Sentence(
      id: 'intro_2',
      text:
          'This demo showcases the integration of multiple Fifty packages working together.',
      speaker: 'SYSTEM',
    ),
    Sentence(
      id: 'intro_3',
      text: 'The sentence engine handles text display with typing animations.',
      speaker: 'SYSTEM',
    ),
    Sentence(
      id: 'intro_4',
      text: 'While the speech engine provides text-to-speech capabilities.',
      speaker: 'SYSTEM',
    ),
    Sentence(
      id: 'intro_5',
      text: 'Together, they create an immersive narrative experience.',
      speaker: 'SYSTEM',
    ),
  ];

  /// Tutorial dialogue.
  static const List<Sentence> tutorial = [
    Sentence(
      id: 'tut_1',
      text: 'Let me show you how the dialogue system works.',
      speaker: 'GUIDE',
    ),
    Sentence(
      id: 'tut_2',
      text:
          'Tap anywhere on the text area to advance to the next sentence.',
      speaker: 'GUIDE',
    ),
    Sentence(
      id: 'tut_3',
      text:
          'You can also use voice commands like "next" or "continue" to progress.',
      speaker: 'GUIDE',
    ),
    Sentence(
      id: 'tut_4',
      text: 'Enable TTS to hear the dialogue spoken aloud.',
      speaker: 'GUIDE',
    ),
    Sentence(
      id: 'tut_5',
      text: 'Try enabling auto-advance for hands-free playback.',
      speaker: 'GUIDE',
    ),
  ];

  /// Story dialogue.
  static const List<Sentence> story = [
    Sentence(
      id: 'story_1',
      text: 'The terminal flickered to life in the darkness.',
      speaker: 'NARRATOR',
    ),
    Sentence(
      id: 'story_2',
      text: 'Lines of crimson code scrolled across the void black screen.',
      speaker: 'NARRATOR',
    ),
    Sentence(
      id: 'story_3',
      text: '"System initialized," the voice announced.',
      speaker: 'AI',
    ),
    Sentence(
      id: 'story_4',
      text: '"Welcome to Fifty Flutter Kit, Commander."',
      speaker: 'AI',
    ),
    Sentence(
      id: 'story_5',
      text: 'The grid map illuminated, revealing the path ahead.',
      speaker: 'NARRATOR',
    ),
    Sentence(
      id: 'story_6',
      text: '"Your journey begins now."',
      speaker: 'AI',
    ),
  ];

  /// All available dialogues with labels.
  static const Map<String, List<Sentence>> all = {
    'Introduction': introduction,
    'Tutorial': tutorial,
    'Story': story,
  };
}
