# BR-027: Fifty Skill Tree Package

**Type:** Feature
**Priority:** P2-Medium
**Effort:** L-Large (2-3 weeks)
**Status:** Done
**Created:** 2026-01-18
**Assignee:** -

---

## Problem

Game developers need a specialized Flutter widget for building and displaying skill trees - a common UI pattern in RPGs, MOBAs, and progression-based games. The existing `graph_builder` package provides basic DAG visualization but lacks game-specific features like:
- Skill states (locked, available, unlocked, maxed)
- Point/currency systems for unlocking
- Prerequisites and dependency visualization
- Unlock animations and visual feedback
- Save/load serialization
- Mobile-friendly touch interactions

---

## Goal

Rebuild `graph_builder` as `fifty_skill_tree` - a production-ready, highly customizable Flutter package for building interactive skill trees with full game integration support. The package should be:
- Easy to integrate with any game's progression system
- Visually stunning with animations and effects
- Performant with large skill trees (100+ nodes)
- Fully customizable to match any game's art style

---

## Context & Inputs

### Existing Package
- **Repository:** https://github.com/fiftynotai/graph_builder
- **Current Features:** Basic DAG rendering, pan/zoom, tap interactions
- **Dependency:** `graphview` package
- **Issues:** Not game-focused, limited customization, no state management

### Target Package
- **Name:** `fifty_skill_tree`
- **Location:** `packages/fifty_skill_tree/` (Fifty Flutter Kit)
- **Dependency:** Standalone (no `graphview` - custom rendering)

### Reference Games (Skill Tree Examples)
- Path of Exile (complex web)
- Diablo 4 (linear branches)
- League of Legends (champion mastery)
- Borderlands (class trees)
- Skyrim (constellation style)

---

## Package Architecture

### Core Components

```
fifty_skill_tree/
├── lib/
│   ├── fifty_skill_tree.dart           # Main export
│   └── src/
│       ├── models/
│       │   ├── skill_node.dart          # Skill data model
│       │   ├── skill_tree.dart          # Tree structure
│       │   ├── skill_connection.dart    # Edge/connection model
│       │   ├── skill_state.dart         # Node states enum
│       │   ├── skill_type.dart          # Node types enum
│       │   └── unlock_result.dart       # Unlock operation result
│       │
│       ├── widgets/
│       │   ├── skill_tree_view.dart     # Main widget
│       │   ├── skill_node_widget.dart   # Default node renderer
│       │   ├── skill_connection_painter.dart  # Edge painter
│       │   ├── skill_tooltip.dart       # Node tooltip
│       │   └── skill_tree_controller.dart     # State controller
│       │
│       ├── layouts/
│       │   ├── tree_layout.dart         # Layout interface
│       │   ├── vertical_tree_layout.dart    # Top-down layout
│       │   ├── horizontal_tree_layout.dart  # Left-right layout
│       │   ├── radial_tree_layout.dart      # Circular layout
│       │   └── force_directed_layout.dart   # Physics-based layout
│       │
│       ├── painters/
│       │   ├── connection_painter.dart  # Base connection painter
│       │   ├── line_painter.dart        # Straight lines
│       │   ├── bezier_painter.dart      # Curved connections
│       │   ├── energy_flow_painter.dart # Animated energy flow
│       │   └── dashed_painter.dart      # Dashed for locked paths
│       │
│       ├── animations/
│       │   ├── unlock_animation.dart    # Unlock effect
│       │   ├── pulse_animation.dart     # Available skill pulse
│       │   ├── glow_animation.dart      # Selected glow
│       │   └── particle_effect.dart     # Optional particles
│       │
│       ├── themes/
│       │   ├── skill_tree_theme.dart    # Theme data class
│       │   ├── default_theme.dart       # Default dark theme
│       │   └── theme_presets.dart       # Game-style presets
│       │
│       └── serialization/
│           ├── tree_serializer.dart     # JSON serialization
│           └── progress_data.dart       # Save/load progress
│
├── example/
│   ├── lib/
│   │   ├── main.dart
│   │   ├── examples/
│   │   │   ├── basic_tree.dart          # Simple example
│   │   │   ├── rpg_skill_tree.dart      # RPG-style tree
│   │   │   ├── tech_tree.dart           # Strategy game tech tree
│   │   │   └── talent_tree.dart         # MOBA-style talents
│   │   └── data/
│   │       └── sample_trees.dart        # Sample tree data
│   └── pubspec.yaml
│
└── test/
    ├── models/
    ├── widgets/
    └── layouts/
```

---

## Data Models

### SkillNode

```dart
class SkillNode<T> {
  final String id;
  final String name;
  final String? description;
  final IconData? icon;
  final String? iconUrl;           // For custom icons
  final T? data;                   // Custom data attachment

  // Progression
  final int currentLevel;
  final int maxLevel;
  final List<int> costs;           // Cost per level [10, 20, 30]
  final List<String> prerequisites; // Required node IDs

  // Categorization
  final SkillType type;            // passive, active, ultimate
  final String? branch;            // Tree branch/path name
  final int tier;                  // Tier/row in tree

  // State (computed)
  SkillState get state;            // locked, available, unlocked, maxed
  bool get canUnlock;
  int get nextCost;
}
```

### SkillState

```dart
enum SkillState {
  locked,      // Prerequisites not met
  available,   // Can be unlocked
  unlocked,    // Partially or fully unlocked
  maxed,       // All levels purchased
}
```

### SkillType

```dart
enum SkillType {
  passive,     // Always active
  active,      // Requires activation
  ultimate,    // Powerful, limited
  keystone,    // Major tree milestone
  minor,       // Small bonuses
}
```

### SkillTree

```dart
class SkillTree<T> {
  final String id;
  final String name;
  final List<SkillNode<T>> nodes;
  final List<SkillConnection> connections;

  // Player state
  int availablePoints;
  int spentPoints;

  // Operations
  UnlockResult unlock(String nodeId);
  void reset();
  void resetNode(String nodeId);

  // Queries
  SkillNode? getNode(String id);
  List<SkillNode> getAvailableNodes();
  List<SkillNode> getUnlockedNodes();
  List<SkillNode> getPath(String fromId, String toId);

  // Serialization
  Map<String, dynamic> toJson();
  factory SkillTree.fromJson(Map<String, dynamic> json);
}
```

### SkillConnection

```dart
class SkillConnection {
  final String fromId;
  final String toId;
  final ConnectionType type;       // required, optional, exclusive
  final bool bidirectional;

  // Visual
  final Color? color;
  final double? thickness;
  final ConnectionStyle style;     // solid, dashed, animated
}
```

---

## Widget API

### SkillTreeView

```dart
SkillTreeView<T>(
  // Required
  tree: SkillTree<T>,

  // Layout
  layout: TreeLayout,              // vertical, horizontal, radial, force
  width: double?,
  height: double?,
  padding: EdgeInsets,

  // Node rendering
  nodeBuilder: Widget Function(SkillNode<T>, SkillState)?,
  nodeSize: Size,
  nodeSeparation: double,
  levelSeparation: double,

  // Connection rendering
  connectionBuilder: CustomPainter Function(SkillConnection)?,
  connectionStyle: ConnectionStyle,
  connectionAnimated: bool,

  // Interactions
  onNodeTap: void Function(SkillNode<T>)?,
  onNodeLongPress: void Function(SkillNode<T>)?,
  onNodeDoubleTap: void Function(SkillNode<T>)?,
  onUnlockAttempt: Future<bool> Function(SkillNode<T>)?,

  // Gestures
  enablePan: bool,
  enableZoom: bool,
  minZoom: double,
  maxZoom: double,
  initialZoom: double,

  // Visual feedback
  showTooltips: bool,
  tooltipBuilder: Widget Function(SkillNode<T>)?,
  highlightPath: bool,             // Highlight path to hovered node
  showUnlockAnimation: bool,

  // Theme
  theme: SkillTreeTheme?,

  // Controller
  controller: SkillTreeController?,
)
```

### SkillTreeController

```dart
class SkillTreeController<T> extends ChangeNotifier {
  // State
  SkillTree<T> get tree;
  int get availablePoints;

  // Operations
  Future<UnlockResult> unlock(String nodeId);
  void reset();
  void resetNode(String nodeId);
  void addPoints(int amount);

  // View control
  void zoomTo(double zoom);
  void panTo(Offset position);
  void focusNode(String nodeId);
  void highlightPath(String nodeId);

  // Serialization
  Map<String, dynamic> exportProgress();
  void importProgress(Map<String, dynamic> data);
}
```

---

## Theme System

### SkillTreeTheme

```dart
class SkillTreeTheme {
  // Node colors by state
  final Color lockedNodeColor;
  final Color lockedNodeBorderColor;
  final Color availableNodeColor;
  final Color availableNodeBorderColor;
  final Color unlockedNodeColor;
  final Color unlockedNodeBorderColor;
  final Color maxedNodeColor;
  final Color maxedNodeBorderColor;

  // Node colors by type
  final Color passiveColor;
  final Color activeColor;
  final Color ultimateColor;
  final Color keystoneColor;

  // Connection colors
  final Color connectionLockedColor;
  final Color connectionUnlockedColor;
  final Color connectionHighlightColor;

  // Text styles
  final TextStyle nodeNameStyle;
  final TextStyle nodeLevelStyle;
  final TextStyle nodeCostStyle;
  final TextStyle tooltipTitleStyle;
  final TextStyle tooltipDescriptionStyle;

  // Shapes
  final double nodeRadius;
  final double nodeBorderWidth;
  final double connectionWidth;

  // Animations
  final Duration unlockDuration;
  final Duration pulseDuration;
  final Curve unlockCurve;

  // Presets
  factory SkillTreeTheme.dark();
  factory SkillTreeTheme.light();
  factory SkillTreeTheme.rpg();      // Fantasy style
  factory SkillTreeTheme.scifi();    // Futuristic style
  factory SkillTreeTheme.minimal();  // Clean, simple
}
```

---

## Layout Algorithms

### Supported Layouts

| Layout | Description | Best For |
|--------|-------------|----------|
| `VerticalTreeLayout` | Top-down hierarchy | Traditional skill trees |
| `HorizontalTreeLayout` | Left-to-right flow | Progression trees |
| `RadialTreeLayout` | Circular/constellation | Skyrim-style trees |
| `ForceDirectedLayout` | Physics-based positioning | Web/network trees |
| `GridLayout` | Fixed grid positions | Tech trees |
| `CustomLayout` | Manual node positions | Artistic designs |

### Layout Interface

```dart
abstract class TreeLayout {
  Map<String, Offset> calculatePositions(
    List<SkillNode> nodes,
    List<SkillConnection> connections,
    Size availableSize,
  );
}
```

---

## Animations

### Built-in Animations

| Animation | Trigger | Effect |
|-----------|---------|--------|
| `UnlockAnimation` | Node unlocked | Burst + glow |
| `PulseAnimation` | Available nodes | Subtle pulse |
| `GlowAnimation` | Selected/hovered | Outer glow |
| `EnergyFlowAnimation` | Connections | Flowing particles |
| `PathHighlightAnimation` | Hover | Path traces |
| `ShakeAnimation` | Unlock failed | Node shakes |

---

## Serialization

### Progress Save/Load

```dart
// Export progress
final progress = controller.exportProgress();
// Returns: { "unlockedNodes": ["node1", "node2"], "nodeLevels": {"node1": 3}, "points": 5 }

// Save to storage
await storage.save('skill_progress', jsonEncode(progress));

// Load progress
final saved = await storage.load('skill_progress');
controller.importProgress(jsonDecode(saved));
```

### Full Tree Serialization

```dart
// Export entire tree definition
final treeJson = tree.toJson();

// Load tree from JSON (for remote configs)
final tree = SkillTree.fromJson(jsonDecode(treeData));
```

---

## Constraints

1. **Performance** - Handle 100+ nodes at 60fps
2. **No external graph dependencies** - Custom rendering engine
3. **Accessibility** - Screen reader support, keyboard navigation
4. **Responsive** - Works on mobile, tablet, desktop, web
5. **FDL Optional** - Can integrate with FDL but not required
6. **Type Safety** - Generic node data support
7. **Null Safety** - Full null safety compliance

---

## Acceptance Criteria

### Core
- [ ] SkillNode model with all properties
- [ ] SkillTree model with operations
- [ ] SkillTreeView widget renders tree
- [ ] Nodes display correct state visuals
- [ ] Connections render between nodes
- [ ] Tap to unlock functionality works
- [ ] Points system tracks spending

### Layouts
- [ ] VerticalTreeLayout implemented
- [ ] HorizontalTreeLayout implemented
- [ ] RadialTreeLayout implemented
- [ ] Custom positioning supported

### Interactions
- [ ] Pan gesture works smoothly
- [ ] Pinch zoom works on mobile
- [ ] Mouse wheel zoom on desktop
- [ ] Node tap/long-press callbacks
- [ ] Tooltip on hover/long-press

### Animations
- [ ] Unlock animation plays
- [ ] Available nodes pulse
- [ ] Connection energy flow (optional)
- [ ] Path highlight on hover

### Theme
- [ ] Default dark theme
- [ ] Theme customization works
- [ ] At least 2 preset themes

### Serialization
- [ ] Export progress to JSON
- [ ] Import progress from JSON
- [ ] Tree definition serialization

### Testing
- [ ] Unit tests for models
- [ ] Widget tests for SkillTreeView
- [ ] Layout algorithm tests
- [ ] 80%+ code coverage

### Documentation
- [ ] README with examples
- [ ] API documentation
- [ ] Example app with 3+ demos

---

## Test Plan

### Automated
1. Unit tests for SkillNode, SkillTree, SkillConnection
2. Widget tests for SkillTreeView rendering
3. Layout algorithm correctness tests
4. Serialization round-trip tests
5. `flutter analyze` passes

### Manual
1. Example app runs on iOS, Android, Web
2. Pan/zoom gestures feel natural
3. Unlock animations are smooth
4. Large tree (50+ nodes) performs well
5. Theme customization works

---

## Implementation Phases

### Phase 1: Core Models (2 days)
- SkillNode, SkillTree, SkillConnection models
- SkillState, SkillType enums
- Basic tree operations (unlock, reset)
- Unit tests for models

### Phase 2: Basic Rendering (3 days)
- SkillTreeView widget
- VerticalTreeLayout
- Basic node rendering
- Connection painting (lines)
- Pan and zoom gestures

### Phase 3: Interactions (2 days)
- Node tap/long-press
- Unlock flow with callbacks
- Points system integration
- Tooltip display

### Phase 4: Advanced Layouts (2 days)
- HorizontalTreeLayout
- RadialTreeLayout
- Custom positioning

### Phase 5: Animations (2 days)
- Unlock animation
- Pulse animation
- Energy flow connections
- Path highlighting

### Phase 6: Theming (1 day)
- SkillTreeTheme class
- Dark/light presets
- RPG/SciFi presets

### Phase 7: Serialization (1 day)
- Progress export/import
- Tree definition serialization

### Phase 8: Polish (2 days)
- Performance optimization
- Accessibility
- Documentation
- Example app

---

## Delivery

- [ ] Package: `packages/fifty_skill_tree/`
- [ ] Tests: 80%+ coverage
- [ ] Docs: README + API docs
- [ ] Example: 3+ demo trees
- [ ] Branch: `implement/BR-027-skill-tree`

---

## Future Enhancements (Out of Scope)

- Multiplayer sync (real-time updates)
- Cloud save integration
- Skill tree editor (visual builder)
- AI-suggested builds
- Achievement integration
- Analytics tracking

---

## Related

- Source: https://github.com/fiftynotai/graph_builder
- Reference: Path of Exile skill tree, Diablo 4 talents
- Ecosystem: Fifty Flutter Kit
