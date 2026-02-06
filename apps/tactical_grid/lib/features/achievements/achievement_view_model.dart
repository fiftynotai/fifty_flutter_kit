/// Achievement ViewModel
///
/// GetxController wrapping [AchievementController] from the achievement engine.
/// Registered as an app-wide singleton so achievement state persists across
/// route changes within the same session.
library;

import 'package:fifty_achievement_engine/fifty_achievement_engine.dart';
import 'package:get/get.dart';

import 'achievement_definitions.dart';

/// Reactive wrapper around [AchievementController] for GetX integration.
///
/// Exposes the engine's controller and provides reactive state via [update].
class AchievementViewModel extends GetxController {
  /// The underlying achievement engine controller.
  late final AchievementController<void> engine;

  @override
  void onInit() {
    super.onInit();
    engine = AchievementController<void>(
      achievements: tacticalGridAchievements,
      onUnlock: _onAchievementUnlocked,
    );
  }

  /// Tracks a game event (delegates to engine).
  void trackEvent(String event, {int count = 1}) {
    engine.trackEvent(event, count: count);
    update();
  }

  /// Updates a stat value (delegates to engine).
  void updateStat(String stat, num value) {
    engine.updateStat(stat, value);
    update();
  }

  /// Increments a stat (delegates to engine).
  void incrementStat(String stat, num delta) {
    engine.incrementStat(stat, delta);
    update();
  }

  /// Returns progress for an achievement (0.0-1.0).
  double getProgress(String achievementId) => engine.getProgress(achievementId);

  /// Whether an achievement is unlocked.
  bool isUnlocked(String achievementId) => engine.isUnlocked(achievementId);

  /// Callback invoked by the engine when an achievement unlocks.
  ///
  /// Sets [lastUnlocked] so the UI layer can show a popup.
  final Rx<Achievement<void>?> lastUnlocked = Rx<Achievement<void>?>(null);

  void _onAchievementUnlocked(Achievement<void> achievement) {
    lastUnlocked.value = achievement;
  }

  /// Clears the last unlocked achievement (after popup is shown).
  void clearLastUnlocked() {
    lastUnlocked.value = null;
  }

  @override
  void onClose() {
    engine.dispose();
    super.onClose();
  }
}
