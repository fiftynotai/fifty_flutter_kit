/// Skill Tree Demo ViewModel
///
/// Business logic for the skill tree demo feature.
/// Demonstrates skill tree visualization and skill unlocking.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A skill node in the tree.
class DemoSkill {
  /// Creates a demo skill.
  DemoSkill({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.cost,
    this.parentIds = const [],
    this.isUnlocked = false,
  });

  /// Unique skill identifier.
  final String id;

  /// Display name of the skill.
  final String name;

  /// Skill description.
  final String description;

  /// Icon for this skill.
  final IconData icon;

  /// Cost in skill points to unlock.
  final int cost;

  /// Parent skill IDs (prerequisites).
  final List<String> parentIds;

  /// Whether this skill is unlocked.
  bool isUnlocked;
}

/// Skill tree branch categories.
enum SkillBranch {
  /// Combat skills branch.
  combat('Combat', Icons.sports_mma),

  /// Magic skills branch.
  magic('Magic', Icons.auto_awesome),

  /// Utility skills branch.
  utility('Utility', Icons.build);

  const SkillBranch(this.label, this.icon);

  /// Display label for the branch.
  final String label;

  /// Icon for the branch.
  final IconData icon;
}

/// ViewModel for the skill tree demo feature.
///
/// Manages skill tree state and unlocking logic.
class SkillTreeDemoViewModel extends GetxController {
  /// Available skill points.
  final _skillPoints = 10.obs;
  int get skillPoints => _skillPoints.value;

  /// Total skills unlocked.
  final _unlockedCount = 0.obs;
  int get unlockedCount => _unlockedCount.value;

  /// Currently selected branch.
  final _selectedBranch = SkillBranch.combat.obs;
  SkillBranch get selectedBranch => _selectedBranch.value;

  /// Currently selected skill (for detail view).
  final _selectedSkill = Rxn<DemoSkill>();
  DemoSkill? get selectedSkill => _selectedSkill.value;

  /// All skills organized by branch.
  final Map<SkillBranch, List<DemoSkill>> _skills = {};

  @override
  void onInit() {
    super.onInit();
    _initializeSkills();
  }

  void _initializeSkills() {
    // Combat branch
    _skills[SkillBranch.combat] = [
      DemoSkill(
        id: 'combat_basic',
        name: 'Basic Strike',
        description: 'Learn the fundamentals of combat.',
        icon: Icons.fitness_center,
        cost: 1,
        isUnlocked: true, // Starting skill
      ),
      DemoSkill(
        id: 'combat_power',
        name: 'Power Attack',
        description: 'Deliver devastating blows with increased damage.',
        icon: Icons.flash_on,
        cost: 2,
        parentIds: ['combat_basic'],
      ),
      DemoSkill(
        id: 'combat_defense',
        name: 'Iron Defense',
        description: 'Reduce incoming damage significantly.',
        icon: Icons.shield,
        cost: 2,
        parentIds: ['combat_basic'],
      ),
      DemoSkill(
        id: 'combat_critical',
        name: 'Critical Strike',
        description: 'Chance to deal double damage on attacks.',
        icon: Icons.bolt,
        cost: 3,
        parentIds: ['combat_power'],
      ),
    ];

    // Magic branch
    _skills[SkillBranch.magic] = [
      DemoSkill(
        id: 'magic_basic',
        name: 'Mana Control',
        description: 'Harness the basics of magical energy.',
        icon: Icons.water_drop,
        cost: 1,
        isUnlocked: true, // Starting skill
      ),
      DemoSkill(
        id: 'magic_fire',
        name: 'Fireball',
        description: 'Hurl a ball of fire at enemies.',
        icon: Icons.local_fire_department,
        cost: 2,
        parentIds: ['magic_basic'],
      ),
      DemoSkill(
        id: 'magic_ice',
        name: 'Ice Shard',
        description: 'Launch freezing projectiles.',
        icon: Icons.ac_unit,
        cost: 2,
        parentIds: ['magic_basic'],
      ),
      DemoSkill(
        id: 'magic_lightning',
        name: 'Chain Lightning',
        description: 'Electricity jumps between targets.',
        icon: Icons.electric_bolt,
        cost: 3,
        parentIds: ['magic_fire', 'magic_ice'],
      ),
    ];

    // Utility branch
    _skills[SkillBranch.utility] = [
      DemoSkill(
        id: 'util_basic',
        name: 'Survival Instinct',
        description: 'Basic survival and awareness skills.',
        icon: Icons.visibility,
        cost: 1,
        isUnlocked: true, // Starting skill
      ),
      DemoSkill(
        id: 'util_stealth',
        name: 'Shadow Step',
        description: 'Move silently and avoid detection.',
        icon: Icons.nightlight,
        cost: 2,
        parentIds: ['util_basic'],
      ),
      DemoSkill(
        id: 'util_heal',
        name: 'First Aid',
        description: 'Heal yourself in combat.',
        icon: Icons.healing,
        cost: 2,
        parentIds: ['util_basic'],
      ),
      DemoSkill(
        id: 'util_master',
        name: 'Jack of All Trades',
        description: 'Master utility skills boost all abilities.',
        icon: Icons.star,
        cost: 4,
        parentIds: ['util_stealth', 'util_heal'],
      ),
    ];

    _updateUnlockedCount();
  }

  /// Gets skills for the selected branch.
  List<DemoSkill> get currentBranchSkills =>
      _skills[selectedBranch] ?? [];

  /// Gets all skills across all branches.
  List<DemoSkill> get allSkills =>
      _skills.values.expand((skills) => skills).toList();

  /// Total number of skills.
  int get totalSkills => allSkills.length;

  // ---------------------------------------------------------------------------
  // Branch Selection
  // ---------------------------------------------------------------------------

  /// Selects a skill branch.
  void selectBranch(SkillBranch branch) {
    _selectedBranch.value = branch;
    _selectedSkill.value = null;
    update();
  }

  // ---------------------------------------------------------------------------
  // Skill Selection
  // ---------------------------------------------------------------------------

  /// Selects a skill to view details.
  void selectSkill(DemoSkill? skill) {
    _selectedSkill.value = skill;
    update();
  }

  // ---------------------------------------------------------------------------
  // Skill Unlocking
  // ---------------------------------------------------------------------------

  /// Checks if a skill can be unlocked.
  bool canUnlockSkill(DemoSkill skill) {
    if (skill.isUnlocked) return false;
    if (skillPoints < skill.cost) return false;

    // Check prerequisites
    if (skill.parentIds.isNotEmpty) {
      for (final parentId in skill.parentIds) {
        final parent = _findSkillById(parentId);
        if (parent == null || !parent.isUnlocked) {
          return false;
        }
      }
    }

    return true;
  }

  /// Unlocks a skill.
  bool unlockSkill(DemoSkill skill) {
    if (!canUnlockSkill(skill)) return false;

    skill.isUnlocked = true;
    _skillPoints.value -= skill.cost;
    _updateUnlockedCount();
    update();

    return true;
  }

  /// Finds a skill by ID across all branches.
  DemoSkill? _findSkillById(String id) {
    for (final skills in _skills.values) {
      for (final skill in skills) {
        if (skill.id == id) return skill;
      }
    }
    return null;
  }

  void _updateUnlockedCount() {
    _unlockedCount.value = allSkills.where((s) => s.isUnlocked).length;
  }

  // ---------------------------------------------------------------------------
  // Reset
  // ---------------------------------------------------------------------------

  /// Resets all skills and points.
  void resetSkills() {
    _skillPoints.value = 10;
    for (final skills in _skills.values) {
      for (final skill in skills) {
        // Only unlock starting skills
        skill.isUnlocked = skill.parentIds.isEmpty;
      }
    }
    _selectedSkill.value = null;
    _updateUnlockedCount();
    update();
  }

  // ---------------------------------------------------------------------------
  // Add Points (for demo)
  // ---------------------------------------------------------------------------

  /// Adds skill points (for demo purposes).
  void addPoints(int amount) {
    _skillPoints.value += amount;
    update();
  }

  // ---------------------------------------------------------------------------
  // Status Helpers
  // ---------------------------------------------------------------------------

  /// Gets the unlock status text for a skill.
  String getSkillStatus(DemoSkill skill) {
    if (skill.isUnlocked) return 'UNLOCKED';
    if (canUnlockSkill(skill)) return 'AVAILABLE';
    return 'LOCKED';
  }

  /// Gets the color for a skill based on its status.
  ///
  /// Accepts theme parameters for theme-aware colors.
  Color getSkillColor(
    DemoSkill skill,
    ColorScheme colorScheme,
    FiftyThemeExtension? fiftyTheme,
  ) {
    if (skill.isUnlocked) {
      return fiftyTheme?.success ?? colorScheme.tertiary;
    }
    if (canUnlockSkill(skill)) {
      return colorScheme.primary;
    }
    return colorScheme.onSurfaceVariant;
  }
}
