/// Utils Demo Actions
///
/// Handles user interactions for the utils demo feature.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../controllers/utils_demo_view_model.dart';

/// Actions for the utils demo feature.
///
/// Provides API state cycling and reset actions.
class UtilsDemoActions {
  /// Creates utils demo actions with required dependencies.
  UtilsDemoActions(this._viewModel, this._presenter);

  final UtilsDemoViewModel _viewModel;
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static UtilsDemoActions get instance => Get.find<UtilsDemoActions>();

  // ---------------------------------------------------------------------------
  // Api State Actions
  // ---------------------------------------------------------------------------

  /// Called when the cycle API states button is tapped.
  Future<void> onCycleApiStatesTapped(BuildContext context) async {
    await _viewModel.cycleApiStates();

    if (!context.mounted) return;

    _presenter.showSuccessSnackBar(
      context,
      'Cycle Complete',
      'API state machine cycle finished.',
    );
  }

  /// Called when the reset button is tapped.
  void onResetApiStateTapped() {
    _viewModel.resetApiState();
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  /// Goes back to previous screen.
  void onBackTapped() {
    _presenter.back();
  }
}
