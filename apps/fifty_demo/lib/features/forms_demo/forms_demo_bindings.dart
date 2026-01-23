/// Forms Demo Bindings
///
/// Registers Forms Demo feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import 'actions/forms_demo_actions.dart';
import 'controllers/forms_demo_view_model.dart';

/// Registers Forms Demo feature dependencies.
///
/// **Registered Dependencies**:
/// - [FormsDemoViewModel] - Business logic for forms demo
/// - [FormsDemoActions] - Action handlers for forms demo
class FormsDemoBindings implements Bindings {
  @override
  void dependencies() {
    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<FormsDemoViewModel>()) {
      Get.put<FormsDemoViewModel>(
        FormsDemoViewModel(),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<FormsDemoActions>()) {
      Get.lazyPut<FormsDemoActions>(
        () => FormsDemoActions(
          Get.find<FormsDemoViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<FormsDemoActions>()) {
      Get.delete<FormsDemoActions>(force: true);
    }
    if (Get.isRegistered<FormsDemoViewModel>()) {
      Get.delete<FormsDemoViewModel>(force: true);
    }
  }
}
