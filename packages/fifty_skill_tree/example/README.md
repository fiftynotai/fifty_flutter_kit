# Fifty Skill Tree - Example App

Interactive examples demonstrating the `fifty_skill_tree` package capabilities.

## Running the Examples

```bash
cd packages/fifty_skill_tree/example
flutter run
```

## Demo Screens

### 1. Basic Tree

**File:** `lib/examples/basic_tree.dart`

A simple linear skill tree demonstrating core functionality.

**Features Demonstrated:**
- Creating a basic `SkillTree<void>` with nodes and connections
- Using `SkillTreeController` for state management
- `SkillTreeView` with `VerticalTreeLayout`
- Tap-to-unlock interactions
- Points display (available and spent)
- Reset functionality
- Long-press for skill details dialog

**Code Highlights:**
```dart
// Create tree and add points
final tree = createBasicTree();
tree.addPoints(10);

// Create controller
final controller = SkillTreeController<void>(
  tree: tree,
  theme: SkillTreeTheme.dark(),
);

// Display with SkillTreeView
SkillTreeView<void>(
  controller: controller,
  layout: const VerticalTreeLayout(),
  onNodeTap: (node) => controller.unlock(node.id),
)
```

---

### 2. RPG Skill Tree

**File:** `lib/examples/rpg_skill_tree.dart`

Multi-branch skill tree with Warrior, Mage, and Rogue paths.

**Features Demonstrated:**
- Multi-branch tree organization using `branch` property
- Custom node styling based on branch color
- Toggle between `VerticalTreeLayout` and `RadialTreeLayout`
- Progress save/load with `exportProgress()` / `importProgress()`
- Custom `nodeBuilder` for branded node widgets
- Branch legend display

**Code Highlights:**
```dart
// Save progress to JSON
final progress = controller.exportProgress();
final json = jsonEncode(progress);

// Load progress from JSON
final decoded = jsonDecode(json) as Map<String, dynamic>;
controller.importProgress(decoded);

// Custom node builder
SkillTreeView<void>(
  controller: controller,
  nodeBuilder: (node, state) => CustomRpgNode(
    node: node,
    state: state,
    branchColor: getBranchColor(node.branch),
  ),
)
```

---

### 3. Tech Tree

**File:** `lib/examples/tech_tree.dart`

Strategy game research tree with grid-based layout.

**Features Demonstrated:**
- `GridLayout` for organized rows and columns
- Research-style progression
- Tier-based organization
- Connection types showing research dependencies

**Code Highlights:**
```dart
SkillTreeView<void>(
  controller: controller,
  layout: const GridLayout(
    columns: 4,
    rows: 3,
  ),
)
```

---

### 4. Talent Tree

**File:** `lib/examples/talent_tree.dart`

MOBA-style talent system with three distinct paths.

**Features Demonstrated:**
- Three parallel progression paths
- Ultimate skills at path endpoints
- Level requirements per tier
- Exclusive connections (choosing one path locks others)

---

## Sample Data

**File:** `lib/data/sample_trees.dart`

Contains factory functions for creating sample trees:

- `createBasicTree()` - Simple linear progression
- `createRpgTree()` - Multi-branch RPG skills
- `createTechTree()` - Strategy game research
- `createTalentTree()` - MOBA talent system

## FDL Integration

The example app uses **Fifty Design Language (FDL)** packages:

- `fifty_theme` - Dark theme styling
- `fifty_tokens` - Colors, spacing, typography
- `fifty_ui` - Cards, buttons, dialogs

This demonstrates how `fifty_skill_tree` integrates seamlessly with the Fifty Flutter Kit.

## Key Patterns

### Controller Setup

```dart
// Create tree
final tree = SkillTree<void>(id: 'my_tree', name: 'My Tree');
tree.addNode(SkillNode(id: 'skill_1', name: 'Skill 1'));
tree.addPoints(10);

// Create controller
final controller = SkillTreeController<void>(
  tree: tree,
  theme: SkillTreeTheme.dark(),
);

// Listen for changes
controller.addListener(() {
  // Update UI
});

// Don't forget to dispose
controller.dispose();
```

### Handling Unlock Results

```dart
Future<void> handleNodeTap(SkillNode node) async {
  final result = await controller.unlock(node.id);

  if (result.success) {
    // Show success feedback
  } else {
    // Handle failure
    switch (result.reason) {
      case UnlockFailureReason.prerequisitesNotMet:
        // Show "unlock prerequisites first"
        break;
      case UnlockFailureReason.insufficientPoints:
        // Show "not enough points"
        break;
      case UnlockFailureReason.alreadyMaxed:
        // Show "already at max level"
        break;
      // ...
    }
  }
}
```

### Custom Theming

```dart
// Use built-in dark theme
final theme = SkillTreeTheme.dark();

// Or customize
final customTheme = SkillTreeTheme.dark().copyWith(
  availableNodeBorderColor: Colors.cyan,
  unlockedNodeColor: Colors.green.shade900,
);

controller.setTheme(customTheme);
```

---

Built with the [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit) by [Fifty.ai](https://fifty.ai)
