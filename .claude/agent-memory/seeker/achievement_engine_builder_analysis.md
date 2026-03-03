# fifty_achievement_engine Widget Builder Patterns Analysis

**Date:** 2026-03-03
**Package:** fifty_achievement_engine v0.2.0
**Research Focus:** Add builder callbacks to 5 widgets for customization
**Reference Pattern:** fifty_skill_tree's `nodeBuilder` callback

---

## REFERENCE PATTERN: SkillTreeView nodeBuilder

**File:** `/packages/fifty_skill_tree/lib/src/widgets/skill_tree_view.dart:89`

```dart
// Constructor parameter (line 55)
final Widget Function(SkillNode<T> node, SkillState state)? nodeBuilder;

// Usage (lines 282-287)
if (widget.nodeBuilder != null) {
  nodeWidget = GestureDetector(
    onTap: () => _handleNodeTap(node),
    onLongPress: () => _handleNodeLongPress(node),
    child: widget.nodeBuilder!(node, state),
  );
} else {
  nodeWidget = SkillNodeWidget<T>(...); // default
}
```

**Key Pattern:**
- Callback type signature: `Widget Function(Data, State)?`
- Builder receives: model data + computed state
- Wrapping gesture detection applied outside builder
- Fallback to default widget if builder is null
- No direct FDL imports — builders compose from provided data

---

## 5 WIDGETS NEEDING BUILDER PATTERNS

### 1. AchievementCard

**File:** `/packages/fifty_achievement_engine/lib/src/widgets/achievement_card.dart`

**Constructor Parameters (lines 23-35):**
```dart
const AchievementCard({
  super.key,
  required this.achievement,           // Model data
  required this.progress,              // 0.0-1.0
  this.state = AchievementState.available,  // Current state
  this.onTap,
  this.onLongPress,
  this.backgroundColor,                // Overrides
  this.borderColor,
  this.showProgress = true,
  this.compact = false,
  this.rarityColors,
});
```

**Build Logic (lines 112-142):**
- Computes `rarityColor` from achievement + colorScheme + overrides
- Wraps container in `GestureDetector(onTap, onLongPress)`
- Renders main content via `_buildContent()` or `_buildHiddenContent()`
- Applies state-based opacity

**Data Available to Builder:**
- `Achievement<T>` — id, name, description, icon, rarity, points, hidden, category
- `double progress` — current progress (0.0-1.0)
- `AchievementState state` — locked, available, unlocked, claimed
- `Color rarityColor` — computed from `_getRarityColor()`
- `ColorScheme colorScheme` — from theme context

**Proposed Builder Signature:**
```dart
final Widget Function(
  Achievement<T> achievement,
  double progress,
  AchievementState state,
  Color rarityColor,
)?  cardBuilder;
```

**Default UI Returns:**
Container with border, padding, icon + content column

---

### 2. AchievementList

**File:** `/packages/fifty_achievement_engine/lib/src/widgets/achievement_list.dart`

**Constructor Parameters (lines 37-53):**
```dart
const AchievementList({
  super.key,
  required this.controller,            // AchievementController<T>
  this.filter = AchievementFilter.all,
  this.rarityFilter,
  this.categoryFilter,
  this.onTap,                          // void Function(Achievement<T>)?
  this.onLongPress,                    // void Function(Achievement<T>)?
  this.padding,
  this.spacing = 12,
  this.compact = false,
  this.showProgress = true,
  this.emptyWidget,                    // Existing customization point
  this.headerBuilder,                  // Existing customization point
  this.physics,
  this.shrinkWrap = false,
});
```

**Build Logic (lines 138-172):**
- Uses `ListenableBuilder` to react to controller changes
- Filters achievements based on 4 criteria (filter, rarity, category, none)
- Builds `ListView.separated` with `AchievementCard` per item
- Falls back to empty state widget

**Data Available to Builder:**
- Filtered `List<Achievement<T>>` — already computed
- Individual item: `Achievement<T>`, `progress`, `state`
- Would replace lines 159-168 (current AchievementCard rendering)

**Proposed Builder Signature:**
```dart
final Widget Function(
  BuildContext context,
  List<Achievement<T>> filtered,
  AchievementController<T> controller,
)?  itemBuilder;
```

OR (more granular):
```dart
final Widget Function(
  BuildContext context,
  Achievement<T> achievement,
  double progress,
  AchievementState state,
  int index,
)?  cardBuilder;
```

**Default UI Returns:**
`ListView.separated` with `AchievementCard` widgets

---

### 3. AchievementSummary

**File:** `/packages/fifty_achievement_engine/lib/src/widgets/achievement_summary.dart`

**Constructor Parameters (lines 22-30):**
```dart
const AchievementSummary({
  super.key,
  required this.controller,            // AchievementController<T>
  this.backgroundColor,                // Override
  this.showRarityBreakdown = false,
  this.showCategoryBreakdown = false,
  this.compact = false,
  this.rarityColors,
});
```

**Build Logic (lines 55-88):**
- Uses `ListenableBuilder` to react to controller
- Renders header (unlockedCount / totalCount, points display)
- Renders progress bar
- Conditionally renders rarity/category breakdown sections
- Uses helper methods: `_buildHeader()`, `_buildProgressSection()`, `_buildBreakdown*()`

**Data Available to Builder:**
- `AchievementController<T>` — full state
- Computed values:
  - `int unlockedCount` / `int totalCount`
  - `double completionPercentage`
  - `int earnedPoints` / `int totalPoints`
  - Rarity breakdown: `Map<AchievementRarity, (unlocked: int, total: int)>`
  - Category breakdown: `Map<String, (unlocked: int, total: int)>`

**Proposed Builder Signature:**
```dart
final Widget Function(
  BuildContext context,
  AchievementController<T> controller,
  SummaryStats stats,  // computed aggregate
)?  contentBuilder;
```

Where `SummaryStats`:
```dart
class SummaryStats {
  final int unlockedCount;
  final int totalCount;
  final double completionPercentage;
  final int earnedPoints;
  final int totalPoints;
  final Map<AchievementRarity, int> rarityUnlocked;
  final Map<AchievementRarity, int> rarityTotal;
  final Map<String, int> categoryUnlocked;
  final Map<String, int> categoryTotal;
}
```

**Default UI Returns:**
Container with header (icon + unlocked/total + points), progress bar, optional breakdowns

---

### 4. AchievementPopup

**File:** `/packages/fifty_achievement_engine/lib/src/widgets/achievement_popup.dart`

**Constructor Parameters (lines 37-46):**
```dart
const AchievementPopup({
  super.key,
  required this.achievement,           // Achievement<T> — the unlocked achievement
  this.onDismiss,                      // VoidCallback?
  this.onTap,                          // VoidCallback?
  this.duration = const Duration(seconds: 4),
  this.backgroundColor,                // Override
  this.showAnimation = true,
  this.rarityColors,
});
```

**Build Logic (lines 153-212):**
- Stateful widget with AnimationController (slide, fade, scale)
- Renders Material(transparency) + GestureDetector
- Displays: icon (gradient bg), name, description, rarity badge, points
- Auto-dismisses after duration
- Animations wrap the entire container

**Data Available to Builder:**
- `Achievement<T>` — id, name, description, icon, rarity, points
- `Color rarityColor` — computed from `_getRarityColor()`
- `AnimationController _controller` — for custom animation chaining
- `Duration duration` — dismiss timing

**Proposed Builder Signature:**
```dart
final Widget Function(
  BuildContext context,
  Achievement<T> achievement,
  Color rarityColor,
  AnimationController animationController,
)?  contentBuilder;
```

**Default UI Returns:**
Animated container with icon + text column + rarity badge

---

### 5. AchievementProgressBar

**File:** `/packages/fifty_achievement_engine/lib/src/widgets/achievement_progress_bar.dart`

**Constructor Parameters (lines 18-27):**
```dart
const AchievementProgressBar({
  super.key,
  required this.progress,              // 0.0-1.0
  this.height = 6,
  this.backgroundColor,                // Override
  this.foregroundColor,                // Override
  this.borderRadius,                   // Override
  this.showLabel = false,
  this.labelStyle,
});
```

**Build Logic (lines 57-111):**
- Clamps progress to [0.0, 1.0]
- Renders container (background) + clipped AnimatedContainer (fill)
- Conditionally adds percentage label below

**Data Available to Builder:**
- `double progress` — clamped 0.0-1.0
- `double height`
- `Color backgroundColor` — from param or theme
- `Color foregroundColor` — from param or theme

**Proposed Builder Signature:**
```dart
final Widget Function(
  BuildContext context,
  double progress,
  double height,
  Color backgroundColor,
  Color foregroundColor,
)?  indicatorBuilder;
```

**Default UI Returns:**
Container + AnimatedContainer with clipping (animated fill effect)

---

## IMPLEMENTATION PATTERNS

### Pattern 1: Simple Content Builder (Popup, ProgressBar)

For widgets that render a single cohesive piece of content, replace the entire build body:

```dart
class AchievementPopup<T> extends StatefulWidget {
  // ... existing params ...

  /// Custom builder for popup content.
  final Widget Function(
    BuildContext context,
    Achievement<T> achievement,
    Color rarityColor,
    AnimationController animationController,
  )? contentBuilder;

  @override
  State<AchievementPopup<T>> createState() => _AchievementPopupState<T>();
}

class _AchievementPopupState<T> extends State<AchievementPopup<T>>
    with SingleTickerProviderStateMixin {
  // ... animation setup ...

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final rarityColor = _getRarityColor(colorScheme);

    final content = widget.contentBuilder?.call(
      context,
      widget.achievement,
      rarityColor,
      _controller,
    ) ?? _buildDefaultContent(context, rarityColor);

    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            // Animations wrap the builder result
            return Transform.translate(
              offset: Offset(0, _slideAnimation.value),
              child: Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.scale(
                  scale: _scaleAnimation.value,
                  child: child,
                ),
              ),
            );
          },
          child: Material(
            type: MaterialType.transparency,
            child: GestureDetector(
              onTap: widget.onTap ?? _dismiss,
              child: content,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultContent(BuildContext context, Color rarityColor) {
    // Current _buildContent + _buildIcon + _buildRarityBadge logic
  }
}
```

### Pattern 2: Item Builder (List)

For list-like widgets with repeated items, builders apply per-item:

```dart
class AchievementList<T> extends StatelessWidget {
  // ... existing params ...

  /// Custom builder for achievement cards.
  final Widget Function(
    BuildContext context,
    Achievement<T> achievement,
    double progress,
    AchievementState state,
    int index,
  )? cardBuilder;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final achievements = _filterAchievements();

        if (achievements.isEmpty) {
          return emptyWidget ?? _buildEmptyState();
        }

        return ListView.separated(
          padding: padding ?? EdgeInsets.all(FiftySpacing.md),
          physics: physics,
          shrinkWrap: shrinkWrap,
          itemCount: achievements.length,
          separatorBuilder: (_, __) => SizedBox(height: spacing),
          itemBuilder: (context, index) {
            final achievement = achievements[index];
            final state = controller.getState(achievement.id);
            final progress = controller.getProgress(achievement.id);

            final card = cardBuilder?.call(
              context,
              achievement,
              progress,
              state,
              index,
            ) ?? AchievementCard<T>(
              achievement: achievement,
              progress: progress,
              state: state,
              onTap: onTap != null ? () => onTap!(achievement) : null,
              onLongPress: onLongPress != null ? () => onLongPress!(achievement) : null,
              showProgress: showProgress,
              compact: compact,
            );

            return card;
          },
        );
      },
    );
  }
}
```

### Pattern 3: Aggregate Data Builder (Summary)

For widgets displaying computed aggregate data:

```dart
class AchievementSummary<T> extends StatelessWidget {
  // ... existing params ...

  /// Custom builder for summary content.
  final Widget Function(
    BuildContext context,
    AchievementController<T> controller,
    SummaryStats stats,
    bool showRarityBreakdown,
    bool showCategoryBreakdown,
    bool compact,
  )? contentBuilder;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final stats = SummaryStats(
          unlockedCount: controller.unlockedAchievements.length,
          totalCount: controller.achievements.length,
          completionPercentage: controller.completionPercentage,
          earnedPoints: controller.earnedPoints,
          totalPoints: controller.totalPoints,
          rarityBreakdown: _computeRarityBreakdown(),
          categoryBreakdown: _computeCategoryBreakdown(),
        );

        final content = contentBuilder?.call(
          context,
          controller,
          stats,
          showRarityBreakdown,
          showCategoryBreakdown,
          compact,
        ) ?? _buildDefaultContent(context, stats);

        final colorScheme = Theme.of(context).colorScheme;
        return Container(
          padding: EdgeInsets.all(compact ? FiftySpacing.md : FiftySpacing.lg),
          decoration: BoxDecoration(
            color: backgroundColor ?? colorScheme.surfaceContainerHighest,
            borderRadius: FiftyRadii.lgRadius,
            border: Border.all(color: colorScheme.outline),
          ),
          child: content,
        );
      },
    );
  }

  Widget _buildDefaultContent(BuildContext context, SummaryStats stats) {
    // Current build logic
  }
}
```

---

## BUILDER DATA CLASSES TO CREATE

These classes encapsulate data passed to builders:

```dart
/// Aggregate statistics for achievement summary.
class SummaryStats {
  const SummaryStats({
    required this.unlockedCount,
    required this.totalCount,
    required this.completionPercentage,
    required this.earnedPoints,
    required this.totalPoints,
    required this.rarityBreakdown,      // Map<AchievementRarity, (unlocked: int, total: int)>
    required this.categoryBreakdown,    // Map<String, (unlocked: int, total: int)>
  });

  final int unlockedCount;
  final int totalCount;
  final double completionPercentage;
  final int earnedPoints;
  final int totalPoints;
  final Map<AchievementRarity, ({int unlocked, int total})> rarityBreakdown;
  final Map<String, ({int unlocked, int total})> categoryBreakdown;
}
```

---

## WIDGET DEFAULT BUILD LOGIC (Current)

### AchievementCard._buildContent()
- Lines 181-269
- Row with icon + column of title/description/progress/badge
- Animated opacity wrapper, gesture detection
- State-based styling (border width, color, opacity)

### AchievementList (ListView)
- Lines 148-170
- `ListView.separated` with 5 filter stages
- Each item is `AchievementCard<T>`

### AchievementSummary (Container)
- Lines 55-88
- Column: header + progress section + optional breakdowns
- Each breakdown is a column of rows

### AchievementPopup (Animated Material)
- Lines 153-212
- Material(transparency) + animated transforms
- Row: icon (animated scale) + column of text
- Auto-dismissal logic (lines 112-116)

### AchievementProgressBar (Animated Fill)
- Lines 57-111
- Container (background) + LayoutBuilder + AnimatedContainer (fill)
- Optional percentage label

---

## BARREL EXPORT

**File:** `/packages/fifty_achievement_engine/lib/src/widgets/widgets.dart:1-14`

Current exports all 5 widgets. After adding builders, ensure builder data classes are exported:

```dart
library;

export 'achievement_card.dart';
export 'achievement_list.dart';
export 'achievement_popup.dart';
export 'achievement_progress_bar.dart';
export 'achievement_summary.dart';
export 'summary_stats.dart';  // NEW - if extracted to separate file
```

---

## TESTING PATTERNS

**File:** `/packages/fifty_achievement_engine/test/widgets/achievement_card_test.dart`

Current test approach:
- `buildTestWidget()` wrapper that creates MaterialApp + Scaffold
- Tests rarity color resolution (common/uncommon/rare/epic/legendary)
- Tests override behavior (rarityColors parameter)
- Tests theme alignment with different ColorSchemes

For builder tests, add:
```dart
testWidgets('uses custom cardBuilder when provided', (tester) async {
  final builderCalls = <(Achievement<void>, double, AchievementState, Color)>[];

  await tester.pumpWidget(buildTestWidget(
    achievement: testAchievement,
    cardBuilder: (ach, progress, state, rarity) {
      builderCalls.add((ach, progress, state, rarity));
      return Container(child: Text('Custom: ${ach.name}'));
    },
  ));

  expect(find.text('Custom: Test Achievement'), findsOneWidget);
  expect(builderCalls.length, 1);
});

testWidgets('defaults to AchievementCard when builder is null', (tester) async {
  await tester.pumpWidget(buildTestWidget(
    achievement: testAchievement,
    cardBuilder: null,
  ));

  // Should render default card UI
  expect(find.text('Test Achievement'), findsOneWidget);
});
```

---

## SUMMARY TABLE

| Widget | Builder Type | Data Passed | Default Returns |
|--------|------------|-------------|-----------------|
| **AchievementCard** | Content | Achievement, progress, state, rarityColor | Container + icon + text column |
| **AchievementList** | Item (per-card) | Achievement, progress, state, index | ListView.separated of cards |
| **AchievementSummary** | Content (aggregate) | Controller, SummaryStats, flags | Column: header + progress + breakdowns |
| **AchievementPopup** | Content (animated) | Achievement, rarityColor, AnimationController | Material + animated icon + text column |
| **AchievementProgressBar** | Indicator | progress, height, bg/fg colors | Container + AnimatedContainer fill |

---

## IMPLEMENTATION PRIORITY

1. **Phase 1 — Foundation (AchievementProgressBar, AchievementCard)**
   - Simplest: no aggregation, single item builders
   - Tests most data types (colors, animations, states)

2. **Phase 2 — Composition (AchievementPopup, AchievementList)**
   - Popup: animation integration
   - List: repeated item builder pattern

3. **Phase 3 — Aggregation (AchievementSummary)**
   - Complex data: SummaryStats extraction
   - Conditional rendering branches

---

**Status:** Ready for ARCHITECT planning
**Next Step:** Create FR-001 implementation plan
