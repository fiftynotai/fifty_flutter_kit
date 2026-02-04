# BR-068: Duplicate Event Icons Bug

**Type:** Bug Fix
**Priority:** P1 - High
**Status:** Done
**Effort:** S - Small
**Module:** packages/fifty_map_engine
**Created:** 2026-02-04

---

## Problem

Objects with text events show duplicated event icons in the map demo. When an entity has an event with text, the event marker icon appears twice.

---

## Goal

Fix the duplicate event icon rendering so each event displays only once.

---

## Context & Inputs

**Affected Files:**
- `packages/fifty_map_engine/lib/src/components/event_component.dart`
- `packages/fifty_map_engine/lib/src/components/base/component.dart`

**Reproduction:**
1. Run fifty_demo app
2. Navigate to Map Demo
3. Observe entities with events (chests, sentinels)
4. Event icons appear duplicated

**Suspected Cause:**
- Event component may be added twice (once by entity, once standalone)
- OR event icon sprite rendered in addition to event component

---

## Acceptance Criteria

1. [ ] Event icons display only once per event
2. [ ] Event text still visible on marker
3. [ ] All event types (basic, npc, masterOfShadow) work correctly
4. [ ] No regression in entity tap handling

---

## Test Plan

### Manual Testing
1. Load map demo
2. Verify each event marker appears once
3. Tap event markers - verify interaction works
4. Check all event types render correctly

---
