/// Service locator for dependency injection.
///
/// Provides centralized access to services throughout the example app.
/// Uses GetIt for service location pattern.
library;

import 'package:get_it/get_it.dart';

import '../../features/map_demo/actions/map_actions.dart';
import '../../features/map_demo/service/map_service.dart';
import '../../features/map_demo/viewmodel/map_viewmodel.dart';

/// Global service locator instance.
final GetIt serviceLocator = GetIt.instance;

/// Initializes all services and dependencies.
///
/// Must be called before running the app.
Future<void> setupServiceLocator() async {
  // Register MapService as singleton
  serviceLocator.registerLazySingleton<MapService>(
    () => MapService(),
  );

  // Register ViewModel factory
  serviceLocator.registerFactory<MapViewModel>(
    () => MapViewModel(
      mapService: serviceLocator<MapService>(),
    ),
  );

  // Register Actions factory
  serviceLocator.registerFactory<MapActions>(
    () => MapActions(
      mapService: serviceLocator<MapService>(),
    ),
  );
}

/// Resets the service locator (useful for testing).
Future<void> resetServiceLocator() async {
  await serviceLocator.reset();
}
