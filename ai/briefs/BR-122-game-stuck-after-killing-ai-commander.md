# BR-122: Game Stuck After Killing AI Commander

**Type:** Bug Fix
**Priority:** P1-High
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-25

---

## Problem

**What's broken or missing?**

After the player kills the AI commander, the game gets stuck in a loop. The player can only press "End Turn" and the turn immediately switches back to them. The AI never takes its turn despite having units remaining (e.g. a knight).

**User Report:** "When I kill the AI commander the game is stuck and I can't do anything except pressing end turn and the turn automatically switches back to me. The AI had a knight left."

**Root Cause:** When the player kills the AI commander:

1. `checkWinCondition()` returns `GameResult.playerWin` and sets game phase to `gameOver`
2. Player's turn ends, triggering AI turn via `executeAITurn()`
3. In `ai_turn_executor.dart:105-106`:
   ```dart
   if (!_viewModel.isGameOver) {
     _viewModel.endTurn();
   }
   ```
4. Since `isGameOver` is `true`, `endTurn()` is **skipped**
5. Turn state remains stuck on "AI's turn" (`isPlayerTurn = false`)
6. The game-over dialog is supposed to show in the `.then()` callback (`battle_actions.dart:533-536`), but the turn state is inconsistent
7. Player sees "End Turn" button, presses it, which calls `onEndTurn()` → `endTurn()` → switches to player turn → stuck loop

**Why does it matter?**

- Game is completely unplayable after killing the AI commander — the most common win scenario
- No victory screen, no game-over dialog, just an infinite turn loop
- Player must force-quit the app to escape
- This is the primary win condition, so it affects every VS AI game

---

## Goal

**What should happen after this brief is completed?**

When the player kills the AI commander, the game immediately shows the victory dialog. No stuck turns, no infinite loop.

---

## Context & Inputs

### Affected Modules
- [x] Other: `apps/tactical_grid/lib/features/battle/`

### Key Files

**Turn management:**
- `ai_turn_executor.dart:79-112` — `executeAITurn()` method, specifically the `endTurn()` skip at line 105-106
- `battle_actions.dart:525-541` — AI turn trigger and game-over callback in `.then()`

**Win condition:**
- `game_state.dart:195-204` — `checkWinCondition()` checks if commander is dead

### The Stuck State Flow
```
Player kills AI commander
  → checkWinCondition() → playerWin → gameOver = true
  → onEndTurn() triggers AI turn
  → executeAITurn() starts
  → AI gets actions for remaining units
  → Actions execute (or isGameOver check breaks loop)
  → endTurn() SKIPPED (isGameOver is true)
  → Turn stays as "AI turn"
  → .then() callback should show game-over dialog but turn state is inconsistent
  → Player stuck pressing "End Turn" forever
```

### Fix Options

**Option A: Show game-over dialog immediately when win condition is met**
- In `battle_actions.dart`, after `checkWinCondition()` returns `playerWin`, show dialog immediately instead of waiting for AI turn to complete
- Skip AI turn entirely if game is already over

**Option B: Fix the AI executor to handle game-over gracefully**
- In `executeAITurn()`, if `isGameOver` at entry, skip all actions AND ensure the `.then()` callback still fires properly
- Ensure `_handleGameOver(context)` is always called

**Option C: Check win condition before starting AI turn**
- In `onEndTurn()` at `battle_actions.dart:525`, check `isGameOver` BEFORE triggering `executeAITurn()`
- If game is already over, call `_handleGameOver()` directly

Option C is likely the cleanest fix — don't start the AI turn at all if the game is already won.

---

## Constraints

### Architecture Rules
- Don't change win condition logic — it works correctly
- Don't modify the AI service decision-making
- Focus on the turn transition and game-over handling flow

### Out of Scope
- Local 1v1 mode (different flow, may not have same issue)
- Adding new game-over conditions
- AI balancing

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Killing the AI commander shows the victory dialog immediately
2. [ ] No stuck turn loop after killing the AI commander
3. [ ] AI turn is not started if the game is already over
4. [ ] Victory dialog allows player to return to main menu
5. [ ] Works regardless of how many AI units remain when commander dies

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Kill Commander — Victory
**Steps:**
1. Start VS AI game
2. Kill the AI commander (leave other AI units alive)
3. Observe what happens immediately after the kill

**Expected Result:** Victory dialog appears, no turn loop

#### Test Case 2: Kill Last Unit (Commander) — Victory
**Steps:**
1. Start VS AI game
2. Kill all AI units until only commander remains
3. Kill the AI commander

**Expected Result:** Victory dialog appears immediately

---

## Delivery

### Code Changes
- [ ] Modified: `apps/tactical_grid/lib/features/battle/actions/battle_actions.dart` — Add game-over check before triggering AI turn in `onEndTurn()`
- [ ] Modified: `apps/tactical_grid/lib/features/battle/services/ai_turn_executor.dart` — Ensure `executeAITurn()` exits cleanly when game is already over

---

**Created:** 2026-02-25
**Last Updated:** 2026-02-25
**Brief Owner:** Igris AI
