# BR-090: Tactical Grid Settings Page

**Type:** Feature
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-17
**Completed:** 2026-02-17

---

## Problem

**What's broken or missing?**

The Tactical Grid app has a `/settings` route defined in `RouteManager` and a "Settings" button on the menu page, but no settings page is implemented. All game configuration values are hardcoded:

- Audio volumes: Battle BGM (0.4), Menu BGM (0.3), Victory/Defeat BGM (0.5), SFX and Voice channels have no user control
- Turn timer: Fixed 60s duration, 10s warning, 5s critical thresholds
- AI difficulty: Selected per-game in the mode selection sheet, no persistent default
- Theme: Hardcoded to `ThemeMode.dark` in `app.dart`

**Why does it matter?**

Players have no way to customize their experience. Volume preferences, preferred difficulty, and timer settings must be adjustable for a polished game. The menu already has a Settings button that does nothing — broken UX expectation.

---

## Goal

**What should happen after this brief is completed?**

A fully functional settings page accessible from the menu with three sections:

1. **Audio** — Master mute toggle, BGM/SFX/Voice volume sliders with real-time preview
2. **Gameplay** — Default AI difficulty selector, turn timer duration slider, timer warning/critical threshold controls
3. **Display** — Theme mode toggle (dark/light)

All settings persist across app sessions via local storage and are applied globally.

---

## Context & Inputs

### Affected Modules
- [ ] Other: `tactical_grid` app — new `settings` feature module

### Layers Touched
- [x] View (UI widgets — settings page, section widgets)
- [x] Actions (UX orchestration — save/reset actions)
- [x] ViewModel (business logic — settings state management)
- [x] Service (data layer — settings persistence via SharedPreferences or fifty_storage)
- [x] Model (domain objects — settings model)

### API Changes
- [x] No API changes

### Dependencies
- [x] Existing service: `FiftyAudioEngine` for volume control
- [x] Existing service: `TurnTimerService` for timer config
- [x] Existing service: `FiftyTheme` for theme mode switching
- [ ] New package: `shared_preferences` or `fifty_storage` for persistence (check what's already available)

### Related Files

**Existing (to modify):**
- `apps/tactical_grid/lib/core/routes/route_manager.dart` — wire settings route to new page
- `apps/tactical_grid/lib/features/menu/menu_page.dart` — settings button already exists, needs navigation
- `apps/tactical_grid/lib/app/app.dart` — theme mode needs to become reactive (currently hardcoded `ThemeMode.dark`)
- `apps/tactical_grid/lib/features/battle/services/audio_coordinator.dart` — volume setters need to read from settings
- `apps/tactical_grid/lib/features/battle/services/turn_timer_service.dart` — timer config needs to read from settings

**New files to create:**
- `features/settings/settings_bindings.dart` — DI registration
- `features/settings/controllers/settings_view_model.dart` — settings state + persistence
- `features/settings/actions/settings_actions.dart` — save/reset UX orchestration
- `features/settings/views/settings_page.dart` — main settings page
- `features/settings/views/widgets/audio_settings_section.dart` — audio controls
- `features/settings/views/widgets/gameplay_settings_section.dart` — gameplay controls
- `features/settings/views/widgets/display_settings_section.dart` — theme controls
- `features/settings/data/models/settings_model.dart` — settings data class
- `features/settings/data/services/settings_service.dart` — persistence layer

---

## Constraints

### Architecture Rules
- Must follow MVVM + Actions pattern (View → Actions → ViewModel → Service → Model)
- No skipping layers
- Use FDL components (FiftyCard, FiftyButton, FiftyTokens) for all UI
- Consume FiftyTheme for theming — no custom theme classes

### Technical Constraints
- Settings must persist across app restarts (SharedPreferences or fifty_storage)
- Volume changes must apply in real-time (live preview while adjusting sliders)
- Theme change must propagate immediately without app restart
- Settings must have sensible defaults matching current hardcoded values
- Audio volumes: 0.0–1.0 range, default BGM 0.4, SFX 1.0, Voice 1.0
- Turn timer: 15s–120s range, default 60s
- Timer warning: 5s–30s range, default 10s
- Timer critical: 3s–15s range, default 5s

### Out of Scope
- Grid size customization (8x8 is fixed for this brief)
- Unit roster or stat customization
- Online/multiplayer settings
- Keybind/control remapping
- Accessibility options (separate brief if needed)

---

## Tasks

### Pending
- [ ] Task 1: Create settings model with default values and serialization
- [ ] Task 2: Create settings service for persistence (read/write SharedPreferences)
- [ ] Task 3: Create settings ViewModel with reactive state
- [ ] Task 4: Create settings actions (save, reset to defaults)
- [ ] Task 5: Create settings bindings (DI registration)
- [ ] Task 6: Build audio settings section (mute toggle, 3 volume sliders)
- [ ] Task 7: Build gameplay settings section (AI difficulty, timer duration, thresholds)
- [ ] Task 8: Build display settings section (theme mode toggle)
- [ ] Task 9: Build settings page (scaffold, sections, save/reset buttons)
- [ ] Task 10: Wire route — connect settings button in menu to settings page
- [ ] Task 11: Integrate settings into audio coordinator (read volumes from settings)
- [ ] Task 12: Integrate settings into turn timer service (read timer config from settings)
- [ ] Task 13: Integrate settings into app.dart (reactive theme mode)
- [ ] Task 14: Write unit tests for settings ViewModel and service
- [ ] Task 15: Write widget tests for settings page sections
- [ ] Task 16: Manual smoke test on simulator

### In Progress

### Completed

---

## Session State (Tactical - This Brief)

**Current State:** Complete
**Next Steps When Resuming:** N/A — brief done
**Last Updated:** 2026-02-17
**Blockers:** None

---

## Acceptance Criteria

**The feature is complete when:**

1. [ ] Settings page opens from menu "Settings" button
2. [ ] Audio section: Master mute toggle works, BGM/SFX/Voice sliders adjust volume in real-time
3. [ ] Gameplay section: AI difficulty default persists across games, timer duration is configurable
4. [ ] Display section: Theme toggle switches between dark and light mode immediately
5. [ ] All settings persist across app restarts
6. [ ] "Reset to Defaults" restores all settings to hardcoded baseline values
7. [ ] Battle uses persisted settings (audio volumes, timer config, AI difficulty default)
8. [ ] Back navigation returns to menu with settings applied
9. [ ] `flutter analyze` passes (zero issues)
10. [ ] `flutter test` passes (all existing + new tests green)
11. [ ] Manual smoke test performed on iOS simulator

---

## Test Plan

### Automated Tests
- [ ] Unit test: SettingsViewModel — default values, save, load, reset
- [ ] Unit test: SettingsService — persistence read/write round-trip
- [ ] Unit test: SettingsModel — serialization/deserialization
- [ ] Widget test: SettingsPage — renders all three sections
- [ ] Widget test: AudioSettingsSection — slider interaction updates state
- [ ] Widget test: GameplaySettingsSection — difficulty selector, timer slider
- [ ] Widget test: DisplaySettingsSection — theme toggle

### Manual Test Cases

#### Test Case 1: Audio Volume Persistence
**Preconditions:** App freshly launched
**Steps:**
1. Open Settings
2. Adjust BGM volume slider to 0.7
3. Mute SFX
4. Return to menu, start a battle
5. Verify BGM plays at 0.7, SFX is muted
6. Force quit and relaunch app
7. Open Settings — verify sliders show saved values

**Expected Result:** Volumes persist and apply to battle audio

#### Test Case 2: Theme Toggle
**Preconditions:** Default dark mode
**Steps:**
1. Open Settings
2. Toggle theme to Light
3. Verify immediate theme change (no restart)
4. Return to menu — verify light theme persists
5. Relaunch app — verify light theme still active

**Expected Result:** Theme applies instantly and persists

#### Test Case 3: Timer Configuration
**Preconditions:** Default 60s timer
**Steps:**
1. Open Settings
2. Change turn timer to 30s
3. Start a VS AI battle
4. Verify turn timer counts down from 30s
5. Verify warning at correct threshold

**Expected Result:** Battle uses configured timer values

### Regression Checklist
- [ ] Menu navigation still works
- [ ] Battle gameplay unaffected (movement, attack, abilities)
- [ ] Audio mute button in HUD still works alongside settings
- [ ] Achievements page still accessible
- [ ] AI difficulty selection in game mode sheet still works (overrides default)
- [ ] All existing tests pass

---

## Delivery

### Code Changes
- [ ] New files created: ~9 files (settings module: model, service, ViewModel, actions, bindings, page, 3 section widgets)
- [ ] Modified files: ~5 files (route_manager, menu_page, app.dart, audio_coordinator, turn_timer_service)
- [ ] Deleted files: None

### Database Migrations
- [x] N/A — uses SharedPreferences/local storage only

### Configuration Changes
- [ ] No environment variables
- [ ] No feature flags
- [ ] No API config changes

### Documentation Updates
- [ ] README: Add settings section to feature list

### Deployment Notes
- [x] Requires app restart: No (settings apply in real-time)
- [x] Backend changes needed first: No
- [x] Rollback plan: Revert commit — hardcoded values still intact

---

## Notes

- The menu page already has a Settings button (`FiftyButton`) — just needs `onPressed` wired to `RouteManager.toSettings()`
- `BattleAudioCoordinator` already has channel-level volume control via `FiftyAudioEngine` — settings just needs to call `setVolume()` on each channel
- `TurnTimerService.configure()` already accepts `turnDuration` parameter — settings hooks into this
- `FiftyTheme` in `app.dart` currently uses `ThemeMode.dark` — needs to become `Obx(() => ThemeMode)` reactive
- Consider: Should mute button in battle HUD sync with settings mute toggle? (Yes — single source of truth)

---

**Created:** 2026-02-17
**Last Updated:** 2026-02-17
**Brief Owner:** Igris AI
