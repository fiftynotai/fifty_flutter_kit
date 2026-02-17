import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../controllers/controllers.dart';
import '../models/models.dart';
import 'achievement_card.dart';

/// Filter options for the achievement list.
enum AchievementFilter {
  /// Show all achievements.
  all,

  /// Show only available (in progress) achievements.
  available,

  /// Show only unlocked achievements.
  unlocked,

  /// Show only locked achievements.
  locked,
}

/// A scrollable list widget for displaying achievements with filtering.
///
/// Consumes FDL tokens directly for consistent styling.
///
/// **Example:**
/// ```dart
/// AchievementList(
///   controller: achievementController,
///   filter: AchievementFilter.all,
///   onTap: (achievement) => showDetails(achievement),
/// )
/// ```
class AchievementList<T> extends StatelessWidget {
  /// Creates an achievement list.
  const AchievementList({
    super.key,
    required this.controller,
    this.filter = AchievementFilter.all,
    this.rarityFilter,
    this.categoryFilter,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.spacing = FiftySpacing.md,
    this.compact = false,
    this.showProgress = true,
    this.emptyWidget,
    this.headerBuilder,
    this.physics,
    this.shrinkWrap = false,
  });

  /// The achievement controller.
  final AchievementController<T> controller;

  /// Filter by achievement state.
  final AchievementFilter filter;

  /// Optional filter by rarity.
  final AchievementRarity? rarityFilter;

  /// Optional filter by category.
  final String? categoryFilter;

  /// Callback when an achievement card is tapped.
  final void Function(Achievement<T> achievement)? onTap;

  /// Callback when an achievement card is long pressed.
  final void Function(Achievement<T> achievement)? onLongPress;

  /// Padding around the list.
  final EdgeInsets? padding;

  /// Spacing between cards.
  final double spacing;

  /// Whether to use compact card layout.
  final bool compact;

  /// Whether to show progress bars.
  final bool showProgress;

  /// Widget to show when the list is empty.
  final Widget? emptyWidget;

  /// Optional header builder for category sections.
  final Widget Function(String category)? headerBuilder;

  /// Scroll physics.
  final ScrollPhysics? physics;

  /// Whether the list should shrink wrap its contents.
  final bool shrinkWrap;

  List<Achievement<T>> _filterAchievements() {
    var achievements = controller.achievements;

    // Apply state filter
    switch (filter) {
      case AchievementFilter.all:
        break;
      case AchievementFilter.available:
        achievements = achievements
            .where(
                (a) => controller.getState(a.id) == AchievementState.available)
            .toList();
        break;
      case AchievementFilter.unlocked:
        achievements = achievements
            .where((a) => controller.getState(a.id).isComplete)
            .toList();
        break;
      case AchievementFilter.locked:
        achievements = achievements
            .where((a) => controller.getState(a.id) == AchievementState.locked)
            .toList();
        break;
    }

    // Apply rarity filter
    if (rarityFilter != null) {
      achievements =
          achievements.where((a) => a.rarity == rarityFilter).toList();
    }

    // Apply category filter
    if (categoryFilter != null) {
      achievements =
          achievements.where((a) => a.category == categoryFilter).toList();
    }

    return achievements;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final achievements = _filterAchievements();

        if (achievements.isEmpty) {
          return emptyWidget ?? _buildEmptyState();
        }

        return ListView.separated(
          padding: padding ?? const EdgeInsets.all(FiftySpacing.md),
          physics: physics,
          shrinkWrap: shrinkWrap,
          itemCount: achievements.length,
          separatorBuilder: (_, __) => SizedBox(height: spacing),
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            final state = controller.getState(achievement.id);
            final progress = controller.getProgress(achievement.id);

            return AchievementCard<T>(
              achievement: achievement,
              progress: progress,
              state: state,
              onTap: onTap != null ? () => onTap!(achievement) : null,
              onLongPress:
                  onLongPress != null ? () => onLongPress!(achievement) : null,
              showProgress: showProgress,
              compact: compact,
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Builder(
      builder: (context) {
        final colorScheme = Theme.of(context).colorScheme;
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(FiftySpacing.xxl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.emoji_events_outlined,
                  size: 48,
                  color: colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: FiftySpacing.md),
                Text(
                  'No achievements found',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.titleSmall,
                    fontWeight: FiftyTypography.medium,
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                ),
                const SizedBox(height: FiftySpacing.sm),
                Text(
                  _getEmptyMessage(),
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _getEmptyMessage() {
    switch (filter) {
      case AchievementFilter.all:
        return 'No achievements have been added yet.';
      case AchievementFilter.available:
        return 'No achievements are currently available to earn.';
      case AchievementFilter.unlocked:
        return 'You haven\'t unlocked any achievements yet.';
      case AchievementFilter.locked:
        return 'All achievements are available or unlocked!';
    }
  }
}
