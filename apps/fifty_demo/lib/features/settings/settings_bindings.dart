/// Settings Bindings
///
/// Registers Settings feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import 'actions/settings_actions.dart';
import 'controllers/settings_view_model.dart';
import 'data/services/theme_service.dart';

/// Registers Settings feature dependencies.
///
/// **Registered Dependencies**:
/// - [ThemeService] - Theme persistence service
/// - [SettingsViewModel] - Business logic for settings
/// - [SettingsActions] - Action handlers for settings
class SettingsBindings implements Bindings {
  @override
  void dependencies() {
    // Register ThemeService first (dependency of ViewModel)
    if (!Get.isRegistered<ThemeService>()) {
      Get.lazyPut<ThemeService>(
        ThemeService.new,
        fenix: true,
      );
    }

    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<SettingsViewModel>()) {
      Get.put<SettingsViewModel>(
        SettingsViewModel(Get.find<ThemeService>()),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<SettingsActions>()) {
      Get.lazyPut<SettingsActions>(
        () => SettingsActions(
          Get.find<SettingsViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<SettingsActions>()) {
      Get.delete<SettingsActions>(force: true);
    }
    if (Get.isRegistered<SettingsViewModel>()) {
      Get.delete<SettingsViewModel>(force: true);
    }
    if (Get.isRegistered<ThemeService>()) {
      Get.delete<ThemeService>(force: true);
    }
  }
}
