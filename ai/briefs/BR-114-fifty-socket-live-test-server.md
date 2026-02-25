# BR-114: Deploy Phoenix WebSocket Test Server for fifty_socket Live Testing

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

The `fifty_socket` package and its example app (BR-113) currently demonstrate the WebSocket API against a fake `ws://localhost:4000/socket` URL that always fails. This only shows the error/reconnection path — never the happy path (connected state, channel joins, message exchange, heartbeat monitoring). There is no way to validate that `fifty_socket` actually works end-to-end with a real Phoenix WebSocket server.

**Why does it matter?**

- Cannot verify the connected state, channel management, or message routing work correctly
- Cannot test heartbeat watchdog or ping/pong timeout detection
- Cannot demonstrate the full value of the package to developers evaluating it
- Need a real server to validate before publishing to pub.dev

---

## Goal

**What should happen after this brief is completed?**

1. A minimal Phoenix WebSocket server deployed on Partner's VPS (76.13.180.77)
2. The server exposes a WebSocket endpoint that `fifty_socket` can connect to
3. Supports Phoenix channel protocol (join, leave, push, broadcast)
4. The example app (BR-113) updated to connect to the live server
5. Full happy path verified: connect → join channel → send/receive messages → heartbeat → disconnect

---

## Context & Inputs

### VPS Details
- **Host:** 76.13.180.77
- **User:** root
- **OS:** Linux (check exact distro on deployment)
- **Existing services:** Igris Brain MCP server (port 3001), Crimson Arena dashboard (port 8001)

### Technical Requirements
- **Phoenix Framework** (Elixir) — the native WebSocket protocol that `fifty_socket` wraps via `phoenix_socket`
- OR a lightweight alternative that speaks the Phoenix channel protocol
- Minimal server — just enough to test socket lifecycle, channels, and messaging
- No database, no auth (or simple static token), no complex business logic

### Server Features Needed
- WebSocket endpoint at `ws://{host}:{port}/socket`
- Support for joining/leaving channels (e.g., `test:lobby`, `echo:*`)
- Echo channel: sends back any message received (for testing message routing)
- Presence/broadcast: notifies all channel members when someone joins/leaves
- Heartbeat support (Phoenix default ping/pong)

### Example App Updates
- Update `DemoSocketService.getWebSocketUrl()` to point to VPS
- Add channel join/leave UI in the example app
- Add message send/receive demonstration
- Show connected state (green) when successfully connected

### Dependencies
- [x] fifty_socket package (BR-112) — Done
- [x] fifty_socket example app (BR-113) — Done
- [ ] Elixir/Phoenix installed on VPS (or alternative)

---

## Constraints

### Architecture Rules
- Server should be minimal and self-contained (single Mix project or Docker container)
- Use a port that doesn't conflict with existing services (3001, 8001 taken)
- Server should auto-start on VPS reboot (systemd service or Docker restart policy)
- No sensitive data or auth secrets — this is a test/demo server

### Out of Scope
- Production-grade server
- User authentication (beyond optional static token)
- Database persistence
- SSL/TLS (use ws:// not wss:// for simplicity, can upgrade later)
- Load testing

---

## Acceptance Criteria

1. [ ] Phoenix WebSocket server running on VPS at a designated port
2. [ ] Example app connects successfully (CONNECTED state shown)
3. [ ] Channel join/leave works (join `test:lobby`, see confirmation)
4. [ ] Echo channel works (send message, receive it back)
5. [ ] Heartbeat/ping-pong functioning (no timeout disconnects)
6. [ ] Reconnection works (kill server, app reconnects when server restarts)
7. [ ] Server persists across VPS reboots (systemd/Docker)
8. [ ] Example app updated to use live server URL

---

**Created:** 2026-02-24
**Last Updated:** 2026-02-24
**Brief Owner:** Partner
