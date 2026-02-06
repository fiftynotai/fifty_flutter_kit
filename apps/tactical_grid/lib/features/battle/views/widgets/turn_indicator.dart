/// Turn Indicator Widget
///
/// Top bar HUD element for the battle screen that displays the current
/// turn number, active player indicator, and utility controls (audio
/// mute toggle and exit button).
///
/// Binds reactively to [BattleViewModel] via `Obx()` so the turn number
/// and player label update automatically as game state changes.
///
/// **Layout:**
/// ```
/// ┌──────────────────────────────────────────────────────────────────┐
/// │  TURN 3  |  * PLAYER 1  |                        [mute]  [exit] │
/// └──────────────────────────────────────────────────────────────────┘
/// ```
///
/// **Dependencies (via GetX):**
/// - [BattleViewModel] - reactive turn/player state
/// - [BattleActions] - exit game handler
/// - [BattleAudioCoordinator] - mute toggle
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../actions/battle_actions.dart';
import '../../controllers/battle_view_model.dart';
import '../../services/audio_coordinator.dart';

/// Top bar showing turn info, active player indicator, and utility controls.
///
/// Reactively displays:
/// - **Turn number** on the left side (e.g. "TURN 3").
/// - **Current player** with a colored dot indicator:
///   - [AppTheme.playerColor] (burgundy) for Player 1.
///   - [AppTheme.enemyColor] (slateGrey) for Player 2.
/// - **Audio mute toggle** on the right side.
/// - **Exit button** on the far right.
///
/// The bar has a subtle bottom border using a low-alpha burgundy.
///
/// **Example:**
/// ```dart
/// // Typically placed in a Stack or Column at the top of the battle screen.
/// const TurnIndicator(),
/// ```
class TurnIndicator extends GetView<BattleViewModel> {
  /// Creates a [TurnIndicator] widget.
  const TurnIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = Get.find<BattleActions>();
    final audio = Get.find<BattleAudioCoordinator>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.md,
        vertical: FiftySpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(180),
        border: Border(
          bottom: BorderSide(
            color: FiftyColors.burgundy.withAlpha(50),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Obx(() {
          final turnNumber = controller.turnNumber;
          final isPlayerTurn = controller.isPlayerTurn;
          final turnLabel = controller.turnLabel;
          final dotColor =
              isPlayerTurn ? AppTheme.playerColor : AppTheme.enemyColor;

          return Row(
            children: [
              // -- Turn number --
              _TurnBadge(turnNumber: turnNumber),

              const SizedBox(width: FiftySpacing.md),

              // -- Vertical divider --
              Container(
                width: 1,
                height: 20,
                color: FiftyColors.slateGrey.withAlpha(80),
              ),

              const SizedBox(width: FiftySpacing.md),

              // -- Player indicator --
              _PlayerIndicator(
                label: turnLabel,
                dotColor: dotColor,
              ),

              const Spacer(),

              // -- Audio mute toggle --
              Obx(() {
                final isMuted = audio.isMuted;
                return FiftyIconButton(
                  icon: isMuted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
                  tooltip: isMuted ? 'Unmute audio' : 'Mute audio',
                  variant: FiftyIconButtonVariant.ghost,
                  size: FiftyIconButtonSize.small,
                  onPressed: () => audio.toggleMute(),
                );
              }),

              const SizedBox(width: FiftySpacing.xs),

              // -- Exit button --
              FiftyIconButton(
                icon: Icons.close_rounded,
                tooltip: 'Exit battle',
                variant: FiftyIconButtonVariant.ghost,
                size: FiftyIconButtonSize.small,
                onPressed: () => actions.onExitGame(context),
              ),
            ],
          );
        }),
      ),
    );
  }
}

/// Displays the current turn number as a styled badge.
///
/// Renders "TURN {n}" in a compact, uppercase label using FDL typography.
class _TurnBadge extends StatelessWidget {
  /// Creates a [_TurnBadge] for the given [turnNumber].
  const _TurnBadge({required this.turnNumber});

  /// The current turn number to display.
  final int turnNumber;

  @override
  Widget build(BuildContext context) {
    return Text(
      'TURN $turnNumber',
      style: const TextStyle(
        fontFamily: FiftyTypography.fontFamily,
        fontSize: FiftyTypography.labelLarge,
        fontWeight: FiftyTypography.bold,
        color: FiftyColors.cream,
        letterSpacing: FiftyTypography.letterSpacingLabel,
      ),
    );
  }
}

/// Displays the current player label with a colored dot indicator.
///
/// The [dotColor] changes based on whose turn it is:
/// - Burgundy for Player 1 (player's turn).
/// - SlateGrey for Player 2 (enemy's turn).
class _PlayerIndicator extends StatelessWidget {
  /// Creates a [_PlayerIndicator] with the given [label] and [dotColor].
  const _PlayerIndicator({
    required this.label,
    required this.dotColor,
  });

  /// The player label text (e.g. "PLAYER 1").
  final String label;

  /// The color for the dot indicator.
  final Color dotColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Colored dot
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: dotColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: dotColor.withAlpha(120),
                blurRadius: 6,
              ),
            ],
          ),
        ),

        const SizedBox(width: FiftySpacing.sm),

        // Player label
        Text(
          label,
          style: const TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodyMedium,
            fontWeight: FiftyTypography.medium,
            color: FiftyColors.cream,
            letterSpacing: FiftyTypography.letterSpacingLabel,
          ),
        ),
      ],
    );
  }
}
