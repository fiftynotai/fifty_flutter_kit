/// AI Service
///
/// Stateless service that decides actions for enemy AI units based on
/// the current game state and selected difficulty level.
///
/// This service receives state, evaluates options, and returns a list of
/// [AIAction] decisions. It does NOT mutate the real game state -- that
/// responsibility belongs to the game controller.
///
/// **Usage:**
/// ```dart
/// final aiService = AIService();
/// final actions = aiService.decideActions(gameState, AIDifficulty.medium);
/// // Execute each action through GameLogicService...
/// ```
library;

import 'dart:math';

import 'package:tactical_grid/features/battle/models/models.dart';

/// Stateless AI decision-making service for the tactical battle system.
///
/// Implements three difficulty levels:
/// - **Easy:** Random valid moves with no tactical awareness.
/// - **Medium:** Prioritizes attacking low-HP targets and moves toward threats.
/// - **Hard:** Score-based evaluation considering damage, safety, and combos.
///
/// **Architecture Note:**
/// This is a SERVICE layer component. It is stateless and deterministic
/// (when given a seeded [Random]). The game controller executes the
/// returned actions through [GameLogicService].
class AIService {
  /// Creates a new [AIService] instance.
  const AIService();

  /// Decides actions for all alive enemy units based on difficulty.
  ///
  /// Returns a list of [AIAction], one per alive enemy unit. The order
  /// of actions reflects the execution order (which varies by difficulty).
  ///
  /// **Parameters:**
  /// - [state]: The current game state (enemy turn expected).
  /// - [difficulty]: The AI difficulty level to use.
  /// - [random]: Optional [Random] instance for deterministic testing.
  ///
  /// **Returns:**
  /// A list of [AIAction] decisions, one per alive enemy unit.
  List<AIAction> decideActions(
    GameState state,
    AIDifficulty difficulty, {
    Random? random,
  }) {
    final rng = random ?? Random();
    switch (difficulty) {
      case AIDifficulty.easy:
        return _decideEasy(state, rng);
      case AIDifficulty.medium:
        return _decideMedium(state);
      case AIDifficulty.hard:
        return _decideHard(state);
    }
  }

  // ---------------------------------------------------------------------------
  // Easy Algorithm
  // ---------------------------------------------------------------------------

  /// Easy AI: random valid actions with no tactical awareness.
  ///
  /// For each alive enemy unit (shuffled order):
  /// 1. If has attack targets: 50% attack random target, 50% skip.
  /// 2. Else if has valid moves: move to random position.
  /// 3. Else: wait.
  List<AIAction> _decideEasy(GameState state, Random rng) {
    final enemies = List<Unit>.from(state.board.enemyUnits)..shuffle(rng);
    final actions = <AIAction>[];

    for (final unit in enemies) {
      final attackTargets = state.board.getAttackTargets(unit);

      if (attackTargets.isNotEmpty) {
        // 50% chance to attack, 50% chance to skip.
        if (rng.nextBool()) {
          final target = attackTargets[rng.nextInt(attackTargets.length)];
          actions.add(AIAction.attack(unit.id, target.id));
        } else {
          actions.add(AIAction.wait(unit.id));
        }
      } else {
        final validMoves = state.board.getValidMoves(unit);
        if (validMoves.isNotEmpty) {
          final target = validMoves[rng.nextInt(validMoves.length)];
          actions.add(AIAction.move(unit.id, target));
        } else {
          actions.add(AIAction.wait(unit.id));
        }
      }
    }

    return actions;
  }

  // ---------------------------------------------------------------------------
  // Medium Algorithm
  // ---------------------------------------------------------------------------

  /// Medium AI: prioritizes attacking low-HP targets and moves toward threats.
  ///
  /// Unit order: ranged units first (archer/mage), then melee, commander last.
  /// For each unit:
  /// 1. Attack lowest-HP enemy if in range.
  /// 2. Use ability if ready and has targets.
  /// 3. Move toward nearest player unit (with moveAndAttack if possible).
  /// 4. Wait if nothing else.
  List<AIAction> _decideMedium(GameState state) {
    final enemies = _sortForMedium(state.board.enemyUnits);
    final actions = <AIAction>[];

    for (final unit in enemies) {
      final action = _decideMediumUnit(state, unit);
      actions.add(action);
    }

    return actions;
  }

  /// Sort enemy units for medium AI: ranged first, melee next, commander last.
  List<Unit> _sortForMedium(List<Unit> units) {
    final sorted = List<Unit>.from(units);
    sorted.sort((a, b) {
      final aOrder = _mediumUnitOrder(a);
      final bOrder = _mediumUnitOrder(b);
      return aOrder.compareTo(bOrder);
    });
    return sorted;
  }

  /// Priority order for medium AI unit processing.
  int _mediumUnitOrder(Unit unit) {
    return switch (unit.type) {
      UnitType.archer || UnitType.mage => 0,
      UnitType.knight || UnitType.shield || UnitType.scout => 1,
      UnitType.commander => 2,
    };
  }

  /// Decide action for a single unit under medium AI.
  AIAction _decideMediumUnit(GameState state, Unit unit) {
    final board = state.board;

    // 1. If has attack targets, pick the lowest-HP enemy.
    final attackTargets = board.getAttackTargets(unit);
    if (attackTargets.isNotEmpty) {
      final target = _lowestHpUnit(attackTargets);
      return AIAction.attack(unit.id, target.id);
    }

    // 2. If ability is ready and has targets, use ability.
    final abilityAction = _tryMediumAbility(state, unit);
    if (abilityAction != null) return abilityAction;

    // 3. Move toward nearest player unit.
    final validMoves = board.getValidMoves(unit);
    if (validMoves.isNotEmpty) {
      final nearest = _nearestPlayerUnit(board, unit.position);
      if (nearest != null) {
        // Pick the move position that minimizes distance to nearest player unit.
        final bestMove = _closestMoveTo(validMoves, nearest.position);

        // Check if after moving, there are attack targets (moveAndAttack).
        final postMoveAttacks = _attackTargetsFromPosition(
          board,
          unit,
          bestMove,
        );
        if (postMoveAttacks.isNotEmpty) {
          final target = _lowestHpUnit(postMoveAttacks);
          return AIAction.moveAndAttack(unit.id, bestMove, target.id);
        }

        return AIAction.move(unit.id, bestMove);
      }

      // No player units to move toward, just pick first valid move.
      return AIAction.move(unit.id, validMoves.first);
    }

    // 4. No options available.
    return AIAction.wait(unit.id);
  }

  /// Try to use an ability for medium AI. Returns null if no ability to use.
  AIAction? _tryMediumAbility(GameState state, Unit unit) {
    final board = state.board;
    final ability = unit.ability;
    if (ability == null || !ability.isReady || ability.isPassive) return null;

    switch (ability.type) {
      case AbilityType.shoot:
        // Shoot: target the lowest-HP enemy at range.
        final abilityTargets = board.getAbilityTargets(unit);
        if (abilityTargets.isEmpty) return null;
        // Find actual enemy units at those positions.
        Unit? bestTarget;
        for (final pos in abilityTargets) {
          final target = board.getUnitAt(pos);
          if (target != null &&
              target.isPlayer &&
              (bestTarget == null || target.hp < bestTarget.hp)) {
            bestTarget = target;
          }
        }
        if (bestTarget != null) {
          return AIAction.ability(
            unit.id,
            AbilityType.shoot,
            target: bestTarget.position,
          );
        }
        return null;

      case AbilityType.fireball:
        // Fireball: target the position with most enemy (player) units in 3x3.
        final abilityTargets = board.getAbilityTargets(unit);
        if (abilityTargets.isEmpty) return null;
        GridPosition? bestPos;
        int bestScore = 0;
        for (final pos in abilityTargets) {
          final score = _fireballScore(board, pos, true);
          if (score > bestScore) {
            bestScore = score;
            bestPos = pos;
          }
        }
        if (bestPos != null && bestScore > 0) {
          return AIAction.ability(
            unit.id,
            AbilityType.fireball,
            target: bestPos,
          );
        }
        return null;

      case AbilityType.block:
        // Block: use if HP is less than 50% of maxHP.
        if (unit.hp < unit.maxHp * 0.5) {
          return AIAction.ability(unit.id, AbilityType.block);
        }
        return null;

      case AbilityType.rally:
        // Rally: use if 2+ adjacent allies.
        final adjacentAllies = unit.position
            .getAdjacentPositions()
            .where((pos) {
              final ally = board.getUnitAt(pos);
              return ally != null && !ally.isPlayer && ally.id != unit.id;
            })
            .length;
        if (adjacentAllies >= 2) {
          return AIAction.ability(unit.id, AbilityType.rally);
        }
        return null;

      case AbilityType.charge:
        // Passive -- never manually triggered.
        return null;

      case AbilityType.reveal:
        // Not tactically useful for AI.
        return null;
    }
  }

  // ---------------------------------------------------------------------------
  // Hard Algorithm
  // ---------------------------------------------------------------------------

  /// Hard AI: score-based evaluation with iterative commitment.
  ///
  /// Process units iteratively: score all units, commit the best action,
  /// re-score remaining units against updated board state. Considers damage
  /// output, target priority, safety, and ability combos.
  List<AIAction> _decideHard(GameState state) {
    final actions = <AIAction>[];
    // Work on a deep copy so we can simulate commitments.
    var workingState = state.copyWith(
      board: state.board.copyWith(),
    );

    final remainingUnitIds =
        workingState.board.enemyUnits.map((u) => u.id).toList();

    while (remainingUnitIds.isNotEmpty) {
      _ScoredAction? bestOverall;

      for (final unitId in remainingUnitIds) {
        final unit = _findUnit(workingState.board, unitId);
        if (unit == null) continue;

        final scored = _scoreAllOptions(workingState, unit);
        if (scored != null &&
            (bestOverall == null || scored.score > bestOverall.score)) {
          bestOverall = scored;
        }
      }

      if (bestOverall != null) {
        actions.add(bestOverall.action);
        remainingUnitIds.remove(bestOverall.action.unitId);

        // Commit: simulate the action on the working state.
        workingState = _simulateAction(workingState, bestOverall.action);
      } else {
        // All remaining units get wait actions.
        for (final unitId in remainingUnitIds) {
          actions.add(AIAction.wait(unitId));
        }
        break;
      }
    }

    return actions;
  }

  /// Score all possible action combinations for a single unit.
  ///
  /// Evaluates staying in place + moving to each valid position,
  /// and for each position evaluates attacks and abilities available.
  _ScoredAction? _scoreAllOptions(GameState state, Unit unit) {
    final board = state.board;
    _ScoredAction? best;

    // Collect all positions to evaluate: current position + all valid moves.
    final positions = <GridPosition>[unit.position];
    final validMoves = board.getValidMoves(unit);
    positions.addAll(validMoves);

    for (final pos in positions) {
      final didMove = pos != unit.position;

      // Evaluate attacks from this position.
      final attacksFromPos = _attackTargetsFromPosition(board, unit, pos);
      for (final target in attacksFromPos) {
        int score = _scoreAttack(unit, target, didMove, pos, board);
        final action = didMove
            ? AIAction.moveAndAttack(unit.id, pos, target.id)
            : AIAction.attack(unit.id, target.id);
        // Apply position safety penalty.
        score += _safetyScore(board, unit, pos);
        if (best == null || score > best.score) {
          best = _ScoredAction(action, score);
        }
      }

      // Evaluate abilities from this position.
      final abilityAction = _scoreAbilityFromPosition(
        state,
        unit,
        pos,
        didMove,
        board,
      );
      if (abilityAction != null) {
        int score = abilityAction.score + _safetyScore(board, unit, pos);
        if (best == null || score > best.score) {
          best = _ScoredAction(abilityAction.action, score);
        }
      }

      // Evaluate just moving (no attack/ability).
      if (didMove) {
        int score = _safetyScore(board, unit, pos);
        // Small incentive to move toward enemies.
        final nearest = _nearestPlayerUnit(board, pos);
        if (nearest != null) {
          final currentDist = _manhattanDistance(unit.position, nearest.position);
          final newDist = _manhattanDistance(pos, nearest.position);
          score += (currentDist - newDist); // positive if moving closer
        }
        final action = AIAction.move(unit.id, pos);
        if (best == null || score > best.score) {
          best = _ScoredAction(action, score);
        }
      }
    }

    // Evaluate waiting (staying put, doing nothing).
    {
      int score = _safetyScore(board, unit, unit.position);
      final waitAction = AIAction.wait(unit.id);
      if (best == null || score > best.score) {
        best = _ScoredAction(waitAction, score);
      }
    }

    return best;
  }

  /// Score an attack action.
  int _scoreAttack(
    Unit attacker,
    Unit target,
    bool didMove,
    GridPosition fromPos,
    BoardState board,
  ) {
    int damage = attacker.effectiveAttack;

    // Knight Charge: +2 damage if moved this turn.
    if (attacker.type == UnitType.knight && didMove) {
      damage += 2;
    }

    // Shield Block: 50% damage reduction (rounded up).
    if (target.isBlocking) {
      damage = (damage / 2).ceil();
    }

    int score = damage * 10; // +10 per damage dealt

    // Commander target bonus.
    if (target.type == UnitType.commander) {
      score += 5;
    }

    // Kill bonuses.
    if (target.hp <= damage) {
      score += 15; // +15 for killing a unit
      if (target.type == UnitType.commander) {
        score += 25; // +25 for killing Commander (total +40)
      }
    }

    // Knight charge combo bonus.
    if (attacker.type == UnitType.knight && didMove) {
      score += 4;
    }

    return score;
  }

  /// Score ability usage from a given position.
  _ScoredAction? _scoreAbilityFromPosition(
    GameState state,
    Unit unit,
    GridPosition pos,
    bool didMove,
    BoardState board,
  ) {
    final ability = unit.ability;
    if (ability == null || !ability.isReady || ability.isPassive) return null;

    switch (ability.type) {
      case AbilityType.shoot:
        // Find best shoot target from position.
        final shootTargets = _getShootTargetsFromPosition(board, unit, pos);
        _ScoredAction? best;
        for (final targetPos in shootTargets) {
          final target = board.getUnitAt(targetPos);
          if (target == null || !target.isPlayer) continue;
          int score = unit.effectiveAttack * 10;
          if (target.type == UnitType.commander) score += 5;
          if (target.hp <= unit.effectiveAttack) {
            score += 15;
            if (target.type == UnitType.commander) score += 25;
          }
          final action = didMove
              ? AIAction.moveAndAbility(
                  unit.id, pos, AbilityType.shoot,
                  abilityTarget: targetPos)
              : AIAction.ability(unit.id, AbilityType.shoot, target: targetPos);
          if (best == null || score > best.score) {
            best = _ScoredAction(action, score);
          }
        }
        return best;

      case AbilityType.fireball:
        // Find best fireball target from position.
        final fireballPositions = pos.getPositionsInRadius(3);
        _ScoredAction? best;
        for (final targetPos in fireballPositions) {
          final playerHits = _fireballScore(board, targetPos, true);
          final friendlyHits = _fireballScore(board, targetPos, false);
          if (playerHits == 0) continue;
          // +8 per extra unit hit beyond the first.
          int score = 10 + (playerHits - 1) * 8;
          // Penalize hitting friendlies.
          score -= friendlyHits * 5;
          // Check for commander kills.
          final affected = board.units.where((u) {
            if (!u.isAlive) return false;
            final dx = (u.position.x - targetPos.x).abs();
            final dy = (u.position.y - targetPos.y).abs();
            return dx <= 1 && dy <= 1;
          });
          for (final u in affected) {
            if (u.isPlayer && u.hp <= 1) {
              score += 15;
              if (u.type == UnitType.commander) score += 25;
            }
          }
          final action = didMove
              ? AIAction.moveAndAbility(
                  unit.id, pos, AbilityType.fireball,
                  abilityTarget: targetPos)
              : AIAction.ability(
                  unit.id, AbilityType.fireball, target: targetPos);
          if (best == null || score > best.score) {
            best = _ScoredAction(action, score);
          }
        }
        return best;

      case AbilityType.block:
        // +2 for Block when HP < 60% of maxHP.
        if (unit.hp < unit.maxHp * 0.6) {
          final action = didMove
              ? AIAction.moveAndAbility(unit.id, pos, AbilityType.block)
              : AIAction.ability(unit.id, AbilityType.block);
          return _ScoredAction(action, 2);
        }
        return null;

      case AbilityType.rally:
        // +3 per ally buffed.
        final adjacentAllies = pos.getAdjacentPositions().where((adjPos) {
          final ally = board.getUnitAt(adjPos);
          return ally != null && !ally.isPlayer && ally.id != unit.id;
        }).length;
        if (adjacentAllies > 0) {
          final action = didMove
              ? AIAction.moveAndAbility(unit.id, pos, AbilityType.rally)
              : AIAction.ability(unit.id, AbilityType.rally);
          return _ScoredAction(action, adjacentAllies * 3);
        }
        return null;

      case AbilityType.charge:
        // Passive -- handled in attack scoring.
        return null;

      case AbilityType.reveal:
        return null;
    }
  }

  /// Safety score modifier based on position.
  int _safetyScore(BoardState board, Unit unit, GridPosition pos) {
    final adjacentEnemies = _adjacentEnemyCount(board, pos, true);
    int score = 0;

    // -5 if ending adjacent to 2+ player units.
    if (adjacentEnemies >= 2) {
      score -= 5;
    }

    // -10 if unit is Commander and ending adjacent to any player unit.
    if (unit.type == UnitType.commander && adjacentEnemies > 0) {
      score -= 10;
    }

    return score;
  }

  /// Simulate an action on a working copy of the game state.
  ///
  /// Used by hard AI to commit actions and re-evaluate remaining units
  /// against the updated board. Only simulates movement and basic effects.
  GameState _simulateAction(GameState state, AIAction action) {
    final board = state.board;
    final unit = _findUnit(board, action.unitId);
    if (unit == null) return state;

    switch (action.type) {
      case AIActionType.move:
        if (action.moveTarget != null) {
          unit.position = action.moveTarget!;
          unit.hasMovedThisTurn = true;
        }
      case AIActionType.attack:
        if (action.attackTargetId != null) {
          final target = _findUnit(board, action.attackTargetId!);
          if (target != null) {
            int damage = unit.effectiveAttack;
            if (target.isBlocking) damage = (damage / 2).ceil();
            target.takeDamage(damage);
          }
          unit.hasActedThisTurn = true;
        }
      case AIActionType.moveAndAttack:
        if (action.moveTarget != null) {
          unit.position = action.moveTarget!;
          unit.hasMovedThisTurn = true;
        }
        if (action.attackTargetId != null) {
          final target = _findUnit(board, action.attackTargetId!);
          if (target != null) {
            int damage = unit.effectiveAttack;
            if (unit.type == UnitType.knight) damage += 2; // Charge bonus
            if (target.isBlocking) damage = (damage / 2).ceil();
            target.takeDamage(damage);
          }
          unit.hasActedThisTurn = true;
        }
      case AIActionType.ability:
        unit.hasActedThisTurn = true;
      case AIActionType.moveAndAbility:
        if (action.moveTarget != null) {
          unit.position = action.moveTarget!;
          unit.hasMovedThisTurn = true;
        }
        unit.hasActedThisTurn = true;
      case AIActionType.wait:
        unit.hasMovedThisTurn = true;
        unit.hasActedThisTurn = true;
    }

    return state;
  }

  // ---------------------------------------------------------------------------
  // Helper Methods
  // ---------------------------------------------------------------------------

  /// Manhattan distance between two positions.
  int _manhattanDistance(GridPosition a, GridPosition b) {
    return (a.x - b.x).abs() + (a.y - b.y).abs();
  }

  /// Chebyshev distance between two positions.
  int _chebyshevDistance(GridPosition a, GridPosition b) {
    final dx = (a.x - b.x).abs();
    final dy = (a.y - b.y).abs();
    return dx > dy ? dx : dy;
  }

  /// Count player units adjacent to a position.
  ///
  /// When [isPlayer] is true, counts player units (enemies of AI).
  /// When [isPlayer] is false, counts enemy (AI) units.
  int _adjacentEnemyCount(BoardState board, GridPosition pos, bool isPlayer) {
    final adjacent = pos.getAdjacentPositions();
    int count = 0;
    for (final adjPos in adjacent) {
      final unit = board.getUnitAt(adjPos);
      if (unit != null && unit.isPlayer == isPlayer) {
        count++;
      }
    }
    return count;
  }

  /// Find the nearest player unit to a position.
  Unit? _nearestPlayerUnit(BoardState board, GridPosition pos) {
    Unit? nearest;
    int nearestDist = 999;
    for (final unit in board.playerUnits) {
      final dist = _manhattanDistance(pos, unit.position);
      if (dist < nearestDist) {
        nearestDist = dist;
        nearest = unit;
      }
    }
    return nearest;
  }

  /// Score a fireball target position: count units of a given side in 3x3.
  ///
  /// When [isPlayer] is true, counts player units. When false, counts enemy units.
  int _fireballScore(BoardState board, GridPosition center, bool isPlayer) {
    int count = 0;
    for (final unit in board.units) {
      if (!unit.isAlive || unit.isPlayer != isPlayer) continue;
      final dx = (unit.position.x - center.x).abs();
      final dy = (unit.position.y - center.y).abs();
      if (dx <= 1 && dy <= 1) count++;
    }
    return count;
  }

  /// Find the unit with the lowest HP from a list.
  Unit _lowestHpUnit(List<Unit> units) {
    return units.reduce((a, b) => a.hp <= b.hp ? a : b);
  }

  /// Pick the move position from [moves] that is closest to [target].
  GridPosition _closestMoveTo(List<GridPosition> moves, GridPosition target) {
    GridPosition best = moves.first;
    int bestDist = _manhattanDistance(best, target);
    for (final move in moves.skip(1)) {
      final dist = _manhattanDistance(move, target);
      if (dist < bestDist) {
        bestDist = dist;
        best = move;
      }
    }
    return best;
  }

  /// Get attack targets as if a unit were at a hypothetical position.
  ///
  /// Checks for adjacent enemy (player) units from the given position.
  List<Unit> _attackTargetsFromPosition(
    BoardState board,
    Unit unit,
    GridPosition pos,
  ) {
    final adjacent = pos.getAdjacentPositions().toSet();
    return board.units
        .where((u) =>
            u.isAlive &&
            u.isPlayer != unit.isPlayer &&
            adjacent.contains(u.position))
        .toList();
  }

  /// Get shoot ability targets from a hypothetical position.
  ///
  /// Returns positions of enemy units within Chebyshev distance 2-3.
  List<GridPosition> _getShootTargetsFromPosition(
    BoardState board,
    Unit unit,
    GridPosition pos,
  ) {
    return board.units
        .where((target) =>
            target.isAlive &&
            target.isPlayer != unit.isPlayer &&
            _chebyshevDistance(pos, target.position) >= 2 &&
            _chebyshevDistance(pos, target.position) <= 3)
        .map((target) => target.position)
        .toList();
  }

  /// Find a unit by ID in a board state.
  Unit? _findUnit(BoardState board, String unitId) {
    for (final unit in board.units) {
      if (unit.id == unitId) return unit;
    }
    return null;
  }
}

/// Internal scored action for hard AI evaluation.
class _ScoredAction {
  /// The AI action being scored.
  final AIAction action;

  /// Numerical score (higher is better).
  final int score;

  const _ScoredAction(this.action, this.score);
}
