import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tactical_grid/core/presentation/actions/action_presenter.dart';
import 'package:tactical_grid/features/battle/actions/battle_actions.dart';
import 'package:tactical_grid/features/battle/controllers/battle_view_model.dart';
import 'package:tactical_grid/features/battle/models/models.dart';
import 'package:tactical_grid/features/battle/services/audio_coordinator.dart';
import 'package:tactical_grid/features/battle/services/game_logic_service.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

/// A minimal [ActionPresenter] that records calls instead of showing UI.
class _FakeActionPresenter extends ActionPresenter {
  final List<String> errorMessages = [];

  @override
  void showErrorSnackBar(BuildContext context, String title, String message) {
    errorMessages.add('$title: $message');
  }
}

void main() {
  late BattleViewModel viewModel;
  late BattleAudioCoordinator audio;
  late _FakeActionPresenter presenter;
  late BattleActions actions;

  setUp(() {
    Get.reset();
    final gameLogic = const GameLogicService();
    viewModel = BattleViewModel(gameLogic);
    // Real audio coordinator -- silently fails without audio engine in tests.
    audio = BattleAudioCoordinator();
    presenter = _FakeActionPresenter();
    actions = BattleActions(viewModel, audio, presenter);
  });

  // ---------------------------------------------------------------------------
  // onAbilityButtonPressed — empty target guard
  // ---------------------------------------------------------------------------

  group('onAbilityButtonPressed', () {
    testWidgets(
      'does NOT enter targeting mode when abilityTargets is empty (shoot)',
      (tester) async {
        // Build a minimal widget tree to obtain a valid BuildContext.
        late BuildContext capturedContext;
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        // Set up game state: select the archer with an empty abilityTargets.
        viewModel.startNewGame();
        viewModel.selectUnit('p_archer_1');

        // Force abilityTargets to be empty so the guard triggers.
        viewModel.gameState.value = viewModel.gameState.value.copyWith(
          abilityTargets: const [],
        );

        // Precondition: targeting is off.
        expect(viewModel.isAbilityTargeting.value, false);

        actions.onAbilityButtonPressed(capturedContext);

        // Targeting should still be off.
        expect(viewModel.isAbilityTargeting.value, false);

        // Presenter should have been called with an error message.
        expect(presenter.errorMessages, hasLength(1));
        expect(
          presenter.errorMessages.first,
          'No Targets: No valid targets in range.',
        );
      },
    );

    testWidgets(
      'enters targeting mode when abilityTargets is NOT empty (shoot)',
      (tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        viewModel.startNewGame();
        viewModel.selectUnit('p_archer_1');

        // Force abilityTargets to contain at least one valid position.
        viewModel.gameState.value = viewModel.gameState.value.copyWith(
          abilityTargets: const [GridPosition(3, 3)],
        );

        expect(viewModel.isAbilityTargeting.value, false);

        actions.onAbilityButtonPressed(capturedContext);

        // Targeting should now be active.
        expect(viewModel.isAbilityTargeting.value, true);

        // No error messages expected.
        expect(presenter.errorMessages, isEmpty);
      },
    );

    testWidgets(
      'does NOT enter targeting mode when abilityTargets is empty (fireball)',
      (tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        viewModel.startNewGame();
        // Select the mage (fireball ability).
        viewModel.selectUnit('p_mage_1');

        // Force abilityTargets to be empty.
        viewModel.gameState.value = viewModel.gameState.value.copyWith(
          abilityTargets: const [],
        );

        expect(viewModel.isAbilityTargeting.value, false);

        actions.onAbilityButtonPressed(capturedContext);

        expect(viewModel.isAbilityTargeting.value, false);
        expect(presenter.errorMessages, hasLength(1));
        expect(
          presenter.errorMessages.first,
          'No Targets: No valid targets in range.',
        );
      },
    );
  });
}
