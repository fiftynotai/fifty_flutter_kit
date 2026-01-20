import 'package:flutter/foundation.dart';

import '../conditions/conditions.dart';
import '../models/models.dart';

/// Controller for managing achievements, tracking progress, and handling unlocks.
///
/// The controller handles:
/// - Achievement registration and management
/// - Event and stat tracking
/// - Progress calculation
/// - Unlock detection and callbacks
/// - Progress serialization/deserialization
///
/// **Example:**
/// ```dart
/// // Create controller with achievements
/// final controller = AchievementController<RewardData>(
///   achievements: [
///     Achievement(
///       id: 'first_kill',
///       name: 'First Blood',
///       condition: EventCondition('enemy_killed'),
///     ),
///     Achievement(
///       id: 'kill_100',
///       name: 'Century',
///       condition: CountCondition('enemy_killed', target: 100),
///     ),
///   ],
///   onUnlock: (achievement) {
///     showUnlockNotification(achievement);
///   },
/// );
///
/// // Track events
/// controller.trackEvent('enemy_killed');
///
/// // Update stats
/// controller.updateStat('player_level', 50);
/// ```
class AchievementController<T> extends ChangeNotifier {
  /// Creates an achievement controller.
  ///
  /// [achievements] is the initial list of achievements.
  /// [onUnlock] is called when an achievement is unlocked.
  /// [sessionStart] sets the session start time for time-based achievements.
  AchievementController({
    List<Achievement<T>> achievements = const [],
    this.onUnlock,
    DateTime? sessionStart,
  })  : _achievements = List.from(achievements),
        _context = AchievementContext(
          sessionStart: sessionStart ?? DateTime.now(),
        );

  // ---- State ----

  final List<Achievement<T>> _achievements;
  AchievementContext _context;
  final Set<String> _unlocked = {};
  final Set<String> _claimed = {};
  final Map<String, DateTime> _unlockTimes = {};

  /// Callback invoked when an achievement is unlocked.
  ValueChanged<Achievement<T>>? onUnlock;

  // ---- Getters ----

  /// All registered achievements.
  List<Achievement<T>> get achievements => List.unmodifiable(_achievements);

  /// The current tracking context.
  AchievementContext get context => _context;

  /// IDs of all unlocked achievements.
  Set<String> get unlockedIds => Set.unmodifiable(_unlocked);

  /// IDs of all claimed achievements.
  Set<String> get claimedIds => Set.unmodifiable(_claimed);

  /// All unlocked achievements.
  List<Achievement<T>> get unlockedAchievements =>
      _achievements.where((a) => _unlocked.contains(a.id)).toList();

  /// All locked achievements (including unavailable).
  List<Achievement<T>> get lockedAchievements =>
      _achievements.where((a) => !_unlocked.contains(a.id)).toList();

  /// All available achievements (can be worked towards).
  List<Achievement<T>> get availableAchievements =>
      _achievements.where((a) => getState(a.id) == AchievementState.available).toList();

  /// Total points from all achievements.
  int get totalPoints =>
      _achievements.fold(0, (sum, a) => sum + a.points);

  /// Points earned from unlocked achievements.
  int get earnedPoints => _achievements
      .where((a) => _unlocked.contains(a.id))
      .fold(0, (sum, a) => sum + a.points);

  /// Completion percentage (0.0 to 1.0).
  double get completionPercentage {
    if (_achievements.isEmpty) return 0.0;
    return _unlocked.length / _achievements.length;
  }

  // ---- Event Tracking ----

  /// Tracks an event occurrence.
  ///
  /// This increments the event count and adds to the event sequence.
  /// Automatically checks for achievement unlocks.
  ///
  /// [event] is the event name to track.
  /// [count] is the number of occurrences (default: 1).
  void trackEvent(String event, {int count = 1}) {
    _context = _context.withEvent(event, count: count);
    _checkUnlocks();
    notifyListeners();
  }

  /// Clears the count for a specific event.
  ///
  /// Does not remove from event sequence.
  void clearEvent(String event) {
    final newCounts = Map<String, int>.from(_context.eventCounts);
    newCounts.remove(event);
    _context = _context.copyWith(eventCounts: newCounts);
    notifyListeners();
  }

  /// Clears all tracked events.
  void clearAllEvents() {
    _context = _context.copyWith(
      eventCounts: const {},
      eventSequence: const [],
    );
    notifyListeners();
  }

  // ---- Stat Tracking ----

  /// Updates a stat to a specific value.
  ///
  /// Automatically checks for achievement unlocks.
  void updateStat(String stat, num value) {
    _context = _context.withStat(stat, value);
    _checkUnlocks();
    notifyListeners();
  }

  /// Increments a stat by a delta value.
  ///
  /// Automatically checks for achievement unlocks.
  void incrementStat(String stat, num delta) {
    _context = _context.withStatIncrement(stat, delta);
    _checkUnlocks();
    notifyListeners();
  }

  /// Gets the current value of a stat.
  num getStat(String stat) => _context.getStat(stat);

  /// Clears a specific stat.
  void clearStat(String stat) {
    final newStats = Map<String, num>.from(_context.stats);
    newStats.remove(stat);
    _context = _context.copyWith(stats: newStats);
    notifyListeners();
  }

  /// Clears all tracked stats.
  void clearAllStats() {
    _context = _context.copyWith(stats: const {});
    notifyListeners();
  }

  // ---- Progress ----

  /// Gets the progress (0.0 to 1.0) for an achievement.
  ///
  /// Returns 1.0 for unlocked achievements.
  /// Returns 0.0 for locked achievements (prerequisites not met).
  double getProgress(String achievementId) {
    final achievement = getAchievement(achievementId);
    if (achievement == null) return 0.0;

    final state = getState(achievementId);
    if (state.isComplete) return 1.0;
    if (state == AchievementState.locked) return 0.0;

    return achievement.condition.getProgress(_context);
  }

  /// Gets detailed progress information for an achievement.
  AchievementProgress getProgressDetails(String achievementId) {
    final achievement = getAchievement(achievementId);
    if (achievement == null) {
      return AchievementProgress.locked(achievementId);
    }

    final state = getState(achievementId);
    final condition = achievement.condition;

    return AchievementProgress(
      achievementId: achievementId,
      state: state,
      current: condition.getCurrent(_context) ?? 0,
      target: condition.target ?? 1,
      unlockedAt: _unlockTimes[achievementId],
    );
  }

  // ---- State ----

  /// Checks if an achievement is unlocked.
  bool isUnlocked(String achievementId) => _unlocked.contains(achievementId);

  /// Checks if an achievement is claimed.
  bool isClaimed(String achievementId) => _claimed.contains(achievementId);

  /// Gets the current state of an achievement.
  AchievementState getState(String achievementId) {
    if (_claimed.contains(achievementId)) {
      return AchievementState.claimed;
    }
    if (_unlocked.contains(achievementId)) {
      return AchievementState.unlocked;
    }

    final achievement = getAchievement(achievementId);
    if (achievement == null) {
      return AchievementState.locked;
    }

    // Check prerequisites
    for (final prereqId in achievement.prerequisites) {
      if (!_unlocked.contains(prereqId)) {
        return AchievementState.locked;
      }
    }

    return AchievementState.available;
  }

  /// Gets an achievement by ID.
  Achievement<T>? getAchievement(String id) {
    try {
      return _achievements.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Gets achievements by category.
  List<Achievement<T>> getByCategory(String category) {
    return _achievements.where((a) => a.category == category).toList();
  }

  /// Gets achievements by rarity.
  List<Achievement<T>> getByRarity(AchievementRarity rarity) {
    return _achievements.where((a) => a.rarity == rarity).toList();
  }

  /// Gets achievements by state.
  List<Achievement<T>> getByState(AchievementState state) {
    return _achievements.where((a) => getState(a.id) == state).toList();
  }

  /// Gets all unique categories.
  List<String> get categories {
    final cats = <String>{};
    for (final a in _achievements) {
      if (a.category != null) cats.add(a.category!);
    }
    return cats.toList()..sort();
  }

  // ---- Management ----

  /// Adds an achievement to the system.
  void addAchievement(Achievement<T> achievement) {
    if (_achievements.any((a) => a.id == achievement.id)) {
      throw ArgumentError('Achievement with id ${achievement.id} already exists');
    }
    _achievements.add(achievement);
    notifyListeners();
  }

  /// Adds multiple achievements to the system.
  void addAchievements(List<Achievement<T>> achievements) {
    for (final achievement in achievements) {
      if (_achievements.any((a) => a.id == achievement.id)) {
        throw ArgumentError('Achievement with id ${achievement.id} already exists');
      }
    }
    _achievements.addAll(achievements);
    notifyListeners();
  }

  /// Removes an achievement from the system.
  void removeAchievement(String id) {
    _achievements.removeWhere((a) => a.id == id);
    _unlocked.remove(id);
    _claimed.remove(id);
    _unlockTimes.remove(id);
    notifyListeners();
  }

  /// Manually unlocks an achievement (bypasses condition check).
  ///
  /// Returns true if the achievement was unlocked, false if already unlocked.
  bool forceUnlock(String achievementId) {
    if (_unlocked.contains(achievementId)) return false;

    final achievement = getAchievement(achievementId);
    if (achievement == null) return false;

    _unlocked.add(achievementId);
    _unlockTimes[achievementId] = DateTime.now();
    onUnlock?.call(achievement);
    notifyListeners();
    return true;
  }

  /// Claims an achievement (marks as claimed after viewing/collecting reward).
  ///
  /// Returns true if claimed, false if not unlocked or already claimed.
  bool claim(String achievementId) {
    if (!_unlocked.contains(achievementId)) return false;
    if (_claimed.contains(achievementId)) return false;

    _claimed.add(achievementId);
    notifyListeners();
    return true;
  }

  /// Resets all progress (unlocks, claims, events, stats).
  void reset() {
    _unlocked.clear();
    _claimed.clear();
    _unlockTimes.clear();
    _context = AchievementContext(sessionStart: DateTime.now());
    notifyListeners();
  }

  /// Resets only tracking data (events and stats), keeps unlocks.
  void resetTracking() {
    _context = AchievementContext(sessionStart: DateTime.now());
    notifyListeners();
  }

  /// Starts a new session (resets session start time).
  void startSession() {
    _context = _context.copyWith(
      sessionStart: DateTime.now(),
      eventSequence: const [],
    );
    notifyListeners();
  }

  // ---- Serialization ----

  /// Exports all progress data for saving.
  ///
  /// Includes unlocked achievements, claimed achievements, and tracking context.
  Map<String, dynamic> exportProgress() {
    return {
      'version': '1.0.0',
      'unlocked': _unlocked.toList(),
      'claimed': _claimed.toList(),
      'unlockTimes': _unlockTimes.map(
        (k, v) => MapEntry(k, v.toIso8601String()),
      ),
      'context': _context.toJson(),
      'exportedAt': DateTime.now().toIso8601String(),
    };
  }

  /// Imports progress data from a saved state.
  void importProgress(Map<String, dynamic> data) {
    _unlocked.clear();
    _claimed.clear();
    _unlockTimes.clear();

    final unlockedList = (data['unlocked'] as List<dynamic>?)?.cast<String>();
    if (unlockedList != null) {
      _unlocked.addAll(unlockedList);
    }

    final claimedList = (data['claimed'] as List<dynamic>?)?.cast<String>();
    if (claimedList != null) {
      _claimed.addAll(claimedList);
    }

    final unlockTimesMap = data['unlockTimes'] as Map<String, dynamic>?;
    if (unlockTimesMap != null) {
      _unlockTimes.addAll(unlockTimesMap.map(
        (k, v) => MapEntry(k, DateTime.parse(v as String)),
      ));
    }

    final contextJson = data['context'] as Map<String, dynamic>?;
    if (contextJson != null) {
      _context = AchievementContext.fromJson(contextJson);
    }

    notifyListeners();
  }

  // ---- Private ----

  /// Checks all achievements for unlocks.
  void _checkUnlocks() {
    for (final achievement in _achievements) {
      if (_unlocked.contains(achievement.id)) continue;

      final state = getState(achievement.id);
      if (state != AchievementState.available) continue;

      if (achievement.condition.evaluate(_context)) {
        _unlocked.add(achievement.id);
        _unlockTimes[achievement.id] = DateTime.now();
        onUnlock?.call(achievement);
      }
    }
  }
}
