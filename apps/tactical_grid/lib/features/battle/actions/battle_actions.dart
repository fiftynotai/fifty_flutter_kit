/// Battle Actions
///
/// UX orchestration layer for the battle feature. Handles user interactions,
/// delegates business logic to [BattleViewModel], triggers audio via
/// [BattleAudioCoordinator], and provides UI feedback through
/// [ActionPresenter].
///
/// **Architecture Note:**
/// Actions NEVER contain business logic. They orchestrate:
/// - Loading indicators
/// - Error handling and snackbars
/// - Navigation
/// - Audio triggers
/// - Dialog presentation
///
/// **Usage:**
/// ```dart
/// final actions = Get.find<BattleActions>();
/// actions.onTileTapped(context, GridPosition(3, 5));
/// actions.onAttackUnit(context, 'e_shield_1');
/// actions.onEndTurn(context);
/// ```
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../../../core/routes/route_manager.dart';
import '../../achievements/achievement_actions.dart';
import '../controllers/battle_view_model.dart';
import '../models/models.dart';
import '../services/audio_coordinator.dart';

/// UX orchestration layer for the tactical battle screen.
///
/// Sits between the UI widgets and the [BattleViewModel]. Every public
/// method corresponds to a user interaction (tile tap, button press, etc.)
/// and follows the same pattern:
///
/// 1. Validate preconditions (delegate to ViewModel)
/// 2. Execute business logic (delegate to ViewModel)
/// 3. Trigger audio feedback (delegate to AudioCoordinator)
/// 4. Show UI feedback (snackbars, dialogs via ActionPresenter)
///
/// **Injected via:** [BattleBindings]
class BattleActions {
  /// The battle ViewModel that holds reactive game state.
  final BattleViewModel _viewModel;

  /// Audio coordinator for battle sound effects and BGM.
  final BattleAudioCoordinator _audio;

  /// Presenter for loading overlays, snackbars, and dialogs.
  final ActionPresenter _presenter;

  /// Achievement tracking for battle events.
  final AchievementActions? _achievements;

  /// Creates a [BattleActions] instance with required dependencies.
  BattleActions(this._viewModel, this._audio, this._presenter,
      [this._achievements]);

  // ---------------------------------------------------------------------------
  // Tile Interaction
  // ---------------------------------------------------------------------------

  /// Handles a user tap on a board tile at [position].
  ///
  /// **Logic flow:**
  /// 0. If in ability targeting mode: use ability on valid target or cancel.
  /// 1. If a friendly unit is at [position] and no unit is selected (or a
  ///    different unit is selected), select it.
  /// 2. If the same unit is already selected, deselect it.
  /// 3. If a unit is selected and [position] is a valid move target, execute
  ///    the move.
  /// 4. Otherwise, deselect.
  void onTileTapped(BuildContext context, GridPosition position) {
    final state = _viewModel.gameState.value;
    if (state.isGameOver) return;

    // Case 0: Ability targeting mode -- intercept tile taps.
    if (_viewModel.isAbilityTargeting.value) {
      if (state.abilityTargets.contains(position)) {
        onUseAbility(context, targetPosition: position);
      }
      _viewModel.isAbilityTargeting.value = false;
      return;
    }

    final unitAtPosition = state.board.getUnitAt(position);

    // Case 1: Tap on a friendly unit.
    if (unitAtPosition != null &&
        unitAtPosition.isAlive &&
        unitAtPosition.isPlayer == state.isPlayerTurn) {
      // Toggle selection if tapping the already-selected unit.
      if (state.selectedUnit?.id == unitAtPosition.id) {
        _viewModel.deselectUnit();
        return;
      }

      // Select the tapped unit.
      _viewModel.selectUnit(unitAtPosition.id);
      _audio.playSelectSfx();
      return;
    }

    // Case 2: A unit is selected and the tapped position is a valid move.
    if (state.hasSelection && state.validMoves.contains(position)) {
      _viewModel.moveSelectedUnit(position);
      _audio.playMoveSfx();
      return;
    }

    // Case 3: Tap on an attack target → execute attack.
    if (state.hasSelection && unitAtPosition != null) {
      final isTarget = state.attackTargets.any((t) => t.id == unitAtPosition.id);
      if (isTarget) {
        onAttackUnit(context, unitAtPosition.id);
        return;
      }
    }

    // Case 4: Tap elsewhere -- deselect.
    if (state.hasSelection) {
      _viewModel.deselectUnit();
    }
  }

  // ---------------------------------------------------------------------------
  // Combat
  // ---------------------------------------------------------------------------

  /// Executes an attack against the target unit with [targetUnitId].
  ///
  /// Delegates combat resolution to the ViewModel, then provides audio and
  /// UI feedback based on the result:
  /// - Attack SFX always plays on success.
  /// - Capture SFX plays if the target is defeated.
  /// - Victory/defeat dialog is shown if the game ends.
  void onAttackUnit(BuildContext context, String targetUnitId) {
    _presenter.actionHandlerWithoutLoading(
      () async {
        // Capture unit info before state mutation.
        final preState = _viewModel.gameState.value;
        final attacker = preState.selectedUnit;
        final target = preState.board.units
            .where((u) => u.id == targetUnitId)
            .firstOrNull;

        final result = _viewModel.attackUnit(targetUnitId);

        if (!result.success) {
          if (context.mounted) {
            _presenter.showErrorSnackBar(
              context,
              'Invalid Action',
              result.errorMessage ?? 'Cannot attack that target.',
            );
          }
          return;
        }

        // Play attack SFX.
        await _audio.playAttackSfx();

        // Play capture SFX if the target was defeated.
        if (result.targetDefeated == true) {
          await _audio.playCaptureSfx();
        }

        // Track achievement events.
        final achievements = _achievements;
        if (achievements != null && attacker != null && target != null) {
          if (result.targetDefeated == true) {
            achievements.trackUnitDefeated(
              attacker: attacker,
              target: target,
            );
          } else {
            achievements.trackShieldBlock(target);
          }
        }

        // Show attack feedback.
        if (context.mounted) {
          final damage = result.damageDealt ?? 0;
          final msg = result.targetDefeated == true
              ? '$damage damage! Target defeated!'
              : '$damage damage dealt!';
          _presenter.showSuccessSnackBar(context, 'Attack', msg);
        }

        // Check for game over after the attack.
        final state = _viewModel.gameState.value;
        if (state.isGameOver && context.mounted) {
          if (state.result == GameResult.playerWin) {
            _trackVictoryAchievements(state);
            _showVictoryDialog(context);
          } else if (state.result == GameResult.enemyWin) {
            _showDefeatDialog(context);
          }
        }

        // Show achievement unlock popup if one was triggered.
        if (context.mounted) {
          _achievements?.showUnlockPopupIfNeeded(context);
        }
      },
      context: context,
    );
  }

  // ---------------------------------------------------------------------------
  // Turn Management
  // ---------------------------------------------------------------------------

  /// Ends the current player's turn.
  ///
  /// Delegates to the ViewModel, plays the turn-end SFX, and provides a
  /// brief snackbar notification indicating the turn change.
  void onEndTurn(BuildContext context) {
    _viewModel.endTurn();
    _audio.playTurnEndSfx();

    // Show turn change feedback.
    if (context.mounted) {
      final nextPlayer = _viewModel.gameState.value.turnLabel;
      FiftySnackbar.show(
        context,
        message: "$nextPlayer's turn",
        variant: FiftySnackbarVariant.info,
      );
    }
  }

  /// Ends the selected unit's turn without performing further actions.
  ///
  /// The unit is marked as having used both its move and action for this
  /// turn. Plays a selection SFX to acknowledge the wait command.
  void onWaitUnit(BuildContext context) {
    _viewModel.waitUnit();
    _audio.playSelectSfx();
  }

  // ---------------------------------------------------------------------------
  // Abilities
  // ---------------------------------------------------------------------------

  /// Handles the ability button press in the unit info panel.
  ///
  /// For self-target abilities (Block, Rally, Reveal), executes immediately.
  /// For position-target abilities (Shoot, Fireball), enters ability targeting
  /// mode so the player can tap a target tile on the board.
  void onAbilityButtonPressed(BuildContext context) {
    final ability = _viewModel.selectedAbility;
    if (ability == null || !ability.isReady) return;

    switch (ability.type) {
      // Self-target / no-position abilities: execute immediately.
      case AbilityType.block:
      case AbilityType.rally:
      case AbilityType.reveal:
        onUseAbility(context);
        break;

      // Position-target abilities: enter targeting mode.
      case AbilityType.shoot:
      case AbilityType.fireball:
        _viewModel.isAbilityTargeting.value = true;
        _audio.playSelectSfx();
        break;

      // Passive -- should not be reachable from the UI.
      case AbilityType.charge:
        break;
    }
  }

  /// Executes the selected unit's ability, optionally at a [targetPosition].
  ///
  /// On success: plays ability SFX, shows feedback, checks game over.
  /// On failure: shows error snackbar.
  /// Always resets ability targeting mode when done.
  void onUseAbility(BuildContext context, {GridPosition? targetPosition}) {
    _presenter.actionHandlerWithoutLoading(
      () async {
        final result = _viewModel.useAbility(targetPosition: targetPosition);
        _viewModel.isAbilityTargeting.value = false;

        if (!result.success) {
          if (context.mounted) {
            _presenter.showErrorSnackBar(
              context,
              'Ability Failed',
              result.errorMessage ?? 'Cannot use ability.',
            );
          }
          return;
        }

        // Play ability SFX (reuse attack SFX for damaging abilities).
        await _audio.playAbilitySfx();

        // Show success feedback.
        if (context.mounted) {
          final abilityName =
              _viewModel.selectedAbility?.name ?? 'Ability';
          final damage = result.damageDealt;
          final msg = damage != null && damage > 0
              ? '$abilityName: $damage damage dealt!'
              : '$abilityName activated!';
          _presenter.showSuccessSnackBar(context, abilityName, msg);
        }

        // Check for game over (Shoot / Fireball can kill a Commander).
        final state = _viewModel.gameState.value;
        if (state.isGameOver && context.mounted) {
          if (state.result == GameResult.playerWin) {
            _trackVictoryAchievements(state);
            _showVictoryDialog(context);
          } else if (state.result == GameResult.enemyWin) {
            _showDefeatDialog(context);
          }
        }

        // Show achievement unlock popup if one was triggered.
        if (context.mounted) {
          _achievements?.showUnlockPopupIfNeeded(context);
        }
      },
      context: context,
    );
  }

  // ---------------------------------------------------------------------------
  // Game Lifecycle
  // ---------------------------------------------------------------------------

  /// Starts a new game.
  ///
  /// Initializes game state via the ViewModel and begins battle BGM.
  void onStartGame(BuildContext context) {
    _viewModel.startNewGame();
    _audio.playBattleBgm();
  }

  /// Called when the battle page is first displayed.
  ///
  /// Starts background music without resetting the game (the ViewModel
  /// already calls [startNewGame] in its [onInit]).
  void onBattleEnter() {
    _audio.playBattleBgm();
  }

  /// Tracks victory-related achievement events.
  void _trackVictoryAchievements(GameState state) {
    final achievements = _achievements;
    if (achievements == null) return;

    final noUnitsLost = state.board.playerUnits.length == 6;
    achievements.trackGameWon(
      turnNumber: state.turnNumber,
      noUnitsLost: noUnitsLost,
    );
  }

  /// Exits the current game and navigates back to the main menu.
  ///
  /// Shows a confirmation dialog before exiting. If confirmed, stops BGM
  /// and navigates to the menu route.
  void onExitGame(BuildContext context) {
    _presenter.actionHandlerWithoutLoading(
      () async {
        if (!context.mounted) return;

        final confirmed = await _presenter.showConfirmationDialog(
          context,
          'Leave the battle? All progress will be lost.',
        );

        if (confirmed) {
          await _audio.stopBgm();
          RouteManager.toMenu();
        }
      },
      context: context,
    );
  }

  // ---------------------------------------------------------------------------
  // Dialogs
  // ---------------------------------------------------------------------------

  /// Shows the victory dialog when the player wins.
  void _showVictoryDialog(BuildContext context) {
    _audio.stopBgm();

    showFiftyDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;

        return FiftyDialog(
          title: 'Victory',
          showCloseButton: false,
          content: Text(
            'The enemy Commander has been captured. You win!',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodyMedium,
              color: colorScheme.onSurface,
            ),
          ),
          actions: [
            FiftyButton(
              label: 'MAIN MENU',
              variant: FiftyButtonVariant.ghost,
              onPressed: () {
                Navigator.pop(dialogContext);
                RouteManager.toMenu();
              },
            ),
            FiftyButton(
              label: 'PLAY AGAIN',
              variant: FiftyButtonVariant.primary,
              onPressed: () {
                Navigator.pop(dialogContext);
                onStartGame(context);
              },
            ),
          ],
        );
      },
    );
  }

  /// Shows the defeat dialog when the player loses.
  void _showDefeatDialog(BuildContext context) {
    _audio.stopBgm();

    showFiftyDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        final colorScheme = Theme.of(dialogContext).colorScheme;

        return FiftyDialog(
          title: 'Defeat',
          showCloseButton: false,
          content: Text(
            'Your Commander has been captured. You lose.',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodyMedium,
              color: colorScheme.onSurface,
            ),
          ),
          actions: [
            FiftyButton(
              label: 'MAIN MENU',
              variant: FiftyButtonVariant.ghost,
              onPressed: () {
                Navigator.pop(dialogContext);
                RouteManager.toMenu();
              },
            ),
            FiftyButton(
              label: 'TRY AGAIN',
              variant: FiftyButtonVariant.primary,
              onPressed: () {
                Navigator.pop(dialogContext);
                onStartGame(context);
              },
            ),
          ],
        );
      },
    );
  }
}
