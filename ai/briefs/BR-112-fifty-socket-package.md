# BR-112: Create fifty_socket Package

**Type:** Feature
**Priority:** P1-High
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Partner
**Status:** Done
**Created:** 2026-02-24
**Completed:** 2026-02-24

---

## Problem

**What's broken or missing?**

The Fifty Flutter Kit ecosystem has 15 packages covering design, storage, caching, connectivity, audio, and more — but no WebSocket infrastructure. Every project that needs real-time socket connections must copy-paste the same battle-tested `SocketService` abstract class from `opaala_admin_app_v3/lib/src/infrastructure/websocket/`. This code has been proven in production (KDS real-time order system) but is locked inside one project.

**Why does it matter?**

- Code duplication across projects that need WebSocket support
- No standardized socket infrastructure in the ecosystem
- Production-proven code (~1018 lines) going unused as a reusable asset
- Inconsistent socket implementations across projects
- Missing from the "infrastructure" row of the ecosystem (HTTP caching, storage, connectivity all have packages — sockets don't)

---

## Goal

**What should happen after this brief is completed?**

A new `fifty_socket` package exists in `packages/fifty_socket/` providing:
1. Abstract `SocketService` base class for Phoenix WebSocket connections
2. `ReconnectConfig` — configurable auto-reconnect with exponential backoff
3. `HeartbeatConfig` — ping/pong watchdog for silent disconnect detection
4. Typed error handling (`SocketError`, `SocketErrorType`, `SocketConnectionState`)
5. Channel lifecycle management with auto-restoration on reconnect
6. Subscription session guards to prevent duplicate channel joins
7. Full test suite
8. Published to pub.dev

---

## Context & Inputs

### Source Code

The implementation is extracted from a production codebase — **not written from scratch**.

**Source project:** `/Users/m.elamin/StudioProjects/opaala_admin_app_v3/`

**Source files (copy, then review and adapt):**
- `lib/src/infrastructure/websocket/socket_service.dart` — Abstract base class (~1018 lines)
- `lib/src/infrastructure/websocket/reconnect_config.dart` — Reconnection strategy config
- `lib/src/infrastructure/websocket/heartbeat_config.dart` — Heartbeat monitoring config

**Consumer reference (do NOT copy — for understanding usage pattern only):**
- `lib/src/modules/kds/data/services/kds_socket_service.dart` — Domain socket extending SocketService
- `lib/src/modules/kds/controllers/kds_view_model.dart` — ViewModel consuming socket service
- `lib/src/modules/kds/kds_bindings.dart` — DI registration pattern

### Affected Modules
- [x] Other: New package `packages/fifty_socket/`

### Layers Touched
- [x] Service (data layer) — socket infrastructure

### API Changes
- [x] No API changes

### Dependencies
- [x] Existing package: `phoenix_socket` (Phoenix WebSocket client)
- [x] Existing package: `meta` (for @protected annotations)

### Architecture Decision

**Standalone `fifty_socket`** chosen over combined `fifty_infrastructure` because:
- Matches ecosystem convention (one concern per package)
- Minimal dependency footprint (`phoenix_socket` + `meta` only)
- Independent versioning (socket changes don't affect HTTP/storage consumers)
- Clean pub.dev discoverability (`websocket`, `phoenix`, `realtime` topics)

---

## Constraints

### Architecture Rules
- Package must be protocol-agnostic in its public API where possible
- No app-specific imports (no `AppStorageService`, no `ApiConfig`)
- Subclasses provide URL via `getWebSocketUrl()` — package doesn't dictate auth strategy
- Must follow Fifty ecosystem conventions (barrel exports, doc comments, FDL consumption where applicable)

### Technical Constraints
- Depends on `phoenix_socket` — currently Phoenix-specific
- Must preserve all production-proven behavior from source (reconnect, heartbeat, channel restore)
- No breaking changes to the public API shape that would prevent easy migration from app code

### Out of Scope
- Generic WebSocket support (non-Phoenix) — future enhancement
- UI widgets for socket status (consumers build their own, or future `fifty_connectivity` integration)
- Domain-specific services (like KdsSocketService) — those stay in app code

---

## Tasks

### Pending
- [ ] Task 1: Create package scaffold (`packages/fifty_socket/`, pubspec.yaml, analysis_options, lib/, test/)
- [ ] Task 2: Copy source files from opaala_admin_app_v3 into package structure
- [ ] Task 3: Review and adapt — remove app-specific imports, clean up for public API
- [ ] Task 4: Add barrel export (`lib/fifty_socket.dart`)
- [ ] Task 5: Add README.md with usage example (show how to extend SocketService)
- [ ] Task 6: Write unit tests (connection states, reconnect logic, heartbeat config, channel management)
- [ ] Task 7: Run `flutter analyze` — zero issues
- [ ] Task 8: Run `flutter test` — all green
- [ ] Task 9: Add example/ with minimal consumer service
- [ ] Task 10: Publish to pub.dev

### In Progress
_(None)_

### Completed
_(None)_

---

## Session State (Tactical - This Brief)

**Current State:** COMPLETE — committed dc87f39
**Active Agent:** none
**Next Steps When Resuming:** N/A
**Last Updated:** 2026-02-24
**Blockers:** None

---

## Acceptance Criteria

**The package is complete when:**

1. [ ] `packages/fifty_socket/` exists with proper pubspec.yaml
2. [ ] `SocketService` abstract class is fully functional and documented
3. [ ] `ReconnectConfig` and `HeartbeatConfig` are configurable
4. [ ] `SocketConnectionState`, `SocketError`, `SocketErrorType` are exported
5. [ ] Channel management (join, leave, restore on reconnect) works correctly
6. [ ] Subscription session guards prevent duplicate joins
7. [ ] `forceReconnect()` vs `autoReconnectIfNeeded()` distinction preserved
8. [ ] No app-specific imports (no opaala, no AppStorageService references)
9. [ ] `flutter analyze` passes (zero issues)
10. [ ] `flutter test` passes (all tests green)
11. [ ] README with usage example exists
12. [ ] Barrel export exposes all public API types
13. [ ] Published to pub.dev

---

## Test Plan

### Automated Tests
- [ ] Unit test: ReconnectConfig defaults and custom values
- [ ] Unit test: HeartbeatConfig defaults and timeout calculation (2x ping interval)
- [ ] Unit test: SocketConnectionState transitions
- [ ] Unit test: SocketError creation and toString
- [ ] Unit test: Backoff calculation (linear and exponential)
- [ ] Unit test: Subscription session guard (shouldAllowSubscription/markSubscriptionComplete)

### Manual Test Cases

#### Test Case 1: Extend and Connect
**Preconditions:** Package added to a test app
**Steps:**
1. Create a subclass implementing `getWebSocketUrl()`
2. Call `connect()`
3. Verify state stream emits `connecting` -> `connected`

**Expected Result:** Connection lifecycle works end-to-end

#### Test Case 2: Reconnection
**Preconditions:** Connected socket
**Steps:**
1. Simulate disconnect (close socket)
2. Verify auto-reconnect triggers
3. Verify exponential backoff timing
4. Verify channel restoration after reconnect

**Expected Result:** Automatic recovery with configured strategy

---

## Delivery

### Code Changes
- [ ] New package: `packages/fifty_socket/`
  - `lib/fifty_socket.dart` (barrel export)
  - `lib/src/socket_service.dart`
  - `lib/src/reconnect_config.dart`
  - `lib/src/heartbeat_config.dart`
  - `lib/src/socket_error.dart` (SocketError, SocketErrorType)
  - `lib/src/socket_state.dart` (SocketConnectionState, SocketStateInfo)
  - `lib/src/log_level.dart`
- [ ] Tests: `test/` directory with unit tests
- [ ] Example: `example/` with minimal consumer

### Documentation Updates
- [ ] README.md: Full usage guide with extend-and-connect pattern
- [ ] Update root README: Add fifty_socket to package table

### Deployment Notes
- [ ] Publish to pub.dev after review
- [ ] No migrations needed
- [ ] No breaking changes to existing packages

---

## Notes

- Source code is production-proven in opaala_admin_app_v3 KDS system (real-time order management)
- The `phoenix_socket` dependency means this is currently Phoenix-specific. Future versions could abstract the transport layer, but that's out of scope
- The consumer pattern (extend SocketService, implement getWebSocketUrl, add domain streams) is clean and should be documented as the recommended usage
- This becomes the 16th package in the Fifty Flutter Kit ecosystem

---

**Created:** 2026-02-24
**Last Updated:** 2026-02-24
**Brief Owner:** Partner
