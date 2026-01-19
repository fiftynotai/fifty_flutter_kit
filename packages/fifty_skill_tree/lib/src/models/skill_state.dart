/// Represents the current state of a skill node.
///
/// Used to determine how a node should be displayed and whether
/// it can be interacted with.
enum SkillState {
  /// Prerequisites not met - cannot unlock.
  ///
  /// The node is visible but grayed out and cannot be clicked
  /// until all prerequisites are satisfied.
  locked,

  /// Can be unlocked - has points and prereqs met.
  ///
  /// The node is highlighted to indicate it's ready for purchase.
  /// Clicking it will spend points and unlock the first level.
  available,

  /// Partially or fully unlocked (level > 0, level < maxLevel).
  ///
  /// The node has been invested in and provides its benefits.
  /// If currentLevel < maxLevel, it can still be upgraded.
  unlocked,

  /// All levels purchased (level == maxLevel).
  ///
  /// The node is fully upgraded and cannot receive more points.
  /// Displayed with a special "maxed out" visual indicator.
  maxed,
}
