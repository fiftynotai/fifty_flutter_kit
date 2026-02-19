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

import 'dart:async';

import 'package:fifty_world_engine/fifty_world_engine.dart' as world_engine;
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../../../core/routes/route_manager.dart';
import '../../achievements/achievement_actions.dart';
import '../controllers/battle_view_model.dart';
import '../models/models.dart';
import '../services/ai_turn_executor.dart';
import '../services/audio_coordinator.dart';
import '../services/animation_service.dart';
import '../services/turn_timer_service.dart';

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

  /// AI turn executor for vs-AI mode. Nullable so existing code
  /// continues to work when no executor is provided.
  final AITurnExecutor? _aiExecutor;

  /// Turn timer service for countdown management. Nullable so existing
  /// code continues to work when no timer is provided.
  final TurnTimerService? _timerService;

  /// Animation service for coordinating visual animation effects.
  /// Nullable so existing code works without it.
  final AnimationService? _animationService;

  /// Creates a [BattleActions] instance with required dependencies.
  BattleActions(
    this._viewModel,
    this._audio,
    this._presenter, [
    this._achievements,
    this._aiExecutor,
    this._timerService,
    this._animationService,
  ]) {
    _setupTimerCallbacks();
  }

  // ---------------------------------------------------------------------------
  // Timer Integration
  // ---------------------------------------------------------------------------

  /// Wires up timer callbacks for expiry, warning, and critical audio cues.
  void _setupTimerCallbacks() {
    final timer = _timerService;
    if (timer == null) return;

    timer.onWarning = () {
      _audio.playTimerWarningSfx();
      _audio.announceTurnWarning();
    };
    timer.onCritical = () => _audio.playTimerAlarmSfx();
    timer.onTimerExpired = _onTimerExpired;
  }

  /// Handles timer expiry by auto-ending the current turn.
  ///
  /// When the timer runs out, the current turn is ended automatically.
  /// If the game is in vs-AI mode, the AI turn is triggered afterward.
  void _onTimerExpired() {
    if (_aiExecutor?.isExecuting.value == true) return;
    if (_viewModel.isGameOver) return;

    // Auto-skip: end the current turn.
    _viewModel.endTurn();
    _audio.playTurnEndSfx();

    // Trigger AI if applicable.
    if (_viewModel.isAITurn && _aiExecutor != null) {
      _aiExecutor!.executeAITurn().then((_) {
        if (!_viewModel.isGameOver) {
          _timerService?.startTurn();
        }
      });
    } else if (!_viewModel.isGameOver) {
      _timerService?.startTurn();
    }
  }

  /// Starts the timer for the current turn if applicable.
  void _startTimerForCurrentTurn() {
    if (_viewModel.isGameOver) return;
    // Do not start timer during AI turns.
    if (_viewModel.isAITurn) return;
    _timerService?.startTurn();
  }

  // ---------------------------------------------------------------------------
  // Animation Helpers
  // ---------------------------------------------------------------------------

  /// Executes a move with engine animation (A* pathfinding + AnimationQueue).
  ///
  /// If the engine controller is available (registered via GetX by
  /// [EngineBoardWidget]), uses the engine's [world_engine.AnimationQueue] to
  /// animate the unit along an A* path step by step. Falls back to the old
  /// [AnimationService] if the engine is not registered (e.g. in tests).
  Future<void> _handleMoveWithAnimation(
    GameState state,
    GridPosition position,
  ) async {
    final fromPos = state.selectedUnit!.position;
    final unitId = state.selectedUnit!.id;

    // Try engine-based animation.
    if (Get.isRegistered<world_engine.FiftyWorldController>()) {
      final controller = Get.find<world_engine.FiftyWorldController>();
      final grid = Get.find<world_engine.TileGrid>();

      // Compute occupied positions (excluding the moving unit).
      final occupied = state.board.units
          .where((u) => u.isAlive && u.id != unitId)
          .map((u) => world_engine.GridPosition(u.position.x, u.position.y))
          .toSet();

      // A* pathfinding (diagonal enabled so diagonal/L-shape moves can route).
      final path = controller.findPath(
        world_engine.GridPosition(fromPos.x, fromPos.y),
        world_engine.GridPosition(position.x, position.y),
        grid: grid,
        blocked: occupied,
        diagonal: true,
      );

      // Update game state immediately (game logic moves the unit).
      _viewModel.moveSelectedUnit(position);
      _audio.playMoveSfx();

      // Animate along the path if one was found.
      if (path != null && path.length > 1) {
        final completer = Completer<void>();

        for (int i = 1; i < path.length; i++) {
          final step = path[i];
          final isLast = i == path.length - 1;
          controller.queueAnimation(world_engine.AnimationEntry(
            execute: () async {
              final entity = controller.getEntityById(unitId);
              if (entity == null) return;
              controller.move(entity, step.x.toDouble(), step.y.toDouble());
              await Future<void>.delayed(const Duration(milliseconds: 200));
            },
            onComplete: isLast ? () => completer.complete() : null,
          ));
        }

        await completer.future;
      } else {
        // No intermediate path (L-shape jump, blocked, or adjacent step).
        // Move the engine component directly to the target tile so it stays
        // in sync with the game state that was already updated above.
        final completer = Completer<void>();
        controller.queueAnimation(world_engine.AnimationEntry(
          execute: () async {
            final entity = controller.getEntityById(unitId);
            if (entity == null) return;
            controller.move(
                entity, position.x.toDouble(), position.y.toDouble());
            await Future<void>.delayed(const Duration(milliseconds: 300));
          },
          onComplete: () => completer.complete(),
        ));
        await completer.future;
      }
      return;
    }

    // Fallback: old animation service (used in tests without the engine).
    final animFuture =
        _animationService?.playMoveAnimation(unitId, fromPos, position);
    _viewModel.moveSelectedUnit(position);
    _audio.playMoveSfx();
    if (animFuture != null) await animFuture;
  }

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
    // Block player input while an animation is playing.
    if (_animationService?.isAnimating ?? false) return;
    if (Get.isRegistered<world_engine.FiftyWorldController>() &&
        Get.find<world_engine.FiftyWorldController>().isAnimating) {
      return;
    }
    // Block player input while AI is executing its turn.
    if (_aiExecutor?.isExecuting.value == true) return;

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
      _handleMoveWithAnimation(state, position);
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
    // Block player input while an animation is playing.
    if (_animationService?.isAnimating ?? false) return;
    if (Get.isRegistered<world_engine.FiftyWorldController>() &&
        Get.find<world_engine.FiftyWorldController>().isAnimating) {
      return;
    }
    // Block player input while AI is executing its turn.
    if (_aiExecutor?.isExecuting.value == true) return;

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

        // --- Animation sequence ---
        // Try engine-based animation.
        if (Get.isRegistered<world_engine.FiftyWorldController>() &&
            attacker != null &&
            target != null) {
          final controller = Get.find<world_engine.FiftyWorldController>();

          // 1. Attack lunge animation.
          final attackerComp = controller.getComponentById(attacker.id);
          if (attackerComp is world_engine.FiftyMovableComponent) {
            final attackCompleter = Completer<void>();
            controller.queueAnimation(world_engine.AnimationEntry.timed(
              action: () => attackerComp.attack(),
              duration: const Duration(milliseconds: 400),
              onComplete: () => attackCompleter.complete(),
            ));
            await attackCompleter.future;
          }

          // 2. Damage popup + HP bar update.
          if (result.damageDealt != null && result.damageDealt! > 0) {
            final popupCompleter = Completer<void>();
            controller.queueAnimation(world_engine.AnimationEntry.timed(
              action: () {
                controller.showFloatingText(
                  world_engine.GridPosition(
                      target.position.x, target.position.y),
                  '-${result.damageDealt}',
                  color: const Color(0xFFFFFF00), // Yellow
                  fontSize: 24,
                );
                controller.updateHP(
                  target.id,
                  target.hp.toDouble() / target.maxHp.toDouble(),
                );
              },
              duration: const Duration(milliseconds: 800),
              onComplete: () => popupCompleter.complete(),
            ));
            await popupCompleter.future;
          }

          // 3. Defeat animation (if killed).
          if (result.targetDefeated == true) {
            final targetComp = controller.getComponentById(target.id);
            if (targetComp is world_engine.FiftyMovableComponent) {
              final defeatCompleter = Completer<void>();
              controller.queueAnimation(world_engine.AnimationEntry(
                execute: () async {
                  targetComp.die();
                  await Future<void>.delayed(
                      const Duration(milliseconds: 600));
                },
                onComplete: () {
                  final targetEntity =
                      controller.getEntityById(target.id);
                  if (targetEntity != null) {
                    controller.removeEntity(targetEntity);
                  }
                  controller.removeDecorators(target.id);
                  defeatCompleter.complete();
                },
              ));
              await defeatCompleter.future;
            }
          }
        } else {
          // Fallback: old AnimationService.
          final anim = _animationService;
          if (anim != null && attacker != null && target != null) {
            await anim.playAttackAnimation(
              attacker.id,
              attacker.position,
              target.position,
            );
            anim.triggerFlash(target.id);
            if (result.damageDealt != null && result.damageDealt! > 0) {
              await anim.playDamagePopup(
                  target.position, result.damageDealt!);
            }
            if (result.targetDefeated == true) {
              await anim.playDefeatAnimation(target.id, target.position);
            }
          }
        }

        // Play attack SFX.
        await _audio.playAttackSfx();

        // Play capture SFX and announce if the target was defeated.
        if (result.targetDefeated == true) {
          await _audio.playCaptureSfx();
          if (target != null) {
            _audio.announceUnitCaptured(target.type);
          }
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
        if (_viewModel.isGameOver && context.mounted) {
          _handleGameOver(context);
        }

        // Check if player's commander is in danger (low HP).
        if (!_viewModel.isGameOver) {
          final commander = _viewModel.board.playerCommander;
          if (commander != null && commander.isAlive && commander.hp <= 2) {
            _audio.announceCommanderInDanger();
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
  /// Cancels the running timer, delegates to the ViewModel, plays the
  /// turn-end SFX, and provides a brief snackbar notification indicating
  /// the turn change. Restarts the timer for the next player turn (or
  /// after the AI turn completes in vs-AI mode).
  void onEndTurn(BuildContext context) {
    // Block player input while an animation is playing.
    if (_animationService?.isAnimating ?? false) return;
    if (Get.isRegistered<world_engine.FiftyWorldController>() &&
        Get.find<world_engine.FiftyWorldController>().isAnimating) {
      return;
    }
    // Block player input while AI is executing its turn.
    if (_aiExecutor?.isExecuting.value == true) return;

    // Cancel timer before ending turn.
    _timerService?.cancel();

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

    // Trigger AI turn if applicable.
    if (_viewModel.isAITurn && _aiExecutor != null) {
      _aiExecutor!.executeAITurn().then((_) {
        // Start timer for player after AI turn completes.
        if (!_viewModel.isGameOver) {
          _timerService?.startTurn();
        }

        // Check game over after AI turn completes.
        if (_viewModel.isGameOver && context.mounted) {
          _handleGameOver(context);
        }
      });
    } else if (!_viewModel.isGameOver) {
      // Local multiplayer: start timer for the next player.
      _timerService?.startTurn();
    }
  }

  /// Ends the selected unit's turn without performing further actions.
  ///
  /// The unit is marked as having used both its move and action for this
  /// turn. Plays a selection SFX to acknowledge the wait command.
  void onWaitUnit(BuildContext context) {
    // Block player input while an animation is playing.
    if (_animationService?.isAnimating ?? false) return;
    if (Get.isRegistered<world_engine.FiftyWorldController>() &&
        Get.find<world_engine.FiftyWorldController>().isAnimating) {
      return;
    }
    // Block player input while AI is executing its turn.
    if (_aiExecutor?.isExecuting.value == true) return;

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
    // Block player input while an animation is playing.
    if (_animationService?.isAnimating ?? false) return;
    if (Get.isRegistered<world_engine.FiftyWorldController>() &&
        Get.find<world_engine.FiftyWorldController>().isAnimating) {
      return;
    }
    // Block player input while AI is executing its turn.
    if (_aiExecutor?.isExecuting.value == true) return;

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
        if (_viewModel.abilityTargets.isEmpty) {
          if (context.mounted) {
            _presenter.showErrorSnackBar(
              context,
              'No Targets',
              'No valid targets in range.',
            );
          }
          return;
        }
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
    // Block player input while an animation is playing.
    if (_animationService?.isAnimating ?? false) return;
    if (Get.isRegistered<world_engine.FiftyWorldController>() &&
        Get.find<world_engine.FiftyWorldController>().isAnimating) {
      return;
    }
    // Block player input while AI is executing its turn.
    if (_aiExecutor?.isExecuting.value == true) return;

    _presenter.actionHandlerWithoutLoading(
      () async {
        // Capture ability type before state mutation for voice announcement.
        final usedAbilityType = _viewModel.selectedAbility?.type;

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

        // --- Animation for damaging abilities ---
        if (Get.isRegistered<world_engine.FiftyWorldController>() &&
            result.damageDealt != null &&
            result.damageDealt! > 0) {
          final controller = Get.find<world_engine.FiftyWorldController>();

          // Damage popup at target position.
          if (targetPosition != null) {
            final popupCompleter = Completer<void>();
            controller.queueAnimation(world_engine.AnimationEntry.timed(
              action: () {
                controller.showFloatingText(
                  world_engine.GridPosition(
                      targetPosition.x, targetPosition.y),
                  '-${result.damageDealt}',
                  color: const Color(0xFFFFFF00),
                  fontSize: 24,
                );
              },
              duration: const Duration(milliseconds: 800),
              onComplete: () => popupCompleter.complete(),
            ));
            await popupCompleter.future;
          }

          // Defeat animations for any killed units.
          if (result.affectedUnitIds != null) {
            for (final affectedId in result.affectedUnitIds!) {
              final affectedUnit =
                  _viewModel.board.getUnitById(affectedId);
              if (affectedUnit != null && affectedUnit.isDead) {
                final comp = controller.getComponentById(affectedId);
                if (comp is world_engine.FiftyMovableComponent) {
                  final defeatCompleter = Completer<void>();
                  controller.queueAnimation(world_engine.AnimationEntry(
                    execute: () async {
                      comp.die();
                      await Future<void>.delayed(
                          const Duration(milliseconds: 600));
                    },
                    onComplete: () {
                      final entity =
                          controller.getEntityById(affectedId);
                      if (entity != null) {
                        controller.removeEntity(entity);
                      }
                      controller.removeDecorators(affectedId);
                      defeatCompleter.complete();
                    },
                  ));
                  await defeatCompleter.future;
                }
              }
            }
          }
        } else {
          // Fallback: old AnimationService.
          final anim = _animationService;
          if (anim != null &&
              result.damageDealt != null &&
              result.damageDealt! > 0) {
            if (targetPosition != null) {
              await anim.playDamagePopup(
                  targetPosition, result.damageDealt!);
            }
            if (result.affectedUnitIds != null) {
              for (final affectedId in result.affectedUnitIds!) {
                final affectedUnit =
                    _viewModel.board.getUnitById(affectedId);
                if (affectedUnit != null && affectedUnit.isDead) {
                  await anim.playDefeatAnimation(
                    affectedId,
                    affectedUnit.position,
                  );
                }
              }
            }
          }
        }

        // Play ability SFX (reuse attack SFX for damaging abilities).
        await _audio.playAbilitySfx(usedAbilityType);

        // Announce ability used via voice.
        if (usedAbilityType != null) {
          _audio.announceAbilityUsed(usedAbilityType);
        }

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
        if (_viewModel.isGameOver && context.mounted) {
          _handleGameOver(context);
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
  /// Initializes game state via the ViewModel, begins battle BGM,
  /// and starts the turn timer for the first turn.
  void onStartGame(BuildContext context) {
    _viewModel.startNewGameWithMode(
      _viewModel.gameMode,
      _viewModel.aiDifficulty,
    );
    _audio.playBattleBgm();
    _audio.announceMatchStart();
    _startTimerForCurrentTurn();
  }

  /// Called when the battle page is first displayed.
  ///
  /// Starts background music and the turn timer without resetting the
  /// game (the ViewModel already calls [startNewGame] in its [onInit]).
  void onBattleEnter() {
    _audio.playBattleBgm();
    _audio.announceMatchStart();
    _startTimerForCurrentTurn();
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

  /// Handles game-over state by cancelling the timer and showing
  /// the appropriate victory or defeat dialog.
  ///
  /// **Parameters:**
  /// - [context]: The current [BuildContext] for dialog display.
  void _handleGameOver(BuildContext context) {
    _timerService?.cancel();
    final state = _viewModel.gameState.value;
    if (state.result == GameResult.playerWin) {
      _trackVictoryAchievements(state);
      _showVictoryDialog(context);
    } else if (state.result == GameResult.enemyWin) {
      _showDefeatDialog(context);
    }
  }

  /// Exits the current game and navigates back to the main menu.
  ///
  /// Shows a confirmation dialog before exiting. If confirmed, stops BGM,
  /// cancels the timer, and navigates to the menu route.
  void onExitGame(BuildContext context) {
    _presenter.actionHandlerWithoutLoading(
      () async {
        if (!context.mounted) return;

        final confirmed = await _presenter.showConfirmationDialog(
          context,
          'Leave the battle? All progress will be lost.',
        );

        if (confirmed) {
          _timerService?.cancel();
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
    _audio.playVictoryBgm();
    _audio.announceVictory();

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
    _audio.playDefeatBgm();
    _audio.announceDefeat();

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
