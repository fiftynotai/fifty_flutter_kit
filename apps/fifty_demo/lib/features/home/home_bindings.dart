/// Home Bindings
///
/// Registers Home feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import '../../shared/services/audio_integration_service.dart';
import '../../shared/services/map_integration_service.dart';
import '../../shared/services/narrative_integration_service.dart';
import '../../shared/services/speech_integration_service.dart';
import 'actions/home_actions.dart';
import 'controllers/home_view_model.dart';

/// **HomeBindings**
///
/// Registers Home feature dependencies.
///
/// **Registered Dependencies**:
/// - `HomeViewModel` - Business logic for home feature
/// - `HomeActions` - Action handlers for home feature
class HomeBindings implements Bindings {
  @override
  void dependencies() {
    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<HomeViewModel>()) {
      Get.put<HomeViewModel>(
        HomeViewModel(
          audioService: Get.find<AudioIntegrationService>(),
          speechService: Get.find<SpeechIntegrationService>(),
          sentencesService: Get.find<NarrativeIntegrationService>(),
          mapService: Get.find<MapIntegrationService>(),
        ),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<HomeActions>()) {
      Get.lazyPut<HomeActions>(
        () => HomeActions(
          Get.find<HomeViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<HomeActions>()) {
      Get.delete<HomeActions>(force: true);
    }
    if (Get.isRegistered<HomeViewModel>()) {
      Get.delete<HomeViewModel>(force: true);
    }
  }
}
