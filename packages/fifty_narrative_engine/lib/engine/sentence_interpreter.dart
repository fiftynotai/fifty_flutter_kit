import 'package:fifty_narrative_engine/data/base_sentence.dart';
import 'narrative_engine.dart';

/// **NarrativeInterpreter** - Core logic engine for sentence execution
///
/// A service responsible for interpreting and executing individual `BaseNarrativeModel` instructions
/// during in-game conversations.
///
/// It decouples the engine's core loop from UI and system concerns (e.g., TTS, navigation),
/// and instead delegates execution logic via injected handlers such as `onRead`, `onWrite`, etc.
///
/// **Key Responsibilities:**
/// - Parse and interpret the `instruction` field from a `BaseNarrativeModel`
/// - Trigger one or multiple handlers based on the instruction contents:
///   - `read` - Read aloud via TTS
///   - `write` - Display message in chat
///   - `ask` - Ask the player a question and wait for answer
///   - `navigate` - Forward to a new screen and wait
///   - `wait` - Await user input (e.g. "Tap to continue")
/// - Support chaining or combining instructions (e.g. `read + write`)
/// - Expose a fallback `onUnhandled` if none of the above matched
///
/// **Usage Example:**
/// ```dart
/// final interpreter = NarrativeInterpreter(
///   engine: sentenceEngine,
///   onRead: (text) => ttsService.speak(text),
///   onWrite: (s) => chatBox.write(s),
///   onAsk: (s) => ui.askQuestion(s),
/// );
///
/// await interpreter.interpret(sentence);
/// ```
class NarrativeInterpreter {
  /// Constructor with injected behavior handlers.
  NarrativeInterpreter({
    required this.engine,
    this.onRead,
    this.onWrite,
    this.onAsk,
    this.onNavigate,
    this.onWait,
    this.onUnhandled,
  });

  /// Reference to the parent engine for control flow operations.
  final NarrativeEngine engine;

  /// Callback to read the sentence text using TTS.
  final Future<void> Function(String text)? onRead;

  /// Callback to write the sentence to the chat UI.
  final Future<void> Function(BaseNarrativeModel sentence)? onWrite;

  /// Callback to show a question prompt and await a response.
  final Future<void> Function(BaseNarrativeModel sentence)? onAsk;

  /// Callback to trigger navigation and wait for resume.
  final Future<void> Function(BaseNarrativeModel sentence)? onNavigate;

  /// Callback to pause until the user taps or resumes manually.
  final Future<void> Function(BaseNarrativeModel sentence)? onWait;

  /// Called when the sentence instruction does not match any known type.
  final Future<void> Function(BaseNarrativeModel sentence)? onUnhandled;

  /// Tracks the current phase for navigation control.
  String currentPhase = '';

  /// **Interprets a single [BaseNarrativeModel] and executes the defined handlers**
  ///
  /// Parses the instruction and determines which actions to run.
  /// Multiple handlers can be triggered for a single sentence (e.g. both `read` and `write`).
  Future<void> interpret(BaseNarrativeModel sentence) async {
    final instruction = sentence.instruction.toLowerCase();
    final shouldAsk = sentence.choices.isNotEmpty;
    final shouldWait = sentence.waitForUserInput;
    final shouldNavigate =
        sentence.phase != null && sentence.phase != currentPhase;
    if (shouldNavigate) currentPhase = sentence.phase!;

    if (instruction.contains('write')) {
      await _handleWrite(sentence);
    }

    if (instruction.contains('read')) {
      await _handleRead(sentence);
    }

    if (shouldNavigate && shouldWait) {
      await engine.pauseUntilUserContinues();
    } else if (shouldWait) {
      await _handleWait(sentence);
    }

    if (shouldAsk) {
      await _handleAsk(sentence);
    }

    if (shouldNavigate) {
      await _handleNavigate(sentence);
    }

    if (!_isHandled(instruction)) {
      onUnhandled?.call(sentence);
    }
  }

  /// Checks whether the instruction includes any supported directive.
  bool _isHandled(String instruction) {
    return instruction.contains('read') ||
        instruction.contains('write') ||
        instruction.contains('ask') ||
        instruction.contains('wait') ||
        instruction.contains('navigate');
  }

  /// Triggers the read handler (e.g. TTS).
  Future<void> _handleRead(BaseNarrativeModel sentence) async {
    if (onRead != null) {
      await onRead!(sentence.text);
    }
  }

  /// Triggers the write handler (e.g. add to chat).
  Future<void> _handleWrite(BaseNarrativeModel sentence) async {
    if (onWrite != null) {
      await onWrite!(sentence);
    }
  }

  /// Triggers the ask handler (e.g. question prompt).
  Future<void> _handleAsk(BaseNarrativeModel sentence) async {
    if (onAsk != null) {
      await onAsk!(sentence);
    }
  }

  /// Triggers the navigate handler (e.g. forward user to another screen).
  Future<void> _handleNavigate(BaseNarrativeModel sentence) async {
    if (onNavigate != null) {
      await onNavigate!(sentence);
    }
  }

  /// Triggers the wait handler (e.g. wait for tap).
  Future<void> _handleWait(BaseNarrativeModel sentence) async {
    if (onWait != null) {
      await onWait!(sentence);
    }
  }
}
