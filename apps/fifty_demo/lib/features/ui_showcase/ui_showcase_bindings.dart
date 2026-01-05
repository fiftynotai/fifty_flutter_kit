/// UI Showcase Bindings
///
/// Registers UI Showcase feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import 'actions/ui_showcase_actions.dart';
import 'viewmodel/ui_showcase_viewmodel.dart';

/// **UiShowcaseBindings**
///
/// Registers UI Showcase feature dependencies.
///
/// **Registered Dependencies**:
/// - `UiShowcaseViewModel` - Business logic for UI showcase feature
/// - `UiShowcaseActions` - Action handlers for UI showcase feature
class UiShowcaseBindings implements Bindings {
  @override
  void dependencies() {
    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<UiShowcaseViewModel>()) {
      Get.put<UiShowcaseViewModel>(
        UiShowcaseViewModel(),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<UiShowcaseActions>()) {
      Get.lazyPut<UiShowcaseActions>(
        () => UiShowcaseActions(
          Get.find<UiShowcaseViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<UiShowcaseActions>()) {
      Get.delete<UiShowcaseActions>(force: true);
    }
    if (Get.isRegistered<UiShowcaseViewModel>()) {
      Get.delete<UiShowcaseViewModel>(force: true);
    }
  }
}
