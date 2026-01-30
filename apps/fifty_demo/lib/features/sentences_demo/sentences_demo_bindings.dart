/// Sentences Demo Bindings
///
/// Registers Sentences Demo feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import 'actions/sentences_demo_actions.dart';
import 'controllers/sentences_demo_view_model.dart';

/// Registers Sentences Demo feature dependencies.
///
/// **Registered Dependencies**:
/// - [SentencesDemoViewModel] - Business logic for sentences demo
/// - [SentencesDemoActions] - Action handlers for sentences demo
class SentencesDemoBindings implements Bindings {
  @override
  void dependencies() {
    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<SentencesDemoViewModel>()) {
      Get.put<SentencesDemoViewModel>(
        SentencesDemoViewModel(),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<SentencesDemoActions>()) {
      Get.lazyPut<SentencesDemoActions>(
        () => SentencesDemoActions(
          Get.find<SentencesDemoViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<SentencesDemoActions>()) {
      Get.delete<SentencesDemoActions>(force: true);
    }
    if (Get.isRegistered<SentencesDemoViewModel>()) {
      Get.delete<SentencesDemoViewModel>(force: true);
    }
  }
}
