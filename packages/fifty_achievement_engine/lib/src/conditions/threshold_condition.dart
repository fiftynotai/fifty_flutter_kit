import 'achievement_condition.dart';
import 'achievement_context.dart';

/// The comparison operator for threshold conditions.
enum ThresholdOperator {
  /// Stat must be greater than or equal to target.
  greaterOrEqual,

  /// Stat must be greater than target.
  greaterThan,

  /// Stat must be less than or equal to target.
  lessOrEqual,

  /// Stat must be less than target.
  lessThan,

  /// Stat must equal target exactly.
  equal,
}

/// A condition that is satisfied when a stat reaches a target value.
///
/// Use this for milestone achievements like "Reach level 50" or
/// "Deal 10,000 total damage".
///
/// **Example:**
/// ```dart
/// // Unlock when player reaches level 50
/// final condition = ThresholdCondition(
///   'player_level',
///   target: 50,
///   operator: ThresholdOperator.greaterOrEqual,
/// );
///
/// // Update the stat
/// controller.updateStat('player_level', 50);
///
/// // Now the condition is satisfied
/// assert(condition.evaluate(context) == true);
/// ```
class ThresholdCondition extends AchievementCondition {
  /// Creates a threshold condition.
  ///
  /// [stat] is the name of the stat to check.
  /// [target] is the target value.
  /// [operator] determines how the comparison is made (default: greaterOrEqual).
  const ThresholdCondition(
    this.stat, {
    required num target,
    this.operator = ThresholdOperator.greaterOrEqual,
  }) : _target = target;

  /// The stat name to check.
  final String stat;

  /// The target value.
  final num _target;

  /// The comparison operator.
  final ThresholdOperator operator;

  @override
  String get type => 'threshold';

  @override
  int? get target => _target.toInt();

  @override
  int? getCurrent(AchievementContext context) {
    return context.getStat(stat).toInt();
  }

  @override
  bool evaluate(AchievementContext context) {
    final value = context.getStat(stat);

    switch (operator) {
      case ThresholdOperator.greaterOrEqual:
        return value >= _target;
      case ThresholdOperator.greaterThan:
        return value > _target;
      case ThresholdOperator.lessOrEqual:
        return value <= _target;
      case ThresholdOperator.lessThan:
        return value < _target;
      case ThresholdOperator.equal:
        return value == _target;
    }
  }

  @override
  double getProgress(AchievementContext context) {
    final value = context.getStat(stat);

    switch (operator) {
      case ThresholdOperator.greaterOrEqual:
      case ThresholdOperator.greaterThan:
        if (_target <= 0) return 1.0;
        return (value / _target).clamp(0.0, 1.0);

      case ThresholdOperator.lessOrEqual:
      case ThresholdOperator.lessThan:
        // Progress is inverted for "less than" conditions
        if (_target <= 0) return value <= 0 ? 1.0 : 0.0;
        // If we need to go from 100 to 10, progress is how close we are to 10
        return evaluate(context) ? 1.0 : 0.0;

      case ThresholdOperator.equal:
        return value == _target ? 1.0 : 0.0;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'stat': stat,
      'target': _target,
      'operator': operator.name,
    };
  }

  /// Creates a threshold condition from a JSON map.
  factory ThresholdCondition.fromJson(Map<String, dynamic> json) {
    return ThresholdCondition(
      json['stat'] as String,
      target: json['target'] as num,
      operator: ThresholdOperator.values.firstWhere(
        (o) => o.name == json['operator'],
        orElse: () => ThresholdOperator.greaterOrEqual,
      ),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ThresholdCondition) return false;
    return stat == other.stat &&
        _target == other._target &&
        operator == other.operator;
  }

  @override
  int get hashCode => Object.hash(stat, _target, operator);

  @override
  String toString() =>
      'ThresholdCondition($stat ${operator.name} $_target)';
}
