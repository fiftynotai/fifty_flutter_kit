/// Achievement Unlock Overlay
///
/// Shows a popup notification when an achievement is unlocked during gameplay.
/// Uses [AchievementPopup] from the fifty_achievement_engine package.
library;

import 'package:fifty_achievement_engine/fifty_achievement_engine.dart';
import 'package:flutter/material.dart';

/// Helper to show the achievement unlock popup as an overlay.
class AchievementUnlockOverlay {
  AchievementUnlockOverlay._();

  /// Shows an [AchievementPopup] overlay for the given [achievement].
  static void show(BuildContext context, Achievement<void> achievement) {
    final overlay = Overlay.of(context);
    final topPadding = MediaQuery.of(context).padding.top;
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (_) => Positioned(
        top: topPadding + 16,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: AchievementPopup<void>(
            achievement: achievement,
            onDismiss: () => entry.remove(),
          ),
        ),
      ),
    );

    overlay.insert(entry);
  }
}
