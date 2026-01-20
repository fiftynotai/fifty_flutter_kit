import 'package:flutter/foundation.dart';

import '../conditions/conditions.dart';

/// Serializable snapshot of achievement system progress.
///
/// Contains all data needed to save and restore achievement state,
/// including unlocks, claims, and tracking context.
///
/// **Example:**
/// ```dart
/// // Save progress
/// final progressData = ProgressData.fromController(controller);
/// final json = progressData.toJson();
/// await saveToFile(jsonEncode(json));
///
/// // Load progress
/// final savedJson = await loadFromFile();
/// final data = ProgressData.fromJson(jsonDecode(savedJson));
/// controller.importProgress(data.toJson());
/// ```
@immutable
class ProgressData {
  /// Creates a progress data instance.
  const ProgressData({
    required this.version,
    required this.unlockedIds,
    required this.claimedIds,
    required this.unlockTimes,
    required this.context,
    required this.exportedAt,
  });

  /// Creates progress data from raw JSON export.
  factory ProgressData.fromJson(Map<String, dynamic> json) {
    return ProgressData(
      version: json['version'] as String? ?? '1.0.0',
      unlockedIds:
          (json['unlocked'] as List<dynamic>?)?.cast<String>().toSet() ??
              const {},
      claimedIds:
          (json['claimed'] as List<dynamic>?)?.cast<String>().toSet() ??
              const {},
      unlockTimes:
          (json['unlockTimes'] as Map<String, dynamic>?)?.map(
                (k, v) => MapEntry(k, DateTime.parse(v as String)),
              ) ??
              const {},
      context: json['context'] != null
          ? AchievementContext.fromJson(json['context'] as Map<String, dynamic>)
          : const AchievementContext(),
      exportedAt: json['exportedAt'] != null
          ? DateTime.parse(json['exportedAt'] as String)
          : DateTime.now(),
    );
  }

  /// Schema version for compatibility.
  final String version;

  /// IDs of unlocked achievements.
  final Set<String> unlockedIds;

  /// IDs of claimed achievements.
  final Set<String> claimedIds;

  /// Timestamps when achievements were unlocked.
  final Map<String, DateTime> unlockTimes;

  /// The tracking context (events, stats, etc.).
  final AchievementContext context;

  /// When this progress was exported.
  final DateTime exportedAt;

  /// Number of achievements unlocked.
  int get unlockedCount => unlockedIds.length;

  /// Number of achievements claimed.
  int get claimedCount => claimedIds.length;

  /// Creates a summary of this progress data.
  ProgressSummary get summary => ProgressSummary(
        unlockedCount: unlockedCount,
        claimedCount: claimedCount,
        eventCount: context.eventCounts.length,
        statCount: context.stats.length,
        exportedAt: exportedAt,
      );

  /// Converts this progress data to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'unlocked': unlockedIds.toList(),
      'claimed': claimedIds.toList(),
      'unlockTimes': unlockTimes.map(
        (k, v) => MapEntry(k, v.toIso8601String()),
      ),
      'context': context.toJson(),
      'exportedAt': exportedAt.toIso8601String(),
    };
  }

  /// Creates a copy with the given fields replaced.
  ProgressData copyWith({
    String? version,
    Set<String>? unlockedIds,
    Set<String>? claimedIds,
    Map<String, DateTime>? unlockTimes,
    AchievementContext? context,
    DateTime? exportedAt,
  }) {
    return ProgressData(
      version: version ?? this.version,
      unlockedIds: unlockedIds ?? this.unlockedIds,
      claimedIds: claimedIds ?? this.claimedIds,
      unlockTimes: unlockTimes ?? this.unlockTimes,
      context: context ?? this.context,
      exportedAt: exportedAt ?? this.exportedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProgressData) return false;
    return version == other.version &&
        setEquals(unlockedIds, other.unlockedIds) &&
        setEquals(claimedIds, other.claimedIds);
  }

  @override
  int get hashCode => Object.hash(version, unlockedIds, claimedIds);

  @override
  String toString() {
    return 'ProgressData(v$version, ${unlockedIds.length} unlocked, ${claimedIds.length} claimed)';
  }
}

/// A lightweight summary of progress data.
@immutable
class ProgressSummary {
  /// Creates a progress summary.
  const ProgressSummary({
    required this.unlockedCount,
    required this.claimedCount,
    required this.eventCount,
    required this.statCount,
    required this.exportedAt,
  });

  /// Number of achievements unlocked.
  final int unlockedCount;

  /// Number of achievements claimed.
  final int claimedCount;

  /// Number of tracked event types.
  final int eventCount;

  /// Number of tracked stats.
  final int statCount;

  /// When the progress was exported.
  final DateTime exportedAt;

  @override
  String toString() {
    return 'ProgressSummary($unlockedCount unlocked, $claimedCount claimed)';
  }
}
