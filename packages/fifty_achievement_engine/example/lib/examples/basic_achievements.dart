import 'package:fifty_achievement_engine/fifty_achievement_engine.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Basic achievements example with simple event and count conditions.
class BasicAchievementsExample extends StatefulWidget {
  const BasicAchievementsExample({super.key});

  @override
  State<BasicAchievementsExample> createState() =>
      _BasicAchievementsExampleState();
}

class _BasicAchievementsExampleState extends State<BasicAchievementsExample> {
  late final AchievementController<void> _controller;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _controller = AchievementController(
      achievements: _createAchievements(),
      onUnlock: _onAchievementUnlocked,
    );
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _controller.dispose();
    super.dispose();
  }

  List<Achievement<void>> _createAchievements() {
    return [
      const Achievement(
        id: 'first_click',
        name: 'First Click',
        description: 'Click the button for the first time',
        condition: EventCondition('button_clicked'),
        rarity: AchievementRarity.common,
        points: 10,
        category: 'Basics',
      ),
      const Achievement(
        id: 'click_10',
        name: 'Getting Started',
        description: 'Click the button 10 times',
        condition: CountCondition('button_clicked', target: 10),
        rarity: AchievementRarity.common,
        points: 20,
        category: 'Basics',
      ),
      const Achievement(
        id: 'click_50',
        name: 'Dedicated Clicker',
        description: 'Click the button 50 times',
        condition: CountCondition('button_clicked', target: 50),
        rarity: AchievementRarity.uncommon,
        points: 50,
        category: 'Basics',
      ),
      const Achievement(
        id: 'click_100',
        name: 'Click Master',
        description: 'Click the button 100 times',
        condition: CountCondition('button_clicked', target: 100),
        rarity: AchievementRarity.rare,
        points: 100,
        category: 'Basics',
      ),
      const Achievement(
        id: 'reset_achievement',
        name: 'Fresh Start',
        description: 'Reset your progress',
        condition: EventCondition('progress_reset'),
        rarity: AchievementRarity.uncommon,
        points: 25,
        category: 'Special',
      ),
      const Achievement(
        id: 'hidden_achievement',
        name: 'Secret Discovery',
        description: 'You found the hidden achievement!',
        condition: EventCondition('secret_found'),
        rarity: AchievementRarity.epic,
        points: 200,
        category: 'Special',
        hidden: true,
      ),
    ];
  }

  void _onAchievementUnlocked(Achievement<void> achievement) {
    _showUnlockPopup(achievement);
  }

  void _showUnlockPopup(Achievement<void> achievement) {
    _overlayEntry?.remove();
    _overlayEntry = OverlayEntry(
      builder: (context) => AchievementPopup<void>(
        achievement: achievement,
        onDismiss: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
        },
      ),
    );
    Overlay.of(context).insert(_overlayEntry!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Achievements'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _controller.trackEvent('progress_reset');
              _controller.resetTracking();
            },
            tooltip: 'Reset tracking',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: FiftySpacing.xxl),
        child: Column(
          children: [
            // Summary at top
            Padding(
              padding: const EdgeInsets.all(FiftySpacing.md),
              child: AchievementSummary(
                controller: _controller,
                showRarityBreakdown: true,
                compact: true,
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: FiftySpacing.md),
              child: Row(
                children: [
                  Expanded(
                    child: _buildActionButton(
                      label: 'Click Me!',
                      onPressed: () => _controller.trackEvent('button_clicked'),
                      color: FiftyColors.burgundy,
                    ),
                  ),
                  const SizedBox(width: FiftySpacing.md),
                  Expanded(
                    child: _buildActionButton(
                      label: 'Find Secret',
                      onPressed: () => _controller.trackEvent('secret_found'),
                      color: FiftyColors.slateGrey,
                    ),
                  ),
                ],
              ),
            ),

            // Click counter
            Padding(
              padding: const EdgeInsets.all(FiftySpacing.md),
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, _) {
                  final clicks = _controller.context.getEventCount('button_clicked');
                  return Text(
                    'Clicks: $clicks',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.titleLarge,
                      fontWeight: FiftyTypography.bold,
                      color: FiftyColors.cream,
                    ),
                  );
                },
              ),
            ),

            // Achievement list
            AchievementList<void>(
              controller: _controller,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onTap: (achievement) {
                _showAchievementDetails(context, achievement);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: FiftySpacing.md),
        shape: RoundedRectangleBorder(
          borderRadius: FiftyRadii.xlRadius,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamily,
          fontWeight: FiftyTypography.bold,
        ),
      ),
    );
  }

  void _showAchievementDetails(
    BuildContext context,
    Achievement<void> achievement,
  ) {
    final progress = _controller.getProgressDetails(achievement.id);

    showModalBottomSheet(
      context: context,
      backgroundColor: FiftyColors.surfaceDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(FiftyRadii.xxl)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(FiftySpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                achievement.name,
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.titleLarge,
                  fontWeight: FiftyTypography.bold,
                  color: FiftyColors.cream,
                ),
              ),
              if (achievement.description != null) ...[
                const SizedBox(height: FiftySpacing.sm),
                Text(
                  achievement.description!,
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    color: FiftyColors.cream.withValues(alpha: 0.7),
                  ),
                ),
              ],
              const SizedBox(height: FiftySpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress: ${progress.current}/${progress.target}',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      color: FiftyColors.cream,
                    ),
                  ),
                  Text(
                    '${(progress.percentage * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontWeight: FiftyTypography.bold,
                      color: FiftyColors.burgundy,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FiftySpacing.sm),
              AchievementProgressBar(progress: progress.percentage),
              const SizedBox(height: FiftySpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Rarity: ${achievement.rarity.displayName}',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      color: FiftyColors.cream.withValues(alpha: 0.7),
                    ),
                  ),
                  Text(
                    'Points: ${achievement.points}',
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      color: FiftyColors.cream.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: FiftySpacing.lg),
            ],
          ),
        );
      },
    );
  }
}
