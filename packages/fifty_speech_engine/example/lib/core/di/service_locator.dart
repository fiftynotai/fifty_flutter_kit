/// Service locator for dependency injection.
///
/// Provides centralized access to services throughout the example app.
/// Uses GetIt for service location pattern.
library;

import 'package:get_it/get_it.dart';

import '../../features/speech_demo/actions/speech_demo_actions.dart';
import '../../features/speech_demo/service/speech_service.dart';
import '../../features/speech_demo/viewmodel/speech_demo_viewmodel.dart';

/// Global service locator instance.
final GetIt serviceLocator = GetIt.instance;

/// Initializes all services and dependencies.
///
/// Must be called before running the app.
Future<void> setupServiceLocator() async {
  // Register SpeechService as singleton
  serviceLocator.registerLazySingleton<SpeechService>(
    () => SpeechService(),
  );

  // Register ViewModel factory
  serviceLocator.registerFactory<SpeechDemoViewModel>(
    () => SpeechDemoViewModel(
      speechService: serviceLocator<SpeechService>(),
    ),
  );

  // Register Actions factory
  serviceLocator.registerFactory<SpeechDemoActions>(
    () => SpeechDemoActions(
      speechService: serviceLocator<SpeechService>(),
    ),
  );
}

/// Resets the service locator (useful for testing).
Future<void> resetServiceLocator() async {
  await serviceLocator.reset();
}
