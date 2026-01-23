/// Skill Tree Demo Bindings
///
/// Registers Skill Tree Demo feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import 'actions/skill_tree_demo_actions.dart';
import 'controllers/skill_tree_demo_view_model.dart';

/// Registers Skill Tree Demo feature dependencies.
///
/// **Registered Dependencies**:
/// - [SkillTreeDemoViewModel] - Business logic for skill tree demo
/// - [SkillTreeDemoActions] - Action handlers for skill tree demo
class SkillTreeDemoBindings implements Bindings {
  @override
  void dependencies() {
    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<SkillTreeDemoViewModel>()) {
      Get.put<SkillTreeDemoViewModel>(
        SkillTreeDemoViewModel(),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<SkillTreeDemoActions>()) {
      Get.lazyPut<SkillTreeDemoActions>(
        () => SkillTreeDemoActions(
          Get.find<SkillTreeDemoViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<SkillTreeDemoActions>()) {
      Get.delete<SkillTreeDemoActions>(force: true);
    }
    if (Get.isRegistered<SkillTreeDemoViewModel>()) {
      Get.delete<SkillTreeDemoViewModel>(force: true);
    }
  }
}
