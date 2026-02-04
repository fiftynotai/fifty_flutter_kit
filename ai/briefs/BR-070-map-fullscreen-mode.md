# BR-070: Map Fullscreen Mode

**Type:** Feature
**Priority:** P2 - Medium
**Status:** Ready
**Effort:** S - Small
**Module:** apps/fifty_demo
**Created:** 2026-02-04

---

## Problem

The map demo displays the map in a small 300px height card. Users cannot see the full map layout and have limited navigation space.

---

## Goal

Make the map fill the available screen space for better visibility and navigation.

---

## Context & Inputs

**Current Implementation:**
- `lib/features/map_demo/views/map_demo_page.dart`
- Map widget wrapped in `SizedBox(height: 300)`
- Page uses `SingleChildScrollView` with controls above map

**Desired Behavior:**
- Map fills remaining screen space after controls
- OR fullscreen toggle button to expand map
- Camera controls overlay on map (not above)

---

## Implementation Options

### Option A: Flexible Layout
- Use `Expanded` instead of fixed height
- Controls in collapsed header
- Map takes remaining space

### Option B: Fullscreen Toggle
- Keep current layout as default
- Add "Fullscreen" button
- Opens map in full-screen overlay/page

### Option C: Tab Layout
- Tab 1: Controls
- Tab 2: Fullscreen map

**Recommended:** Option A (simplest, best UX)

---

## Acceptance Criteria

1. [ ] Map fills available screen space
2. [ ] Controls remain accessible
3. [ ] Camera controls work correctly
4. [ ] Responsive on different screen sizes
5. [ ] No scroll issues

---

## Test Plan

### Manual Testing
1. Open map demo
2. Verify map fills screen appropriately
3. Test on different screen sizes
4. Verify controls and camera functions work

---
