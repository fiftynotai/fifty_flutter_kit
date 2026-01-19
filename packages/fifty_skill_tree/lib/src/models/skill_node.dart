import 'package:flutter/widgets.dart';

import 'skill_type.dart';

/// An immutable representation of a skill node in a skill tree.
///
/// Generic type [T] allows attaching custom data to nodes for
/// game-specific functionality (e.g., stat bonuses, ability data).
///
/// **Example:**
/// ```dart
/// final node = SkillNode<AbilityData>(
///   id: 'fireball',
///   name: 'Fireball',
///   description: 'Launches a ball of fire',
///   maxLevel: 5,
///   costs: [1, 1, 2, 2, 3],
///   data: AbilityData(damage: 50, cooldown: 2.0),
/// );
/// ```
@immutable
class SkillNode<T> {
  /// Creates a new skill node.
  ///
  /// [id] must be unique within the skill tree.
  /// [name] is the display name shown to users.
  SkillNode({
    required this.id,
    required this.name,
    this.description,
    this.icon,
    this.iconUrl,
    this.data,
    this.currentLevel = 0,
    this.maxLevel = 1,
    this.costs = const [1],
    this.prerequisites = const [],
    this.type = SkillType.passive,
    this.branch,
    this.tier = 0,
    this.position,
  }) : assert(maxLevel >= 1, 'maxLevel must be at least 1'),
       assert(currentLevel >= 0, 'currentLevel cannot be negative'),
       assert(currentLevel <= maxLevel, 'currentLevel cannot exceed maxLevel'),
       assert(costs.isNotEmpty, 'costs list cannot be empty');

  /// Unique identifier for this node within the tree.
  final String id;

  /// Display name for the skill.
  final String name;

  /// Optional detailed description of the skill's effects.
  final String? description;

  /// Icon to display for this skill (Flutter IconData).
  final IconData? icon;

  /// URL for a custom icon image.
  ///
  /// Takes precedence over [icon] if both are provided.
  final String? iconUrl;

  /// Generic custom data attachment for game-specific info.
  ///
  /// Use this to store ability stats, modifiers, or any other
  /// data your game needs associated with the skill.
  final T? data;

  /// Current level of investment in this skill (0 = not unlocked).
  final int currentLevel;

  /// Maximum level this skill can reach.
  final int maxLevel;

  /// Cost in points for each level.
  ///
  /// If the list is shorter than [maxLevel], the last value is
  /// used for remaining levels.
  final List<int> costs;

  /// List of node IDs that must be unlocked before this node.
  final List<String> prerequisites;

  /// The type of skill (affects visuals and potentially gameplay).
  final SkillType type;

  /// Optional branch/path name for grouping nodes.
  final String? branch;

  /// Tier/row in the skill tree (0 = root level).
  final int tier;

  /// Custom position for manual layouts.
  ///
  /// If null, the layout algorithm determines position.
  final Offset? position;

  /// Returns the cost to unlock the next level.
  ///
  /// Returns 0 if already maxed.
  int get nextCost {
    if (isMaxed) return 0;
    if (currentLevel >= costs.length) {
      return costs.last;
    }
    return costs[currentLevel];
  }

  /// Whether this skill is at maximum level.
  bool get isMaxed => currentLevel >= maxLevel;

  /// Whether this skill has been unlocked (has at least one level).
  bool get isUnlocked => currentLevel > 0;

  /// Total points spent on this skill across all levels.
  int get totalSpent {
    if (currentLevel == 0) return 0;
    int total = 0;
    for (int i = 0; i < currentLevel; i++) {
      if (i < costs.length) {
        total += costs[i];
      } else {
        total += costs.last;
      }
    }
    return total;
  }

  /// Creates a copy of this node with the given fields replaced.
  SkillNode<T> copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    String? iconUrl,
    T? data,
    int? currentLevel,
    int? maxLevel,
    List<int>? costs,
    List<String>? prerequisites,
    SkillType? type,
    String? branch,
    int? tier,
    Offset? position,
  }) {
    return SkillNode<T>(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      iconUrl: iconUrl ?? this.iconUrl,
      data: data ?? this.data,
      currentLevel: currentLevel ?? this.currentLevel,
      maxLevel: maxLevel ?? this.maxLevel,
      costs: costs ?? this.costs,
      prerequisites: prerequisites ?? this.prerequisites,
      type: type ?? this.type,
      branch: branch ?? this.branch,
      tier: tier ?? this.tier,
      position: position ?? this.position,
    );
  }

  /// Converts this node to a JSON map.
  ///
  /// Note: [icon], [iconUrl], [data], and [position] are not serialized.
  /// Override or extend for custom serialization needs.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      'currentLevel': currentLevel,
      'maxLevel': maxLevel,
      'costs': costs,
      'prerequisites': prerequisites,
      'type': type.name,
      if (branch != null) 'branch': branch,
      'tier': tier,
      if (position != null)
        'position': {'dx': position!.dx, 'dy': position!.dy},
    };
  }

  /// Creates a skill node from a JSON map.
  ///
  /// Generic [data] must be provided separately if needed.
  factory SkillNode.fromJson(Map<String, dynamic> json) {
    Offset? position;
    if (json['position'] != null) {
      final pos = json['position'] as Map<String, dynamic>;
      position = Offset(
        (pos['dx'] as num).toDouble(),
        (pos['dy'] as num).toDouble(),
      );
    }

    return SkillNode<T>(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      currentLevel: json['currentLevel'] as int? ?? 0,
      maxLevel: json['maxLevel'] as int? ?? 1,
      costs:
          (json['costs'] as List<dynamic>?)?.cast<int>() ?? const [1],
      prerequisites:
          (json['prerequisites'] as List<dynamic>?)?.cast<String>() ??
          const [],
      type: SkillType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => SkillType.passive,
      ),
      branch: json['branch'] as String?,
      tier: json['tier'] as int? ?? 0,
      position: position,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SkillNode<T>) return false;
    return id == other.id &&
        name == other.name &&
        description == other.description &&
        currentLevel == other.currentLevel &&
        maxLevel == other.maxLevel &&
        type == other.type &&
        branch == other.branch &&
        tier == other.tier;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      description,
      currentLevel,
      maxLevel,
      type,
      branch,
      tier,
    );
  }

  @override
  String toString() {
    return 'SkillNode(id: $id, name: $name, level: $currentLevel/$maxLevel)';
  }
}
