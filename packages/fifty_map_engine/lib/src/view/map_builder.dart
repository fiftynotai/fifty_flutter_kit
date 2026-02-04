import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:fifty_map_engine/src/components/base/extension.dart';
import 'package:fifty_map_engine/src/components/base/model.dart';
import 'package:fifty_map_engine/src/components/base/component.dart';
import 'package:fifty_map_engine/src/components/base/spawner.dart';
import 'package:fifty_map_engine/src/services/asset_loader_service.dart';

/// **FiftyMapBuilder**
///
/// A high-level `FlameGame` that renders and manages the interactive Fifty map.
/// It hosts the **World**, controls a **CameraComponent** (pan + pinch zoom),
/// and orchestrates entity lifecycle (spawn, update, remove) using the
/// [`FiftyEntitySpawner`].
///
/// **Key Features:**
/// - Bulk asset loading via [FiftyAssetLoader]
/// - Smooth pan and pinch-to-zoom gestures
/// - Programmatic zoom controls (in, out, reset)
/// - Render layering with [World] and [CameraComponent]
/// - Entity lifecycle handling (spawn, update, remove)
/// - Exposes [onEntityTap] for interaction callbacks
///
/// **Coordinate System Notes:**
/// - Positions are `Vector2` in world-space pixels (grid -> pixel mapping is
///   handled by your entity/component logic via [FiftyMapEntity.position]).
/// - Parent-relative entities compute their final position by composing the
///   parent's world position with their own local offsets.
///
/// **Gesture Model:**
/// - **One finger drag** -> pans the camera by subtracting the drag delta from
///   the `viewfinder.position`.
/// - **Two finger pinch** -> adjusts `viewfinder.zoom` based on the ratio
///   `currentDistance / initialDistance` clamped to [_minZoom]..[_maxZoom].
///   **Anchored at the pinch midpoint**: the world point under your fingers
///   remains stationary by offsetting the camera while zooming.
///
/// **Usage (example):**
/// ```dart
/// final game = FiftyMapBuilder(
///   initialEntities: myEntities,
///   onEntityTap: (entity) {
///     // handle taps
///   },
/// );
/// ```
///
/// **Known Limitations & Tips:**
/// - [`centerMap`] and [`centerOnEntity`] compute a *speed* from
///   `distance / duration.inSeconds`. If you pass sub-second durations, the
///   integer seconds may evaluate to `0`, producing very high speeds.
///   Prefer whole seconds or refactor to milliseconds if you need finer control.
/// - If you want to suppress taps during drags, handle that in the entity
///   components (e.g., guard tap handlers when a drag is active) or use a
///   higher-level gesture gate.
class FiftyMapBuilder extends FlameGame
    with HasCollisionDetection, MultiTouchDragDetector, TapDetector {
  // Construction

  /// **Entities to load at start.**
  ///
  /// These models will be spawned in [initializeGame] via [addEntities].
  final List<FiftyMapEntity> initialEntities;

  /// **Callback invoked when an entity is tapped.**
  ///
  /// Typically passed down to entity components that forward tap events.
  final FiftyMapTapCallback onEntityTap;

  /// **World container** for map entity components.
  ///
  /// The world holds renderable children (rooms, furniture, characters, etc.).
  @override
  late final World world;

  /// **Camera component** handling zoom and pan.
  ///
  /// Uses fixed-resolution matching the current game [size] at initialization.
  late final CameraComponent cameraComponent;

  /// **Internal registry** mapping entity IDs to their component instances.
  ///
  /// This mirrors the world graph for quick lookup, updates, and removals.
  final Map<String, FiftyBaseComponent> _componentsRegistry = {};

  /// **Zoom constraints** applied to [CameraComponent.viewfinder.zoom].
  final double _minZoom = 0.3, _maxZoom = 3.0;

  // Gesture State

  /// Active pointer IDs currently interacting with the game surface.
  final Set<int> _activePointers = {};

  /// Latest known global positions per active pointer.
  final Map<int, Vector2> _pointerPositions = {};

  /// Zoom value captured at the start of a pinch.
  double _pinchStartZoom = 1.0;

  /// Initial distance between two fingers at the start of a pinch.
  double _initialPinchDistance = 0.0;

  /// **Screen -> World** helper.
  ///
  /// Converts a point in screen/game coordinates to world coordinates,
  /// assuming the camera anchor is at the center (as configured).
  /// If [zoom] or [pos] are omitted, the current viewfinder values are used.
  Vector2 _screenToWorld(
    Vector2 screen, {
    double? zoom,
    Vector2? pos,
  }) {
    final vf = cameraComponent.viewfinder;
    final z = zoom ?? vf.zoom;
    final p = pos ?? vf.position;
    final half = Vector2(size.x / 2, size.y / 2); // anchor = center
    // world = (screen - half)/zoom + cameraPos
    return (screen - half) / z + p;
  }

  /// **Creates a new [FiftyMapBuilder].**
  ///
  /// - [initialEntities] - optional list to preload.
  /// - [onEntityTap] - callback for entity taps.
  FiftyMapBuilder({
    this.initialEntities = const [],
    required this.onEntityTap,
  }) : world = World();

  // Lifecycle

  /// **Load hook** - preloads assets, anchors camera, and initializes the game.
  @override
  Future<void> onLoad() async {
    await super.onLoad();
    await FiftyAssetLoader.loadAll(images);
    camera.viewfinder.anchor = Anchor.center;
    initializeGame();
  }

  /// **Sets up world, camera, and initial entities.**
  ///
  /// - Creates a [CameraComponent] that adapts to viewport size.
  /// - Centers the viewfinder and positions it at the origin.
  /// - Adds [world] and [cameraComponent] to the tree.
  /// - Spawns [initialEntities], if any.
  void initializeGame() {
    cameraComponent = CameraComponent(world: world);
    cameraComponent.viewfinder
      ..anchor = Anchor.center
      ..position = Vector2.zero();

    addAll([world, cameraComponent]);
    addEntities(initialEntities);
  }

  // Entity Management

  /// **Adds or updates a batch of entity models.**
  ///
  /// Existing entities are updated via [_onExitingEntity]; new ones are created
  /// via [_onNewEntity].
  Future<void> addEntities(List<FiftyMapEntity> models) async {
    for (final model in models) {
      final existing = getComponentById(model.id);
      if (existing != null) {
        _onExitingEntity(existing, model);
      } else {
        _onNewEntity(model);
      }
    }
  }

  /// **Removes the component corresponding to [model] from the world.**
  void removeEntity(FiftyMapEntity model) {
    final component = getComponentById(model.id);
    if (component != null) {
      _removeComponent(component);
    }
  }

  /// **Clears all entities from the map.**
  ///
  /// Removes components from the world and empties the internal registry.
  void clear() {
    world.removeAll(_componentsRegistry.values);
    _componentsRegistry.clear();
  }

  /// **Lookup** a component by its entity [id]. Returns `null` if not found.
  FiftyBaseComponent? getComponentById(String id) {
    return _componentsRegistry[id];
  }

  /// **Spawns and registers a new entity.**
  ///
  /// Uses [FiftyEntitySpawner.spawn] to create the concrete component and adds it
  /// to the [world].
  void spawnEntity(FiftyMapEntity model) {
    final component = FiftyEntitySpawner.spawn(model);
    saveEntity(model, component);
    world.add(component);
  }

  /// **Registers** a component in the internal registry.
  void saveEntity(FiftyMapEntity entity, FiftyBaseComponent component) {
    _componentsRegistry[entity.id] = component;
  }

  /// **Removes** a component instance from the world and unregisters it.
  void _removeComponent(FiftyBaseComponent component) {
    world.remove(component);
    _componentsRegistry.remove(component.model.id);
  }

  /// **Handles updates to an existing entity** by reconciling [newModel] with
  /// [oldComponent].
  ///
  /// Behavior:
  /// - If grid-position changed **and** the component is movable, animate the
  ///   movement via [FiftyMovableComponent.moveTo].
  /// - If it's not movable, despawn and respawn the entity.
  /// - If unchanged but it has children, recursively reconcile children.
  void _onExitingEntity(
    FiftyBaseComponent oldComponent,
    FiftyMapEntity newModel,
  ) {
    final oldModel = oldComponent.model;

    // Position changed -> animate or replace
    if (oldModel.gridPosition != newModel.gridPosition) {
      if (oldComponent is FiftyMovableComponent) {
        var updated = newModel;

        // If the entity is parented, adjust to the parent's position
        if (newModel.parentId != null) {
          final parent = getComponentById(newModel.parentId!);
          if (parent != null) {
            updated = newModel.copyWithParent(parent.model.position);
          }
        }

        final newPos = getNewPosition(
          oldComponent,
          updated.gridPosition.x,
          updated.gridPosition.y,
          newModel.parentId,
        );
        oldComponent.moveTo(newPos, updated);
      } else {
        _removeComponent(oldComponent);
        _onNewEntity(newModel);
      }

      // No position change -> reconcile children if provided
    } else if (newModel.components.isNotEmpty) {
      for (final child in newModel.components) {
        final existingChild = getComponentById(child.id);
        if (existingChild != null) {
          _onExitingEntity(existingChild, child);
        } else {
          _onNewEntity(child);
        }
      }
    }
  }

  /// **Handles spawning of a completely new entity.**
  ///
  /// - If it has a parent, delegates to the parent component via
  ///   [FiftyBaseComponent.spawnChild].
  /// - Otherwise spawns directly via [spawnEntity].
  void _onNewEntity(FiftyMapEntity model) {
    if (model.parentId != null) {
      final parentComp = getComponentById(model.parentId!);
      if (parentComp != null) {
        parentComp.spawnChild(model);
        return;
      }
    }
    spawnEntity(model);
  }

  /// **Computes a new world position** from grid coordinates [x], [y].
  ///
  /// - If a [parentId] (or the model's parent) exists, composes with the
  ///   parent's world position to yield a final world-space position.
  Vector2 getNewPosition(
    FiftyBaseComponent component,
    double x,
    double y, [
    String? parentId,
  ]) {
    final movedModel =
        component.model.changePosition(gridPosition: Vector2(x, y));
    var pos = movedModel.position;

    final pid = parentId ?? component.model.parentId;
    if (pid != null) {
      final parentComp = getComponentById(pid);
      if (parentComp != null) {
        pos = movedModel.copyWithParent(parentComp.model.position).position;
      }
    }
    return pos;
  }

  // Gesture Handling (Pan + Pinch Zoom)

  /// **Pointer down -> start drag/pinch tracking.**
  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    _activePointers.add(pointerId);
    _pointerPositions[pointerId] = info.eventPosition.global;
    super.onDragStart(pointerId, info);
  }

  /// **Pointer move -> pan or pinch.**
  ///
  /// - 1 pointer: pans the camera by `-delta` (screen -> world motion).
  /// - 2 pointers: updates pinch distance and scales zoom accordingly (midpoint anchored).
  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    _pointerPositions[pointerId] = info.eventPosition.global;

    if (_activePointers.length == 1) {
      // Pan camera with a single finger
      cameraComponent.viewfinder.position -= info.delta.global;
      return;
    }

    if (_activePointers.length == 2) {
      // Pinch zoom with two fingers - keep the midpoint anchored
      final positions = _pointerPositions.values.toList();
      if (positions.length < 2) return; // safety guard

      final currentDistance = positions[0].distanceTo(positions[1]);
      final midpoint = (positions[0] + positions[1]) / 2;

      if (_initialPinchDistance == 0.0) {
        _initialPinchDistance = currentDistance;
        _pinchStartZoom = cameraComponent.viewfinder.zoom;
        return;
      }

      // 1) Capture the world point under the pinch midpoint BEFORE zoom
      final worldBefore = _screenToWorld(midpoint);

      // 2) Apply new zoom (clamped)
      final newZoom =
          (_pinchStartZoom * (currentDistance / _initialPinchDistance))
              .clamp(_minZoom, _maxZoom);
      cameraComponent.viewfinder.zoom = newZoom;

      // 3) Where does that same screen point map AFTER zoom?
      final worldAfter = _screenToWorld(midpoint);

      // 4) Offset camera so the same world point stays under the fingers
      cameraComponent.viewfinder.position += (worldBefore - worldAfter);
      return;
    }
  }

  /// **Pointer up -> end drag/pinch tracking.**
  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    _activePointers.remove(pointerId);
    _pointerPositions.remove(pointerId);
    if (_activePointers.length < 2) _initialPinchDistance = 0.0;
    super.onDragEnd(pointerId, info);
  }

  /// **Pointer cancel -> clean up tracking state.**
  @override
  void onDragCancel(int pointerId) {
    _activePointers.remove(pointerId);
    _pointerPositions.remove(pointerId);
    if (_activePointers.length < 2) _initialPinchDistance = 0.0;
    super.onDragCancel(pointerId);
  }

  /// **Background color** for the game surface.
  @override
  Color backgroundColor() => Colors.black;

  // Programmatic Zoom Controls

  /// **Zooms in** by multiplying the current zoom by [factor] (default `1.2`).
  void zoomIn({double factor = 1.2}) {
    cameraComponent.viewfinder.zoom =
        (cameraComponent.viewfinder.zoom * factor).clamp(_minZoom, _maxZoom);
  }

  /// **Zooms out** by dividing the current zoom by [factor] (default `1.2`).
  void zoomOut({double factor = 1.2}) {
    cameraComponent.viewfinder.zoom =
        (cameraComponent.viewfinder.zoom / factor).clamp(_minZoom, _maxZoom);
  }

  /// **Resets** zoom to `1.0`.
  void resetZoom() {
    cameraComponent.viewfinder.zoom = 1.0;
  }

  // Camera Centering Helpers

  /// **Centers the camera on the full extent of all entities.**
  ///
  /// Calculates the bounding box of all component positions and moves the
  /// camera towards the midpoint. The *movement speed* is computed as
  /// `distance / duration.inSeconds` so that the viewfinder approximately
  /// reaches the target in [duration].
  void centerMap({Duration duration = const Duration(seconds: 1)}) {
    if (_componentsRegistry.isEmpty) return;

    final positions =
        _componentsRegistry.values.map((c) => c.position).toList();
    final minX = positions.map((p) => p.x).reduce((a, b) => a < b ? a : b);
    final maxX = positions.map((p) => p.x).reduce((a, b) => a > b ? a : b);
    final minY = positions.map((p) => p.y).reduce((a, b) => a < b ? a : b);
    final maxY = positions.map((p) => p.y).reduce((a, b) => a > b ? a : b);

    final center = Vector2((minX + maxX) / 2, (minY + maxY) / 2);
    final currentPos = cameraComponent.viewfinder.position;
    final distance = currentPos.distanceTo(center);

    // NOTE: uses seconds (integer). Prefer whole seconds to avoid `0` division.
    final speed = distance / duration.inSeconds;

    // Align center to camera viewport so it looks centered on screen.
    cameraComponent.moveTo(center, speed: speed);
  }

  /// **Centers the camera on a specific [entity]** over [duration].
  void centerOnEntity(
    FiftyMapEntity entity, {
    Duration duration = const Duration(seconds: 1),
  }) {
    final component = getComponentById(entity.id);
    if (component != null) {
      final target = component.position;
      final current = cameraComponent.viewfinder.position;
      final distance = current.distanceTo(target);

      // NOTE: uses seconds (integer). Prefer whole seconds to avoid `0` division.
      final speed = distance / duration.inSeconds;
      cameraComponent.moveTo(target, speed: speed);
    }
  }

  // Teardown

  /// **Tears down the game instance for safe disposal.**
  ///
  /// - Pauses the update loop.
  /// - Clears all spawned entities.
  ///
  /// *Note:* if you want to fully detach everything, you could also remove
  /// the camera/world or clear their children here.
  void destroy() {
    pauseEngine();
    clear(); // stop the update loop and remove entities
  }
}
