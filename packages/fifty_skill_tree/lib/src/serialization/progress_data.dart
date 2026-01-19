import 'package:flutter/foundation.dart';

/// Represents the progress state of a skill tree.
///
/// This class encapsulates all progress data for easy serialization
/// and persistence in save files or databases.
///
/// **Example:**
/// ```dart
/// // Create progress data
/// final progress = ProgressData(
///   unlockedNodes: {'fireball', 'ice_bolt'},
///   nodeLevels: {'fireball': 3, 'ice_bolt': 1},
///   availablePoints: 5,
///   spentPoints: 4,
/// );
///
/// // Serialize to JSON
/// final json = progress.toJson();
///
/// // Deserialize from JSON
/// final loaded = ProgressData.fromJson(json);
/// ```
@immutable
class ProgressData {
  /// Creates a progress data object.
  ///
  /// **Parameters:**
  /// - [unlockedNodes]: Set of node IDs that have been unlocked
  /// - [nodeLevels]: Map of node IDs to their current levels
  /// - [availablePoints]: Points available for spending
  /// - [spentPoints]: Total points spent across all nodes
  /// - [timestamp]: When this progress was saved (optional)
  /// - [metadata]: Additional custom metadata (optional)
  const ProgressData({
    required this.unlockedNodes,
    required this.nodeLevels,
    required this.availablePoints,
    required this.spentPoints,
    this.timestamp,
    this.metadata,
  });

  /// Set of node IDs that have been unlocked (level > 0).
  final Set<String> unlockedNodes;

  /// Map of node IDs to their current levels.
  final Map<String, int> nodeLevels;

  /// Points available for spending.
  final int availablePoints;

  /// Total points spent across all nodes.
  final int spentPoints;

  /// When this progress was saved.
  final DateTime? timestamp;

  /// Additional custom metadata.
  final Map<String, dynamic>? metadata;

  /// Total points (available + spent).
  int get totalPoints => availablePoints + spentPoints;

  /// Number of unlocked nodes.
  int get unlockedCount => unlockedNodes.length;

  /// Creates an empty progress data object.
  factory ProgressData.empty() {
    return const ProgressData(
      unlockedNodes: {},
      nodeLevels: {},
      availablePoints: 0,
      spentPoints: 0,
    );
  }

  /// Creates progress data from a skill tree's export.
  ///
  /// This is a convenience factory for converting the format
  /// returned by [SkillTree.exportProgress].
  factory ProgressData.fromTreeExport(Map<String, dynamic> export) {
    final nodesMap = export['nodes'] as Map<String, dynamic>? ?? {};

    final unlockedNodes = <String>{};
    final nodeLevels = <String, int>{};

    for (final entry in nodesMap.entries) {
      final level = entry.value as int;
      if (level > 0) {
        unlockedNodes.add(entry.key);
        nodeLevels[entry.key] = level;
      }
    }

    // Calculate spent points from levels (assuming cost of 1 per level)
    // This is an approximation; actual costs depend on node configuration
    int spentPoints = 0;
    for (final level in nodeLevels.values) {
      spentPoints += level;
    }

    return ProgressData(
      unlockedNodes: unlockedNodes,
      nodeLevels: nodeLevels,
      availablePoints: export['availablePoints'] as int? ?? 0,
      spentPoints: spentPoints,
      timestamp: DateTime.now(),
    );
  }

  /// Converts this progress data to a JSON map.
  ///
  /// **Returns:**
  /// A map suitable for JSON serialization.
  Map<String, dynamic> toJson() {
    return {
      'unlockedNodes': unlockedNodes.toList(),
      'nodeLevels': nodeLevels,
      'availablePoints': availablePoints,
      'spentPoints': spentPoints,
      if (timestamp != null) 'timestamp': timestamp!.toIso8601String(),
      if (metadata != null) 'metadata': metadata,
    };
  }

  /// Creates progress data from a JSON map.
  ///
  /// **Parameters:**
  /// - [json]: The JSON map to deserialize
  ///
  /// **Returns:**
  /// A new [ProgressData] instance.
  factory ProgressData.fromJson(Map<String, dynamic> json) {
    final unlockedNodesList = json['unlockedNodes'] as List<dynamic>? ?? [];
    final nodeLevelsMap = json['nodeLevels'] as Map<String, dynamic>? ?? {};

    DateTime? timestamp;
    if (json['timestamp'] != null) {
      timestamp = DateTime.tryParse(json['timestamp'] as String);
    }

    return ProgressData(
      unlockedNodes: unlockedNodesList.cast<String>().toSet(),
      nodeLevels: nodeLevelsMap.map((k, v) => MapEntry(k, v as int)),
      availablePoints: json['availablePoints'] as int? ?? 0,
      spentPoints: json['spentPoints'] as int? ?? 0,
      timestamp: timestamp,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Converts to the format expected by [SkillTree.importProgress].
  ///
  /// **Returns:**
  /// A map in the tree import format.
  Map<String, dynamic> toTreeImport() {
    return {
      'availablePoints': availablePoints,
      'nodes': nodeLevels,
    };
  }

  /// Creates a copy with the given fields replaced.
  ProgressData copyWith({
    Set<String>? unlockedNodes,
    Map<String, int>? nodeLevels,
    int? availablePoints,
    int? spentPoints,
    DateTime? timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return ProgressData(
      unlockedNodes: unlockedNodes ?? this.unlockedNodes,
      nodeLevels: nodeLevels ?? this.nodeLevels,
      availablePoints: availablePoints ?? this.availablePoints,
      spentPoints: spentPoints ?? this.spentPoints,
      timestamp: timestamp ?? this.timestamp,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Merges this progress with another, keeping the higher values.
  ///
  /// Useful for syncing progress from multiple sources.
  ProgressData merge(ProgressData other) {
    final mergedLevels = <String, int>{};

    // Merge node levels, keeping higher values
    for (final entry in nodeLevels.entries) {
      mergedLevels[entry.key] = entry.value;
    }
    for (final entry in other.nodeLevels.entries) {
      final existing = mergedLevels[entry.key] ?? 0;
      if (entry.value > existing) {
        mergedLevels[entry.key] = entry.value;
      }
    }

    // Derive unlocked nodes from merged levels
    final mergedUnlocked = mergedLevels.entries
        .where((e) => e.value > 0)
        .map((e) => e.key)
        .toSet();

    // Calculate new spent points
    int mergedSpent = 0;
    for (final level in mergedLevels.values) {
      mergedSpent += level;
    }

    return ProgressData(
      unlockedNodes: mergedUnlocked,
      nodeLevels: mergedLevels,
      availablePoints: availablePoints > other.availablePoints
          ? availablePoints
          : other.availablePoints,
      spentPoints: mergedSpent,
      timestamp: DateTime.now(),
      metadata: {
        ...?metadata,
        ...?other.metadata,
      },
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProgressData) return false;

    return setEquals(unlockedNodes, other.unlockedNodes) &&
        mapEquals(nodeLevels, other.nodeLevels) &&
        availablePoints == other.availablePoints &&
        spentPoints == other.spentPoints;
  }

  @override
  int get hashCode {
    return Object.hash(
      Object.hashAllUnordered(unlockedNodes),
      Object.hashAllUnordered(nodeLevels.entries),
      availablePoints,
      spentPoints,
    );
  }

  @override
  String toString() {
    return 'ProgressData(unlocked: ${unlockedNodes.length}, '
        'available: $availablePoints, spent: $spentPoints)';
  }
}
