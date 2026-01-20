import 'achievement_condition.dart';
import 'achievement_context.dart';

/// A condition that combines multiple conditions with AND/OR logic.
///
/// Use this for complex achievements that require multiple criteria:
/// - AND: All conditions must be satisfied
/// - OR: At least one condition must be satisfied
///
/// **Example:**
/// ```dart
/// // Kill 100 enemies AND reach level 50
/// final condition = CompositeCondition.and([
///   CountCondition('enemy_killed', target: 100),
///   ThresholdCondition('player_level', target: 50),
/// ]);
///
/// // Complete tutorial OR skip tutorial
/// final altCondition = CompositeCondition.or([
///   EventCondition('tutorial_completed'),
///   EventCondition('tutorial_skipped'),
/// ]);
/// ```
class CompositeCondition extends AchievementCondition {
  /// Creates a composite condition.
  ///
  /// [conditions] is the list of conditions to combine.
  /// [operator] determines how conditions are combined (default: AND).
  const CompositeCondition(
    this.conditions, {
    this.operator = CompositeOperator.and,
  });

  /// Creates an AND composite condition.
  ///
  /// All conditions must be satisfied.
  factory CompositeCondition.and(List<AchievementCondition> conditions) {
    return CompositeCondition(conditions, operator: CompositeOperator.and);
  }

  /// Creates an OR composite condition.
  ///
  /// At least one condition must be satisfied.
  factory CompositeCondition.or(List<AchievementCondition> conditions) {
    return CompositeCondition(conditions, operator: CompositeOperator.or);
  }

  /// The list of conditions to combine.
  final List<AchievementCondition> conditions;

  /// How conditions are combined (AND or OR).
  final CompositeOperator operator;

  @override
  String get type => 'composite';

  @override
  bool evaluate(AchievementContext context) {
    if (conditions.isEmpty) return true;

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
      final totalProgress = conditions.fold<double>(
        0.0,
        (sum, c) => sum + c.getProgress(context),
      );
      return totalProgress / conditions.length;
    } else {
      // Maximum progress of any condition
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
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'operator': operator.name,
      'conditions': conditions.map((c) => c.toJson()).toList(),
    };
  }

  /// Creates a composite condition from a JSON map.
  factory CompositeCondition.fromJson(Map<String, dynamic> json) {
    final conditions = (json['conditions'] as List<dynamic>)
        .map((c) => AchievementCondition.fromJson(c as Map<String, dynamic>))
        .toList();

    final operator = CompositeOperator.values.firstWhere(
      (o) => o.name == json['operator'],
      orElse: () => CompositeOperator.and,
    );

    return CompositeCondition(conditions, operator: operator);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CompositeCondition) return false;
    if (operator != other.operator) return false;
    if (conditions.length != other.conditions.length) return false;
    for (int i = 0; i < conditions.length; i++) {
      if (conditions[i] != other.conditions[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(operator, conditions);

  @override
  String toString() {
    final op = operator == CompositeOperator.and ? 'AND' : 'OR';
    return 'CompositeCondition.$op(${conditions.length} conditions)';
  }
}
