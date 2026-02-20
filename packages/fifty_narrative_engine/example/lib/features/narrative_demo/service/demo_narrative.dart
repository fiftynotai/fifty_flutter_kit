/// Demo sentence model implementing BaseNarrativeModel.
///
/// Provides a concrete implementation for demonstration purposes.
library;

import 'package:fifty_narrative_engine/fifty_narrative_engine.dart';

/// A demonstration sentence model for the example app.
///
/// Implements [BaseNarrativeModel] with all required properties.
class DemoNarrative implements BaseNarrativeModel {
  /// Creates a new demo sentence.
  const DemoNarrative({
    required this.id,
    required this.text,
    required this.instruction,
    this.order,
    this.waitForUserInput = false,
    this.phase,
    this.choices = const [],
  });

  /// Creates a write instruction sentence.
  factory DemoNarrative.write({
    required String id,
    required String text,
    int? order,
  }) {
    return DemoNarrative(
      id: id,
      text: text,
      instruction: 'write',
      order: order,
    );
  }

  /// Creates a read instruction sentence (for TTS).
  factory DemoNarrative.read({
    required String id,
    required String text,
    int? order,
  }) {
    return DemoNarrative(
      id: id,
      text: text,
      instruction: 'read',
      order: order,
    );
  }

  /// Creates a write+read instruction sentence (display and speak).
  factory DemoNarrative.writeAndRead({
    required String id,
    required String text,
    int? order,
  }) {
    return DemoNarrative(
      id: id,
      text: text,
      instruction: 'write+read',
      order: order,
    );
  }

  /// Creates an ask instruction sentence with choices.
  factory DemoNarrative.ask({
    required String id,
    required String text,
    required List<String> choices,
    int? order,
  }) {
    return DemoNarrative(
      id: id,
      text: text,
      instruction: 'ask',
      choices: choices,
      order: order,
    );
  }

  /// Creates a wait instruction sentence (tap to continue).
  factory DemoNarrative.wait({
    required String id,
    required String text,
    int? order,
  }) {
    return DemoNarrative(
      id: id,
      text: text,
      instruction: 'wait',
      waitForUserInput: true,
      order: order,
    );
  }

  /// Creates a navigate instruction sentence.
  factory DemoNarrative.navigate({
    required String id,
    required String text,
    required String phase,
    int? order,
  }) {
    return DemoNarrative(
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
  String toString() => 'DemoNarrative(id: $id, instruction: $instruction, text: $text)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DemoNarrative && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
