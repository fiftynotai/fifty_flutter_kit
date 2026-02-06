/// App Theme Configuration
///
/// Game-specific color semantics consuming FDL primitives.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';

/// Theme utilities for Tactical Grid.
///
/// Provides game-specific color semantics while consuming FDL primitives
/// (no hardcoded values).
class AppTheme {
  AppTheme._();

  /// Color for player units.
  static const Color playerColor = FiftyColors.burgundy;

  /// Color for enemy units.
  static const Color enemyColor = FiftyColors.slateGrey;

  /// Color for dark board tiles.
  static const Color boardDark = FiftyColors.darkBurgundy;

  /// Color for light board tiles.
  static Color get boardLight => FiftyColors.slateGrey.withAlpha(50);

  /// Color for selection glow.
  static const Color selectionColor = FiftyColors.cream;

  /// Color for valid move overlay.
  static const Color validMoveColor = FiftyColors.hunterGreen;

  /// Color for attack range overlay.
  static const Color attackRangeColor = FiftyColors.burgundy;

  /// Color for UI accents.
  static const Color accentColor = FiftyColors.powderBlush;
}
