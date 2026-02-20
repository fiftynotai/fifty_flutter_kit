/// Service locator for dependency injection.
///
/// Provides centralized access to services throughout the example app.
/// Uses GetIt for service location pattern.
library;

import 'package:get_it/get_it.dart';

import '../../features/narrative_demo/actions/narrative_demo_actions.dart';
import '../../features/narrative_demo/service/narrative_service.dart';
import '../../features/narrative_demo/viewmodel/narrative_demo_viewmodel.dart';

/// Global service locator instance.
final GetIt serviceLocator = GetIt.instance;

/// Initializes all services and dependencies.
///
/// Must be called before running the app.
Future<void> setupServiceLocator() async {
  // Register NarrativeService as singleton
  serviceLocator.registerLazySingleton<NarrativeService>(
    () => NarrativeService(),
  );

  // Register ViewModel factory
  serviceLocator.registerFactory<NarrativeDemoViewModel>(
    () => NarrativeDemoViewModel(
      sentencesService: serviceLocator<NarrativeService>(),
    ),
  );

  // Register Actions factory
  serviceLocator.registerFactory<NarrativeDemoActions>(
    () => NarrativeDemoActions(
      sentencesService: serviceLocator<NarrativeService>(),
    ),
  );
}

/// Resets the service locator (useful for testing).
Future<void> resetServiceLocator() async {
  await serviceLocator.reset();
}
