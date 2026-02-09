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

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../actions/battle_actions.dart';
import '../../controllers/battle_view_model.dart';
import '../../models/models.dart';
import '../../services/animation_service.dart';
import 'animated_board_overlay.dart';
import 'unit_sprite_widget.dart';

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
            child: Stack(
              children: [
                // Base grid.
                Obx(() {
              final state = controller.gameState.value;
              final selectedUnit = state.selectedUnit;
              final validMoves = state.validMoves.toSet();

              // Build a set of positions that are attack targets for quick
              // lookup inside the tile builder.
              final attackPositions = <GridPosition>{};
              for (final target in state.attackTargets) {
                attackPositions.add(target.position);
              }

              // Ability target positions (only relevant in targeting mode).
              final isAbilityTargeting =
                  controller.isAbilityTargeting.value;
              final abilityTargetPositions = isAbilityTargeting
                  ? state.abilityTargets.toSet()
                  : <GridPosition>{};

              // Get animation service for hiding animated units.
              final AnimationService? animService =
                  Get.isRegistered<AnimationService>()
                      ? Get.find<AnimationService>()
                      : null;

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
                  final rawUnit = state.board.getUnitAt(position);

                  // Hide unit from grid tile if it is being animated
                  // (the overlay shows it instead).
                  final unitAtPos = (rawUnit != null &&
                          animService != null &&
                          animService.isUnitAnimating(rawUnit.id))
                      ? null
                      : rawUnit;

                  // Check if this unit should show an impact flash.
                  final isFlashing = rawUnit != null &&
                      animService != null &&
                      animService.flashingUnitIds.contains(rawUnit.id);

                  final isSelected = selectedUnit != null &&
                      selectedUnit.position == position;
                  final isValidMove = validMoves.contains(position);
                  final isAttackTarget = attackPositions.contains(position);
                  final isAbilityTarget =
                      abilityTargetPositions.contains(position);

                  return _BoardTile(
                    position: position,
                    unit: unitAtPos,
                    isValidMove: isValidMove,
                    isAttackTarget: isAttackTarget,
                    isAbilityTarget: isAbilityTarget,
                    isSelected: isSelected,
                    showFlash: isFlashing,
                    tileSize: tileSize,
                    onTap: () => actions.onTileTapped(context, position),
                  );
                },
              );
            }),

                // Animation overlay.
                Positioned.fill(
                  child: AnimatedBoardOverlay(tileSize: tileSize),
                ),
              ],
            ),
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
/// Renders the tile background, optional overlays for move/attack/ability
/// highlights, a selection border, and a unit placeholder sprite when occupied.
class _BoardTile extends StatelessWidget {
  /// Grid position of this tile.
  final GridPosition position;

  /// The unit occupying this tile, or `null` if empty.
  final Unit? unit;

  /// Whether this tile is a valid move destination for the selected unit.
  final bool isValidMove;

  /// Whether this tile contains a unit that is a valid attack target.
  final bool isAttackTarget;

  /// Whether this tile is a valid ability target position.
  final bool isAbilityTarget;

  /// Whether this tile contains the currently selected unit.
  final bool isSelected;

  /// Whether to show an impact flash overlay on the unit sprite.
  final bool showFlash;

  /// Side length of the tile in logical pixels.
  final double tileSize;

  /// Callback when the tile is tapped.
  final VoidCallback onTap;

  const _BoardTile({
    required this.position,
    required this.unit,
    required this.isValidMove,
    required this.isAttackTarget,
    required this.isAbilityTarget,
    required this.isSelected,
    required this.showFlash,
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

            // Ability target overlay (purple/magenta tint).
            if (isAbilityTarget)
              Positioned.fill(
                child: Container(
                  color: AppTheme.accentColor.withAlpha(80),
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
                child: UnitSpriteWidget(
                  unit: unit!,
                  tileSize: tileSize,
                  isAttackTarget: isAttackTarget,
                  showFlash: showFlash,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

