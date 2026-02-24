# BR-074: Igris Birth Chamber Hero Website

**Type:** Feature
**Priority:** P1 - High
**Status:** Ready
**Effort:** XL - Extra Large (10 sprints)
**Created:** 2026-02-05

---

## Problem

Igris AI needs a compelling hero website that introduces the product with a cinematic "Birth Chamber" animation - a 6.5-second sci-fi lab sequence where the Igris mascot is "born", followed by a hero landing page with feature showcase.

## Goal

Create a Flutter Web app at `apps/igris_website/` featuring:
1. A cinematic 6.5s Birth Chamber animation with 4 phases
2. Tech HUD overlays with reactive data
3. Seamless transition to hero landing page
4. Feature showcase with FDL components
5. Responsive design (Desktop/Tablet/Mobile)
6. Optional audio integration
7. Reduced motion accessibility support

## Context & Inputs

- **Platform:** Flutter Web (CanvasKit renderer)
- **State Management:** GetX (MVVM + Actions pattern)
- **Design System:** FDL (fifty_tokens, fifty_theme, fifty_ui)
- **Audio:** fifty_audio_engine (optional)
- **Reference:** apps/tactical_grid/ for patterns

## Constraints

- Must use CanvasKit renderer for GPU-accelerated CustomPainters
- Single master animation controller (6500ms)
- All child animations derived via Interval
- Single page app (AnimatedSwitcher, no route transition between chamber and hero)
- Object pooling for particles (avoid GC)
- FDL compliance (consume tokens, no custom theme classes)

## Acceptance Criteria

1. Animation plays through all 4 phases in 6.5s
2. Skip button jumps to hero landing
3. Tech panels show reactive data per phase
4. Progress bar fills 0-100%
5. Transition to hero landing is seamless
6. Feature cards have hover effects
7. Responsive at 1440px, 768px, 375px widths
8. Reduced motion skips animation entirely
9. `flutter analyze` passes with 0 errors

## Test Plan

- Unit tests for BirthChamberViewModel (phase transitions, progress)
- `flutter run -d chrome` from apps/igris_website/
- Visual verification of all 4 animation phases
- Skip button functionality
- Responsive testing at 3 breakpoints

## Delivery

- New app: `apps/igris_website/`
- 10 implementation sprints
- No migrations needed

---

## Workflow State

**Phase:** INIT
**Active Agent:** none
**Retry Count:** 0

### Agent Log
- [2026-02-05] Starting BR-074 implementation - 10 sprint plan
- [2026-02-24] Reset to Ready — no sprints started, stale since 2026-02-05

### Tasks

- [ ] Sprint 1: Project scaffold
- [ ] Sprint 2: ViewModel + Static Layout
- [ ] Sprint 3: Chamber + Character (Core Visuals)
- [ ] Sprint 4: Particle Systems
- [ ] Sprint 5: Scanning Beam + Energy Ripple
- [ ] Sprint 6: UI Overlays
- [ ] Sprint 7: Completion + Transition
- [ ] Sprint 8: Hero Landing Page
- [ ] Sprint 9: Audio Integration
- [ ] Sprint 10: Responsive + Polish

### Next Steps
- Ready for implementation when prioritized
