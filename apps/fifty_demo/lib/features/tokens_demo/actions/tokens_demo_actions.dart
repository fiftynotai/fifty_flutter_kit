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

  /// The Baltic Blue color configuration.
  static final _balticBlueColors = FiftyPreset.fdlV2.colors.copyWith(
    primary: const Color(0xFF586994),
    primaryHover: const Color(0xFF47567A),
    secondary: const Color(0xFF7d869c),
    secondaryHover: const Color(0xFF656D80),
    success: const Color(0xFFb4c4ae),
    accent: const Color(0xFFa2abab),
    background: const Color(0xFFe5e8b6),
    backgroundDark: const Color(0xFF1A1D2B),
    surface: const Color(0xFFD5D8A8),
    surfaceDark: const Color(0xFF2A2D3B),
    onPrimary: const Color(0xFFe5e8b6),
    onBackground: const Color(0xFF1A1D2B),
  );

  // ---------------------------------------------------------------------------
  // Palette Actions
  // ---------------------------------------------------------------------------

  /// Applies the Baltic Blue palette and rebuilds the theme.
  void onApplyBalticBlue(BuildContext context) {
    FiftyTokens.configure(colors: _balticBlueColors);
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

  /// Resets to the default FDL v2 palette and rebuilds the theme.
  void onResetToFdl(BuildContext context) {
    FiftyTokens.reset();
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
