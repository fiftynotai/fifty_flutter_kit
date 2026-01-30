/// Audio Demo Bindings
///
/// Registers Audio Demo feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import 'actions/audio_demo_actions.dart';
import 'controllers/audio_demo_view_model.dart';

/// **AudioDemoBindings**
///
/// Registers Audio Demo feature dependencies.
///
/// **Registered Dependencies**:
/// - `AudioDemoViewModel` - Business logic for audio demo feature
/// - `AudioDemoActions` - Action handlers for audio demo feature
class AudioDemoBindings implements Bindings {
  @override
  void dependencies() {
    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<AudioDemoViewModel>()) {
      Get.put<AudioDemoViewModel>(
        AudioDemoViewModel(),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<AudioDemoActions>()) {
      Get.lazyPut<AudioDemoActions>(
        () => AudioDemoActions(
          Get.find<AudioDemoViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<AudioDemoActions>()) {
      Get.delete<AudioDemoActions>(force: true);
    }
    if (Get.isRegistered<AudioDemoViewModel>()) {
      Get.delete<AudioDemoViewModel>(force: true);
    }
  }
}
