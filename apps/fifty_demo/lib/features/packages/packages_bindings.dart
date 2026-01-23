/// Packages Bindings
///
/// Registers Packages feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import 'actions/packages_actions.dart';
import 'controllers/packages_view_model.dart';

/// Registers Packages feature dependencies.
///
/// **Registered Dependencies**:
/// - [PackagesViewModel] - Business logic for packages hub
/// - [PackagesActions] - Action handlers for packages feature
class PackagesBindings implements Bindings {
  @override
  void dependencies() {
    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<PackagesViewModel>()) {
      Get.put<PackagesViewModel>(
        PackagesViewModel(),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<PackagesActions>()) {
      Get.lazyPut<PackagesActions>(
        () => PackagesActions(
          Get.find<PackagesViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<PackagesActions>()) {
      Get.delete<PackagesActions>(force: true);
    }
    if (Get.isRegistered<PackagesViewModel>()) {
      Get.delete<PackagesViewModel>(force: true);
    }
  }
}
