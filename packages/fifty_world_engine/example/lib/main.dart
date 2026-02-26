/// FDL Tactical Grid Demo
///
/// A concise example showcasing `fifty_world_engine` capabilities:
/// tile grid rendering, entity decorators (HP bars, team borders, status
/// icons), tile overlays, A* pathfinding, and tap interaction -- all themed
/// with the Fifty Design Language.
///
/// For a full-featured tactical game built on this engine, see
/// `apps/tactical_grid/` in the fifty_eco_system repository.
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_world_engine/fifty_world_engine.dart';
import 'package:flutter/material.dart';

// ============================================================
// TILE TYPE DEFINITIONS
// ============================================================

const _grass = TileType(
  id: 'grass',
  asset: 'tiles/tile_dark.png',
  color: Color(0xFF4CAF50),
  walkable: true,
  movementCost: 1.0,
);

const _forest = TileType(
  id: 'forest',
  asset: 'tiles/tile_dark.png',
  color: Color(0xFF2E7D32),
  walkable: true,
  movementCost: 2.0,
);

const _water = TileType(
  id: 'water',
  asset: 'tiles/tile_dark.png',
  color: Color(0xFF1565C0),
  walkable: false,
);

const _wall = TileType(
  id: 'wall',
  asset: 'tiles/tile_dark.png',
  color: Color(0xFF5D4037),
  walkable: false,
);

// ============================================================
// DEMO DATA
// ============================================================

/// Lightweight unit data for the demo. No HP tracking, no attack logic.
class _DemoUnit {
  final String id;
  final String name;
  final String team; // 'blue' | 'red'
  final String asset;
  final int moveRange;
  GridPosition position;

  _DemoUnit({
    required this.id,
    required this.name,
    required this.team,
    required this.asset,
    required this.moveRange,
    required this.position,
  });

  bool get isBlue => team == 'blue';

  /// First letter of the unit class for the status icon.
  String get label => name.split(' ').last[0].toUpperCase();
}

List<_DemoUnit> _initialUnits() => [
      // Blue team (left side)
      _DemoUnit(
        id: 'blue_commander',
        name: 'Blue Commander',
        team: 'blue',
        asset: 'units/player_commander.png',
        moveRange: 3,
        position: const GridPosition(1, 1),
      ),
      _DemoUnit(
        id: 'blue_archer',
        name: 'Blue Archer',
        team: 'blue',
        asset: 'units/player_archer.png',
        moveRange: 3,
        position: const GridPosition(1, 4),
      ),
      _DemoUnit(
        id: 'blue_mage',
        name: 'Blue Mage',
        team: 'blue',
        asset: 'units/player_mage.png',
        moveRange: 2,
        position: const GridPosition(1, 6),
      ),
      // Red team (right side)
      _DemoUnit(
        id: 'red_commander',
        name: 'Red Commander',
        team: 'red',
        asset: 'units/enemy_commander.png',
        moveRange: 3,
        position: const GridPosition(6, 1),
      ),
      _DemoUnit(
        id: 'red_archer',
        name: 'Red Archer',
        team: 'red',
        asset: 'units/enemy_archer.png',
        moveRange: 3,
        position: const GridPosition(6, 3),
      ),
      _DemoUnit(
        id: 'red_mage',
        name: 'Red Mage',
        team: 'red',
        asset: 'units/enemy_mage.png',
        moveRange: 2,
        position: const GridPosition(6, 5),
      ),
    ];

TileGrid _buildGrid() {
  final grid = TileGrid(width: 8, height: 8);
  grid.fill(_grass);
  // Forest patches
  grid.fillRect(const GridPosition(2, 0), 2, 2, _forest);
  grid.fillRect(const GridPosition(5, 5), 2, 2, _forest);
  // Water strip (river crossing)
  grid.setTile(const GridPosition(3, 3), _water);
  grid.setTile(const GridPosition(4, 3), _water);
  // Wall obstacles
  grid.setTile(const GridPosition(0, 0), _wall);
  grid.setTile(const GridPosition(7, 7), _wall);
  grid.setTile(const GridPosition(5, 0), _wall);
  grid.setTile(const GridPosition(4, 7), _wall);
  return grid;
}

// ============================================================
// APP ENTRY POINT
// ============================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FiftyAssetLoader.registerAssets([
    'units/player_commander.png',
    'units/player_archer.png',
    'units/player_mage.png',
    'units/enemy_commander.png',
    'units/enemy_archer.png',
    'units/enemy_mage.png',
    'tiles/tile_dark.png',
  ]);
  runApp(const FdlTacticalGridDemo());
}

/// Root widget wrapped in [FiftyTheme] with system-based light/dark support.
class FdlTacticalGridDemo extends StatelessWidget {
  const FdlTacticalGridDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FDL Tactical Grid Demo',
      debugShowCheckedModeBanner: false,
      theme: FiftyTheme.dark(),
      darkTheme: FiftyTheme.dark(),
      themeMode: ThemeMode.dark,
      home: const DemoPage(),
    );
  }
}

// ============================================================
// DEMO PAGE
// ============================================================

/// Main demo page: grid + entities + decorators + tap-to-select + movement.
class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  late FiftyWorldController _controller;
  late TileGrid _grid;
  late List<_DemoUnit> _units;

  String? _selectedUnitId;
  Set<GridPosition> _moveTargets = {};
  bool _decoratorsApplied = false;
  bool _isMoving = false;

  @override
  void initState() {
    super.initState();
    _controller = FiftyWorldController();
    _grid = _buildGrid();
    _units = _initialUnits();
    // Apply decorators after the engine has spawned entities.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), _setupDecorators);
    });
  }

  // --- Entity building ---

  List<FiftyWorldEntity> _buildEntities() {
    return _units.map((u) {
      return FiftyWorldEntity(
        id: u.id,
        type: 'character',
        asset: u.asset,
        // ignore: deprecated_export_use
        gridPosition: Vector2(u.position.x.toDouble(), u.position.y.toDouble()),
        blockSize: FiftyBlockSize(1, 1),
      );
    }).toList();
  }

  // --- Decorator setup ---

  void _setupDecorators() {
    if (_decoratorsApplied) return;
    _decoratorsApplied = true;

    for (final unit in _units) {
      // Team border: blue = slateGrey, red = burgundy.
      _controller.setTeamColor(
        unit.id,
        unit.isBlue ? FiftyColors.slateGrey : FiftyColors.burgundy,
      );
      // HP bar at full health.
      _controller.updateHP(unit.id, 1.0);
      // Status icon with unit class initial.
      _controller.addStatusIcon(unit.id, unit.label);
    }

    // Centre camera on the grid (retry if engine not ready).
    _centerCamera();
  }

  /// Zooms out and snaps the camera to the grid centre.
  ///
  /// Retries if the engine camera is not yet initialised.
  void _centerCamera() {
    try {
      _controller.zoomOut();
      _controller.zoomOut();
      const tileSize = FiftyWorldConfig.blockSize;
      _controller.game.cameraComponent.viewfinder.position =
          // ignore: deprecated_export_use
          Vector2(4 * tileSize, 4 * tileSize);
    } catch (_) {
      // Camera not ready yet; retry shortly.
      Future.delayed(const Duration(milliseconds: 300), _centerCamera);
    }
  }

  // --- Tap handlers ---

  /// All input is handled through tile taps (same pattern as the full app).
  void _onEntityTap(FiftyWorldEntity entity) {}

  void _onTileTap(GridPosition pos) {
    if (_isMoving) return;
    if (_controller.isAnimating || _controller.inputManager.isBlocked) return;

    // Check if a unit is at this tile.
    final unitHere = _unitAt(pos);
    if (unitHere != null) {
      _selectUnit(unitHere);
      return;
    }

    // Move to highlighted tile.
    if (_moveTargets.contains(pos) && _selectedUnitId != null) {
      _moveUnit(pos);
      return;
    }

    // Deselect.
    _deselectUnit();
  }

  _DemoUnit? _unitAt(GridPosition pos) {
    for (final u in _units) {
      if (u.position == pos) return u;
    }
    return null;
  }

  _DemoUnit? _unitById(String id) {
    for (final u in _units) {
      if (u.id == id) return u;
    }
    return null;
  }

  // --- Selection ---

  void _selectUnit(_DemoUnit unit) {
    // Deselect previous.
    if (_selectedUnitId != null) {
      _controller.setSelected(_selectedUnitId!, selected: false);
    }
    _controller.clearHighlights();

    setState(() {
      _selectedUnitId = unit.id;
      _moveTargets = {};
    });

    // Selection ring + tile highlight.
    _controller.setSelected(unit.id, selected: true);
    _controller.setSelection(unit.position);

    // Movement range (BFS).
    final occupied = _units.map((u) => u.position).toSet()
      ..remove(unit.position);
    final reachable = _controller.getMovementRange(
      unit.position,
      budget: unit.moveRange.toDouble(),
      grid: _grid,
      blocked: occupied,
    )..remove(unit.position);

    if (reachable.isNotEmpty) {
      _controller.highlightTiles(reachable.toList(), HighlightStyle.validMove);
    }
    setState(() => _moveTargets = reachable);
  }

  void _deselectUnit() {
    if (_selectedUnitId != null) {
      _controller.setSelected(_selectedUnitId!, selected: false);
    }
    _controller.clearHighlights();
    setState(() {
      _selectedUnitId = null;
      _moveTargets = {};
    });
  }

  // --- Movement ---

  void _moveUnit(GridPosition target) {
    final unit = _unitById(_selectedUnitId!);
    if (unit == null) return;
    if (!_moveTargets.contains(target)) return;

    _isMoving = true;

    // A* pathfinding.
    final blocked =
        _units.map((u) => u.position).toSet().difference({unit.position});
    final path = _controller.findPath(
      unit.position,
      target,
      grid: _grid,
      blocked: blocked,
    );
    if (path == null || path.length < 2) {
      _isMoving = false;
      return;
    }

    _controller.clearHighlights(group: 'validMoves');

    // Queue step-by-step movement along the A* path.
    for (int i = 1; i < path.length; i++) {
      final step = path[i];
      final isLast = i == path.length - 1;
      _controller.queueAnimation(AnimationEntry(
        execute: () async {
          final entity = _controller.getEntityById(unit.id);
          if (entity == null) return;
          _controller.move(entity, step.x.toDouble(), step.y.toDouble());
          await Future<void>.delayed(const Duration(milliseconds: 350));
        },
        onComplete: isLast
            ? () {
                setState(() {
                  unit.position = target;
                  _moveTargets = {};
                });
                _isMoving = false;
                _deselectUnit();
              }
            : null,
      ));
    }
  }

  // --- Build ---

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final selectedUnit =
        _selectedUnitId != null ? _unitById(_selectedUnitId!) : null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FDL Tactical Grid Demo',
          style: theme.textTheme.titleMedium,
        ),
      ),
      body: Column(
        children: [
          // Grid
          Expanded(
            child: FiftyWorldWidget(
              grid: _grid,
              controller: _controller,
              initialEntities: _buildEntities(),
              onEntityTap: _onEntityTap,
              onTileTap: _onTileTap,
            ),
          ),
          // Info panel
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: FiftySpacing.lg,
              vertical: FiftySpacing.md,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: colorScheme.outlineVariant,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Selected unit info or instruction.
                Text(
                  selectedUnit != null
                      ? '${selectedUnit.name} (${selectedUnit.team.toUpperCase()}) '
                          '-- Move range: ${selectedUnit.moveRange}'
                      : 'Tap a unit to select, then tap a green tile to move.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: FiftySpacing.sm),
                // Terrain legend.
                Row(
                  children: [
                    _legendDot(const Color(0xFF4CAF50), 'Grass',
                        theme.textTheme.bodySmall),
                    const SizedBox(width: FiftySpacing.md),
                    _legendDot(const Color(0xFF2E7D32), 'Forest (2x)',
                        theme.textTheme.bodySmall),
                    const SizedBox(width: FiftySpacing.md),
                    _legendDot(const Color(0xFF1565C0), 'Water',
                        theme.textTheme.bodySmall),
                    const SizedBox(width: FiftySpacing.md),
                    _legendDot(const Color(0xFF5D4037), 'Wall',
                        theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label, TextStyle? style) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: FiftySpacing.xs),
        Text(label, style: style),
      ],
    );
  }
}
