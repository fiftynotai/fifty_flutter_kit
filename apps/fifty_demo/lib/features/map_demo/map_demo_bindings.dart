/// Map Demo Bindings
///
/// Registers Map Demo feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import '../map_demo/service/map_audio_coordinator.dart';
import 'actions/map_demo_actions.dart';
import 'viewmodel/map_demo_viewmodel.dart';

/// **MapDemoBindings**
///
/// Registers Map Demo feature dependencies.
///
/// **Registered Dependencies**:
/// - `MapDemoViewModel` - Business logic for map demo feature
/// - `MapDemoActions` - Action handlers for map demo feature
class MapDemoBindings implements Bindings {
  @override
  void dependencies() {
    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<MapDemoViewModel>()) {
      Get.put<MapDemoViewModel>(
        MapDemoViewModel(
          coordinator: Get.find<MapAudioCoordinator>(),
        ),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<MapDemoActions>()) {
      Get.lazyPut<MapDemoActions>(
        () => MapDemoActions(
          Get.find<MapDemoViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<MapDemoActions>()) {
      Get.delete<MapDemoActions>(force: true);
    }
    if (Get.isRegistered<MapDemoViewModel>()) {
      Get.delete<MapDemoViewModel>(force: true);
    }
  }
}
