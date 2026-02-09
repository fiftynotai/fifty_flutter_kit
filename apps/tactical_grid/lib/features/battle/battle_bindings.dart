/// Battle Bindings
///
/// GetX dependency injection registration for the battle feature.
/// Follows the established pattern: Services -> ViewModels -> Actions.
///
/// Registered on the `/battle` route so dependencies are created when
/// navigating to the battle screen and disposed when leaving.
///
/// **Usage:**
/// ```dart
/// GetPage(
///   name: '/battle',
///   page: () => const BattleScreen(),
///   binding: BattleBindings(),
/// );
/// ```
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import '../achievements/achievement_actions.dart';
import '../achievements/achievement_view_model.dart';
import 'actions/battle_actions.dart';
import 'controllers/battle_view_model.dart';
import 'services/ai_service.dart';
import 'services/ai_turn_executor.dart';
import 'services/audio_coordinator.dart';
import 'services/game_logic_service.dart';

/// Registers all battle feature dependencies in the GetX container.
///
/// **Registration Order:**
/// 1. **Services** - [GameLogicService], [BattleAudioCoordinator]
/// 2. **ViewModel** - [BattleViewModel] (depends on [GameLogicService])
/// 3. **Actions** - [BattleActions] (depends on ViewModel, Audio, Presenter)
///
/// Uses `fenix: true` on lazy-put bindings to allow re-creation if the
/// route is revisited after the previous instance was disposed.
class BattleBindings extends Bindings {
  @override
  void dependencies() {
    // 1. Services
    Get.lazyPut<GameLogicService>(
      () => const GameLogicService(),
      fenix: true,
    );
    Get.lazyPut<BattleAudioCoordinator>(
      () => BattleAudioCoordinator(),
      fenix: true,
    );
    Get.lazyPut<AIService>(
      () => const AIService(),
      fenix: true,
    );

    // 2. ViewModel
    Get.put<BattleViewModel>(
      BattleViewModel(Get.find<GameLogicService>()),
    );

    // 3. AI Turn Executor (depends on ViewModel, Audio, AIService)
    Get.lazyPut<AITurnExecutor>(
      () => AITurnExecutor(
        Get.find<BattleViewModel>(),
        Get.find<BattleAudioCoordinator>(),
        Get.find<AIService>(),
      ),
      fenix: true,
    );

    // 4. Achievement tracking
    Get.lazyPut<AchievementActions>(
      () => AchievementActions(
        Get.find<AchievementViewModel>(),
        Get.find<BattleAudioCoordinator>(),
      ),
      fenix: true,
    );

    // 5. Actions
    Get.lazyPut<BattleActions>(
      () => BattleActions(
        Get.find<BattleViewModel>(),
        Get.find<BattleAudioCoordinator>(),
        ActionPresenter(),
        Get.find<AchievementActions>(),
        Get.find<AITurnExecutor>(),
      ),
      fenix: true,
    );
  }
}
