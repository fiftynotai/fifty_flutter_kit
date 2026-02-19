/// Packages Actions
///
/// Handles user interactions for the packages hub feature.
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../../achievement_demo/views/achievement_demo_page.dart';
import '../../audio_demo/views/audio_demo_page.dart';
import '../../forms_demo/views/forms_demo_page.dart';
import '../../map_demo/views/map_demo_page.dart';
import '../../printing_demo/views/printing_demo_page.dart';
import '../../sentences_demo/views/sentences_demo_page.dart';
import '../../skill_tree_demo/views/skill_tree_demo_page.dart';
import '../../speech_demo/views/speech_demo_page.dart';
import '../controllers/packages_view_model.dart';

/// Actions for the packages hub feature.
///
/// Provides navigation to individual package demos.
class PackagesActions {
  /// Creates packages actions with required dependencies.
  PackagesActions(this._viewModel, this._presenter);

  final PackagesViewModel _viewModel;
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static PackagesActions get instance => Get.find<PackagesActions>();

  /// Gets the view model for accessing package data.
  PackagesViewModel get viewModel => _viewModel;

  // ---------------------------------------------------------------------------
  // Navigation Actions
  // ---------------------------------------------------------------------------

  /// Called when a package demo card is tapped.
  ///
  /// [context] - The build context for showing snackbars.
  /// [packageId] - The unique identifier of the package demo.
  void onPackageTapped(BuildContext context, String packageId) {
    final package = PackagesViewModel.allPackages.firstWhereOrNull(
      (p) => p.id == packageId,
    );

    if (package == null) return;

    if (!package.isAvailable) {
      _presenter.showErrorSnackBar(
        context,
        'Coming Soon',
        '${package.name} demo is not yet available.',
      );
      return;
    }

    // Navigate to the appropriate demo based on package ID
    switch (packageId) {
      case 'fifty_world_engine':
        Get.to<void>(() => const MapDemoPage());
        break;
      case 'fifty_audio_engine':
        Get.to<void>(() => const AudioDemoPage());
        break;
      case 'fifty_speech_engine':
        Get.to<void>(() => const SpeechDemoPage());
        break;
      case 'fifty_sentences_engine':
        Get.to<void>(() => const SentencesDemoPage());
        break;
      case 'fifty_printing_engine':
        Get.to<void>(() => const PrintingDemoPage());
        break;
      case 'fifty_skill_tree':
        Get.to<void>(() => const SkillTreeDemoPage());
        break;
      case 'fifty_achievement_engine':
        Get.to<void>(() => const AchievementDemoPage());
        break;
      case 'fifty_forms':
        Get.to<void>(() => const FormsDemoPage());
        break;
      case 'fifty_ui':
      case 'fifty_tokens':
      case 'fifty_theme':
        _presenter.showSuccessSnackBar(
          context,
          'UI Kit',
          'View ${package.name} components in the UI Kit tab.',
        );
        break;
      default:
        _presenter.showSuccessSnackBar(
          context,
          'Package Demo',
          'Opening ${package.name} demo...',
        );
    }
  }
}
