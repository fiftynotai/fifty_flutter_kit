/// The current state of an achievement.
///
/// Achievements progress through states:
/// 1. [locked] - Cannot be earned yet (prerequisites not met)
/// 2. [available] - Can be earned but conditions not yet met
/// 3. [unlocked] - Conditions met, achievement earned
/// 4. [claimed] - Reward has been claimed (optional state)
///
/// **Example:**
/// ```dart
/// final state = controller.getState('first_kill');
/// if (state == AchievementState.unlocked) {
///   showUnlockAnimation();
/// }
/// ```
enum AchievementState {
  /// Achievement is locked - prerequisites not met.
  ///
  /// The player cannot work towards this achievement yet.
  /// Used for sequential or tiered achievements.
  locked,

  /// Achievement is available to earn.
  ///
  /// The player can work towards completing this achievement.
  /// Progress can be tracked.
  available,

  /// Achievement has been unlocked (earned).
  ///
  /// The player has completed the conditions and earned
  /// the achievement.
  unlocked,

  /// Achievement reward has been claimed.
  ///
  /// Optional state for achievements with rewards that
  /// must be explicitly claimed by the player.
  claimed,
}

/// Extension methods for [AchievementState].
extension AchievementStateExtension on AchievementState {
  /// Whether progress can be tracked for this state.
  ///
  /// Only [available] achievements track progress.
  bool get canTrackProgress => this == AchievementState.available;

  /// Whether this achievement is considered complete.
  ///
  /// Returns true for [unlocked] and [claimed] states.
  bool get isComplete =>
      this == AchievementState.unlocked || this == AchievementState.claimed;

  /// Whether this achievement can still be earned.
  ///
  /// Returns true for [locked] and [available] states.
  bool get isPending =>
      this == AchievementState.locked || this == AchievementState.available;

  /// Returns the state display name.
  String get displayName {
    switch (this) {
      case AchievementState.locked:
        return 'Locked';
      case AchievementState.available:
        return 'In Progress';
      case AchievementState.unlocked:
        return 'Unlocked';
      case AchievementState.claimed:
        return 'Claimed';
    }
  }
}
