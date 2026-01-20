import 'package:fifty_achievement_engine/fifty_achievement_engine.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// RPG-style achievements with combat, leveling, and quest conditions.
class RpgAchievementsExample extends StatefulWidget {
  const RpgAchievementsExample({super.key});

  @override
  State<RpgAchievementsExample> createState() => _RpgAchievementsExampleState();
}

class _RpgAchievementsExampleState extends State<RpgAchievementsExample> {
  late final AchievementController<void> _controller;
  OverlayEntry? _overlayEntry;

  int _playerLevel = 1;
  int _gold = 0;
  int _exp = 0;

  @override
  void initState() {
    super.initState();
    _controller = AchievementController(
      achievements: _createAchievements(),
      onUnlock: _onAchievementUnlocked,
    );
    _updateStats();
  }

  @override
  void dispose() {
    _overlayEntry?.remove();
    _controller.dispose();
    super.dispose();
  }

  void _updateStats() {
    _controller.updateStat('player_level', _playerLevel);
    _controller.updateStat('gold', _gold);
    _controller.updateStat('exp', _exp);
  }

  List<Achievement<void>> _createAchievements() {
    return [
      // Combat achievements
      const Achievement(
        id: 'first_blood',
        name: 'First Blood',
        description: 'Defeat your first enemy',
        condition: EventCondition('enemy_killed'),
        rarity: AchievementRarity.common,
        points: 10,
        category: 'Combat',
        icon: Icons.pets,
      ),
      const Achievement(
        id: 'slayer_10',
        name: 'Monster Slayer',
        description: 'Defeat 10 enemies',
        condition: CountCondition('enemy_killed', target: 10),
        rarity: AchievementRarity.common,
        points: 25,
        category: 'Combat',
        prerequisites: ['first_blood'],
        icon: Icons.pets,
      ),
      const Achievement(
        id: 'boss_hunter',
        name: 'Boss Hunter',
        description: 'Defeat a boss enemy',
        condition: EventCondition('boss_killed'),
        rarity: AchievementRarity.rare,
        points: 100,
        category: 'Combat',
        icon: Icons.whatshot,
      ),

      // Leveling achievements
      const Achievement(
        id: 'level_5',
        name: 'Adventurer',
        description: 'Reach level 5',
        condition: ThresholdCondition('player_level', target: 5),
        rarity: AchievementRarity.common,
        points: 20,
        category: 'Progression',
        icon: Icons.arrow_upward,
      ),
      const Achievement(
        id: 'level_10',
        name: 'Veteran',
        description: 'Reach level 10',
        condition: ThresholdCondition('player_level', target: 10),
        rarity: AchievementRarity.uncommon,
        points: 50,
        category: 'Progression',
        prerequisites: ['level_5'],
        icon: Icons.arrow_upward,
      ),
      const Achievement(
        id: 'level_25',
        name: 'Hero',
        description: 'Reach level 25',
        condition: ThresholdCondition('player_level', target: 25),
        rarity: AchievementRarity.rare,
        points: 100,
        category: 'Progression',
        prerequisites: ['level_10'],
        icon: Icons.star,
      ),

      // Wealth achievements
      const Achievement(
        id: 'gold_100',
        name: 'Pocket Change',
        description: 'Accumulate 100 gold',
        condition: ThresholdCondition('gold', target: 100),
        rarity: AchievementRarity.common,
        points: 15,
        category: 'Wealth',
        icon: Icons.monetization_on,
      ),
      const Achievement(
        id: 'gold_1000',
        name: 'Treasure Hunter',
        description: 'Accumulate 1,000 gold',
        condition: ThresholdCondition('gold', target: 1000),
        rarity: AchievementRarity.rare,
        points: 75,
        category: 'Wealth',
        prerequisites: ['gold_100'],
        icon: Icons.monetization_on,
      ),

      // Quest achievements
      const Achievement(
        id: 'first_quest',
        name: 'Quest Taker',
        description: 'Complete your first quest',
        condition: EventCondition('quest_completed'),
        rarity: AchievementRarity.common,
        points: 20,
        category: 'Quests',
        icon: Icons.assignment_turned_in,
      ),

      // Combo achievements
      Achievement(
        id: 'combo_master',
        name: 'Combo Master',
        description: 'Kill 10 enemies AND reach level 10 AND have 500 gold',
        condition: CompositeCondition.and([
          const CountCondition('enemy_killed', target: 10),
          const ThresholdCondition('player_level', target: 10),
          const ThresholdCondition('gold', target: 500),
        ]),
        rarity: AchievementRarity.epic,
        points: 200,
        category: 'Special',
        icon: Icons.auto_awesome,
      ),

      // Hidden achievement
      const Achievement(
        id: 'secret_area',
        name: 'Explorer',
        description: 'Discover the secret area',
        condition: EventCondition('secret_area_found'),
        rarity: AchievementRarity.legendary,
        points: 500,
        category: 'Special',
        hidden: true,
        icon: Icons.explore,
      ),
    ];
  }

  void _onAchievementUnlocked(Achievement<void> achievement) {
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

  void _killEnemy() {
    _controller.trackEvent('enemy_killed');
    _gold += 10;
    _exp += 25;
    _checkLevelUp();
    _updateStats();
  }

  void _killBoss() {
    _controller.trackEvent('boss_killed');
    _controller.trackEvent('enemy_killed');
    _gold += 100;
    _exp += 250;
    _checkLevelUp();
    _updateStats();
  }

  void _completeQuest() {
    _controller.trackEvent('quest_completed');
    _gold += 50;
    _exp += 100;
    _checkLevelUp();
    _updateStats();
  }

  void _findSecret() {
    _controller.trackEvent('secret_area_found');
  }

  void _checkLevelUp() {
    final expForNextLevel = _playerLevel * 100;
    while (_exp >= expForNextLevel) {
      _exp -= expForNextLevel;
      _playerLevel++;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RPG Achievements'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: FiftySpacing.xxl),
        child: Column(
          children: [
            // Player stats
            Container(
              margin: const EdgeInsets.all(FiftySpacing.md),
              padding: const EdgeInsets.all(FiftySpacing.md),
              decoration: BoxDecoration(
                color: FiftyColors.surfaceDark,
                borderRadius: FiftyRadii.lgRadius,
                border: Border.all(color: FiftyColors.borderDark),
              ),
              child: ListenableBuilder(
                listenable: _controller,
                builder: (context, _) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn('Level', _playerLevel.toString()),
                      _buildStatColumn('Gold', _gold.toString()),
                      _buildStatColumn('EXP', _exp.toString()),
                      _buildStatColumn(
                        'Kills',
                        _controller.context.getEventCount('enemy_killed').toString(),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: FiftySpacing.md),
              child: Wrap(
                spacing: FiftySpacing.sm,
                runSpacing: FiftySpacing.sm,
                children: [
                  _buildActionChip('Kill Enemy', _killEnemy, Icons.pets),
                  _buildActionChip('Kill Boss', _killBoss, Icons.whatshot),
                  _buildActionChip(
                      'Complete Quest', _completeQuest, Icons.assignment_turned_in),
                  _buildActionChip('Find Secret', _findSecret, Icons.explore),
                ],
              ),
            ),

            const SizedBox(height: FiftySpacing.md),

            // Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: FiftySpacing.md),
              child: AchievementSummary(
                controller: _controller,
                showCategoryBreakdown: true,
                compact: true,
              ),
            ),

            // Achievement list
            AchievementList<void>(
              controller: _controller,
              compact: true,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.labelSmall,
            fontWeight: FiftyTypography.semiBold,
            letterSpacing: FiftyTypography.letterSpacingLabelMedium,
            color: FiftyColors.cream.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: FiftySpacing.xs),
        Text(
          value,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.titleMedium,
            fontWeight: FiftyTypography.bold,
            color: FiftyColors.cream,
          ),
        ),
      ],
    );
  }

  Widget _buildActionChip(String label, VoidCallback onPressed, IconData icon) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: FiftyColors.cream),
      label: Text(
        label,
        style: TextStyle(
          fontFamily: FiftyTypography.fontFamily,
          color: FiftyColors.cream,
        ),
      ),
      backgroundColor: FiftyColors.burgundy,
      onPressed: onPressed,
    );
  }
}
