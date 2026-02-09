/// Unit Sprite Widget
///
/// A reusable widget that renders a game unit using its PNG sprite asset
/// clipped to a circle. Falls back to a coloured circle with the unit type
/// initial letter when the image asset cannot be loaded.
///
/// Extracted from the board tile renderer so it can be shared across multiple
/// screens (battle board, info panels, animation overlays, etc.).
///
/// **Visual spec:**
/// - Circle sized at 70% of the parent [tileSize].
/// - Sprite image loaded via [Unit.assetPath] and clipped with [ClipOval].
/// - Border: thicker burgundy border when [isAttackTarget] is true,
///   subtle cream border otherwise.
/// - A glow shadow matching the unit colour.
/// - HP indicator overlay at bottom centre when HP is below max.
/// - Optional white flash overlay for impact effects via [showFlash].
/// - Fallback: coloured circle with type initial (C/K/S/A/M/R) if image
///   fails to load.
///
/// **Usage:**
/// ```dart
/// UnitSpriteWidget(
///   unit: selectedUnit,
///   tileSize: 48.0,
///   isAttackTarget: true,
///   showFlash: isFlashing,
/// )
/// ```
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../models/unit.dart';

/// Shared unit sprite rendered from a PNG asset image clipped to a circle.
///
/// Uses [Unit.assetPath] to load the sprite. Falls back to a coloured circle
/// with the unit type initial letter when the asset cannot be loaded.
///
/// - Player units glow with [AppTheme.playerColor] (burgundy).
/// - Enemy units glow with [AppTheme.enemyColor] (slate grey).
/// - Attack targets receive a highlighted border in [AppTheme.attackRangeColor].
/// - When [showFlash] is true, a white semi-transparent overlay is drawn on
///   top of the sprite to indicate an impact flash effect.
class UnitSpriteWidget extends StatelessWidget {
  /// The unit to render.
  final Unit unit;

  /// Size of the containing tile (used to scale the sprite to 70%).
  final double tileSize;

  /// Whether this unit is an active attack target.
  ///
  /// When true, the border switches to [AppTheme.attackRangeColor] and becomes
  /// thicker (2.5 lp instead of the default 1.5 lp).
  final bool isAttackTarget;

  /// Whether to show a white flash overlay on the sprite.
  ///
  /// When true, a white circle at 60% opacity is layered on top of the sprite
  /// to indicate a damage impact or ability hit effect.
  final bool showFlash;

  /// Creates a [UnitSpriteWidget].
  const UnitSpriteWidget({
    required this.unit,
    required this.tileSize,
    this.isAttackTarget = false,
    this.showFlash = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final spriteSize = tileSize * 0.7;
    final color = unit.isPlayer ? AppTheme.playerColor : AppTheme.enemyColor;

    return SizedBox(
      width: spriteSize,
      height: spriteSize,
      child: Stack(
        children: [
          // Base sprite image with border decoration.
          Container(
            width: spriteSize,
            height: spriteSize,
            decoration: BoxDecoration(
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
            child: ClipOval(
              child: Image.asset(
                unit.assetPath,
                width: spriteSize,
                height: spriteSize,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to colored circle with initial if image fails.
                  final initial = switch (unit.type) {
                    UnitType.commander => 'C',
                    UnitType.knight => 'K',
                    UnitType.shield => 'S',
                    UnitType.archer => 'A',
                    UnitType.mage => 'M',
                    UnitType.scout => 'R',
                  };
                  return Container(
                    color: color,
                    alignment: Alignment.center,
                    child: Text(
                      initial,
                      style: TextStyle(
                        fontFamily: FiftyTypography.fontFamily,
                        fontSize: spriteSize * 0.38,
                        fontWeight: FiftyTypography.extraBold,
                        color: FiftyColors.cream,
                        height: 1,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // HP indicator overlay (bottom center).
          if (unit.hp < unit.maxHp)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(180),
                    borderRadius: BorderRadius.circular(4),
                  ),
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
              ),
            ),

          // Impact flash overlay.
          if (showFlash)
            Container(
              width: spriteSize,
              height: spriteSize,
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(153),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
