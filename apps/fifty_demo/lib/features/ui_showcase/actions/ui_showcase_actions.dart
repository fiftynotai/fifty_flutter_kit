/// UI Showcase Actions
///
/// Handles user interactions for the UI showcase feature.
library;

// ignore: unused_import - required for BuildContext type even if not currently used
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../controllers/ui_showcase_view_model.dart';

/// Actions for the UI showcase feature.
///
/// Provides component interaction actions.
class UiShowcaseActions {
  UiShowcaseActions(this._viewModel, this._presenter);

  final UiShowcaseViewModel _viewModel;
  // ignore: unused_field - kept for future async methods
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static UiShowcaseActions get instance => Get.find<UiShowcaseActions>();

  /// Called when a button is pressed (for demo).
  void onButtonPressed() {
    _viewModel.toggleButtonLoading();
  }

  /// Called when input changes.
  void onInputChanged(String value) {
    _viewModel.setInputValue(value);
  }

  /// Called when switch is toggled.
  void onSwitchToggled() {
    _viewModel.toggleSwitch();
  }

  /// Called when slider changes.
  void onSliderChanged(double value) {
    _viewModel.setSliderValue(value);
  }

  /// Called when tab is selected.
  void onTabSelected(int index) {
    _viewModel.setTabIndex(index);
  }

  /// Called when snackbar is triggered.
  void onShowSnackbar() {
    _viewModel.triggerSnackbar();
  }
}
