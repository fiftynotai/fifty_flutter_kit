# Implementation Plan: BR-129 -- Scroll Sequence Coffee Showcase Web App

**Complexity:** M (Medium)
**Estimated Duration:** 1--2 hours (implementation only; frame extraction is a ~30s manual step)
**Risk Level:** Low

## Summary

Create a polished single-page Flutter web app at `apps/coffee_showcase/` that uses real video-extracted PNG frames from `coffee.mp4` to showcase `fifty_scroll_sequence` with an Apple-style pinned scroll-to-scrub experience on a dark FDL background.

---

## Prerequisites (Manual -- Before Implementation)

### Frame Extraction

Run from the user's machine:

```bash
mkdir -p /Users/m.elamin/StudioProjects/fifty_eco_system/apps/coffee_showcase/assets/frames

ffmpeg -i ~/Downloads/coffee.mp4 -vf fps=30 /Users/m.elamin/StudioProjects/fifty_eco_system/apps/coffee_showcase/assets/frames/frame_%04d.png
```

**Expected output:** ~150 PNG files at 960x960, named `frame_0001.png` through `frame_0151.png` (ffmpeg uses 1-based indexing).

**Important:** After extraction, count the actual number of frames produced:

```bash
ls /Users/m.elamin/StudioProjects/fifty_eco_system/apps/coffee_showcase/assets/frames/ | wc -l
```

This count will be used for `frameCount` in the widget configuration.

### WebP Optimization (Optional -- Recommended)

PNGs at 960x960 will total ~50--100 MB in the asset bundle. Convert to WebP to reduce to ~5--15 MB:

```bash
cd /Users/m.elamin/StudioProjects/fifty_eco_system/apps/coffee_showcase/assets/frames

for f in frame_*.png; do
  cwebp -q 85 "$f" -o "${f%.png}.webp"
done

rm frame_*.png
```

If WebP is used, change the `framePath` from `.png` to `.webp` and the pubspec asset declarations accordingly.

---

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `apps/coffee_showcase/pubspec.yaml` | CREATE | Flutter web app manifest with path deps |
| `apps/coffee_showcase/web/index.html` | CREATE | Web entry point (Flutter default) |
| `apps/coffee_showcase/web/manifest.json` | CREATE | PWA manifest |
| `apps/coffee_showcase/web/favicon.png` | CREATE | Default favicon |
| `apps/coffee_showcase/lib/main.dart` | CREATE | Entry point |
| `apps/coffee_showcase/lib/app/app.dart` | CREATE | GetMaterialApp with FDL dark theme |
| `apps/coffee_showcase/lib/features/showcase/views/showcase_page.dart` | CREATE | Main showcase page with pinned ScrollSequence |
| `apps/coffee_showcase/assets/frames/frame_XXXX.png` | CREATE | Extracted video frames (~150 files) |
| `apps/coffee_showcase/analysis_options.yaml` | CREATE | Linter config |
| `apps/coffee_showcase/.gitignore` | CREATE | Standard Flutter gitignore |
| `apps/coffee_showcase/.metadata` | CREATE | Flutter metadata |

---

## Implementation Steps

### Phase 1: Scaffold Flutter Web App

**Goal:** Bare-bones Flutter web app that compiles and runs.

#### Step 1.1: Create `pubspec.yaml`

Path: `/Users/m.elamin/StudioProjects/fifty_eco_system/apps/coffee_showcase/pubspec.yaml`

```yaml
name: coffee_showcase
description: Coffee scroll sequence showcase -- real video frames
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.9.2 <4.0.0'

dependencies:
  fifty_scroll_sequence:
    path: ../../packages/fifty_scroll_sequence
  fifty_theme:
    path: ../../packages/fifty_theme
  fifty_tokens:
    path: ../../packages/fifty_tokens
  fifty_ui:
    path: ../../packages/fifty_ui
  flutter:
    sdk: flutter

dev_dependencies:
  flutter_lints: ^5.0.0
  flutter_test:
    sdk: flutter

flutter:
  uses-material-design: true
  assets:
    - assets/frames/
```

Key decisions:
- No `get:` dependency -- single-page app does not need routing.
- Use `MaterialApp` directly instead of `GetMaterialApp` -- no routes to manage.
- Asset declaration uses directory wildcard `assets/frames/` to capture all frame files without listing each one.

#### Step 1.2: Create `analysis_options.yaml`

Path: `/Users/m.elamin/StudioProjects/fifty_eco_system/apps/coffee_showcase/analysis_options.yaml`

```yaml
include: package:flutter_lints/flutter.yaml
```

#### Step 1.3: Create `.gitignore`

Path: `/Users/m.elamin/StudioProjects/fifty_eco_system/apps/coffee_showcase/.gitignore`

Standard Flutter `.gitignore` (same as the example app).

#### Step 1.4: Create web shell files

Use `flutter create --platforms=web .` inside the `apps/coffee_showcase/` directory to generate the `web/` folder with `index.html`, `manifest.json`, and `favicon.png`. This ensures correct CanvasKit configuration for the current Flutter SDK version.

Alternatively, copy the `web/` directory from `apps/scroll_sequence_example/` if it exists, or let `flutter create` generate it.

**Important:** Do NOT manually write `index.html` -- the Flutter SDK's template handles CanvasKit loading configuration that varies by SDK version.

#### Step 1.5: Create `lib/main.dart`

Path: `/Users/m.elamin/StudioProjects/fifty_eco_system/apps/coffee_showcase/lib/main.dart`

```dart
/// Coffee Showcase -- Entry Point
///
/// Single-page Flutter web app demonstrating fifty_scroll_sequence
/// with real video-extracted frames from a coffee product animation.
library;

import 'package:flutter/material.dart';

import 'app/app.dart';

/// Main entry point for the Coffee Showcase application.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CoffeeShowcaseApp());
}
```

#### Step 1.6: Create `lib/app/app.dart`

Path: `/Users/m.elamin/StudioProjects/fifty_eco_system/apps/coffee_showcase/lib/app/app.dart`

```dart
/// Coffee Showcase -- App Shell
///
/// MaterialApp with FDL dark theme. Single-page, no routing.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:flutter/material.dart';

import '../features/showcase/views/showcase_page.dart';

/// Root application widget for the coffee showcase.
///
/// Uses [MaterialApp] directly (no GetX routing needed for a single page).
/// Forces dark theme via [FiftyTheme.dark] for the showcase aesthetic.
class CoffeeShowcaseApp extends StatelessWidget {
  /// Creates the coffee showcase app.
  const CoffeeShowcaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee Showcase',
      theme: FiftyTheme.dark(),
      darkTheme: FiftyTheme.dark(),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const ShowcasePage(),
    );
  }
}
```

Key decisions:
- `MaterialApp` not `GetMaterialApp` -- single page, no routes needed.
- This keeps dependencies minimal (no `get:` import).

---

### Phase 2: Build Showcase Page

**Goal:** Polished, full-screen pinned scroll sequence with FDL chrome.

#### Step 2.1: Create `lib/features/showcase/views/showcase_page.dart`

Path: `/Users/m.elamin/StudioProjects/fifty_eco_system/apps/coffee_showcase/lib/features/showcase/views/showcase_page.dart`

**Widget Architecture:**

```
ShowcasePage (StatefulWidget)
  |-- Scaffold (dark bg, no AppBar)
      |-- SingleChildScrollView
          |-- Column
              |-- SizedBox (lead-in spacer: ~300px)
              |-- _HeroTitle ("COFFEE" + "SHOWCASE" display text)
              |-- SizedBox (gap: md)
              |-- _ScrollHint ("SCROLL TO EXPLORE" label)
              |-- SizedBox (gap: xl)
              |-- ScrollSequence (pinned, asset frames)
              |     pin: true
              |     frameCount: <ACTUAL_COUNT>
              |     framePath: 'assets/frames/frame_{index}.png'
              |     indexOffset: 1  (ffmpeg 1-based)
              |     indexPadWidth: 4 (frame_0001.png)
              |     scrollExtent: 5000
              |     fit: BoxFit.contain
              |     lerpFactor: 0.15
              |     controller: _controller
              |     loadingBuilder: progress bar
              |     builder: overlay with frame counter + progress
              |-- SizedBox (trail-out spacer: ~500px)
```

**Key design decisions:**

1. **`indexOffset: 1`** -- ffmpeg outputs `frame_0001.png`, `frame_0002.png`, etc. (1-based). The `AssetFrameLoader` uses `indexOffset` to shift from zero-based internal indexing to 1-based file naming.

2. **`indexPadWidth: 4`** -- ffmpeg `%04d` format produces 4-digit zero-padded names.

3. **`framePath: 'assets/frames/frame_{index}.png'`** -- matches the `frame_%04d.png` output from ffmpeg after index substitution.

4. **`fit: BoxFit.contain`** -- the frames are 960x960 (square). Using `contain` ensures the full frame is visible on any viewport without cropping. Could also use `cover` if edge-to-edge fill is preferred (may crop top/bottom on non-square viewports).

5. **`scrollExtent: 5000`** -- ~150 frames over 5000px gives ~33px per frame, which feels deliberate and controlled. Adjustable.

6. **No AppBar** -- clean full-bleed showcase aesthetic. Title is inline in the scroll content.

7. **`pin: true`** -- the coffee animation pins to the viewport while scrolling, exactly like Apple's product pages.

**Overlay structure (via `builder`):**

```
Stack
  |-- child (the frame image)
  |-- Positioned(bottom-left): frame counter badge
  |     "FRAME 42 / 151"
  |     "27.8%"
  |-- Positioned(bottom-right): scroll progress indicator (thin vertical bar)
```

The overlay should use:
- `FiftyColors.borderDark` for badge background border
- `colorScheme.surface.withValues(alpha: 0.8)` for semi-transparent badge bg
- `FiftyTypography.fontFamily` for text
- `FiftySpacing.*` for all padding/margins

**Loading state (via `loadingBuilder`):**

```
Center
  |-- Column
      |-- FiftyProgressBar(value: progress)
      |-- SizedBox(height: md)
      |-- Text "LOADING 42%"
```

Pattern taken directly from the existing `PinnedPage` in the example app.

**Frame counter state management:**

The `builder` callback provides `frameIndex` and `progress` directly -- no extra state management needed. This is the pattern used by the existing pinned demo.

#### Step 2.2: Constants to extract

Create a private constants section at the top of `ShowcasePage`:

```dart
/// Frame configuration -- update after frame extraction.
static const int _frameCount = 151; // UPDATE: actual count from ffmpeg
static const String _framePath = 'assets/frames/frame_{index}.png';
static const int _indexOffset = 1;
static const int _indexPadWidth = 4;
static const double _scrollExtent = 5000.0;
```

This makes it easy to adjust after counting the actual frame output.

---

### Phase 3: Web-Specific Considerations

#### Step 3.1: Asset Bundle Size

- ~150 PNGs at 960x960 uncompressed: likely 50--100+ MB
- Flutter web bundles assets via `AssetManifest.json` and fetches them on demand
- Assets are NOT embedded in the JS bundle -- they are fetched individually via HTTP
- This means the initial page load is fast; frames load progressively

**Recommendation for the forger:**
- Start with PNG for correctness
- If bundle size is a problem, convert to WebP (see prerequisites section) and change `_framePath` to `.webp`
- The `eager` preload strategy (default) will load all frames on widget init -- this could cause a long initial wait. Consider using `PreloadStrategy.chunked()` or `PreloadStrategy.progressive()` for better perceived performance on web.

#### Step 3.2: CanvasKit vs HTML Renderer

- `dart:ui` image decoding requires CanvasKit renderer (the default on web)
- No special flags needed -- modern Flutter defaults to CanvasKit
- Ensure `web/index.html` uses the SDK-generated template (handled by `flutter create`)

#### Step 3.3: Web Build Verification

After implementation, run:

```bash
cd /Users/m.elamin/StudioProjects/fifty_eco_system/apps/coffee_showcase
flutter analyze
flutter build web
```

---

### Phase 4: Polish and Verification

#### Step 4.1: Visual Polish Checklist

- [ ] Dark background (`colorScheme.surface` from FDL dark theme)
- [ ] No AppBar -- clean full-bleed
- [ ] Title section uses FDL typography tokens (Manrope, uppercase, tight spacing)
- [ ] Frame display centered, `BoxFit.contain`
- [ ] Overlay badge uses FDL spacing, colors, radii
- [ ] Loading state uses `FiftyProgressBar`
- [ ] No hardcoded colors, spacing, or font values
- [ ] Smooth scroll-to-scrub with `lerpFactor: 0.15`

#### Step 4.2: Manual Testing

1. `flutter run -d chrome` from `apps/coffee_showcase/`
2. Scroll down past the title -- sequence should pin
3. Scroll slowly -- frames should scrub forward smoothly
4. Scroll up -- frames should reverse
5. Release scroll -- should hold position (no snap configured)
6. Verify frame counter overlay updates correctly
7. Verify loading progress shows before frames are ready

#### Step 4.3: Build Verification

```bash
cd /Users/m.elamin/StudioProjects/fifty_eco_system/apps/coffee_showcase
flutter analyze   # must pass with zero issues
flutter build web # must succeed
```

---

## File Creation Summary

| # | File | Lines (est.) |
|---|------|-------------|
| 1 | `apps/coffee_showcase/pubspec.yaml` | ~30 |
| 2 | `apps/coffee_showcase/analysis_options.yaml` | ~1 |
| 3 | `apps/coffee_showcase/.gitignore` | ~45 |
| 4 | `apps/coffee_showcase/web/` (via flutter create) | ~50 |
| 5 | `apps/coffee_showcase/lib/main.dart` | ~15 |
| 6 | `apps/coffee_showcase/lib/app/app.dart` | ~30 |
| 7 | `apps/coffee_showcase/lib/features/showcase/views/showcase_page.dart` | ~200 |

**Total new Dart code:** ~245 lines across 3 files (main, app, showcase_page).

---

## Testing Strategy

- **No unit tests** -- this is a pure UI showcase app with no business logic
- **Manual visual verification** -- scroll scrubbing, frame accuracy, loading state
- **Build verification** -- `flutter analyze` + `flutter build web` must pass
- **Browser testing** -- Chrome (primary), optionally Firefox/Safari

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Asset bundle too large for comfortable web loading | Medium | Medium | Use WebP conversion (see prerequisites); use `PreloadStrategy.chunked()` instead of eager |
| ffmpeg frame count differs from expected ~150 | Low | Low | Use `ls | wc -l` to count actual frames; update `_frameCount` constant |
| coffee.mp4 not at expected path | Low | High | Verify file exists at `~/Downloads/coffee.mp4` before extraction |
| CanvasKit issues on older browsers | Low | Low | Modern Flutter default; not a target concern for a showcase app |
| Frame path pattern mismatch (indexOffset/padWidth) | Low | Medium | ffmpeg `%04d` is well-documented; `indexOffset: 1` + `indexPadWidth: 4` matches |
| Missing `get:` dependency if `GetMaterialApp` is used | Low | Low | Plan uses plain `MaterialApp` -- no GetX dependency needed |
| Large number of asset files slows `flutter analyze` | Low | Low | Frames are images, not Dart files -- analyzer does not process them |

---

## Dependency Chain

```
Phase 0 (Manual): Frame extraction via ffmpeg
    |
Phase 1: App scaffold (pubspec, main, app, web shell)
    |
Phase 2: Showcase page (depends on Phase 1 + frames existing)
    |
Phase 3: Web verification (depends on Phase 2)
    |
Phase 4: Polish + manual testing (depends on Phase 3)
```

**Note:** Phase 0 (frame extraction) MUST be completed before the forger can run `flutter build web` or test the app. The forger should verify that `assets/frames/` is populated before attempting to build.

---

## Key API Usage Summary

For quick reference by the forger agent:

```dart
// Core widget -- pinned mode with asset frames
ScrollSequence(
  frameCount: 151,                        // actual count from ffmpeg
  framePath: 'assets/frames/frame_{index}.png',
  indexOffset: 1,                         // ffmpeg 1-based naming
  indexPadWidth: 4,                       // frame_0001.png format
  scrollExtent: 5000,
  pin: true,
  fit: BoxFit.contain,
  lerpFactor: 0.15,
  controller: _controller,
  loadingBuilder: (context, progress) => ...,
  builder: (context, frameIndex, progress, child) => ...,
)
```

```dart
// Controller lifecycle
final _controller = ScrollSequenceController();
// dispose in State.dispose()
```

```dart
// FDL imports
import 'package:fifty_scroll_sequence/fifty_scroll_sequence.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
```
