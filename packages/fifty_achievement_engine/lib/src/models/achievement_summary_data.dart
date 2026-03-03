import 'package:flutter/foundation.dart';

import '../controllers/achievement_controller.dart';
import 'achievement_rarity.dart';
import 'achievement_state.dart';

/// Computed summary statistics for an achievement system.
///
/// Bundles all derived values from [AchievementController] into an
/// immutable data object for use with [AchievementSummary.contentBuilder].
@immutable
class AchievementSummaryData {
  /// Creates achievement summary data with the given statistics.
  const AchievementSummaryData({
    required this.unlockedCount,
    required this.totalCount,
    required this.completionPercentage,
    required this.earnedPoints,
    required this.totalPoints,
    required this.rarityBreakdown,
    required this.categoryBreakdown,
  });

  /// Creates summary data from an [AchievementController].
  ///
  /// Delegates scalar values to the controller's existing getters and
  /// computes rarity/category breakdown maps by iterating achievements.
  factory AchievementSummaryData.fromController(
    AchievementController controller,
  ) {
    final achievements = controller.achievements;
    final rarityBreakdown = <AchievementRarity, ({int unlocked, int total})>{};
    final categoryBreakdown = <String, ({int unlocked, int total})>{};

    for (final achievement in achievements) {
      final state = controller.getState(achievement.id);
      final isUnlocked = state == AchievementState.unlocked ||
          state == AchievementState.claimed;

      // Rarity breakdown
      final rarity = achievement.rarity;
      final existing = rarityBreakdown[rarity] ?? (unlocked: 0, total: 0);
      rarityBreakdown[rarity] = (
        unlocked: existing.unlocked + (isUnlocked ? 1 : 0),
        total: existing.total + 1,
      );

      // Category breakdown
      if (achievement.category != null) {
        final category = achievement.category!;
        final catExisting =
            categoryBreakdown[category] ?? (unlocked: 0, total: 0);
        categoryBreakdown[category] = (
          unlocked: catExisting.unlocked + (isUnlocked ? 1 : 0),
          total: catExisting.total + 1,
        );
      }
    }

    return AchievementSummaryData(
      unlockedCount: controller.unlockedAchievements.length,
      totalCount: achievements.length,
      completionPercentage: controller.completionPercentage,
      earnedPoints: controller.earnedPoints,
      totalPoints: controller.totalPoints,
      rarityBreakdown: rarityBreakdown,
      categoryBreakdown: categoryBreakdown,
    );
  }

  /// Number of unlocked (including claimed) achievements.
  final int unlockedCount;

  /// Total number of achievements.
  final int totalCount;

  /// Completion percentage from 0.0 to 1.0.
  final double completionPercentage;

  /// Points earned from unlocked achievements.
  final int earnedPoints;

  /// Total points across all achievements.
  final int totalPoints;

  /// Breakdown of unlocked/total counts by rarity.
  final Map<AchievementRarity, ({int unlocked, int total})> rarityBreakdown;

  /// Breakdown of unlocked/total counts by category.
  final Map<String, ({int unlocked, int total})> categoryBreakdown;

  /// Compares scalar fields only. Breakdown maps are derived from the same
  /// controller state, so scalar equality implies breakdown equality in
  /// typical usage. This avoids deep map comparison overhead.
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AchievementSummaryData &&
          runtimeType == other.runtimeType &&
          unlockedCount == other.unlockedCount &&
          totalCount == other.totalCount &&
          completionPercentage == other.completionPercentage &&
          earnedPoints == other.earnedPoints &&
          totalPoints == other.totalPoints;

  @override
  int get hashCode => Object.hash(
        unlockedCount,
        totalCount,
        completionPercentage,
        earnedPoints,
        totalPoints,
      );

  @override
  String toString() =>
      'AchievementSummaryData($unlockedCount/$totalCount, '
      '${(completionPercentage * 100).toStringAsFixed(1)}%, '
      '$earnedPoints/$totalPoints pts)';
}
