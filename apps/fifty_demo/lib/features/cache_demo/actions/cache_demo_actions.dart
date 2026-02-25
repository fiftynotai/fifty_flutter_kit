/// Cache Demo Actions
///
/// Handles user interactions for the cache demo feature.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../controllers/cache_demo_view_model.dart';

/// Actions for the cache demo feature.
///
/// Provides fetch, clear, and endpoint selection actions.
class CacheDemoActions {
  /// Creates cache demo actions with required dependencies.
  CacheDemoActions(this._viewModel, this._presenter);

  final CacheDemoViewModel _viewModel;
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static CacheDemoActions get instance => Get.find<CacheDemoActions>();

  // ---------------------------------------------------------------------------
  // Cache Actions
  // ---------------------------------------------------------------------------

  /// Called when fetch button is tapped.
  Future<void> onFetchTapped(BuildContext context) async {
    await _viewModel.fetchData();

    if (!context.mounted) return;

    if (_viewModel.wasCacheHit) {
      _presenter.showSuccessSnackBar(
        context,
        'Cache Hit',
        'Response served from cache.',
      );
    }
  }

  /// Called when clear cache button is tapped.
  Future<void> onClearCacheTapped(BuildContext context) async {
    await _viewModel.clearCache();

    if (!context.mounted) return;

    _presenter.showSuccessSnackBar(
      context,
      'Cache Cleared',
      'All cached entries have been removed.',
    );
  }

  /// Called when an endpoint chip is tapped.
  void onEndpointSelected(int index) {
    _viewModel.selectEndpoint(index);
  }

  // ---------------------------------------------------------------------------
  // Navigation
  // ---------------------------------------------------------------------------

  /// Goes back to previous screen.
  void onBackTapped() {
    _presenter.back();
  }
}
