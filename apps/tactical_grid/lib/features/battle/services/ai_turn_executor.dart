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

import 'package:get/get.dart';

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
      [this._animationService]);

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
  Future<void> _executeMove(AIAction action) async {
    final unit = _viewModel.board.getUnitById(action.unitId);
    _viewModel.selectUnit(action.unitId);
    await _audio.playSelectSfx();
    await Future<void>.delayed(const Duration(milliseconds: _selectDelayMs));

    final fromPos = unit?.position;
    final animFuture = (fromPos != null && _animationService != null)
        ? _animationService!.playMoveAnimation(action.unitId, fromPos, action.moveTarget!)
        : null;
    _viewModel.moveSelectedUnit(action.moveTarget!);
    await _audio.playMoveSfx();
    if (animFuture != null) await animFuture;
  }

  /// Executes a simple attack action: select unit, pause, attack.
  Future<void> _executeAttack(AIAction action) async {
    final attacker = _viewModel.board.getUnitById(action.unitId);
    final target = _viewModel.board.getUnitById(action.attackTargetId!);
    _viewModel.selectUnit(action.unitId);
    await _audio.playSelectSfx();
    await Future<void>.delayed(const Duration(milliseconds: _selectDelayMs));

    final result = _viewModel.attackUnit(action.attackTargetId!);

    final anim = _animationService;
    if (anim != null && attacker != null && target != null) {
      await anim.playAttackAnimation(attacker.id, attacker.position, target.position);
      anim.triggerFlash(target.id);
      if (result.damageDealt != null && result.damageDealt! > 0) {
        await anim.playDamagePopup(target.position, result.damageDealt!);
      }
      if (result.targetDefeated == true) {
        await anim.playDefeatAnimation(target.id, target.position);
      }
    }

    await _audio.playAttackSfx();
  }

  /// Executes an ability action: select unit, pause, use ability.
  Future<void> _executeAbility(AIAction action) async {
    _viewModel.selectUnit(action.unitId);
    await _audio.playSelectSfx();
    await Future<void>.delayed(const Duration(milliseconds: _selectDelayMs));

    final result = _viewModel.useAbility(targetPosition: action.abilityTarget);

    final anim = _animationService;
    if (anim != null && result.damageDealt != null && result.damageDealt! > 0) {
      if (action.abilityTarget != null) {
        await anim.playDamagePopup(action.abilityTarget!, result.damageDealt!);
      }
      if (result.affectedUnitIds != null) {
        for (final affectedId in result.affectedUnitIds!) {
          final affectedUnit = _viewModel.board.getUnitById(affectedId);
          if (affectedUnit != null && affectedUnit.isDead) {
            await anim.playDefeatAnimation(affectedId, affectedUnit.position);
          }
        }
      }
    }

    await _audio.playAbilitySfx();
  }

  /// Executes a move-then-attack combo with sub-step delay.
  Future<void> _executeMoveAndAttack(AIAction action) async {
    // Step 1: Select and move with animation.
    final unit = _viewModel.board.getUnitById(action.unitId);
    _viewModel.selectUnit(action.unitId);
    await _audio.playSelectSfx();
    await Future<void>.delayed(const Duration(milliseconds: _selectDelayMs));

    final fromPos = unit?.position;
    final moveAnimFuture = (fromPos != null && _animationService != null)
        ? _animationService!.playMoveAnimation(action.unitId, fromPos, action.moveTarget!)
        : null;
    _viewModel.moveSelectedUnit(action.moveTarget!);
    await _audio.playMoveSfx();
    if (moveAnimFuture != null) await moveAnimFuture;
    await Future<void>.delayed(const Duration(milliseconds: _subStepDelayMs));

    // Step 2: Re-select and attack with animation.
    final attacker = _viewModel.board.getUnitById(action.unitId);
    final target = _viewModel.board.getUnitById(action.attackTargetId!);
    _viewModel.selectUnit(action.unitId);
    await Future<void>.delayed(const Duration(milliseconds: _selectDelayMs));

    final result = _viewModel.attackUnit(action.attackTargetId!);

    final anim = _animationService;
    if (anim != null && attacker != null && target != null) {
      await anim.playAttackAnimation(attacker.id, attacker.position, target.position);
      anim.triggerFlash(target.id);
      if (result.damageDealt != null && result.damageDealt! > 0) {
        await anim.playDamagePopup(target.position, result.damageDealt!);
      }
      if (result.targetDefeated == true) {
        await anim.playDefeatAnimation(target.id, target.position);
      }
    }

    await _audio.playAttackSfx();
  }

  /// Executes a move-then-ability combo with sub-step delay.
  Future<void> _executeMoveAndAbility(AIAction action) async {
    // Step 1: Select and move with animation.
    final unit = _viewModel.board.getUnitById(action.unitId);
    _viewModel.selectUnit(action.unitId);
    await _audio.playSelectSfx();
    await Future<void>.delayed(const Duration(milliseconds: _selectDelayMs));

    final fromPos = unit?.position;
    final moveAnimFuture = (fromPos != null && _animationService != null)
        ? _animationService!.playMoveAnimation(action.unitId, fromPos, action.moveTarget!)
        : null;
    _viewModel.moveSelectedUnit(action.moveTarget!);
    await _audio.playMoveSfx();
    if (moveAnimFuture != null) await moveAnimFuture;
    await Future<void>.delayed(const Duration(milliseconds: _subStepDelayMs));

    // Step 2: Re-select and use ability with animation.
    _viewModel.selectUnit(action.unitId);
    await Future<void>.delayed(const Duration(milliseconds: _selectDelayMs));

    final result = _viewModel.useAbility(targetPosition: action.abilityTarget);

    final anim = _animationService;
    if (anim != null && result.damageDealt != null && result.damageDealt! > 0) {
      if (action.abilityTarget != null) {
        await anim.playDamagePopup(action.abilityTarget!, result.damageDealt!);
      }
      if (result.affectedUnitIds != null) {
        for (final affectedId in result.affectedUnitIds!) {
          final affectedUnit = _viewModel.board.getUnitById(affectedId);
          if (affectedUnit != null && affectedUnit.isDead) {
            await anim.playDefeatAnimation(affectedId, affectedUnit.position);
          }
        }
      }
    }

    await _audio.playAbilitySfx();
  }

  /// Executes a wait action: select unit briefly, then deselect.
  Future<void> _executeWait(AIAction action) async {
    _viewModel.selectUnit(action.unitId);
    await _audio.playSelectSfx();
    await Future<void>.delayed(const Duration(milliseconds: _selectDelayMs));
    _viewModel.waitUnit();
  }
}
