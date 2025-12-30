# Fifty Map Engine

Flame-based interactive grid map rendering for Flutter games. Part of the Fifty ecosystem.

[![Pub Version](https://img.shields.io/pub/v/fifty_map_engine)](https://pub.dev/packages/fifty_map_engine)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## Features

- Tile-based grid map rendering with Flame game engine
- Smooth pan and pinch-to-zoom camera controls
- Entity lifecycle management (spawn, update, remove)
- Support for multiple entity types (rooms, characters, monsters, furniture, events)
- Movement animations for movable entities
- Event markers with customizable alignment
- Asset loading and caching
- JSON-based map serialization/deserialization
- Multi-platform support (Android, iOS, macOS, Linux, Windows, Web)

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_map_engine: ^0.1.0
```

## Quick Start

```dart
import 'package:fifty_map_engine/fifty_map_engine.dart';

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
  FiftyMapEntity(
    id: 'room1',
    type: 'room',
    asset: 'rooms/room1.png',
    gridPosition: Vector2(0, 0),
    blockSize: FiftyBlockSize(4, 3),
    components: [
      FiftyMapEntity(
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
final controller = FiftyMapController();

FiftyMapWidget(
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

## API Reference

### Core Classes

#### FiftyMapController

UI-friendly facade for map manipulation.

```dart
final controller = FiftyMapController();

// Binding
controller.bind(game);       // Bind to a FiftyMapBuilder
controller.unbind();         // Unbind and cleanup
controller.isBound;          // Check if bound

// Entity Management
controller.addEntities(entities);     // Add or update entities
controller.removeEntity(entity);      // Remove an entity
controller.clear();                   // Remove all entities

// Movement (grid coordinates)
controller.move(entity, x, y);        // Move to position
controller.moveUp(entity, steps);     // Move up
controller.moveDown(entity, steps);   // Move down
controller.moveLeft(entity, steps);   // Move left
controller.moveRight(entity, steps);  // Move right

// Lookups
controller.currentEntities;           // Initial entities
controller.getComponentById(id);      // Get component by ID
controller.getEntityById(id);         // Get entity model by ID

// Camera
controller.centerMap();               // Center on all entities
controller.centerOnEntity(entity);    // Center on specific entity
controller.zoomIn();                  // Zoom in
controller.zoomOut();                 // Zoom out
```

#### FiftyMapEntity

Data model for map entities.

```dart
final entity = FiftyMapEntity(
  id: 'room1',                           // Unique identifier
  parentId: null,                        // Parent entity ID (optional)
  type: 'room',                          // Entity type string
  asset: 'rooms/room1.png',              // Sprite asset path
  gridPosition: Vector2(0, 0),           // Tile coordinates
  blockSize: FiftyBlockSize(4, 3),       // Size in tiles
  zIndex: 0,                             // Render priority
  quarterTurns: 0,                       // Rotation (0-3)
  text: 'Room A',                        // Optional text overlay
  event: FiftyMapEvent(...),             // Optional event marker
  components: [...],                     // Child entities
  metadata: {...},                       // Custom data
);

// Computed properties
entity.position;   // Pixel position (Vector2)
entity.size;       // Pixel size (Vector2)

// Serialization
final json = entity.toJson();
final restored = FiftyMapEntity.fromJson(json);
```

#### FiftyMapEvent

Event marker attached to entities.

```dart
final event = FiftyMapEvent(
  text: 'Quest',                         // Display text
  type: FiftyEventType.npc,              // Event type
  alignment: FiftyEventAlignment.topLeft, // Position relative to parent
  clicked: false,                        // Acknowledged state
);
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

### Services

#### FiftyAssetLoader

Asset registration and loading.

```dart
// Register assets (call before game starts)
FiftyAssetLoader.registerAssets([
  'rooms/room1.png',
  'characters/hero.png',
]);

// Check registered assets
FiftyAssetLoader.registeredAssets;

// Reset registry (for testing/hot reload)
FiftyAssetLoader.reset();
```

#### FiftyMapLoader

Map JSON loading and serialization.

```dart
// Load from asset bundle
final entities = await FiftyMapLoader.loadFromAssets('assets/maps/level1.json');

// Load from JSON string
final entities = FiftyMapLoader.loadFromJsonString(jsonString);

// Serialize to JSON
final json = FiftyMapLoader.toJsonString(entities);
```

### Extensions

#### FiftyMapEntityExtension

```dart
// Clone with overrides
final copy = entity.copyWith(id: 'new-id', zIndex: 5);

// Change position
final moved = entity.changePosition(gridPosition: Vector2(5, 3));

// Offset by parent position
final absolute = entity.copyWithParent(parentPosition);

// Type checks
entity.entityType;     // FiftyEntityType enum
entity.isRoom;         // true if room
entity.isMonster;      // true if monster
entity.isCharacter;    // true if character
entity.isFurniture;    // true if furniture
entity.isEvent;        // true if event
entity.isMovable;      // true if character or monster
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
}

// Register before game starts
FiftyEntitySpawner.register(
  'trap',
  (model) => TrapComponent(model: model),
);
```

## Map JSON Format

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

## Configuration

### Grid Configuration

The default block size is 64 pixels. Access via:

```dart
FiftyMapConfig.blockSize  // 64.0
```

### Render Priorities

Default render priorities (higher = on top):

```dart
FiftyRenderPriority.background   // 0
FiftyRenderPriority.furniture    // 10
FiftyRenderPriority.door         // 20
FiftyRenderPriority.monster      // 30
FiftyRenderPriority.character    // 40
FiftyRenderPriority.event        // 50
FiftyRenderPriority.uiOverlay    // 100
```

Override with `zIndex` in FiftyMapEntity.

## Coordinate System

- Grid coordinates: Tile-based (0, 0) is bottom-left
- Pixel coordinates: `gridPosition * FiftyMapConfig.blockSize`
- Flame coordinate system: Y-axis flipped internally for rendering

## Platform Support

| Platform | Support |
|----------|---------|
| Android | Yes |
| iOS | Yes |
| macOS | Yes |
| Linux | Yes |
| Windows | Yes |
| Web | Yes |

## Dependencies

- [flame](https://pub.dev/packages/flame) ^1.30.1 - Game engine
- [logging](https://pub.dev/packages/logging) ^1.3.0 - Logging

## License

MIT License - see [LICENSE](LICENSE) for details.

## Contributing

This package is part of the [Fifty ecosystem](https://github.com/fiftynotai/fifty_eco_system).
