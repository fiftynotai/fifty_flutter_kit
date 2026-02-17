/// Initial Bindings
///
/// Registers core app-wide dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../features/achievements/achievement_view_model.dart';
import '../../features/settings/controllers/settings_view_model.dart';
import '../../features/settings/data/services/settings_service.dart';

/// Registers core app-wide dependencies.
///
/// Feature bindings are registered when routes are accessed.
/// Dependencies are registered in order: Services -> ViewModels -> Actions.
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // App-wide services
    Get.put<AchievementViewModel>(AchievementViewModel(), permanent: true);

    // Settings (app-wide, permanent)
    Get.put<SettingsService>(SettingsService(), permanent: true);
    Get.put<SettingsViewModel>(
      SettingsViewModel(Get.find<SettingsService>()),
      permanent: true,
    );
  }
}
