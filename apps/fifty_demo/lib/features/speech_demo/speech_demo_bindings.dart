/// Speech Demo Bindings
///
/// Registers Speech Demo feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import '../../shared/services/speech_integration_service.dart';
import 'actions/speech_demo_actions.dart';
import 'controllers/speech_demo_view_model.dart';

/// Registers Speech Demo feature dependencies.
///
/// **Registered Dependencies**:
/// - [SpeechIntegrationService] - Speech engine wrapper (TTS/STT)
/// - [SpeechDemoViewModel] - Business logic for speech demo
/// - [SpeechDemoActions] - Action handlers for speech demo
class SpeechDemoBindings implements Bindings {
  @override
  void dependencies() {
    // 1. Register Service (if not already registered)
    if (!Get.isRegistered<SpeechIntegrationService>()) {
      Get.put<SpeechIntegrationService>(
        SpeechIntegrationService(),
        permanent: true,
      );
    }

    // 2. Register ViewModel (depends on Service)
    if (!Get.isRegistered<SpeechDemoViewModel>()) {
      Get.put<SpeechDemoViewModel>(
        SpeechDemoViewModel(
          speechService: Get.find<SpeechIntegrationService>(),
        ),
        permanent: true,
      );
    }

    // 3. Register Actions (depends on ViewModel)
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
    if (Get.isRegistered<SpeechIntegrationService>()) {
      Get.delete<SpeechIntegrationService>(force: true);
    }
  }
}
