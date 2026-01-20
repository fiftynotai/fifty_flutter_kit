import 'achievement_condition.dart';
import 'achievement_context.dart';

/// A condition that is satisfied when a specific event occurs.
///
/// This is the simplest condition type - it checks if an event
/// has occurred at least once.
///
/// **Example:**
/// ```dart
/// // Unlock when player completes the tutorial
/// final condition = EventCondition('tutorial_completed');
///
/// // Track the event
/// controller.trackEvent('tutorial_completed');
///
/// // Now the condition evaluates to true
/// assert(condition.evaluate(context) == true);
/// ```
class EventCondition extends AchievementCondition {
  /// Creates an event condition.
  ///
  /// [event] is the name of the event to check for.
  const EventCondition(this.event);

  /// The event name to check for.
  final String event;

  @override
  String get type => 'event';

  @override
  bool evaluate(AchievementContext context) {
    return context.hasEvent(event);
  }

  @override
  double getProgress(AchievementContext context) {
    return evaluate(context) ? 1.0 : 0.0;
  }

  @override
  int? get target => 1;

  @override
  int? getCurrent(AchievementContext context) {
    return context.hasEvent(event) ? 1 : 0;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'event': event,
    };
  }

  /// Creates an event condition from a JSON map.
  factory EventCondition.fromJson(Map<String, dynamic> json) {
    return EventCondition(json['event'] as String);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EventCondition) return false;
    return event == other.event;
  }

  @override
  int get hashCode => event.hashCode;

  @override
  String toString() => 'EventCondition($event)';
}
