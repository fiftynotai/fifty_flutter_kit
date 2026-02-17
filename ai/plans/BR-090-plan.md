# Implementation Plan: BR-090 — Tactical Grid Settings Page

**Complexity:** M (Medium)
**Risk Level:** Low
**Files affected:** 16 (9 new, 7 modified)
**Phases:** 7

## Critical Discovery

`AudioStorage` (from `fifty_audio_engine`) already persists BGM, SFX, and Voice volumes via `get_storage`. Audio sliders do NOT need a custom persistence layer. Non-audio settings (timer, AI difficulty, theme) need a new `GetStorage` box.

## Implementation Order

1. Phase 1: SettingsModel + SettingsService (data layer)
2. Phase 2: SettingsViewModel (business logic)
3. Phase 3: SettingsActions (UX orchestration)
4. Phase 4: DI + Routing (InitialBindings, main.dart, RouteManager)
5. Phase 5: UI (SettingsPage + 3 section widgets)
6. Phase 6: Integration (app.dart, audio_coordinator, turn_timer, battle_bindings, menu_page)
7. Phase 7: Tests

## Key Decisions

- Use `get_storage` (already a transitive dep) instead of `shared_preferences`
- Use `Get.changeThemeMode()` for instant reactive theme switching
- Audio volumes persist via engine's AudioStorage — no duplication
- SettingsViewModel registered in InitialBindings (permanent, app-wide)
- Remove hardcoded volume overrides from AudioCoordinator and MenuPage
- Make TurnTimerService thresholds configurable (instance fields, not static const)

**Status:** Auto-approved (M complexity, P2 priority)
