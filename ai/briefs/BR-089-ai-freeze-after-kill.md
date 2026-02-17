# BR-089: AI Turn Freezes After Killing a Player Unit

**Type:** Bug Fix
**Priority:** P0-Critical
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** M
**Status:** Done
**Created:** 2026-02-17

---

## Problem

**What's broken or missing?**

The enemy AI turn freezes permanently after killing a player unit. The player cannot interact with the game — no taps, no buttons, no turn timer. The game must be restarted.

**Root Cause:**

The `AnimationQueue._processQueue()` wraps `entry.execute()` in try/catch but leaves `entry.onComplete?.call()` unprotected (line 118). The AI executor's defeat animation `onComplete` callbacks call `controller.removeEntity()` and `controller.removeDecorators()` before `c.complete()`. If either throws (e.g. due to `die()` already removing the component via `RemoveEffect`), the `Completer` orphans and `await c.future` hangs forever — keeping `isExecuting.value = true` and blocking all player input.

The same vulnerable pattern exists in 3 places:
- `_executeAttack` (lines 286-291)
- `_executeAbility` (lines 380-385)
- `_executeMoveAndAttack` (lines 556-561)

**Why does it matter?**

P0 — game-breaking freeze. Player loses their game and must restart.

---

## Goal

**What should happen after this brief is completed?**

1. AI turn completes reliably after killing any player unit
2. `onComplete` exceptions in AnimationQueue are caught and logged (no orphaned Completers)
3. Defeat animation `onComplete` callbacks always call `c.complete()` even if cleanup throws

---

## Context & Inputs

### Affected Modules
- [x] Other: `packages/fifty_map_engine` (AnimationQueue)
- [x] Other: `apps/tactical_grid` (AI turn executor)

### Layers Touched
- [ ] View (UI widgets)
- [x] Service (data layer) — AnimationQueue, AITurnExecutor

### API Changes
- [x] No API changes

### Related Files
- `packages/fifty_map_engine/lib/src/animation/animation_queue.dart` — `_processQueue()` line 118: `entry.onComplete?.call()` outside try/catch
- `apps/tactical_grid/lib/features/battle/services/ai_turn_executor.dart` — defeat animation Completer pattern in 3 methods
- `packages/fifty_map_engine/lib/src/components/base/component.dart` — `die()` uses `RemoveEffect` at 500ms

---

## Constraints

### Architecture Rules
- Must not change game logic, AI decisions, or combat mechanics
- Must follow existing AnimationQueue patterns

### Out of Scope
- AI decision quality or targeting logic
- Changing the `die()` animation timing

---

## Tasks

### Pending
- [ ] Task 1: Wrap `entry.onComplete?.call()` in try/catch in `animation_queue.dart:118`
- [ ] Task 2: Wrap all 3 defeat animation `onComplete` callbacks in try/finally with `c.complete()` in finally block
- [ ] Task 3: Run `flutter test` on both packages
- [ ] Task 4: Manual smoke test — AI kills player unit, verify game continues

### In Progress

### Completed

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] `entry.onComplete?.call()` is wrapped in try/catch in `AnimationQueue._processQueue()`
2. [ ] All 3 defeat animation `onComplete` callbacks use try/finally to guarantee `c.complete()`
3. [ ] `flutter test` passes (all tests green)
4. [ ] AI turn completes normally after killing a player unit

---

## Test Plan

### Automated Tests
- Test that AnimationQueue processes remaining entries even if `onComplete` throws
- Test that AnimationQueue calls queue-level `onComplete` even if entry `onComplete` throws

### Manual Test Cases

#### Test Case 1: AI Kills Player Unit
**Preconditions:** VS AI game, player units in range of AI units
**Steps:**
1. Let AI kill a player unit
2. Verify the turn ends and player can act

**Expected Result:** Game continues after kill
**Status:** [ ] Pass / [ ] Fail

---

**Created:** 2026-02-17
**Last Updated:** 2026-02-17
**Brief Owner:** M
