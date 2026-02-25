# Implementation Plan: BR-126

**Complexity:** M (Medium)
**Estimated Duration:** 1-2 days
**Risk Level:** Medium

## Summary

Add `ScrollSequenceController` (ChangeNotifier for programmatic control), `SliverScrollSequence` (sliver widget for CustomScrollView), an example app at `apps/scroll_sequence_example/` with three demo pages, comprehensive tests, and a full README. This makes the package publish-ready.

---

## Codebase Baseline (Post BR-123/124/125)

### Existing Architecture

```
packages/fifty_scroll_sequence/lib/
  fifty_scroll_sequence.dart          # Barrel: exports core/, loaders/, models/, strategies/, utils/, widgets/
  src/
    core/
      core.dart                       # Barrel: frame_cache_manager, frame_controller, scroll_progress_tracker
      frame_cache_manager.dart        # LRU cache with ui.Image disposal, dedup, preloadForStrategy
      frame_controller.dart           # ChangeNotifier: ticker-based lerp, progress -> frame index
      scroll_progress_tracker.dart    # calculateProgress, calculatePinnedProgress, direction tracking
    loaders/
      loaders.dart                    # Barrel
      frame_loader.dart               # Abstract: loadFrame(index), resolveFramePath(index), dispose()
      asset_frame_loader.dart         # Asset bundle loader
      network_frame_loader.dart       # HTTP + disk cache loader
      sprite_sheet_loader.dart        # Grid crop from sprite sheets
    models/
      models.dart                     # Barrel
      frame_info.dart                 # Immutable FrameInfo(index, path, width?, height?)
      scroll_sequence_config.dart     # Immutable config data class
    strategies/
      strategies.dart                 # Barrel
      preload_strategy.dart           # Abstract + 3 impls (eager, chunked, progressive) + ScrollDirection enum
    utils/
      utils.dart                      # Barrel
      frame_path_resolver.dart        # {index} placeholder resolution
      lerp_util.dart                  # Static lerp + hasConverged helpers
    widgets/
      widgets.dart                    # Barrel: frame_display, pinned_scroll_section, scroll_sequence_widget
      frame_display.dart              # StatelessWidget: RawImage with gapless fallback
      pinned_scroll_section.dart      # Pinning via SizedBox + Stack + localToGlobal offset tracking
      scroll_sequence_widget.dart     # Main ScrollSequence StatefulWidget (pinned/non-pinned, 3 constructors)
```

### Key Integration Points

- `_ScrollSequenceState` owns: `FrameLoader`, `FrameCacheManager`, `FrameController`, `ScrollProgressTracker`, `PreloadStrategy`
- `FrameController` is the internal ChangeNotifier that maps progress (0.0-1.0) to frame index via ticker-based lerp
- `PinnedScrollSection` does pinning via `SizedBox(height: viewportHeight + scrollExtent)` + `Stack` with computed offset
- `ScrollSequence` widget has pinned/non-pinned modes and three constructors (default, `.network()`, `.spriteSheet()`)
- State has `_isLoadingFrames`, `_loadedCount`, `_totalToLoad` for loading progress tracking
- `_onFrameChanged` calls `widget.onFrameChanged?.call(currentIndex, progress)` and triggers strategy preload

### Existing Tests (8 files, ~109 tests)

- `frame_path_resolver_test.dart`, `lerp_util_test.dart`, `frame_controller_test.dart`
- `frame_cache_manager_test.dart`, `scroll_progress_tracker_test.dart`
- `preload_strategy_test.dart`, `network_frame_loader_test.dart`, `sprite_sheet_loader_test.dart`

---

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `packages/fifty_scroll_sequence/lib/src/widgets/scroll_sequence_controller.dart` | CREATE | ScrollSequenceController class |
| `packages/fifty_scroll_sequence/lib/src/widgets/sliver_scroll_sequence.dart` | CREATE | SliverScrollSequence widget + delegate |
| `packages/fifty_scroll_sequence/lib/src/widgets/scroll_sequence_widget.dart` | MODIFY | Add optional `controller` param, wire bidirectional sync |
| `packages/fifty_scroll_sequence/lib/src/widgets/widgets.dart` | MODIFY | Add 2 new exports |
| `packages/fifty_scroll_sequence/README.md` | REWRITE | Full documentation |
| `packages/fifty_scroll_sequence/test/scroll_sequence_controller_test.dart` | CREATE | Unit tests for controller |
| `packages/fifty_scroll_sequence/test/sliver_scroll_sequence_test.dart` | CREATE | Widget tests for sliver |
| `packages/fifty_scroll_sequence/test/scroll_sequence_widget_test.dart` | CREATE | Widget tests for main widget |
| `apps/scroll_sequence_example/pubspec.yaml` | CREATE | Example app dependencies |
| `apps/scroll_sequence_example/lib/main.dart` | CREATE | App entry point |
| `apps/scroll_sequence_example/lib/app/app.dart` | CREATE | GetMaterialApp shell |
| `apps/scroll_sequence_example/lib/core/routes/route_manager.dart` | CREATE | Route definitions |
| `apps/scroll_sequence_example/lib/core/bindings/initial_bindings.dart` | CREATE | Global DI setup |
| `apps/scroll_sequence_example/lib/core/utils/frame_generator.dart` | CREATE | Procedural gradient frame generator |
| `apps/scroll_sequence_example/lib/features/menu/views/menu_page.dart` | CREATE | Menu with demo links |
| `apps/scroll_sequence_example/lib/features/basic/views/basic_page.dart` | CREATE | Basic usage demo |
| `apps/scroll_sequence_example/lib/features/pinned/views/pinned_page.dart` | CREATE | Pinned mode demo |
| `apps/scroll_sequence_example/lib/features/multi/views/multi_sequence_page.dart` | CREATE | Multi-sequence demo |

---

## Implementation Steps

### Phase 1: ScrollSequenceController (Tasks 1-4)

#### 1.1 Create `ScrollSequenceController` class

**File:** `packages/fifty_scroll_sequence/lib/src/widgets/scroll_sequence_controller.dart`

**Class Design:**

```dart
class ScrollSequenceController extends ChangeNotifier {
  // --- Read-only state ---
  int get currentFrame;       // Current frame index (from FrameController)
  double get progress;        // Current progress 0.0-1.0
  int get frameCount;         // Total frames
  bool get isFullyLoaded;     // All frames in cache
  int get loadedFrameCount;   // Number of cached frames
  double get loadingProgress; // loadedFrameCount / frameCount

  // --- Commands ---
  void jumpToFrame(int frame, {Duration duration = const Duration(milliseconds: 500)});
  void jumpToProgress(double progress, {Duration duration = const Duration(milliseconds: 500)});
  Future<void> preloadAll();
  void clearCache();
}
```

**Internal Design Notes:**

- `ScrollSequenceController` does NOT own `FrameController` or `FrameCacheManager`. It acts as a **public facade** that the widget state attaches to.
- The widget state calls `controller._attach(...)` in `initState` and `controller._detach()` in `dispose`.
- The `_attach` method receives references to the internal `FrameController`, `FrameCacheManager`, `FrameLoader`, `ScrollPosition`, `PreloadStrategy`, and the widget's `frameCount`.
- `jumpToFrame` and `jumpToProgress` need access to the ancestor `ScrollPosition` to animate the scroll offset. The widget state must resolve and provide this.
- The controller stores a weak reference to the state (or a typed callback interface) to avoid holding the state alive.

**Attach/Detach Pattern:**

```dart
// Internal, called by _ScrollSequenceState
void _attach({
  required FrameController frameController,
  required FrameCacheManager cacheManager,
  required FrameLoader loader,
  required PreloadStrategy strategy,
  required int frameCount,
  required _ScrollSequenceStateAccessor accessor,
});

void _detach();
```

Where `_ScrollSequenceStateAccessor` is a lightweight interface:

```dart
abstract class _ScrollSequenceStateAccessor {
  ScrollPosition? get scrollPosition;
  double get scrollExtent;
  bool get isPinned;
}
```

**Jump Methods:**

- `jumpToFrame(int frame)` calculates the target progress (`frame / (frameCount - 1)`), then calls `jumpToProgress(targetProgress)`.
- `jumpToProgress(double target)` determines the required scroll offset:
  - For **pinned mode**: The widget top offset in the scroll view + `target * scrollExtent`. Use `scrollPosition.animateTo(...)` with the provided `duration` and `Curves.easeInOut`.
  - For **non-pinned mode**: Similar calculation using the viewport-relative progress model from `ScrollProgressTracker.calculateProgress`.
- Both methods assert the controller is attached (throw `StateError` if not).

**State Sync (Bidirectional):**

- **Widget -> Controller:** The existing `_onFrameChanged` listener in `_ScrollSequenceState` calls `controller._updateState(currentFrame, progress, loadedCount)` on every frame change.
- **Controller -> Widget:** `jumpToFrame/Progress` animates the `ScrollPosition`, which triggers scroll notifications, which the widget handles normally through its existing progress tracking.

**Loading state:**

- `loadedFrameCount` reads `_cacheManager.length`.
- `isFullyLoaded` is `_cacheManager.length >= frameCount`.
- `loadingProgress` is `_cacheManager.length / frameCount`.
- These update reactively because `_updateState` calls `notifyListeners()`.

**preloadAll / clearCache:**

- `preloadAll()` uses the eager strategy to load all frames: loops 0..frameCount-1, calling `_cacheManager.loadFrame(i, _loader)` for each. Returns a `Future<void>`.
- `clearCache()` calls `_cacheManager.clearAll()` and notifies listeners. The widget rebuilds showing placeholder/loading state.

#### 1.2 Wire controller into ScrollSequence widget

**File:** `packages/fifty_scroll_sequence/lib/src/widgets/scroll_sequence_widget.dart`

**Changes:**

1. Add `final ScrollSequenceController? controller;` parameter to `ScrollSequence` and all three constructors.
2. In `_ScrollSequenceState.initState()`, after creating internal components, call `widget.controller?._attach(...)`.
3. In `_ScrollSequenceState.dispose()`, call `widget.controller?._detach()` before disposing internals.
4. In `_onFrameChanged()`, add `widget.controller?._updateState(...)`.
5. Implement `_ScrollSequenceStateAccessor` on the state class:
   - `scrollPosition` returns `Scrollable.maybeOf(context)?.position`.
   - `scrollExtent` returns `widget.scrollExtent`.
   - `isPinned` returns `widget.pin`.

**Backward Compatibility:**

- `controller` is optional and nullable. When null, behavior is identical to current implementation.
- No breaking API changes.

#### 1.3 Update barrel export

**File:** `packages/fifty_scroll_sequence/lib/src/widgets/widgets.dart`

Add: `export 'scroll_sequence_controller.dart';`

**Dependencies Between Tasks:** 1.1 must complete before 1.2. 1.3 depends on 1.1.

---

### Phase 2: SliverScrollSequence (Task 5)

#### 2.1 Create `SliverScrollSequence` widget

**File:** `packages/fifty_scroll_sequence/lib/src/widgets/sliver_scroll_sequence.dart`

**Design:**

The `SliverScrollSequence` is a convenience widget that wraps the scroll sequence in a `SliverPersistentHeader` for use inside `CustomScrollView`.

**Class signature:**

```dart
class SliverScrollSequence extends StatelessWidget {
  const SliverScrollSequence({
    required this.frameCount,
    required this.framePath,
    this.scrollExtent = 3000.0,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.loadingBuilder,
    this.onFrameChanged,
    this.indexPadWidth,
    this.indexOffset = 0,
    this.maxCacheSize = 100,
    this.builder,
    this.lerpFactor = 0.15,
    this.curve = Curves.linear,
    this.loader,
    this.strategy,
    this.controller,
    this.pinned = true,
    super.key,
  });

  // ... same parameters as ScrollSequence ...
  // plus:
  final bool pinned; // whether SliverPersistentHeader is pinned
  final ScrollSequenceController? controller;
}
```

**Implementation approach:**

The widget builds a `SliverPersistentHeader` with a custom delegate `_ScrollSequencePersistentDelegate`:

```dart
@override
Widget build(BuildContext context) {
  final viewportHeight = MediaQuery.sizeOf(context).height;
  return SliverPersistentHeader(
    pinned: pinned,
    delegate: _ScrollSequencePersistentDelegate(
      maxExtent: viewportHeight + scrollExtent,
      minExtent: pinned ? viewportHeight : 0,
      // ... all frame params
    ),
  );
}
```

**Delegate design (`_ScrollSequencePersistentDelegate`):**

```dart
class _ScrollSequencePersistentDelegate extends SliverPersistentHeaderDelegate {
  // Receives all frame sequence params

  @override
  double get maxExtent => _maxExtent;

  @override
  double get minExtent => _minExtent;

  @override
  bool shouldRebuild(covariant _ScrollSequencePersistentDelegate oldDelegate) {
    return oldDelegate.frameCount != frameCount || ...;
  }

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // shrinkOffset goes from 0 (fully expanded) to maxExtent - minExtent
    // Calculate progress from shrinkOffset
    final progress = (shrinkOffset / scrollExtent).clamp(0.0, 1.0);

    // Build the frame sequence content
    return _SliverScrollSequenceContent(
      progress: progress,
      // ... all frame params
    );
  }
}
```

**`_SliverScrollSequenceContent`** is a `StatefulWidget` with `SingleTickerProviderStateMixin` that:
- Creates its own `FrameLoader`, `FrameCacheManager`, `FrameController`, `PreloadStrategy`
- Receives `progress` from the delegate's `build` method and feeds it into `FrameController.updateFromProgress()`
- Handles loading and rendering identically to `_ScrollSequenceState._buildFrameContent()`
- Attaches/detaches the optional `ScrollSequenceController`

**Why a StatefulWidget inside the delegate:** The delegate's `build` is called every frame during scroll. We need a stateful widget to hold the cache, ticker, and controller lifecycle. The delegate passes the shrinkOffset-derived progress down.

**Alternative approach (simpler):** Instead of reimplementing the internals, we could use the existing `ScrollSequence` widget with `pin: false` inside the delegate, but this would not correctly receive progress from `shrinkOffset`. The delegate-based approach is cleaner because `SliverPersistentHeader` already handles the pinning mechanics -- we just need to map `shrinkOffset` to progress.

#### 2.2 Update barrel export

**File:** `packages/fifty_scroll_sequence/lib/src/widgets/widgets.dart`

Add: `export 'sliver_scroll_sequence.dart';`

**Dependencies:** Phase 1 must be complete (controller integration). Phase 2 depends on the controller's `_attach` API for sliver support.

---

### Phase 3: Example App (Tasks 6-10)

#### 3.1 App Structure

The example app follows the ecosystem pattern (tactical_grid) but is much simpler -- no GetX DI or Actions layer needed since this is a stateless demo.

**Simplified approach for example app:** Since this is a package demo (not a production app), we can use a lighter version of MVVM+Actions:
- `GetMaterialApp` for routing (ecosystem convention)
- Simple `StatelessWidget` / `StatefulWidget` pages (no ViewModels or Actions needed -- the demos are self-contained)
- FDL components for styling

```
apps/scroll_sequence_example/
  pubspec.yaml
  lib/
    main.dart                                    # Entry point
    app/
      app.dart                                   # GetMaterialApp shell
    core/
      routes/
        route_manager.dart                       # 4 routes: menu, basic, pinned, multi
      bindings/
        initial_bindings.dart                    # Empty (no DI needed for demos)
      utils/
        frame_generator.dart                     # Procedural gradient frame CustomPainter
    features/
      menu/
        views/
          menu_page.dart                         # Menu with 3 demo buttons
      basic/
        views/
          basic_page.dart                        # Simplest ScrollSequence usage
      pinned/
        views/
          pinned_page.dart                       # Pinned with overlays + controller
      multi/
        views/
          multi_sequence_page.dart               # Two independent sequences
  assets/
    frames/                                      # 20 procedural gradient PNGs
```

#### 3.2 pubspec.yaml

**File:** `apps/scroll_sequence_example/pubspec.yaml`

```yaml
name: scroll_sequence_example
description: Example app for fifty_scroll_sequence
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.9.2 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  fifty_scroll_sequence:
    path: ../../packages/fifty_scroll_sequence
  fifty_tokens:
    path: ../../packages/fifty_tokens
  fifty_theme:
    path: ../../packages/fifty_theme
  fifty_ui:
    path: ../../packages/fifty_ui
  get: ^4.6.6

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/frames/
```

#### 3.3 Sample Frame Generation Strategy

**File:** `apps/scroll_sequence_example/lib/core/utils/frame_generator.dart`

Instead of bundling real image assets (which bloat the repo), create a utility class that generates frames procedurally at runtime. This avoids any asset files.

**Approach:** Use `CustomPainter` + `PictureRecorder` to generate `ui.Image` objects directly. Create a custom `FrameLoader` implementation that generates gradient frames (hue rotation 0-360 across frameCount).

```dart
class GeneratedFrameLoader extends FrameLoader {
  GeneratedFrameLoader({required this.frameCount, this.width = 320, this.height = 180});

  final int frameCount;
  final int width;
  final int height;

  @override
  Future<ui.Image> loadFrame(int index) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()));

    // HSL hue rotation: 0 -> 360 across frames
    final hue = (index / (frameCount - 1)) * 360.0;
    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(width.toDouble(), height.toDouble()),
        [HSLColor.fromAHSL(1, hue, 0.8, 0.5).toColor(), HSLColor.fromAHSL(1, (hue + 60) % 360, 0.8, 0.3).toColor()],
      );
    canvas.drawRect(Rect.fromLTWH(0, 0, width.toDouble(), height.toDouble()), paint);

    // Frame number overlay
    final textPainter = TextPainter(
      text: TextSpan(text: '${index + 1}/$frameCount', style: ...),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(width / 2 - textPainter.width / 2, height / 2 - textPainter.height / 2));

    final picture = recorder.endRecording();
    return picture.toImage(width, height);
  }

  @override
  String resolveFramePath(int index) => 'generated_frame_$index';

  @override
  void dispose() {}
}
```

This means the example app does NOT need any files in `assets/frames/` -- remove that from pubspec.yaml. All frames are generated in-memory.

**Update pubspec.yaml:** Remove `assets:` section since no real assets are needed.

#### 3.4 main.dart

**File:** `apps/scroll_sequence_example/lib/main.dart`

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ScrollSequenceExampleApp());
}
```

#### 3.5 App Shell

**File:** `apps/scroll_sequence_example/lib/app/app.dart`

Standard `GetMaterialApp` with FiftyTheme dark mode, no loader overlay (demos are synchronous), `initialRoute: '/'`.

#### 3.6 Route Manager

**File:** `apps/scroll_sequence_example/lib/core/routes/route_manager.dart`

Four routes:
- `/` -- MenuPage
- `/basic` -- BasicPage
- `/pinned` -- PinnedPage
- `/multi` -- MultiSequencePage

No bindings needed (no DI for demos).

#### 3.7 Menu Page

**File:** `apps/scroll_sequence_example/lib/features/menu/views/menu_page.dart`

Layout (following tactical_grid pattern):
- Title: "SCROLL" / "SEQUENCE" in FiftyTypography display
- Subtitle: "A FIFTY SHOWCASE"
- Three FiftyButton links: BASIC DEMO, PINNED DEMO, MULTI DEMO
- Version label at bottom

#### 3.8 Basic Demo Page

**File:** `apps/scroll_sequence_example/lib/features/basic/views/basic_page.dart`

Demonstrates the simplest `ScrollSequence` usage:

```dart
SingleChildScrollView(
  child: Column(
    children: [
      SizedBox(height: 200), // lead-in
      ScrollSequence(
        frameCount: 60,
        framePath: '', // unused, custom loader
        loader: GeneratedFrameLoader(frameCount: 60),
        scrollExtent: 2000,
        pin: false,
        fit: BoxFit.cover,
      ),
      SizedBox(height: 500), // trail-out
    ],
  ),
)
```

With an AppBar showing back button and title "BASIC DEMO".

#### 3.9 Pinned Demo Page

**File:** `apps/scroll_sequence_example/lib/features/pinned/views/pinned_page.dart`

Demonstrates pinned mode with:
- `ScrollSequenceController` for programmatic control
- `builder` for frame/progress overlay text
- `onFrameChanged` callback
- Bottom controls: "Jump to Start", "Jump to 50%", "Jump to End" buttons
- `loadingBuilder` showing loading progress

```dart
class PinnedPage extends StatefulWidget { ... }

class _PinnedPageState extends State<PinnedPage> {
  final _controller = ScrollSequenceController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('PINNED DEMO')),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 200),
                ScrollSequence(
                  frameCount: 120,
                  framePath: '',
                  loader: GeneratedFrameLoader(frameCount: 120),
                  scrollExtent: 4000,
                  pin: true,
                  controller: _controller,
                  builder: (context, frameIndex, progress, child) {
                    return Stack(
                      children: [
                        child,
                        Positioned(
                          bottom: 16, left: 16,
                          child: Text('Frame $frameIndex / ${(progress * 100).toInt()}%'),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 500),
              ],
            ),
          ),
          // Bottom control bar
          Positioned(
            bottom: 0, left: 0, right: 0,
            child: _ControlBar(controller: _controller),
          ),
        ],
      ),
    );
  }
}
```

#### 3.10 Multi-Sequence Demo Page

**File:** `apps/scroll_sequence_example/lib/features/multi/views/multi_sequence_page.dart`

Two independent `ScrollSequence` widgets on the same page, each with its own `GeneratedFrameLoader` (different frame counts or gradient styles):

```dart
SingleChildScrollView(
  child: Column(
    children: [
      SizedBox(height: 100),
      Text('SEQUENCE 1'),
      ScrollSequence(
        frameCount: 40,
        framePath: '',
        loader: GeneratedFrameLoader(frameCount: 40, width: 320, height: 180),
        scrollExtent: 1500,
        pin: true,
      ),
      SizedBox(height: 200),
      Text('SEQUENCE 2'),
      ScrollSequence(
        frameCount: 60,
        framePath: '',
        loader: GeneratedFrameLoader(frameCount: 60, width: 320, height: 240),
        scrollExtent: 2000,
        pin: true,
      ),
      SizedBox(height: 500),
    ],
  ),
)
```

**Dependencies:** Phase 3 depends on Phase 1 (controller). Phase 2 (sliver) is independent but the example app could optionally showcase it.

---

### Phase 4: Tests & README (Tasks 11-15)

#### 4.1 ScrollSequenceController Unit Tests

**File:** `packages/fifty_scroll_sequence/test/scroll_sequence_controller_test.dart`

**Test Groups:**

1. **Initial state**
   - currentFrame == 0, progress == 0.0, loadedFrameCount == 0
   - isFullyLoaded == false
   - loadingProgress == 0.0

2. **Attach/Detach**
   - Throws StateError when calling jumpToFrame without attach
   - After attach, state reflects internal controller state
   - After detach, throws StateError again

3. **State sync (widget -> controller)**
   - When `_updateState` called, controller reflects new values
   - `notifyListeners` is called (test via listener count)

4. **jumpToFrame**
   - Calculates correct progress from frame index
   - Clamps to valid range (0, frameCount-1)
   - Calls `scrollPosition.animateTo(...)` with correct offset

5. **jumpToProgress**
   - Clamps to 0.0-1.0
   - Calls `scrollPosition.animateTo(...)` with correct offset
   - Duration parameter is respected

6. **preloadAll**
   - Loads all frames sequentially
   - Updates loadedFrameCount after completion
   - isFullyLoaded returns true

7. **clearCache**
   - Calls cacheManager.clearAll()
   - loadedFrameCount returns 0
   - isFullyLoaded returns false

**Test Helpers:** Use `FakeFrameLoader` from existing test pattern (PictureRecorder-based 1x1 images), `FakeTickerProvider`, and mock `ScrollPosition`.

#### 4.2 SliverScrollSequence Widget Tests

**File:** `packages/fifty_scroll_sequence/test/sliver_scroll_sequence_test.dart`

**Test Groups:**

1. **Renders inside CustomScrollView**
   - `pumpWidget` with `CustomScrollView(slivers: [SliverScrollSequence(...)])`
   - Verify no errors, finds RawImage after loading

2. **Pinning behavior**
   - Scroll past the sliver, verify it stays pinned (visible at top)
   - Verify progress updates as shrinkOffset changes

3. **Works alongside other slivers**
   - `CustomScrollView` with `SliverAppBar` + `SliverScrollSequence` + `SliverList`
   - Scroll through, verify all render correctly

4. **Controller attachment**
   - Attach controller, verify state updates during scroll

**Test approach:** Use `tester.pumpWidget(...)` with a `CustomScrollView` containing the sliver. Use `tester.drag(...)` to simulate scrolling. Use `FakeFrameLoader` to avoid real asset loading.

#### 4.3 ScrollSequence Widget Tests

**File:** `packages/fifty_scroll_sequence/test/scroll_sequence_widget_test.dart`

**Test Groups:**

1. **Renders without errors**
   - Basic construction with FakeFrameLoader
   - Shows placeholder during initial load
   - Shows frame after loading

2. **Scroll updates frame**
   - Wrap in `SingleChildScrollView`, drag, verify `onFrameChanged` called

3. **Pinned mode pins correctly**
   - Scroll, verify widget stays visible (pinned phase)

4. **Controller integration**
   - Attach controller, verify state syncs
   - Call jumpToFrame, verify scroll position changes (if feasible in widget tests)

5. **Builder overlay**
   - Provide builder, verify overlay widgets appear

6. **Loading builder**
   - Provide loadingBuilder, verify it receives progress values

#### 4.4 Expand Existing Test Coverage

**Enhancements to existing test files (no new files):**

- `frame_cache_manager_test.dart`: Add tests for `estimatedMemoryBytes`, edge case with maxCacheSize=1
- `frame_controller_test.dart`: Add tests for all three curves (`easeIn`, `easeOut`, `easeInOut`), boundary conditions (frameCount=1, progress at exact 0.0 and 1.0)
- `preload_strategy_test.dart`: Add progressive strategy edge case (keyframeCount > totalFrames)

#### 4.5 README

**File:** `packages/fifty_scroll_sequence/README.md`

**Sections:**

1. **Hero Section**
   - Package name + tagline
   - Feature badges (pub.dev ready)
   - Placeholder for demo GIF

2. **Features**
   - Scroll-driven image sequences
   - Pinned (sticky) and non-pinned modes
   - Sliver support for CustomScrollView
   - Programmatic control via ScrollSequenceController
   - 3 preload strategies (eager, chunked, progressive)
   - Network loading with disk caching
   - Sprite sheet support
   - LRU cache with GPU texture disposal
   - Smooth ticker-based frame interpolation

3. **Installation**
   - pubspec.yaml dependency
   - Import statement

4. **Quick Start**
   - Minimal example (5 lines)
   - Pinned example with builder
   - Controller example
   - Sliver example

5. **Frame Preparation Guide**
   - ffmpeg command to extract frames from video
   - Recommended resolution and format (WebP)
   - Naming convention

6. **API Reference**
   - ScrollSequence (all parameters)
   - ScrollSequence.network()
   - ScrollSequence.spriteSheet()
   - SliverScrollSequence
   - ScrollSequenceController
   - PreloadStrategy (eager/chunked/progressive)

7. **Advanced Usage**
   - Custom FrameLoader implementation
   - Strategy selection guide
   - Multiple sequences on one page

8. **Performance Tips**
   - Use WebP format (smallest size)
   - Use chunked strategy for >100 frames
   - Set appropriate maxCacheSize
   - Dispose controller in widget dispose

9. **Example App**
   - Link to example app
   - How to run

---

## Testing Strategy

### Unit Tests (package)
| Test File | Target | Key Scenarios |
|-----------|--------|---------------|
| `scroll_sequence_controller_test.dart` | ScrollSequenceController | Attach/detach, state sync, jump methods, preloadAll, clearCache |
| `frame_cache_manager_test.dart` | Existing + additions | estimatedMemoryBytes, maxCacheSize=1 |
| `frame_controller_test.dart` | Existing + additions | All curves, frameCount=1, exact boundaries |
| `preload_strategy_test.dart` | Existing + additions | Progressive edge cases |

### Widget Tests (package)
| Test File | Target | Key Scenarios |
|-----------|--------|---------------|
| `scroll_sequence_widget_test.dart` | ScrollSequence | Render, scroll, pin, controller, builder, loading |
| `sliver_scroll_sequence_test.dart` | SliverScrollSequence | Render in CustomScrollView, pin, other slivers |

### Validation
- `flutter analyze` on package: zero issues
- `flutter analyze` on example app: zero issues
- `flutter test` on package: all tests pass (existing 109 + new ~40-50 = ~150+ total)

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| ScrollPosition animation in jumpTo may conflict with user scrolling | Medium | Medium | Gate jump calls: if user is actively scrolling, queue the jump or ignore. Document this limitation. |
| SliverPersistentHeader delegate rebuild frequency causing performance issues | Low | High | The delegate's `build` is called every frame during scroll. Ensure the StatefulWidget inside only rebuilds when progress actually changes (use `didUpdateWidget` check). |
| Widget test flakiness with scroll position + async frame loading | Medium | Low | Use `FakeFrameLoader` with instant resolution, `tester.pumpAndSettle()` after each scroll drag. |
| GeneratedFrameLoader performance in example app (generating images on each load call) | Low | Low | Frame generation is very fast (< 1ms per frame for 320x180). Cache handles dedup. |
| Bidirectional sync causing infinite notification loops (controller notifies -> widget updates -> controller notifies) | Medium | High | Use a guard flag `_isUpdatingFromController` to break the cycle. When the widget updates the controller, it sets the flag so the controller's notification does not trigger a widget update. |
| SliverScrollSequence lifecycle: delegate rebuild creates new StatefulWidget keys | Medium | Medium | Use a `GlobalKey` or ensure the StatefulWidget's state is preserved across delegate rebuilds by keeping the same widget type and key. |
| Example app SDK constraint mismatch: package requires `^3.9.2` but example app may use different | Low | Low | Set example app SDK to `>=3.9.2 <4.0.0` to match package. |

---

## Notes

### Key Design Decisions

1. **Controller as facade, not owner:** The controller does NOT own the FrameController or cache. This avoids lifecycle complexity -- the widget state manages creation/disposal of internals. The controller just provides a public API window into them.

2. **No SliverScrollSequence.network() or .spriteSheet():** Keep the sliver widget with a single `loader` parameter. Users pass `NetworkFrameLoader(...)` or `SpriteSheetLoader(...)` directly. This avoids duplicating all three constructor variants.

3. **Procedural frames in example app:** No bundled image assets. The `GeneratedFrameLoader` generates gradient frames at runtime. This keeps the repo clean and demonstrates custom `FrameLoader` usage.

4. **Example app simplicity:** Since this is a package demo, not a production app, we skip the full Actions layer and ViewModels. Simple `StatefulWidget` pages with FDL styling. GetX is only used for routing.

### Implementation Order

```
Phase 1.1 (ScrollSequenceController class)
    |
Phase 1.2 (Wire into ScrollSequence widget)
    |
Phase 1.3 (Update barrel)
    |
    +-- Phase 2.1 (SliverScrollSequence) -- can start after 1.2
    |       |
    |   Phase 2.2 (Update barrel)
    |
    +-- Phase 3 (Example app) -- can start after 1.2
    |       |
    |   Phase 3.1-3.10 (all sequential)
    |
Phase 4.1-4.3 (New tests) -- can start after Phase 1 + 2
Phase 4.4 (Expand existing tests) -- independent
Phase 4.5 (README) -- can start after Phase 1 + 2
Phase 4.6 (analyze + test) -- final validation
```

---

**Created:** 2026-02-26
**Agent:** ARCHITECT
**Brief:** BR-126
