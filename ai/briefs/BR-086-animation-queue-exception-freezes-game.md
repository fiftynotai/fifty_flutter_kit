# BR-086: Animation Queue Exception Freezes Game After Unit Kill

**Type:** Bug Fix
**Priority:** P1-High
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** M
**Status:** Done
**Created:** 2026-02-16
**Completed:**

---

## Problem

**What's broken or missing?**

After a character is killed, the game stops responding entirely — all characters become unselectable, END TURN is clickable but does nothing, and the game appears frozen.

Root cause: `AnimationQueue._processQueue()` has **no try/catch** around `await entry.execute()`. If any exception is thrown inside a defeat animation's `execute` callback (e.g., `targetComp.die()` throws because the component is already removed from the Flame tree), the exception propagates out of `_processQueue()`, which means:

1. `_isRunning` is **never set back to `false`** (the finally block doesn't exist)
2. `onComplete` is **never called**, so `inputManager.unblock()` never fires
3. The `Completer` in calling code (`defeatCompleter.complete()`) is **never completed**
4. `isAnimating` returns `true` forever

Every subsequent user interaction checks `isAnimating`/`isBlocked` and silently returns, freezing the game.

**Why does it matter?**

The game becomes completely unplayable after any unit death. This is a P1 blocker for the tactical grid game — combat is the core mechanic and kills happen every game.

---

## Goal

**What should happen after this brief is completed?**

1. The animation queue should be resilient to exceptions in animation callbacks
2. `_isRunning` and `inputManager` state should always be cleaned up, even if an animation throws
3. After a unit kill, the game should continue normally — remaining units selectable, turns switch correctly

---

## Context & Inputs

### Affected Modules
- [ ] Other: `packages/fifty_map_engine` (animation queue)

### Layers Touched
- [ ] View (UI widgets)
- [ ] Actions (UX orchestration)
- [ ] ViewModel (business logic)
- [ ] Service (data layer)
- [x] Model (domain objects) — AnimationQueue execution loop

### API Changes
- [x] No API changes

### Dependencies
- [ ] Existing service: Flame component lifecycle

### Related Files
- `packages/fifty_map_engine/lib/src/animation/animation_queue.dart` — `_processQueue()` (lines 103-117)
- `apps/tactical_grid/lib/features/battle/actions/battle_actions.dart` — defeat animation queueing (lines 395-411)
- `apps/tactical_grid/lib/features/battle/actions/ai_turn_executor.dart` — AI defeat animation (lines 279-294)

---

## Constraints

### Architecture Rules
- Must not change animation execution semantics — animations should still run sequentially
- Must not swallow exceptions silently — log them for debugging
- `onComplete` for each entry should still fire even if `execute` throws

### Technical Constraints
- `_processQueue` is an async method that processes entries sequentially via `while` loop
- `_isRunning` gates whether new animations can start
- `onStart`/`onComplete` callbacks control `inputManager.block()`/`unblock()`
- The `Completer` pattern in calling code depends on `entry.onComplete` being called

### Out of Scope
- Investigating why `die()` throws (secondary bug — the queue should be resilient regardless)
- Fixing the RenderFlex overflow in unit_info_panel.dart

---

## Tasks

### Pending
- [ ] Task 1: Wrap `await entry.execute()` in try/catch inside `_processQueue()` — log exception, continue processing queue
- [ ] Task 2: Ensure `entry.onComplete?.call()` fires in a finally block (or after catch) so Completers always resolve
- [ ] Task 3: Ensure `_isRunning = false` and `onComplete?.call()` always execute (move to finally block outside the while loop)
- [ ] Task 4: Run `flutter test` on both packages
- [ ] Task 5: Manual smoke test — kill a unit and verify the game continues

### In Progress

### Completed

---

## Session State (Tactical - This Brief)

**Current State:** Not started — investigation complete, fix identified
**Next Steps When Resuming:** Begin with Task 1 (add try/catch/finally to _processQueue)
**Last Updated:** 2026-02-16
**Blockers:** None

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] After killing a unit, the game continues — remaining units are selectable
2. [ ] Turn switching works correctly after a kill
3. [ ] END TURN button works after a kill
4. [ ] Exceptions in animation callbacks are logged but don't freeze the game
5. [ ] `_isRunning` is always reset to `false` after queue processing
6. [ ] `inputManager.unblock()` is always called after queue processing
7. [ ] `flutter test` passes (all tests green)

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Kill Unit and Continue Playing
**Preconditions:** Local 1V1 game, units in attack range
**Steps:**
1. Select a player unit adjacent to an enemy
2. Attack the enemy until it dies
3. Verify the game continues — other units are selectable
4. Verify END TURN works

**Expected Result:** Game continues normally after kill
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: Multiple Kills in One Game
**Preconditions:** Local 1V1 game
**Steps:**
1. Kill multiple enemy units across several turns
2. Verify the game never freezes
3. Verify game over triggers when all enemy units are defeated

**Expected Result:** All kills processed without freeze, game over detected
**Status:** [ ] Pass / [ ] Fail

---

## Notes

The smoking gun is `AnimationQueue._processQueue()` at lines 103-117:

```dart
Future<void> _processQueue() async {
  _isRunning = true;       // SET TO TRUE
  _cancelled = false;
  onStart?.call();         // inputManager.block()

  while (_queue.isNotEmpty && !_cancelled) {
    final entry = _queue.removeAt(0);
    await entry.execute();         // NO TRY/CATCH — exception kills the loop
    entry.onComplete?.call();      // NEVER REACHED on exception
  }

  _isRunning = false;      // NEVER REACHED on exception
  _cancelled = false;
  onComplete?.call();      // inputManager.unblock() NEVER CALLED
}
```

The fix is straightforward: wrap the execute/onComplete in try/catch, and move cleanup to a finally block.

---

**Created:** 2026-02-16
**Last Updated:** 2026-02-16
**Brief Owner:** M
