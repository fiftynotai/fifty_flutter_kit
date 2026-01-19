# Implementation Plan: BR-027 - Fifty Skill Tree Package

**Generated:** 2026-01-18
**Complexity:** L (Large)
**Estimated Duration:** 2-3 weeks (15 working days)
**Risk Level:** Medium

---

## Executive Summary

Build `fifty_skill_tree` - a production-ready Flutter package for interactive skill trees with game integration support. The package provides:
- Standalone rendering engine (no graphview dependency)
- ChangeNotifier-based controller (framework-agnostic)
- Generic data support (`SkillTree<T>`)
- Multiple layout algorithms
- Comprehensive theming and animations

---

## File Manifest

**Total Files:** 60
**Complex:** 14 | **Moderate:** 28 | **Trivial:** 18

### Core Package Files

| # | File Path | Complexity | Description |
|---|-----------|------------|-------------|
| 1 | `packages/fifty_skill_tree/pubspec.yaml` | Trivial | Package definition |
| 2 | `packages/fifty_skill_tree/lib/fifty_skill_tree.dart` | Trivial | Main barrel export |
| 3 | `packages/fifty_skill_tree/LICENSE` | Trivial | MIT License |
| 4 | `packages/fifty_skill_tree/README.md` | Moderate | Documentation |
| 5 | `packages/fifty_skill_tree/CHANGELOG.md` | Trivial | Version history |
| 6 | `packages/fifty_skill_tree/analysis_options.yaml` | Trivial | Lint rules |

### Models (Phase 1)

| # | File Path | Complexity | Description |
|---|-----------|------------|-------------|
| 7 | `lib/src/models/skill_state.dart` | Trivial | SkillState enum |
| 8 | `lib/src/models/skill_type.dart` | Trivial | SkillType enum |
| 9 | `lib/src/models/connection_type.dart` | Trivial | ConnectionType enum |
| 10 | `lib/src/models/connection_style.dart` | Trivial | ConnectionStyle enum |
| 11 | `lib/src/models/skill_node.dart` | Complex | SkillNode<T> model |
| 12 | `lib/src/models/skill_connection.dart` | Moderate | SkillConnection model |
| 13 | `lib/src/models/skill_tree.dart` | Complex | SkillTree<T> model |
| 14 | `lib/src/models/unlock_result.dart` | Moderate | UnlockResult model |
| 15 | `lib/src/models/models.dart` | Trivial | Models barrel export |

### Widgets (Phase 2-3)

| # | File Path | Complexity | Description |
|---|-----------|------------|-------------|
| 16 | `lib/src/widgets/skill_tree_view.dart` | Complex | Main widget |
| 17 | `lib/src/widgets/skill_tree_controller.dart` | Complex | Controller |
| 18 | `lib/src/widgets/skill_node_widget.dart` | Moderate | Node renderer |
| 19 | `lib/src/widgets/skill_tooltip.dart` | Moderate | Tooltip overlay |
| 20 | `lib/src/widgets/widgets.dart` | Trivial | Widgets barrel |

### Painters (Phase 2)

| # | File Path | Complexity | Description |
|---|-----------|------------|-------------|
| 21 | `lib/src/painters/connection_painter.dart` | Complex | Base painter |
| 22 | `lib/src/painters/line_painter.dart` | Moderate | Straight lines |
| 23 | `lib/src/painters/bezier_painter.dart` | Moderate | Curved lines |
| 24 | `lib/src/painters/dashed_painter.dart` | Moderate | Dashed lines |
| 25 | `lib/src/painters/energy_flow_painter.dart` | Complex | Animated flow |
| 26 | `lib/src/painters/painters.dart` | Trivial | Painters barrel |

### Layouts (Phase 2, 4)

| # | File Path | Complexity | Description |
|---|-----------|------------|-------------|
| 27 | `lib/src/layouts/tree_layout.dart` | Moderate | Abstract interface |
| 28 | `lib/src/layouts/vertical_tree_layout.dart` | Complex | Top-down layout |
| 29 | `lib/src/layouts/horizontal_tree_layout.dart` | Complex | Left-right layout |
| 30 | `lib/src/layouts/radial_tree_layout.dart` | Complex | Circular layout |
| 31 | `lib/src/layouts/grid_layout.dart` | Moderate | Grid positioning |
| 32 | `lib/src/layouts/custom_layout.dart` | Moderate | Manual positions |
| 33 | `lib/src/layouts/layouts.dart` | Trivial | Layouts barrel |

### Animations (Phase 5)

| # | File Path | Complexity | Description |
|---|-----------|------------|-------------|
| 34 | `lib/src/animations/unlock_animation.dart` | Complex | Unlock burst |
| 35 | `lib/src/animations/pulse_animation.dart` | Moderate | Available pulse |
| 36 | `lib/src/animations/glow_animation.dart` | Moderate | Selection glow |
| 37 | `lib/src/animations/shake_animation.dart` | Moderate | Failed shake |
| 38 | `lib/src/animations/path_highlight_animation.dart` | Moderate | Path trace |
| 39 | `lib/src/animations/animations.dart` | Trivial | Animations barrel |

### Themes (Phase 6)

| # | File Path | Complexity | Description |
|---|-----------|------------|-------------|
| 40 | `lib/src/themes/skill_tree_theme.dart` | Complex | Theme data |
| 41 | `lib/src/themes/theme_presets.dart` | Moderate | Theme presets |
| 42 | `lib/src/themes/themes.dart` | Trivial | Themes barrel |

### Serialization (Phase 7)

| # | File Path | Complexity | Description |
|---|-----------|------------|-------------|
| 43 | `lib/src/serialization/tree_serializer.dart` | Complex | Full serialization |
| 44 | `lib/src/serialization/progress_data.dart` | Moderate | Progress save/load |
| 45 | `lib/src/serialization/serialization.dart` | Trivial | Serialization barrel |

### Example App (Phase 8)

| # | File Path | Complexity | Description |
|---|-----------|------------|-------------|
| 46 | `example/pubspec.yaml` | Trivial | Example deps |
| 47 | `example/lib/main.dart` | Moderate | App entry |
| 48 | `example/lib/examples/basic_tree.dart` | Moderate | Simple example |
| 49 | `example/lib/examples/rpg_skill_tree.dart` | Complex | RPG multi-branch |
| 50 | `example/lib/examples/tech_tree.dart` | Moderate | Strategy tech |
| 51 | `example/lib/examples/talent_tree.dart` | Moderate | MOBA talents |
| 52 | `example/lib/data/sample_trees.dart` | Moderate | Tree data |

### Tests

| # | File Path | Complexity | Description |
|---|-----------|------------|-------------|
| 53 | `test/models/skill_node_test.dart` | Moderate | Node tests |
| 54 | `test/models/skill_tree_test.dart` | Complex | Tree tests |
| 55 | `test/models/skill_connection_test.dart` | Moderate | Connection tests |
| 56 | `test/widgets/skill_tree_view_test.dart` | Complex | View tests |
| 57 | `test/widgets/skill_tree_controller_test.dart` | Moderate | Controller tests |
| 58 | `test/layouts/vertical_layout_test.dart` | Moderate | Layout tests |
| 59 | `test/layouts/radial_layout_test.dart` | Moderate | Radial tests |
| 60 | `test/serialization/serializer_test.dart` | Moderate | JSON tests |

---

## Dependency Graph (Build Order)

```
PHASE 1: FOUNDATION
───────────────────
[1] pubspec.yaml, analysis_options.yaml
    │
    ▼
[2] Enums (no dependencies)
    ├── skill_state.dart
    ├── skill_type.dart
    ├── connection_type.dart
    └── connection_style.dart
    │
    ▼
[3] Models (depend on enums)
    ├── skill_node.dart ← (skill_state, skill_type)
    ├── skill_connection.dart ← (connection_type, connection_style)
    ├── unlock_result.dart
    └── skill_tree.dart ← (skill_node, skill_connection, unlock_result)
    │
    ▼
[4] models.dart (barrel)

PHASE 2: RENDERING ENGINE
─────────────────────────
[5] tree_layout.dart (interface)
    │
    ▼
[6] vertical_tree_layout.dart
    │
    ▼
[7] Painters
    ├── connection_painter.dart (base)
    ├── line_painter.dart
    └── bezier_painter.dart
    │
    ▼
[8] Theme System
    └── skill_tree_theme.dart
    │
    ▼
[9] Controller
    └── skill_tree_controller.dart
    │
    ▼
[10] Widgets
    ├── skill_node_widget.dart
    └── skill_tree_view.dart

PHASE 3: INTERACTIONS
────────────────────
[11] skill_tooltip.dart
[12] Update skill_tree_view.dart (interactions)
[13] Update skill_tree_controller.dart (unlock logic)

PHASE 4: ADVANCED LAYOUTS
─────────────────────────
[14] horizontal_tree_layout.dart
[15] radial_tree_layout.dart
[16] grid_layout.dart
[17] custom_layout.dart

PHASE 5: ANIMATIONS
──────────────────
[18] unlock_animation.dart
[19] pulse_animation.dart
[20] glow_animation.dart
[21] shake_animation.dart
[22] path_highlight_animation.dart

PHASE 6: THEMING POLISH
──────────────────────
[23] theme_presets.dart
[24] dashed_painter.dart
[25] energy_flow_painter.dart

PHASE 7: SERIALIZATION
─────────────────────
[26] progress_data.dart
[27] tree_serializer.dart

PHASE 8: POLISH & DOCS
─────────────────────
[28] Main barrel export
[29] README.md
[30] Example app
[31] All tests
```

---

## Phase-by-Phase Implementation Details

### Phase 1: Core Models (2 days)

**Deliverables:**
- Package scaffolding (pubspec.yaml, analysis_options.yaml)
- All enums: SkillState, SkillType, ConnectionType, ConnectionStyle
- SkillNode<T> with generic data support, immutable with copyWith
- SkillConnection model
- UnlockResult with success/failure variants
- SkillTree<T> with unlock operations and prerequisite checking
- Unit tests for all models

**Key Implementation Notes:**
- SkillNode uses computed state based on tree context
- SkillTree is the aggregate root managing mutations
- Costs stored as `List<int>` for multi-level skills

### Phase 2: Basic Rendering (3 days)

**Deliverables:**
- TreeLayout abstract interface
- VerticalTreeLayout with tier-based positioning
- ConnectionPainter base class
- LinePainter and BezierPainter
- SkillTreeTheme (minimal colors/sizes)
- SkillTreeController with ChangeNotifier
- SkillNodeWidget for node rendering
- SkillTreeView with InteractiveViewer for pan/zoom

**Key Implementation Notes:**
- Use InteractiveViewer for built-in pan/zoom
- CustomPaint for connections under Stack of node widgets
- Cache layout positions, recalculate on tree change

### Phase 3: Interactions (2 days)

**Deliverables:**
- Tap-to-unlock flow with onUnlockAttempt callback
- SkillTooltip widget
- Overlay-based tooltip positioning
- Controller unlock logic with result handling

### Phase 4: Advanced Layouts (2 days)

**Deliverables:**
- HorizontalTreeLayout
- RadialTreeLayout (circular/constellation)
- GridLayout (fixed positions)
- CustomLayout (manual positions)

### Phase 5: Animations (2 days)

**Deliverables:**
- UnlockAnimation (burst + glow)
- PulseAnimation (available nodes)
- GlowAnimation (selection)
- ShakeAnimation (failed unlock)
- PathHighlightAnimation (path trace)

### Phase 6: Theming (1 day)

**Deliverables:**
- Complete SkillTreeTheme with all properties
- Theme presets: dark, light, rpg, scifi, minimal
- Additional painters: DashedPainter, EnergyFlowPainter

### Phase 7: Serialization (1 day)

**Deliverables:**
- ProgressData for lightweight save/load
- TreeSerializer for full tree JSON
- Generic data serializer support

### Phase 8: Polish (2 days)

**Deliverables:**
- Performance optimization (RepaintBoundary, caching)
- Accessibility (Semantics widgets)
- README documentation
- CHANGELOG
- Example app with 4 demos
- All tests passing with 80%+ coverage

---

## Critical Design Decisions

### 1. Framework-Agnostic Controller

**Choice:** ChangeNotifier instead of GetX/Riverpod/Bloc

**Rationale:** Package should work with any state management. Users wrap controller in their preferred solution.

### 2. No GraphView Dependency

**Choice:** Custom rendering with CustomPainter + Stack

**Rationale:** Full control, game-specific optimizations, avoid dependency conflicts.

### 3. Generic Node Data

**Choice:** `SkillTree<T>` with generic data attachment

**Rationale:** Games attach custom data (damage, cooldowns) with type-safe access.

### 4. Computed State vs Stored State

**Choice:** Compute SkillState from context, store only currentLevel

**Rationale:** Single source of truth, avoids synchronization bugs.

### 5. Immutable Nodes, Mutable Tree

**Choice:** SkillNode immutable, SkillTree manages mutable map

**Rationale:** Nodes are value objects, Tree is aggregate root.

---

## Testing Strategy

| Component | Coverage Target | Key Tests |
|-----------|-----------------|-----------|
| SkillNode | 95% | Creation, copyWith, JSON, computed |
| SkillTree | 90% | Unlock, prerequisites, points, reset |
| Layouts | 85% | Position calculations, edge cases |
| SkillTreeView | 70% | Renders, taps, pan/zoom |
| Serialization | 90% | JSON round-trip |

---

## Risks and Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Layout complexity | High | Start simple, reference academic papers |
| Performance (100+ nodes) | Medium | RepaintBoundary, cache, profile early |
| Animation jank | Medium | Test on low-end devices, respect reduced-motion |
| Gesture conflicts | Low | Test InteractiveViewer + node taps thoroughly |

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
  mocktail: ^1.0.0
```

---

**Ready for implementation. Awaiting Monarch's approval.**
