/// Unit Info Panel Widget
///
/// Bottom HUD panel for the battle screen that displays the selected unit's
/// stats (name, type, HP, attack, movement) and action buttons (Attack,
/// Wait, End Turn). When no unit is selected, shows a prompt message
/// with only the End Turn button.
///
/// Binds reactively to [BattleViewModel] via `Obx()` so the panel content
/// updates automatically when the selected unit changes.
///
/// **Layout (unit selected):**
/// ```
/// ┌────────────────────────────────────────────────────────────────────┐
/// │  [K]  KNIGHT          HP: 3/5                                     │
/// │       ATK: 3  MOVE: L-shape    ████████░░░░                       │
/// │       [ ATTACK ]  [ WAIT ]                     [ END TURN ]       │
/// └────────────────────────────────────────────────────────────────────┘
/// ```
///
/// **Layout (no selection):**
/// ```
/// ┌────────────────────────────────────────────────────────────────────┐
/// │            TAP A UNIT TO SELECT              [ END TURN ]          │
/// └────────────────────────────────────────────────────────────────────┘
/// ```
///
/// **Dependencies (via GetX):**
/// - [BattleViewModel] - reactive unit selection, attack targets
/// - [BattleActions] - attack, wait, end turn handlers
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../actions/battle_actions.dart';
import '../../controllers/battle_view_model.dart';
import '../../models/ability.dart';
import '../../models/unit.dart';
import '../../services/ai_turn_executor.dart';

/// Bottom panel that shows selected unit info and action buttons.
///
/// Reactively switches between two layouts:
/// - **Unit selected:** Shows unit avatar, name, stats, HP bar, and
///   action buttons (Attack, Wait, End Turn).
/// - **No selection:** Shows a "TAP A UNIT TO SELECT" prompt with only
///   the End Turn button visible.
///
/// **HP Bar Color Logic:**
/// - HP > 60%: [FiftyColors.hunterGreen] (healthy)
/// - HP > 30%: [FiftyColors.powderBlush] (warning)
/// - HP <= 30%: [FiftyColors.burgundy] (critical)
///
/// **Example:**
/// ```dart
/// // Typically placed in a Stack or Column at the bottom of the battle screen.
/// const UnitInfoPanel(),
/// ```
class UnitInfoPanel extends GetView<BattleViewModel> {
  /// Creates a [UnitInfoPanel] widget.
  const UnitInfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final actions = Get.find<BattleActions>();
    final aiExecutor = Get.find<AITurnExecutor>();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: FiftySpacing.md,
        vertical: FiftySpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(180),
        border: Border(
          top: BorderSide(
            color: FiftyColors.burgundy.withAlpha(50),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Obx(() {
          final selectedUnit = controller.selectedUnit;
          final isAIExecuting = aiExecutor.isExecuting.value;

          if (selectedUnit != null) {
            return _SelectedUnitLayout(
              unit: selectedUnit,
              attackTargets: controller.attackTargets,
              canUseAbility: controller.canUseAbility,
              actions: actions,
              isAIExecuting: isAIExecuting,
            );
          }

          return _EmptySelectionLayout(
            actions: actions,
            isAIExecuting: isAIExecuting,
          );
        }),
      ),
    );
  }
}

/// Layout displayed when a unit is selected.
///
/// Shows the unit's avatar, name, stats, HP bar, ability info, and action
/// buttons (Attack, Ability, Wait, End Turn).
///
/// When [isAIExecuting] is `true`, the action buttons row is replaced with
/// an "ENEMY TURN" label to prevent player interaction.
class _SelectedUnitLayout extends StatelessWidget {
  /// Creates a [_SelectedUnitLayout] for the given [unit].
  const _SelectedUnitLayout({
    required this.unit,
    required this.attackTargets,
    required this.canUseAbility,
    required this.actions,
    this.isAIExecuting = false,
  });

  /// The currently selected unit.
  final Unit unit;

  /// Available attack targets for the selected unit.
  final List<Unit> attackTargets;

  /// Whether the unit's ability can be activated right now.
  final bool canUseAbility;

  /// Battle actions for handling button presses.
  final BattleActions actions;

  /// Whether the AI is currently executing its turn.
  final bool isAIExecuting;

  @override
  Widget build(BuildContext context) {
    final ability = unit.ability;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // -- Top row: avatar, name/stats, HP --
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Unit avatar
            _UnitAvatar(unit: unit),

            const SizedBox(width: FiftySpacing.md),

            // Name and stats
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Unit name
                  Text(
                    unit.displayName.toUpperCase(),
                    style: TextStyle(
                      fontFamily: FiftyTypography.fontFamily,
                      fontSize: FiftyTypography.labelLarge,
                      fontWeight: FiftyTypography.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                      letterSpacing: FiftyTypography.letterSpacingLabel,
                    ),
                  ),

                  const SizedBox(height: FiftySpacing.xs),

                  // Stats row
                  Row(
                    children: [
                      _StatLabel(
                        label: 'ATK',
                        value: '${unit.attack}',
                      ),
                      const SizedBox(width: FiftySpacing.md),
                      _StatLabel(
                        label: 'MOVE',
                        value: _movementDescription(unit.type),
                      ),
                    ],
                  ),

                  const SizedBox(height: FiftySpacing.xs),

                  // Ability info
                  if (ability != null)
                    _AbilityStatusLabel(ability: ability),

                  const SizedBox(height: FiftySpacing.sm),

                  // HP bar
                  _HpBar(unit: unit),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: FiftySpacing.md),

        // -- Bottom row: action buttons or AI turn label --
        if (isAIExecuting)
          const _EnemyTurnLabel()
        else
          Row(
            children: [
              // Attack button
              FiftyButton(
                label: 'ATTACK',
                variant: FiftyButtonVariant.primary,
                size: FiftyButtonSize.small,
                icon: Icons.gps_fixed_rounded,
                disabled: attackTargets.isEmpty,
                onPressed: attackTargets.isEmpty
                    ? null
                    : () => _onAttackPressed(context),
              ),

              const SizedBox(width: FiftySpacing.sm),

              // Ability button (only for active abilities).
              if (ability != null && !ability.isPassive)
                Padding(
                  padding: const EdgeInsets.only(right: FiftySpacing.sm),
                  child: FiftyButton(
                    label: _abilityButtonLabel(ability),
                    variant: FiftyButtonVariant.outline,
                    size: FiftyButtonSize.small,
                    disabled: !canUseAbility,
                    onPressed: canUseAbility
                        ? () => actions.onAbilityButtonPressed(context)
                        : null,
                  ),
                ),

              // Wait button
              FiftyButton(
                label: 'WAIT',
                variant: FiftyButtonVariant.ghost,
                size: FiftyButtonSize.small,
                onPressed: () => actions.onWaitUnit(context),
              ),

              const Spacer(),

              // End Turn button
              FiftyButton(
                label: 'END TURN',
                variant: FiftyButtonVariant.outline,
                size: FiftyButtonSize.medium,
                onPressed: () => actions.onEndTurn(context),
              ),
            ],
          ),
      ],
    );
  }

  /// Handles the attack button press.
  ///
  /// If there is exactly one attack target, attacks it directly.
  /// If there are multiple targets, attacks the first one (the UI
  /// can be extended later to show a target selection overlay).
  void _onAttackPressed(BuildContext context) {
    if (attackTargets.isNotEmpty) {
      actions.onAttackUnit(context, attackTargets.first.id);
    }
  }

  /// Returns the ability button label text.
  ///
  /// Shows ability name in uppercase, with cooldown count when on cooldown.
  String _abilityButtonLabel(Ability ability) {
    final name = ability.name.toUpperCase();
    if (ability.currentCooldown > 0) {
      return '$name (${ability.currentCooldown})';
    }
    return name;
  }
}

/// Layout displayed when no unit is selected.
///
/// Shows a centered prompt message and the End Turn button.
/// When [isAIExecuting] is `true`, shows "ENEMY TURN..." instead of the
/// normal prompt and hides the End Turn button.
class _EmptySelectionLayout extends StatelessWidget {
  /// Creates an [_EmptySelectionLayout] with the given [actions].
  const _EmptySelectionLayout({
    required this.actions,
    this.isAIExecuting = false,
  });

  /// Battle actions for handling button presses.
  final BattleActions actions;

  /// Whether the AI is currently executing its turn.
  final bool isAIExecuting;

  @override
  Widget build(BuildContext context) {
    if (isAIExecuting) {
      return const _EnemyTurnLabel();
    }

    return Row(
      children: [
        // Prompt message
        Expanded(
          child: Text(
            'TAP A UNIT TO SELECT',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodyMedium,
              fontWeight: FiftyTypography.medium,
              color: FiftyColors.slateGrey.withAlpha(180),
              letterSpacing: FiftyTypography.letterSpacingLabel,
            ),
          ),
        ),

        // End Turn button
        FiftyButton(
          label: 'END TURN',
          variant: FiftyButtonVariant.outline,
          size: FiftyButtonSize.medium,
          onPressed: () => actions.onEndTurn(context),
        ),
      ],
    );
  }
}

/// Circular avatar displaying the unit type initial and color.
///
/// Uses [AppTheme.playerColor] for player units and [AppTheme.enemyColor]
/// for enemy units as the background color.
class _UnitAvatar extends StatelessWidget {
  /// Creates a [_UnitAvatar] for the given [unit].
  const _UnitAvatar({required this.unit});

  /// The unit whose avatar to display.
  final Unit unit;

  @override
  Widget build(BuildContext context) {
    final bgColor = unit.isPlayer ? AppTheme.playerColor : AppTheme.enemyColor;
    final initial = unit.displayName[0];

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bgColor.withAlpha(180),
        shape: BoxShape.circle,
        border: Border.all(
          color: bgColor,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: bgColor.withAlpha(80),
            blurRadius: 8,
          ),
        ],
      ),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.titleLarge,
            fontWeight: FiftyTypography.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

/// Displays a stat label-value pair (e.g. "ATK: 3").
class _StatLabel extends StatelessWidget {
  /// Creates a [_StatLabel] with the given [label] and [value].
  const _StatLabel({
    required this.label,
    required this.value,
  });

  /// The stat label (e.g. "ATK", "MOVE").
  final String label;

  /// The stat value (e.g. "3", "L-shape").
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label: ',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodySmall,
            fontWeight: FiftyTypography.medium,
            color: FiftyColors.slateGrey.withAlpha(200),
            letterSpacing: FiftyTypography.letterSpacingLabel,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.bodySmall,
            fontWeight: FiftyTypography.bold,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

/// Displays the ability name and status (passive, ready, or cooldown).
///
/// Examples:
/// - "Charge (passive)"
/// - "Rally - Ready"
/// - "Block (CD: 2)"
class _AbilityStatusLabel extends StatelessWidget {
  /// Creates an [_AbilityStatusLabel] for the given [ability].
  const _AbilityStatusLabel({required this.ability});

  /// The ability to describe.
  final Ability ability;

  @override
  Widget build(BuildContext context) {
    final String statusText;
    final Color statusColor;

    if (ability.isPassive) {
      statusText = '${ability.name} (passive)';
      statusColor = FiftyColors.slateGrey;
    } else if (ability.isReady) {
      statusText = '${ability.name} - Ready';
      statusColor = FiftyColors.hunterGreen;
    } else {
      statusText = '${ability.name} (CD: ${ability.currentCooldown})';
      statusColor = FiftyColors.powderBlush;
    }

    return Text(
      statusText,
      style: TextStyle(
        fontFamily: FiftyTypography.fontFamily,
        fontSize: FiftyTypography.labelSmall,
        fontWeight: FiftyTypography.medium,
        color: statusColor.withAlpha(200),
        letterSpacing: FiftyTypography.letterSpacingLabel,
      ),
    );
  }
}

/// HP bar for the selected unit using [FiftyProgressBar].
///
/// **Color logic:**
/// - HP > 60%: [FiftyColors.hunterGreen]
/// - HP > 30%: [FiftyColors.powderBlush]
/// - HP <= 30%: [FiftyColors.burgundy]
class _HpBar extends StatelessWidget {
  /// Creates an [_HpBar] for the given [unit].
  const _HpBar({required this.unit});

  /// The unit whose HP to display.
  final Unit unit;

  @override
  Widget build(BuildContext context) {
    final hpRatio = unit.hpRatio;
    final hpColor = _getHpColor(hpRatio);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // HP text label
        Text(
          'HP: ${unit.hp}/${unit.maxHp}',
          style: TextStyle(
            fontFamily: FiftyTypography.fontFamily,
            fontSize: FiftyTypography.labelSmall,
            fontWeight: FiftyTypography.medium,
            color: hpColor,
            letterSpacing: FiftyTypography.letterSpacingLabel,
          ),
        ),

        const SizedBox(height: FiftySpacing.xs),

        // Progress bar
        FiftyProgressBar(
          value: hpRatio,
          height: 6,
          foregroundColor: hpColor,
          backgroundColor: Colors.white.withAlpha(20),
        ),
      ],
    );
  }

  /// Returns the HP bar color based on the current HP ratio.
  ///
  /// - Above 60%: green (healthy)
  /// - Above 30%: blush/warning
  /// - 30% or below: burgundy (critical)
  Color _getHpColor(double ratio) {
    if (ratio > 0.6) return FiftyColors.hunterGreen;
    if (ratio > 0.3) return FiftyColors.powderBlush;
    return FiftyColors.burgundy;
  }
}

/// Returns a human-readable movement description for the given [type].
///
/// - [UnitType.commander]: "1 tile (any)"
/// - [UnitType.knight]: "L-shape"
/// - [UnitType.shield]: "1 tile (any)"
String _movementDescription(UnitType type) => switch (type) {
      UnitType.commander => '1 tile (any)',
      UnitType.knight => 'L-shape',
      UnitType.shield => '1 tile (any)',
      UnitType.archer => '2 tiles (orthogonal)',
      UnitType.mage => '2 tiles (diagonal)',
      UnitType.scout => '3 tiles (any)',
    };

/// Label displayed during the AI's turn in place of action buttons.
///
/// Shows "ENEMY TURN..." in a subdued style to indicate the player
/// cannot interact with the board.
class _EnemyTurnLabel extends StatelessWidget {
  const _EnemyTurnLabel();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'ENEMY TURN...',
            style: TextStyle(
              fontFamily: FiftyTypography.fontFamily,
              fontSize: FiftyTypography.bodyMedium,
              fontWeight: FiftyTypography.medium,
              color: FiftyColors.powderBlush.withAlpha(180),
              letterSpacing: FiftyTypography.letterSpacingLabel,
            ),
          ),
        ),
      ],
    );
  }
}
