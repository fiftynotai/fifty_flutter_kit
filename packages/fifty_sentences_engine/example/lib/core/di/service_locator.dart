/// Service locator for dependency injection.
///
/// Provides centralized access to services throughout the example app.
/// Uses GetIt for service location pattern.
library;

import 'package:get_it/get_it.dart';

import '../../features/sentences_demo/actions/sentences_demo_actions.dart';
import '../../features/sentences_demo/service/sentences_service.dart';
import '../../features/sentences_demo/viewmodel/sentences_demo_viewmodel.dart';

/// Global service locator instance.
final GetIt serviceLocator = GetIt.instance;

/// Initializes all services and dependencies.
///
/// Must be called before running the app.
Future<void> setupServiceLocator() async {
  // Register SentencesService as singleton
  serviceLocator.registerLazySingleton<SentencesService>(
    () => SentencesService(),
  );

  // Register ViewModel factory
  serviceLocator.registerFactory<SentencesDemoViewModel>(
    () => SentencesDemoViewModel(
      sentencesService: serviceLocator<SentencesService>(),
    ),
  );

  // Register Actions factory
  serviceLocator.registerFactory<SentencesDemoActions>(
    () => SentencesDemoActions(
      sentencesService: serviceLocator<SentencesService>(),
    ),
  );
}

/// Resets the service locator (useful for testing).
Future<void> resetServiceLocator() async {
  await serviceLocator.reset();
}
