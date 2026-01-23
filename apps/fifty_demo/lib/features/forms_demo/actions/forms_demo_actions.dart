/// Forms Demo Actions
///
/// Handles user interactions for the forms demo feature.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../controllers/forms_demo_view_model.dart';

/// Actions for the forms demo feature.
///
/// Provides form submission and reset actions.
class FormsDemoActions {
  /// Creates forms demo actions with required dependencies.
  FormsDemoActions(this._viewModel, this._presenter);

  final FormsDemoViewModel _viewModel;
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static FormsDemoActions get instance => Get.find<FormsDemoActions>();

  // ---------------------------------------------------------------------------
  // Form Actions
  // ---------------------------------------------------------------------------

  /// Called when submit button is tapped.
  Future<void> onSubmitTapped(BuildContext context) async {
    await _presenter.actionHandler(context, () async {
      final success = await _viewModel.submitForm();

      if (success) {
        _presenter.showSuccessSnackBar(
          context,
          'Success!',
          'Registration form submitted successfully.',
        );
      } else {
        _presenter.showErrorSnackBar(
          context,
          'Validation Error',
          'Please fix the errors in the form.',
        );
      }
    });
  }

  /// Called when reset button is tapped.
  void onResetTapped(BuildContext context) {
    _viewModel.resetForm();
    _presenter.showSuccessSnackBar(
      context,
      'Form Reset',
      'All fields have been cleared.',
    );
  }

  // ---------------------------------------------------------------------------
  // Field Actions
  // ---------------------------------------------------------------------------

  /// Called when password visibility toggle is tapped.
  void onTogglePasswordVisibility() {
    _viewModel.togglePasswordVisibility();
  }

  /// Called when confirm password visibility toggle is tapped.
  void onToggleConfirmPasswordVisibility() {
    _viewModel.toggleConfirmPasswordVisibility();
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  /// Goes back to previous screen.
  void onBackTapped() {
    _presenter.back();
  }
}
