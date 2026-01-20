import 'package:flutter/foundation.dart';

/// Context containing all tracked data for evaluating achievement conditions.
///
/// The context is passed to conditions for evaluation and progress
/// calculation. It contains event counts, stat values, and event history.
///
/// **Example:**
/// ```dart
/// final context = AchievementContext(
///   eventCounts: {'enemy_killed': 50, 'boss_killed': 3},
///   stats: {'level': 25, 'damage_dealt': 10000.0},
///   eventSequence: ['game_started', 'first_kill', 'level_up'],
///   sessionStart: DateTime.now().subtract(Duration(hours: 2)),
/// );
/// ```
@immutable
class AchievementContext {
  /// Creates an achievement context.
  const AchievementContext({
    this.eventCounts = const {},
    this.stats = const {},
    this.eventSequence = const [],
    this.sessionStart,
    this.customData = const {},
  });

  /// Creates an empty context.
  factory AchievementContext.empty() => const AchievementContext();

  /// Counts of how many times each event has occurred.
  ///
  /// Key: event name, Value: count
  /// Example: {'enemy_killed': 50, 'item_collected': 100}
  final Map<String, int> eventCounts;

  /// Current values of tracked statistics.
  ///
  /// Key: stat name, Value: current value
  /// Example: {'level': 25, 'health': 100.0, 'gold': 5000}
  final Map<String, num> stats;

  /// Ordered list of events that have occurred.
  ///
  /// Used for sequence-based achievements.
  /// Example: ['game_started', 'first_kill', 'first_death', 'respawn']
  final List<String> eventSequence;

  /// When the current session started (for time-based achievements).
  final DateTime? sessionStart;

  /// Custom data for game-specific conditions.
  ///
  /// Use this for any data that doesn't fit the standard categories.
  final Map<String, dynamic> customData;

  /// Gets the count for a specific event.
  ///
  /// Returns 0 if the event hasn't been tracked.
  int getEventCount(String event) => eventCounts[event] ?? 0;

  /// Gets the value of a specific stat.
  ///
  /// Returns 0 if the stat hasn't been tracked.
  num getStat(String stat) => stats[stat] ?? 0;

  /// Checks if an event has occurred at least once.
  bool hasEvent(String event) => getEventCount(event) > 0;

  /// Gets the duration since session start.
  ///
  /// Returns [Duration.zero] if no session start is set.
  Duration get sessionDuration {
    if (sessionStart == null) return Duration.zero;
    return DateTime.now().difference(sessionStart!);
  }

  /// Creates a copy with the given fields replaced.
  AchievementContext copyWith({
    Map<String, int>? eventCounts,
    Map<String, num>? stats,
    List<String>? eventSequence,
    DateTime? sessionStart,
    Map<String, dynamic>? customData,
  }) {
    return AchievementContext(
      eventCounts: eventCounts ?? this.eventCounts,
      stats: stats ?? this.stats,
      eventSequence: eventSequence ?? this.eventSequence,
      sessionStart: sessionStart ?? this.sessionStart,
      customData: customData ?? this.customData,
    );
  }

  /// Creates a new context with an event added.
  AchievementContext withEvent(String event, {int count = 1}) {
    final newCounts = Map<String, int>.from(eventCounts);
    newCounts[event] = (newCounts[event] ?? 0) + count;

    final newSequence = List<String>.from(eventSequence);
    for (var i = 0; i < count; i++) {
      newSequence.add(event);
    }

    return copyWith(
      eventCounts: newCounts,
      eventSequence: newSequence,
    );
  }

  /// Creates a new context with a stat updated.
  AchievementContext withStat(String stat, num value) {
    final newStats = Map<String, num>.from(stats);
    newStats[stat] = value;
    return copyWith(stats: newStats);
  }

  /// Creates a new context with a stat incremented.
  AchievementContext withStatIncrement(String stat, num delta) {
    final currentValue = getStat(stat);
    return withStat(stat, currentValue + delta);
  }

  /// Converts this context to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'eventCounts': eventCounts,
      'stats': stats,
      'eventSequence': eventSequence,
      if (sessionStart != null) 'sessionStart': sessionStart!.toIso8601String(),
      'customData': customData,
    };
  }

  /// Creates a context from a JSON map.
  factory AchievementContext.fromJson(Map<String, dynamic> json) {
    return AchievementContext(
      eventCounts:
          (json['eventCounts'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as int),
          ) ??
          const {},
      stats:
          (json['stats'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, v as num),
          ) ??
          const {},
      eventSequence:
          (json['eventSequence'] as List<dynamic>?)?.cast<String>() ??
          const [],
      sessionStart: json['sessionStart'] != null
          ? DateTime.parse(json['sessionStart'] as String)
          : null,
      customData: json['customData'] as Map<String, dynamic>? ?? const {},
    );
  }

  @override
  String toString() {
    return 'AchievementContext(events: ${eventCounts.length}, stats: ${stats.length})';
  }
}
