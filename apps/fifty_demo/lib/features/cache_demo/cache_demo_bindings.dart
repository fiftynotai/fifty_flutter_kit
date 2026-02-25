/// Cache Demo Bindings
///
/// Registers Cache Demo feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import 'actions/cache_demo_actions.dart';
import 'controllers/cache_demo_view_model.dart';

/// Registers Cache Demo feature dependencies.
///
/// **Registered Dependencies**:
/// - [CacheDemoViewModel] - Business logic for cache demo
/// - [CacheDemoActions] - Action handlers for cache demo
class CacheDemoBindings implements Bindings {
  @override
  void dependencies() {
    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<CacheDemoViewModel>()) {
      Get.put<CacheDemoViewModel>(
        CacheDemoViewModel(),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<CacheDemoActions>()) {
      Get.lazyPut<CacheDemoActions>(
        () => CacheDemoActions(
          Get.find<CacheDemoViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<CacheDemoActions>()) {
      Get.delete<CacheDemoActions>(force: true);
    }
    if (Get.isRegistered<CacheDemoViewModel>()) {
      Get.delete<CacheDemoViewModel>(force: true);
    }
  }
}
