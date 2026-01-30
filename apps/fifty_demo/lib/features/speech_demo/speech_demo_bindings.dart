/// Speech Demo Bindings
///
/// Registers Speech Demo feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import 'actions/speech_demo_actions.dart';
import 'controllers/speech_demo_view_model.dart';

/// Registers Speech Demo feature dependencies.
///
/// **Registered Dependencies**:
/// - [SpeechDemoViewModel] - Business logic for speech demo
/// - [SpeechDemoActions] - Action handlers for speech demo
class SpeechDemoBindings implements Bindings {
  @override
  void dependencies() {
    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<SpeechDemoViewModel>()) {
      Get.put<SpeechDemoViewModel>(
        SpeechDemoViewModel(),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<SpeechDemoActions>()) {
      Get.lazyPut<SpeechDemoActions>(
        () => SpeechDemoActions(
          Get.find<SpeechDemoViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<SpeechDemoActions>()) {
      Get.delete<SpeechDemoActions>(force: true);
    }
    if (Get.isRegistered<SpeechDemoViewModel>()) {
      Get.delete<SpeechDemoViewModel>(force: true);
    }
  }
}
