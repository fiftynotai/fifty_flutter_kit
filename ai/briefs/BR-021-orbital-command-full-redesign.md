# BR-021: Orbital Command Full App Redesign

**Type:** Feature
**Priority:** P1-High
**Effort:** L-Large
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** In Progress
**Created:** 2025-12-30
**Completed:** -

---

## Goal

Transform the entire fifty_arch example app into "Orbital Command" - a space monitoring station with full FDL (Fifty Design Language) integration. All existing modules (auth, connections, locale, theme, menu) will be restyled with space/military aesthetic while maintaining their functionality.

---

## Visual Language

| Element | FDL Treatment |
|---------|---------------|
| Background | voidBlack (#0D0D0D) |
| Cards | gunmetal (#2A2A2E) with 1px border |
| Primary action | crimsonPulse (#DC143C) |
| Safe status | igrisGreen (#00FF41) |
| Warning | hyperChrome (#C0C0C0) |
| Text | terminalWhite (#F5F5F5) |
| Headlines | Monument Extended, UPPERCASE |
| Body | JetBrains Mono |

---

## Module Redesign

### 1. Auth Module → "Operator Access"
- Splash: Orbital Command logo with star field
- Login: "ESTABLISH UPLINK" styled form
- Register: "REQUEST ACCESS" styled form
- Use FiftyTextField, FiftyButton, FiftyCard

### 2. Menu Module → "Command Center"
- Drawer: Space station command menu
- Items: Radar icon + UPPERCASE labels
- Bottom nav: Minimal icon bar with crimson accent

### 3. Connections Module → "Uplink Status"
- Overlay: "SIGNAL LOST" with pulse animation
- Handler: Status indicator (ONLINE/OFFLINE/CONNECTING)

### 4. Locale Module → "Language Protocol"
- Dialog: Terminal-style language selector
- Use FiftyChip for language options

### 5. Theme Module → "Visual Mode"
- Dark mode PRIMARY (space theme)
- Light mode available as secondary

### 6. Space Module (Main Content)
- Dashboard: APOD, NEO threats, Mars recon
- Replace posts module entirely

---

## Tasks

- [ ] Update config/config.dart with Orbital Command branding
- [ ] Restyle auth/views/splash.dart
- [ ] Restyle auth/views/login.dart
- [ ] Restyle auth/views/register.dart
- [ ] Restyle menu/views/side_menu_drawer.dart
- [ ] Restyle menu/views/menu_drawer_item.dart
- [ ] Restyle connections/views/connection_overlay.dart
- [ ] Restyle locale/views/language_dialog.dart
- [ ] Update app.dart routes (remove posts, add space)
- [ ] Delete posts module
- [ ] Run flutter analyze
- [ ] Run flutter test

---

**Created:** 2025-12-30
