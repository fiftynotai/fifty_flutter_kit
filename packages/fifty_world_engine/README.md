# Fifty World Engine

[![pub package](https://img.shields.io/pub/v/fifty_world_engine.svg)](https://pub.dev/packages/fifty_world_engine)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Flame-based interactive grid map rendering for Flutter games. Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).

| Tactical Overview | Unit Selection & Pathfinding |
|:-----------------:|:---------------------------:|
| <img src="screenshots/tactical_overview_light.png" width="200"> | <img src="screenshots/unit_selection_light.png" width="200"> |

---

## Features

- **Tile Rendering** - Grid-based map with sprites for dungeon crawlers and strategy games
- **Camera Controls** - Smooth pan and pinch-to-zoom for map exploration
- **Entity Management** - Spawn, update, remove lifecycle for characters, rooms, monsters
- **Movement Animation** - Animated transitions for movable entities
- **Event Markers** - Overlay icons with customizable alignment
- **Asset Loading** - Registration-based asset loading and caching
- **JSON Serialization** - Map serialization/deserialization for level design
- **Custom Entity Types** - Register custom spawners for game-specific entities
- **Multi-Platform** - Full support for Android, iOS, macOS, Linux, Windows, and Web

---

## Installation

```yaml
dependencies:
  fifty_world_engine: ^0.1.2
```

### For Contributors

```yaml
dependencies:
  fifty_world_engine:
    path: ../fifty_world_engine
```

**Dependencies:** `flame`, `logging`

---

## Quick Start

```dart
import 'package:fifty_world_engine/fifty_world_engine.dart';

// 1. Register your assets before the game starts
FiftyAssetLoader.registerAssets([
  'rooms/room1.png',
  'rooms/room2.png',
  'characters/hero.png',
  'monsters/goblin.png',
  'events/npc.png',
  'events/basic.png',
  'events/master_of_shadow.png',
]);

// 2. Create your map entities
final entities = [
  FiftyWorldEntity(
    id: 'room1',
    type: 'room',
    asset: 'rooms/room1.png',
    gridPosition: Vector2(0, 0),
    blockSize: FiftyBlockSize(4, 3),
    components: [
      FiftyWorldEntity(
        id: 'hero',
        parentId: 'room1',
        type: 'character',
        asset: 'characters/hero.png',
        gridPosition: Vector2(1, 1),
        blockSize: FiftyBlockSize(1, 1),
      ),
    ],
  ),
];

// 3. Create controller and widget
final controller = FiftyWorldController();

FiftyWorldWidget(
  controller: controller,
  initialEntities: entities,
  onEntityTap: (entity) {
    print('Tapped: ${entity.id}');
  },
);

// 4. Use the controller to manipulate the map
controller.addEntities(newEntities);
controller.move(entity, 5, 3);
controller.centerOnEntity(entity);
controller.zoomIn();
```

---

## Architecture

```
FiftyWorldWidget (Flutter Widget)
    |
    +-- FiftyWorldController (UI Facade)
    |       Entity orchestration, camera control, lookups
    |
    +-- FiftyWorldBuilder (FlameGame)
            |
            +-- World (Entity Container)
            |       Holds all spawned components
            |
            +-- CameraComponent (View Control)
            |       Pan, zoom, center operations
            |
            +-- Entity Registry (Map<String, Component>)
                    Quick ID-based lookups
```

### Core Components

| Component | Description |
|-----------|-------------|
| `FiftyWorldController` | UI-friendly facade for map manipulation |
| `FiftyWorldBuilder` | FlameGame implementation with pan/zoom gestures |
| `FiftyWorldWidget` | Flutter widget embedding the map game |
| `FiftyWorldEntity` | Data model for map entities |
| `FiftyEntitySpawner` | Factory for creating entity components |

### Coordinate System

- **Grid coordinates**: Tile-based `(x, y)` where `(0, 0)` is bottom-left
- **Pixel coordinates**: `gridPosition * FiftyWorldConfig.blockSize`
- **Flame rendering**: Y-axis is flipped internally for correct display

---

## API Reference

### FiftyWorldController

UI-friendly facade for map manipulation.

```dart
final controller = FiftyWorldController();

/// Binding lifecycle
controller.bind(game);       // Bind to a FiftyWorldBuilder
controller.unbind();         // Unbind and cleanup
controller.isBound;          // Check if bound

/// Entity Management
controller.addEntities(entities);     // Add or update entities
controller.removeEntity(entity);      // Remove an entity
controller.clear();                   // Remove all entities

/// Movement (grid coordinates)
controller.move(entity, x, y);        // Move to position
controller.moveUp(entity, steps);     // Move up by steps
controller.moveDown(entity, steps);   // Move down by steps
controller.moveLeft(entity, steps);   // Move left by steps
controller.moveRight(entity, steps);  // Move right by steps

/// Lookups
controller.currentEntities;           // Initial entities list
controller.getComponentById(id);      // Get component by ID
controller.getEntityById(id);         // Get entity model by ID

/// Camera Control
controller.centerMap();               // Center on all entities
controller.centerOnEntity(entity);    // Center on specific entity
controller.zoomIn();                  // Zoom in (1.2x factor)
controller.zoomOut();                 // Zoom out (1.2x factor)
```

**Design Notes:**
- Safe-by-default: if no game is bound (`isBound == false`), public methods are no-ops
- Movement helpers only work on `FiftyMovableComponent` instances
- All operations are synchronous proxies; spawning/animations occur on Flame tick

### FiftyWorldBuilder

FlameGame implementation with pan/zoom gestures.

```dart
final game = FiftyWorldBuilder(
  initialEntities: entities,
  onEntityTap: (entity) => print('Tapped: ${entity.id}'),
);

/// Lifecycle
game.initializeGame();        // Setup world, camera, spawn initial entities
game.destroy();               // Pause engine and clear entities

/// Entity Management
game.addEntities(entities);   // Add or update batch of entities
game.removeEntity(entity);    // Remove single entity
game.clear();                 // Clear all entities
game.spawnEntity(entity);     // Spawn single entity

/// Lookups
game.getComponentById(id);    // Get component by ID
game.initialEntities;         // Original entity list

/// Camera Control
game.centerMap(duration: Duration(seconds: 1));
game.centerOnEntity(entity, duration: Duration(seconds: 1));
game.zoomIn(factor: 1.2);
game.zoomOut(factor: 1.2);
game.resetZoom();
```

**Gesture Model:**
- One finger drag: Pans the camera
- Two finger pinch: Zooms anchored at pinch midpoint
- Zoom range: 0.3x to 3.0x

### FiftyWorldWidget

Flutter widget embedding the map game.

```dart
FiftyWorldWidget(
  initialEntities: entities,        // Optional preloaded entities
  onEntityTap: (entity) => {...},   // Required tap callback
  controller: controller,           // Required controller
);
```

The widget:
- Automatically binds the controller to a new FiftyWorldBuilder
- Initializes with provided entities
- Forwards tap events via callback

### FiftyWorldEntity

Data model for map entities.

```dart
final entity = FiftyWorldEntity(
  id: 'room1',                           // Unique identifier (required)
  parentId: null,                        // Parent entity ID (optional)
  type: 'room',                          // Entity type string (required)
  asset: 'rooms/room1.png',              // Sprite asset path (required)
  gridPosition: Vector2(0, 0),           // Tile coordinates (required)
  blockSize: FiftyBlockSize(4, 3),       // Size in tiles (required)
  zIndex: 0,                             // Render priority (default: 0)
  quarterTurns: 0,                       // Rotation 0-3 (default: 0)
  text: 'Room A',                        // Optional text overlay
  event: FiftyWorldEvent(...),             // Optional event marker
  components: [...],                     // Child entities (default: [])
  metadata: {...},                       // Custom data (optional)
);

/// Computed properties
entity.position;   // Pixel position (Vector2)
entity.size;       // Pixel size (Vector2)

/// Serialization
final json = entity.toJson();
final restored = FiftyWorldEntity.fromJson(json);
```

### FiftyWorldEvent

Event marker attached to entities.

```dart
final event = FiftyWorldEvent(
  text: 'Quest',                         // Display text
  type: FiftyEventType.npc,              // Event type
  alignment: FiftyEventAlignment.topLeft, // Position relative to parent
  clicked: false,                        // Acknowledged state
);

/// Serialization
final json = event.toJson();
final restored = FiftyWorldEvent.fromJson(json);
```

### FiftyBlockSize

Tile-based size wrapper for map entities.

```dart
final size = FiftyBlockSize(4, 3);  // 4 tiles wide, 3 tiles tall

/// Properties
size.width;   // Horizontal tiles
size.height;  // Vertical tiles

/// Serialization
final json = size.toJson();
final restored = FiftyBlockSize.fromJson(json);
```

### Entity Types

| Type | Class | Description |
|------|-------|-------------|
| `room` | FiftyRoomComponent | Container with children |
| `character` | FiftyMovableComponent | Movable player/NPC |
| `monster` | FiftyMovableComponent | Movable enemy |
| `furniture` | FiftyStaticComponent | Static prop |
| `door` | FiftyStaticComponent | Static door |
| `event` | FiftyEventComponent | Event marker |

### Event Types

| Type | Description |
|------|-------------|
| `FiftyEventType.basic` | Generic event |
| `FiftyEventType.npc` | NPC interaction |
| `FiftyEventType.masterOfShadow` | Boss/story event |

### Event Alignments

```
FiftyEventAlignment.topLeft      FiftyEventAlignment.topCenter      FiftyEventAlignment.topRight
FiftyEventAlignment.centerLeft   FiftyEventAlignment.center         FiftyEventAlignment.centerRight
FiftyEventAlignment.bottomLeft   FiftyEventAlignment.bottomCenter   FiftyEventAlignment.bottomRight
```

### Component Classes

#### FiftyBaseComponent

Abstract base for all entity components.

```dart
abstract class FiftyBaseComponent extends SpriteComponent
    with HasGameReference<FiftyWorldBuilder>, TapCallbacks {

  FiftyWorldEntity model;              // Entity data model
  FiftyEventComponent? eventComponent;  // Optional event overlay
  FiftyTextComponent? textComponent;    // Optional text overlay

  void spawnChild(FiftyWorldEntity child);  // Hook for nested entities
}
```

**Features:**
- Loads sprite from model.asset
- Calculates pixel position with Y-axis flip
- Applies rotation via quarterTurns
- Attaches RectangleHitbox for collisions
- Spawns event/text overlays if present
- Forwards taps to game handler

#### FiftyStaticComponent

Component for static, non-moving entities (furniture, doors).

```dart
final component = FiftyStaticComponent(model: entity);
```

Inherits all base behaviors with no additional logic.

#### FiftyMovableComponent

Component for movable entities (characters, monsters).

```dart
final component = FiftyMovableComponent(model: entity);

/// Movement
component.moveTo(newPosition, newModel, speed: 200);
component.moveUp(steps, speed: 200);
component.moveDown(steps, speed: 200);
component.moveLeft(steps, speed: 200);
component.moveRight(steps, speed: 200);

/// Effects
component.attack(onComplete: () => {...});  // Bounce animation
component.die(onComplete: () => {...});     // Fade out and remove

/// Sprite Swap
await component.swapSprite('characters/hero_battle.png');
```

**Movement Notes:**
- All movements animate smoothly using MoveToEffect
- Speed is in pixels per second (default: 200)
- Event overlays automatically follow parent movement

#### FiftyRoomComponent

Container component that spawns child entities.

```dart
final room = FiftyRoomComponent(model: roomEntity);
// Child entities in model.components are auto-spawned
```

#### FiftyEventComponent

Event marker overlay component.

```dart
final event = FiftyEventComponent(model: entity);
event.moveWithParent(newModel);  // Follow parent movement
```

#### FiftyTextComponent

Text overlay component for entity labels.

```dart
// Automatically spawned when entity.text is non-null
```

### Services

#### FiftyAssetLoader

Asset registration and loading.

```dart
/// Register assets (call before game starts)
FiftyAssetLoader.registerAssets([
  'rooms/room1.png',
  'characters/hero.png',
  'events/npc.png',
]);

/// Check registered assets
FiftyAssetLoader.registeredAssets;

/// Reset registry (for testing/hot reload)
FiftyAssetLoader.reset();
```

**Notes:**
- Safe to call registerAssets multiple times
- Duplicates are automatically ignored
- Throws exception if loadAll() called with empty registry

#### FiftyWorldLoader

Map JSON loading and serialization.

```dart
/// Load from asset bundle
final entities = await FiftyWorldLoader.loadFromAssets('assets/maps/level1.json');

/// Load from JSON string
final entities = FiftyWorldLoader.loadFromJsonString(jsonString);

/// Serialize to JSON
final json = FiftyWorldLoader.toJsonString(entities);
```

#### FiftyEntitySpawner

Factory for spawning map entity components.

```dart
/// Spawn a component
final component = FiftyEntitySpawner.spawn(entityModel);
game.world.add(component);

/// Register custom entity type
FiftyEntitySpawner.register(
  'trap',
  (model) => TrapComponent(model: model),
);
```

### Extensions

#### FiftyWorldEntityExtension

```dart
/// Clone with overrides
final copy = entity.copyWith(id: 'new-id', zIndex: 5);

/// Change position
final moved = entity.changePosition(gridPosition: Vector2(5, 3));

/// Offset by parent position
final absolute = entity.copyWithParent(parentPosition);

/// Type checks
entity.entityType;     // FiftyEntityType enum
entity.isRoom;         // true if room
entity.isMonster;      // true if monster
entity.isCharacter;    // true if character
entity.isFurniture;    // true if furniture
entity.isEvent;        // true if event
entity.isMovable;      // true if character or monster
```

---

## Configuration

### FiftyWorldConfig

Grid configuration controlling tile size for the world map.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `blockSize` | `double` | `64.0` | Size of each grid tile in pixels |

```dart
FiftyWorldConfig.blockSize  // 64.0
```

### FiftyRenderPriority

Default render priorities controlling draw order (higher values render on top).

| Priority | Value | Description |
|----------|-------|-------------|
| `background` | `0` | Background layer |
| `furniture` | `10` | Static furniture props |
| `door` | `20` | Door elements |
| `monster` | `30` | Enemy entities |
| `character` | `40` | Player and NPC entities |
| `event` | `50` | Event marker overlays |
| `uiOverlay` | `100` | Top-level UI elements |

```dart
FiftyRenderPriority.background   // 0
FiftyRenderPriority.furniture    // 10
FiftyRenderPriority.door         // 20
FiftyRenderPriority.monster      // 30
FiftyRenderPriority.character    // 40
FiftyRenderPriority.event        // 50
FiftyRenderPriority.uiOverlay    // 100
```

Override the default render order for any entity using the `zIndex` parameter on `FiftyWorldEntity`.

### Map JSON Format

```json
[
  {
    "id": "room1",
    "type": "room",
    "asset": "rooms/room1.png",
    "grid_position": {"x": 0, "y": 0},
    "size": {"width": 4, "height": 3},
    "z_index": 0,
    "quarter_turns": 0,
    "text": "Room A",
    "components": [
      {
        "id": "hero",
        "parent_id": "room1",
        "type": "character",
        "asset": "characters/hero.png",
        "grid_position": {"x": 1, "y": 1},
        "size": {"width": 1, "height": 1},
        "event": {
          "event_text": "Quest",
          "event_type": "npc",
          "alignment": "topLeft",
          "clicked": false
        }
      }
    ],
    "metadata": {
      "custom_key": "custom_value"
    }
  }
]
```

---

## Usage Patterns

### Loading Maps Dynamically

```dart
// Load from JSON file
final entities = await FiftyWorldLoader.loadFromAssets('assets/maps/dungeon.json');

// Clear existing and load new
controller.clear();
controller.addEntities(entities);
controller.centerMap();
```

### Character Movement with Collision Checks

```dart
void moveCharacter(FiftyWorldEntity character, double x, double y) {
  // Get destination cell
  final targetPos = Vector2(x, y);

  // Check for obstacles (custom logic)
  final blocked = checkCollision(targetPos);

  if (!blocked) {
    controller.move(character, x, y);
  }
}
```

### Event Marker Interaction

```dart
FiftyWorldWidget(
  controller: controller,
  initialEntities: entities,
  onEntityTap: (entity) {
    if (entity.event != null && !entity.event!.clicked) {
      // Mark event as acknowledged
      entity.event!.clicked = true;

      // Show quest dialog
      showQuestDialog(entity.event!.text);
    }
  },
);
```

### Camera Animation Sequences

```dart
// Pan through locations
await controller.centerOnEntity(entrance, duration: Duration(seconds: 1));
await Future.delayed(Duration(milliseconds: 500));
await controller.centerOnEntity(treasure, duration: Duration(seconds: 2));
await Future.delayed(Duration(milliseconds: 500));
await controller.centerOnEntity(exit, duration: Duration(seconds: 1));
```

### Custom Entity Types

Register custom entity types with the spawner:

```dart
class TrapComponent extends FiftyBaseComponent {
  TrapComponent({required super.model});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Custom trap logic
  }

  void trigger() {
    // Trap activation logic
  }
}

// Register before game starts
FiftyEntitySpawner.register(
  'trap',
  (model) => TrapComponent(model: model),
);

// Use in entity definitions
final trap = FiftyWorldEntity(
  id: 'trap1',
  type: 'trap',  // Uses registered spawner
  asset: 'traps/spike.png',
  gridPosition: Vector2(3, 2),
  blockSize: FiftyBlockSize(1, 1),
);
```

### Best Practices

1. **Register assets first** - Call `FiftyAssetLoader.registerAssets()` before game starts
2. **Use controller methods** - Prefer controller over direct game access
3. **Check isBound** - Verify controller is bound before operations
4. **Clean up properly** - Call `controller.unbind()` when disposing
5. **Use grid coordinates** - Movement methods use tile units, not pixels
6. **Leverage custom types** - Register custom spawners for game-specific entities

See the [example directory](example/) for a complete tactical skirmish sandbox showcasing tile grid rendering, camera controls, entity spawning with team decorators, A* pathfinding, animation queues, and tap interaction.

---

## Platform Support

| Platform | Support | Notes |
|----------|---------|-------|
| Android | Yes | Full feature support |
| iOS | Yes | Full feature support |
| macOS | Yes | Full feature support |
| Linux | Yes | Full feature support |
| Windows | Yes | Full feature support |
| Web | Yes | Full feature support |

---

## Fifty Design Language Integration

This package is part of Fifty Flutter Kit:

- **Consistent naming** - All classes use `Fifty` prefix
- **Compatible packages** - Works with `fifty_ui`, `fifty_theme`, `fifty_tokens`
- **Kit patterns** - Follows Fifty Flutter Kit coding standards

---

## Version

**Current:** 0.1.2

---

## License

MIT License - see [LICENSE](LICENSE) for details.

Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).
