import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../controllers/controllers.dart';
import '../models/models.dart';
import 'achievement_progress_bar.dart';

/// A summary widget showing overall achievement progress.
///
/// Displays total points, completion percentage, and stats breakdown.
/// Consumes FDL tokens directly for consistent styling.
///
/// **Example:**
/// ```dart
/// AchievementSummary(
///   controller: achievementController,
///   showRarityBreakdown: true,
/// )
/// ```
class AchievementSummary<T> extends StatelessWidget {
  /// Creates an achievement summary.
  const AchievementSummary({
    super.key,
    required this.controller,
    this.backgroundColor,
    this.showRarityBreakdown = false,
    this.showCategoryBreakdown = false,
    this.compact = false,
  });

  /// The achievement controller.
  final AchievementController<T> controller;

  /// Background color override.
  final Color? backgroundColor;

  /// Whether to show breakdown by rarity.
  final bool showRarityBreakdown;

  /// Whether to show breakdown by category.
  final bool showCategoryBreakdown;

  /// Whether to use compact layout.
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Container(
          padding: EdgeInsets.all(compact ? FiftySpacing.md : FiftySpacing.lg),
          decoration: BoxDecoration(
            color: backgroundColor ??
                Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: FiftyRadii.lgRadius,
            border: Border.all(
                color: Theme.of(context).colorScheme.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context),
              const SizedBox(height: FiftySpacing.md),
              _buildProgressSection(),
              if (showRarityBreakdown) ...[
                const SizedBox(height: FiftySpacing.lg),
                _buildRarityBreakdown(),
              ],
              if (showCategoryBreakdown &&
                  controller.categories.isNotEmpty) ...[
                const SizedBox(height: FiftySpacing.lg),
                _buildCategoryBreakdown(),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final unlockedCount = controller.unlockedAchievements.length;
    final totalCount = controller.achievements.length;

    return Row(
      children: [
        Container(
          width: compact ? 40 : 48,
          height: compact ? 40 : 48,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                FiftyColors.burgundy,
                FiftyColors.burgundy.withValues(alpha: 0.7),
              ],
            ),
            borderRadius: FiftyRadii.mdRadius,
          ),
          child: Icon(
            Icons.emoji_events,
            size: compact ? 20 : 24,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        const SizedBox(width: FiftySpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ACHIEVEMENTS',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.labelMedium,
                  fontWeight: FiftyTypography.bold,
                  letterSpacing: FiftyTypography.letterSpacingLabelMedium,
                  color: FiftyColors.cream.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: FiftySpacing.xs / 2),
              Text(
                '$unlockedCount / $totalCount Unlocked',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: compact
                      ? FiftyTypography.titleSmall
                      : FiftyTypography.titleMedium,
                  fontWeight: FiftyTypography.bold,
                  color: FiftyColors.cream,
                ),
              ),
            ],
          ),
        ),
        _buildPointsDisplay(),
      ],
    );
  }

  Widget _buildPointsDisplay() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'POINTS',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.labelSmall,
            fontWeight: FiftyTypography.semiBold,
            letterSpacing: FiftyTypography.letterSpacingLabelMedium,
            color: FiftyColors.cream.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: FiftySpacing.xs / 2),
        Text(
          '${controller.earnedPoints}',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: compact
                ? FiftyTypography.titleLarge
                : FiftyTypography.displayMedium,
            fontWeight: FiftyTypography.extraBold,
            color: FiftyColors.burgundy,
          ),
        ),
        Text(
          'of ${controller.totalPoints}',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodySmall,
            color: FiftyColors.cream.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Overall Progress',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodyMedium,
                fontWeight: FiftyTypography.medium,
                color: FiftyColors.cream.withValues(alpha: 0.7),
              ),
            ),
            Text(
              '${(controller.completionPercentage * 100).toStringAsFixed(1)}%',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodyMedium,
                fontWeight: FiftyTypography.bold,
                color: FiftyColors.cream,
              ),
            ),
          ],
        ),
        const SizedBox(height: FiftySpacing.sm),
        AchievementProgressBar(
          progress: controller.completionPercentage,
          height: 8,
        ),
      ],
    );
  }

  Widget _buildRarityBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BY RARITY',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.labelMedium,
            fontWeight: FiftyTypography.bold,
            letterSpacing: FiftyTypography.letterSpacingLabelMedium,
            color: FiftyColors.cream.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: FiftySpacing.sm),
        ...AchievementRarity.values.map((rarity) {
          final total = controller.getByRarity(rarity).length;
          if (total == 0) return const SizedBox.shrink();

          final unlocked = controller.getByRarity(rarity)
              .where((a) => controller.isUnlocked(a.id))
              .length;

          return Padding(
            padding: const EdgeInsets.only(bottom: FiftySpacing.sm),
            child: _buildBreakdownRow(
              label: rarity.displayName,
              unlocked: unlocked,
              total: total,
              color: _getRarityColor(rarity),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCategoryBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BY CATEGORY',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.labelMedium,
            fontWeight: FiftyTypography.bold,
            letterSpacing: FiftyTypography.letterSpacingLabelMedium,
            color: FiftyColors.cream.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: FiftySpacing.sm),
        ...controller.categories.map((category) {
          final achievements = controller.getByCategory(category);
          final unlocked = achievements
              .where((a) => controller.isUnlocked(a.id))
              .length;

          return Padding(
            padding: const EdgeInsets.only(bottom: FiftySpacing.sm),
            child: _buildBreakdownRow(
              label: category,
              unlocked: unlocked,
              total: achievements.length,
              color: FiftyColors.slateGrey,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBreakdownRow({
    required String label,
    required int unlocked,
    required int total,
    required Color color,
  }) {
    final progress = total > 0 ? unlocked / total : 0.0;

    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: FiftyRadii.smRadius,
          ),
        ),
        const SizedBox(width: FiftySpacing.sm),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              color: FiftyColors.cream.withValues(alpha: 0.7),
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: AchievementProgressBar(
            progress: progress,
            height: 4,
            foregroundColor: color,
          ),
        ),
        const SizedBox(width: FiftySpacing.sm),
        SizedBox(
          width: 40,
          child: Text(
            '$unlocked/$total',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              fontWeight: FiftyTypography.medium,
              color: FiftyColors.cream.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Color _getRarityColor(AchievementRarity rarity) {
    switch (rarity) {
      case AchievementRarity.common:
        return FiftyColors.slateGrey;
      case AchievementRarity.uncommon:
        return FiftyColors.hunterGreen;
      case AchievementRarity.rare:
        return const Color(0xFF5B8BD4);
      case AchievementRarity.epic:
        return const Color(0xFF9B59B6);
      case AchievementRarity.legendary:
        return const Color(0xFFE67E22);
    }
  }
}
