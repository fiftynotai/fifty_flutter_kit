# BR-129: Scroll Sequence Coffee Showcase Web App

**Type:** Feature
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Fifty.ai
**Status:** Done
**Completed:** 2026-02-27
**Created:** 2026-02-27

---

## Problem

**What's broken or missing?**

The existing `scroll_sequence_example` app uses programmatically generated gradient frames — not real imagery. There's no showcase demonstrating the `fifty_scroll_sequence` package with actual video-extracted frames, which is the primary real-world use case (Apple-style scroll-driven product reveals).

**Why does it matter?**

A polished showcase with real frames proves the package works for production use cases and serves as a reference implementation for consumers of the package.

---

## Goal

**What should happen after this brief is completed?**

A new Flutter web app at `apps/coffee_showcase/` that:
1. Extracts ~120 PNG frames from `coffee.mp4` (5s, 24fps, 960x960) using ffmpeg
2. Uses `fifty_scroll_sequence` to scrub through the coffee animation on scroll
3. Builds and runs as a Flutter web app
4. Looks polished — dark background, centered frame, minimal chrome

---

## Context & Inputs

### Source Material
- **Video:** `~/Downloads/coffee.mp4` — 5.04s, 24fps, 960x960, h264
- **Extraction command:** `ffmpeg -i input.mp4 -vf fps=30 frame_%04d.png`
- **Expected output:** ~120-150 PNG frames at 960x960

### Affected Packages
- `fifty_scroll_sequence` — the package being showcased
- `fifty_tokens` / `fifty_ui` — FDL compliance for any UI chrome

### Layers Touched
- [x] View (UI widgets)
- [ ] Actions
- [ ] ViewModel
- [ ] Service
- [ ] Model

### API Changes
- [x] No API changes

### Dependencies
- `fifty_scroll_sequence` (path dependency)
- `fifty_tokens` (FDL tokens)
- ffmpeg (frame extraction, build-time only)

### Related Files
- `packages/fifty_scroll_sequence/` — the package
- `apps/scroll_sequence_example/` — existing example (generated frames)
- `apps/coffee_showcase/` — new app (this brief)

---

## Constraints

### Architecture Rules
- Frames stored as asset PNGs in the app's `assets/frames/` directory
- Use `ScrollSequence` or `PinnedScrollSection` widget from the package
- FDL tokens for any UI styling (colors, spacing, typography)
- Web-first (Flutter web target)

### Technical Constraints
- Frame extraction at native 24fps (or user-specified 30fps)
- PNG format for lossless quality
- Asset bundle size will be large (~120 PNGs at 960x960) — acceptable for showcase
- Consider WebP conversion to reduce bundle if PNGs are too heavy

### Out of Scope
- Mobile-specific layouts
- Multiple sequences / multi-page app
- Server-side frame loading (all from assets)

---

## Tasks

### Pending
- [ ] Task 1: Extract frames from coffee.mp4 using ffmpeg
- [ ] Task 2: Create Flutter web app scaffold at `apps/coffee_showcase/`
- [ ] Task 3: Add frames to `assets/frames/` and declare in pubspec.yaml
- [ ] Task 4: Build showcase page with ScrollSequence / PinnedScrollSection
- [ ] Task 5: Style with FDL tokens — dark background, centered layout
- [ ] Task 6: Verify `flutter build web` succeeds
- [ ] Task 7: Manual visual verification

---

## Acceptance Criteria

**The feature is complete when:**

1. [ ] `apps/coffee_showcase/` exists as a standalone Flutter web app
2. [ ] Frames extracted from coffee.mp4 are in `assets/frames/`
3. [ ] Scrolling scrubs through the coffee animation smoothly
4. [ ] App builds for web: `flutter build web` passes
5. [ ] `flutter analyze` passes (zero issues)
6. [ ] Visual polish: dark background, centered frame, clean layout

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Scroll Scrubbing
**Steps:**
1. Run `flutter run -d chrome`
2. Scroll down slowly
3. Observe frame animation playing forward
4. Scroll up
5. Observe frame animation reversing

**Expected Result:** Smooth frame-by-frame scrubbing tied to scroll position

#### Test Case 2: Web Build
**Steps:**
1. Run `flutter build web` in `apps/coffee_showcase/`
2. Serve the build output

**Expected Result:** App loads and functions correctly in browser

---

## Delivery

### Code Changes
- [ ] New directory: `apps/coffee_showcase/`
- [ ] New files: Flutter web app scaffold + showcase page
- [ ] New assets: ~120-150 extracted PNG frames

---

## Notes

- The existing `apps/scroll_sequence_example/` uses generated gradient frames — this showcase uses real video frames
- 960x960 is a good web-friendly resolution, no resizing needed
- User specified fps=30 in extraction command; video is 24fps native — using 30 will interpolate slightly more frames (~150)

---

**Created:** 2026-02-27
**Brief Owner:** Fifty.ai
