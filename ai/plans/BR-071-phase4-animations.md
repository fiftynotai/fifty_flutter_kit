# BR-071 Priority 4: Animations - Implementation Plan

**Complexity:** L
**Approach:** Stack Overlay (Option A)
**Files:** 6 new, 5 modified

## Architecture

Stack overlay approach: Keep GridView for tile backgrounds, overlay animated unit sprites on a Stack above. AnimationService manages reactive animation state with Completers for async flow control.

## Animation Specs

| Animation | Duration | Key Effect |
|-----------|----------|------------|
| Movement | 300ms | Slide from old tile to new tile (easeInOutCubic) |
| Attack | 400ms | Lunge toward target (200ms) + return (200ms) + impact flash |
| Damage Popup | 800ms | Float upward + fade out + scale overshoot |
| Defeat | 500ms | Fade out + scale down to 0.5 + slight rotation |

## Implementation Order

1. AnimationService (foundation - reactive state + Completers)
2. UnitSpriteWidget (shared renderer extracted from _TileUnitSprite)
3. AnimatedUnitSprite (StatefulWidget with TickerProvider for move/attack/defeat)
4. DamagePopup (floating damage text widget)
5. AnimatedBoardOverlay (Stack overlay compositing animated widgets)
6. BoardWidget modification (hide animating units, add overlay Stack)
7. BattleActions integration (trigger animations, await completion, input guards)
8. AITurnExecutor integration (trigger animations for AI moves/attacks)
9. BattleBindings (register AnimationService)
10. Tests

## Key Design Decisions

- State changes happen IMMEDIATELY, animations are cosmetic overlay
- Start animation FIRST (marks unit as animating), THEN update state
- AnimationService nullable in constructors (like TurnTimerService pattern)
- Player input blocked during animations via isAnimating guard
