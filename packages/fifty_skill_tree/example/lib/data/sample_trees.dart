import 'package:fifty_skill_tree/fifty_skill_tree.dart';
import 'package:flutter/material.dart';

/// Creates a basic 5-node linear skill tree.
///
/// Good for demonstrating simple progression mechanics.
SkillTree<void> createBasicTree() {
  final tree = SkillTree<void>(
    id: 'basic',
    name: 'Basic Skills',
  );

  // Add nodes in a linear chain
  tree.addNode(SkillNode(
    id: 'strike',
    name: 'Strike',
    description: 'A basic attack that deals damage to a single target.',
    icon: Icons.gps_fixed,
    costs: [1],
    tier: 0,
  ));

  tree.addNode(SkillNode(
    id: 'power_strike',
    name: 'Power Strike',
    description: 'An enhanced strike that deals 50% more damage.',
    icon: Icons.flash_on,
    costs: [2],
    prerequisites: ['strike'],
    tier: 1,
  ));

  tree.addNode(SkillNode(
    id: 'critical_strike',
    name: 'Critical Strike',
    description: 'Chance to deal double damage on hit.',
    icon: Icons.stars,
    costs: [2],
    prerequisites: ['power_strike'],
    tier: 2,
  ));

  tree.addNode(SkillNode(
    id: 'fury',
    name: 'Fury',
    description: 'Enter a rage state, increasing attack speed.',
    icon: Icons.local_fire_department,
    costs: [3],
    prerequisites: ['critical_strike'],
    tier: 3,
  ));

  tree.addNode(SkillNode(
    id: 'devastation',
    name: 'Devastation',
    description: 'Ultimate attack dealing massive damage.',
    icon: Icons.whatshot,
    costs: [4],
    prerequisites: ['fury'],
    tier: 4,
    type: SkillType.ultimate,
  ));

  // Add connections
  tree.addConnection(SkillConnection(fromId: 'strike', toId: 'power_strike'));
  tree.addConnection(
      SkillConnection(fromId: 'power_strike', toId: 'critical_strike'));
  tree.addConnection(SkillConnection(fromId: 'critical_strike', toId: 'fury'));
  tree.addConnection(SkillConnection(fromId: 'fury', toId: 'devastation'));

  return tree;
}

/// Creates a multi-branch RPG skill tree with 3 paths.
///
/// Paths: Warrior (strength), Mage (magic), Rogue (agility)
SkillTree<void> createRpgTree() {
  final tree = SkillTree<void>(
    id: 'rpg',
    name: 'Class Skills',
  );

  // === STARTING NODE ===
  tree.addNode(SkillNode(
    id: 'novice',
    name: 'Novice',
    description: 'Begin your journey as an adventurer.',
    icon: Icons.person,
    costs: [0],
    tier: 0,
    currentLevel: 1, // Start unlocked
  ));

  // === WARRIOR PATH ===
  tree.addNode(SkillNode(
    id: 'warrior_1',
    name: 'Sword Mastery',
    description: 'Increase damage with swords by 10%.',
    icon: Icons.shield,
    costs: [1],
    prerequisites: ['novice'],
    tier: 1,
    branch: 'warrior',
  ));

  tree.addNode(SkillNode(
    id: 'warrior_2',
    name: 'Armor Break',
    description: 'Attacks reduce enemy armor.',
    icon: Icons.construction,
    costs: [2],
    prerequisites: ['warrior_1'],
    tier: 2,
    branch: 'warrior',
  ));

  tree.addNode(SkillNode(
    id: 'warrior_3',
    name: 'Berserker',
    description: 'Deal more damage when health is low.',
    icon: Icons.whatshot,
    costs: [3],
    prerequisites: ['warrior_2'],
    tier: 3,
    branch: 'warrior',
    type: SkillType.ultimate,
  ));

  // === MAGE PATH ===
  tree.addNode(SkillNode(
    id: 'mage_1',
    name: 'Arcane Knowledge',
    description: 'Increase spell damage by 10%.',
    icon: Icons.auto_awesome,
    costs: [1],
    prerequisites: ['novice'],
    tier: 1,
    branch: 'mage',
  ));

  tree.addNode(SkillNode(
    id: 'mage_2',
    name: 'Mana Flow',
    description: 'Reduce spell mana costs.',
    icon: Icons.water_drop,
    costs: [2],
    prerequisites: ['mage_1'],
    tier: 2,
    branch: 'mage',
  ));

  tree.addNode(SkillNode(
    id: 'mage_3',
    name: 'Archmage',
    description: 'Spells have a chance to cast twice.',
    icon: Icons.bolt,
    costs: [3],
    prerequisites: ['mage_2'],
    tier: 3,
    branch: 'mage',
    type: SkillType.ultimate,
  ));

  // === ROGUE PATH ===
  tree.addNode(SkillNode(
    id: 'rogue_1',
    name: 'Quick Feet',
    description: 'Increase movement speed.',
    icon: Icons.directions_run,
    costs: [1],
    prerequisites: ['novice'],
    tier: 1,
    branch: 'rogue',
  ));

  tree.addNode(SkillNode(
    id: 'rogue_2',
    name: 'Backstab',
    description: 'Deal extra damage from behind.',
    icon: Icons.sports_martial_arts,
    costs: [2],
    prerequisites: ['rogue_1'],
    tier: 2,
    branch: 'rogue',
  ));

  tree.addNode(SkillNode(
    id: 'rogue_3',
    name: 'Shadow Step',
    description: 'Teleport behind enemies.',
    icon: Icons.visibility_off,
    costs: [3],
    prerequisites: ['rogue_2'],
    tier: 3,
    branch: 'rogue',
    type: SkillType.ultimate,
  ));

  // Add connections
  // From starting node to each path
  tree.addConnection(SkillConnection(fromId: 'novice', toId: 'warrior_1'));
  tree.addConnection(SkillConnection(fromId: 'novice', toId: 'mage_1'));
  tree.addConnection(SkillConnection(fromId: 'novice', toId: 'rogue_1'));

  // Warrior path
  tree.addConnection(SkillConnection(fromId: 'warrior_1', toId: 'warrior_2'));
  tree.addConnection(SkillConnection(fromId: 'warrior_2', toId: 'warrior_3'));

  // Mage path
  tree.addConnection(SkillConnection(fromId: 'mage_1', toId: 'mage_2'));
  tree.addConnection(SkillConnection(fromId: 'mage_2', toId: 'mage_3'));

  // Rogue path
  tree.addConnection(SkillConnection(fromId: 'rogue_1', toId: 'rogue_2'));
  tree.addConnection(SkillConnection(fromId: 'rogue_2', toId: 'rogue_3'));

  return tree;
}

/// Creates a strategy game tech tree.
///
/// Features multiple research tiers with cross-tier dependencies.
SkillTree<void> createTechTree() {
  final tree = SkillTree<void>(
    id: 'tech',
    name: 'Research',
  );

  // === TIER 0: BASIC ===
  tree.addNode(SkillNode(
    id: 'research_1',
    name: 'Basic Research',
    description: 'Unlocks the research facility.',
    icon: Icons.science,
    costs: [1],
    tier: 0,
  ));

  // === TIER 1 ===
  tree.addNode(SkillNode(
    id: 'military_1',
    name: 'Military Training',
    description: 'Train basic infantry units.',
    icon: Icons.military_tech,
    costs: [2],
    prerequisites: ['research_1'],
    tier: 1,
    branch: 'military',
  ));

  tree.addNode(SkillNode(
    id: 'economy_1',
    name: 'Agriculture',
    description: 'Increase food production.',
    icon: Icons.grass,
    costs: [2],
    prerequisites: ['research_1'],
    tier: 1,
    branch: 'economy',
  ));

  tree.addNode(SkillNode(
    id: 'tech_1',
    name: 'Basic Tools',
    description: 'Improve worker efficiency.',
    icon: Icons.build,
    costs: [2],
    prerequisites: ['research_1'],
    tier: 1,
    branch: 'technology',
  ));

  // === TIER 2 ===
  tree.addNode(SkillNode(
    id: 'military_2',
    name: 'Archery',
    description: 'Train ranged units.',
    icon: Icons.my_location,
    costs: [3],
    prerequisites: ['military_1'],
    tier: 2,
    branch: 'military',
  ));

  tree.addNode(SkillNode(
    id: 'economy_2',
    name: 'Mining',
    description: 'Extract gold from mines.',
    icon: Icons.hardware,
    costs: [3],
    prerequisites: ['economy_1', 'tech_1'],
    tier: 2,
    branch: 'economy',
  ));

  tree.addNode(SkillNode(
    id: 'tech_2',
    name: 'Engineering',
    description: 'Build advanced structures.',
    icon: Icons.architecture,
    costs: [3],
    prerequisites: ['tech_1'],
    tier: 2,
    branch: 'technology',
  ));

  // === TIER 3 ===
  tree.addNode(SkillNode(
    id: 'military_3',
    name: 'Siege Weapons',
    description: 'Build catapults and trebuchets.',
    icon: Icons.rocket_launch,
    costs: [4],
    prerequisites: ['military_2', 'tech_2'],
    tier: 3,
    branch: 'military',
    type: SkillType.keystone,
  ));

  tree.addNode(SkillNode(
    id: 'economy_3',
    name: 'Trade Routes',
    description: 'Establish trade with other factions.',
    icon: Icons.swap_horiz,
    costs: [4],
    prerequisites: ['economy_2'],
    tier: 3,
    branch: 'economy',
    type: SkillType.keystone,
  ));

  tree.addNode(SkillNode(
    id: 'tech_3',
    name: 'Advanced Research',
    description: 'Unlock ultimate technologies.',
    icon: Icons.psychology,
    costs: [4],
    prerequisites: ['tech_2'],
    tier: 3,
    branch: 'technology',
    type: SkillType.keystone,
  ));

  // Add connections
  tree.addConnection(SkillConnection(fromId: 'research_1', toId: 'military_1'));
  tree.addConnection(SkillConnection(fromId: 'research_1', toId: 'economy_1'));
  tree.addConnection(SkillConnection(fromId: 'research_1', toId: 'tech_1'));

  tree.addConnection(SkillConnection(fromId: 'military_1', toId: 'military_2'));
  tree.addConnection(SkillConnection(fromId: 'economy_1', toId: 'economy_2'));
  tree.addConnection(SkillConnection(fromId: 'tech_1', toId: 'economy_2'));
  tree.addConnection(SkillConnection(fromId: 'tech_1', toId: 'tech_2'));

  tree.addConnection(SkillConnection(fromId: 'military_2', toId: 'military_3'));
  tree.addConnection(SkillConnection(fromId: 'tech_2', toId: 'military_3'));
  tree.addConnection(SkillConnection(fromId: 'economy_2', toId: 'economy_3'));
  tree.addConnection(SkillConnection(fromId: 'tech_2', toId: 'tech_3'));

  return tree;
}

/// Creates a MOBA-style talent tree with 3 paths.
///
/// Players choose between Offense, Defense, or Utility.
SkillTree<void> createTalentTree() {
  final tree = SkillTree<void>(
    id: 'talents',
    name: 'Talents',
  );

  // === OFFENSE PATH ===
  tree.addNode(SkillNode(
    id: 'offense_1',
    name: 'Damage +5%',
    description: 'Increase all damage dealt by 5%.',
    icon: Icons.flash_on,
    costs: [1],
    maxLevel: 3,
    tier: 0,
    branch: 'offense',
  ));

  tree.addNode(SkillNode(
    id: 'offense_2',
    name: 'Crit Chance',
    description: 'Increase critical hit chance by 3%.',
    icon: Icons.stars,
    costs: [1],
    maxLevel: 3,
    prerequisites: ['offense_1'],
    tier: 1,
    branch: 'offense',
  ));

  tree.addNode(SkillNode(
    id: 'offense_3',
    name: 'Armor Pen',
    description: 'Ignore 5% of enemy armor.',
    icon: Icons.shield,
    costs: [2],
    maxLevel: 2,
    prerequisites: ['offense_2'],
    tier: 2,
    branch: 'offense',
  ));

  tree.addNode(SkillNode(
    id: 'offense_4',
    name: 'Execute',
    description: 'Deal 10% more damage to low health enemies.',
    icon: Icons.whatshot,
    costs: [3],
    prerequisites: ['offense_3'],
    tier: 3,
    branch: 'offense',
    type: SkillType.keystone,
  ));

  // === DEFENSE PATH ===
  tree.addNode(SkillNode(
    id: 'defense_1',
    name: 'Health +5%',
    description: 'Increase maximum health by 5%.',
    icon: Icons.favorite,
    costs: [1],
    maxLevel: 3,
    tier: 0,
    branch: 'defense',
  ));

  tree.addNode(SkillNode(
    id: 'defense_2',
    name: 'Armor +5%',
    description: 'Increase armor by 5%.',
    icon: Icons.security,
    costs: [1],
    maxLevel: 3,
    prerequisites: ['defense_1'],
    tier: 1,
    branch: 'defense',
  ));

  tree.addNode(SkillNode(
    id: 'defense_3',
    name: 'Regen',
    description: 'Regenerate 1% health per second.',
    icon: Icons.healing,
    costs: [2],
    maxLevel: 2,
    prerequisites: ['defense_2'],
    tier: 2,
    branch: 'defense',
  ));

  tree.addNode(SkillNode(
    id: 'defense_4',
    name: 'Fortitude',
    description: 'Survive a killing blow once per fight.',
    icon: Icons.shield,
    costs: [3],
    prerequisites: ['defense_3'],
    tier: 3,
    branch: 'defense',
    type: SkillType.keystone,
  ));

  // === UTILITY PATH ===
  tree.addNode(SkillNode(
    id: 'utility_1',
    name: 'Move Speed',
    description: 'Increase movement speed by 3%.',
    icon: Icons.directions_run,
    costs: [1],
    maxLevel: 3,
    tier: 0,
    branch: 'utility',
  ));

  tree.addNode(SkillNode(
    id: 'utility_2',
    name: 'Cooldown Red.',
    description: 'Reduce ability cooldowns by 3%.',
    icon: Icons.timer,
    costs: [1],
    maxLevel: 3,
    prerequisites: ['utility_1'],
    tier: 1,
    branch: 'utility',
  ));

  tree.addNode(SkillNode(
    id: 'utility_3',
    name: 'Gold Find',
    description: 'Gain 5% more gold from kills.',
    icon: Icons.monetization_on,
    costs: [2],
    maxLevel: 2,
    prerequisites: ['utility_2'],
    tier: 2,
    branch: 'utility',
  ));

  tree.addNode(SkillNode(
    id: 'utility_4',
    name: 'Flash',
    description: 'Gain a short-range teleport ability.',
    icon: Icons.bolt,
    costs: [3],
    prerequisites: ['utility_3'],
    tier: 3,
    branch: 'utility',
    type: SkillType.keystone,
  ));

  // Add connections
  // Offense
  tree.addConnection(SkillConnection(fromId: 'offense_1', toId: 'offense_2'));
  tree.addConnection(SkillConnection(fromId: 'offense_2', toId: 'offense_3'));
  tree.addConnection(SkillConnection(fromId: 'offense_3', toId: 'offense_4'));

  // Defense
  tree.addConnection(SkillConnection(fromId: 'defense_1', toId: 'defense_2'));
  tree.addConnection(SkillConnection(fromId: 'defense_2', toId: 'defense_3'));
  tree.addConnection(SkillConnection(fromId: 'defense_3', toId: 'defense_4'));

  // Utility
  tree.addConnection(SkillConnection(fromId: 'utility_1', toId: 'utility_2'));
  tree.addConnection(SkillConnection(fromId: 'utility_2', toId: 'utility_3'));
  tree.addConnection(SkillConnection(fromId: 'utility_3', toId: 'utility_4'));

  return tree;
}
