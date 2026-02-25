# Fifty Scroll Sequence

[![pub package](https://img.shields.io/pub/v/fifty_scroll_sequence.svg)](https://pub.dev/packages/fifty_scroll_sequence)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

Scroll-driven image sequences for Flutter. Apple-style frame scrubbing mapped to scroll position. Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).

<!-- TODO: Add demo GIF here -->

---

## Features

- **Scroll-driven image sequences** - Frames change as the user scrolls, creating cinematic scrubbing effects
- **Pinned (sticky) mode** - Widget pins to viewport top while scroll runway is consumed
- **Non-pinned mode** - Standard viewport-relative frame mapping
- **Sliver support** - `SliverScrollSequence` for use inside `CustomScrollView`
- **Programmatic control** - `ScrollSequenceController` for jump-to-frame, preload, and cache management
- **3 preload strategies** - Eager (all frames), chunked (sliding window), progressive (keyframes first)
- **Network loading** - `ScrollSequence.network()` with HTTP fetching and disk caching
- **Sprite sheet support** - `ScrollSequence.spriteSheet()` with multi-sheet grid extraction
- **LRU cache** - GPU texture caching with automatic eviction and proper disposal
- **Smooth interpolation** - Ticker-based frame lerping with configurable factor and curve
- **Builder overlay** - Reactive overlay widgets that respond to frame index and progress
- **Loading feedback** - `loadingBuilder` with normalized 0.0-1.0 progress reporting

---

## Installation

```yaml
dependencies:
  fifty_scroll_sequence: ^0.1.0
```

### For Contributors

```yaml
dependencies:
  fifty_scroll_sequence:
    path: ../fifty_scroll_sequence
```

---

## Quick Start

### Minimal Example

```dart
import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';

ScrollSequence(
  frameCount: 120,
  framePath: 'assets/hero/frame_{index}.webp',
  scrollExtent: 3000,
  fit: BoxFit.cover,
)
```

Place inside a `SingleChildScrollView` (or any scrollable ancestor). The widget pins to the viewport top by default and plays through all 120 frames as the user scrolls 3000 pixels.

### Pinned Mode with Builder Overlay

```dart
SingleChildScrollView(
  child: Column(
    children: [
      const SizedBox(height: 500),
      ScrollSequence(
        frameCount: 120,
        framePath: 'assets/hero/frame_{index}.webp',
        scrollExtent: 3000,
        fit: BoxFit.cover,
        lerpFactor: 0.15,
        curve: Curves.easeInOut,
        builder: (context, frameIndex, progress, child) {
          return Stack(
            children: [
              child,
              Positioned(
                bottom: 16,
                left: 16,
                child: Text('Frame $frameIndex / ${(progress * 100).toInt()}%'),
              ),
            ],
          );
        },
      ),
      const SizedBox(height: 500),
    ],
  ),
)
```

### With Controller

```dart
class _MyPageState extends State<MyPage> {
  final _controller = ScrollSequenceController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScrollSequence(
          frameCount: 120,
          framePath: 'assets/hero/frame_{index}.webp',
          scrollExtent: 3000,
          controller: _controller,
        ),
        ElevatedButton(
          onPressed: () => _controller.jumpToFrame(60),
          child: const Text('Jump to frame 60'),
        ),
      ],
    );
  }
}
```

### SliverScrollSequence in CustomScrollView

```dart
CustomScrollView(
  slivers: [
    SliverScrollSequence(
      frameCount: 120,
      framePath: 'assets/hero/frame_{index}.webp',
      scrollExtent: 3000,
      fit: BoxFit.cover,
    ),
    SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => ListTile(title: Text('Item $index')),
        childCount: 50,
      ),
    ),
  ],
)
```

---

## Frame Preparation Guide

### Extracting Frames from Video

Use `ffmpeg` to extract individual frames from a video file:

```bash
# Extract all frames as WebP (recommended format)
ffmpeg -i input.mp4 -vf "fps=30" -c:v libwebp -q:v 80 frames/frame_%04d.webp

# Extract at specific resolution
ffmpeg -i input.mp4 -vf "fps=30,scale=1080:-1" -c:v libwebp -q:v 80 frames/frame_%04d.webp

# Extract specific segment (seconds 5 to 10)
ffmpeg -i input.mp4 -ss 5 -t 5 -vf "fps=30" -c:v libwebp -q:v 80 frames/frame_%04d.webp
```

### Recommended Format

- **Format:** WebP (smallest file size with good quality)
- **Resolution:** Match your target display size (avoid scaling at runtime)
- **Naming:** `frame_{index}.webp` with zero-padded indices (e.g., `frame_0001.webp`)
- **Frame count:** 60-200 frames is typical for a 2-5 second scroll sequence

### Asset Registration

```yaml
# pubspec.yaml
flutter:
  assets:
    - assets/hero/
```

---

## API Reference

### Class Overview

| Class | Description |
|-------|-------------|
| `ScrollSequence` | Main scroll-driven image sequence widget (pinned/non-pinned) |
| `SliverScrollSequence` | Sliver variant for `CustomScrollView` |
| `ScrollSequenceController` | Programmatic control: jump, preload, cache management |
| `FrameLoader` | Abstract base for frame loading (asset, network, sprite, custom) |
| `AssetFrameLoader` | Loads frames from Flutter asset bundle |
| `NetworkFrameLoader` | Loads frames from HTTP URLs with disk caching |
| `SpriteSheetLoader` | Extracts frames from sprite sheet grid images |
| `PreloadStrategy` | Abstract preload strategy with 3 implementations |
| `EagerPreloadStrategy` | Loads all frames upfront |
| `ChunkedPreloadStrategy` | Direction-aware sliding window |
| `ProgressivePreloadStrategy` | Keyframes first, then gap-filling |
| `FrameCacheManager` | LRU cache with GPU texture disposal |
| `FrameController` | Ticker-based progress-to-frame interpolation |
| `ScrollProgressTracker` | Scroll offset to 0.0-1.0 progress mapping |
| `FramePathResolver` | `{index}` placeholder resolution with padding |
| `LerpUtil` | Static lerp and convergence helpers |
| `FrameInfo` | Immutable frame metadata (index, path, dimensions) |
| `ScrollSequenceConfig` | Immutable configuration data class |

### ScrollSequence

The main widget. Place inside any scrollable ancestor.

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `frameCount` | `int` | required | Total frames in the sequence |
| `framePath` | `String` | required | Path pattern with `{index}` placeholder |
| `scrollExtent` | `double` | `3000.0` | Scroll distance for full animation |
| `fit` | `BoxFit` | `BoxFit.cover` | How frames fit the display area |
| `width` | `double?` | `null` | Display width (null = parent width) |
| `height` | `double?` | `null` | Display height (null = parent height) |
| `pin` | `bool` | `true` | Whether to pin at viewport top |
| `placeholder` | `ImageProvider?` | `null` | Placeholder during initial load |
| `loadingBuilder` | `LoadingWidgetBuilder?` | `null` | Loading UI with 0.0-1.0 progress |
| `onFrameChanged` | `FrameChangedCallback?` | `null` | Frame change callback |
| `builder` | `Function?` | `null` | Overlay builder (context, frameIndex, progress, child) |
| `lerpFactor` | `double` | `0.15` | Smoothing factor (1.0 = instant) |
| `curve` | `Curve` | `Curves.linear` | Progress-to-frame curve |
| `loader` | `FrameLoader?` | `null` | Custom frame loader |
| `strategy` | `PreloadStrategy?` | `null` | Preload strategy |
| `controller` | `ScrollSequenceController?` | `null` | Programmatic controller |
| `indexPadWidth` | `int?` | `null` | Zero-pad width override |
| `indexOffset` | `int` | `0` | Frame index offset |
| `maxCacheSize` | `int` | `100` | Maximum cached frames |

### ScrollSequence.network()

Named constructor for network-loaded sequences.

```dart
ScrollSequence.network(
  frameCount: 200,
  frameUrl: 'https://cdn.example.com/hero/frame_{index}.webp',
  cacheDirectory: tempDir.path,
  scrollExtent: 4000,
  headers: {'Authorization': 'Bearer token'},
  onDownloadProgress: (received, total) {
    print('Download: ${received / total * 100}%');
  },
)
```

Defaults to `PreloadStrategy.chunked()` to avoid downloading all frames upfront.

### ScrollSequence.spriteSheet()

Named constructor for sprite-sheet-based sequences.

```dart
ScrollSequence.spriteSheet(
  frameCount: 100,
  sheets: [
    SpriteSheetConfig(
      assetPath: 'assets/sprites/sheet_01.webp',
      columns: 10,
      rows: 10,
      frameWidth: 320,
      frameHeight: 180,
    ),
  ],
  scrollExtent: 3000,
)
```

Multiple sheets are supported for large sequences. Defaults to `PreloadStrategy.chunked()`.

### SliverScrollSequence

Sliver variant for use inside `CustomScrollView`. Wraps the sequence in a `SliverPersistentHeader`.

```dart
SliverScrollSequence(
  frameCount: 120,
  framePath: 'assets/hero/frame_{index}.webp',
  scrollExtent: 3000,
  pinned: true,  // pin to viewport top (default)
)
```

Parameters mirror `ScrollSequence`. The `pinned` parameter controls whether the sliver header pins (default `true`).

### ScrollSequenceController

Programmatic control over the sequence.

```dart
final controller = ScrollSequenceController();

// Read-only state
controller.currentFrame;       // int - current frame index
controller.progress;           // double - 0.0 to 1.0
controller.frameCount;         // int - total frames
controller.isAttached;         // bool - whether attached to widget
controller.isFullyLoaded;      // bool - all frames cached
controller.loadedFrameCount;   // int - cached frame count
controller.loadingProgress;    // double - 0.0 to 1.0

// Commands (throw StateError if not attached)
controller.jumpToFrame(60);                        // animate to frame 60
controller.jumpToFrame(60, duration: Duration(seconds: 1));
controller.jumpToProgress(0.5);                    // animate to 50%
await controller.preloadAll();                     // load all frames
controller.clearCache();                           // dispose all cached textures

// Listeners
controller.addListener(() {
  print('Frame: ${controller.currentFrame}');
});

// Cleanup
controller.dispose();
```

### PreloadStrategy

Three built-in strategies for different use cases:

```dart
// Load all frames upfront (best for small sequences, <50 frames)
const PreloadStrategy.eager()

// Sliding window (best for large sequences, network loading)
const PreloadStrategy.chunked(
  chunkSize: 40,
  preloadAhead: 30,
  preloadBehind: 10,
)

// Keyframes first, then fill gaps (best for preview + detail)
const PreloadStrategy.progressive(
  keyframeCount: 20,
  windowAhead: 5,
  windowBehind: 3,
)
```

| Strategy | Best For | Memory | Initial Load |
|----------|----------|--------|--------------|
| Eager | Small sequences (<50 frames) | High | Slow |
| Chunked | Large sequences, network | Low | Fast |
| Progressive | Preview + progressive detail | Medium | Fast |

---

## Advanced Usage

### Custom FrameLoader

Implement `FrameLoader` for custom frame sources:

```dart
class MyCustomLoader implements FrameLoader {
  @override
  Future<ui.Image> loadFrame(int index) async {
    // Load or generate frame image
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, 320, 180));
    // ... draw frame content ...
    final picture = recorder.endRecording();
    return picture.toImage(320, 180);
  }

  @override
  String resolveFramePath(int index) => 'custom_frame_$index';

  @override
  void dispose() {
    // Clean up resources
  }
}

// Usage
ScrollSequence(
  frameCount: 60,
  framePath: '',  // unused with custom loader
  loader: MyCustomLoader(),
  scrollExtent: 2000,
)
```

### Strategy Selection Guide

| Scenario | Recommended Strategy |
|----------|---------------------|
| Product showcase (<50 frames, local assets) | `PreloadStrategy.eager()` |
| Long cinematic scroll (100+ frames, local) | `PreloadStrategy.chunked()` |
| Network-loaded sequence | `PreloadStrategy.chunked()` |
| Quick preview with progressive detail | `PreloadStrategy.progressive()` |
| Sprite sheet extraction | `PreloadStrategy.chunked()` |

### Multiple Sequences on One Page

Each `ScrollSequence` maintains its own independent cache, loader, and controller:

```dart
SingleChildScrollView(
  child: Column(
    children: [
      ScrollSequence(
        frameCount: 60,
        framePath: 'assets/sequence_a/frame_{index}.webp',
        scrollExtent: 2000,
        pin: true,
      ),
      const SizedBox(height: 200),
      ScrollSequence(
        frameCount: 80,
        framePath: 'assets/sequence_b/frame_{index}.webp',
        scrollExtent: 2500,
        pin: true,
      ),
    ],
  ),
)
```

---

## Performance Tips

- **Use WebP format** - Smallest file size with good quality. Significantly smaller than PNG.
- **Use chunked strategy for >100 frames** - Avoids loading all frames into memory at once.
- **Set appropriate `maxCacheSize`** - Default is 100. Lower for memory-constrained devices.
- **Match frame resolution to display size** - Avoid loading 4K frames for a 300px widget.
- **Dispose controllers** - Always call `controller.dispose()` in your widget's `dispose` method.
- **Use `lerpFactor: 1.0` for instant response** - Disables smoothing if you want pixel-perfect tracking.
- **Pre-extract frames at target resolution** - Runtime scaling wastes GPU cycles.

---

## Example App

See the [example app](../../apps/scroll_sequence_example/) for working demos:

- **Basic demo** - Simplest non-pinned usage
- **Pinned demo** - Pinned mode with controller and overlays
- **Multi-sequence demo** - Two independent sequences on one page

### Running the Example

```bash
cd apps/scroll_sequence_example
flutter run
```

---

## Version

**Current:** 0.1.0

See [CHANGELOG.md](CHANGELOG.md) for release notes.

---

## License

MIT License - see [LICENSE](LICENSE) for details.

Part of [Fifty Flutter Kit](https://github.com/fiftynotai/fifty_flutter_kit).
