/// Rarity tiers for achievements.
///
/// Rarity affects visual presentation and can be used for
/// categorization and point multipliers.
///
/// **Example:**
/// ```dart
/// final achievement = Achievement(
///   id: 'legendary_warrior',
///   name: 'Legendary Warrior',
///   rarity: AchievementRarity.legendary,
///   // ...
/// );
/// ```
enum AchievementRarity {
  /// Common achievements - easy to obtain, basic accomplishments.
  ///
  /// Typically awarded for routine actions or first-time events.
  common,

  /// Uncommon achievements - moderate effort required.
  ///
  /// Awarded for completing optional objectives or reaching
  /// early milestones.
  uncommon,

  /// Rare achievements - significant accomplishment.
  ///
  /// Awarded for challenging tasks or major milestones.
  rare,

  /// Epic achievements - impressive feat.
  ///
  /// Awarded for difficult challenges or exceptional performance.
  epic,

  /// Legendary achievements - extraordinary accomplishment.
  ///
  /// Awarded for the most difficult challenges, completionist
  /// tasks, or unique feats.
  legendary,
}

/// Extension methods for [AchievementRarity].
extension AchievementRarityExtension on AchievementRarity {
  /// Returns a suggested point multiplier for this rarity.
  ///
  /// - Common: 1x
  /// - Uncommon: 2x
  /// - Rare: 3x
  /// - Epic: 5x
  /// - Legendary: 10x
  double get pointMultiplier {
    switch (this) {
      case AchievementRarity.common:
        return 1.0;
      case AchievementRarity.uncommon:
        return 2.0;
      case AchievementRarity.rare:
        return 3.0;
      case AchievementRarity.epic:
        return 5.0;
      case AchievementRarity.legendary:
        return 10.0;
    }
  }

  /// Returns the rarity display name.
  String get displayName {
    switch (this) {
      case AchievementRarity.common:
        return 'Common';
      case AchievementRarity.uncommon:
        return 'Uncommon';
      case AchievementRarity.rare:
        return 'Rare';
      case AchievementRarity.epic:
        return 'Epic';
      case AchievementRarity.legendary:
        return 'Legendary';
    }
  }
}
