# UI-007: Map Engine Example App Redesign

**Type:** Feature
**Priority:** P2-Medium
**Effort:** S-Small (1d)
**Status:** Ready
**Created:** 2026-01-21
**Requested By:** Monarch

---

## Problem

The fifty_map_engine example app needs redesign to match the new FDL v2 patterns established in fifty_achievement_engine:

1. Pages may scroll from middle instead of full-page scrolling
2. Overlay popups may have yellow underline text issue (missing Material ancestor)
3. UI may not follow latest FDL token consumption patterns
4. Layout patterns inconsistent with newer examples

---

## Goal

Redesign the example app to:
1. Use `SingleChildScrollView` pattern for full-page scrolling
2. Ensure all overlays have proper Material ancestors
3. Consume FDL tokens directly (FiftyColors, FiftySpacing, FiftyTypography, FiftyRadii)
4. Match visual quality of fifty_achievement_engine example
5. Showcase all map engine features comprehensively

---

## Scope

**Package:** `packages/fifty_map_engine/example/`

**Key Features to Showcase:**
- Map rendering
- Tile layers
- Markers and annotations
- Zoom controls
- Pan gestures
- Location tracking

---

## Acceptance Criteria

- [ ] Full-page scrolling (SingleChildScrollView pattern)
- [ ] No yellow underline text issues
- [ ] FDL v2 token consumption throughout
- [ ] All map features demonstrated
- [ ] Analyzer clean (no errors)
- [ ] Consistent with fifty_achievement_engine example patterns

---

## Workflow State

**Phase:** Not Started
**Active Agent:** None
**Retry Count:** 0

### Agent Log
_(empty - not started)_
