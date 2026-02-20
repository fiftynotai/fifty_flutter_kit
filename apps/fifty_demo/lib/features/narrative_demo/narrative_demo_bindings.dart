/// Sentences Demo Bindings
///
/// Registers Sentences Demo feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import '../../shared/services/speech_integration_service.dart';
import 'actions/narrative_demo_actions.dart';
import 'controllers/narrative_demo_view_model.dart';

/// Registers Sentences Demo feature dependencies.
///
/// **Registered Dependencies**:
/// - [NarrativeDemoViewModel] - Business logic for sentences demo
/// - [NarrativeDemoActions] - Action handlers for sentences demo
class NarrativeDemoBindings implements Bindings {
  @override
  void dependencies() {
    // Get speech service if available (for TTS in read mode)
    SpeechIntegrationService? speechService;
    if (Get.isRegistered<SpeechIntegrationService>()) {
      speechService = Get.find<SpeechIntegrationService>();
    }

    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<NarrativeDemoViewModel>()) {
      Get.put<NarrativeDemoViewModel>(
        NarrativeDemoViewModel(speechService: speechService),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<NarrativeDemoActions>()) {
      Get.lazyPut<NarrativeDemoActions>(
        () => NarrativeDemoActions(
          Get.find<NarrativeDemoViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<NarrativeDemoActions>()) {
      Get.delete<NarrativeDemoActions>(force: true);
    }
    if (Get.isRegistered<NarrativeDemoViewModel>()) {
      Get.delete<NarrativeDemoViewModel>(force: true);
    }
  }
}
