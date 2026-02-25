/// AI Turn Executor
///
/// Orchestrates the visual execution of AI turn decisions with delays
/// so the player can follow what the AI is doing on the board.
///
/// This class sits between the [AIService] (which decides what to do)
/// and the [BattleViewModel] (which mutates game state). It calls
/// ViewModel methods in sequence with pauses to create readable AI turns.
///
/// **Usage:**
/// ```dart
/// final executor = AITurnExecutor(viewModel, audio, aiService);
/// await executor.executeAITurn();
/// ```
library;

import 'dart:async';

import 'package:fifty_world_engine/fifty_world_engine.dart' as world_engine;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../achievements/achievement_actions.dart';
import '../controllers/battle_view_model.dart';
import '../models/models.dart';
import '../services/ai_service.dart';
import '../services/animation_service.dart';
import '../services/audio_coordinator.dart';

/// Orchestrates the visual execution of AI turn decisions.
///
/// Executes AI actions sequentially with delays between each action
/// so the player can follow the AI's moves visually on the board.
///
/// **Architecture Note:**
/// This is a SERVICE layer component. It coordinates AI decision-making
/// ([AIService]) with state mutation ([BattleViewModel]) and audio
/// ([BattleAudioCoordinator]) to produce a readable AI turn sequence.
class AITurnExecutor {
  /// The battle ViewModel that holds reactive game state.
  final BattleViewModel _viewModel;

  /// Audio coordinator for battle sound effects.
  final BattleAudioCoordinator _audio;

  /// AI decision-making service.
  final AIService _aiService;

  /// Animation service for coordinating visual animation effects.
  /// Nullable so existing tests work without it.
  final AnimationService? _animationService;

  /// Achievement tracking for battle events. Nullable so existing tests
  /// work without it.
  final AchievementActions? _achievements;

  /// Whether the AI is currently executing its turn.
  final RxBool isExecuting = false.obs;

  /// Delay before AI starts acting (ms) -- simulates "thinking".
  static const int _thinkingDelayMs = 800;

  /// Delay between individual AI unit actions (ms).
  static const int _actionDelayMs = 600;

  /// Delay between sub-steps within a compound action (ms).
  static const int _subStepDelayMs = 400;

  /// Delay for unit selection highlight (ms).
  static const int _selectDelayMs = 300;

  /// Creates an [AITurnExecutor] with the required dependencies.
  AITurnExecutor(this._viewModel, this._audio, this._aiService,
      [this._animationService, this._achievements]);

  /// Execute the complete AI turn.
  ///
  /// 1. Brief "thinking" delay.
  /// 2. Get AI decisions from [AIService].
  /// 3. Execute each action with visual delays.
  /// 4. End the AI turn (switch back to player).
  ///
  /// Does nothing if already executing or the game is over.
  Future<void> executeAITurn() async {
    if (isExecuting.value) return;
    if (_viewModel.isGameOver) return;

    isExecuting.value = true;

    try {
      // Thinking delay so the player sees the turn transition.
      await Future<void>.delayed(
        const Duration(milliseconds: _thinkingDelayMs),
      );

      // Get AI decisions for all enemy units.
      final state = _viewModel.gameState.value;
      final actions = _aiService.decideActions(state, state.aiDifficulty);

      // Execute each action with visual delays.
      for (final action in actions) {
        if (_viewModel.isGameOver) break;
        await _executeAction(action);
        await Future<void>.delayed(
          const Duration(milliseconds: _actionDelayMs),
        );
      }

      // End AI turn (switch back to player).
      if (!_viewModel.isGameOver) {
        _viewModel.endTurn();
        await _audio.playTurnEndSfx();
      }
    } finally {
      isExecuting.value = false;
    }
  }

  /// Executes a single AI action with appropriate visual delays and audio.
  Future<void> _executeAction(AIAction action) async {
    // Validate unit is still alive and present.
    final unit = _viewModel.board.getUnitById(action.unitId);
    if (unit == null || unit.isDead) return;

    switch (action.type) {
      case AIActionType.move:
        await _executeMove(action);

      case AIActionType.attack:
        await _executeAttack(action);

      case AIActionType.ability:
        await _executeAbility(action);

      case AIActionType.moveAndAttack:
        await _executeMoveAndAttack(action);

      case AIActionType.moveAndAbility:
        await _executeMoveAndAbility(action);

      case AIActionType.wait:
        await _executeWait(action);
    }

    // Clear selection after action completes.
    if (_viewModel.hasSelection) {
      _viewModel.deselectUnit();
    }
  }

  /// Executes a simple move action: select unit, pause, move.
  ///
  /// Uses the engine's A* pathfinding and [AnimationQueue] when the
  /// [FiftyWorldController] is available, otherwise falls back to the
  /// old [AnimationService].
  Future<void> _executeMove(AIAction action) async {
    final unit = _viewModel.board.getUnitById(action.unitId);
    _viewModel.selectUnit(action.unitId);
    await _audio.playSelectSfx();
    await Future<void>.delayed(const Duration(milliseconds: _selectDelayMs));

    if (Get.isRegistered<world_engine.FiftyWorldController>()) {
      final controller = Get.find<world_engine.FiftyWorldController>();
      final grid = Get.find<world_engine.TileGrid>();
      final fromPos = unit?.position;
      if (fromPos != null) {
        final occupied = _viewModel.gameState.value.board.units
            .where((u) => u.isAlive && u.id != action.unitId)
            .map((u) => world_engine.GridPosition(u.position.x, u.position.y))
            .toSet();
        final path = controller.findPath(
          world_engine.GridPosition(fromPos.x, fromPos.y),
          world_engine.GridPosition(action.moveTarget!.x, action.moveTarget!.y),
          grid: grid,
          blocked: occupied,
          diagonal: true,
        );
        _viewModel.moveSelectedUnit(action.moveTarget!);
        await _audio.playMoveSfx();
        if (path != null && path.length > 1) {
          final completer = Completer<void>();
          for (int i = 1; i < path.length; i++) {
            final step = path[i];
            final isLast = i == path.length - 1;
            controller.queueAnimation(world_engine.AnimationEntry(
              execute: () async {
                final entity = controller.getEntityById(action.unitId);
                if (entity == null) return;
                controller.move(entity, step.x.toDouble(), step.y.toDouble());
                await Future<void>.delayed(const Duration(milliseconds: 200));
              },
              onComplete: isLast ? () => completer.complete() : null,
            ));
          }
          await completer.future;
        } else {
          // Direct move: no intermediate path (L-shape, blocked, or adjacent).
          final completer = Completer<void>();
          controller.queueAnimation(world_engine.AnimationEntry(
            execute: () async {
              final entity = controller.getEntityById(action.unitId);
              if (entity == null) return;
              controller.move(entity, action.moveTarget!.x.toDouble(),
                  action.moveTarget!.y.toDouble());
              await Future<void>.delayed(const Duration(milliseconds: 300));
            },
            onComplete: () => completer.complete(),
          ));
          await completer.future;
        }
      } else {
        _viewModel.moveSelectedUnit(action.moveTarget!);
        await _audio.playMoveSfx();
      }
    } else {
      // Fallback: old AnimationService.
      final fromPos = unit?.position;
      final animFuture = (fromPos != null && _animationService != null)
          ? _animationService!
              .playMoveAnimation(action.unitId, fromPos, action.moveTarget!)
          : null;
      _viewModel.moveSelectedUnit(action.moveTarget!);
      await _audio.playMoveSfx();
      if (animFuture != null) await animFuture;
    }
  }

  /// Executes a simple attack action: select unit, pause, attack.
  ///
  /// Uses the engine's attack lunge, floating text, HP update, and defeat
  /// animations when the [FiftyWorldController] is available, otherwise
  /// falls back to the old [AnimationService].
  Future<void> _executeAttack(AIAction action) async {
    final attacker = _viewModel.board.getUnitById(action.unitId);
    final target = _viewModel.board.getUnitById(action.attackTargetId!);
    _viewModel.selectUnit(action.unitId);
    await _audio.playSelectSfx();
    await Future<void>.delayed(const Duration(milliseconds: _selectDelayMs));

    final result = _viewModel.attackUnit(action.attackTargetId!);

    if (Get.isRegistered<world_engine.FiftyWorldController>() &&
        attacker != null &&
        target != null) {
      final controller = Get.find<world_engine.FiftyWorldController>();

      // 1. Attack lunge animation.
      final attackerComp = controller.getComponentById(attacker.id);
      if (attackerComp is world_engine.FiftyMovableComponent) {
        final c = Completer<void>();
        controller.queueAnimation(world_engine.AnimationEntry.timed(
          action: () => attackerComp.attack(),
          duration: const Duration(milliseconds: 400),
          onComplete: () => c.complete(),
        ));
        await c.future;
      }

      // 2. Damage popup + HP bar update.
      if (result.damageDealt != null && result.damageDealt! > 0) {
        final c = Completer<void>();
        controller.queueAnimation(world_engine.AnimationEntry.timed(
          action: () {
            controller.showFloatingText(
              world_engine.GridPosition(target.position.x, target.position.y),
              '-${result.damageDealt}',
              color: const Color(0xFFFFFF00),
              fontSize: 24,
            );
            controller.updateHP(
              target.id,
              target.hp.toDouble() / target.maxHp.toDouble(),
            );
          },
          duration: const Duration(milliseconds: 800),
          onComplete: () => c.complete(),
        ));
        await c.future;
      }

      // 3. Defeat animation (if killed).
      if (result.targetDefeated == true) {
        final targetComp = controller.getComponentById(target.id);
        if (targetComp is world_engine.FiftyMovableComponent) {
          final c = Completer<void>();
          controller.queueAnimation(world_engine.AnimationEntry(
            execute: () async {
              targetComp.die();
              await Future<void>.delayed(const Duration(milliseconds: 600));
            },
            onComplete: () {
              try {
                final e = controller.getEntityById(target.id);
                if (e != null) controller.removeEntity(e);
                controller.removeDecorators(target.id);
              } finally {
                c.complete();
              }
            },
          ));
          await c.future;
        }
      }
    } else {
      // Fallback: old AnimationService.
      final anim = _animationService;
      if (anim != null && attacker != null && target != null) {
        await anim.playAttackAnimation(
            attacker.id, attacker.position, target.position);
        anim.triggerFlash(target.id);
        if (result.damageDealt != null && result.damageDealt! > 0) {
          await anim.playDamagePopup(target.position, result.damageDealt!);
        }
        if (result.targetDefeated == true) {
          await anim.playDefeatAnimation(target.id, target.position);
        }
      }
    }

    await _audio.playAttackSfx();

    if (result.targetDefeated == true && target != null) {
      _audio.announceUnitCaptured(target.type);
    }

    // Check if player's commander is in danger after AI attack.
    final playerCommander = _viewModel.board.playerCommander;
    if (playerCommander != null &&
        playerCommander.isAlive &&
        playerCommander.hp <= 2) {
      _audio.announceCommanderInDanger();
    }
  }

  /// Executes an ability action: select unit, pause, use ability.
  ///
  /// Uses the engine's floating text and defeat animations when the
  /// [FiftyWorldController] is available, otherwise falls back to the
  /// old [AnimationService].
  Future<void> _executeAbility(AIAction action) async {
    final selectedUnit = _viewModel.board.getUnitById(action.unitId);
    final abilityType = selectedUnit?.ability?.type;

    _viewModel.selectUnit(action.unitId);
    await _audio.playSelectSfx();
    await Future<void>.delayed(const Duration(milliseconds: _selectDelayMs));

    final result = _viewModel.useAbility(targetPosition: action.abilityTarget);

    if (Get.isRegistered<world_engine.FiftyWorldController>() &&
        result.damageDealt != null &&
        result.damageDealt! > 0) {
      final controller = Get.find<world_engine.FiftyWorldController>();

      // Damage popup at target position.
      if (action.abilityTarget != null) {
        final c = Completer<void>();
        controller.queueAnimation(world_engine.AnimationEntry.timed(
          action: () {
            controller.showFloatingText(
              world_engine.GridPosition(
                  action.abilityTarget!.x, action.abilityTarget!.y),
              '-${result.damageDealt}',
              color: const Color(0xFFFFFF00),
              fontSize: 24,
            );
          },
          duration: const Duration(milliseconds: 800),
          onComplete: () => c.complete(),
        ));
        await c.future;
      }

      // Defeat animations for any killed units.
      if (result.affectedUnitIds != null) {
        for (final affectedId in result.affectedUnitIds!) {
          final affectedUnit = _viewModel.board.getUnitById(affectedId);
          if (affectedUnit != null && affectedUnit.isDead) {
            final comp = controller.getComponentById(affectedId);
            if (comp is world_engine.FiftyMovableComponent) {
              final c = Completer<void>();
              controller.queueAnimation(world_engine.AnimationEntry(
                execute: () async {
                  comp.die();
                  await Future<void>.delayed(
                      const Duration(milliseconds: 600));
                },
                onComplete: () {
                  try {
                    final entity = controller.getEntityById(affectedId);
                    if (entity != null) controller.removeEntity(entity);
                    controller.removeDecorators(affectedId);
                  } finally {
                    c.complete();
                  }
                },
              ));
              await c.future;
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
        if (action.abilityTarget != null) {
          await anim.playDamagePopup(
              action.abilityTarget!, result.damageDealt!);
        }
        if (result.affectedUnitIds != null) {
          for (final affectedId in result.affectedUnitIds!) {
            final affectedUnit = _viewModel.board.getUnitById(affectedId);
            if (affectedUnit != null && affectedUnit.isDead) {
              await anim.playDefeatAnimation(
                  affectedId, affectedUnit.position);
            }
          }
        }
      }
    }

    await _audio.playAbilitySfx();

    if (abilityType != null) {
      _audio.announceAbilityUsed(abilityType);
    }

    // Track achievement events for ability kills.
    // Use `selectedUnit` captured before useAbility() state mutation.
    final achievements = _achievements;
    if (achievements != null && result.affectedUnitIds != null) {
      for (final affectedId in result.affectedUnitIds!) {
        final affectedUnit = _viewModel.board.getUnitById(affectedId);
        if (affectedUnit != null &&
            affectedUnit.isDead &&
            selectedUnit != null) {
          achievements.trackUnitDefeated(
            attacker: selectedUnit,
            target: affectedUnit,
          );
        }
      }
    }
  }

  /// Executes a move-then-attack combo with sub-step delay.
  ///
  /// Uses engine A* pathfinding for the move and engine attack lunge,
  /// floating text, HP update, and defeat animations for the attack
  /// when the [FiftyWorldController] is available.
  Future<void> _executeMoveAndAttack(AIAction action) async {
    // Step 1: Select and move with animation.
    final unit = _viewModel.board.getUnitById(action.unitId);
    _viewModel.selectUnit(action.unitId);
    await _audio.playSelectSfx();
    await Future<void>.delayed(const Duration(milliseconds: _selectDelayMs));

    if (Get.isRegistered<world_engine.FiftyWorldController>()) {
      final controller = Get.find<world_engine.FiftyWorldController>();
      final grid = Get.find<world_engine.TileGrid>();
      final fromPos = unit?.position;
      if (fromPos != null) {
        final occupied = _viewModel.gameState.value.board.units
            .where((u) => u.isAlive && u.id != action.unitId)
            .map((u) => world_engine.GridPosition(u.position.x, u.position.y))
            .toSet();
        final path = controller.findPath(
          world_engine.GridPosition(fromPos.x, fromPos.y),
          world_engine.GridPosition(action.moveTarget!.x, action.moveTarget!.y),
          grid: grid,
          blocked: occupied,
          diagonal: true,
        );
        _viewModel.moveSelectedUnit(action.moveTarget!);
        await _audio.playMoveSfx();
        if (path != null && path.length > 1) {
          final completer = Completer<void>();
          for (int i = 1; i < path.length; i++) {
            final step = path[i];
            final isLast = i == path.length - 1;
            controller.queueAnimation(world_engine.AnimationEntry(
              execute: () async {
                final entity = controller.getEntityById(action.unitId);
                if (entity == null) return;
                controller.move(entity, step.x.toDouble(), step.y.toDouble());
                await Future<void>.delayed(const Duration(milliseconds: 200));
              },
              onComplete: isLast ? () => completer.complete() : null,
            ));
          }
          await completer.future;
        } else {
          // Direct move: no intermediate path (L-shape, blocked, or adjacent).
          final completer = Completer<void>();
          controller.queueAnimation(world_engine.AnimationEntry(
            execute: () async {
              final entity = controller.getEntityById(action.unitId);
              if (entity == null) return;
              controller.move(entity, action.moveTarget!.x.toDouble(),
                  action.moveTarget!.y.toDouble());
              await Future<void>.delayed(const Duration(milliseconds: 300));
            },
            onComplete: () => completer.complete(),
          ));
          await completer.future;
        }
      } else {
        _viewModel.moveSelectedUnit(action.moveTarget!);
        await _audio.playMoveSfx();
      }
    } else {
      // Fallback: old AnimationService for move.
      final fromPos = unit?.position;
      final moveAnimFuture = (fromPos != null && _animationService != null)
          ? _animationService!
              .playMoveAnimation(action.unitId, fromPos, action.moveTarget!)
          : null;
      _viewModel.moveSelectedUnit(action.moveTarget!);
      await _audio.playMoveSfx();
      if (moveAnimFuture != null) await moveAnimFuture;
    }
    await Future<void>.delayed(const Duration(milliseconds: _subStepDelayMs));

    // Step 2: Re-select and attack with animation.
    final attacker = _viewModel.board.getUnitById(action.unitId);
    final target = _viewModel.board.getUnitById(action.attackTargetId!);
    _viewModel.selectUnit(action.unitId);
    await Future<void>.delayed(const Duration(milliseconds: _selectDelayMs));

    final result = _viewModel.attackUnit(action.attackTargetId!);

    if (Get.isRegistered<world_engine.FiftyWorldController>() &&
        attacker != null &&
        target != null) {
      final controller = Get.find<world_engine.FiftyWorldController>();

      // 1. Attack lunge animation.
      final attackerComp = controller.getComponentById(attacker.id);
      if (attackerComp is world_engine.FiftyMovableComponent) {
        final c = Completer<void>();
        controller.queueAnimation(world_engine.AnimationEntry.timed(
          action: () => attackerComp.attack(),
          duration: const Duration(milliseconds: 400),
          onComplete: () => c.complete(),
        ));
        await c.future;
      }

      // 2. Damage popup + HP bar update.
      if (result.damageDealt != null && result.damageDealt! > 0) {
        final c = Completer<void>();
        controller.queueAnimation(world_engine.AnimationEntry.timed(
          action: () {
            controller.showFloatingText(
              world_engine.GridPosition(target.position.x, target.position.y),
              '-${result.damageDealt}',
              color: const Color(0xFFFFFF00),
              fontSize: 24,
            );
            controller.updateHP(
              target.id,
              target.hp.toDouble() / target.maxHp.toDouble(),
            );
          },
          duration: const Duration(milliseconds: 800),
          onComplete: () => c.complete(),
        ));
        await c.future;
      }

      // 3. Defeat animation (if killed).
      if (result.targetDefeated == true) {
        final targetComp = controller.getComponentById(target.id);
        if (targetComp is world_engine.FiftyMovableComponent) {
          final c = Completer<void>();
          controller.queueAnimation(world_engine.AnimationEntry(
            execute: () async {
              targetComp.die();
              await Future<void>.delayed(const Duration(milliseconds: 600));
            },
            onComplete: () {
              try {
                final e = controller.getEntityById(target.id);
                if (e != null) controller.removeEntity(e);
                controller.removeDecorators(target.id);
              } finally {
                c.complete();
              }
            },
          ));
          await c.future;
        }
      }
    } else {
      // Fallback: old AnimationService for attack.
      final anim = _animationService;
      if (anim != null && attacker != null && target != null) {
        await anim.playAttackAnimation(
            attacker.id, attacker.position, target.position);
        anim.triggerFlash(target.id);
        if (result.damageDealt != null && result.damageDealt! > 0) {
          await anim.playDamagePopup(target.position, result.damageDealt!);
        }
        if (result.targetDefeated == true) {
          await anim.playDefeatAnimation(target.id, target.position);
        }
      }
    }

    await _audio.playAttackSfx();

    if (result.targetDefeated == true && target != null) {
      _audio.announceUnitCaptured(target.type);
    }

    // Check if player's commander is in danger after AI attack.
    final playerCmdr = _viewModel.board.playerCommander;
    if (playerCmdr != null && playerCmdr.isAlive && playerCmdr.hp <= 2) {
      _audio.announceCommanderInDanger();
    }
  }

  /// Executes a move-then-ability combo with sub-step delay.
  ///
  /// Uses engine A* pathfinding for the move and engine floating text
  /// and defeat animations for the ability when the [FiftyWorldController]
  /// is available.
  Future<void> _executeMoveAndAbility(AIAction action) async {
    // Step 1: Select and move with animation.
    final unit = _viewModel.board.getUnitById(action.unitId);
    final abilityType = unit?.ability?.type;
    _viewModel.selectUnit(action.unitId);
    await _audio.playSelectSfx();
    await Future<void>.delayed(const Duration(milliseconds: _selectDelayMs));

    if (Get.isRegistered<world_engine.FiftyWorldController>()) {
      final controller = Get.find<world_engine.FiftyWorldController>();
      final grid = Get.find<world_engine.TileGrid>();
      final fromPos = unit?.position;
      if (fromPos != null) {
        final occupied = _viewModel.gameState.value.board.units
            .where((u) => u.isAlive && u.id != action.unitId)
            .map((u) => world_engine.GridPosition(u.position.x, u.position.y))
            .toSet();
        final path = controller.findPath(
          world_engine.GridPosition(fromPos.x, fromPos.y),
          world_engine.GridPosition(action.moveTarget!.x, action.moveTarget!.y),
          grid: grid,
          blocked: occupied,
          diagonal: true,
        );
        _viewModel.moveSelectedUnit(action.moveTarget!);
        await _audio.playMoveSfx();
        if (path != null && path.length > 1) {
          final completer = Completer<void>();
          for (int i = 1; i < path.length; i++) {
            final step = path[i];
            final isLast = i == path.length - 1;
            controller.queueAnimation(world_engine.AnimationEntry(
              execute: () async {
                final entity = controller.getEntityById(action.unitId);
                if (entity == null) return;
                controller.move(entity, step.x.toDouble(), step.y.toDouble());
                await Future<void>.delayed(const Duration(milliseconds: 200));
              },
              onComplete: isLast ? () => completer.complete() : null,
            ));
          }
          await completer.future;
        } else {
          // Direct move: no intermediate path (L-shape, blocked, or adjacent).
          final completer = Completer<void>();
          controller.queueAnimation(world_engine.AnimationEntry(
            execute: () async {
              final entity = controller.getEntityById(action.unitId);
              if (entity == null) return;
              controller.move(entity, action.moveTarget!.x.toDouble(),
                  action.moveTarget!.y.toDouble());
              await Future<void>.delayed(const Duration(milliseconds: 300));
            },
            onComplete: () => completer.complete(),
          ));
          await completer.future;
        }
      } else {
        _viewModel.moveSelectedUnit(action.moveTarget!);
        await _audio.playMoveSfx();
      }
    } else {
      // Fallback: old AnimationService for move.
      final fromPos = unit?.position;
      final moveAnimFuture = (fromPos != null && _animationService != null)
          ? _animationService!
              .playMoveAnimation(action.unitId, fromPos, action.moveTarget!)
          : null;
      _viewModel.moveSelectedUnit(action.moveTarget!);
      await _audio.playMoveSfx();
      if (moveAnimFuture != null) await moveAnimFuture;
    }
    await Future<void>.delayed(const Duration(milliseconds: _subStepDelayMs));

    // Step 2: Re-select and use ability with animation.
    _viewModel.selectUnit(action.unitId);
    await Future<void>.delayed(const Duration(milliseconds: _selectDelayMs));

    final result = _viewModel.useAbility(targetPosition: action.abilityTarget);

    if (Get.isRegistered<world_engine.FiftyWorldController>() &&
        result.damageDealt != null &&
        result.damageDealt! > 0) {
      final controller = Get.find<world_engine.FiftyWorldController>();

      // Damage popup at target position.
      if (action.abilityTarget != null) {
        final c = Completer<void>();
        controller.queueAnimation(world_engine.AnimationEntry.timed(
          action: () {
            controller.showFloatingText(
              world_engine.GridPosition(
                  action.abilityTarget!.x, action.abilityTarget!.y),
              '-${result.damageDealt}',
              color: const Color(0xFFFFFF00),
              fontSize: 24,
            );
          },
          duration: const Duration(milliseconds: 800),
          onComplete: () => c.complete(),
        ));
        await c.future;
      }

      // Defeat animations for any killed units.
      if (result.affectedUnitIds != null) {
        for (final affectedId in result.affectedUnitIds!) {
          final affectedUnit = _viewModel.board.getUnitById(affectedId);
          if (affectedUnit != null && affectedUnit.isDead) {
            final comp = controller.getComponentById(affectedId);
            if (comp is world_engine.FiftyMovableComponent) {
              final c = Completer<void>();
              controller.queueAnimation(world_engine.AnimationEntry(
                execute: () async {
                  comp.die();
                  await Future<void>.delayed(
                      const Duration(milliseconds: 600));
                },
                onComplete: () {
                  try {
                    final entity = controller.getEntityById(affectedId);
                    if (entity != null) controller.removeEntity(entity);
                    controller.removeDecorators(affectedId);
                  } finally {
                    c.complete();
                  }
                },
              ));
              await c.future;
            }
          }
        }
      }
    } else {
      // Fallback: old AnimationService for ability.
      final anim = _animationService;
      if (anim != null &&
          result.damageDealt != null &&
          result.damageDealt! > 0) {
        if (action.abilityTarget != null) {
          await anim.playDamagePopup(
              action.abilityTarget!, result.damageDealt!);
        }
        if (result.affectedUnitIds != null) {
          for (final affectedId in result.affectedUnitIds!) {
            final affectedUnit = _viewModel.board.getUnitById(affectedId);
            if (affectedUnit != null && affectedUnit.isDead) {
              await anim.playDefeatAnimation(
                  affectedId, affectedUnit.position);
            }
          }
        }
      }
    }

    await _audio.playAbilitySfx();

    if (abilityType != null) {
      _audio.announceAbilityUsed(abilityType);
    }

    // Track achievement events for ability kills.
    // Use `unit` captured before useAbility() state mutation.
    final achievements = _achievements;
    if (achievements != null && result.affectedUnitIds != null) {
      for (final affectedId in result.affectedUnitIds!) {
        final affectedUnit = _viewModel.board.getUnitById(affectedId);
        if (affectedUnit != null && affectedUnit.isDead && unit != null) {
          achievements.trackUnitDefeated(
            attacker: unit,
            target: affectedUnit,
          );
        }
      }
    }
  }

  /// Executes a wait action: select unit briefly, then deselect.
  Future<void> _executeWait(AIAction action) async {
    _viewModel.selectUnit(action.unitId);
    await _audio.playSelectSfx();
    await Future<void>.delayed(const Duration(milliseconds: _selectDelayMs));
    _viewModel.waitUnit();
  }
}
