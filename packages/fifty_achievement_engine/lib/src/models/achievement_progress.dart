import 'package:flutter/foundation.dart';

import 'achievement_state.dart';

/// Detailed progress information for an achievement.
///
/// Provides both raw progress values and computed percentages,
/// along with the current state.
///
/// **Example:**
/// ```dart
/// final progress = controller.getProgressDetails('kill_100_enemies');
/// print('${progress.current}/${progress.target} enemies killed');
/// print('${(progress.percentage * 100).toStringAsFixed(1)}%');
/// ```
@immutable
class AchievementProgress {
  /// Creates an achievement progress instance.
  const AchievementProgress({
    required this.achievementId,
    required this.state,
    required this.current,
    required this.target,
    this.unlockedAt,
    this.claimedAt,
  });

  /// Creates a progress instance for a locked achievement.
  factory AchievementProgress.locked(String achievementId) {
    return AchievementProgress(
      achievementId: achievementId,
      state: AchievementState.locked,
      current: 0,
      target: 1,
    );
  }

  /// Creates a progress instance for a fully completed achievement.
  factory AchievementProgress.completed(
    String achievementId, {
    int target = 1,
    DateTime? unlockedAt,
  }) {
    return AchievementProgress(
      achievementId: achievementId,
      state: AchievementState.unlocked,
      current: target,
      target: target,
      unlockedAt: unlockedAt ?? DateTime.now(),
    );
  }

  /// The achievement ID this progress relates to.
  final String achievementId;

  /// The current state of the achievement.
  final AchievementState state;

  /// Current progress value (e.g., 45 enemies killed).
  final int current;

  /// Target value for completion (e.g., 100 enemies).
  final int target;

  /// When the achievement was unlocked (null if not yet unlocked).
  final DateTime? unlockedAt;

  /// When the achievement reward was claimed (null if not claimed).
  final DateTime? claimedAt;

  /// Progress as a percentage (0.0 to 1.0).
  ///
  /// Returns 1.0 for completed achievements, even if current > target.
  double get percentage {
    if (target <= 0) return 0.0;
    if (state.isComplete) return 1.0;
    return (current / target).clamp(0.0, 1.0);
  }

  /// Whether the target has been reached.
  bool get isTargetReached => current >= target;

  /// Remaining progress to complete.
  ///
  /// Returns 0 if already complete.
  int get remaining => (target - current).clamp(0, target);

  /// Creates a copy with the given fields replaced.
  AchievementProgress copyWith({
    String? achievementId,
    AchievementState? state,
    int? current,
    int? target,
    DateTime? unlockedAt,
    DateTime? claimedAt,
  }) {
    return AchievementProgress(
      achievementId: achievementId ?? this.achievementId,
      state: state ?? this.state,
      current: current ?? this.current,
      target: target ?? this.target,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      claimedAt: claimedAt ?? this.claimedAt,
    );
  }

  /// Converts this progress to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'achievementId': achievementId,
      'state': state.name,
      'current': current,
      'target': target,
      if (unlockedAt != null) 'unlockedAt': unlockedAt!.toIso8601String(),
      if (claimedAt != null) 'claimedAt': claimedAt!.toIso8601String(),
    };
  }

  /// Creates a progress instance from a JSON map.
  factory AchievementProgress.fromJson(Map<String, dynamic> json) {
    return AchievementProgress(
      achievementId: json['achievementId'] as String,
      state: AchievementState.values.firstWhere(
        (s) => s.name == json['state'],
        orElse: () => AchievementState.locked,
      ),
      current: json['current'] as int? ?? 0,
      target: json['target'] as int? ?? 1,
      unlockedAt: json['unlockedAt'] != null
          ? DateTime.parse(json['unlockedAt'] as String)
          : null,
      claimedAt: json['claimedAt'] != null
          ? DateTime.parse(json['claimedAt'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AchievementProgress) return false;
    return achievementId == other.achievementId &&
        state == other.state &&
        current == other.current &&
        target == other.target;
  }

  @override
  int get hashCode => Object.hash(achievementId, state, current, target);

  @override
  String toString() {
    return 'AchievementProgress($achievementId: $current/$target, $state)';
  }
}
