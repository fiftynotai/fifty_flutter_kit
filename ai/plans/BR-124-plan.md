# Implementation Plan: BR-124

**Complexity:** M (Medium)
**Estimated Duration:** 1-2 days
**Risk Level:** Medium

## Summary

Add ticker-based smooth frame lerping and a pinning (sticky) widget to `fifty_scroll_sequence`. The core change is making `FrameController` ticker-driven so scroll events set a *target* while a vsync'd loop smoothly interpolates the *current* frame toward it. A new `PinnedScrollSection` widget creates scroll runway and holds its child fixed while progress accumulates.

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `packages/fifty_scroll_sequence/lib/src/utils/lerp_util.dart` | CREATE | Stateless lerp helper with convergence snap |
| `packages/fifty_scroll_sequence/lib/src/widgets/pinned_scroll_section.dart` | CREATE | Pinning wrapper widget using SizedBox + Stack + Positioned |
| `packages/fifty_scroll_sequence/lib/src/core/frame_controller.dart` | MODIFY | Add ticker-based lerp loop, curve support, target/current split |
| `packages/fifty_scroll_sequence/lib/src/core/scroll_progress_tracker.dart` | MODIFY | Add `calculatePinnedProgress` method |
| `packages/fifty_scroll_sequence/lib/src/widgets/scroll_sequence_widget.dart` | MODIFY | Add pin, builder, lerpFactor, curve params; wire pinned/non-pinned |
| `packages/fifty_scroll_sequence/lib/src/utils/utils.dart` | MODIFY | Add lerp_util export |
| `packages/fifty_scroll_sequence/lib/src/widgets/widgets.dart` | MODIFY | Add pinned_scroll_section export |
| `packages/fifty_scroll_sequence/test/frame_controller_test.dart` | MODIFY | Add lerp convergence, curve, ticker lifecycle tests |
| `packages/fifty_scroll_sequence/test/scroll_progress_tracker_test.dart` | CREATE | Tests for pinned progress calculation |
| `packages/fifty_scroll_sequence/test/lerp_util_test.dart` | CREATE | Tests for lerp helper convergence and snap |

---

## Implementation Steps

### Phase 1: LerpUtil (New File)

**File:** `packages/fifty_scroll_sequence/lib/src/utils/lerp_util.dart`

Create a pure-function utility class. No state, no dependencies. This is the mathematical core of smooth interpolation.

```
class LerpUtil {
  const LerpUtil._();

  /// Interpolate [current] toward [target] by [factor].
  ///
  /// factor = 0.15 means each tick moves 15% of the remaining distance.
  /// When the difference is less than [snapThreshold], snaps directly
  /// to [target] to prevent infinite asymptotic approach.
  static double lerp(double current, double target, double factor) {
    final delta = target - current;
    if (delta.abs() < snapThreshold) return target;
    return current + delta * factor;
  }

  /// Minimum distance before snapping to target.
  /// For a 120-frame sequence, 1 frame = ~0.0083 progress.
  /// Half a frame (~0.004) is a good snap threshold.
  static const double snapThreshold = 0.001;

  /// Check whether [current] has converged to [target].
  static bool hasConverged(double current, double target) {
    return (current - target).abs() < snapThreshold;
  }
}
```

**Key decisions:**
- Operates on `double` progress values (0.0-1.0), not frame indices. This gives sub-frame precision.
- `snapThreshold` of 0.001 prevents infinite asymptotic approach. At 120 frames, one frame is ~0.0083 progress, so 0.001 is well within sub-frame territory.
- Pure static class -- no allocation, no state.
- `factor` is NOT clamped here; the caller (FrameController) validates the range.

**Export:** Add `export 'lerp_util.dart';` to `utils/utils.dart`.

---

### Phase 2: FrameController Ticker Rewrite (Major Modification)

**File:** `packages/fifty_scroll_sequence/lib/src/core/frame_controller.dart`

This is the most critical change. The controller splits into two progress values:

- `_targetProgress` -- set directly by scroll events (instant, no lerp)
- `_currentProgress` -- driven toward target by the ticker loop (smooth)

#### 2.1: New Constructor Signature

```dart
class FrameController extends ChangeNotifier {
  FrameController({
    required this.frameCount,
    required TickerProvider vsync,
    this.lerpFactor = 0.15,
    this.curve = Curves.linear,
  }) : assert(frameCount > 0),
       assert(lerpFactor > 0.0 && lerpFactor <= 1.0) {
    _ticker = vsync.createTicker(_onTick);
  }
```

**Parameters:**
- `vsync` -- `TickerProvider` supplied by the widget (via `SingleTickerProviderStateMixin`). Required.
- `lerpFactor` -- how fast current catches up to target. 0.15 = 15% of remaining distance per tick. 1.0 = instant (no lerp, BR-123 behavior).
- `curve` -- `Curve` applied to the *target* progress before frame mapping. Default `Curves.linear` = no transform.

#### 2.2: State Fields

```dart
  late final Ticker _ticker;
  final double lerpFactor;
  final Curve curve;

  double _targetProgress = 0.0;
  double _currentProgress = 0.0;
  int _currentIndex = 0;

  // Public getters
  int get currentIndex => _currentIndex;
  double get progress => _currentProgress;
  double get targetProgress => _targetProgress;
  bool get isLerping => !LerpUtil.hasConverged(_currentProgress, _targetProgress);
```

#### 2.3: updateFromProgress (Called by Scroll Events)

```dart
  /// Set the target progress from a scroll event.
  ///
  /// Does NOT directly change the displayed frame. Instead, updates the
  /// target that the ticker loop interpolates toward.
  void updateFromProgress(double progress) {
    _targetProgress = progress.clamp(0.0, 1.0);

    // Start ticker if not already running
    if (!_ticker.isActive) {
      _ticker.start();
    }
  }
```

**Critical insight:** The scroll event only sets the target and ensures the ticker is running. It does NOT compute frame indices or notify listeners. That is the ticker's job.

#### 2.4: Ticker Callback (Runs at vsync, ~60fps)

```dart
  void _onTick(Duration elapsed) {
    if (LerpUtil.hasConverged(_currentProgress, _targetProgress)) {
      // Snap to exact target and stop
      _currentProgress = _targetProgress;
      _ticker.stop();
      _updateIndex();
      return;
    }

    _currentProgress = LerpUtil.lerp(
      _currentProgress,
      _targetProgress,
      lerpFactor,
    );

    _updateIndex();
  }

  void _updateIndex() {
    // Apply curve transform to the current (lerped) progress
    final curved = curve.transform(_currentProgress.clamp(0.0, 1.0));
    final newIndex = _progressToIndex(curved);
    if (newIndex != _currentIndex) {
      _currentIndex = newIndex;
      notifyListeners();
    }
  }
```

**Why the curve is applied to `_currentProgress`, not `_targetProgress`:**
The curve transforms the *mapping* from progress to frame index. For example, `Curves.easeInOut` means frames change slowly at the start and end of the scroll range and faster in the middle. The lerp operates in linear progress space; the curve is a display-time transform.

#### 2.5: Lifecycle Management

```dart
  /// Pause the lerp ticker (e.g., when app goes to background).
  void pauseTicker() {
    if (_ticker.isActive) _ticker.stop();
  }

  /// Resume the lerp ticker if there is unfinished interpolation.
  void resumeTicker() {
    if (isLerping && !_ticker.isActive) {
      _ticker.start();
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
```

#### 2.6: Backward Compatibility

When `lerpFactor = 1.0`, the lerp formula becomes:
```
current + (target - current) * 1.0 = target
```
So `_currentProgress` jumps to `_targetProgress` in a single tick. Combined with `snapThreshold`, this means the ticker runs for exactly one frame and stops. This is functionally identical to BR-123's instant-update behavior.

**Existing tests impact:** The existing `FrameController` tests call `updateFromProgress` and immediately check `currentIndex`. With the ticker, the index updates on the *next tick*, not synchronously. Two options:

1. **Preferred:** Add a convenience method `updateFromProgressImmediate` for testing, or
2. **Better:** In tests, use `FakeAsync` / `TestVSync` to pump exactly one frame after calling `updateFromProgress`.

The plan recommends option 2 -- update existing tests to use a `FakeTickerProvider` and pump one frame. This is more honest and ensures tests actually exercise the ticker path.

#### 2.7: Test Helper

Add to the test file:

```dart
class FakeTickerProvider extends TickerProvider {
  Ticker? lastTicker;

  @override
  Ticker createTicker(TickerCallback onTick) {
    lastTicker = Ticker(onTick);
    return lastTicker!;
  }
}
```

Then existing tests wrap calls with:
```dart
final vsync = FakeTickerProvider();
final controller = FrameController(frameCount: 10, vsync: vsync);
controller.updateFromProgress(0.5);
vsync.lastTicker!.tick(Duration.zero); // manually pump one frame
expect(controller.currentIndex, ...);
```

**For lerpFactor: 1.0 tests**, one tick is sufficient to converge. For lerpFactor: 0.15 tests, pump multiple ticks and verify convergence.

---

### Phase 3: ScrollProgressTracker Pinned Mode (Modification)

**File:** `packages/fifty_scroll_sequence/lib/src/core/scroll_progress_tracker.dart`

Add a second calculation method for pinned mode. The existing `calculateProgress` stays untouched.

```dart
  /// Calculate normalized progress (0.0 to 1.0) for pinned mode.
  ///
  /// In pinned mode, progress is based on how far the section has scrolled
  /// past the point where it pinned (its top reached the viewport top).
  ///
  /// [scrollOffset] is how far the scroll view has scrolled.
  /// [sectionTop] is the top edge of the PinnedScrollSection in the
  /// scroll content (its layout offset, not screen position).
  ///
  /// Progress:
  /// - 0.0 when scrollOffset == sectionTop (section just pinned)
  /// - 1.0 when scrollOffset == sectionTop + scrollExtent (about to unpin)
  double calculatePinnedProgress({
    required double scrollOffset,
    required double sectionTop,
  }) {
    final scrolledPastPin = scrollOffset - sectionTop;
    return (scrolledPastPin / scrollExtent).clamp(0.0, 1.0);
  }
```

**Key insight:** In pinned mode, progress is purely based on how many pixels of `scrollExtent` have been consumed since the section pinned. No viewport height involved. The `PinnedScrollSection` widget provides the correct `sectionTop` from its layout position.

---

### Phase 4: PinnedScrollSection Widget (New File)

**File:** `packages/fifty_scroll_sequence/lib/src/widgets/pinned_scroll_section.dart`

This is the scroll runway + sticky positioning widget. It does NOT know about frames or images -- it is a general-purpose pinning container.

#### 4.1: Widget Structure

```dart
/// Creates a scroll "runway" that pins its child to the viewport
/// while [scrollExtent] pixels of scroll distance are consumed.
///
/// The total height of this widget is `viewportHeight + scrollExtent`.
/// While the user scrolls through the runway:
/// - Phase 1 (pre-pin): Child scrolls into view normally
/// - Phase 2 (pinned): Child stays fixed at viewport top, progress 0.0 -> 1.0
/// - Phase 3 (post-pin): Child scrolls away normally
///
/// Reports [progress] (0.0 to 1.0) through the [onProgressChanged] callback.
class PinnedScrollSection extends StatefulWidget {
  const PinnedScrollSection({
    required this.scrollExtent,
    required this.child,
    this.onProgressChanged,
    super.key,
  });

  final double scrollExtent;
  final Widget child;
  final ValueChanged<double>? onProgressChanged;
}
```

#### 4.2: State Implementation

```dart
class _PinnedScrollSectionState extends State<PinnedScrollSection> {
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final totalHeight = viewportHeight + widget.scrollExtent;

    return SizedBox(
      height: totalHeight,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              _updateProgress(viewportHeight);
              return false; // don't absorb
            },
            child: Stack(
              children: [
                Positioned(
                  top: _calculateStickyOffset(viewportHeight),
                  left: 0,
                  right: 0,
                  height: viewportHeight,
                  child: widget.child,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
```

#### 4.3: Sticky Offset Calculation

The child's `top` offset within the SizedBox determines stickiness:

```dart
  double _calculateStickyOffset(double viewportHeight) {
    // Get this widget's position relative to the viewport
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return 0;

    final widgetTopInViewport = renderBox.localToGlobal(Offset.zero).dy;

    if (widgetTopInViewport >= 0) {
      // Pre-pin: widget hasn't reached viewport top yet.
      // Child sits at top of SizedBox, scrolls normally.
      return 0;
    }

    // Widget top is above viewport top (negative = scrolled past).
    // The "scrolled past" amount is -widgetTopInViewport.
    final scrolledPast = -widgetTopInViewport;

    if (scrolledPast >= widget.scrollExtent) {
      // Post-pin: all scrollExtent consumed.
      // Child offset = scrollExtent, so it sits at the bottom of the
      // SizedBox and scrolls away naturally.
      return widget.scrollExtent;
    }

    // Pinned phase: offset child downward by exactly the amount
    // the SizedBox has scrolled past the viewport top.
    // This keeps the child visually fixed at viewport top.
    return scrolledPast;
  }
```

**How it works:** The `SizedBox` is `viewportHeight + scrollExtent` tall. As it scrolls, its top goes negative. The child is `Positioned` with `top: scrolledPast`, which exactly cancels the scroll, keeping it visually fixed at the viewport top. When `scrolledPast >= scrollExtent`, the child stops compensating and scrolls away.

#### 4.4: Progress Reporting

```dart
  void _updateProgress(double viewportHeight) {
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null || !renderBox.hasSize) return;

    final widgetTopInViewport = renderBox.localToGlobal(Offset.zero).dy;

    double newProgress;
    if (widgetTopInViewport >= 0) {
      newProgress = 0.0;
    } else {
      final scrolledPast = -widgetTopInViewport;
      newProgress = (scrolledPast / widget.scrollExtent).clamp(0.0, 1.0);
    }

    if (newProgress != _progress) {
      _progress = newProgress;
      widget.onProgressChanged?.call(_progress);
      if (mounted) setState(() {});
    }
  }
```

**Important:** The `NotificationListener<ScrollNotification>` here catches scroll events from ancestor scrollables. But because `PinnedScrollSection` is a child of a `SingleChildScrollView` (or similar), the notifications bubble down. We need to listen from the parent, not the child.

**Correction:** `NotificationListener` captures notifications from *descendants*, not ancestors. Since the scrollable is an ancestor, `PinnedScrollSection` cannot catch its scroll notifications this way.

**Revised approach:** Use `Scrollable.of(context)` + `ScrollPosition.addListener` to react to ancestor scroll changes. Alternatively, the parent `ScrollSequence` widget can pass scroll progress down. The cleanest pattern:

```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();
  // Listen to the ancestor scrollable's position
  _scrollPosition?.removeListener(_onScroll);
  _scrollPosition = Scrollable.maybeOf(context)?.position;
  _scrollPosition?.addListener(_onScroll);
}

void _onScroll() {
  _updateProgress(MediaQuery.sizeOf(context).height);
  // Also trigger rebuild for sticky offset
  if (mounted) setState(() {});
}

@override
void dispose() {
  _scrollPosition?.removeListener(_onScroll);
  super.dispose();
}
```

This correctly listens to ancestor scroll position changes.

**Export:** Add `export 'pinned_scroll_section.dart';` to `widgets/widgets.dart`.

---

### Phase 5: ScrollSequence Widget Updates (Modification)

**File:** `packages/fifty_scroll_sequence/lib/src/widgets/scroll_sequence_widget.dart`

#### 5.1: New Parameters

```dart
class ScrollSequence extends StatefulWidget {
  const ScrollSequence({
    required this.frameCount,
    required this.framePath,
    this.scrollExtent = 3000.0,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.placeholder,
    this.loadingBuilder,
    this.onFrameChanged,     // CHANGED: now passes (int frameIndex, double progress)
    this.indexPadWidth,
    this.indexOffset = 0,
    this.maxCacheSize = 100,
    this.pin = true,          // NEW: default true (pinned mode)
    this.builder,             // NEW: overlay builder
    this.lerpFactor = 0.15,   // NEW: smoothing factor
    this.curve = Curves.linear, // NEW: progress-to-frame curve
    super.key,
  });

  // ... existing params ...

  /// Whether to pin (stick) the sequence while scrollExtent is consumed.
  final bool pin;

  /// Builder for overlay content that reacts to frame index and progress.
  ///
  /// [child] is the frame display widget. Wrap it or stack overlays on top.
  final Widget Function(
    BuildContext context,
    int frameIndex,
    double progress,
    Widget child,
  )? builder;

  /// Lerp smoothing factor (0.0 to 1.0).
  ///
  /// Lower values = smoother but slower catch-up.
  /// 1.0 = instant (no smoothing, equivalent to BR-123 behavior).
  final double lerpFactor;

  /// Curve applied to the progress-to-frame mapping.
  final Curve curve;
}
```

#### 5.2: onFrameChanged Callback Change

The existing `onFrameChanged` is `ValueChanged<int>`. For BR-124, it should also pass progress. Two options:

**Option A (breaking):** Change to `void Function(int frameIndex, double progress)?`
**Option B (additive):** Add a separate `onProgressChanged` callback.

**Recommendation:** Option A. This is a pre-1.0 package (v0.1.0), so breaking changes are acceptable. The brief explicitly requests "Update `onFrameChanged` to pass both frameIndex AND progress." If the FORGER prefers a typedef for cleanliness:

```dart
typedef FrameChangedCallback = void Function(int frameIndex, double progress);
```

Define this in `models/` or at the top of the widget file.

#### 5.3: State Class Changes

```dart
class _ScrollSequenceState extends State<ScrollSequence>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
```

**`SingleTickerProviderStateMixin`:** Provides the `TickerProvider` that `FrameController` needs for its vsync'd lerp loop.

**`WidgetsBindingObserver`:** Pauses/resumes the ticker when the app goes to background.

#### 5.4: initState Changes

```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addObserver(this);

  _loader = AssetFrameLoader(...);
  _cache = FrameCacheManager(maxCacheSize: widget.maxCacheSize);
  _controller = FrameController(
    frameCount: widget.frameCount,
    vsync: this,               // SingleTickerProviderStateMixin
    lerpFactor: widget.lerpFactor,
    curve: widget.curve,
  );
  _tracker = ScrollProgressTracker(scrollExtent: widget.scrollExtent);

  _controller.addListener(_onFrameChanged);
  _eagerLoadAllFrames();
}
```

#### 5.5: App Lifecycle

```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.paused ||
      state == AppLifecycleState.inactive) {
    _controller.pauseTicker();
  } else if (state == AppLifecycleState.resumed) {
    _controller.resumeTicker();
  }
}
```

#### 5.6: onFrameChanged Handler

```dart
void _onFrameChanged() {
  widget.onFrameChanged?.call(
    _controller.currentIndex,
    _controller.progress,
  );
  if (mounted) setState(() {});
}
```

#### 5.7: Build Method -- Pinned vs Non-Pinned

```dart
@override
Widget build(BuildContext context) {
  if (widget.pin) {
    return _buildPinned();
  }
  return _buildNonPinned();
}

Widget _buildPinned() {
  return PinnedScrollSection(
    scrollExtent: widget.scrollExtent,
    onProgressChanged: (progress) {
      _controller.updateFromProgress(progress);
    },
    child: _buildFrameContent(),
  );
}

Widget _buildNonPinned() {
  // Existing BR-123 behavior: NotificationListener + SizedBox
  return NotificationListener<ScrollNotification>(
    onNotification: _handleScroll,
    child: SizedBox(
      width: widget.width,
      height: widget.height ?? widget.scrollExtent,
      child: _buildFrameContent(),
    ),
  );
}
```

#### 5.8: Frame Content with Builder Support

```dart
Widget _buildFrameContent() {
  if (_isLoadingFrames && _cache.length == 0) {
    if (widget.placeholder != null) {
      return Image(image: widget.placeholder!, fit: widget.fit);
    }
    if (widget.loadingBuilder != null) {
      return widget.loadingBuilder!(context);
    }
    return const SizedBox.shrink();
  }

  final frameWidget = FrameDisplay(
    frameIndex: _controller.currentIndex,
    cacheManager: _cache,
    fit: widget.fit,
    width: widget.width,
    height: widget.height,
  );

  if (widget.builder != null) {
    return widget.builder!(
      context,
      _controller.currentIndex,
      _controller.progress,
      frameWidget,
    );
  }

  return frameWidget;
}
```

#### 5.9: dispose Changes

```dart
@override
void dispose() {
  WidgetsBinding.instance.removeObserver(this);
  _controller.removeListener(_onFrameChanged);
  _controller.dispose(); // disposes ticker
  _cache.clearAll();
  _loader.dispose();
  super.dispose();
}
```

#### 5.10: Non-Pinned Scroll Handler (unchanged logic)

The existing `_handleScroll` method stays the same for non-pinned mode. In pinned mode, `PinnedScrollSection` calculates progress and passes it via `onProgressChanged`.

---

### Phase 6: Barrel Export Updates

**File:** `packages/fifty_scroll_sequence/lib/src/utils/utils.dart`

Add:
```dart
export 'lerp_util.dart';
```

**File:** `packages/fifty_scroll_sequence/lib/src/widgets/widgets.dart`

Add:
```dart
export 'pinned_scroll_section.dart';
```

No changes needed to the top-level `fifty_scroll_sequence.dart` since it already re-exports `utils/utils.dart` and `widgets/widgets.dart`.

---

## Testing Strategy

### Phase 7: Unit Tests

#### 7.1: LerpUtil Tests (New File)

**File:** `packages/fifty_scroll_sequence/test/lerp_util_test.dart`

Tests:
- `lerp(0.0, 1.0, 0.15)` returns `0.15`
- `lerp(0.5, 1.0, 0.15)` returns `0.575`
- `lerp(0.999, 1.0, 0.15)` snaps to `1.0` (within snapThreshold)
- `lerp(0.0, 0.0, 0.15)` returns `0.0` (no movement)
- `lerp(1.0, 0.0, 0.15)` returns `0.85` (backward lerp works)
- `hasConverged(0.0, 0.0)` is true
- `hasConverged(0.0, 0.01)` is false
- `hasConverged(0.999, 1.0)` depends on whether delta < 0.001
- Convergence test: repeatedly lerp from 0.0 toward 1.0 at factor 0.15 -- must converge within 60 iterations

#### 7.2: FrameController Tests (Modify Existing)

**File:** `packages/fifty_scroll_sequence/test/frame_controller_test.dart`

**Existing tests migration:**
- All 11 existing tests need updating to provide a `FakeTickerProvider` and manually tick.
- Tests that check `currentIndex` after `updateFromProgress` must pump at least one tick (for lerpFactor: 1.0) or enough ticks to converge (for lerpFactor: 0.15).

**New tests:**
- Lerp convergence: set target to 1.0, tick N times at lerpFactor 0.15, verify converges
- Lerp factor 1.0: single tick converges instantly
- Lerp factor 0.01: converges slowly (more ticks needed)
- Curve transform: easeInOut curve maps midpoint differently than linear
- Ticker stops when converged (isActive check)
- Ticker starts when target changes
- `pauseTicker()` stops active ticker
- `resumeTicker()` restarts if not converged
- `isLerping` returns true when current != target

#### 7.3: ScrollProgressTracker Tests (New File)

**File:** `packages/fifty_scroll_sequence/test/scroll_progress_tracker_test.dart`

Tests for `calculatePinnedProgress`:
- `scrollOffset == sectionTop` returns 0.0
- `scrollOffset == sectionTop + scrollExtent` returns 1.0
- `scrollOffset == sectionTop + scrollExtent/2` returns 0.5
- `scrollOffset < sectionTop` returns 0.0 (clamped)
- `scrollOffset > sectionTop + scrollExtent` returns 1.0 (clamped)

Also add tests for existing `calculateProgress` (currently untested):
- Progress 0.0 when widget top is at viewport bottom
- Progress 1.0 when widget top has scrolled past viewport by scrollExtent
- Clamping at boundaries

#### 7.4: Widget Tests (Desirable but Complex)

Widget tests for `PinnedScrollSection` require a test scroll environment. The FORGER should attempt these but they may be deferred to a follow-up if the test harness proves too complex:

- Create a `SingleChildScrollView` with a `PinnedScrollSection` child
- Use `tester.drag` to scroll
- Verify the child's screen position stays fixed during pin phase
- Verify `onProgressChanged` fires with correct values

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Existing tests break due to FrameController constructor change | High | Medium | Update all 11 tests to use FakeTickerProvider. lerpFactor: 1.0 ensures single-tick convergence for simple tests. |
| PinnedScrollSection flickers during fast scroll | Medium | High | Ensure `_calculateStickyOffset` and `_updateProgress` always agree. Both use the same `renderBox.localToGlobal` call. Consider caching the offset in a field. |
| Ticker not pausing when widget off-screen (waste) | Medium | Low | The ticker self-stops when converged. Only runs during active lerp. Not a performance issue. |
| `Scrollable.maybeOf(context)` returns null (not inside scrollable) | Low | High | Guard with null check. If null, PinnedScrollSection falls back to non-pinned behavior and logs a warning. |
| iOS overscroll bounce causes negative progress or > 1.0 | Medium | Medium | All progress values are clamped to 0.0-1.0 at every calculation point (tracker, controller). |
| Multiple ScrollSequence widgets on same page interfere | Low | Medium | Each widget creates its own FrameController with its own Ticker. No shared state. Independent by design. |
| `SingleTickerProviderStateMixin` conflicts if widget already has a ticker | Low | Low | The package owns its State class. No external ticker conflict possible. |

---

## Architecture Diagram

```
Scroll Event (ancestor ScrollPosition)
        |
        v
PinnedScrollSection
  - Calculates sticky offset (visual pinning)
  - Calculates progress (0.0 to 1.0)
  - Calls onProgressChanged
        |
        v
ScrollSequence._buildPinned
  - Receives progress
  - Calls controller.updateFromProgress(progress)
        |
        v
FrameController
  - _targetProgress = progress (instant)
  - Starts ticker if not running
        |
        v
Ticker Loop (vsync, ~60fps)
  - _currentProgress = LerpUtil.lerp(current, target, factor)
  - curvedProgress = curve.transform(_currentProgress)
  - newIndex = _progressToIndex(curvedProgress)
  - If index changed: notifyListeners()
  - If converged: ticker.stop()
        |
        v
ScrollSequence._onFrameChanged
  - Calls widget.onFrameChanged(index, progress)
  - Calls setState()
        |
        v
FrameDisplay
  - Renders _cache.getFrame(currentIndex)
  - Falls back to nearestCachedFrame if missing
```

---

## Implementation Order

The FORGER should implement in this exact order to maintain a compilable state at each step:

1. **LerpUtil** -- new file, no dependencies, can test immediately
2. **FrameController rewrite** -- core change, update existing tests
3. **ScrollProgressTracker.calculatePinnedProgress** -- additive method, new tests
4. **PinnedScrollSection** -- new widget, depends on nothing from above except `Scrollable.of`
5. **ScrollSequence widget updates** -- wires everything together
6. **Barrel exports** -- utils.dart, widgets.dart
7. **Run `flutter analyze`** -- zero issues
8. **Run `flutter test`** -- all tests pass

---

## Notes for FORGER

- The `FrameController` constructor is a breaking change. Every test file and the `ScrollSequence` widget must be updated simultaneously.
- `PinnedScrollSection` should be a general-purpose widget -- it knows nothing about frames or images. It just pins and reports progress. This makes it reusable for other scroll effects.
- The `builder` callback wraps `FrameDisplay` -- it does NOT replace it. The `child` parameter IS the frame image widget.
- When `pin: true`, the widget no longer needs `NotificationListener<ScrollNotification>` in its own build tree. The `PinnedScrollSection` handles scroll listening via `Scrollable.of(context)`.
- Keep the `_handleScroll` method for `pin: false` mode. Do NOT remove it.
