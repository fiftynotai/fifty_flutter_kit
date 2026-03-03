import 'package:fifty_achievement_engine/fifty_achievement_engine.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Example demonstrating custom builder patterns for achievement widgets.
///
/// Shows how to use [AchievementList.itemBuilder],
/// [AchievementSummary.contentBuilder], and
/// [AchievementProgressBar.barBuilder] to fully customise the UI.
class CustomBuildersExample extends StatefulWidget {
  const CustomBuildersExample({super.key});

  @override
  State<CustomBuildersExample> createState() => _CustomBuildersExampleState();
}

class _CustomBuildersExampleState extends State<CustomBuildersExample> {
  late final AchievementController<void> _controller;

  @override
  void initState() {
    super.initState();
    _controller = AchievementController(
      achievements: _createAchievements(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Achievement<void>> _createAchievements() {
    return [
      const Achievement(
        id: 'explore_1',
        name: 'Trailblazer',
        description: 'Explore your first area',
        condition: EventCondition('area_explored'),
        rarity: AchievementRarity.common,
        points: 10,
        icon: Icons.explore,
        category: 'Exploration',
      ),
      const Achievement(
        id: 'explore_5',
        name: 'Cartographer',
        description: 'Explore 5 different areas',
        condition: CountCondition('area_explored', target: 5),
        rarity: AchievementRarity.uncommon,
        points: 30,
        icon: Icons.map,
        category: 'Exploration',
      ),
      const Achievement(
        id: 'collect_10',
        name: 'Collector',
        description: 'Collect 10 items',
        condition: CountCondition('item_collected', target: 10),
        rarity: AchievementRarity.rare,
        points: 50,
        icon: Icons.inventory_2,
        category: 'Collection',
      ),
      const Achievement(
        id: 'collect_50',
        name: 'Hoarder',
        description: 'Collect 50 items',
        condition: CountCondition('item_collected', target: 50),
        rarity: AchievementRarity.epic,
        points: 150,
        icon: Icons.warehouse,
        category: 'Collection',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Builders'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: FiftySpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // --- Custom Summary via contentBuilder ---
            Padding(
              padding: EdgeInsets.all(FiftySpacing.md),
              child: _buildSectionLabel(context, 'AchievementSummary + contentBuilder'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: FiftySpacing.md),
              child: AchievementSummary<void>(
                controller: _controller,
                contentBuilder: (data) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: FiftySpacing.md,
                      vertical: FiftySpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: FiftyRadii.mdRadius,
                      border: Border.all(color: colorScheme.outline),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.emoji_events,
                          color: colorScheme.primary,
                        ),
                        SizedBox(width: FiftySpacing.sm),
                        Text(
                          '${data.unlockedCount}/${data.totalCount} unlocked',
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: FiftyTypography.titleSmall,
                            fontWeight: FiftyTypography.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${data.earnedPoints} pts',
                          style: TextStyle(
                            fontFamily: FiftyTypography.fontFamily,
                            fontSize: FiftyTypography.bodyMedium,
                            fontWeight: FiftyTypography.semiBold,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: FiftySpacing.lg),

            // --- Custom ProgressBar via barBuilder ---
            Padding(
              padding: EdgeInsets.all(FiftySpacing.md),
              child: _buildSectionLabel(context, 'AchievementProgressBar + barBuilder'),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: FiftySpacing.md),
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, _) {
                  return AchievementProgressBar(
                    progress: _controller.completionPercentage,
                    height: 16,
                    showLabel: true,
                    barBuilder: (progress, height, bgColor, fgColor, radius) {
                      return ClipRRect(
                        borderRadius: radius,
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: height,
                          backgroundColor: bgColor,
                          valueColor: AlwaysStoppedAnimation(fgColor),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            SizedBox(height: FiftySpacing.lg),

            // --- Action buttons ---
            Padding(
              padding: EdgeInsets.symmetric(horizontal: FiftySpacing.md),
              child: Wrap(
                spacing: FiftySpacing.sm,
                runSpacing: FiftySpacing.sm,
                children: [
                  _buildActionChip(
                    context,
                    label: 'Explore Area',
                    onPressed: () =>
                        _controller.trackEvent('area_explored'),
                  ),
                  _buildActionChip(
                    context,
                    label: 'Collect Item',
                    onPressed: () =>
                        _controller.trackEvent('item_collected'),
                  ),
                  _buildActionChip(
                    context,
                    label: 'Reset',
                    onPressed: () => _controller.reset(),
                  ),
                ],
              ),
            ),

            SizedBox(height: FiftySpacing.lg),

            // --- Custom List via itemBuilder ---
            Padding(
              padding: EdgeInsets.all(FiftySpacing.md),
              child: _buildSectionLabel(context, 'AchievementList + itemBuilder'),
            ),
            AchievementList<void>(
              controller: _controller,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (achievement, progress, state, index) {
                final isComplete = state.isComplete;
                return Card(
                  color: colorScheme.surfaceContainerHighest,
                  shape: RoundedRectangleBorder(
                    borderRadius: FiftyRadii.mdRadius,
                    side: BorderSide(
                      color: isComplete
                          ? colorScheme.primary
                          : colorScheme.outline,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      achievement.icon ?? Icons.emoji_events,
                      color: isComplete
                          ? colorScheme.primary
                          : colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                    title: Text(
                      achievement.name,
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontWeight: FiftyTypography.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (achievement.description != null)
                          Text(
                            achievement.description!,
                            style: TextStyle(
                              fontFamily: FiftyTypography.fontFamily,
                              fontSize: FiftyTypography.bodySmall,
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        SizedBox(height: FiftySpacing.xs),
                        AchievementProgressBar(
                          progress: progress,
                          height: 4,
                          foregroundColor: colorScheme.primary,
                          barBuilder:
                              (prog, h, bgColor, fgColor, radius) {
                            return ClipRRect(
                              borderRadius: radius,
                              child: LinearProgressIndicator(
                                value: prog,
                                minHeight: h,
                                backgroundColor: bgColor,
                                valueColor:
                                    AlwaysStoppedAnimation(fgColor),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    trailing: isComplete
                        ? Icon(
                            Icons.check_circle,
                            color: colorScheme.primary,
                          )
                        : Text(
                            '${(progress * 100).toStringAsFixed(0)}%',
                            style: TextStyle(
                              fontFamily: FiftyTypography.fontFamily,
                              fontWeight: FiftyTypography.semiBold,
                              color: colorScheme.onSurface
                                  .withValues(alpha: 0.7),
                            ),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Text(
      text,
      style: TextStyle(
        fontFamily: FiftyTypography.fontFamily,
        fontSize: FiftyTypography.labelMedium,
        fontWeight: FiftyTypography.bold,
        letterSpacing: FiftyTypography.letterSpacingLabelMedium,
        color: colorScheme.onSurface.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildActionChip(
    BuildContext context, {
    required String label,
    required VoidCallback onPressed,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return ActionChip(
      label: Text(
        label,
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamily,
          fontWeight: FiftyTypography.semiBold,
          color: colorScheme.onSurface,
        ),
      ),
      onPressed: onPressed,
      backgroundColor: colorScheme.surfaceContainerHighest,
      side: BorderSide(color: colorScheme.outline),
      shape: RoundedRectangleBorder(borderRadius: FiftyRadii.mdRadius),
    );
  }
}
