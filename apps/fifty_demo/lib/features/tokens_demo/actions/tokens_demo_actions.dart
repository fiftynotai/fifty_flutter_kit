/// Tokens Demo Actions
///
/// Handles user interactions for the tokens demo feature.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../controllers/tokens_demo_view_model.dart';

/// Actions for the tokens demo feature.
///
/// Provides palette switching and reset functionality.
class TokensDemoActions {
  /// Creates tokens demo actions with required dependencies.
  TokensDemoActions(this._viewModel, this._presenter);

  final TokensDemoViewModel _viewModel;
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static TokensDemoActions get instance => Get.find<TokensDemoActions>();

  // ---------------------------------------------------------------------------
  // Palette Actions
  // ---------------------------------------------------------------------------

  /// Applies the Baltic Blue preset and rebuilds the theme.
  void onApplyBalticBlue(BuildContext context) {
    FiftyTokens.load(FiftyPreset.balticBlue);
    _viewModel.setBalticBlue(active: true);
    Get.forceAppUpdate();

    if (context.mounted) {
      _presenter.showSuccessSnackBar(
        context,
        'Palette Applied',
        'Baltic Blue palette is now active.',
      );
    }
  }

  /// Resets to the default FDL v2 preset and rebuilds the theme.
  void onResetToFdl(BuildContext context) {
    FiftyTokens.load(FiftyPreset.fdlV2);
    _viewModel.setBalticBlue(active: false);
    Get.forceAppUpdate();

    if (context.mounted) {
      _presenter.showSuccessSnackBar(
        context,
        'Palette Reset',
        'FDL v2 palette restored.',
      );
    }
  }
}
