/// Achievement Demo Page
///
/// Demonstrates achievement tracking and unlocking.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../actions/achievement_demo_actions.dart';
import '../controllers/achievement_demo_view_model.dart';

/// Extension to provide theme-aware colors for achievement rarities.
///
/// Resolves rarity colors based on the current theme (dark/light mode).
/// Uses FiftyThemeExtension when available, falls back to ColorScheme.
extension AchievementRarityColors on AchievementRarity {
  /// Gets the theme-aware color for this rarity.
  ///
  /// In dark mode: Uses vibrant colors for visibility
  /// In light mode: Uses slightly muted variants
  Color getColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (this) {
      case AchievementRarity.common:
        // Neutral grey - uses surface variant
        return isDark
            ? colorScheme.onSurfaceVariant
            : colorScheme.outline;
      case AchievementRarity.uncommon:
        // Green tint - uses success color
        return fiftyTheme?.success ?? colorScheme.tertiary;
      case AchievementRarity.rare:
        // Blue tint - uses primary
        return colorScheme.primary;
      case AchievementRarity.epic:
        // Purple/pink - uses secondary
        return colorScheme.secondary;
      case AchievementRarity.legendary:
        // Gold/orange - uses warning or tertiary
        return fiftyTheme?.warning ?? FiftyColors.warning;
    }
  }
}

/// Achievement demo page widget.
///
/// Shows achievement list with event triggers.
class AchievementDemoPage extends GetView<AchievementDemoViewModel> {
  /// Creates an achievement demo page.
  const AchievementDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AchievementDemoViewModel>(
      builder: (viewModel) {
        final actions = Get.find<AchievementDemoActions>();

        return DemoScaffold(
          title: 'Achievement Engine',
          padding: EdgeInsets.zero,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: FiftySpacing.lg,
                  vertical: FiftySpacing.md,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary Stats
                      _buildSummaryCard(context, viewModel),
                      const SizedBox(height: FiftySpacing.xl),

                      // Event Triggers
                      const SectionHeader(
                        title: 'Event Triggers',
                        subtitle: 'Tap to trigger game events',
                      ),
                      _buildEventTriggers(context, viewModel, actions),
                      const SizedBox(height: FiftySpacing.xl),

                      // Achievement List
                      SectionHeader(
                        title: 'Achievements',
                        subtitle:
                            '${viewModel.unlockedCount}/${viewModel.totalCount} unlocked',
                      ),
                      _buildAchievementList(viewModel),
                    ],
                  ),
                ),
              ),

              // Unlock Popup
              if (viewModel.recentUnlock != null)
                _buildUnlockPopup(context, viewModel.recentUnlock!, actions),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(BuildContext context, AchievementDemoViewModel viewModel) {
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final successColor = fiftyTheme?.success ?? colorScheme.tertiary;

    return FiftyCard(
      padding: const EdgeInsets.all(FiftySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Progress bar
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COMPLETION',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        color: colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: FiftySpacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(FiftyRadii.sm),
                      child: LinearProgressIndicator(
                        value: viewModel.completionPercentage,
                        backgroundColor:
                            colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation<Color>(successColor),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: FiftySpacing.lg),
              Text(
                '${(viewModel.completionPercentage * 100).toInt()}%',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.titleLarge,
                  fontWeight: FontWeight.bold,
                  color: successColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: FiftySpacing.md),

          // Rarity breakdown
          Row(
            children: AchievementRarity.values.map((rarity) {
              final count =
                  viewModel.getByRarity(rarity).where((a) => a.isUnlocked).length;
              final total = viewModel.getByRarity(rarity).length;
              final rarityColor = rarity.getColor(context);

              if (total == 0) return const SizedBox.shrink();

              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: rarityColor.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: rarityColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: FiftySpacing.xs),
                    Text(
                      rarity.label.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: 10,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEventTriggers(
    BuildContext context,
    AchievementDemoViewModel viewModel,
    AchievementDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Wrap(
      spacing: FiftySpacing.sm,
      runSpacing: FiftySpacing.sm,
      children: GameEvent.values.map((event) {
        final count = viewModel.eventCounts[event] ?? 0;
        // Gold gives more per tap for faster progress
        final amount = event == GameEvent.goldCollected ? 50 : 1;

        return GestureDetector(
          onTap: () => actions.onEventTapped(context, event, amount: amount),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: FiftySpacing.md,
              vertical: FiftySpacing.sm,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(FiftyRadii.md),
              border: Border.all(color: colorScheme.outline),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  event.icon,
                  color: colorScheme.primary,
                  size: 20,
                ),
                const SizedBox(width: FiftySpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.label.toUpperCase(),
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      event == GameEvent.goldCollected
                          ? '+$amount ($count total)'
                          : 'x$count',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: 10,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAchievementList(AchievementDemoViewModel viewModel) {
    return Column(
      children: viewModel.achievements.map((achievement) {
        return Padding(
          padding: const EdgeInsets.only(bottom: FiftySpacing.sm),
          child: _AchievementCard(achievement: achievement),
        );
      }).toList(),
    );
  }

  Widget _buildUnlockPopup(
    BuildContext context,
    DemoAchievement achievement,
    AchievementDemoActions actions,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
    final successColor = fiftyTheme?.success ?? colorScheme.tertiary;
    final rarityColor = achievement.rarity.getColor(context);

    return Positioned.fill(
      child: GestureDetector(
        onTap: actions.onDismissUnlock,
        child: Container(
          color: colorScheme.surface.withValues(alpha: 0.85),
          child: Center(
            child: FiftyCard(
              padding: const EdgeInsets.all(FiftySpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icon with glow effect
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: rarityColor.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: rarityColor.withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      achievement.icon,
                      color: rarityColor,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: FiftySpacing.lg),

                  // Title
                  Text(
                    'ACHIEVEMENT UNLOCKED!',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      color: successColor,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: FiftySpacing.sm),

                  // Achievement name
                  Text(
                    achievement.name.toUpperCase(),
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.titleLarge,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: FiftySpacing.xs),

                  // Rarity
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: FiftySpacing.md,
                      vertical: FiftySpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: rarityColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(FiftyRadii.sm),
                    ),
                    child: Text(
                      achievement.rarity.label.toUpperCase(),
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        fontWeight: FontWeight.bold,
                        color: rarityColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: FiftySpacing.lg),

                  // Description
                  Text(
                    achievement.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodyMedium,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: FiftySpacing.lg),

                  // Dismiss hint
                  Text(
                    'Tap anywhere to dismiss',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Card widget for displaying an achievement.
class _AchievementCard extends StatelessWidget {
  const _AchievementCard({required this.achievement});

  final DemoAchievement achievement;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final rarityColor = achievement.rarity.getColor(context);

    return Opacity(
      opacity: achievement.isUnlocked ? 1.0 : 0.6,
      child: FiftyCard(
        padding: const EdgeInsets.all(FiftySpacing.md),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: achievement.isUnlocked
                    ? rarityColor.withValues(alpha: 0.2)
                    : colorScheme.onSurfaceVariant.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(FiftyRadii.sm),
              ),
              child: Icon(
                achievement.isUnlocked ? achievement.icon : Icons.lock_outline,
                color: achievement.isUnlocked
                    ? rarityColor
                    : colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ),
            const SizedBox(width: FiftySpacing.md),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          achievement.name.toUpperCase(),
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: FiftyTypography.bodyMedium,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: FiftySpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: rarityColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(FiftyRadii.sm),
                        ),
                        child: Text(
                          achievement.rarity.label.toUpperCase(),
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: 10,
                            color: rarityColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: FiftySpacing.xs),
                  Text(
                    achievement.description,
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      color: colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),

                  // Progress bar for locked achievements
                  if (!achievement.isUnlocked) ...[
                    const SizedBox(height: FiftySpacing.sm),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: achievement.progress,
                              backgroundColor:
                                  colorScheme.onSurfaceVariant.withValues(alpha: 0.3),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                rarityColor,
                              ),
                              minHeight: 4,
                            ),
                          ),
                        ),
                        const SizedBox(width: FiftySpacing.sm),
                        Text(
                          achievement.progressText,
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: 10,
                            color: colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Checkmark for unlocked
            if (achievement.isUnlocked)
              Builder(
                builder: (context) {
                  final fiftyTheme = Theme.of(context).extension<FiftyThemeExtension>();
                  final colorScheme = Theme.of(context).colorScheme;
                  return Padding(
                    padding: const EdgeInsets.only(left: FiftySpacing.sm),
                    child: Icon(
                      Icons.check_circle,
                      color: fiftyTheme?.success ?? colorScheme.tertiary,
                      size: 24,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
