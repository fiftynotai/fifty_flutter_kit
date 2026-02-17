/// **BattlePage**
///
/// Main battle screen that displays the tactical grid game. Composes three
/// major sections in a vertical [Column]:
///
/// 1. **TurnIndicator** -- top bar showing turn number, active player, and
///    action buttons (sound toggle, exit).
/// 2. **BoardWidget** -- the 8x8 game grid (occupies all remaining space).
/// 3. **UnitInfoPanel** -- bottom bar showing selected unit stats and action
///    buttons (attack, wait, end turn).
///
/// Uses a [StatefulWidget] so that BGM playback begins on the first frame.
/// Resolves [BattleActions] from the GetX container and delegates user
/// interactions to the action layer.
///
/// **Data Flow:**
/// ```
/// BattlePage (Obx) -> BattleActions -> BattleViewModel -> GameLogicService
/// ```
library;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../actions/battle_actions.dart';
import 'widgets/engine_board_widget.dart';
import 'widgets/turn_indicator.dart';
import 'widgets/unit_info_panel.dart';

/// The main battle screen for the tactical grid game.
///
/// Uses a [StatefulWidget] so that [initState] can trigger BGM playback
/// on the very first frame. Resolves [BattleViewModel] and [BattleActions]
/// from the GetX container.
class BattlePage extends StatefulWidget {
  /// Creates a [BattlePage].
  const BattlePage({super.key});

  @override
  State<BattlePage> createState() => _BattlePageState();
}

class _BattlePageState extends State<BattlePage> {
  @override
  void initState() {
    super.initState();
    Get.find<BattleActions>().onBattleEnter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          const TurnIndicator(),
          const Expanded(child: EngineBoardWidget()),
          const UnitInfoPanel(),
        ],
      ),
    );
  }
}
