/// Home Actions
///
/// Handles user interactions for the home feature.
library;

import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../viewmodel/home_viewmodel.dart';

/// Actions for the home feature.
///
/// Provides navigation and initialization actions.
class HomeActions {
  HomeActions(this._viewModel, this._presenter);

  final HomeViewModel _viewModel;
  // ignore: unused_field - kept for future use in error handling
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static HomeActions get instance => Get.find<HomeActions>();

  // ─────────────────────────────────────────────────────────────────────────
  // Navigation Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Called when a feature card is tapped.
  void onFeatureTapped(String featureId) {
    // Navigation handled by parent
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Audio Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Plays a click sound effect.
  ///
  /// Note: SFX disabled - external URLs block hotlinking.
  /// To enable, add local audio files to assets/audio/sfx/.
  Future<void> onPlayClickSound() async {
    // SFX disabled - soundjay.com blocks hotlinking
    // To enable: add local asset and use audio service playSfx('assets/...')
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Initialization Actions
  // ─────────────────────────────────────────────────────────────────────────

  /// Initializes services if needed.
  Future<void> onInitializeServices() async {
    if (!_viewModel.servicesInitialized) {
      await _viewModel.initializeServices();
    }
  }
}
