/// Dialogue Demo Bindings
///
/// Registers Dialogue Demo feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import 'actions/dialogue_demo_actions.dart';
import 'service/dialogue_orchestrator.dart';
import 'viewmodel/dialogue_demo_viewmodel.dart';

/// **DialogueDemoBindings**
///
/// Registers Dialogue Demo feature dependencies.
///
/// **Registered Dependencies**:
/// - `DialogueDemoViewModel` - Business logic for dialogue demo feature
/// - `DialogueDemoActions` - Action handlers for dialogue demo feature
class DialogueDemoBindings implements Bindings {
  @override
  void dependencies() {
    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<DialogueDemoViewModel>()) {
      Get.put<DialogueDemoViewModel>(
        DialogueDemoViewModel(
          orchestrator: Get.find<DialogueOrchestrator>(),
        ),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<DialogueDemoActions>()) {
      Get.lazyPut<DialogueDemoActions>(
        () => DialogueDemoActions(
          Get.find<DialogueDemoViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<DialogueDemoActions>()) {
      Get.delete<DialogueDemoActions>(force: true);
    }
    if (Get.isRegistered<DialogueDemoViewModel>()) {
      Get.delete<DialogueDemoViewModel>(force: true);
    }
  }
}
