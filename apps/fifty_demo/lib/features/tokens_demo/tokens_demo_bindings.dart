/// Tokens Demo Bindings
///
/// Registers Tokens Demo feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import 'actions/tokens_demo_actions.dart';
import 'controllers/tokens_demo_view_model.dart';

/// Registers Tokens Demo feature dependencies.
///
/// **Registered Dependencies**:
/// - [TokensDemoViewModel] - Business logic for tokens demo
/// - [TokensDemoActions] - Action handlers for tokens demo
class TokensDemoBindings implements Bindings {
  @override
  void dependencies() {
    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<TokensDemoViewModel>()) {
      Get.put<TokensDemoViewModel>(
        TokensDemoViewModel(),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<TokensDemoActions>()) {
      Get.lazyPut<TokensDemoActions>(
        () => TokensDemoActions(
          Get.find<TokensDemoViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<TokensDemoActions>()) {
      Get.delete<TokensDemoActions>(force: true);
    }
    if (Get.isRegistered<TokensDemoViewModel>()) {
      Get.delete<TokensDemoViewModel>(force: true);
    }
  }
}
