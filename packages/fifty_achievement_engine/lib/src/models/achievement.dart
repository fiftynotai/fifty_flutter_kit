import 'package:flutter/widgets.dart';

import '../conditions/conditions.dart';
import 'achievement_rarity.dart';

/// An immutable representation of an achievement.
///
/// Generic type [T] allows attaching custom data to achievements for
/// game-specific functionality (e.g., rewards, unlock effects).
///
/// **Example:**
/// ```dart
/// final achievement = Achievement<RewardData>(
///   id: 'first_kill',
///   name: 'First Blood',
///   description: 'Defeat your first enemy',
///   rarity: AchievementRarity.common,
///   points: 10,
///   condition: EventCondition('enemy_killed'),
///   data: RewardData(gold: 100),
/// );
/// ```
@immutable
class Achievement<T> {
  /// Creates a new achievement.
  ///
  /// [id] must be unique within the achievement system.
  /// [name] is the display name shown to users.
  /// [condition] defines when this achievement is unlocked.
  const Achievement({
    required this.id,
    required this.name,
    required this.condition,
    this.description,
    this.icon,
    this.iconUrl,
    this.rarity = AchievementRarity.common,
    this.points = 10,
    this.hidden = false,
    this.category,
    this.prerequisites = const [],
    this.data,
  });

  /// Unique identifier for this achievement.
  final String id;

  /// Display name for the achievement.
  final String name;

  /// Detailed description of how to earn this achievement.
  final String? description;

  /// Icon to display for this achievement (Flutter IconData).
  final IconData? icon;

  /// URL for a custom icon image.
  ///
  /// Takes precedence over [icon] if both are provided.
  final String? iconUrl;

  /// Rarity tier affecting visual presentation.
  final AchievementRarity rarity;

  /// Points awarded when this achievement is unlocked.
  final int points;

  /// Whether this achievement is hidden until unlocked.
  ///
  /// Hidden achievements don't show details until earned,
  /// typically used for surprises or spoiler-sensitive content.
  final bool hidden;

  /// Optional category for grouping achievements.
  ///
  /// Examples: 'Combat', 'Exploration', 'Social', 'Completionist'
  final String? category;

  /// The condition that must be met to unlock this achievement.
  final AchievementCondition condition;

  /// IDs of achievements that must be unlocked first.
  ///
  /// This achievement will be in [locked] state until all
  /// prerequisites are unlocked.
  final List<String> prerequisites;

  /// Generic custom data attachment for game-specific info.
  ///
  /// Use this to store rewards, unlock effects, or any other
  /// data your game needs associated with the achievement.
  final T? data;

  /// Creates a copy of this achievement with the given fields replaced.
  Achievement<T> copyWith({
    String? id,
    String? name,
    String? description,
    IconData? icon,
    String? iconUrl,
    AchievementRarity? rarity,
    int? points,
    bool? hidden,
    String? category,
    AchievementCondition? condition,
    List<String>? prerequisites,
    T? data,
  }) {
    return Achievement<T>(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      iconUrl: iconUrl ?? this.iconUrl,
      rarity: rarity ?? this.rarity,
      points: points ?? this.points,
      hidden: hidden ?? this.hidden,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      prerequisites: prerequisites ?? this.prerequisites,
      data: data ?? this.data,
    );
  }

  /// Converts this achievement to a JSON map.
  ///
  /// Note: [icon], [iconUrl], and [data] are not serialized.
  /// Override or extend for custom serialization needs.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      if (description != null) 'description': description,
      'rarity': rarity.name,
      'points': points,
      'hidden': hidden,
      if (category != null) 'category': category,
      'condition': condition.toJson(),
      'prerequisites': prerequisites,
    };
  }

  /// Creates an achievement from a JSON map.
  ///
  /// Generic [data] must be provided separately if needed.
  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement<T>(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      rarity: AchievementRarity.values.firstWhere(
        (r) => r.name == json['rarity'],
        orElse: () => AchievementRarity.common,
      ),
      points: json['points'] as int? ?? 10,
      hidden: json['hidden'] as bool? ?? false,
      category: json['category'] as String?,
      condition: AchievementCondition.fromJson(
        json['condition'] as Map<String, dynamic>,
      ),
      prerequisites:
          (json['prerequisites'] as List<dynamic>?)?.cast<String>() ??
              const [],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! Achievement<T>) return false;
    return id == other.id &&
        name == other.name &&
        rarity == other.rarity &&
        points == other.points &&
        hidden == other.hidden &&
        category == other.category;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, rarity, points, hidden, category);
  }

  @override
  String toString() {
    return 'Achievement(id: $id, name: $name, rarity: ${rarity.name})';
  }
}
