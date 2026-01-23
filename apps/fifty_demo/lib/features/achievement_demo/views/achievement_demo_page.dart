/// Achievement Demo Page
///
/// Demonstrates achievement tracking and unlocking.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../../../shared/widgets/section_header.dart';
import '../actions/achievement_demo_actions.dart';
import '../controllers/achievement_demo_view_model.dart';

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
        return Scaffold(
          backgroundColor: FiftyColors.darkBurgundy,
          appBar: AppBar(
            backgroundColor: FiftyColors.surfaceDark,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: FiftyColors.cream),
              onPressed: actions.onBackTapped,
            ),
            title: const Text(
              'ACHIEVEMENT ENGINE',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodyLarge,
                fontWeight: FontWeight.bold,
                color: FiftyColors.cream,
                letterSpacing: 2,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: FiftyColors.cream),
                onPressed: () => actions.onResetTapped(context),
                tooltip: 'Reset All',
              ),
            ],
          ),
          body: Stack(
            children: [
              DemoScaffold(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary Stats
                      _buildSummaryCard(viewModel),
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
                _buildUnlockPopup(viewModel.recentUnlock!, actions),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(AchievementDemoViewModel viewModel) {
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
                        color: FiftyColors.cream.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: FiftySpacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(FiftyRadii.sm),
                      child: LinearProgressIndicator(
                        value: viewModel.completionPercentage,
                        backgroundColor:
                            FiftyColors.slateGrey.withValues(alpha: 0.3),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          FiftyColors.hunterGreen,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: FiftySpacing.lg),
              Text(
                '${(viewModel.completionPercentage * 100).toInt()}%',
                style: const TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.titleLarge,
                  fontWeight: FontWeight.bold,
                  color: FiftyColors.hunterGreen,
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

              if (total == 0) return const SizedBox.shrink();

              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: rarity.color.withValues(alpha: 0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: rarity.color,
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
                        color: FiftyColors.cream.withValues(alpha: 0.5),
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
              color: FiftyColors.surfaceDark,
              borderRadius: BorderRadius.circular(FiftyRadii.md),
              border: Border.all(color: FiftyColors.borderDark),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  event.icon,
                  color: FiftyColors.burgundy,
                  size: 20,
                ),
                const SizedBox(width: FiftySpacing.sm),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.label.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: FiftyColors.cream,
                      ),
                    ),
                    Text(
                      event == GameEvent.goldCollected
                          ? '+$amount ($count total)'
                          : 'x$count',
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: 10,
                        color: FiftyColors.cream.withValues(alpha: 0.5),
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
    DemoAchievement achievement,
    AchievementDemoActions actions,
  ) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: actions.onDismissUnlock,
        child: Container(
          color: Colors.black.withValues(alpha: 0.7),
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
                      color: achievement.rarity.color.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: achievement.rarity.color.withValues(alpha: 0.5),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      achievement.icon,
                      color: achievement.rarity.color,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: FiftySpacing.lg),

                  // Title
                  const Text(
                    'ACHIEVEMENT UNLOCKED!',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      color: FiftyColors.hunterGreen,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: FiftySpacing.sm),

                  // Achievement name
                  Text(
                    achievement.name.toUpperCase(),
                    style: const TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.titleLarge,
                      fontWeight: FontWeight.bold,
                      color: FiftyColors.cream,
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
                      color: achievement.rarity.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(FiftyRadii.sm),
                    ),
                    child: Text(
                      achievement.rarity.label.toUpperCase(),
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: FiftyTypography.bodySmall,
                        fontWeight: FontWeight.bold,
                        color: achievement.rarity.color,
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
                      color: FiftyColors.cream.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(height: FiftySpacing.lg),

                  // Dismiss hint
                  Text(
                    'Tap anywhere to dismiss',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.bodySmall,
                      color: FiftyColors.cream.withValues(alpha: 0.5),
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
                    ? achievement.rarity.color.withValues(alpha: 0.2)
                    : FiftyColors.slateGrey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(FiftyRadii.sm),
              ),
              child: Icon(
                achievement.isUnlocked ? achievement.icon : Icons.lock_outline,
                color: achievement.isUnlocked
                    ? achievement.rarity.color
                    : FiftyColors.slateGrey,
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
                          style: const TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: FiftyTypography.bodyMedium,
                            fontWeight: FontWeight.bold,
                            color: FiftyColors.cream,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: FiftySpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: achievement.rarity.color.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(FiftyRadii.sm),
                        ),
                        child: Text(
                          achievement.rarity.label.toUpperCase(),
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: 10,
                            color: achievement.rarity.color,
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
                      color: FiftyColors.cream.withValues(alpha: 0.7),
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
                                  FiftyColors.slateGrey.withValues(alpha: 0.3),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                achievement.rarity.color,
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
                            color: FiftyColors.cream.withValues(alpha: 0.5),
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
              const Padding(
                padding: EdgeInsets.only(left: FiftySpacing.sm),
                child: Icon(
                  Icons.check_circle,
                  color: FiftyColors.hunterGreen,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
