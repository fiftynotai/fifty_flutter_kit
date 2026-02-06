/// Achievement Actions
///
/// UX orchestration layer for achievement-related interactions.
/// Tracks battle events and shows unlock notifications.
library;

import 'package:flutter/material.dart';

import '../battle/models/models.dart';
import '../battle/services/audio_coordinator.dart';
import 'achievement_view_model.dart';
import 'views/widgets/achievement_unlock_overlay.dart';

/// Orchestrates achievement tracking and UI feedback.
class AchievementActions {
  final AchievementViewModel _viewModel;
  final BattleAudioCoordinator _audio;

  AchievementActions(this._viewModel, this._audio);

  /// Tracks a unit being defeated in combat.
  ///
  /// Fires `'unit_defeated'` event. If the defeated unit is a Commander,
  /// also fires `'commander_captured'`. If the attacker is a Knight,
  /// fires `'knight_kill'`.
  void trackUnitDefeated({
    required Unit attacker,
    required Unit target,
  }) {
    _viewModel.trackEvent('unit_defeated');

    if (target.type == UnitType.commander) {
      _viewModel.trackEvent('commander_captured');
    }

    if (attacker.type == UnitType.knight) {
      _viewModel.trackEvent('knight_kill');
    }
  }

  /// Tracks a shield blocking an attack (unit attacked but not defeated).
  void trackShieldBlock(Unit target) {
    if (target.type == UnitType.shield) {
      _viewModel.trackEvent('shield_block');
    }
  }

  /// Tracks a game victory with context events.
  void trackGameWon({
    required int turnNumber,
    required bool noUnitsLost,
  }) {
    _viewModel.trackEvent('game_won');

    if (noUnitsLost) {
      _viewModel.trackEvent('flawless_win');
    }

    if (turnNumber < 10) {
      _viewModel.trackEvent('blitz_win');
    }

    if (turnNumber >= 20) {
      _viewModel.trackEvent('long_win');
    }
  }

  /// Shows the unlock popup overlay if an achievement was just unlocked.
  void showUnlockPopupIfNeeded(BuildContext context) {
    final achievement = _viewModel.lastUnlocked.value;
    if (achievement == null) return;

    _audio.playAchievementSfx();
    _viewModel.clearLastUnlocked();

    AchievementUnlockOverlay.show(context, achievement);
  }
}
