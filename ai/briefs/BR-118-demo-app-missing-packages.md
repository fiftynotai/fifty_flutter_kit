# BR-118: Update Demo App with All 16 Packages

**Type:** Feature
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-25

---

## Problem

**What's broken or missing?**

The `fifty_demo` app only integrates 13 of 16 ecosystem packages. Three packages are missing from the demo:

| Missing Package | Type |
|----------------|------|
| `fifty_cache` | TTL-based HTTP response caching |
| `fifty_utils` | DateTime, Color, responsive utilities, async state |
| `fifty_socket` | Phoenix WebSocket with auto-reconnect |

**Why does it matter?**

- The demo app claims to showcase "all packages" but doesn't
- Developers evaluating the ecosystem can't see these 3 packages in action
- `fifty_socket` is the newest package (v0.1.0) and has zero demo coverage
- `fifty_utils` is a foundational package used by many others but has no dedicated demo page

---

## Goal

**What should happen after this brief is completed?**

The `fifty_demo` app integrates all 16 packages with dedicated demo pages for the 3 missing packages:

1. **fifty_cache** — Demo page showing TTL caching in action (cache hit/miss indicators, TTL countdown, cache clear)
2. **fifty_utils** — Demo page showing DateTime extensions, responsive utilities, ApiResponse state machine
3. **fifty_socket** — Demo page showing WebSocket connection, channel join/leave, message send/receive

---

## Context & Inputs

### Affected Modules
- [x] Other: `apps/fifty_demo/`

### Layers Touched
- [x] View (UI widgets)
- [x] ViewModel (business logic)

### API Changes
- [x] No API changes (consumer of existing APIs)

### Dependencies
- [x] Existing service: `fifty_cache` public API
- [x] Existing service: `fifty_utils` public API
- [x] Existing service: `fifty_socket` public API

### Current Demo Pages (13 packages)
- fifty_tokens, fifty_theme, fifty_ui (design system)
- fifty_audio_engine, fifty_speech_engine, fifty_narrative_engine (engines)
- fifty_world_engine, fifty_printing_engine (engines)
- fifty_skill_tree, fifty_achievement_engine (game features)
- fifty_forms, fifty_connectivity, fifty_storage (app features)

### Related Files
- `apps/fifty_demo/pubspec.yaml` — Add 3 missing dependencies
- `apps/fifty_demo/lib/features/` — Add 3 new demo pages
- `apps/fifty_demo/lib/core/routes/` — Register new routes
- `apps/fifty_demo/screenshots/` — Update screenshots after implementation

---

## Constraints

### Architecture Rules
- Follow existing demo app patterns (MVVM + GetX)
- Each demo page should be self-contained and demonstrate key package features
- Use FDL design tokens for all UI chrome
- Demo pages should work without external services where possible

### Technical Constraints
- `fifty_socket` demo may need a WebSocket server endpoint or mock mode
- `fifty_cache` demo should use simulated API calls to show caching behavior
- `fifty_utils` demo should show real outputs (actual DateTime formatting, responsive breakpoints)

### Out of Scope
- Modifying the 13 existing demo pages
- Adding new packages beyond the 3 missing ones
- Backend/server infrastructure

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] `pubspec.yaml` includes all 16 ecosystem packages as dependencies
2. [ ] `fifty_cache` demo page shows caching behavior (hit/miss, TTL, clear)
3. [ ] `fifty_utils` demo page shows DateTime extensions, responsive utils, ApiResponse
4. [ ] `fifty_socket` demo page shows WebSocket connection lifecycle and messaging
5. [ ] All 3 new pages accessible from the demo app navigation
6. [ ] All 3 new pages use FDL design tokens
7. [ ] `flutter analyze` passes (zero issues)
8. [ ] Updated screenshots captured
9. [ ] Demo app packages list/home page reflects 16/16 packages

---

## Test Plan

### Manual Test Cases

#### Test Case 1: Cache Demo
**Steps:**
1. Navigate to cache demo page
2. Trigger a cached request — verify "cache miss" indicator
3. Trigger same request — verify "cache hit" indicator
4. Wait for TTL expiry or tap clear — verify cache reset

#### Test Case 2: Utils Demo
**Steps:**
1. Navigate to utils demo page
2. Verify DateTime extensions show correct output (timeAgo, format)
3. Verify responsive utilities detect current device breakpoint
4. Verify ApiResponse demo shows loading → data → error states

#### Test Case 3: Socket Demo
**Steps:**
1. Navigate to socket demo page
2. Verify connection UI (connect/disconnect, status indicator)
3. If server available: join channel, send message, see response
4. If no server: verify graceful handling with connection status display

---

## Delivery

### Code Changes
- [ ] Modified: `apps/fifty_demo/pubspec.yaml` (add 3 deps)
- [ ] New: `apps/fifty_demo/lib/features/cache_demo/` (cache demo page)
- [ ] New: `apps/fifty_demo/lib/features/utils_demo/` (utils demo page)
- [ ] New: `apps/fifty_demo/lib/features/socket_demo/` (socket demo page)
- [ ] Modified: Route configuration to include new pages

### Documentation Updates
- [ ] Screenshots: Capture updated demo screenshots

---

## Notes

- The demo app home page may need updating to show 16/16 packages instead of current count
- Consider grouping the packages page by domain (Foundation / App / Game) to match README structure
- `fifty_socket` demo could include a toggle for mock mode vs live server connection

---

**Created:** 2026-02-25
**Last Updated:** 2026-02-25
**Brief Owner:** Igris AI
