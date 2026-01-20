import 'achievement_context.dart';

/// Base class for all achievement conditions.
///
/// Conditions determine when an achievement is unlocked by evaluating
/// tracked events and stats in an [AchievementContext].
///
/// **Built-in condition types:**
/// - [EventCondition] - Triggered by a single event occurrence
/// - [CountCondition] - Requires a cumulative event count
/// - [ThresholdCondition] - Stat reaches a target value
/// - [CompositeCondition] - Combines multiple conditions (AND/OR)
/// - [TimeCondition] - Time-based challenges
/// - [SequenceCondition] - Ordered event sequences
///
/// **Example:**
/// ```dart
/// // Kill 100 enemies
/// final condition = CountCondition('enemy_killed', target: 100);
///
/// // Check if complete
/// if (condition.evaluate(context)) {
///   print('Achievement unlocked!');
/// }
///
/// // Get progress (0.0 to 1.0)
/// print('Progress: ${condition.getProgress(context) * 100}%');
/// ```
abstract class AchievementCondition {
  /// Creates a new achievement condition.
  const AchievementCondition();

  /// Unique type identifier for serialization.
  String get type;

  /// Evaluates whether this condition is satisfied.
  ///
  /// Returns true if the achievement should be unlocked.
  bool evaluate(AchievementContext context);

  /// Gets the current progress towards completing this condition.
  ///
  /// Returns a value from 0.0 (no progress) to 1.0 (complete).
  /// For conditions that are binary (either complete or not),
  /// this should return 0.0 or 1.0.
  double getProgress(AchievementContext context);

  /// Gets the target value for this condition (if applicable).
  ///
  /// Used for displaying progress like "45/100 enemies killed".
  /// Returns null for conditions without a numeric target.
  int? get target => null;

  /// Gets the current value for this condition (if applicable).
  ///
  /// Used for displaying progress. Returns null by default.
  int? getCurrent(AchievementContext context) => null;

  /// Converts this condition to a JSON map.
  Map<String, dynamic> toJson();

  /// Creates a condition from a JSON map.
  ///
  /// Uses the 'type' field to determine which concrete class to create.
  /// Throws [ArgumentError] for unknown types.
  factory AchievementCondition.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;

    switch (type) {
      case 'event':
        return _EventConditionBase.fromJson(json);
      case 'count':
        return _CountConditionBase.fromJson(json);
      case 'threshold':
        return _ThresholdConditionBase.fromJson(json);
      case 'composite':
        return _CompositeConditionBase.fromJson(json);
      case 'time':
        return _TimeConditionBase.fromJson(json);
      case 'sequence':
        return _SequenceConditionBase.fromJson(json);
      default:
        throw ArgumentError('Unknown condition type: $type');
    }
  }
}

// These placeholder classes are replaced by the actual implementations
// but needed here for fromJson to work. The actual implementations
// are in their respective files and export themselves.

class _EventConditionBase extends AchievementCondition {
  final String event;
  const _EventConditionBase(this.event);

  @override
  String get type => 'event';

  @override
  bool evaluate(AchievementContext context) => context.hasEvent(event);

  @override
  double getProgress(AchievementContext context) =>
      evaluate(context) ? 1.0 : 0.0;

  @override
  Map<String, dynamic> toJson() => {'type': type, 'event': event};

  factory _EventConditionBase.fromJson(Map<String, dynamic> json) =>
      _EventConditionBase(json['event'] as String);
}

class _CountConditionBase extends AchievementCondition {
  final String event;
  final int targetCount;
  const _CountConditionBase(this.event, {required this.targetCount});

  @override
  String get type => 'count';

  @override
  int? get target => targetCount;

  @override
  int? getCurrent(AchievementContext context) => context.getEventCount(event);

  @override
  bool evaluate(AchievementContext context) =>
      context.getEventCount(event) >= targetCount;

  @override
  double getProgress(AchievementContext context) {
    final count = context.getEventCount(event);
    return (count / targetCount).clamp(0.0, 1.0);
  }

  @override
  Map<String, dynamic> toJson() =>
      {'type': type, 'event': event, 'target': targetCount};

  factory _CountConditionBase.fromJson(Map<String, dynamic> json) =>
      _CountConditionBase(
        json['event'] as String,
        targetCount: json['target'] as int,
      );
}

class _ThresholdConditionBase extends AchievementCondition {
  final String stat;
  final num targetValue;
  const _ThresholdConditionBase(this.stat, {required this.targetValue});

  @override
  String get type => 'threshold';

  @override
  int? get target => targetValue.toInt();

  @override
  int? getCurrent(AchievementContext context) =>
      context.getStat(stat).toInt();

  @override
  bool evaluate(AchievementContext context) =>
      context.getStat(stat) >= targetValue;

  @override
  double getProgress(AchievementContext context) {
    final value = context.getStat(stat);
    return (value / targetValue).clamp(0.0, 1.0);
  }

  @override
  Map<String, dynamic> toJson() =>
      {'type': type, 'stat': stat, 'target': targetValue};

  factory _ThresholdConditionBase.fromJson(Map<String, dynamic> json) =>
      _ThresholdConditionBase(
        json['stat'] as String,
        targetValue: json['target'] as num,
      );
}

/// Logical operator for composite conditions.
enum CompositeOperator {
  /// All conditions must be true (AND).
  and,

  /// At least one condition must be true (OR).
  or,
}

class _CompositeConditionBase extends AchievementCondition {
  final List<AchievementCondition> conditions;
  final CompositeOperator operator;

  const _CompositeConditionBase(
    this.conditions, {
    this.operator = CompositeOperator.and,
  });

  @override
  String get type => 'composite';

  @override
  bool evaluate(AchievementContext context) {
    if (operator == CompositeOperator.and) {
      return conditions.every((c) => c.evaluate(context));
    } else {
      return conditions.any((c) => c.evaluate(context));
    }
  }

  @override
  double getProgress(AchievementContext context) {
    if (conditions.isEmpty) return 1.0;

    if (operator == CompositeOperator.and) {
      // Average progress of all conditions
      final totalProgress =
          conditions.fold<double>(0.0, (sum, c) => sum + c.getProgress(context));
      return totalProgress / conditions.length;
    } else {
      // Max progress of any condition
      return conditions.fold<double>(
        0.0,
        (max, c) {
          final p = c.getProgress(context);
          return p > max ? p : max;
        },
      );
    }
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'operator': operator.name,
        'conditions': conditions.map((c) => c.toJson()).toList(),
      };

  factory _CompositeConditionBase.fromJson(Map<String, dynamic> json) {
    final conditions = (json['conditions'] as List<dynamic>)
        .map((c) => AchievementCondition.fromJson(c as Map<String, dynamic>))
        .toList();
    final operator = CompositeOperator.values.firstWhere(
      (o) => o.name == json['operator'],
      orElse: () => CompositeOperator.and,
    );
    return _CompositeConditionBase(conditions, operator: operator);
  }
}

class _TimeConditionBase extends AchievementCondition {
  final Duration duration;
  final String? duringEvent;

  const _TimeConditionBase(this.duration, {this.duringEvent});

  @override
  String get type => 'time';

  @override
  bool evaluate(AchievementContext context) {
    if (duringEvent != null && !context.hasEvent(duringEvent!)) {
      return false;
    }
    return context.sessionDuration >= duration;
  }

  @override
  double getProgress(AchievementContext context) {
    if (duringEvent != null && !context.hasEvent(duringEvent!)) {
      return 0.0;
    }
    final sessionSeconds = context.sessionDuration.inSeconds;
    final targetSeconds = duration.inSeconds;
    if (targetSeconds <= 0) return 1.0;
    return (sessionSeconds / targetSeconds).clamp(0.0, 1.0);
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'durationSeconds': duration.inSeconds,
        if (duringEvent != null) 'duringEvent': duringEvent,
      };

  factory _TimeConditionBase.fromJson(Map<String, dynamic> json) =>
      _TimeConditionBase(
        Duration(seconds: json['durationSeconds'] as int),
        duringEvent: json['duringEvent'] as String?,
      );
}

class _SequenceConditionBase extends AchievementCondition {
  final List<String> sequence;
  final bool strict;

  const _SequenceConditionBase(this.sequence, {this.strict = false});

  @override
  String get type => 'sequence';

  @override
  int? get target => sequence.length;

  @override
  bool evaluate(AchievementContext context) {
    if (sequence.isEmpty) return true;

    if (strict) {
      // Events must appear in exact order, consecutively
      final events = context.eventSequence;
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
      final events = context.eventSequence;
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
  int? getCurrent(AchievementContext context) {
    if (sequence.isEmpty) return 0;

    final events = context.eventSequence;
    int seqIndex = 0;

    if (strict) {
      // Find longest matching subsequence
      for (int i = 0; i <= events.length - sequence.length; i++) {
        int localMatch = 0;
        for (int j = 0; j < sequence.length && (i + j) < events.length; j++) {
          if (events[i + j] == sequence[j]) {
            localMatch++;
          } else {
            break;
          }
        }
        if (localMatch > seqIndex) seqIndex = localMatch;
        if (seqIndex >= sequence.length) break;
      }
    } else {
      for (final event in events) {
        if (seqIndex < sequence.length && event == sequence[seqIndex]) {
          seqIndex++;
        }
      }
    }

    return seqIndex;
  }

  @override
  double getProgress(AchievementContext context) {
    if (sequence.isEmpty) return 1.0;
    final current = getCurrent(context) ?? 0;
    return (current / sequence.length).clamp(0.0, 1.0);
  }

  @override
  Map<String, dynamic> toJson() => {
        'type': type,
        'sequence': sequence,
        'strict': strict,
      };

  factory _SequenceConditionBase.fromJson(Map<String, dynamic> json) =>
      _SequenceConditionBase(
        (json['sequence'] as List<dynamic>).cast<String>(),
        strict: json['strict'] as bool? ?? false,
      );
}
