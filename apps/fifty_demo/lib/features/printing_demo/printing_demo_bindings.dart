/// Printing Demo Bindings
///
/// Registers Printing Demo feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import 'actions/printing_demo_actions.dart';
import 'controllers/printing_demo_view_model.dart';

/// Registers Printing Demo feature dependencies.
///
/// **Registered Dependencies**:
/// - [PrintingDemoViewModel] - Business logic for printing demo
/// - [PrintingDemoActions] - Action handlers for printing demo
class PrintingDemoBindings implements Bindings {
  @override
  void dependencies() {
    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<PrintingDemoViewModel>()) {
      Get.put<PrintingDemoViewModel>(
        PrintingDemoViewModel(),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<PrintingDemoActions>()) {
      Get.lazyPut<PrintingDemoActions>(
        () => PrintingDemoActions(
          Get.find<PrintingDemoViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<PrintingDemoActions>()) {
      Get.delete<PrintingDemoActions>(force: true);
    }
    if (Get.isRegistered<PrintingDemoViewModel>()) {
      Get.delete<PrintingDemoViewModel>(force: true);
    }
  }
}
