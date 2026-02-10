/// Tactical Skirmish Sandbox
///
/// A lightweight 2-player hot-seat tactical game showcasing 19/21
/// fifty_map_engine v2 features: tile grid, overlays, entity decorators,
/// animation queue, A* pathfinding, BFS movement range, and more.
library;

import 'package:fifty_map_engine/fifty_map_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ============================================================
// GAME DATA
// ============================================================

const _grass = TileType(
  id: 'grass',
  color: Color(0xFF4CAF50),
  walkable: true,
  movementCost: 1.0,
);
const _forest = TileType(
  id: 'forest',
  color: Color(0xFF2E7D32),
  walkable: true,
  movementCost: 2.0,
);
const _water = TileType(
  id: 'water',
  color: Color(0xFF1565C0),
  walkable: false,
);
const _wall = TileType(
  id: 'wall',
  color: Color(0xFF5D4037),
  walkable: false,
);

/// Unit stats for one game piece.
class UnitData {
  final String id;
  final String name;
  final String team; // 'blue' | 'red'
  final String unitType; // 'warrior' | 'archer' | 'mage'
  int hp;
  final int maxHp;
  final int atk;
  final int moveRange;
  final int atkRange;
  GridPosition position;

  UnitData({
    required this.id,
    required this.name,
    required this.team,
    required this.unitType,
    required this.hp,
    required this.maxHp,
    required this.atk,
    required this.moveRange,
    required this.atkRange,
    required this.position,
  });

  String get label => unitType == 'warrior'
      ? 'W'
      : unitType == 'archer'
          ? 'A'
          : 'M';

  bool get isBlue => team == 'blue';

  UnitData clone() => UnitData(
        id: id,
        name: name,
        team: team,
        unitType: unitType,
        hp: hp,
        maxHp: maxHp,
        atk: atk,
        moveRange: moveRange,
        atkRange: atkRange,
        position: GridPosition(position.x, position.y),
      );
}

List<UnitData> _initialUnits() => [
      // Blue team
      UnitData(
          id: 'blue_warrior',
          name: 'Blue Warrior',
          team: 'blue',
          unitType: 'warrior',
          hp: 100,
          maxHp: 100,
          atk: 25,
          moveRange: 3,
          atkRange: 1,
          position: const GridPosition(1, 2)),
      UnitData(
          id: 'blue_archer',
          name: 'Blue Archer',
          team: 'blue',
          unitType: 'archer',
          hp: 70,
          maxHp: 70,
          atk: 20,
          moveRange: 3,
          atkRange: 2,
          position: const GridPosition(1, 4)),
      UnitData(
          id: 'blue_mage',
          name: 'Blue Mage',
          team: 'blue',
          unitType: 'mage',
          hp: 60,
          maxHp: 60,
          atk: 35,
          moveRange: 2,
          atkRange: 2,
          position: const GridPosition(1, 6)),
      // Red team
      UnitData(
          id: 'red_warrior',
          name: 'Red Warrior',
          team: 'red',
          unitType: 'warrior',
          hp: 100,
          maxHp: 100,
          atk: 25,
          moveRange: 3,
          atkRange: 1,
          position: const GridPosition(8, 1)),
      UnitData(
          id: 'red_archer',
          name: 'Red Archer',
          team: 'red',
          unitType: 'archer',
          hp: 70,
          maxHp: 70,
          atk: 20,
          moveRange: 3,
          atkRange: 2,
          position: const GridPosition(8, 3)),
      UnitData(
          id: 'red_mage',
          name: 'Red Mage',
          team: 'red',
          unitType: 'mage',
          hp: 60,
          maxHp: 60,
          atk: 35,
          moveRange: 2,
          atkRange: 2,
          position: const GridPosition(8, 5)),
    ];

TileGrid _buildMap() {
  final grid = TileGrid(width: 10, height: 8);
  grid.fill(_grass);
  // Forests
  grid.fillRect(const GridPosition(3, 1), 2, 2, _forest);
  grid.fillRect(const GridPosition(6, 4), 2, 2, _forest);
  // Water
  grid.fillRect(const GridPosition(4, 3), 2, 2, _water);
  // Walls
  for (final p in [
    const GridPosition(0, 0),
    const GridPosition(9, 7),
    const GridPosition(5, 0),
    const GridPosition(4, 7),
  ]) {
    grid.setTile(p, _wall);
  }
  return grid;
}

// ============================================================
// GAME STATE
// ============================================================

class GameState {
  List<UnitData> units;
  String? selectedUnitId;
  bool isBlueTeam;
  bool hasMoved;
  bool hasAttacked;
  String? winner;

  /// Positions currently shown as valid moves.
  Set<GridPosition> moveTargets;

  /// Positions currently shown as attack range.
  Set<GridPosition> attackTargets;

  GameState({required this.units})
      : isBlueTeam = true,
        hasMoved = false,
        hasAttacked = false,
        selectedUnitId = null,
        winner = null,
        moveTargets = {},
        attackTargets = {};

  UnitData? get selectedUnit =>
      selectedUnitId == null ? null : _unitById(selectedUnitId!);

  UnitData? _unitById(String id) {
    for (final u in units) {
      if (u.id == id) return u;
    }
    return null;
  }

  UnitData? unitAt(GridPosition pos) {
    for (final u in units) {
      if (u.position == pos) return u;
    }
    return null;
  }

  Set<GridPosition> get occupiedPositions =>
      units.map((u) => u.position).toSet();
}

// ============================================================
// APP
// ============================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  runApp(const TacticalSkirmishApp());
}

/// Root widget with dark theme.
class TacticalSkirmishApp extends StatelessWidget {
  const TacticalSkirmishApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tactical Skirmish Sandbox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const TacticalSkirmishPage(),
    );
  }
}

// ============================================================
// GAME PAGE
// ============================================================

/// The main game screen.
class TacticalSkirmishPage extends StatefulWidget {
  const TacticalSkirmishPage({super.key});

  @override
  State<TacticalSkirmishPage> createState() => _TacticalSkirmishPageState();
}

class _TacticalSkirmishPageState extends State<TacticalSkirmishPage> {
  late FiftyMapController _controller;
  late TileGrid _grid;
  late GameState _state;
  bool _decoratorsApplied = false;

  static const _blueColor = Color(0xFF2196F3);
  static const _redColor = Color(0xFFF44336);

  @override
  void initState() {
    super.initState();
    _controller = FiftyMapController();
    _grid = _buildMap();
    _state = GameState(units: _initialUnits());
    // Apply decorators after the game engine has spawned the entities.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), _setupDecorators);
    });
  }

  // --- Entity building ---

  List<FiftyMapEntity> _buildEntities() {
    return _state.units.map((u) {
      return FiftyMapEntity(
        id: u.id,
        type: 'character',
        asset: '',
        gridPosition: Vector2(u.position.x.toDouble(), u.position.y.toDouble()),
        blockSize: FiftyBlockSize(1, 1),
      );
    }).toList();
  }

  // --- Decorator setup ---

  void _setupDecorators() {
    if (_decoratorsApplied) return;
    _decoratorsApplied = true;
    for (final unit in _state.units) {
      _controller.setTeamColor(
          unit.id, unit.isBlue ? _blueColor : _redColor);
      _controller.updateHP(unit.id, unit.hp / unit.maxHp);
      _controller.addStatusIcon(unit.id, unit.label);
    }
    // Zoom out to fit grid, then center camera on entities
    _controller.zoomOut();
    _controller.zoomOut();
    _controller.centerMap();
  }

  // --- Tap handlers ---

  void _onEntityTap(FiftyMapEntity entity) {
    if (_state.winner != null) return;
    if (_controller.isAnimating || _controller.inputManager.isBlocked) return;
    final unit = _state.units.where((u) => u.id == entity.id).firstOrNull;
    if (unit == null) return;
    final isOwnTeam =
        (unit.isBlue && _state.isBlueTeam) || (!unit.isBlue && !_state.isBlueTeam);
    if (isOwnTeam) {
      _selectUnit(unit);
    } else {
      // Tapped enemy - check if in attack range
      if (_state.attackTargets.contains(unit.position)) {
        _attackUnit(unit);
      }
    }
  }

  void _onTileTap(GridPosition pos) {
    if (_state.winner != null) return;
    if (_controller.isAnimating || _controller.inputManager.isBlocked) return;

    // Own unit at this tile?
    final unitHere = _state.unitAt(pos);
    if (unitHere != null) {
      final isOwn = (unitHere.isBlue && _state.isBlueTeam) ||
          (!unitHere.isBlue && !_state.isBlueTeam);
      if (isOwn) {
        _selectUnit(unitHere);
        return;
      }
      // Enemy at this tile - check attack range
      if (_state.attackTargets.contains(pos)) {
        _attackUnit(unitHere);
        return;
      }
    }

    // Move to this tile?
    if (_state.moveTargets.contains(pos) && !_state.hasMoved) {
      _moveUnit(pos);
      return;
    }

    // Deselect
    _deselectUnit();
  }

  // --- Selection ---

  void _selectUnit(UnitData unit) {
    // Deselect previous
    if (_state.selectedUnitId != null) {
      _controller.setSelected(_state.selectedUnitId!, selected: false);
    }
    _controller.clearHighlights();

    setState(() {
      _state.selectedUnitId = unit.id;
      _state.hasMoved = false;
      _state.hasAttacked = false;
      _state.moveTargets = {};
      _state.attackTargets = {};
    });

    // Selection ring
    _controller.setSelected(unit.id, selected: true);
    _controller.setSelection(unit.position);

    // Movement range (BFS)
    if (!_state.hasMoved) {
      final blocked = _state.occupiedPositions..remove(unit.position);
      final reachable = _controller.getMovementRange(
        unit.position,
        budget: unit.moveRange.toDouble(),
        grid: _grid,
        blocked: blocked,
      )..remove(unit.position);

      if (reachable.isNotEmpty) {
        _controller.highlightTiles(reachable.toList(), HighlightStyle.validMove);
      }
      setState(() => _state.moveTargets = reachable);
    }

    // Attack range
    _showAttackRange(unit);
  }

  void _showAttackRange(UnitData unit) {
    final atkPositions = <GridPosition>{};
    for (final pos in _grid.allPositions) {
      if (pos.manhattanDistanceTo(unit.position) <= unit.atkRange &&
          pos != unit.position) {
        atkPositions.add(pos);
      }
    }
    if (atkPositions.isNotEmpty) {
      _controller.highlightTiles(
          atkPositions.toList(), HighlightStyle.attackRange);
    }
    setState(() => _state.attackTargets = atkPositions);
  }

  void _deselectUnit() {
    if (_state.selectedUnitId != null) {
      _controller.setSelected(_state.selectedUnitId!, selected: false);
    }
    _controller.clearHighlights();
    setState(() {
      _state.selectedUnitId = null;
      _state.moveTargets = {};
      _state.attackTargets = {};
    });
  }

  // --- Movement ---

  void _moveUnit(GridPosition target) {
    final unit = _state.selectedUnit;
    if (unit == null) return;

    // A* pathfinding to compute the optimal route
    final blocked = _state.occupiedPositions.difference({unit.position});
    final path = _controller.findPath(
      unit.position,
      target,
      grid: _grid,
      blocked: blocked,
    );
    if (path == null || path.length < 2) return;

    _controller.clearHighlights(group: 'validMoves');

    // Queue step-by-step movement along the A* path
    for (int i = 1; i < path.length; i++) {
      final step = path[i];
      final isLast = i == path.length - 1;
      _controller.queueAnimation(AnimationEntry(
        execute: () async {
          final entity = _controller.getEntityById(unit.id);
          if (entity == null) return;
          _controller.move(entity, step.x.toDouble(), step.y.toDouble());
          await Future<void>.delayed(const Duration(milliseconds: 250));
        },
        onComplete: isLast
            ? () {
                setState(() {
                  unit.position = target;
                  _state.hasMoved = true;
                  _state.moveTargets = {};
                });
                // Show attack range from new position
                _controller.clearHighlights(group: 'attackRange');
                _showAttackRange(unit);
              }
            : null,
      ));
    }
  }

  // --- Attack ---

  void _attackUnit(UnitData enemy) {
    final attacker = _state.selectedUnit;
    if (attacker == null) return;
    if (_state.hasAttacked) return;

    final attackerComp = _controller.getComponentById(attacker.id);
    if (attackerComp == null || attackerComp is! FiftyMovableComponent) return;

    final damage = attacker.atk;
    enemy.hp = (enemy.hp - damage).clamp(0, enemy.maxHp);

    _controller.clearHighlights();

    // Attack animation
    _controller.queueAnimation(AnimationEntry.timed(
      action: () => attackerComp.attack(),
      duration: const Duration(milliseconds: 250),
    ));

    // Damage popup + HP update
    _controller.queueAnimation(AnimationEntry.timed(
      action: () {
        _controller.showFloatingText(
          enemy.position,
          '-$damage',
          color: const Color(0xFFFFFF00),
          fontSize: 24,
        );
        _controller.updateHP(
          enemy.id,
          enemy.hp / enemy.maxHp,
          color: enemy.hp / enemy.maxHp > 0.5
              ? const Color(0xFF4CAF50)
              : const Color(0xFFF44336),
        );
      },
      duration: const Duration(milliseconds: 400),
    ));

    // Death or end turn
    if (enemy.hp <= 0) {
      final enemyComp = _controller.getComponentById(enemy.id);
      if (enemyComp is FiftyMovableComponent) {
        _controller.queueAnimation(AnimationEntry(
          execute: () async {
            enemyComp.die();
            await Future<void>.delayed(const Duration(milliseconds: 600));
          },
          onComplete: () {
            final enemyEntity = _controller.getEntityById(enemy.id);
            if (enemyEntity != null) {
              _controller.removeEntity(enemyEntity);
            }
            setState(() {
              _state.units.removeWhere((u) => u.id == enemy.id);
              _state.hasAttacked = true;
            });
            _checkWin();
            if (_state.winner == null) _endTurn();
          },
        ));
      }
    } else {
      _controller.queueAnimation(AnimationEntry.timed(
        action: () {},
        duration: const Duration(milliseconds: 100),
        onComplete: () {
          setState(() => _state.hasAttacked = true);
          _endTurn();
        },
      ));
    }
  }

  // --- Turn management ---

  void _endTurn() {
    if (_state.selectedUnitId != null) {
      _controller.setSelected(_state.selectedUnitId!, selected: false);
    }
    _controller.clearHighlights();
    setState(() {
      _state.selectedUnitId = null;
      _state.isBlueTeam = !_state.isBlueTeam;
      _state.hasMoved = false;
      _state.hasAttacked = false;
      _state.moveTargets = {};
      _state.attackTargets = {};
    });
  }

  void _checkWin() {
    final hasBlue = _state.units.any((u) => u.isBlue);
    final hasRed = _state.units.any((u) => !u.isBlue);
    if (!hasBlue) {
      setState(() => _state.winner = 'Red');
    } else if (!hasRed) {
      setState(() => _state.winner = 'Blue');
    }
  }

  void _restart() {
    _controller.clearHighlights();
    _controller.cancelAnimations();
    _controller.clear();
    _decoratorsApplied = false;
    setState(() {
      _state = GameState(units: _initialUnits());
    });
    _controller.addEntities(_buildEntities());
    Future.delayed(const Duration(milliseconds: 300), _setupDecorators);
  }

  // --- Build ---

  @override
  Widget build(BuildContext context) {
    final teamName = _state.isBlueTeam ? 'Blue' : 'Red';
    final teamColor = _state.isBlueTeam ? _blueColor : _redColor;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(color: teamColor, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text('$teamName Team\'s Turn'),
          ],
        ),
        actions: [
          if (_state.winner == null)
            TextButton(
              onPressed: () => _endTurn(),
              child: const Text('End Turn', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Stack(
        children: [
          FiftyMapWidget(
            grid: _grid,
            controller: _controller,
            initialEntities: _buildEntities(),
            onEntityTap: _onEntityTap,
            onTileTap: _onTileTap,
          ),
          if (_state.winner != null) _buildWinOverlay(),
        ],
      ),
    );
  }

  Widget _buildWinOverlay() {
    final color = _state.winner == 'Blue' ? _blueColor : _redColor;
    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          color: Colors.grey[900],
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${_state.winner} Team Wins!',
                  style: TextStyle(fontSize: 32, color: color, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: _restart,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Play Again'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
