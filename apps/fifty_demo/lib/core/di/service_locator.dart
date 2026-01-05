/// Service Locator for Dependency Injection
///
/// Provides centralized access to services throughout the demo app.
/// Uses GetIt for service location pattern.
library;

import 'package:get_it/get_it.dart';

import '../../features/dialogue_demo/actions/dialogue_demo_actions.dart';
import '../../features/dialogue_demo/service/dialogue_orchestrator.dart';
import '../../features/dialogue_demo/viewmodel/dialogue_demo_viewmodel.dart';
import '../../features/home/actions/home_actions.dart';
import '../../features/home/viewmodel/home_viewmodel.dart';
import '../../features/map_demo/actions/map_demo_actions.dart';
import '../../features/map_demo/service/map_audio_coordinator.dart';
import '../../features/map_demo/viewmodel/map_demo_viewmodel.dart';
import '../../features/ui_showcase/actions/ui_showcase_actions.dart';
import '../../features/ui_showcase/viewmodel/ui_showcase_viewmodel.dart';
import '../../shared/services/audio_integration_service.dart';
import '../../shared/services/map_integration_service.dart';
import '../../shared/services/sentences_integration_service.dart';
import '../../shared/services/speech_integration_service.dart';

/// Global service locator instance.
final GetIt serviceLocator = GetIt.instance;

/// Initializes all services and dependencies.
///
/// Must be called before running the app.
/// Registers services, viewmodels, and actions in dependency order.
Future<void> setupServiceLocator() async {
  // ─────────────────────────────────────────────────────────────────────────
  // Integration Services (Wrap Fifty Engines)
  // ─────────────────────────────────────────────────────────────────────────

  serviceLocator.registerLazySingleton<AudioIntegrationService>(
    AudioIntegrationService.new,
  );

  serviceLocator.registerLazySingleton<SpeechIntegrationService>(
    SpeechIntegrationService.new,
  );

  serviceLocator.registerLazySingleton<SentencesIntegrationService>(
    SentencesIntegrationService.new,
  );

  serviceLocator.registerLazySingleton<MapIntegrationService>(
    MapIntegrationService.new,
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Feature Services
  // ─────────────────────────────────────────────────────────────────────────

  serviceLocator.registerLazySingleton<MapAudioCoordinator>(
    () => MapAudioCoordinator(
      audioService: serviceLocator<AudioIntegrationService>(),
      mapService: serviceLocator<MapIntegrationService>(),
    ),
  );

  serviceLocator.registerLazySingleton<DialogueOrchestrator>(
    () => DialogueOrchestrator(
      speechService: serviceLocator<SpeechIntegrationService>(),
      sentencesService: serviceLocator<SentencesIntegrationService>(),
    ),
  );

  // ─────────────────────────────────────────────────────────────────────────
  // ViewModels
  // ─────────────────────────────────────────────────────────────────────────

  serviceLocator.registerFactory<HomeViewModel>(
    () => HomeViewModel(
      audioService: serviceLocator<AudioIntegrationService>(),
      speechService: serviceLocator<SpeechIntegrationService>(),
      sentencesService: serviceLocator<SentencesIntegrationService>(),
      mapService: serviceLocator<MapIntegrationService>(),
    ),
  );

  serviceLocator.registerFactory<MapDemoViewModel>(
    () => MapDemoViewModel(
      coordinator: serviceLocator<MapAudioCoordinator>(),
    ),
  );

  serviceLocator.registerFactory<DialogueDemoViewModel>(
    () => DialogueDemoViewModel(
      orchestrator: serviceLocator<DialogueOrchestrator>(),
    ),
  );

  serviceLocator.registerFactory<UiShowcaseViewModel>(
    UiShowcaseViewModel.new,
  );

  // ─────────────────────────────────────────────────────────────────────────
  // Actions
  // ─────────────────────────────────────────────────────────────────────────

  serviceLocator.registerFactory<HomeActions>(
    () => HomeActions(
      audioService: serviceLocator<AudioIntegrationService>(),
    ),
  );

  serviceLocator.registerFactory<MapDemoActions>(
    () => MapDemoActions(
      coordinator: serviceLocator<MapAudioCoordinator>(),
    ),
  );

  serviceLocator.registerFactory<DialogueDemoActions>(
    () => DialogueDemoActions(
      orchestrator: serviceLocator<DialogueOrchestrator>(),
    ),
  );

  serviceLocator.registerFactory<UiShowcaseActions>(
    UiShowcaseActions.new,
  );
}

/// Resets the service locator (useful for testing).
Future<void> resetServiceLocator() async {
  await serviceLocator.reset();
}
