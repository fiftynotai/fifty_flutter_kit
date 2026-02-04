# BR-069: Map Demo Interaction Buttons

**Type:** Feature
**Priority:** P2 - Medium
**Status:** Done
**Effort:** M - Medium
**Module:** apps/fifty_demo
**Created:** 2026-02-04

---

## Problem

The map demo lacks interaction buttons for users to manipulate the map and entities. The engine example has a full control panel that the demo should replicate.

---

## Goal

Add a control panel overlay to the map demo matching the engine example's capabilities.

---

## Context & Inputs

### Engine Example Reference
File: `packages/fifty_map_engine/example/lib/features/map_demo/view/widgets/control_panel.dart`

### Available Controls (from engine example)

**CAMERA Section:**
| Control | Icon | Action |
|---------|------|--------|
| Zoom In | `Icons.zoom_in` | `controller.zoomIn()` |
| Zoom Out | `Icons.zoom_out` | `controller.zoomOut()` |
| Center Map | `Icons.my_location` | `controller.centerMap()` |

**ENTITY Section:**
| Control | Icon | Action |
|---------|------|--------|
| Add Entity | `Icons.add` | Add test entity to map |
| Remove Entity | `Icons.remove` | Remove last added entity |
| Focus Entity | `Icons.center_focus_strong_rounded` | Center camera on entity |

**MAP Section:**
| Control | Icon | Action |
|---------|------|--------|
| Refresh | `Icons.refresh` | Load updated room |
| Reload | `Icons.download` | Reload map from JSON |
| Clear All | `Icons.clear` | Remove all entities |

**MOVE Section (D-pad):**
| Control | Icon | Action |
|---------|------|--------|
| Move Up | `Icons.arrow_circle_up_outlined` | Move selected entity up |
| Move Down | `Icons.arrow_circle_down_outlined` | Move selected entity down |
| Move Left | `Icons.arrow_circle_left_outlined` | Move selected entity left |
| Move Right | `Icons.arrow_circle_right_outlined` | Move selected entity right |

### Engine Example Layout
```
┌─────────────────────────────────────────────────┐
│                                    ┌──────────┐ │
│                                    │ CAMERA   │ │
│                                    │ [+][-][◎]│ │
│                                    ├──────────┤ │
│            MAP                     │ ENTITY   │ │
│         (fullscreen)               │ [+][-][◉]│ │
│                                    ├──────────┤ │
│                                    │ MAP      │ │
│  ┌──────────┐                      │ [↻][⬇][✕]│ │
│  │ STATUS   │                      ├──────────┤ │
│  │ Ready    │                      │ MOVE     │ │
│  │ 24 ent.  │                      │    [↑]   │ │
│  └──────────┘                      │ [←][↓][→]│ │
│                                    └──────────┘ │
└─────────────────────────────────────────────────┘
```

### Key Widgets Used
- `FiftyCard` - Container with FDL styling
- `FiftyIconButton` - Icon buttons with variants
- `FiftyDivider` - Section separators
- Section labels with FDL typography

---

## Implementation Steps

1. **Copy ControlPanel widget** from engine example to fifty_demo
   - `lib/features/map_demo/views/widgets/control_panel.dart`

2. **Copy StatusBar widget** from engine example
   - `lib/features/map_demo/views/widgets/status_bar.dart`

3. **Update MapDemoActions** to expose all control methods:
   - Camera: zoomIn, zoomOut, centerMap
   - Entity: addEntity, removeEntity, focusEntity
   - Map: refresh, reload, clearAll
   - Move: moveUp, moveDown, moveLeft, moveRight

4. **Update MapIntegrationService** with missing methods:
   - `addTestEntity()`, `removeTestEntity()`
   - `moveUp()`, `moveDown()`, `moveLeft()`, `moveRight()`
   - `focusOnTestEntity()`

5. **Update MapDemoPage** to use Stack layout with overlays

---

## Acceptance Criteria

1. [x] Control panel displays on right side of map
2. [x] Status bar displays on top left
3. [x] All camera controls functional (zoom in/out, center)
4. [x] All entity controls functional (add/remove/focus)
5. [x] All map controls functional (refresh/reload/clear)
6. [x] D-pad movement controls functional
7. [x] FDL compliant styling (FiftyCard, FiftyIconButton)
8. [x] Entity tap shows entity info in status bar

---

## Test Plan

### Manual Testing
1. Open map demo
2. Test each camera control
3. Test adding/removing entities
4. Test movement controls on selected entity
5. Test reload and clear functions
6. Verify FDL styling matches engine example

---

## Reference Files

| File | Purpose |
|------|---------|
| `packages/fifty_map_engine/example/lib/features/map_demo/view/widgets/control_panel.dart` | Control panel reference |
| `packages/fifty_map_engine/example/lib/features/map_demo/view/widgets/status_bar.dart` | Status bar reference |
| `packages/fifty_map_engine/example/lib/features/map_demo/view/map_demo_page.dart` | Layout reference |
| `packages/fifty_map_engine/example/lib/features/map_demo/actions/map_actions.dart` | Actions reference |

---
