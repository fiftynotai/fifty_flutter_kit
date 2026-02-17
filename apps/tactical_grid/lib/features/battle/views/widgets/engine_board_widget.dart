/// **EngineBoardWidget**
///
/// Renders the 8x8 tactical grid board using the `fifty_map_engine` v2
/// game engine instead of Flutter's [GridView.builder].
///
/// Wraps [FiftyMapWidget] with:
/// - A checkerboard [TileGrid] (dark/light tiles from [AppTheme]).
/// - [FiftyMapEntity] instances for each living unit on the board.
/// - Entity decorators: team colour borders, HP bars, and status icons.
///
/// **Architecture Note:**
/// This widget replaces [BoardWidget] as the primary board renderer.
/// The data flow remains unchanged -- it reads from [BattleViewModel]
/// and delegates taps to [BattleActions] via the action layer.
///
/// **Data Flow:**
/// ```
/// EngineBoardWidget (FiftyMapWidget)
///   -> onTileTap -> BattleActions.onTileTapped
///   -> BattleViewModel.gameState (read-only)
/// ```
///
/// **Usage:**
/// ```dart
/// const Expanded(child: EngineBoardWidget());
/// ```
library;

import 'package:fifty_map_engine/fifty_map_engine.dart' as map_engine;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_theme.dart';
import '../../actions/battle_actions.dart';
import '../../controllers/battle_view_model.dart';
import '../../models/models.dart';

// ---------------------------------------------------------------------------
// Tile Type Definitions
// ---------------------------------------------------------------------------

/// Dark checkerboard tile consuming [AppTheme.boardDark].
const _tileDark = map_engine.TileType(
  id: 'dark',
  asset: 'board/tile_dark.png',
  color: AppTheme.boardDark,
  walkable: true,
);

/// Light checkerboard tile consuming [AppTheme.boardLight].
///
/// Note: [AppTheme.boardLight] is a non-const getter, but [TileType.color]
/// is only used as a fallback when the asset is missing. The engine renders
/// the sprite image when available, so the compile-time colour here is a
/// reasonable approximation.
const _tileLight = map_engine.TileType(
  id: 'light',
  asset: 'board/tile_light.png',
  color: Color(0x32708090), // AppTheme.boardLight approximation (slateGrey @ 50 alpha)
  walkable: true,
);

// ---------------------------------------------------------------------------
// Widget
// ---------------------------------------------------------------------------

/// The 8x8 tactical game board powered by `fifty_map_engine` v2.
///
/// Uses a [StatefulWidget] because the engine controller and grid must be
/// initialised in [initState], and decorators are applied via a post-frame
/// callback after the engine spawns entities.
///
/// Resolves [BattleViewModel] and [BattleActions] from the GetX container.
class EngineBoardWidget extends StatefulWidget {
  /// Creates an [EngineBoardWidget].
  const EngineBoardWidget({super.key});

  @override
  State<EngineBoardWidget> createState() => _EngineBoardWidgetState();
}

class _EngineBoardWidgetState extends State<EngineBoardWidget> {
  /// Engine controller for entity manipulation and camera control.
  late final map_engine.FiftyMapController _controller;

  /// The 8x8 checkerboard tile grid.
  late final map_engine.TileGrid _grid;

  /// Reference to the reactive battle ViewModel.
  late final BattleViewModel _viewModel;

  /// Whether decorators (team borders, HP bars, icons) have been applied.
  bool _decoratorsApplied = false;

  /// Tracks the previous turn number to detect game restarts.
  ///
  /// When the player clicks "PLAY AGAIN", a fresh [GameState] is created
  /// with `turnNumber = 1`. If the previous turn was higher, we know
  /// the game restarted and must rebuild all engine entities.
  int _lastTurnNumber = 1;

  /// GetX worker that fires on every [BattleViewModel.gameState] change.
  late final Worker _stateWorker;

  /// GetX worker that fires on every [BattleViewModel.isAbilityTargeting] change.
  late final Worker _abilityTargetWorker;

  // -----------------------------------------------------------------------
  // Lifecycle
  // -----------------------------------------------------------------------

  @override
  void initState() {
    super.initState();

    // Register all sprite assets the engine needs to load.
    _registerAssets();

    // Create the engine controller and register with GetX for access
    // from the action layer (e.g. BattleActions movement animation).
    _controller = map_engine.FiftyMapController();
    Get.put<map_engine.FiftyMapController>(_controller);

    // Build the checkerboard grid and register with GetX for pathfinding.
    _grid = map_engine.TileGrid(width: 8, height: 8);
    _grid.fillCheckerboard(_tileDark, _tileLight);
    Get.put<map_engine.TileGrid>(_grid);

    // Resolve the ViewModel from GetX.
    _viewModel = Get.find<BattleViewModel>();

    // Listen to game state changes and sync engine visuals.
    _stateWorker = ever(_viewModel.gameState, _syncEngineState);

    // Listen to ability targeting mode changes.
    _abilityTargetWorker = ever(
      _viewModel.isAbilityTargeting,
      _onAbilityTargetingChanged,
    );

    // Apply decorators after the engine has spawned entities on screen.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), _setupDecorators);
    });
  }

  @override
  void dispose() {
    _stateWorker.dispose();
    _abilityTargetWorker.dispose();
    Get.delete<map_engine.TileGrid>();
    Get.delete<map_engine.FiftyMapController>();
    super.dispose();
  }

  // -----------------------------------------------------------------------
  // Asset Registration
  // -----------------------------------------------------------------------

  /// Registers all sprite assets used by the engine.
  ///
  /// Must be called before the first build so the engine can resolve
  /// asset paths to loaded images.
  void _registerAssets() {
    map_engine.FiftyAssetLoader.registerAssets([
      // Board tiles
      'board/tile_dark.png',
      'board/tile_light.png',
      // Player units (6 types)
      'units/player_commander.png',
      'units/player_knight.png',
      'units/player_shield.png',
      'units/player_archer.png',
      'units/player_mage.png',
      'units/player_scout.png',
      // Enemy units (6 types)
      'units/enemy_commander.png',
      'units/enemy_knight.png',
      'units/enemy_shield.png',
      'units/enemy_archer.png',
      'units/enemy_mage.png',
      'units/enemy_scout.png',
    ]);
  }

  // -----------------------------------------------------------------------
  // Entity Building
  // -----------------------------------------------------------------------

  /// Converts the current game state's living units into engine entities.
  ///
  /// Each [Unit] is mapped to a [FiftyMapEntity] with a 1x1 block size
  /// and the appropriate sprite asset path.
  List<map_engine.FiftyMapEntity> _buildEntities(GameState state) {
    return state.board.units
        .where((u) => u.isAlive)
        .map((unit) => map_engine.FiftyMapEntity(
              id: unit.id,
              type: 'character',
              asset: _unitAssetPath(unit),
              gridPosition: map_engine.Vector2(
                unit.position.x.toDouble(),
                unit.position.y.toDouble(),
              ),
              blockSize: map_engine.FiftyBlockSize(1, 1),
            ))
        .toList();
  }

  /// Converts a [Unit]'s full asset path to the engine-relative path.
  ///
  /// [Unit.assetPath] returns `'assets/images/units/player_commander.png'`
  /// but the engine expects paths relative to `assets/images/`, e.g.
  /// `'units/player_commander.png'`.
  String _unitAssetPath(Unit unit) {
    return unit.assetPath.replaceFirst('assets/images/', '');
  }

  // -----------------------------------------------------------------------
  // Decorator Setup
  // -----------------------------------------------------------------------

  /// Applies visual decorators to all living units after entity spawning.
  ///
  /// Decorators include:
  /// - **Team colour border:** Player units get [AppTheme.playerColor],
  ///   enemy units get [AppTheme.enemyColor].
  /// - **HP bar:** Displays current HP ratio.
  /// - **Status icon:** Shows the first letter of the unit type name.
  ///
  /// Also zooms out and centres the camera so the full board is visible.
  void _setupDecorators() {
    if (_decoratorsApplied) return;
    _decoratorsApplied = true;

    final state = _viewModel.gameState.value;
    for (final unit in state.board.units.where((u) => u.isAlive)) {
      // Team border colour.
      _controller.setTeamColor(
        unit.id,
        unit.isPlayer ? AppTheme.playerColor : AppTheme.enemyColor,
      );

      // HP bar.
      _controller.updateHP(unit.id, unit.hpRatio);

      // Status icon (unit type initial).
      _controller.addStatusIcon(
        unit.id,
        unit.type.name[0].toUpperCase(),
      );
    }

    // Centre camera on the board (may not be ready on slow platforms).
    _centerCamera();
  }

  /// Zooms out and centres the camera.
  ///
  /// Retries if the engine camera is not yet initialised (e.g. web where
  /// asset loading takes longer than the post-frame callback delay).
  void _centerCamera() {
    try {
      _controller.zoomOut();
      _controller.zoomOut();
      _controller.centerMap();
    } catch (_) {
      // Camera not ready yet; retry shortly.
      Future.delayed(const Duration(milliseconds: 300), _centerCamera);
    }
  }

  // -----------------------------------------------------------------------
  // State Synchronisation
  // -----------------------------------------------------------------------

  /// Syncs the engine visuals to the latest [GameState].
  ///
  /// Called reactively whenever [BattleViewModel.gameState] changes.
  /// Updates tile overlays (valid moves, attack range, ability targets)
  /// and entity selection decorators.
  void _syncEngineState(GameState state) {
    // Detect game restart: turn number drops below the last seen value
    // (e.g. from turn 10 back to 1 after "PLAY AGAIN").
    if (state.turnNumber < _lastTurnNumber) {
      _lastTurnNumber = state.turnNumber;
      _rebuildEngineEntities(state);
      return;
    }
    _lastTurnNumber = state.turnNumber;

    _syncHighlights(state);
    _syncSelection(state);
    _syncHPBars(state);
  }

  /// Rebuilds all engine entities from scratch after a game restart.
  ///
  /// When the player clicks "PLAY AGAIN", the game state is replaced with
  /// a fresh state. This method tears down the old engine visuals and
  /// creates new entities matching the reset board.
  void _rebuildEngineEntities(GameState state) {
    _controller.cancelAnimations();
    _controller.clearHighlights();
    _controller.clear();
    _controller.addEntities(_buildEntities(state));
    _decoratorsApplied = false;

    // Re-apply decorators after the engine has re-spawned entities.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), _setupDecorators);
    });
  }

  /// Updates tile overlays for valid moves, attack range, and ability targets.
  ///
  /// Clears all existing highlights first, then re-applies overlays for
  /// whichever lists are non-empty in the current [state].
  void _syncHighlights(GameState state) {
    // Clear all existing highlights.
    _controller.clearHighlights();

    // Valid move highlights (green).
    if (state.validMoves.isNotEmpty) {
      _controller.highlightTiles(
        state.validMoves
            .map((p) => map_engine.GridPosition(p.x, p.y))
            .toList(),
        map_engine.HighlightStyle.validMove,
      );
    }

    // Attack target highlights (red) -- targets are Units, map via position.
    if (state.attackTargets.isNotEmpty) {
      _controller.highlightTiles(
        state.attackTargets
            .map((u) => map_engine.GridPosition(u.position.x, u.position.y))
            .toList(),
        map_engine.HighlightStyle.attackRange,
      );
    }

    // Re-apply ability highlights if targeting mode is active.
    if (_viewModel.isAbilityTargeting.value && state.abilityTargets.isNotEmpty) {
      _controller.highlightTiles(
        state.abilityTargets
            .map((p) => map_engine.GridPosition(p.x, p.y))
            .toList(),
        map_engine.HighlightStyle.abilityTarget,
      );
    }

    // Selection highlight (yellow on selected unit's tile).
    if (state.selectedUnit != null) {
      _controller.setSelection(
        map_engine.GridPosition(
          state.selectedUnit!.position.x,
          state.selectedUnit!.position.y,
        ),
      );
    }
  }

  /// Updates selection ring decorators on entities.
  ///
  /// Removes selection ring from all entities, then adds one to the
  /// currently selected unit (if any).
  void _syncSelection(GameState state) {
    // Deselect all entities.
    for (final unit in state.board.units.where((u) => u.isAlive)) {
      _controller.setSelected(unit.id, selected: false);
    }

    // Select current unit.
    if (state.selectedUnit != null) {
      _controller.setSelected(
        state.selectedUnit!.id,
        selected: true,
        color: AppTheme.selectionColor,
      );
    }
  }

  /// Updates HP bars for all living units.
  ///
  /// This catches HP changes from attacks, abilities, etc.
  void _syncHPBars(GameState state) {
    for (final unit in state.board.units.where((u) => u.isAlive)) {
      _controller.updateHP(unit.id, unit.hpRatio);
    }
  }

  /// Handles changes to ability targeting mode.
  ///
  /// When activated, renders ability target highlights on the board.
  /// When deactivated, clears them.
  void _onAbilityTargetingChanged(bool isTargeting) {
    if (isTargeting) {
      final state = _viewModel.gameState.value;
      if (state.abilityTargets.isNotEmpty) {
        _controller.highlightTiles(
          state.abilityTargets
              .map((p) => map_engine.GridPosition(p.x, p.y))
              .toList(),
          map_engine.HighlightStyle.abilityTarget,
        );
      }
    } else {
      _controller.clearHighlights(group: 'abilityTarget');
    }
  }

  // -----------------------------------------------------------------------
  // Tap Handling
  // -----------------------------------------------------------------------

  /// Handles tile taps from the engine and delegates to [BattleActions].
  ///
  /// Converts the engine's [GridPosition] to the tactical grid's own
  /// [GridPosition] and forwards the tap to the action layer. Ignores
  /// taps while the engine is animating or input is blocked.
  void _onTileTap(map_engine.GridPosition pos) {
    if (_controller.isAnimating || _controller.inputManager.isBlocked) return;

    final actions = Get.find<BattleActions>();
    actions.onTileTapped(context, GridPosition(pos.x, pos.y));
  }

  // -----------------------------------------------------------------------
  // Build
  // -----------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return map_engine.FiftyMapWidget(
      grid: _grid,
      controller: _controller,
      initialEntities: _buildEntities(_viewModel.gameState.value),
      onEntityTap: (_) {}, // All input handled through onTileTap.
      onTileTap: _onTileTap,
    );
  }
}
