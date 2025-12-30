import 'package:flame/components.dart';
import 'package:fifty_map_engine/src/components/base/extension.dart';
import 'package:fifty_map_engine/src/components/base/model.dart';
import 'package:fifty_map_engine/src/components/base/component.dart';
import 'package:fifty_map_engine/src/view/map_builder.dart';

/// **FiftyMapController**
///
/// Acts as a thin, UI-friendly facade around a running [FiftyMapBuilder]. It lets
/// you bind/unbind a game instance, add/update/remove entities, move them by
/// grid coordinates, focus the camera, and perform zoom actions - all without
/// directly touching the game internals from your widgets or higher-level logic.
///
/// **When to use:**
/// - From a Flutter widget (e.g., `FiftyMapWidget`) that hosts the map game.
/// - From a view model / controller layer that needs to trigger map changes.
/// - From debug tooling or scripted sequences that manipulate the board.
///
/// **Design notes:**
/// - Safe-by-default: if no game is bound (`isBound == false`), public methods
///   are **no-ops** (they simply return) - avoiding crashes during init/teardown.
/// - Movement helpers operate only on components that implement
///   [FiftyMovableComponent]. Non-movable entities are ignored.
/// - Uses world-space positions computed by your models (via
///   [FiftyMapEntity.position] and its helpers in `extension.dart`).
///
/// **Typical lifecycle:**
/// 1) Construct the controller.
/// 2) Bind it to a running [FiftyMapBuilder] via [bind].
/// 3) Drive changes (add/move/remove/center/zoom) while the game is alive.
/// 4) Call [unbind] to safely tear down and release the game reference.
///
/// **Usage example:**
/// ```dart
/// final controller = FiftyMapController();
/// // In your FiftyMapWidget's onGameReady:
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
class FiftyMapController {
  // Binding

  FiftyMapBuilder? _game;

  /// **The bound [FiftyMapBuilder] instance.**
  ///
  /// **Throws** a `StateError` if accessed while unbound. Prefer checking
  /// [isBound] first, or use methods which no-op when unbound.
  FiftyMapBuilder get game => _game!;

  /// **Whether a game is currently bound.**
  bool get isBound => _game != null;

  /// **Binds this controller to a [FiftyMapBuilder].**
  ///
  /// Typically invoked by the hosting widget once the game is initialized.
  /// Rebinding simply replaces the reference.
  void bind(FiftyMapBuilder game) {
    _game = game;
  }

  /// **Unbinds the current game and cleans it up.**
  ///
  /// Invokes the game's teardown ([FiftyMapBuilder.destroy]) so Flame components
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
  void addEntities(List<FiftyMapEntity> entities) {
    if (!isBound) return;
    _game!.addEntities(entities);
  }

  /// **Removes a single entity from the map.**
  ///
  /// - [entity]: model identifying the entity to remove (by `id`).
  void removeEntity(FiftyMapEntity entity) {
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
  /// Computes the final world position using [FiftyMapEntity.position],
  /// adjusting for parent transforms if applicable. Movement only executes when
  /// the component is a [FiftyMovableComponent]. Others are ignored.
  void move(FiftyMapEntity entity, double x, double y) {
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
  void moveUp(FiftyMapEntity entity, double steps) {
    if (!isBound) return;
    final comp = _game!.getComponentById(entity.id);
    if (comp is FiftyMovableComponent) {
      comp.moveUp(steps);
    }
  }

  /// **Moves the entity down by [steps] grid blocks.**
  ///
  /// No-ops if unbound or the component is not movable.
  void moveDown(FiftyMapEntity entity, double steps) {
    if (!isBound) return;
    final comp = _game!.getComponentById(entity.id);
    if (comp is FiftyMovableComponent) {
      comp.moveDown(steps);
    }
  }

  /// **Moves the entity right by [steps] grid blocks.**
  ///
  /// No-ops if unbound or the component is not movable.
  void moveRight(FiftyMapEntity entity, double steps) {
    if (!isBound) return;
    final comp = _game!.getComponentById(entity.id);
    if (comp is FiftyMovableComponent) {
      comp.moveRight(steps);
    }
  }

  /// **Moves the entity left by [steps] grid blocks.**
  ///
  /// No-ops if unbound or the component is not movable.
  void moveLeft(FiftyMapEntity entity, double steps) {
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
  List<FiftyMapEntity> get currentEntities => _game?.initialEntities ?? [];

  /// **Lookup a component by its entity `id`.** Returns `null` if not found.
  FiftyBaseComponent? getComponentById(String id) {
    if (!isBound) return null;
    return _game!.getComponentById(id);
  }

  /// **Lookup a model by its entity `id`.** Returns `null` if not found.
  FiftyMapEntity? getEntityById(String id) {
    return getComponentById(id)?.model;
  }

  // Camera utilities

  /// **Centers the camera on all spawned entities.**
  ///
  /// Delegates to [FiftyMapBuilder.centerMap]. See that method for notes on how
  /// speed is derived from [duration].
  void centerMap({Duration duration = const Duration(seconds: 1)}) {
    if (!isBound) return;
    game.centerMap(duration: duration);
  }

  /// **Centers the camera on a specific [entity].**
  ///
  /// Delegates to [FiftyMapBuilder.centerOnEntity]. Only meaningful if the
  /// entity exists in the current world.
  void centerOnEntity(
    FiftyMapEntity entity, {
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
}
