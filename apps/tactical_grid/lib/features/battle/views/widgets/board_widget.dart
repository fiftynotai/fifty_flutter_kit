/// **BoardWidget**
///
/// Renders the 8x8 tactical grid board as a Flutter [GridView]. Each cell
/// is a [_BoardTile] widget that displays:
///
/// - Alternating dark/light tile colours (from [AppTheme]).
/// - Unit placeholder icons (coloured circle with type initial).
/// - Green overlay for valid move destinations.
/// - Red overlay for attack target positions.
/// - Cream border glow for the currently selected unit.
///
/// **Architecture Note:**
/// This is a simple Flutter grid implementation for the MVP. It can be
/// swapped to use `fifty_map_engine` in a later iteration without changing
/// the data flow -- the widget only reads from [BattleViewModel] and
/// delegates taps to [BattleActions].
///
/// **Sizing:**
/// A [LayoutBuilder] measures available space and computes the tile size
/// so the board is always square and centered within the available area.
///
/// **Usage:**
/// ```dart
/// const Expanded(child: BoardWidget());
/// ```
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../actions/battle_actions.dart';
import '../../controllers/battle_view_model.dart';
import '../../models/models.dart';

/// The 8x8 tactical game board.
///
/// Uses [GetView] to automatically resolve [BattleViewModel]. The entire
/// grid rebuilds via a single [Obx] wrapper that watches [gameState].
class BoardWidget extends GetView<BattleViewModel> {
  /// Creates a [BoardWidget].
  const BoardWidget({super.key});

  /// Board dimension (8 tiles per side).
  static const int _boardSize = GridPosition.boardSize;

  @override
  Widget build(BuildContext context) {
    final actions = Get.find<BattleActions>();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Compute the largest square that fits in the available space,
        // using the smaller of width and height.
        final availableSize = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;
        final tileSize = availableSize / _boardSize;

        return Center(
          child: SizedBox(
            width: tileSize * _boardSize,
            height: tileSize * _boardSize,
            child: Obx(() {
              final state = controller.gameState.value;
              final selectedUnit = state.selectedUnit;
              final validMoves = state.validMoves.toSet();

              // Build a set of positions that are attack targets for quick
              // lookup inside the tile builder.
              final attackPositions = <GridPosition>{};
              for (final target in state.attackTargets) {
                attackPositions.add(target.position);
              }

              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _boardSize,
                ),
                itemCount: _boardSize * _boardSize,
                itemBuilder: (context, index) {
                  final x = index % _boardSize;
                  final y = index ~/ _boardSize;
                  final position = GridPosition(x, y);
                  final unitAtPos = state.board.getUnitAt(position);

                  final isSelected = selectedUnit != null &&
                      selectedUnit.position == position;
                  final isValidMove = validMoves.contains(position);
                  final isAttackTarget = attackPositions.contains(position);

                  return _BoardTile(
                    position: position,
                    unit: unitAtPos,
                    isValidMove: isValidMove,
                    isAttackTarget: isAttackTarget,
                    isSelected: isSelected,
                    tileSize: tileSize,
                    onTap: () => actions.onTileTapped(context, position),
                  );
                },
              );
            }),
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// Board Tile
// ---------------------------------------------------------------------------

/// A single cell on the 8x8 board.
///
/// Renders the tile background, optional overlays for move/attack highlights,
/// a selection border, and a unit placeholder sprite when occupied.
class _BoardTile extends StatelessWidget {
  /// Grid position of this tile.
  final GridPosition position;

  /// The unit occupying this tile, or `null` if empty.
  final Unit? unit;

  /// Whether this tile is a valid move destination for the selected unit.
  final bool isValidMove;

  /// Whether this tile contains a unit that is a valid attack target.
  final bool isAttackTarget;

  /// Whether this tile contains the currently selected unit.
  final bool isSelected;

  /// Side length of the tile in logical pixels.
  final double tileSize;

  /// Callback when the tile is tapped.
  final VoidCallback onTap;

  const _BoardTile({
    required this.position,
    required this.unit,
    required this.isValidMove,
    required this.isAttackTarget,
    required this.isSelected,
    required this.tileSize,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Checkerboard pattern: even sum = dark tile, odd sum = light tile.
    final isDarkTile = (position.x + position.y) % 2 == 0;
    final baseColor = isDarkTile ? AppTheme.boardDark : AppTheme.boardLight;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: tileSize,
        height: tileSize,
        decoration: BoxDecoration(
          color: baseColor,
          border: isSelected
              ? Border.all(
                  color: AppTheme.selectionColor,
                  width: 2,
                )
              : null,
        ),
        child: Stack(
          children: [
            // Valid move overlay.
            if (isValidMove)
              Positioned.fill(
                child: Container(
                  color: AppTheme.validMoveColor.withAlpha(102), // ~40%
                ),
              ),

            // Attack target overlay.
            if (isAttackTarget)
              Positioned.fill(
                child: Container(
                  color: AppTheme.attackRangeColor.withAlpha(102), // ~40%
                ),
              ),

            // Valid move dot indicator (when tile is empty).
            if (isValidMove && unit == null)
              Center(
                child: Container(
                  width: tileSize * 0.25,
                  height: tileSize * 0.25,
                  decoration: BoxDecoration(
                    color: AppTheme.validMoveColor.withAlpha(180),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

            // Unit sprite placeholder.
            if (unit != null)
              Center(
                child: _TileUnitSprite(
                  unit: unit!,
                  tileSize: tileSize,
                  isAttackTarget: isAttackTarget,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tile Unit Sprite
// ---------------------------------------------------------------------------

/// Placeholder unit sprite rendered as a coloured circle with the unit type
/// initial letter.
///
/// - Player units use [AppTheme.playerColor] (burgundy).
/// - Enemy units use [AppTheme.enemyColor] (slate grey).
/// - Attack targets receive a pulsing border in [AppTheme.attackRangeColor].
class _TileUnitSprite extends StatelessWidget {
  /// The unit to render.
  final Unit unit;

  /// Size of the containing tile (used to scale the sprite).
  final double tileSize;

  /// Whether this unit is an active attack target.
  final bool isAttackTarget;

  const _TileUnitSprite({
    required this.unit,
    required this.tileSize,
    required this.isAttackTarget,
  });

  @override
  Widget build(BuildContext context) {
    final spriteSize = tileSize * 0.7;
    final color = unit.isPlayer ? AppTheme.playerColor : AppTheme.enemyColor;

    final initial = switch (unit.type) {
      UnitType.commander => 'C',
      UnitType.knight => 'K',
      UnitType.shield => 'S',
    };

    return Container(
      width: spriteSize,
      height: spriteSize,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: isAttackTarget
              ? AppTheme.attackRangeColor
              : FiftyColors.cream.withAlpha(80),
          width: isAttackTarget ? 2.5 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(100),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Unit type initial.
          Text(
            initial,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: spriteSize * 0.38,
              fontWeight: FiftyTypography.extraBold,
              color: FiftyColors.cream,
              height: 1,
            ),
          ),

          // Small HP indicator beneath the initial.
          if (unit.hp < unit.maxHp)
            Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(
                '${unit.hp}',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: spriteSize * 0.2,
                  fontWeight: FiftyTypography.bold,
                  color: unit.hpRatio > 0.5
                      ? FiftyColors.cream
                      : FiftyColors.powderBlush,
                  height: 1,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
