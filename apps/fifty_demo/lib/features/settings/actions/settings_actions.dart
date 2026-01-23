/// Settings Actions
///
/// Handles user interactions for the settings feature.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../controllers/settings_view_model.dart';

/// Actions for the settings feature.
///
/// Provides theme switching and external link handling.
class SettingsActions {
  /// Creates settings actions with required dependencies.
  SettingsActions(this._viewModel, this._presenter);

  final SettingsViewModel _viewModel;
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static SettingsActions get instance => Get.find<SettingsActions>();

  // ---------------------------------------------------------------------------
  // Theme Actions
  // ---------------------------------------------------------------------------

  /// Changes the app theme mode.
  ///
  /// [context] - The build context for showing snackbars.
  /// [mode] - The theme mode to apply.
  void onThemeChanged(BuildContext context, AppThemeMode mode) {
    _viewModel.themeMode = mode;

    // Note: Full theme switching will be implemented in Phase 2
    // when fifty_theme integration is complete
    _presenter.showSuccessSnackBar(
      context,
      'Theme Changed',
      'Switched to ${mode.name} mode',
    );
  }

  // ---------------------------------------------------------------------------
  // External Link Actions
  // ---------------------------------------------------------------------------

  /// Opens the documentation URL.
  Future<void> onOpenDocs(BuildContext context) async {
    await _launchUrl(SettingsViewModel.docsUrl, context);
  }

  /// Opens the repository URL.
  Future<void> onOpenRepository(BuildContext context) async {
    await _launchUrl(SettingsViewModel.repositoryUrl, context);
  }

  /// Opens a URL in the external browser.
  Future<void> _launchUrl(String url, BuildContext context) async {
    final uri = Uri.parse(url);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        _presenter.showErrorSnackBar(
          context,
          'Error',
          'Could not open $url',
        );
      }
    } catch (e) {
      _presenter.showErrorSnackBar(
        context,
        'Error',
        'Failed to open link: $e',
      );
    }
  }

  // ---------------------------------------------------------------------------
  // Debug Actions
  // ---------------------------------------------------------------------------

  /// Toggles debug mode.
  void onToggleDebugMode() {
    _viewModel.toggleDebugMode();
  }
}
