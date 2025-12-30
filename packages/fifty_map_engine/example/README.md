# fifty_map_engine Example

Demonstrates the **fifty_map_engine** package with Fifty Design Language (FDL) styling.

---

## Overview

This example app showcases the full capabilities of the fifty_map_engine package:

| Feature | Description |
|---------|-------------|
| **Interactive Map** | Pan and zoom with touch gestures |
| **Entity Management** | Add, remove, and focus on entities |
| **Movement Controls** | D-pad for character movement |
| **Camera Controls** | Zoom in/out and center view |
| **Map Operations** | Refresh, download, and clear |

---

## Getting Started

```bash
cd packages/fifty_map_engine/example
flutter pub get
flutter run
```

The app runs in landscape mode for optimal map viewing.

---

## Architecture

This example follows the **MVVM + Actions** architecture pattern used throughout the Fifty ecosystem:

```
lib/
├── main.dart                 # Entry point, asset registration
├── app/
│   └── map_demo_app.dart     # App shell with providers
├── core/
│   └── di/
│       └── service_locator.dart  # GetIt dependency injection
└── features/
    └── map_demo/
        ├── actions/
        │   └── map_actions.dart      # UI event handlers (user intents)
        ├── viewmodel/
        │   └── map_viewmodel.dart    # State exposure for view
        ├── service/
        │   └── map_service.dart      # Business logic and state
        └── view/
            ├── map_demo_page.dart    # Main page layout
            └── widgets/
                ├── control_panel.dart # Control buttons
                └── status_bar.dart    # Status display
```

### Layer Responsibilities

| Layer | File | Purpose |
|-------|------|---------|
| **View** | `map_demo_page.dart` | UI layout, widget composition |
| **Widgets** | `control_panel.dart`, `status_bar.dart` | Reusable UI components |
| **Actions** | `map_actions.dart` | Translates UI events to service calls |
| **ViewModel** | `map_viewmodel.dart` | Exposes state streams to view |
| **Service** | `map_service.dart` | Business logic, state management |
| **DI** | `service_locator.dart` | Wires dependencies via GetIt |

### Data Flow

```
User Tap -> View -> Actions -> Service -> State Change
                                  |
                                  v
            View <- ViewModel <- ChangeNotifier
```

---

## Controls

The control panel is organized into four groups:

### Camera Controls

| Button | Action | Description |
|--------|--------|-------------|
| Zoom In | `controller.zoomIn()` | Magnify the map view by 1.2x |
| Zoom Out | `controller.zoomOut()` | Shrink the map view by 1.2x |
| Center | `controller.centerMap()` | Center camera on all entities |

### Entity Controls

| Button | Action | Description |
|--------|--------|-------------|
| Add | `service.addTestEntity()` | Spawn test entity at grid (1,1) |
| Remove | `service.removeTestEntity()` | Remove the test entity |
| Focus | `controller.centerOnEntity()` | Center camera on test entity |

### Map Controls

| Button | Action | Description |
|--------|--------|-------------|
| Refresh | `controller.addEntities()` | Load updated room layout |
| Download | `service.loadInitialMap()` | Reload original map data |
| Clear | `controller.clear()` | Remove all entities from map |

### D-Pad Movement

| Direction | Action | Description |
|-----------|--------|-------------|
| Up | `controller.moveUp(entity, 1)` | Move test entity up 1 tile |
| Down | `controller.moveDown(entity, 1)` | Move test entity down 1 tile |
| Left | `controller.moveLeft(entity, 1)` | Move test entity left 1 tile |
| Right | `controller.moveRight(entity, 1)` | Move test entity right 1 tile |

---

## FDL Styling

The example uses Fifty Design Language tokens for a consistent dark theme:

### Colors

| Token | Value | Usage |
|-------|-------|-------|
| Void Black | `#050505` | App background |
| Gunmetal | `#1A1A1A` | Card backgrounds |
| Terminal White | `#EAEAEA` | Primary text |
| Crimson Pulse | `#960E29` | Accent color, glow effects |
| Hyper Chrome | `#888888` | Borders at 10% opacity |

### Components Used

| Component | Usage |
|-----------|-------|
| `FiftyCard` | Control panel container |
| `FiftyIconButton` | All control buttons |
| `FiftyTheme` | App-wide dark theme |

### Visual Effects

- Crimson glow accent on status bar
- Subtle border on cards (0.1 opacity)
- Consistent spacing with FDL tokens

---

## Code Examples

### Asset Registration (main.dart)

```dart
void main() {
  FiftyAssetLoader.registerAssets([
    'rooms/room1.png',
    'rooms/room2.png',
    'characters/hero.png',
    'monsters/goblin.png',
    'events/npc.png',
    'events/basic.png',
  ]);

  setupServiceLocator();
  runApp(const MapDemoApp());
}
```

### Service Locator (service_locator.dart)

```dart
final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<FiftyMapController>(() => FiftyMapController());
  getIt.registerLazySingleton<MapService>(() => MapService(getIt()));
  getIt.registerLazySingleton<MapViewModel>(() => MapViewModel(getIt()));
  getIt.registerLazySingleton<MapActions>(() => MapActions(getIt(), getIt()));
}
```

### Actions Layer (map_actions.dart)

```dart
class MapActions {
  final MapService _service;
  final FiftyMapController _controller;

  MapActions(this._service, this._controller);

  void onZoomIn() => _controller.zoomIn();
  void onZoomOut() => _controller.zoomOut();
  void onCenterMap() => _controller.centerMap();

  void onAddEntity() => _service.addTestEntity();
  void onRemoveEntity() => _service.removeTestEntity();

  void onMoveUp() {
    final entity = _service.testEntity;
    if (entity != null) _controller.moveUp(entity, 1);
  }
}
```

### ViewModel Layer (map_viewmodel.dart)

```dart
class MapViewModel extends ChangeNotifier {
  final MapService _service;

  MapViewModel(this._service) {
    _service.addListener(notifyListeners);
  }

  bool get hasTestEntity => _service.testEntity != null;
  int get entityCount => _service.entityCount;
  String get state => _service.state;
}
```

### Service Layer (map_service.dart)

```dart
class MapService extends ChangeNotifier {
  final FiftyMapController _controller;

  FiftyMapEntity? _testEntity;
  String _state = 'Ready';

  MapService(this._controller);

  FiftyMapEntity? get testEntity => _testEntity;
  String get state => _state;

  void addTestEntity() {
    _testEntity = FiftyMapEntity(
      id: 'test-entity',
      type: 'character',
      asset: 'characters/hero.png',
      gridPosition: Vector2(1, 1),
      blockSize: FiftyBlockSize(1, 1),
    );
    _controller.addEntities([_testEntity!]);
    _state = 'Entity added';
    notifyListeners();
  }
}
```

---

## Dependencies

| Package | Purpose |
|---------|---------|
| `fifty_map_engine` | Map rendering engine |
| `fifty_ui` | FDL components (FiftyCard, FiftyIconButton) |
| `fifty_theme` | Dark theme configuration |
| `fifty_tokens` | Design tokens (colors, spacing) |
| `provider` | State management |
| `get_it` | Dependency injection |

---

## App Layout

The app displays in landscape mode with three main areas:

```
+--------------------------------------------------+
| Status Bar (top-left)                            |
|   State: Ready                                   |
|   Entities: 5                                    |
|                                                  |
|                                      +---------+ |
|                                      | Control | |
|        Interactive Map               |  Panel  | |
|        (Full Screen)                 | (Right) | |
|                                      |         | |
|                                      | Camera  | |
|                                      | Entity  | |
|                                      | Map     | |
|                                      | D-Pad   | |
|                                      +---------+ |
+--------------------------------------------------+
```

### Status Bar

- Current state indicator (Ready, Loading, Entity added, etc.)
- Entity count display
- Crimson glow accent styling

### Control Panel

- Grouped action buttons
- Camera controls (zoom, center)
- Entity controls (add, remove, focus)
- Map controls (refresh, download, clear)
- D-pad for movement

### Map Area

- Full-screen interactive map
- Pan with single finger
- Pinch to zoom
- Long-press to select entities

---

## Extending the Example

### Adding Custom Entity Types

```dart
// Register in main.dart before runApp
FiftyEntitySpawner.register(
  'treasure',
  (model) => TreasureComponent(model: model),
);

// Use in map data
final chest = FiftyMapEntity(
  id: 'chest1',
  type: 'treasure',
  asset: 'items/chest.png',
  gridPosition: Vector2(3, 2),
  blockSize: FiftyBlockSize(1, 1),
);
```

### Loading Maps from JSON

```dart
// In map_service.dart
Future<void> loadLevel(String levelName) async {
  _state = 'Loading...';
  notifyListeners();

  final entities = await FiftyMapLoader.loadFromAssets(
    'assets/maps/$levelName.json',
  );

  _controller.clear();
  _controller.addEntities(entities);

  _state = 'Level loaded';
  notifyListeners();
}
```

### Adding Event Interactions

```dart
// In map_demo_page.dart
FiftyMapWidget(
  controller: controller,
  initialEntities: entities,
  onEntityTap: (entity) {
    if (entity.event != null) {
      _showEventDialog(context, entity.event!);
    }
  },
);

void _showEventDialog(BuildContext context, FiftyMapEvent event) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(event.text),
      content: Text('Event type: ${event.type.name}'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
```

---

## License

MIT License - see main package for details.
