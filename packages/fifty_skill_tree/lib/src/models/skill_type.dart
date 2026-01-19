/// Categorizes the type of skill for visual/gameplay distinction.
///
/// Different skill types may have different visual representations
/// and gameplay mechanics in the consuming application.
enum SkillType {
  /// Always-active effect.
  ///
  /// Passive skills provide continuous benefits without requiring
  /// player activation. Examples: +10% damage, +5 armor.
  passive,

  /// Requires activation to use.
  ///
  /// Active skills must be triggered by the player to take effect.
  /// May have cooldowns or resource costs in the game.
  active,

  /// Powerful ability, often with limitations.
  ///
  /// Ultimate skills are typically the most powerful abilities
  /// with significant costs or long cooldowns.
  ultimate,

  /// Major milestone node in the tree.
  ///
  /// Keystone skills represent significant power spikes and often
  /// unlock new branches or dramatically change gameplay.
  keystone,

  /// Small bonus/stat increase.
  ///
  /// Minor skills provide incremental improvements and are often
  /// prerequisites for reaching more powerful nodes.
  minor,
}
