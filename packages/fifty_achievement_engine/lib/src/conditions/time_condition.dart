import 'achievement_condition.dart';
import 'achievement_context.dart';

/// A condition that requires a certain amount of time to pass.
///
/// Use this for time-based achievements like "Play for 10 hours" or
/// "Survive for 30 minutes".
///
/// **Example:**
/// ```dart
/// // Unlock after playing for 1 hour
/// final condition = TimeCondition(Duration(hours: 1));
///
/// // Unlock after surviving for 30 minutes in survival mode
/// final survivalCondition = TimeCondition(
///   Duration(minutes: 30),
///   duringEvent: 'survival_mode_active',
/// );
/// ```
class TimeCondition extends AchievementCondition {
  /// Creates a time condition.
  ///
  /// [duration] is the required time to pass.
  /// [duringEvent] optionally requires a specific event to be active.
  const TimeCondition(
    this.duration, {
    this.duringEvent,
  });

  /// The required duration.
  final Duration duration;

  /// Optional event that must be active for time to count.
  ///
  /// If set, the session must have this event tracked for
  /// the time condition to be evaluated.
  final String? duringEvent;

  @override
  String get type => 'time';

  @override
  int? get target => duration.inSeconds;

  @override
  int? getCurrent(AchievementContext context) {
    if (duringEvent != null && !context.hasEvent(duringEvent!)) {
      return 0;
    }
    return context.sessionDuration.inSeconds;
  }

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
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'durationSeconds': duration.inSeconds,
      if (duringEvent != null) 'duringEvent': duringEvent,
    };
  }

  /// Creates a time condition from a JSON map.
  factory TimeCondition.fromJson(Map<String, dynamic> json) {
    return TimeCondition(
      Duration(seconds: json['durationSeconds'] as int),
      duringEvent: json['duringEvent'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TimeCondition) return false;
    return duration == other.duration && duringEvent == other.duringEvent;
  }

  @override
  int get hashCode => Object.hash(duration, duringEvent);

  @override
  String toString() {
    final eventStr = duringEvent != null ? ', during: $duringEvent' : '';
    return 'TimeCondition(${duration.inSeconds}s$eventStr)';
  }
}
