import 'achievement_condition.dart';
import 'achievement_context.dart';

/// A condition that requires an event to occur a specific number of times.
///
/// Use this for cumulative achievements like "Kill 100 enemies" or
/// "Collect 50 coins".
///
/// **Example:**
/// ```dart
/// // Unlock when player kills 100 enemies
/// final condition = CountCondition('enemy_killed', target: 100);
///
/// // Track each kill
/// controller.trackEvent('enemy_killed');
///
/// // Check progress
/// print('${condition.getCurrent(context)}/100 enemies killed');
/// print('Progress: ${(condition.getProgress(context) * 100).toStringAsFixed(1)}%');
/// ```
class CountCondition extends AchievementCondition {
  /// Creates a count condition.
  ///
  /// [event] is the name of the event to count.
  /// [target] is the required count to satisfy the condition.
  const CountCondition(
    this.event, {
    required int target,
  }) : _target = target;

  /// The event name to count.
  final String event;

  /// The required count.
  final int _target;

  @override
  String get type => 'count';

  @override
  int? get target => _target;

  @override
  int? getCurrent(AchievementContext context) {
    return context.getEventCount(event);
  }

  @override
  bool evaluate(AchievementContext context) {
    return context.getEventCount(event) >= _target;
  }

  @override
  double getProgress(AchievementContext context) {
    final count = context.getEventCount(event);
    if (_target <= 0) return 1.0;
    return (count / _target).clamp(0.0, 1.0);
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'event': event,
      'target': _target,
    };
  }

  /// Creates a count condition from a JSON map.
  factory CountCondition.fromJson(Map<String, dynamic> json) {
    return CountCondition(
      json['event'] as String,
      target: json['target'] as int,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CountCondition) return false;
    return event == other.event && _target == other._target;
  }

  @override
  int get hashCode => Object.hash(event, _target);

  @override
  String toString() => 'CountCondition($event, target: $_target)';
}
