/// Socket Demo Bindings
///
/// Registers Socket Demo feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import 'actions/socket_demo_actions.dart';
import 'controllers/socket_demo_view_model.dart';

/// Registers Socket Demo feature dependencies.
///
/// **Registered Dependencies**:
/// - [SocketDemoViewModel] - Business logic for socket demo
/// - [SocketDemoActions] - Action handlers for socket demo
class SocketDemoBindings implements Bindings {
  @override
  void dependencies() {
    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<SocketDemoViewModel>()) {
      Get.put<SocketDemoViewModel>(
        SocketDemoViewModel(),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<SocketDemoActions>()) {
      Get.lazyPut<SocketDemoActions>(
        () => SocketDemoActions(
          Get.find<SocketDemoViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<SocketDemoActions>()) {
      Get.delete<SocketDemoActions>(force: true);
    }
    if (Get.isRegistered<SocketDemoViewModel>()) {
      Get.delete<SocketDemoViewModel>(force: true);
    }
  }
}
