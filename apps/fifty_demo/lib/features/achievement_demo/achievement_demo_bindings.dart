/// Achievement Demo Bindings
///
/// Registers Achievement Demo feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import 'actions/achievement_demo_actions.dart';
import 'controllers/achievement_demo_view_model.dart';

/// Registers Achievement Demo feature dependencies.
///
/// **Registered Dependencies**:
/// - [AchievementDemoViewModel] - Business logic for achievement demo
/// - [AchievementDemoActions] - Action handlers for achievement demo
class AchievementDemoBindings implements Bindings {
  @override
  void dependencies() {
    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<AchievementDemoViewModel>()) {
      Get.put<AchievementDemoViewModel>(
        AchievementDemoViewModel(),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<AchievementDemoActions>()) {
      Get.lazyPut<AchievementDemoActions>(
        () => AchievementDemoActions(
          Get.find<AchievementDemoViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<AchievementDemoActions>()) {
      Get.delete<AchievementDemoActions>(force: true);
    }
    if (Get.isRegistered<AchievementDemoViewModel>()) {
      Get.delete<AchievementDemoViewModel>(force: true);
    }
  }
}
