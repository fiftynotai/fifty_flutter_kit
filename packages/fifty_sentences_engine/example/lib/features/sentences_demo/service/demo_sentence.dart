/// Demo sentence model implementing BaseSentenceModel.
///
/// Provides a concrete implementation for demonstration purposes.
library;

import 'package:fifty_sentences_engine/fifty_sentences_engine.dart';

/// A demonstration sentence model for the example app.
///
/// Implements [BaseSentenceModel] with all required properties.
class DemoSentence implements BaseSentenceModel {
  /// Creates a new demo sentence.
  const DemoSentence({
    required this.id,
    required this.text,
    required this.instruction,
    this.order,
    this.waitForUserInput = false,
    this.phase,
    this.choices = const [],
  });

  /// Creates a write instruction sentence.
  factory DemoSentence.write({
    required String id,
    required String text,
    int? order,
  }) {
    return DemoSentence(
      id: id,
      text: text,
      instruction: 'write',
      order: order,
    );
  }

  /// Creates a read instruction sentence (for TTS).
  factory DemoSentence.read({
    required String id,
    required String text,
    int? order,
  }) {
    return DemoSentence(
      id: id,
      text: text,
      instruction: 'read',
      order: order,
    );
  }

  /// Creates a write+read instruction sentence (display and speak).
  factory DemoSentence.writeAndRead({
    required String id,
    required String text,
    int? order,
  }) {
    return DemoSentence(
      id: id,
      text: text,
      instruction: 'write+read',
      order: order,
    );
  }

  /// Creates an ask instruction sentence with choices.
  factory DemoSentence.ask({
    required String id,
    required String text,
    required List<String> choices,
    int? order,
  }) {
    return DemoSentence(
      id: id,
      text: text,
      instruction: 'ask',
      choices: choices,
      order: order,
    );
  }

  /// Creates a wait instruction sentence (tap to continue).
  factory DemoSentence.wait({
    required String id,
    required String text,
    int? order,
  }) {
    return DemoSentence(
      id: id,
      text: text,
      instruction: 'wait',
      waitForUserInput: true,
      order: order,
    );
  }

  /// Creates a navigate instruction sentence.
  factory DemoSentence.navigate({
    required String id,
    required String text,
    required String phase,
    int? order,
  }) {
    return DemoSentence(
      id: id,
      text: text,
      instruction: 'navigate',
      phase: phase,
      waitForUserInput: true,
      order: order,
    );
  }

  /// Unique identifier for this sentence.
  final String id;

  @override
  final String text;

  @override
  final String instruction;

  @override
  final int? order;

  @override
  final bool waitForUserInput;

  @override
  final String? phase;

  @override
  final List<String> choices;

  @override
  String toString() => 'DemoSentence(id: $id, instruction: $instruction, text: $text)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DemoSentence && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
