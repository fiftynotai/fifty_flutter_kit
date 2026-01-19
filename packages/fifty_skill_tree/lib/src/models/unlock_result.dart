import 'package:flutter/foundation.dart';

import 'skill_node.dart';

/// Reasons why an unlock attempt may fail.
enum UnlockFailureReason {
  /// Not enough available points to cover the cost.
  insufficientPoints,

  /// One or more prerequisite nodes are not unlocked.
  prerequisitesNotMet,

  /// The node is already at maximum level.
  alreadyMaxed,

  /// The specified node ID doesn't exist in the tree.
  nodeNotFound,

  /// An exclusive connection prevents unlocking this node.
  ///
  /// This occurs when a mutually exclusive sibling has already
  /// been unlocked.
  lockedByExclusive,
}

/// Result of an unlock attempt on a skill node.
///
/// Use factory constructors for cleaner code:
/// ```dart
/// final success = UnlockResult.success(
///   node: updatedNode,
///   pointsSpent: 2,
///   newLevel: 3,
/// );
///
/// final failure = UnlockResult.failure(
///   reason: UnlockFailureReason.insufficientPoints,
///   node: node,
/// );
/// ```
@immutable
class UnlockResult<T> {
  /// Creates an unlock result.
  ///
  /// For convenience, use [UnlockResult.success] or [UnlockResult.failure].
  const UnlockResult._({
    required this.success,
    this.node,
    this.reason,
    this.pointsSpent = 0,
    this.newLevel = 0,
  });

  /// Whether the unlock attempt succeeded.
  final bool success;

  /// The node after the unlock attempt (updated if successful).
  final SkillNode<T>? node;

  /// The reason for failure, if [success] is false.
  final UnlockFailureReason? reason;

  /// The number of points spent (0 if failed).
  final int pointsSpent;

  /// The new level of the node after unlocking.
  final int newLevel;

  /// Creates a successful unlock result.
  ///
  /// **Example:**
  /// ```dart
  /// final result = UnlockResult.success(
  ///   node: updatedNode,
  ///   pointsSpent: 2,
  ///   newLevel: 3,
  /// );
  /// ```
  factory UnlockResult.success({
    required SkillNode<T> node,
    required int pointsSpent,
    required int newLevel,
  }) {
    return UnlockResult._(
      success: true,
      node: node,
      pointsSpent: pointsSpent,
      newLevel: newLevel,
    );
  }

  /// Creates a failed unlock result.
  ///
  /// **Example:**
  /// ```dart
  /// final result = UnlockResult.failure(
  ///   reason: UnlockFailureReason.insufficientPoints,
  ///   node: node,
  /// );
  /// ```
  factory UnlockResult.failure({
    required UnlockFailureReason reason,
    SkillNode<T>? node,
  }) {
    return UnlockResult._(
      success: false,
      node: node,
      reason: reason,
    );
  }

  /// Whether the unlock attempt failed.
  bool get failed => !success;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! UnlockResult<T>) return false;
    return success == other.success &&
        node == other.node &&
        reason == other.reason &&
        pointsSpent == other.pointsSpent &&
        newLevel == other.newLevel;
  }

  @override
  int get hashCode {
    return Object.hash(success, node, reason, pointsSpent, newLevel);
  }

  @override
  String toString() {
    if (success) {
      return 'UnlockResult.success(node: ${node?.id}, '
          'spent: $pointsSpent, level: $newLevel)';
    }
    return 'UnlockResult.failure(reason: ${reason?.name}, node: ${node?.id})';
  }
}
