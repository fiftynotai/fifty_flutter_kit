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
import '../../services/ai_turn_executor.dart';
import '../../services/audio_coordinator.dart';
import '../../services/turn_timer_service.dart';

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
    final aiExecutor = Get.find<AITurnExecutor>();
    final timerService = Get.find<TurnTimerService>();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: FiftyColors.burgundy.withAlpha(50),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // -- Top row: turn info + controls --
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: FiftySpacing.md,
                vertical: FiftySpacing.sm,
              ),
              child: Obx(() {
                final turnNumber = controller.turnNumber;
                final isPlayerTurn = controller.isPlayerTurn;
                final turnLabel = controller.turnLabel;
                final dotColor =
                    isPlayerTurn ? AppTheme.playerColor : AppTheme.enemyColor;
                final isAIExecuting = aiExecutor.isExecuting.value;

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

                    // -- Player indicator or AI thinking label --
                    if (isAIExecuting)
                      const _AIThinkingLabel()
                    else
                      _PlayerIndicator(
                        label: turnLabel,
                        dotColor: dotColor,
                      ),

                    const Spacer(),

                    // -- Timer countdown text --
                    _TimerCountdown(timerService: timerService),

                    const SizedBox(width: FiftySpacing.sm),

                    // -- Audio mute toggle --
                    Obx(() {
                      final isMuted = audio.isMuted;
                      return FiftyIconButton(
                        icon: isMuted
                            ? Icons.volume_off_rounded
                            : Icons.volume_up_rounded,
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

            // -- Timer progress bar --
            _TimerBar(timerService: timerService),
          ],
        ),
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
      style: TextStyle(
        fontFamily: FiftyTypography.fontFamily,
        fontSize: FiftyTypography.labelLarge,
        fontWeight: FiftyTypography.bold,
        color: Theme.of(context).colorScheme.onSurface,
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
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodyMedium,
            fontWeight: FiftyTypography.medium,
            color: Theme.of(context).colorScheme.onSurface,
            letterSpacing: FiftyTypography.letterSpacingLabel,
          ),
        ),
      ],
    );
  }
}

/// Label displayed when the AI is executing its turn.
///
/// Shows "ENEMY THINKING..." in a pulsing style with an animated dot
/// indicator to convey that the AI is actively processing.
class _AIThinkingLabel extends StatelessWidget {
  const _AIThinkingLabel();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Pulsing dot indicator
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: FiftyColors.powderBlush,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: FiftyColors.powderBlush.withAlpha(120),
                blurRadius: 6,
              ),
            ],
          ),
        ),

        const SizedBox(width: FiftySpacing.sm),

        // Thinking label
        Text(
          'ENEMY THINKING...',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodyMedium,
            fontWeight: FiftyTypography.medium,
            color: FiftyColors.powderBlush,
            letterSpacing: FiftyTypography.letterSpacingLabel,
          ),
        ),
      ],
    );
  }
}

/// Displays the remaining turn time as a compact countdown text.
///
/// Shows the time in "M:SS" format. Color transitions based on the
/// timer zone:
/// - Normal: [FiftyColors.cream]
/// - Warning (<=10s): [Colors.amber]
/// - Critical (<=5s): [Colors.red]
///
/// Hidden when the timer is not running and has no remaining time.
class _TimerCountdown extends StatelessWidget {
  /// Creates a [_TimerCountdown] widget.
  const _TimerCountdown({required this.timerService});

  /// The timer service to observe.
  final TurnTimerService timerService;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final seconds = timerService.remainingSeconds.value;
      final isRunning = timerService.isRunning.value;

      if (!isRunning && seconds <= 0) return const SizedBox.shrink();

      final minutes = seconds ~/ 60;
      final secs = seconds % 60;
      final timeText = '$minutes:${secs.toString().padLeft(2, '0')}';
      final color = _timerColor(seconds, timerService, context);

      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.timer_outlined,
            size: 14,
            color: color,
          ),
          const SizedBox(width: FiftySpacing.xs),
          Text(
            timeText,
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodySmall,
              fontWeight: FiftyTypography.bold,
              color: color,
              letterSpacing: FiftyTypography.letterSpacingLabel,
            ),
          ),
        ],
      );
    });
  }
}

/// Displays a horizontal progress bar that counts down with the turn timer.
///
/// Color transitions:
/// - Normal: [AppTheme.accentColor] (powder blush)
/// - Warning (<=10s): [Colors.amber]
/// - Critical (<=5s): [Colors.red]
///
/// Hidden when the timer is not running and has no remaining time.
class _TimerBar extends StatelessWidget {
  /// Creates a [_TimerBar] widget.
  const _TimerBar({required this.timerService});

  /// The timer service to observe.
  final TurnTimerService timerService;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final seconds = timerService.remainingSeconds.value;
      final isRunning = timerService.isRunning.value;

      if (!isRunning && seconds <= 0) return const SizedBox.shrink();

      final progress = timerService.progress;
      final color = _timerColor(seconds, timerService, context);

      return ClipRRect(
        borderRadius: BorderRadius.circular(1),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: Theme.of(context).colorScheme.onSurface.withAlpha(30),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 3,
        ),
      );
    });
  }
}

/// Returns the appropriate color for the timer based on remaining [seconds].
///
/// Uses the configurable thresholds from the [TurnTimerService] instance
/// rather than static constants, so user-configured thresholds are respected.
///
/// - Critical (<=criticalThreshold): Red
/// - Warning (<=warningThreshold): Amber
/// - Normal: Accent color (cream)
Color _timerColor(int seconds, TurnTimerService timer, BuildContext context) {
  if (seconds <= timer.criticalThreshold && seconds > 0) {
    return Colors.red;
  }
  if (seconds <= timer.warningThreshold) {
    return Colors.amber;
  }
  return Theme.of(context).colorScheme.onSurface;
}
