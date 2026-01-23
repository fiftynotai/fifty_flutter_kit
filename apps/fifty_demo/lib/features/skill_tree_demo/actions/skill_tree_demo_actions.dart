/// Skill Tree Demo Actions
///
/// Handles user interactions for the skill tree demo feature.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../controllers/skill_tree_demo_view_model.dart';

/// Actions for the skill tree demo feature.
///
/// Provides skill tree interaction actions.
class SkillTreeDemoActions {
  /// Creates skill tree demo actions with required dependencies.
  SkillTreeDemoActions(this._viewModel, this._presenter);

  final SkillTreeDemoViewModel _viewModel;
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static SkillTreeDemoActions get instance => Get.find<SkillTreeDemoActions>();

  // ---------------------------------------------------------------------------
  // Branch Actions
  // ---------------------------------------------------------------------------

  /// Called when a branch tab is selected.
  void onBranchSelected(SkillBranch branch) {
    _viewModel.selectBranch(branch);
  }

  // ---------------------------------------------------------------------------
  // Skill Actions
  // ---------------------------------------------------------------------------

  /// Called when a skill node is tapped.
  void onSkillTapped(DemoSkill skill) {
    _viewModel.selectSkill(skill);
  }

  /// Called when unlock skill button is tapped.
  void onUnlockSkillTapped(BuildContext context, DemoSkill skill) {
    if (_viewModel.unlockSkill(skill)) {
      _presenter.showSuccessSnackBar(
        context,
        'Skill Unlocked',
        '${skill.name} has been unlocked!',
      );
    } else {
      _presenter.showErrorSnackBar(
        context,
        'Cannot Unlock',
        'Requirements not met for ${skill.name}',
      );
    }
  }

  /// Called when reset button is tapped.
  void onResetTapped(BuildContext context) {
    _viewModel.resetSkills();
    _presenter.showSuccessSnackBar(
      context,
      'Skills Reset',
      'All skills have been reset.',
    );
  }

  /// Called when add points button is tapped (demo only).
  void onAddPointsTapped(BuildContext context) {
    _viewModel.addPoints(5);
    _presenter.showSuccessSnackBar(
      context,
      'Points Added',
      'You received 5 skill points!',
    );
  }

  /// Clears the selected skill.
  void onClearSelection() {
    _viewModel.selectSkill(null);
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  /// Goes back to previous screen.
  void onBackTapped() {
    _presenter.back();
  }
}
