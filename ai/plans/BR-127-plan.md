# Implementation Plan: BR-127

**Complexity:** L (Large)
**Estimated Duration:** 2-3 days
**Risk Level:** Medium

## Summary

Add three opt-in features to `fifty_scroll_sequence`: snap-to-keyframe on scroll idle, symmetrical lifecycle callbacks (onEnter/onLeave/onEnterBack/onLeaveBack), and horizontal scroll axis support. All features are additive -- default behavior is unchanged when parameters are omitted.

---

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `.../models/snap_config.dart` | CREATE | SnapConfig model with constructors: default, everyNFrames, scenes |
| `.../models/lifecycle_event.dart` | CREATE | ScrollSequenceLifecycleEvent enum (enter, leave, enterBack, leaveBack) |
| `.../models/models.dart` | MODIFY | Add exports for snap_config.dart and lifecycle_event.dart |
| `.../core/snap_controller.dart` | CREATE | SnapController -- idle detection, nearest-point resolution, scroll animation |
| `.../core/viewport_observer.dart` | CREATE | ViewportObserver -- tracks visibility state, fires directional callbacks |
| `.../core/core.dart` | MODIFY | Add exports for snap_controller.dart and viewport_observer.dart |
| `.../core/scroll_progress_tracker.dart` | MODIFY | Add axis-aware progress calculation methods for horizontal mode |
| `.../widgets/scroll_sequence_widget.dart` | MODIFY | Add snapConfig, lifecycle callbacks, scrollDirection parameters; wire up SnapController and ViewportObserver |
| `.../widgets/sliver_scroll_sequence.dart` | MODIFY | Add snapConfig, lifecycle callbacks, scrollDirection parameters; pass through to delegate/content |
| `.../widgets/pinned_scroll_section.dart` | MODIFY | Add scrollDirection parameter; horizontal pinning (sticky left) |
| `.../widgets/scroll_sequence_controller.dart` | MODIFY | Add scrollDirection to ScrollSequenceStateAccessor; update jumpToProgress for horizontal offset |
| `test/snap_config_test.dart` | CREATE | Unit tests for SnapConfig model and constructors |
| `test/snap_controller_test.dart` | CREATE | Unit tests for SnapController idle detection, nearest-point, cancel |
| `test/viewport_observer_test.dart` | CREATE | Unit tests for ViewportObserver state machine |
| `test/scroll_progress_tracker_test.dart` | MODIFY | Add horizontal progress calculation tests |
| `test/scroll_sequence_widget_test.dart` | MODIFY | Add widget tests for snap, lifecycle callbacks, horizontal mode |
| `test/sliver_scroll_sequence_test.dart` | MODIFY | Add widget tests for snap, lifecycle callbacks, horizontal mode in slivers |

**Total: 6 new files, 11 modified files**

---

## Implementation Steps

### Phase 1: Models (no dependencies)

#### 1a. SnapConfig (`/packages/fifty_scroll_sequence/lib/src/models/snap_config.dart`)

Immutable configuration class for snap behavior.

**Public API:**
```
class SnapConfig {
  const SnapConfig({
    required List<double> snapPoints,     // progress values 0.0-1.0, sorted
    Duration snapDuration = 300ms,
    Curve snapCurve = Curves.easeOut,
    Duration idleTimeout = 150ms,         // debounce before snapping
  });

  const SnapConfig.everyNFrames({
    required int n,
    required int frameCount,
    Duration snapDuration = 300ms,
    Curve snapCurve = Curves.easeOut,
    Duration idleTimeout = 150ms,
  });

  const SnapConfig.scenes({
    required List<int> sceneStartFrames,  // frame indices
    required int frameCount,
    Duration snapDuration = 300ms,
    Curve snapCurve = Curves.easeOut,
    Duration idleTimeout = 150ms,
  });

  // Computed helpers:
  double nearestSnapPoint(double currentProgress); // O(log n) binary search
  List<double> get snapPoints;
  Duration get snapDuration;
  Curve get snapCurve;
  Duration get idleTimeout;
}
```

**Key details:**
- `everyNFrames` factory: Generates points at `[0, n/(frameCount-1), 2n/(frameCount-1), ..., 1.0]`. Uses `frameCount` to convert frame indices to progress values.
- `scenes` factory: Converts `[0, 50, 100, 148]` to progress `[0.0, 50/147, 100/147, 1.0]`.
- `nearestSnapPoint` uses binary search on sorted list. For equidistant ties, snaps to lower progress (nearer to start -- feels more natural for "scene" usage).
- The class is `@immutable` with `operator==`, `hashCode`, and `toString`.
- `snapPoints` are validated in constructor: must be non-empty, each must be in [0.0, 1.0], auto-sorted.
- `const` is NOT possible for `everyNFrames`/`scenes` (they compute a List) -- these are factory constructors that return non-const instances.

#### 1b. ScrollSequenceLifecycleEvent (`/packages/fifty_scroll_sequence/lib/src/models/lifecycle_event.dart`)

Simple enum used internally by ViewportObserver to track state transitions.

```
enum ScrollSequenceLifecycleEvent {
  enter,
  leave,
  enterBack,
  leaveBack,
}
```

This enum is primarily for the ViewportObserver's state machine. The widget surface uses individual VoidCallback parameters (`onEnter`, `onLeave`, `onEnterBack`, `onLeaveBack`), not the enum. The enum is still exported for consumers who want to build custom listeners.

#### 1c. Update `models.dart` barrel

Add:
```dart
export 'lifecycle_event.dart';
export 'snap_config.dart';
```

---

### Phase 2: Core Logic (depends on Phase 1)

#### 2a. SnapController (`/packages/fifty_scroll_sequence/lib/src/core/snap_controller.dart`)

Stateful controller that detects scroll idle and animates to the nearest snap point.

**Public API:**
```
class SnapController {
  SnapController({
    required SnapConfig config,
  });

  // Called by the widget's scroll notification handler.
  void onScrollUpdate();    // resets idle timer
  void onScrollEnd();       // starts idle timer
  void cancelSnap();        // cancels any active snap animation

  // Called by the widget to wire up the scroll position.
  void attach(ScrollPosition scrollPosition, {
    required double Function() widgetTopOffset,
    required double scrollExtent,
    required double Function() currentProgress,
  });
  void detach();

  bool get isSnapping;      // true during snap animation

  void dispose();
}
```

**Internal mechanics:**
1. On `onScrollEnd()`, start a `Timer` for `config.idleTimeout` (default 150ms).
2. When timer fires: compute `nearestSnapPoint(currentProgress())`, convert to scroll offset via `widgetTopOffset() + nearestProgress * scrollExtent`, and call `scrollPosition.animateTo(targetOffset, duration: config.snapDuration, curve: config.snapCurve)`.
3. On `onScrollUpdate()` during an active snap: call `cancelSnap()` which stops the animation by calling `scrollPosition.jumpTo(scrollPosition.pixels)` (this halts `animateTo` mid-flight) and cancels the idle timer.
4. `dispose()` cancels timer and any pending snap.

**Design decision -- Timer vs ScrollEndNotification:**
Use `Timer` after `onScrollEnd()` rather than relying solely on `ScrollEndNotification`, because `ScrollEndNotification` fires at the end of ballistic scrolling which may itself be after the user lifts their finger. The timer approach gives the same debounce behavior regardless of scroll physics. However, `onScrollEnd()` IS triggered by `ScrollEndNotification` -- the timer provides the additional idle debounce.

**Guard against jumpToProgress loops:**
When the SnapController triggers `animateTo`, it sets `isSnapping = true`. The widget checks `isSnapping` before calling `onScrollUpdate()`/`onScrollEnd()`, preventing the snap animation's own scroll events from re-triggering snap logic. This mirrors the existing `_isUpdatingFromController` pattern in `ScrollSequenceController`.

#### 2b. ViewportObserver (`/packages/fifty_scroll_sequence/lib/src/core/viewport_observer.dart`)

Tracks widget visibility and fires directional lifecycle callbacks.

**Public API:**
```
class ViewportObserver {
  ViewportObserver({
    VoidCallback? onEnter,
    VoidCallback? onLeave,
    VoidCallback? onEnterBack,
    VoidCallback? onLeaveBack,
  });

  // Called by the widget on each scroll update.
  void updateVisibility({
    required bool isVisible,
    required ScrollDirection direction,
  });

  // For pinned mode.
  void updatePinnedState({
    required double progress,     // 0.0 = just pinned, 1.0 = about to unpin
    required ScrollDirection direction,
  });

  void reset();    // resets state machine to initial
  void dispose();  // no-op currently, for future-proofing
}
```

**State machine (non-pinned mode):**

```
States: { outside, inside }
Transitions:
  outside + (isVisible=true, direction=forward)  -> inside  -> fire onEnter
  inside  + (isVisible=false, direction=forward)  -> outside -> fire onLeave
  outside + (isVisible=true, direction=backward)  -> inside  -> fire onEnterBack
  inside  + (isVisible=false, direction=backward) -> outside -> fire onLeaveBack
```

**Pinned mode:**
- `onEnter` fires when `progress` crosses from 0.0 upward (pin start) while scrolling forward.
- `onLeave` fires when `progress` crosses from 1.0 downward... NO. `onLeave` fires when `progress` reaches 1.0 (unpin) while scrolling forward.
- `onEnterBack` fires when `progress` drops below 1.0 (re-entering pin zone from the bottom) while scrolling backward.
- `onLeaveBack` fires when `progress` drops to 0.0 (scrolled back past the pin start) while scrolling backward.

In pinned mode, the widget is always "visible" during the pin phase. The lifecycle maps to the pin boundary, not viewport visibility. We use a `_pinnedState` enum: `{ beforePin, pinned, afterPin }` with transitions that fire the appropriate callbacks.

**Important:** Callbacks fire exactly once per transition. The observer stores the last state and only fires on state change.

#### 2c. Update `ScrollProgressTracker` (`/packages/fifty_scroll_sequence/lib/src/core/scroll_progress_tracker.dart`)

Add axis-aware overloads:

```dart
// Existing (vertical) -- NO CHANGE to signatures.
// double calculateProgress({widgetTopInViewport, viewportHeight});
// double calculatePinnedProgress({scrollOffset, sectionTop});

// NEW: Horizontal equivalents.
double calculateHorizontalProgress({
  required double widgetLeftInViewport,
  required double viewportWidth,
});

double calculatePinnedHorizontalProgress({
  required double scrollOffset,
  required double sectionLeft,
});
```

**calculateHorizontalProgress:**
Same math as vertical but uses `widgetLeftInViewport` and `viewportWidth`:
```
totalTravel = viewportWidth + scrollExtent
traveled = viewportWidth - widgetLeftInViewport
return (traveled / totalTravel).clamp(0.0, 1.0)
```

**calculatePinnedHorizontalProgress:**
Same math as vertical but with left offset:
```
scrolledPastPin = scrollOffset - sectionLeft
return (scrolledPastPin / scrollExtent).clamp(0.0, 1.0)
```

**No change to `updateDirection` or `direction`** -- direction tracking is axis-agnostic (it only looks at progress delta).

#### 2d. Update `core.dart` barrel

Add:
```dart
export 'snap_controller.dart';
export 'viewport_observer.dart';
```

---

### Phase 3: Widget Integration (depends on Phase 2)

This is the largest phase. Both `ScrollSequence` and `SliverScrollSequence` gain new parameters.

#### 3a. Update `ScrollSequenceStateAccessor` (in `scroll_sequence_controller.dart`)

Add `scrollDirection` to the accessor interface:
```dart
abstract class ScrollSequenceStateAccessor {
  // ... existing ...
  Axis get scrollDirection; // NEW
}
```

Update `ScrollSequenceController.jumpToProgress` to handle horizontal axis:
- When `accessor.scrollDirection == Axis.horizontal`, the offset calculation uses `widgetLeftOffset` (new accessor getter) instead of `widgetTopOffset`. However, for simplicity, rename the existing getter to something generic or add a separate `widgetLeadingOffset` that returns top for vertical and left for horizontal. **Preferred approach:** Keep `widgetTopOffset` and add a doc comment clarifying it returns the leading-edge offset for the configured scroll direction. The widget state's implementation switches on `scrollDirection`.

Actually, cleaner approach: Rename nothing. In the accessor implementation, `widgetTopOffset` returns the leading-edge offset appropriate for the current axis. For vertical it returns the vertical offset (as today). For horizontal it returns the horizontal offset. The name stays `widgetTopOffset` for backward compat, with a doc update clarifying "leading edge offset in the scroll direction." No breaking change.

#### 3b. Update `ScrollSequence` widget (`scroll_sequence_widget.dart`)

**New constructor parameters:**
```dart
const ScrollSequence({
  // ... existing ...
  this.snapConfig,                              // NEW
  this.onEnter,                                 // NEW
  this.onLeave,                                 // NEW
  this.onEnterBack,                             // NEW
  this.onLeaveBack,                             // NEW
  this.scrollDirection = Axis.vertical,          // NEW
});
```

**New fields:**
```dart
final SnapConfig? snapConfig;
final VoidCallback? onEnter;
final VoidCallback? onLeave;
final VoidCallback? onEnterBack;
final VoidCallback? onLeaveBack;
final Axis scrollDirection;
```

**State changes (`_ScrollSequenceState`):**

1. **SnapController lifecycle:**
   - Create in `initState` if `widget.snapConfig != null`.
   - Attach after internals are ready (needs scroll position -- do in `didChangeDependencies` or after first frame via `WidgetsBinding.instance.addPostFrameCallback`).
   - Actually, SnapController needs the `ScrollPosition`. The widget currently gets it lazily via `Scrollable.maybeOf(context)?.position`. We can attach the SnapController in `didChangeDependencies` once the scroll position is available.
   - On `dispose`, call `_snapController?.dispose()`.

2. **ViewportObserver lifecycle:**
   - Create in `initState` if any lifecycle callback is non-null.
   - Feed it from the same scroll handler that feeds progress: in `_handleScroll` (non-pinned) or `_buildPinned`'s `onProgressChanged` callback.
   - Dispose in `dispose`.

3. **Scroll notification handling for snap:**
   - In non-pinned mode, wrap with `NotificationListener<ScrollNotification>` (already done). Add detection for `ScrollEndNotification` to call `_snapController?.onScrollEnd()`, and `ScrollUpdateNotification` to call `_snapController?.onScrollUpdate()`.
   - In pinned mode, the `PinnedScrollSection` drives progress from the ancestor scroll position. We need to listen for scroll-end events on the ancestor. This can be done by adding a post-frame callback in `didChangeDependencies` that listens to the ancestor `ScrollPosition`'s `isScrollingNotifier`.

4. **Horizontal axis:**
   - In `_buildPinned`, pass `scrollDirection` to `PinnedScrollSection`.
   - In `_buildNonPinned`, use the axis-appropriate dimension for the SizedBox (width vs height for scrollExtent).
   - In `_handleScroll`, use horizontal progress calculation when `scrollDirection == Axis.horizontal`.
   - Update `ScrollSequenceStateAccessor` implementation: `widgetTopOffset` returns leading-edge offset appropriate for axis.
   - The `Scrollable.maybeOf(context)` picks up the correct axis from the ancestor automatically.

5. **Update `build` method:**
   - No change to conditional pinned/non-pinned branching -- axis is handled inside each branch.

6. **Pass through to `.network()` and `.spriteSheet()` constructors:**
   - Add `snapConfig`, lifecycle callbacks, and `scrollDirection` parameters to both named constructors.

7. **Implement `ScrollSequenceStateAccessor.scrollDirection`:**
   ```dart
   @override
   Axis get scrollDirection => widget.scrollDirection;
   ```

#### 3c. Update `PinnedScrollSection` (`pinned_scroll_section.dart`)

**New parameter:**
```dart
const PinnedScrollSection({
  // ... existing ...
  this.scrollDirection = Axis.vertical,  // NEW
});

final Axis scrollDirection;
```

**Changes to `_PinnedScrollSectionState`:**

- `build`: Switch on `scrollDirection`:
  - **Vertical (existing):** `SizedBox(height: totalHeight)` with `Positioned(top: stickyOffset, left: 0, right: 0, height: viewportHeight)`.
  - **Horizontal:** `SizedBox(width: totalWidth)` where `totalWidth = viewportWidth + scrollExtent`, with `Positioned(left: stickyOffset, top: 0, bottom: 0, width: viewportWidth)`.

- `_calculateStickyOffset`: Switch on axis:
  - **Vertical (existing):** Uses `renderBox.localToGlobal(Offset.zero).dy`.
  - **Horizontal:** Uses `renderBox.localToGlobal(Offset.zero).dx`.

- `_updateProgress`: Same logic, switched on axis:
  - **Vertical (existing):** Uses `.dy`.
  - **Horizontal:** Uses `.dx`.

- `MediaQuery.sizeOf(context)`: Use `.height` for vertical, `.width` for horizontal.

**Refactoring approach:** Extract the axis-dependent calculations into a helper method that returns `(viewportDimension, leadingEdgeOffset)` based on `scrollDirection`. This avoids duplicating the entire calculation logic.

#### 3d. Update `SliverScrollSequence` (`sliver_scroll_sequence.dart`)

**New constructor parameters:** Same as ScrollSequence -- `snapConfig`, lifecycle callbacks, `scrollDirection`.

**Changes:**
- Pass `scrollDirection` to the delegate and content widget.
- The delegate's `build` method already computes progress from `shrinkOffset` -- this is axis-independent since `SliverPersistentHeader` works the same in both axes.
- Pass lifecycle callbacks and snapConfig to `_SliverScrollSequenceContent`.

**`_SliverScrollSequenceContent` state changes:**
- ViewportObserver: Create if callbacks provided. Feed from `didUpdateWidget` (progress changes).
- SnapController: More complex for slivers. The sliver's scroll position is available via `Scrollable.maybeOf(context)?.position`. However, snap in a sliver context means animating the CustomScrollView's scroll position. Wire up similar to ScrollSequence.
- Implement `ScrollSequenceStateAccessor.scrollDirection`.

**SliverScrollSequence horizontal:**
The `CustomScrollView` itself has `scrollDirection` which determines the sliver layout axis. The `SliverPersistentHeader`'s `shrinkOffset` works along the main axis automatically. So passing `scrollDirection` through is mainly for viewport observation and snap offset calculation.

---

### Phase 4: Tests (depends on Phase 3)

#### 4a. `test/snap_config_test.dart` (NEW)

**Test groups:**
1. **Default constructor:**
   - snapPoints are sorted
   - Invalid points (< 0, > 1) throw assertion
   - Empty list throws assertion
   - nearestSnapPoint returns correct value (below, above, equidistant, exact match)
   - nearestSnapPoint with single point always returns that point

2. **everyNFrames:**
   - `n=50, frameCount=150` generates `[0.0, 50/149, 100/149, 1.0]`
   - `n=1` generates all frames as snap points
   - `n > frameCount` generates only `[0.0, 1.0]`
   - `frameCount=1` generates `[0.0]`

3. **scenes:**
   - `[0, 50, 100, 148], frameCount=149` converts correctly
   - Single scene `[0]` generates `[0.0]`
   - Duplicate indices are deduplicated
   - Out-of-range indices are clamped

4. **Equality / hashCode:**
   - Same config equals
   - Different config not equals

#### 4b. `test/snap_controller_test.dart` (NEW)

**Test groups:**
1. **Idle detection:**
   - After `onScrollEnd`, timer fires after `idleTimeout`
   - `onScrollUpdate` resets the timer
   - Multiple rapid `onScrollEnd` calls only produce one snap

2. **Nearest point calculation:**
   - Verify snap target matches `config.nearestSnapPoint(currentProgress)`
   - At exact snap point, no animation (or animates to same spot)

3. **Cancel on resume:**
   - `onScrollUpdate` during snap animation calls `cancelSnap`
   - After cancel, `isSnapping` is false

4. **Attach / detach:**
   - Throws if called before attach
   - Detach cancels pending timer and snap

**Note:** These tests require a mock `ScrollPosition`. Use `FixedScrollMetrics` + a test `ScrollPosition` or create a mock. Since `ScrollPosition.animateTo` returns a `Future`, mock it with a `Completer`.

#### 4c. `test/viewport_observer_test.dart` (NEW)

**Test groups:**
1. **Non-pinned state machine:**
   - outside -> visible+forward = onEnter fires
   - inside -> not-visible+forward = onLeave fires
   - outside -> visible+backward = onEnterBack fires
   - inside -> not-visible+backward = onLeaveBack fires
   - No double-fire on same state
   - Direction=idle with visibility change still fires appropriate callback (treat idle as forward for initial enter)

2. **Pinned state machine:**
   - progress crosses 0.0 upward + forward = onEnter
   - progress reaches 1.0 + forward = onLeave
   - progress drops below 1.0 + backward = onEnterBack
   - progress drops to 0.0 + backward = onLeaveBack

3. **Reset:**
   - After reset, callbacks fire again on next transition

#### 4d. Update `test/scroll_progress_tracker_test.dart`

Add test groups:
1. **calculateHorizontalProgress:**
   - Mirror the existing vertical tests but with horizontal semantics (widgetLeftInViewport, viewportWidth)
   - Returns 0.0 at viewport right edge, 1.0 when fully scrolled past

2. **calculatePinnedHorizontalProgress:**
   - Mirror the existing pinned vertical tests with horizontal semantics

#### 4e. Update `test/scroll_sequence_widget_test.dart`

Add test groups:
1. **Snap integration:**
   - Widget with snapConfig renders without errors
   - After scroll + idle, scroll position animates (verify via scroll controller listener)
   - Snap is cancelled on new scroll input

2. **Lifecycle callbacks:**
   - onEnter fires when widget scrolls into view
   - onLeave fires when widget scrolls out of view
   - Pinned mode: onEnter at pin start, onLeave at unpin

3. **Horizontal scroll:**
   - Widget with `scrollDirection: Axis.horizontal` renders inside horizontal SingleChildScrollView
   - Horizontal scroll updates frame progress
   - Horizontal pinned mode works

#### 4f. Update `test/sliver_scroll_sequence_test.dart`

Add test groups:
1. **Snap in sliver context:**
   - SliverScrollSequence with snapConfig renders without errors

2. **Lifecycle in sliver context:**
   - Callbacks fire appropriately during CustomScrollView scrolling

3. **Horizontal sliver:**
   - SliverScrollSequence inside horizontal CustomScrollView renders without errors

---

### Phase 5: Barrel Exports and Analyzer (depends on Phase 4)

1. Verify all new public types are exported through barrel files:
   - `models/models.dart` exports `snap_config.dart` and `lifecycle_event.dart`
   - `core/core.dart` exports `snap_controller.dart` and `viewport_observer.dart`
   - Main `fifty_scroll_sequence.dart` already exports all barrels

2. Run `flutter analyze` in the package directory -- zero issues required.

3. Run full test suite -- all tests green.

---

## Testing Strategy

| Test Type | Target | Key Assertions |
|-----------|--------|----------------|
| Unit | SnapConfig | Binary search correctness, factory constructors, boundary cases |
| Unit | SnapController | Timer debounce, cancel-on-resume, attach/detach lifecycle |
| Unit | ViewportObserver | State machine transitions, exactly-once firing, reset |
| Unit | ScrollProgressTracker | Horizontal progress math mirrors vertical |
| Widget | ScrollSequence + snap | Scroll idle triggers position change |
| Widget | ScrollSequence + lifecycle | Callbacks fire once per enter/leave transition |
| Widget | ScrollSequence + horizontal | Renders in horizontal scroll, frames update |
| Widget | SliverScrollSequence | Snap, lifecycle, horizontal in sliver context |

**Estimated test count:** ~40-50 new tests across 3 new + 4 modified test files.

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Snap animation fights user scroll (jank) | Medium | High | Use `scrollPosition.jumpTo(scrollPosition.pixels)` to cancel `animateTo` cleanly; guard with `isSnapping` flag |
| Lifecycle callbacks double-fire during rapid scroll | Medium | Medium | State machine with last-state tracking; only fire on state transition |
| Horizontal pinning breaks in nested scrollables | Low | Medium | Test with both SingleChildScrollView and CustomScrollView; use `Scrollable.maybeOf(context)` which resolves nearest ancestor |
| SnapController timer leaks on hot reload | Low | Low | Cancel timer in `dispose()` and `detach()` |
| SliverPersistentHeader horizontal behavior differs | Low | High | Verify shrinkOffset is axis-agnostic in Flutter source; add integration test |
| Mock ScrollPosition difficulty in snap tests | Medium | Low | Create a minimal `TestScrollPosition` extending `ScrollPositionWithSingleContext` or use `ScrollController` in widget test |
| PinnedScrollSection horizontal breaks touch detection | Low | Medium | Verify `GestureDetector` and `Scrollable` work correctly in horizontal mode via widget tests |
| Snap + jumpToFrame interaction conflict | Medium | Medium | When `isSnapping` is true, block `ScrollSequenceController.jumpToFrame` or cancel snap first |

---

## Dependency Graph

```
Phase 1: Models (no deps)
  |
  v
Phase 2: Core Logic (depends on models)
  |
  v
Phase 3: Widget Integration (depends on core)
  |
  v
Phase 4: Tests (depends on widgets)
  |
  v
Phase 5: Exports + Analyzer (depends on all)
```

Within phases, the sub-tasks can be parallelized:
- Phase 1: `snap_config.dart` and `lifecycle_event.dart` are independent.
- Phase 2: `snap_controller.dart`, `viewport_observer.dart`, and `scroll_progress_tracker.dart` changes are independent.
- Phase 3: `scroll_sequence_widget.dart` and `sliver_scroll_sequence.dart` changes are mostly independent (both depend on `pinned_scroll_section.dart` for horizontal).
- Phase 4: All test files are independent of each other.

---

## Key Design Decisions

### 1. VoidCallback vs typed callback for lifecycle

**Decision:** Use `VoidCallback?` for `onEnter`/`onLeave`/`onEnterBack`/`onLeaveBack`.

**Rationale:** GSAP ScrollTrigger uses no-argument callbacks. The progress and frame are already available via `onFrameChanged`. Keeping lifecycles as simple VoidCallbacks matches the mental model: "tell me WHEN, not WHAT."

### 2. SnapController as a separate class (not embedded in widget state)

**Decision:** Create a standalone `SnapController` class.

**Rationale:** Keeps the widget state clean. Allows unit testing the snap logic without a widget tree. Mirrors the existing separation of concerns (FrameController, ScrollProgressTracker).

### 3. ViewportObserver as state machine (not raw visibility calculations)

**Decision:** State machine with `outside`/`inside` states for non-pinned, `beforePin`/`pinned`/`afterPin` for pinned.

**Rationale:** Guarantees exactly-once callback firing. Raw visibility + direction tracking is error-prone for edge cases (rapid direction changes, threshold bouncing).

### 4. Horizontal via axis parameter (not separate widget)

**Decision:** Add `scrollDirection: Axis` parameter to existing widgets.

**Rationale:** Horizontal mode shares 95% of logic with vertical. A separate widget would duplicate massive amounts of code. The axis-dependent parts (progress calculation, pinning offsets) are small and cleanly switchable.

### 5. SnapConfig as configuration object (not individual parameters)

**Decision:** Bundle snap parameters into a `SnapConfig` class.

**Rationale:** Snap has 4+ related parameters. Individual widget parameters would bloat the constructor. A config object is nullable (snap is off when null) and allows factory constructors for convenience (`everyNFrames`, `scenes`).

---

## Notes for FORGER

1. **SnapController timer:** Use `dart:async` `Timer`, not `Future.delayed`. Timer can be cancelled; Future cannot.

2. **Cancel animateTo:** Flutter's `ScrollPosition.animateTo` returns a `Future` and uses an internal animation. To cancel mid-flight, call `scrollPosition.jumpTo(scrollPosition.pixels)` which immediately completes the animation at the current position. Alternatively, use `scrollPosition.hold(() {})` which returns a `ScrollHoldController`.

3. **PinnedScrollSection horizontal:** The `localToGlobal(Offset.zero)` call returns both `.dx` and `.dy`. For horizontal, use `.dx`. For vertical, use `.dy` (as today). The `MediaQuery.sizeOf(context)` provides both `.width` and `.height`.

4. **SnapConfig.nearestSnapPoint:** Binary search implementation. Sort snap points in constructor, then use `lowerBound` equivalent:
   ```dart
   int low = 0, high = _sortedPoints.length - 1;
   while (low < high) { ... }
   ```
   Compare distances to `_sortedPoints[low]` and `_sortedPoints[low-1]` to pick nearest.

5. **Test helper reuse:** The existing tests already have `_FakeFrameLoader` and `_createTestImage()` duplicated across 4 test files. For BR-127, follow the same pattern (duplicate in each test file) rather than extracting to a shared helper -- this avoids touching existing tests.

6. **ViewportObserver for pinned mode:** The progress-based lifecycle maps thresholds:
   - `onEnter`: progress changes from exactly 0.0 to > 0.0 (or from below threshold to above)
   - `onLeave`: progress reaches 1.0
   - Use small epsilon (0.001) for boundary detection to avoid floating-point edge cases.
