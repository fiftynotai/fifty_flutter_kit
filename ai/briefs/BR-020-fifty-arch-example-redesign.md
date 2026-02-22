# BR-020: fifty_arch Example Redesign - Orbital Command

**Type:** Feature
**Priority:** P2-Medium
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2025-12-30
**Completed:** 2025-12-30

---

## Problem

**What's broken or missing?**

The current fifty_arch example app uses a generic "posts" module that fetches placeholder data from JSONPlaceholder API. This example:

1. **Doesn't showcase FDL aesthetic** - Uses default Material styling, not FDL v2
2. **No fifty_ui integration** - Doesn't use FiftyButton, FiftyCard, FiftyDataSlate, etc.
3. **No fifty_theme integration** - Uses custom themes instead of FiftyTheme.dark()/light()
4. **Generic concept** - "Posts" is uninspiring and doesn't demonstrate the architecture's power
5. **Fake data** - JSONPlaceholder is boring placeholder text

**Why does it matter?**

The example app is the first impression developers get of the architecture. A compelling, well-designed example:
- Demonstrates best practices
- Shows ecosystem integration possibilities
- Inspires developers to adopt the architecture
- Uses real, fascinating data

---

## Goal

**What should happen after this brief is completed?**

A redesigned example app called **"Orbital Command"** - a space monitoring station that:

1. **Embodies FDL v2 Modern Sophisticated**
   - Dark mode primary (voidBlack background) - perfect for space theme
   - Crimson pulse accents (alert indicators, threat levels)
   - Monument Extended headings + JetBrains Mono body
   - Sharp 12px/24px radii, no drop shadows
   - Compact density, 4px grid spacing

2. **Uses NASA Open APIs (Real Data)**
   - **APOD** - Astronomy Picture of the Day
   - **Mars Rover Photos** - Curiosity/Perseverance imagery
   - **NEO** - Near Earth Objects (asteroid tracking)

3. **Integrates fifty ecosystem packages**
   - `fifty_tokens` - Design tokens for all values
   - `fifty_theme` - FiftyTheme.dark() / FiftyTheme.light()
   - `fifty_ui` - FiftyButton, FiftyCard, FiftyDataSlate, FiftyChip, etc.

4. **Showcases all architecture modules**
   - **Auth** - Operator login/logout with styled forms
   - **Connectivity** - System uplink status indicator
   - **Locale** - Language switcher (EN/AR)
   - **Theme** - Dark/light toggle (dark primary)
   - **Space** - New module replacing "posts"

---

## Concept: Orbital Command

### Theme
A **space monitoring station** aesthetic - think NASA mission control meets brutalist design. The app functions as an orbital command interface where operators:
- View daily cosmic briefings (APOD)
- Monitor near-Earth objects (asteroids)
- Browse Mars reconnaissance data (rover photos)
- Track system status

### NASA APIs

| API | Endpoint | Data |
|-----|----------|------|
| **APOD** | `api.nasa.gov/planetary/apod` | Daily space image + explanation |
| **NEO** | `api.nasa.gov/neo/rest/v1/feed` | Asteroids, distance, velocity, threat |
| **Mars Rover** | `api.nasa.gov/mars-photos/api/v1/rovers/{rover}/photos` | Curiosity/Perseverance images |

**API Key:** Free at https://api.nasa.gov (DEMO_KEY works for testing)

### Screens

1. **Splash** - Orbital Command logo with star field animation
2. **Login** - Operator authentication ("Access Orbital Command")
3. **Dashboard** - Main command center view
   - Daily briefing card (APOD image + title)
   - NEO threat assessment (asteroid count + closest approach)
   - Quick stats (objects tracked, missions active)
4. **APOD Detail** - Full cosmic briefing with HD image
5. **NEO Monitor** - Near Earth Objects list with threat levels
6. **Mars Recon** - Mars rover photo gallery
7. **Settings** - Operator profile, theme/locale

### Data Models

```dart
// Astronomy Picture of the Day
class ApodModel {
  final String title;
  final String explanation;
  final String url;
  final String hdurl;
  final String date;
  final String mediaType; // image or video
}

// Near Earth Object
class NeoModel {
  final String id;
  final String name;
  final double diameter; // km
  final double velocity; // km/h
  final double missDistance; // AU
  final bool isPotentiallyHazardous;
  final DateTime closeApproachDate;
}

// Mars Rover Photo
class MarsPhotoModel {
  final int id;
  final String imgSrc;
  final String earthDate;
  final String roverName;
  final String cameraName;
}
```

### Visual Language

| Element | FDL Treatment |
|---------|---------------|
| Background | voidBlack (#0D0D0D) - the void of space |
| Cards | gunmetal (#2A2A2E) with 1px border |
| Primary action | crimsonPulse (#DC143C) - alert/action |
| Safe status | igrisGreen (#00FF41) - all clear |
| Warning | hyperChrome (#C0C0C0) - caution |
| Text | terminalWhite (#F5F5F5) |
| Focus states | Crimson glow (no drop shadows) |
| Threat levels | P0=Crimson, P1=Orange, P2=Yellow, P3=Green |

---

## Context & Inputs

### Affected Modules
- [x] `auth` - Restyle as "Operator Access"
- [x] `connections` - Restyle as "Uplink Status"
- [x] `locale` - FDL-styled language picker
- [x] `menu` - Orbital Command navigation
- [x] `theme` - Integrate FiftyTheme
- [x] `posts` → `space` - Replace entirely with NASA data
- [x] `presentation/custom` - Replace with fifty_ui

### New Module: `space`
```
lib/src/modules/space/
├── space.dart                    # Barrel export
├── space_bindings.dart           # DI bindings
├── actions/
│   └── space_actions.dart        # UX orchestration
├── controllers/
│   ├── apod_view_model.dart      # APOD state
│   ├── neo_view_model.dart       # NEO state
│   └── mars_view_model.dart      # Mars photos state
├── data/
│   ├── models/
│   │   ├── apod_model.dart
│   │   ├── neo_model.dart
│   │   └── mars_photo_model.dart
│   └── services/
│       └── nasa_service.dart     # NASA API client
└── views/
    ├── dashboard_page.dart       # Main command center
    ├── apod_detail_page.dart     # APOD full view
    ├── neo_monitor_page.dart     # Asteroid list
    ├── mars_recon_page.dart      # Mars gallery
    └── widgets/
        ├── apod_card.dart
        ├── neo_list_tile.dart
        ├── threat_indicator.dart
        └── mars_photo_grid.dart
```

### Dependencies
- [x] fifty_tokens: Design token values
- [x] fifty_theme: Theme system
- [x] fifty_ui: Component library
- [x] cached_network_image: Image caching for NASA photos
- [x] http or dio: API requests

---

## Tasks

### Pending
- [ ] Task 1: Add ecosystem dependencies to pubspec.yaml
  - fifty_tokens, fifty_theme, fifty_ui (path deps)
  - cached_network_image
- [ ] Task 2: Update app.dart to use FiftyTheme.dark()/light()
- [ ] Task 3: Create NasaService with API client
  - APOD endpoint
  - NEO Feed endpoint
  - Mars Rover Photos endpoint
  - API key configuration
- [ ] Task 4: Create data models
  - ApodModel with JSON serialization
  - NeoModel with JSON serialization
  - MarsPhotoModel with JSON serialization
- [ ] Task 5: Create space module ViewModels
  - ApodViewModel (fetch daily, cache)
  - NeoViewModel (fetch feed, filter hazardous)
  - MarsViewModel (fetch by rover/date)
- [ ] Task 6: Create SpaceActions for UX orchestration
- [ ] Task 7: Build Dashboard page with FDL styling
  - APOD hero card
  - NEO threat summary (FiftyDataSlate)
  - Quick stats row
  - Navigation to detail pages
- [ ] Task 8: Build APOD Detail page
  - Full HD image display
  - Explanation text
  - Share action
- [ ] Task 9: Build NEO Monitor page
  - List of near-Earth objects
  - Threat level chips (FiftyChip)
  - Distance/velocity display
- [ ] Task 10: Build Mars Recon page
  - Photo grid
  - Rover selector
  - Date picker
- [ ] Task 11: Restyle auth module views
  - Login as "Operator Access"
  - FiftyTextField, FiftyButton
- [ ] Task 12: Restyle connection overlay as "Uplink Status"
- [ ] Task 13: Update menu drawer with Orbital Command branding
- [ ] Task 14: Remove old posts module
- [ ] Task 15: Update README with Orbital Command description
- [ ] Task 16: Run flutter analyze (zero issues)
- [ ] Task 17: Run flutter test

### In Progress
_(Tasks currently being worked on)_

### Completed
_(Finished tasks)_

---

## Session State (Tactical - This Brief)

**Current State:** Not started
**Next Steps When Resuming:** Begin with Task 1 - Add ecosystem dependencies
**Last Updated:** 2025-12-30
**Blockers:** None

---

## Acceptance Criteria

**The feature is complete when:**

1. [ ] App fetches real data from NASA APIs (APOD, NEO, Mars)
2. [ ] Example uses FiftyTheme.dark()/light() from fifty_theme
3. [ ] All views use fifty_ui components
4. [ ] Color values come from fifty_tokens (FiftyColors)
5. [ ] New space module replaces posts module
6. [ ] Dashboard shows APOD + NEO summary + stats
7. [ ] NEO Monitor shows asteroid list with threat levels
8. [ ] Mars Recon shows rover photo gallery
9. [ ] Auth flow styled with FDL aesthetic
10. [ ] Dark mode is primary (space theme)
11. [ ] `flutter analyze` passes (zero issues)
12. [ ] App handles API errors gracefully

---

## Visual Mockups (ASCII)

### Dashboard Screen
```
┌──────────────────────────────────────────┐
│  ☰  ORBITAL COMMAND          ◉ UPLINK   │
├──────────────────────────────────────────┤
│                                          │
│  ┌────────────────────────────────────┐  │
│  │                                    │  │
│  │        [APOD IMAGE]                │  │
│  │     "Horsehead Nebula"             │  │
│  │                                    │  │
│  │  Daily Cosmic Briefing    [VIEW]   │  │
│  └────────────────────────────────────┘  │
│                                          │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐  │
│  │ ⚠ NEO    │ │ TRACKED  │ │ MARS     │  │
│  │    3     │ │   847    │ │  12.4k   │  │
│  │ APPROACH │ │ OBJECTS  │ │  PHOTOS  │  │
│  └──────────┘ └──────────┘ └──────────┘  │
│                                          │
│  THREAT ASSESSMENT                       │
│  ┌────────────────────────────────────┐  │
│  │ 2024 XK4  │ 0.02 AU │ ● HAZARDOUS │  │
│  │ 2024 YM1  │ 0.05 AU │ ○ NOMINAL   │  │
│  └────────────────────────────────────┘  │
│                                          │
│  [NEO MONITOR]  [MARS RECON]  [SETTINGS]│
└──────────────────────────────────────────┘
```

### NEO Monitor Screen
```
┌──────────────────────────────────────────┐
│  ←  NEO MONITOR              2024-12-30  │
├──────────────────────────────────────────┤
│                                          │
│  CLOSE APPROACHES (NEXT 7 DAYS)          │
│                                          │
│  ┌────────────────────────────────────┐  │
│  │ ● 2024 XK4                         │  │
│  │   Diameter: 0.4 km                 │  │
│  │   Velocity: 45,230 km/h            │  │
│  │   Distance: 0.02 AU   [HAZARDOUS]  │  │
│  │   Approach: Dec 31, 2024           │  │
│  └────────────────────────────────────┘  │
│  ┌────────────────────────────────────┐  │
│  │ ○ 2024 YM1                         │  │
│  │   Diameter: 0.1 km                 │  │
│  │   Velocity: 32,100 km/h            │  │
│  │   Distance: 0.05 AU   [NOMINAL]    │  │
│  │   Approach: Jan 02, 2025           │  │
│  └────────────────────────────────────┘  │
│  ┌────────────────────────────────────┐  │
│  │ ○ 2024 ZP3                         │  │
│  │   Diameter: 0.08 km                │  │
│  │   Distance: 0.12 AU   [NOMINAL]    │  │
│  └────────────────────────────────────┘  │
│                                          │
└──────────────────────────────────────────┘
```

### Login Screen
```
┌──────────────────────────────────────────┐
│                                          │
│            ╭──────────────╮              │
│            │   ◉    ◉     │              │
│            │  ORBITAL     │              │
│            │  COMMAND     │              │
│            ╰──────────────╯              │
│                                          │
│          OPERATOR ACCESS                 │
│                                          │
│  ┌────────────────────────────────────┐  │
│  │ Operator ID                        │  │
│  └────────────────────────────────────┘  │
│  ┌────────────────────────────────────┐  │
│  │ Access Code          ●●●●●●●●      │  │
│  └────────────────────────────────────┘  │
│                                          │
│  ┌────────────────────────────────────┐  │
│  │        ESTABLISH UPLINK            │  │
│  └────────────────────────────────────┘  │
│                                          │
│         [ Request Access ]               │
│                                          │
└──────────────────────────────────────────┘
```

---

## API Examples

### APOD Response
```json
{
  "date": "2024-12-30",
  "title": "Horsehead Nebula",
  "explanation": "One of the most identifiable nebulae...",
  "url": "https://apod.nasa.gov/apod/image/2412/horsehead.jpg",
  "hdurl": "https://apod.nasa.gov/apod/image/2412/horsehead_hd.jpg",
  "media_type": "image"
}
```

### NEO Response (simplified)
```json
{
  "element_count": 12,
  "near_earth_objects": {
    "2024-12-30": [
      {
        "id": "54321",
        "name": "2024 XK4",
        "estimated_diameter": { "kilometers": { "estimated_diameter_max": 0.4 } },
        "is_potentially_hazardous_asteroid": true,
        "close_approach_data": [{
          "relative_velocity": { "kilometers_per_hour": "45230" },
          "miss_distance": { "astronomical": "0.02" }
        }]
      }
    ]
  }
}
```

---

## Test Plan

### Automated Tests
- [ ] Unit test: NasaService API parsing
- [ ] Unit test: ApodModel JSON serialization
- [ ] Unit test: NeoModel threat level calculation
- [ ] Widget test: Dashboard renders APOD card
- [ ] Widget test: NEO list shows threat chips

### Manual Test Cases

#### Test Case 1: NASA API Integration
**Steps:**
1. Launch app
2. Wait for dashboard to load
3. Verify APOD image displays
4. Navigate to NEO Monitor
5. Verify asteroid data loads

**Expected Result:** Real NASA data displays correctly
**Status:** [ ] Pass / [ ] Fail

#### Test Case 2: Offline Handling
**Steps:**
1. Disable network
2. Launch app
3. Verify error state shows gracefully

**Expected Result:** Friendly error message, retry option
**Status:** [ ] Pass / [ ] Fail

---

## Delivery

### Code Changes
- [ ] New: `lib/src/modules/space/` (entire module)
- [ ] Modified: `lib/src/app.dart` (FiftyTheme)
- [ ] Modified: `lib/src/modules/auth/views/`
- [ ] Modified: `lib/src/modules/connections/views/`
- [ ] Modified: `lib/src/modules/menu/views/`
- [ ] Modified: `lib/src/config/api_config.dart` (NASA endpoints)
- [ ] Deleted: `lib/src/modules/posts/`

### Configuration
- [ ] NASA API key in environment/config
- [ ] Base URL: `https://api.nasa.gov`

### Documentation Updates
- [ ] README: Orbital Command description
- [ ] README: NASA API setup instructions
- [ ] README: Screenshots

---

## Notes

**Why "Orbital Command" fits perfectly:**

1. **Dark theme natural** - Space is dark, voidBlack background is authentic
2. **Real fascinating data** - NASA APIs provide genuinely interesting content
3. **Threat levels = priorities** - NEO hazard levels map to P0/P1/P2 chips
4. **Image-rich** - APOD and Mars photos showcase image handling
5. **Multiple data sources** - Demonstrates multi-service architecture
6. **Universal appeal** - Space interests everyone

**API Rate Limits:**
- DEMO_KEY: 30 requests/hour, 50 requests/day
- Free key: 1000 requests/hour

---

**Created:** 2025-12-30
**Last Updated:** 2025-12-30
**Brief Owner:** Igris AI
