/// Initial Bindings
///
/// Registers core app-wide dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../features/dialogue_demo/service/dialogue_orchestrator.dart';
import '../../features/map_demo/service/map_audio_coordinator.dart';
import '../../shared/services/audio_integration_service.dart';
import '../../shared/services/map_integration_service.dart';
import '../../shared/services/sentences_integration_service.dart';
import '../../shared/services/speech_integration_service.dart';

/// **InitialBindings**
///
/// Registers core app-wide dependencies using GetX dependency injection.
///
/// **Features**:
/// - Lazy loading for performance optimization
/// - Permanent registration for global dependencies
/// - Initialization order management
///
/// **Usage**:
/// ```dart
/// GetMaterialApp(
///   initialBinding: InitialBindings(),
///   // ...
/// )
/// ```
///
/// **Registered Dependencies**:
/// - Integration Services (Audio, Speech, Sentences, Map)
/// - Feature Services (MapAudioCoordinator, DialogueOrchestrator)
///
/// **Notes**:
/// - Feature bindings are registered when features are accessed
/// - Dependencies are registered in specific order to handle inter-dependencies
class InitialBindings extends Bindings {
  @override
  void dependencies() {
    // ═══════════════════════════════════════════════════════════════════════════
    // Integration Services (Wrap Fifty Engines)
    // ═══════════════════════════════════════════════════════════════════════════

    Get.lazyPut<AudioIntegrationService>(
      AudioIntegrationService.new,
      fenix: true,
    );

    Get.lazyPut<SpeechIntegrationService>(
      SpeechIntegrationService.new,
      fenix: true,
    );

    Get.lazyPut<SentencesIntegrationService>(
      SentencesIntegrationService.new,
      fenix: true,
    );

    Get.lazyPut<MapIntegrationService>(
      MapIntegrationService.new,
      fenix: true,
    );

    // ═══════════════════════════════════════════════════════════════════════════
    // Feature Services
    // ═══════════════════════════════════════════════════════════════════════════

    Get.lazyPut<MapAudioCoordinator>(
      () => MapAudioCoordinator(
        mapService: Get.find<MapIntegrationService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<DialogueOrchestrator>(
      () => DialogueOrchestrator(
        speechService: Get.find<SpeechIntegrationService>(),
        sentencesService: Get.find<SentencesIntegrationService>(),
      ),
      fenix: true,
    );
  }
}
