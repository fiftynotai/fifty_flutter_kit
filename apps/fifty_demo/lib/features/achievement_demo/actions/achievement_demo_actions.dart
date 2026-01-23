/// Achievement Demo Actions
///
/// Handles user interactions for the achievement demo feature.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../controllers/achievement_demo_view_model.dart';

/// Actions for the achievement demo feature.
///
/// Provides event triggering and achievement actions.
class AchievementDemoActions {
  /// Creates achievement demo actions with required dependencies.
  AchievementDemoActions(this._viewModel, this._presenter);

  final AchievementDemoViewModel _viewModel;
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static AchievementDemoActions get instance =>
      Get.find<AchievementDemoActions>();

  // ---------------------------------------------------------------------------
  // Event Actions
  // ---------------------------------------------------------------------------

  /// Called when a game event button is tapped.
  void onEventTapped(BuildContext context, GameEvent event, {int amount = 1}) {
    final unlocked = _viewModel.triggerEvent(event, amount: amount);

    if (unlocked.isNotEmpty) {
      for (final achievement in unlocked) {
        _presenter.showSuccessSnackBar(
          context,
          'Achievement Unlocked!',
          '${achievement.name} - ${achievement.rarity.label}',
        );
      }
    }
  }

  /// Called when the unlock popup is dismissed.
  void onDismissUnlock() {
    _viewModel.clearRecentUnlock();
  }

  // ---------------------------------------------------------------------------
  // Reset Actions
  // ---------------------------------------------------------------------------

  /// Called when reset button is tapped.
  void onResetTapped(BuildContext context) {
    _viewModel.resetAll();
    _presenter.showSuccessSnackBar(
      context,
      'Reset Complete',
      'All achievements have been reset.',
    );
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  /// Goes back to previous screen.
  void onBackTapped() {
    _presenter.back();
  }
}
