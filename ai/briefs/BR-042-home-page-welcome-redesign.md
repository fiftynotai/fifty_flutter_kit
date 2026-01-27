# BR-042: Home Page Welcome/Onboarding Redesign

**Type:** Feature
**Priority:** P1-High
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI (ARTISAN)
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-01-24

---

## Problem

HOME and PACKAGES pages both display the same package information, creating redundant navigation. Users see essentially the same content on the first two tabs.

---

## Goal

Repurpose HOME as a Welcome/Onboarding experience with unique content:
- Remove EcosystemStatus package grid (redundant with PACKAGES tab)
- Add "Getting Started" section
- Add quick action buttons for key demos
- Add "What's New" or documentation links
- Keep System Info section

PACKAGES remains the comprehensive demo hub.

---

## Design Spec

### New HOME Page Structure

```
┌─────────────────────────────────────┐
│  HERO SECTION (existing)            │
│  "Fifty Flutter Kit"                │
├─────────────────────────────────────┤
│  GETTING STARTED                    │
│  ┌─────────┐ ┌─────────┐           │
│  │ Explore │ │ Try UI  │           │
│  │ Packages│ │   Kit   │           │
│  └─────────┘ └─────────┘           │
│  ┌─────────┐ ┌─────────┐           │
│  │  Audio  │ │  Map    │           │
│  │  Demo   │ │  Demo   │           │
│  └─────────┘ └─────────┘           │
├─────────────────────────────────────┤
│  WHAT'S NEW / HIGHLIGHTS            │
│  - v0.5.0: FDL v2 components        │
│  - fifty_forms package released     │
│  - New skill tree engine            │
├─────────────────────────────────────┤
│  DOCUMENTATION LINKS                │
│  [GitHub] [API Docs] [Examples]     │
├─────────────────────────────────────┤
│  SYSTEM INFO (existing)             │
│  Platform, Flutter version, etc.    │
└─────────────────────────────────────┘
```

### Components to Remove
- `EcosystemStatus` widget
- Package count stats row
- Analytics section (or repurpose as What's New)

### Components to Add
- `GettingStartedSection` - 4 quick action cards
- `WhatsNewSection` - Recent updates/highlights
- `DocumentationSection` - External links

---

## Related Files

**Modify:**
- `apps/fifty_demo/lib/features/home/views/home_page.dart`
- `apps/fifty_demo/lib/features/home/controllers/home_view_model.dart`

**Remove/Archive:**
- `apps/fifty_demo/lib/features/home/views/widgets/ecosystem_status.dart` (or keep for reference)

**Create:**
- `apps/fifty_demo/lib/features/home/views/widgets/getting_started_section.dart`
- `apps/fifty_demo/lib/features/home/views/widgets/whats_new_section.dart`
- `apps/fifty_demo/lib/features/home/views/widgets/documentation_section.dart`

---

## Tasks

### Completed
- [x] Remove EcosystemStatus from home_page.dart
- [x] Remove analytics section (redundant)
- [x] Create GettingStartedSection with 4 quick action cards
- [x] Create WhatsNewSection with recent highlights
- [x] Create ResourcesSection with external links
- [x] Update home_page.dart with new sections
- [x] Ensure navigation to PACKAGES tab works from quick actions

---

## Acceptance Criteria

1. [ ] HOME no longer shows package grid
2. [ ] Getting Started section with 4 tappable action cards
3. [ ] What's New section with 3+ highlights
4. [ ] Documentation links section
5. [ ] System Info section retained
6. [ ] Navigation from quick actions works correctly
7. [ ] `flutter analyze` passes

---

**Created:** 2026-01-24
**Brief Owner:** ARTISAN
