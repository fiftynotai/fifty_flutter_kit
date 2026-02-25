/// Utils Demo Bindings
///
/// Registers Utils Demo feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import 'actions/utils_demo_actions.dart';
import 'controllers/utils_demo_view_model.dart';

/// Registers Utils Demo feature dependencies.
///
/// **Registered Dependencies**:
/// - [UtilsDemoViewModel] - Business logic for utils demo
/// - [UtilsDemoActions] - Action handlers for utils demo
class UtilsDemoBindings implements Bindings {
  @override
  void dependencies() {
    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<UtilsDemoViewModel>()) {
      Get.put<UtilsDemoViewModel>(
        UtilsDemoViewModel(),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<UtilsDemoActions>()) {
      Get.lazyPut<UtilsDemoActions>(
        () => UtilsDemoActions(
          Get.find<UtilsDemoViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<UtilsDemoActions>()) {
      Get.delete<UtilsDemoActions>(force: true);
    }
    if (Get.isRegistered<UtilsDemoViewModel>()) {
      Get.delete<UtilsDemoViewModel>(force: true);
    }
  }
}
