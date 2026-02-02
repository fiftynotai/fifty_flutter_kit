/// Achievement Demo ViewModel
///
/// Business logic for the achievement demo feature.
/// Demonstrates achievement tracking and unlocking.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Achievement rarity levels.
///
/// Colors are resolved at runtime via [AchievementRarityColors] extension
/// to support theme-aware dark/light mode colors.
enum AchievementRarity {
  /// Common achievements.
  common('Common'),

  /// Uncommon achievements.
  uncommon('Uncommon'),

  /// Rare achievements.
  rare('Rare'),

  /// Epic achievements.
  epic('Epic'),

  /// Legendary achievements.
  legendary('Legendary');

  const AchievementRarity(this.label);

  /// Display label for the rarity.
  final String label;
}

/// A demo achievement.
class DemoAchievement {
  /// Creates a demo achievement.
  DemoAchievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.rarity,
    required this.targetValue,
    this.currentValue = 0,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  /// Unique achievement identifier.
  final String id;

  /// Display name.
  final String name;

  /// Description of how to earn.
  final String description;

  /// Icon for the achievement.
  final IconData icon;

  /// Rarity level.
  final AchievementRarity rarity;

  /// Target value to unlock.
  final int targetValue;

  /// Current progress value.
  int currentValue;

  /// Whether the achievement is unlocked.
  bool isUnlocked;

  /// When the achievement was unlocked.
  DateTime? unlockedAt;

  /// Progress percentage (0.0 to 1.0).
  double get progress =>
      targetValue > 0 ? (currentValue / targetValue).clamp(0.0, 1.0) : 0.0;

  /// Progress as percentage string.
  String get progressText =>
      '$currentValue/$targetValue';
}

/// Event types that can trigger achievements.
enum GameEvent {
  /// Enemy killed event.
  enemyKilled('Kill Enemy', Icons.dangerous),

  /// Gold collected event.
  goldCollected('Collect Gold', Icons.monetization_on),

  /// Level completed event.
  levelCompleted('Complete Level', Icons.flag),

  /// Item crafted event.
  itemCrafted('Craft Item', Icons.construction),

  /// Boss defeated event.
  bossDefeated('Defeat Boss', Icons.whatshot);

  const GameEvent(this.label, this.icon);

  /// Display label for the event.
  final String label;

  /// Icon for the event.
  final IconData icon;
}

/// ViewModel for the achievement demo feature.
///
/// Manages achievement state and event tracking.
///
/// **Note:** No `onClose()` override needed. RxList and Rxn observables are
/// auto-disposed by GetX. No external subscriptions, timers, or controllers.
class AchievementDemoViewModel extends GetxController {
  /// All achievements.
  final _achievements = <DemoAchievement>[].obs;
  List<DemoAchievement> get achievements => _achievements;

  /// Recently unlocked achievement (for popup).
  final _recentUnlock = Rxn<DemoAchievement>();
  DemoAchievement? get recentUnlock => _recentUnlock.value;

  /// Event counters.
  final _eventCounts = <GameEvent, int>{}.obs;
  Map<GameEvent, int> get eventCounts => _eventCounts;

  @override
  void onInit() {
    super.onInit();
    _initializeAchievements();
  }

  void _initializeAchievements() {
    _achievements.addAll([
      // Kill enemies achievements
      DemoAchievement(
        id: 'first_blood',
        name: 'First Blood',
        description: 'Kill your first enemy',
        icon: Icons.sports_martial_arts,
        rarity: AchievementRarity.common,
        targetValue: 1,
      ),
      DemoAchievement(
        id: 'warrior',
        name: 'Warrior',
        description: 'Kill 10 enemies',
        icon: Icons.military_tech,
        rarity: AchievementRarity.uncommon,
        targetValue: 10,
      ),

      // Gold collection achievements
      DemoAchievement(
        id: 'penny_pincher',
        name: 'Penny Pincher',
        description: 'Collect 100 gold',
        icon: Icons.savings,
        rarity: AchievementRarity.common,
        targetValue: 100,
      ),
      DemoAchievement(
        id: 'treasure_hunter',
        name: 'Treasure Hunter',
        description: 'Collect 500 gold',
        icon: Icons.diamond,
        rarity: AchievementRarity.rare,
        targetValue: 500,
      ),

      // Level completion achievements
      DemoAchievement(
        id: 'adventurer',
        name: 'Adventurer',
        description: 'Complete 5 levels',
        icon: Icons.explore,
        rarity: AchievementRarity.uncommon,
        targetValue: 5,
      ),

      // Boss achievements
      DemoAchievement(
        id: 'boss_slayer',
        name: 'Boss Slayer',
        description: 'Defeat a boss',
        icon: Icons.emoji_events,
        rarity: AchievementRarity.epic,
        targetValue: 1,
      ),

      // Crafting achievements
      DemoAchievement(
        id: 'craftsman',
        name: 'Craftsman',
        description: 'Craft 3 items',
        icon: Icons.handyman,
        rarity: AchievementRarity.uncommon,
        targetValue: 3,
      ),
    ]);

    // Initialize event counts
    for (final event in GameEvent.values) {
      _eventCounts[event] = 0;
    }
  }

  // ---------------------------------------------------------------------------
  // Event Tracking
  // ---------------------------------------------------------------------------

  /// Triggers a game event.
  ///
  /// Returns list of newly unlocked achievements.
  List<DemoAchievement> triggerEvent(GameEvent event, {int amount = 1}) {
    _eventCounts[event] = (_eventCounts[event] ?? 0) + amount;

    final unlocked = <DemoAchievement>[];

    // Check achievements based on event type
    for (final achievement in _achievements) {
      if (achievement.isUnlocked) continue;

      // Update progress based on event type
      switch (event) {
        case GameEvent.enemyKilled:
          if (achievement.id == 'first_blood' ||
              achievement.id == 'warrior') {
            achievement.currentValue += amount;
          }
          break;
        case GameEvent.goldCollected:
          if (achievement.id == 'penny_pincher' ||
              achievement.id == 'treasure_hunter') {
            achievement.currentValue += amount;
          }
          break;
        case GameEvent.levelCompleted:
          if (achievement.id == 'adventurer') {
            achievement.currentValue += amount;
          }
          break;
        case GameEvent.bossDefeated:
          if (achievement.id == 'boss_slayer') {
            achievement.currentValue += amount;
          }
          break;
        case GameEvent.itemCrafted:
          if (achievement.id == 'craftsman') {
            achievement.currentValue += amount;
          }
          break;
      }

      // Check if unlocked
      if (achievement.currentValue >= achievement.targetValue &&
          !achievement.isUnlocked) {
        achievement.isUnlocked = true;
        achievement.unlockedAt = DateTime.now();
        unlocked.add(achievement);
      }
    }

    // Show most recent unlock
    if (unlocked.isNotEmpty) {
      _recentUnlock.value = unlocked.last;
    }

    update();
    return unlocked;
  }

  /// Clears the recent unlock popup.
  void clearRecentUnlock() {
    _recentUnlock.value = null;
    update();
  }

  // ---------------------------------------------------------------------------
  // Statistics
  // ---------------------------------------------------------------------------

  /// Total achievements unlocked.
  int get unlockedCount =>
      achievements.where((a) => a.isUnlocked).length;

  /// Total number of achievements.
  int get totalCount => achievements.length;

  /// Completion percentage.
  double get completionPercentage =>
      totalCount > 0 ? unlockedCount / totalCount : 0.0;

  /// Gets achievements by rarity.
  List<DemoAchievement> getByRarity(AchievementRarity rarity) =>
      achievements.where((a) => a.rarity == rarity).toList();

  /// Gets unlocked achievements.
  List<DemoAchievement> get unlockedAchievements =>
      achievements.where((a) => a.isUnlocked).toList();

  /// Gets locked achievements.
  List<DemoAchievement> get lockedAchievements =>
      achievements.where((a) => !a.isUnlocked).toList();

  // ---------------------------------------------------------------------------
  // Reset
  // ---------------------------------------------------------------------------

  /// Resets all achievements and event counters.
  void resetAll() {
    for (final achievement in _achievements) {
      achievement.currentValue = 0;
      achievement.isUnlocked = false;
      achievement.unlockedAt = null;
    }
    for (final event in GameEvent.values) {
      _eventCounts[event] = 0;
    }
    _recentUnlock.value = null;
    update();
  }
}
