/// **BaseNarrativeModel**
///
/// Abstract interface representing a sentence to be processed by the NarrativeEngine.
/// Your app-specific sentence model should implement or extend this.
///
/// **Properties:**
/// - [order] - Optional ordering for sentence queue sorting
/// - [text] - The sentence text content
/// - [instruction] - Processing instruction (read, write, ask, etc.)
/// - [waitForUserInput] - Whether to pause for user interaction
/// - [phase] - Optional phase identifier for navigation control
/// - [choices] - List of choice options for interactive sentences
abstract class BaseNarrativeModel {
  /// Optional order for queue sorting (lower values processed first).
  int? get order;

  /// The text content of the sentence.
  String get text;

  /// Processing instruction (e.g., 'read', 'write', 'ask', 'navigate').
  String get instruction;

  /// Whether to pause and wait for user input after processing.
  bool get waitForUserInput;

  /// Optional phase identifier for navigation control.
  String? get phase;

  /// List of choice options for interactive sentences.
  List<dynamic> get choices;
}
