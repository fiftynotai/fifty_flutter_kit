/// Achievement definitions for Tactical Grid.
///
/// All achievement data for the game. Uses [EventCondition] and
/// [CountCondition] from the fifty_achievement_engine package.
library;

import 'package:fifty_achievement_engine/fifty_achievement_engine.dart';
import 'package:flutter/material.dart';

/// All tactical grid achievements.
List<Achievement<void>> get tacticalGridAchievements => [
      const Achievement<void>(
        id: 'first_blood',
        name: 'First Blood',
        description: 'Defeat your first enemy unit.',
        icon: Icons.local_fire_department,
        rarity: AchievementRarity.common,
        points: 10,
        condition: EventCondition('unit_defeated'),
        category: 'Combat',
      ),
      const Achievement<void>(
        id: 'commander_slayer',
        name: 'Commander Slayer',
        description: 'Capture an enemy Commander.',
        icon: Icons.star,
        rarity: AchievementRarity.rare,
        points: 25,
        condition: EventCondition('commander_captured'),
        category: 'Combat',
      ),
      const Achievement<void>(
        id: 'flawless_victory',
        name: 'Flawless Victory',
        description: 'Win a game without losing any units.',
        icon: Icons.shield,
        rarity: AchievementRarity.epic,
        points: 50,
        condition: EventCondition('flawless_win'),
        category: 'Strategy',
      ),
      const Achievement<void>(
        id: 'tactician',
        name: 'Tactician',
        description: 'Win 5 games.',
        icon: Icons.emoji_events,
        rarity: AchievementRarity.rare,
        points: 30,
        condition: CountCondition('game_won', target: 5),
        category: 'Mastery',
      ),
      const Achievement<void>(
        id: 'veteran',
        name: 'Veteran',
        description: 'Win 10 games.',
        icon: Icons.military_tech,
        rarity: AchievementRarity.epic,
        points: 50,
        condition: CountCondition('game_won', target: 10),
        category: 'Mastery',
        prerequisites: ['tactician'],
      ),
      const Achievement<void>(
        id: 'blitz',
        name: 'Blitz',
        description: 'Win a game in under 10 turns.',
        icon: Icons.flash_on,
        rarity: AchievementRarity.rare,
        points: 30,
        condition: EventCondition('blitz_win'),
        category: 'Strategy',
      ),
      const Achievement<void>(
        id: 'patient_general',
        name: 'Patient General',
        description: 'Win a game lasting 20 or more turns.',
        icon: Icons.hourglass_bottom,
        rarity: AchievementRarity.uncommon,
        points: 15,
        condition: EventCondition('long_win'),
        category: 'Strategy',
      ),
      const Achievement<void>(
        id: 'knight_master',
        name: 'Knight Master',
        description: 'Defeat 10 enemies with Knights.',
        icon: Icons.sports_kabaddi,
        rarity: AchievementRarity.rare,
        points: 25,
        condition: CountCondition('knight_kill', target: 10),
        category: 'Combat',
      ),
      const Achievement<void>(
        id: 'shield_wall',
        name: 'Shield Wall',
        description: 'Block 20 attacks with Shields.',
        icon: Icons.security,
        rarity: AchievementRarity.rare,
        points: 25,
        condition: CountCondition('shield_block', target: 20),
        category: 'Combat',
      ),
      const Achievement<void>(
        id: 'total_war',
        name: 'Total War',
        description: 'Defeat 50 enemy units across all games.',
        icon: Icons.whatshot,
        rarity: AchievementRarity.legendary,
        points: 100,
        condition: CountCondition('unit_defeated', target: 50),
        category: 'Mastery',
      ),
    ];
