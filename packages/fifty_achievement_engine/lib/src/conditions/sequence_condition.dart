import 'achievement_condition.dart';
import 'achievement_context.dart';

/// A condition that requires events to occur in a specific order.
///
/// Use this for sequence-based achievements like "Complete a perfect
/// combo" or "Progress through story chapters in order".
///
/// **Example:**
/// ```dart
/// // Complete a combo: light, light, heavy
/// final condition = SequenceCondition(
///   ['light_attack', 'light_attack', 'heavy_attack'],
///   strict: true, // Must be consecutive
/// );
///
/// // Complete story chapters in any order
/// final storyCondition = SequenceCondition(
///   ['chapter_1_complete', 'chapter_2_complete', 'chapter_3_complete'],
///   strict: false, // Can have other events between
/// );
/// ```
class SequenceCondition extends AchievementCondition {
  /// Creates a sequence condition.
  ///
  /// [sequence] is the ordered list of events required.
  /// [strict] determines if events must be consecutive (default: false).
  const SequenceCondition(
    this.sequence, {
    this.strict = false,
  });

  /// The required sequence of events.
  final List<String> sequence;

  /// Whether events must occur consecutively.
  ///
  /// If true, the events must appear one after another without
  /// any other events in between.
  /// If false, other events can occur between sequence events.
  final bool strict;

  @override
  String get type => 'sequence';

  @override
  int? get target => sequence.length;

  @override
  int? getCurrent(AchievementContext context) {
    if (sequence.isEmpty) return 0;

    final events = context.eventSequence;
    int matchedCount = 0;

    if (strict) {
      // Find the longest consecutive match
      for (int i = 0; i <= events.length - sequence.length; i++) {
        int localMatch = 0;
        for (int j = 0; j < sequence.length && (i + j) < events.length; j++) {
          if (events[i + j] == sequence[j]) {
            localMatch++;
          } else {
            break;
          }
        }
        if (localMatch > matchedCount) {
          matchedCount = localMatch;
        }
        if (matchedCount >= sequence.length) break;
      }
    } else {
      // Find how many sequence events have been matched in order
      int seqIndex = 0;
      for (final event in events) {
        if (seqIndex < sequence.length && event == sequence[seqIndex]) {
          seqIndex++;
        }
      }
      matchedCount = seqIndex;
    }

    return matchedCount;
  }

  @override
  bool evaluate(AchievementContext context) {
    if (sequence.isEmpty) return true;

    final events = context.eventSequence;

    if (strict) {
      // Events must appear in exact order, consecutively
      for (int i = 0; i <= events.length - sequence.length; i++) {
        bool match = true;
        for (int j = 0; j < sequence.length; j++) {
          if (events[i + j] != sequence[j]) {
            match = false;
            break;
          }
        }
        if (match) return true;
      }
      return false;
    } else {
      // Events must appear in order, but not necessarily consecutive
      int seqIndex = 0;
      for (final event in events) {
        if (event == sequence[seqIndex]) {
          seqIndex++;
          if (seqIndex >= sequence.length) return true;
        }
      }
      return false;
    }
  }

  @override
  double getProgress(AchievementContext context) {
    if (sequence.isEmpty) return 1.0;
    final current = getCurrent(context) ?? 0;
    return (current / sequence.length).clamp(0.0, 1.0);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'sequence': sequence,
      'strict': strict,
    };
  }

  /// Creates a sequence condition from a JSON map.
  factory SequenceCondition.fromJson(Map<String, dynamic> json) {
    return SequenceCondition(
      (json['sequence'] as List<dynamic>).cast<String>(),
      strict: json['strict'] as bool? ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SequenceCondition) return false;
    if (strict != other.strict) return false;
    if (sequence.length != other.sequence.length) return false;
    for (int i = 0; i < sequence.length; i++) {
      if (sequence[i] != other.sequence[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(sequence, strict);

  @override
  String toString() {
    final strictStr = strict ? ', strict' : '';
    return 'SequenceCondition(${sequence.length} events$strictStr)';
  }
}
