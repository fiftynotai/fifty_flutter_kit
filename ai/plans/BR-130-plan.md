# Implementation Plan: BR-130

**Complexity:** M (Medium)
**Estimated Duration:** 1-2 days
**Risk Level:** Medium

## Summary

Prepare `fifty_scroll_sequence` for v1.0.0 release: relocate the example app from `apps/` to `packages/fifty_scroll_sequence/example/`, rewrite README to match kit standards (using `fifty_audio_engine` as reference), run WARDEN code review, add screenshots, version bump, and create CHANGELOG v1.0.0 entry.

---

## Current State Analysis

### Package API Surface (28 source files, 14 test files)

The package exports far more than the current README documents. Key gaps:

| Feature | In Code | In README |
|---------|---------|-----------|
| `snapConfig` parameter | YES (SnapConfig, SnapController) | NO |
| `onEnter/onLeave/onEnterBack/onLeaveBack` | YES (ViewportObserver) | NO |
| `scrollDirection` (Axis.horizontal) | YES | NO |
| `ViewportObserver` class | YES (exported) | NO |
| `SnapController` class | YES (exported) | NO |
| `ScrollSequenceLifecycleEvent` enum | YES (exported) | NO |
| `FrameDisplay` class | YES (exported) | NO |
| `PinnedScrollSection` class | YES (exported) | NO |
| `DownloadProgressCallback` typedef | YES (exported) | NO |
| `LoadProgressCallback` typedef | YES (exported) | NO |
| `ScrollSequenceStateAccessor` abstract | YES (exported) | NO |
| `FrameChangedCallback` typedef | YES (exported) | NO |
| `LoadingWidgetBuilder` typedef | YES (exported) | NO |

### Exported Classes (complete inventory)

**Core:** `FrameCacheManager`, `FrameController`, `ScrollProgressTracker`, `SnapController`, `ViewportObserver`
**Loaders:** `FrameLoader` (abstract), `AssetFrameLoader`, `NetworkFrameLoader`, `SpriteSheetLoader`
**Models:** `FrameInfo`, `ScrollSequenceLifecycleEvent`, `ScrollSequenceConfig`, `SnapConfig`
**Strategies:** `PreloadStrategy` (abstract), `EagerPreloadStrategy`, `ChunkedPreloadStrategy`, `ProgressivePreloadStrategy`, `ScrollDirection`
**Utils:** `FramePathResolver`, `LerpUtil`
**Widgets:** `FrameDisplay`, `PinnedScrollSection`, `ScrollSequenceController`, `ScrollSequence`, `SliverScrollSequence`, `ScrollSequenceStateAccessor`

### Example App Structure

- 7 demo pages: Menu, Basic, Pinned, Multi, Snap, Lifecycle, Horizontal
- Dependencies: `fifty_scroll_sequence`, `fifty_theme`, `fifty_tokens`, `fifty_ui`, `get`
- Path deps all use `../../packages/` prefix (needs to change to `../` after move)
- Platform dirs: `ios/` (with Pods), `web/`, NO `android/`, NO `macos/`, NO `linux/`, NO `windows/`
- Uses FDL components (FiftyButton, FiftySpacing, FiftyTypography, FiftyTheme)
- Version label in menu_page.dart hardcoded as `v0.1.0`

### Current README Issues

1. Version references say `0.1.0` (3 places)
2. Missing features: snap, lifecycle callbacks, horizontal, ViewportObserver
3. `ScrollSequence` parameter table is incomplete (missing `snapConfig`, `onEnter`, `onLeave`, `onEnterBack`, `onLeaveBack`, `scrollDirection`)
4. `SliverScrollSequence` parameter table mentions `pinned` but not snap/lifecycle/horizontal params
5. Example app link points to `../../apps/scroll_sequence_example/` (will be wrong after move)
6. Demo list is outdated: only 3 demos listed (basic, pinned, multi); missing snap, lifecycle, horizontal
7. Class overview table has 18 classes but is missing `SnapController`, `ViewportObserver`, `ScrollSequenceLifecycleEvent`, `PinnedScrollSection`, `FrameDisplay`, `ScrollSequenceStateAccessor`
8. `<!-- TODO: Add demo GIF here -->` placeholder still present
9. Architecture diagram is entirely absent
10. No screenshot table (kit standard has one)

---

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `packages/fifty_scroll_sequence/example/` | CREATE (directory) | Entire example app relocated here |
| `packages/fifty_scroll_sequence/example/pubspec.yaml` | CREATE | Copied from apps/ with updated path deps |
| `packages/fifty_scroll_sequence/example/lib/**/*.dart` | CREATE | Copied from apps/ (11 Dart files) |
| `packages/fifty_scroll_sequence/example/web/` | CREATE | Copied from apps/ |
| `packages/fifty_scroll_sequence/example/ios/` | CREATE | Copied from apps/ |
| `packages/fifty_scroll_sequence/example/analysis_options.yaml` | CREATE | Copied from apps/ |
| `packages/fifty_scroll_sequence/example/lib/features/menu/views/menu_page.dart` | MODIFY | Update version label to v1.0.0 |
| `apps/scroll_sequence_example/` | DELETE | Remove after successful copy |
| `packages/fifty_scroll_sequence/pubspec.yaml` | MODIFY | Version 0.1.0 -> 1.0.0 |
| `packages/fifty_scroll_sequence/README.md` | MODIFY | Full rewrite to kit standards |
| `packages/fifty_scroll_sequence/CHANGELOG.md` | MODIFY | Add v1.0.0 entry |
| `packages/fifty_scroll_sequence/screenshots/` | CREATE | Screenshot PNGs from example app |

---

## Implementation Steps

### Phase 1: Relocate Example App

**Goal:** Move example from `apps/scroll_sequence_example/` to `packages/fifty_scroll_sequence/example/` with working dependencies.

1. **Copy the entire example app directory**
   - Copy `apps/scroll_sequence_example/` to `packages/fifty_scroll_sequence/example/`
   - Exclude `.dart_tool/`, `build/`, `.flutter-plugins`, `.flutter-plugins-dependencies`, `pubspec.lock`, `.iml`, `ios/Pods/`, `ios/Flutter/ephemeral/`
   - Include: `lib/`, `web/`, `ios/` (platform scaffolding minus Pods), `pubspec.yaml`, `analysis_options.yaml`

2. **Update path dependencies in `example/pubspec.yaml`**
   - Current paths use `../../packages/{pkg}` prefix
   - New paths should use `../../{pkg}` (relative to `packages/fifty_scroll_sequence/example/`)
   - Specifically:
     ```yaml
     # OLD (from apps/scroll_sequence_example/)
     fifty_scroll_sequence:
       path: ../../packages/fifty_scroll_sequence
     fifty_theme:
       path: ../../packages/fifty_theme
     fifty_tokens:
       path: ../../packages/fifty_tokens
     fifty_ui:
       path: ../../packages/fifty_ui

     # NEW (from packages/fifty_scroll_sequence/example/)
     fifty_scroll_sequence:
       path: ../
     fifty_theme:
       path: ../../fifty_theme
     fifty_tokens:
       path: ../../fifty_tokens
     fifty_ui:
       path: ../../fifty_ui
     ```

3. **Update version label in menu_page.dart**
   - Change `'fifty_scroll_sequence v0.1.0'` to `'fifty_scroll_sequence v1.0.0'`

4. **Verify the example works**
   - `cd packages/fifty_scroll_sequence/example && flutter pub get`
   - `flutter analyze` -- must be zero issues
   - Quick manual `flutter run` smoke test if possible

5. **Delete the old directory**
   - Remove `apps/scroll_sequence_example/` entirely

**Important notes on the move:**
- The iOS project has `Pods/` and build artifacts that should NOT be copied; a fresh `pod install` will regenerate them
- The `.metadata` and `.gitignore` files should be copied
- The `web/` directory with `index.html`, `manifest.json`, and icons should be copied

### Phase 2: WARDEN Code Review

**Goal:** Formal code review on all package source files.

1. **Invoke WARDEN** on `packages/fifty_scroll_sequence/lib/src/`
   - Review all 28 source files across 5 subdirectories
   - Focus areas:
     - Public API documentation completeness (all public classes, methods, parameters)
     - API consistency (naming, parameter ordering)
     - Dead code / unused exports
     - Memory safety (ui.Image disposal in all paths)
     - Error handling (StateError messages, null safety)

2. **Classes to specifically audit:**
   - `ScrollSequenceStateAccessor` -- is this correct to export publicly? Users should not implement it.
   - `FrameDisplay` -- exported but internal-use; verify it belongs in public API
   - `PinnedScrollSection` -- exported but could be useful standalone; verify docs
   - `SnapController` -- exported but only useful via `SnapConfig`; verify docs
   - `ViewportObserver` -- exported but only useful via callbacks; verify docs

3. **Fix any findings** before proceeding to README

### Phase 3: README Rewrite

**Goal:** Complete README rewrite matching `fifty_audio_engine` kit standards, accurately reflecting actual implementation.

**Structure to follow (from fifty_audio_engine pattern):**

```
1. Title + badges
2. Description line
3. Screenshot table (4 screenshots in a row, like audio engine)
4. ---
5. Features (bullet list of actual features)
6. ---
7. Installation (pub + contributor path dep)
8. ---
9. Quick Start (6 examples: minimal, pinned+builder, controller, snap, lifecycle, horizontal)
10. ---
11. Architecture (ASCII tree diagram)
12. Core Components table
13. ---
14. API Reference
    - Class overview table (complete, accurate)
    - ScrollSequence parameter table (complete)
    - ScrollSequence.network() section
    - ScrollSequence.spriteSheet() section
    - SliverScrollSequence section
    - ScrollSequenceController section
    - SnapConfig section (NEW)
    - Lifecycle Callbacks section (NEW)
    - PreloadStrategy section
15. ---
16. Frame Preparation Guide (keep existing, it's good)
17. ---
18. Advanced Usage
    - Custom FrameLoader
    - Horizontal Scrolling (NEW)
    - Strategy Selection Guide
    - Multiple Sequences
19. ---
20. Performance Tips
21. ---
22. Example App section (updated path to example/)
23. ---
24. Version (1.0.0)
25. ---
26. License
```

**Key README content requirements:**

A. **ScrollSequence parameter table must include ALL 22 parameters:**
   - `frameCount`, `framePath`, `scrollExtent`, `fit`, `width`, `height`, `placeholder`, `loadingBuilder`, `onFrameChanged`, `indexPadWidth`, `indexOffset`, `maxCacheSize`, `pin`, `builder`, `lerpFactor`, `curve`, `loader`, `strategy`, `controller`, `snapConfig`, `onEnter`/`onLeave`/`onEnterBack`/`onLeaveBack`, `scrollDirection`

B. **New Quick Start examples needed:**
   - Snap-to-keyframe example (show SnapConfig.everyNFrames)
   - Lifecycle callbacks example (show onEnter/onLeave)
   - Horizontal scrolling example (show scrollDirection: Axis.horizontal)

C. **New API Reference sections needed:**
   - `SnapConfig` -- 3 constructors, parameters, nearestSnapPoint
   - Lifecycle callbacks -- 4 VoidCallbacks on ScrollSequence, ViewportObserver internal behavior
   - Horizontal mode -- Axis.horizontal, how progress calc differs

D. **Class overview table must match actual exports (24 classes/enums/typedefs):**
   Add: `SnapConfig`, `SnapController`, `ViewportObserver`, `ScrollSequenceLifecycleEvent`, `PinnedScrollSection`, `FrameDisplay`, `ScrollSequenceStateAccessor`, `SpriteSheetConfig`
   Remove: none (all listed classes exist)

E. **Architecture diagram:**
   ```
   ScrollSequence / SliverScrollSequence (Widget)
       |
       +-- FrameLoader (abstract)
       |       +-- AssetFrameLoader
       |       +-- NetworkFrameLoader
       |       +-- SpriteSheetLoader
       |
       +-- FrameCacheManager (LRU + dedup)
       |
       +-- FrameController (Ticker + lerp)
       |
       +-- ScrollProgressTracker
       |
       +-- SnapController (opt-in, via SnapConfig)
       |
       +-- ViewportObserver (opt-in, via lifecycle callbacks)
       |
       +-- PinnedScrollSection (pinned mode layout)
       |
       +-- FrameDisplay (RawImage rendering)
       |
       +-- ScrollSequenceController (public facade, opt-in)
   ```

### Phase 4: Screenshots

**Goal:** Capture representative screenshots from the example app.

1. **Run example on iOS Simulator** (or physical device)
2. **Capture 4-6 screenshots** for the README table:
   - Menu page
   - Pinned demo (frame mid-sequence with overlay)
   - Snap demo (showing scene dots)
   - Lifecycle demo (showing event log)
3. **Save to** `packages/fifty_scroll_sequence/screenshots/`
   - Naming: `menu.png`, `pinned_demo.png`, `snap_demo.png`, `lifecycle_demo.png`
   - Format: PNG, reasonable width (~300-400px for README display)
4. **Reference in README** screenshot table matching audio engine pattern:
   ```markdown
   | Menu | Pinned Demo | Snap Demo | Lifecycle Demo |
   |:----:|:-----------:|:---------:|:--------------:|
   | <img src="screenshots/menu.png" width="200"> | ... |
   ```

**Note:** Screenshots require running the app on a device/simulator, which is a manual step. The FORGER can prepare the README with screenshot references and the directory, but actual capture is manual.

### Phase 5: Version Bump and CHANGELOG

**Goal:** Update version to 1.0.0 everywhere and create comprehensive changelog.

1. **Update `packages/fifty_scroll_sequence/pubspec.yaml`**
   - `version: 0.1.0` -> `version: 1.0.0`

2. **Update README version references**
   - Installation block: `fifty_scroll_sequence: ^1.0.0`
   - Version section: `**Current:** 1.0.0`

3. **Write CHANGELOG.md v1.0.0 entry**
   - Must cover ALL features added since 0.1.0:

   ```markdown
   ## [1.0.0] - 2026-02-27

   ### Added
   - Pinned mode with `PinnedScrollSection` for viewport-sticky scrubbing.
   - `SliverScrollSequence` for `CustomScrollView` integration.
   - `ScrollSequenceController` for programmatic jump-to-frame/progress, preloading, and cache management.
   - `NetworkFrameLoader` for HTTP frame loading with disk caching (dart:io HttpClient).
   - `SpriteSheetLoader` with multi-sheet grid extraction and lazy-loaded sheet caching.
   - Three `PreloadStrategy` implementations: eager, chunked (sliding window), progressive (keyframes first).
   - `SnapConfig` with three constructors: explicit points, everyNFrames, scenes.
   - `SnapController` with velocity-based momentum detection for fast snap triggering.
   - Lifecycle callbacks: `onEnter`, `onLeave`, `onEnterBack`, `onLeaveBack` via `ViewportObserver` state machine.
   - Horizontal scrolling via `scrollDirection: Axis.horizontal` parameter.
   - `builder` parameter for reactive overlay widgets.
   - `loadingBuilder` with normalized 0.0-1.0 progress reporting.
   - Strategy-driven cache sizing (eager keeps all frames resident).
   - Direction-aware preloading for chunked and progressive strategies.

   ### Changed
   - Ticker-based frame interpolation with configurable `lerpFactor` and `curve`.
   - LRU cache uses deduplication via in-flight load tracking (Set + Completer).
   - Snap controller uses raw progress (not lerped) to prevent overshoot.
   - Non-pinned mode uses ScrollPosition listener instead of NotificationListener.

   ### Fixed
   - Eager strategy cache eviction when frameCount > maxCacheSize.
   - Snap overshoot caused by lerp lag in progress delta calculation.
   - Non-pinned mode frame updates (NotificationListener architecture bug).
   - Frame centering in pinned mode via Center wrapper.
   ```

---

## Testing Strategy

1. **Existing tests (238+ across 14 test files)** -- must all pass after changes
   - Run: `cd packages/fifty_scroll_sequence && flutter test`
   - Zero failures required

2. **Analyzer** -- must pass on both package and example
   - `cd packages/fifty_scroll_sequence && flutter analyze`
   - `cd packages/fifty_scroll_sequence/example && flutter analyze`

3. **Example app smoke test** -- manual
   - Run example from new location
   - Verify all 7 pages load and function
   - Verify path deps resolve correctly

4. **README validation** -- manual
   - Every class in the API reference table must exist in the exports
   - Every parameter in the ScrollSequence table must match the actual constructor
   - Every code example must use valid Dart that would compile against the current API

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Path deps break after example move | Medium | High | Test `flutter pub get` and `flutter analyze` immediately after move |
| iOS Pods don't regenerate in new location | Low | Medium | Delete Pods/, run `pod install` from new ios/ dir |
| README documents feature that doesn't exist | Medium | High | Cross-reference every claim against actual source code; WARDEN review catches gaps |
| Screenshots require manual device capture | Certain | Low | Prepare README with placeholder references; capture as separate manual step |
| Existing 238 tests break from changes | Low | High | The plan only modifies pubspec/README/CHANGELOG/example, not package source; tests should be unaffected |
| Example uses FDL packages that need specific path structure | Low | Medium | Verify `../../fifty_theme` etc. resolve correctly from new example location |
| `ScrollSequenceStateAccessor` is exported but arguably internal | Medium | Low | WARDEN can flag it; consider hiding with `@internal` annotation or keeping as extension point |
| Version label in menu_page.dart missed during update | Low | Low | Explicitly listed as step in Phase 1 |

---

## Dependency Ordering

```
Phase 1 (Example Move) -- no dependencies, do first
     |
     v
Phase 2 (WARDEN Review) -- needs stable code, may produce source changes
     |
     v
Phase 3 (README Rewrite) -- needs finalized API from WARDEN review
     |
     v
Phase 4 (Screenshots) -- needs working example from Phase 1, README structure from Phase 3
     |
     v
Phase 5 (Version Bump) -- last, after all content is finalized
```

Phase 4 (screenshots) is partially manual and can be done in parallel with Phase 3 once the example is working.

---

## Notes for FORGER

1. **Do NOT copy `.dart_tool/`, `build/`, `pubspec.lock`, `.iml`, `ios/Pods/`, `.flutter-plugins`, `.flutter-plugins-dependencies` into the new location.** These are generated and will be recreated by `flutter pub get` / `pod install`.

2. **The `.gitignore` in the example should exclude Pods/ and build artifacts.** Verify this is the case.

3. **The example app depends on `fifty_theme`, `fifty_tokens`, `fifty_ui`, and `get`.** These are NOT dependencies of the package itself (which has Flutter SDK only). The example's pubspec has its own dependencies.

4. **The README must NOT mention features that don't exist.** Before writing any API documentation, read the actual source file to confirm the class/method/parameter exists and works as described.

5. **The CHANGELOG 0.1.0 entry should be preserved.** Only add the 1.0.0 entry above it.

6. **The `SpriteSheetConfig` class is exported from loaders.dart (via sprite_sheet_loader.dart) but is NOT in the current README class table.** Add it.
