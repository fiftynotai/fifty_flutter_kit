import 'package:flame/components.dart';
import 'package:fifty_world_engine/src/components/base/extension.dart';
import 'package:fifty_world_engine/src/components/base/model.dart';
import 'package:fifty_world_engine/src/components/base/component.dart';
import 'package:fifty_world_engine/src/view/world_builder.dart';
import 'package:fifty_world_engine/src/grid/grid_position.dart';
import 'package:fifty_world_engine/src/grid/tile_grid.dart';
import 'package:fifty_world_engine/src/grid/tile_overlay.dart';
import 'package:fifty_world_engine/src/grid/coordinate_adapter.dart';
import 'package:fifty_world_engine/src/components/overlays/overlay_manager.dart';
import 'package:fifty_world_engine/src/components/decorators/entity_decorator.dart';
import 'package:fifty_world_engine/src/components/decorators/health_bar_component.dart';
import 'package:fifty_world_engine/src/components/decorators/selection_ring_component.dart';
import 'package:fifty_world_engine/src/components/decorators/team_border_component.dart';
import 'package:fifty_world_engine/src/components/decorators/status_icon_component.dart';
import 'package:fifty_world_engine/src/components/effects/floating_text_component.dart';
import 'package:fifty_world_engine/src/input/input_manager.dart';
import 'package:fifty_world_engine/src/animation/animation_queue.dart';
import 'package:fifty_world_engine/src/pathfinding/grid_graph.dart';
import 'package:fifty_world_engine/src/pathfinding/pathfinder.dart';
import 'package:fifty_world_engine/src/pathfinding/movement_range.dart';
import 'dart:ui' show Color;

/// **FiftyWorldController**
///
/// Acts as a thin, UI-friendly facade around a running [FiftyWorldBuilder]. It lets
/// you bind/unbind a game instance, add/update/remove entities, move them by
/// grid coordinates, focus the camera, and perform zoom actions - all without
/// directly touching the game internals from your widgets or higher-level logic.
///
/// **When to use:**
/// - From a Flutter widget (e.g., `FiftyWorldWidget`) that hosts the map game.
/// - From a view model / controller layer that needs to trigger map changes.
/// - From debug tooling or scripted sequences that manipulate the board.
///
/// **Design notes:**
/// - Safe-by-default: if no game is bound (`isBound == false`), public methods
///   are **no-ops** (they simply return) - avoiding crashes during init/teardown.
/// - Movement helpers operate only on components that implement
///   [FiftyMovableComponent]. Non-movable entities are ignored.
/// - Uses world-space positions computed by your models (via
///   [FiftyWorldEntity.position] and its helpers in `extension.dart`).
///
/// **Typical lifecycle:**
/// 1) Construct the controller.
/// 2) Bind it to a running [FiftyWorldBuilder] via [bind].
/// 3) Drive changes (add/move/remove/center/zoom) while the game is alive.
/// 4) Call [unbind] to safely tear down and release the game reference.
///
/// **Usage example:**
/// ```dart
/// final controller = FiftyWorldController();
/// // In your FiftyWorldWidget's onGameReady:
/// controller.bind(game);
///
/// // Later, add or move entities
/// controller.addEntities(myEntities);
/// controller.move(entity, 10, 6);
/// controller.centerOnEntity(entity);
/// controller.zoomIn();
///
/// // On dispose
/// controller.unbind();
/// ```
///
/// **Caveats & tips:**
/// - [currentEntities] reflects the game's **initial** list only; it does not
///   reflect the union of dynamic changes. Query the game registry via
///   [getComponentById] / [getEntityById] for live state.
/// - Movement targets are **grid** coordinates; the controller computes the
///   final world position, adjusting for parents if any.
/// - All operations are synchronous proxies; spawning/animations inside the
///   game may occur asynchronously on the Flame tick.
class FiftyWorldController {
  // Binding

  FiftyWorldBuilder? _game;

  /// **The bound [FiftyWorldBuilder] instance.**
  ///
  /// **Throws** a `StateError` if accessed while unbound. Prefer checking
  /// [isBound] first, or use methods which no-op when unbound.
  FiftyWorldBuilder get game => _game!;

  /// **Whether a game is currently bound.**
  bool get isBound => _game != null;

  /// **Binds this controller to a [FiftyWorldBuilder].**
  ///
  /// Typically invoked by the hosting widget once the game is initialized.
  /// Rebinding simply replaces the reference.
  void bind(FiftyWorldBuilder game) {
    _game = game;
  }

  /// **Unbinds the current game and cleans it up.**
  ///
  /// Invokes the game's teardown ([FiftyWorldBuilder.destroy]) so Flame components
  /// are detached and resources can be GC'd. After unbinding, all controller
  /// operations become **no-ops** until a new game is bound.
  void unbind() {
    if (_game != null) {
      _game!.destroy();
      _game = null;
    }
  }

  // Entity orchestration

  /// **Adds or updates multiple entities on the map.**
  ///
  /// - [entities]: list of models to spawn or reconcile. Existing entities are
  ///   updated (position/children) while unknown ones are spawned.
  void addEntities(List<FiftyWorldEntity> entities) {
    if (!isBound) return;
    _game!.addEntities(entities);
  }

  /// **Removes a single entity from the map.**
  ///
  /// - [entity]: model identifying the entity to remove (by `id`).
  void removeEntity(FiftyWorldEntity entity) {
    if (!isBound) return;
    _game!.removeEntity(entity);
  }

  /// **Clears all entities from the map.**
  ///
  /// Useful when switching boards or reloading a scenario.
  void clear() {
    if (!isBound) return;
    _game!.clear();
  }

  // Movement helpers (grid -> world)

  /// **Moves an entity to a new grid position.**
  ///
  /// - [entity]: the model to move (its `id` must match a spawned component)
  /// - [x], [y]: target **grid** coordinates
  ///
  /// Computes the final world position using [FiftyWorldEntity.position],
  /// adjusting for parent transforms if applicable. Movement only executes when
  /// the component is a [FiftyMovableComponent]. Others are ignored.
  void move(FiftyWorldEntity entity, double x, double y) {
    if (!isBound) return;

    final updated = entity.changePosition(gridPosition: Vector2(x, y));
    var target = updated.position;

    // If the entity is parented, compose with parent world position
    if (entity.parentId != null) {
      final parent = _game!.getComponentById(entity.parentId!);
      if (parent != null) {
        target = updated.copyWithParent(parent.model.position).position;
      }
    }

    final comp = _game!.getComponentById(entity.id);
    if (comp is FiftyMovableComponent) {
      comp.moveTo(target, updated);
    }
  }

  /// **Moves the entity up by [steps] grid blocks.**
  ///
  /// No-ops if unbound or the component is not movable.
  void moveUp(FiftyWorldEntity entity, double steps) {
    if (!isBound) return;
    final comp = _game!.getComponentById(entity.id);
    if (comp is FiftyMovableComponent) {
      comp.moveUp(steps);
    }
  }

  /// **Moves the entity down by [steps] grid blocks.**
  ///
  /// No-ops if unbound or the component is not movable.
  void moveDown(FiftyWorldEntity entity, double steps) {
    if (!isBound) return;
    final comp = _game!.getComponentById(entity.id);
    if (comp is FiftyMovableComponent) {
      comp.moveDown(steps);
    }
  }

  /// **Moves the entity right by [steps] grid blocks.**
  ///
  /// No-ops if unbound or the component is not movable.
  void moveRight(FiftyWorldEntity entity, double steps) {
    if (!isBound) return;
    final comp = _game!.getComponentById(entity.id);
    if (comp is FiftyMovableComponent) {
      comp.moveRight(steps);
    }
  }

  /// **Moves the entity left by [steps] grid blocks.**
  ///
  /// No-ops if unbound or the component is not movable.
  void moveLeft(FiftyWorldEntity entity, double steps) {
    if (!isBound) return;
    final comp = _game!.getComponentById(entity.id);
    if (comp is FiftyMovableComponent) {
      comp.moveLeft(steps);
    }
  }

  // Lookups

  /// **Current list of initial entities.**
  ///
  /// Reflects the initial set passed to the game at construction time. It does
  /// **not** include entities added dynamically after start.
  List<FiftyWorldEntity> get currentEntities => _game?.initialEntities ?? [];

  /// **Lookup a component by its entity `id`.** Returns `null` if not found.
  FiftyBaseComponent? getComponentById(String id) {
    if (!isBound) return null;
    return _game!.getComponentById(id);
  }

  /// **Lookup a model by its entity `id`.** Returns `null` if not found.
  FiftyWorldEntity? getEntityById(String id) {
    return getComponentById(id)?.model;
  }

  // Camera utilities

  /// **Centers the camera on all spawned entities.**
  ///
  /// Delegates to [FiftyWorldBuilder.centerMap]. See that method for notes on how
  /// speed is derived from [duration].
  void centerMap({Duration duration = const Duration(seconds: 1)}) {
    if (!isBound) return;
    game.centerMap(duration: duration);
  }

  /// **Centers the camera on a specific [entity].**
  ///
  /// Delegates to [FiftyWorldBuilder.centerOnEntity]. Only meaningful if the
  /// entity exists in the current world.
  void centerOnEntity(
    FiftyWorldEntity entity, {
    Duration duration = const Duration(seconds: 1),
  }) {
    if (!isBound) return;
    game.centerOnEntity(entity, duration: duration);
  }

  /// **Zoom in** programmatically using the game's zoom helper.
  void zoomIn() {
    if (!isBound) return;
    game.zoomIn();
  }

  /// **Zoom out** programmatically using the game's zoom helper.
  void zoomOut() {
    if (!isBound) return;
    game.zoomOut();
  }

  // --- v2 Grid Systems ---

  /// Overlay manager for tile highlights.
  OverlayManager? _overlayManager;

  /// Input manager for blocking state.
  InputManager? _inputManager;

  /// Animation queue for sequential animations.
  AnimationQueue? _animationQueue;

  // Overlay Methods

  /// Highlights tiles at [positions] with the given [overlay] style.
  void highlightTiles(List<GridPosition> positions, TileOverlay overlay) {
    if (!isBound) return;
    _overlayManager ??= OverlayManager();
    _overlayManager!.addOverlays(positions, overlay, game.world);
  }

  /// Clears overlays by [group]. If null, clears ALL overlays.
  void clearHighlights({String? group}) {
    if (_overlayManager == null) return;
    if (group != null) {
      _overlayManager!.clearGroup(group);
    } else {
      _overlayManager!.clearAll();
    }
  }

  /// Sets a single tile as selected (yellow highlight). Pass null to deselect.
  void setSelection(GridPosition? position) {
    clearHighlights(group: 'selection');
    if (position != null) {
      highlightTiles([position], HighlightStyle.selection);
    }
  }

  // Decorator Methods

  /// Adds an HP bar to the entity with [entityId].
  void updateHP(String entityId, double ratio, {Color? color}) {
    if (!isBound) return;
    final comp = _game!.getComponentById(entityId);
    if (comp == null) return;

    // Find existing HP bar or create new one
    final existing = comp.children.whereType<HealthBarComponent>().firstOrNull;
    if (existing != null) {
      existing.ratio = ratio;
    } else {
      comp.add(HealthBarComponent(
        ratio: ratio,
        foregroundColor: color ?? const Color(0xFF4CAF50),
      ));
    }
  }

  /// Sets or removes selection ring on entity with [entityId].
  void setSelected(String entityId, {bool selected = true, Color? color}) {
    if (!isBound) return;
    final comp = _game!.getComponentById(entityId);
    if (comp == null) return;

    // Remove existing ring
    comp.children
        .whereType<SelectionRingComponent>()
        .toList()
        .forEach((r) => r.removeFromParent());

    if (selected) {
      comp.add(SelectionRingComponent(color: color ?? const Color(0xFFFFC107)));
    }
  }

  /// Sets team color border on entity with [entityId].
  void setTeamColor(String entityId, Color color) {
    if (!isBound) return;
    final comp = _game!.getComponentById(entityId);
    if (comp == null) return;

    // Remove existing team border
    comp.children
        .whereType<TeamBorderComponent>()
        .toList()
        .forEach((r) => r.removeFromParent());
    comp.add(TeamBorderComponent(color: color));
  }

  /// Adds a status icon to entity with [entityId].
  void addStatusIcon(String entityId, String label, {Color? color}) {
    if (!isBound) return;
    final comp = _game!.getComponentById(entityId);
    if (comp == null) return;
    comp.add(StatusIconComponent(
      label: label,
      color: color ?? const Color(0xFF9C27B0),
    ));
  }

  /// Removes all decorators from entity with [entityId].
  void removeDecorators(String entityId) {
    if (!isBound) return;
    final comp = _game!.getComponentById(entityId);
    if (comp == null) return;
    comp.children
        .whereType<EntityDecorator>()
        .toList()
        .forEach((d) => d.removeFromParent());
  }

  // Animation & Effects Methods

  /// Shows floating text at a grid position (e.g., damage popup).
  void showFloatingText(
    GridPosition position,
    String text, {
    Color? color,
    double? fontSize,
    double? duration,
  }) {
    if (!isBound) return;
    game.world.add(FloatingTextComponent(
      text: text,
      position: CoordinateAdapter.gridToCenterPixel(position),
      color: color ?? const Color(0xFFFF0000),
      fontSize: fontSize ?? 20.0,
      duration: duration ?? 1.0,
    ));
  }

  /// Whether animations are currently running.
  bool get isAnimating => _animationQueue?.isRunning ?? false;

  /// The input manager for this controller.
  InputManager get inputManager {
    _inputManager ??= InputManager();
    return _inputManager!;
  }

  /// Queues an animation entry. Input is automatically blocked during animations.
  void queueAnimation(AnimationEntry entry) {
    _ensureAnimationQueue();
    _animationQueue!.enqueue(entry);
  }

  /// Queues multiple animation entries.
  void queueAnimations(List<AnimationEntry> entries) {
    _ensureAnimationQueue();
    _animationQueue!.enqueueAll(entries);
  }

  /// Cancels all pending animations.
  void cancelAnimations() {
    _animationQueue?.cancel();
  }

  void _ensureAnimationQueue() {
    _animationQueue ??= AnimationQueue(
      onStart: () => inputManager.block(),
      onComplete: () => inputManager.unblock(),
    );
  }

  // Pathfinding Methods

  /// Finds the shortest path from [from] to [to] on the given [grid].
  ///
  /// Returns the path as a list of positions (start to goal inclusive),
  /// or null if no path exists.
  List<GridPosition>? findPath(
    GridPosition from,
    GridPosition to, {
    required TileGrid grid,
    Set<GridPosition>? blocked,
    bool diagonal = false,
  }) {
    final graph = GridGraph(
      grid: grid,
      blocked: blocked ?? const {},
      diagonal: diagonal,
    );
    return Pathfinder.findPath(start: from, goal: to, graph: graph);
  }

  /// Returns all positions reachable from [from] within [budget] movement points.
  Set<GridPosition> getMovementRange(
    GridPosition from, {
    required double budget,
    required TileGrid grid,
    Set<GridPosition>? blocked,
    bool diagonal = false,
  }) {
    final graph = GridGraph(
      grid: grid,
      blocked: blocked ?? const {},
      diagonal: diagonal,
    );
    return MovementRange.reachable(
      start: from,
      budget: budget,
      graph: graph,
    );
  }
}
