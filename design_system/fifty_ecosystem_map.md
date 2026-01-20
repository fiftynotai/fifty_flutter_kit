# FIFTY.DEV ECOSYSTEM MAP

**Version:** 2.0.0 | **Status:** Active Development

A visual dependency and relationship diagram for the fifty.dev modular architecture.

---

## ARCHITECTURE OVERVIEW

```
┌─────────────────────────────────────────────────────────────────┐
│                      FOUNDATION LAYER                            │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │ fifty_tokens│──▶│ fifty_theme │──▶│  fifty_ui   │              │
│  │   (DNA)     │  │  (Theming)  │  │ (Components)│              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                    INFRASTRUCTURE LAYER                          │
│  ┌───────────┐ ┌─────────────┐ ┌───────────┐ ┌────────────────┐ │
│  │fifty_cache│ │fifty_storage│ │fifty_utils│ │fifty_connectivity│
│  └───────────┘ └─────────────┘ └───────────┘ └────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                       ENGINE LAYER                               │
│  ┌────────────────┐ ┌─────────────────┐ ┌───────────────────┐   │
│  │fifty_audio_    │ │fifty_speech_    │ │fifty_sentences_   │   │
│  │engine          │ │engine           │ │engine             │   │
│  └────────────────┘ └─────────────────┘ └───────────────────┘   │
│  ┌────────────────┐ ┌─────────────────┐ ┌───────────────────┐   │
│  │fifty_map_      │ │fifty_printing_  │ │fifty_skill_tree   │   │
│  │engine          │ │engine           │ │                   │   │
│  └────────────────┘ └─────────────────┘ └───────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

---

## LAYER DEFINITIONS

### Foundation Layer
The design system core. All visual decisions flow from here.

| Package | Version | Purpose | Status |
|---------|---------|---------|--------|
| `fifty_tokens` | 1.0.0 | Design tokens (colors, spacing, typography, radii) | Released |
| `fifty_theme` | 1.0.0 | Theme system (light/dark modes, ThemeData) | Released |
| `fifty_ui` | 1.0.0 | Component library (28 production components) | Released |

### Infrastructure Layer
Core utilities and services consumed by all applications.

| Package | Version | Purpose | Status |
|---------|---------|---------|--------|
| `fifty_cache` | 0.1.0 | HTTP response caching | Released |
| `fifty_storage` | 0.1.0 | Secure local storage (tokens, preferences) | Released |
| `fifty_utils` | 0.1.0 | Shared utilities, ApiResponse wrapper | Released |
| `fifty_connectivity` | 0.1.0 | Network monitoring, connection overlay | Released |

### Engine Layer
Domain-specific functionality for specialized applications.

| Package | Version | Purpose | Status |
|---------|---------|---------|--------|
| `fifty_audio_engine` | 0.8.0 | Multi-channel audio (BGM, SFX, Voice) | Ready |
| `fifty_speech_engine` | 0.1.0 | Text-to-speech integration | Released |
| `fifty_sentences_engine` | 0.1.0 | Dialogue/sentence queue management | Released |
| `fifty_map_engine` | 0.1.0 | 2D map and grid system | Released |
| `fifty_printing_engine` | 1.0.0 | Print services and PDF generation | Released |
| `fifty_skill_tree` | 0.2.0 | RPG-style skill tree visualization | Released |

---

## DEPENDENCY FLOW

```
fifty_tokens
     │
     ├──▶ fifty_theme ──▶ fifty_ui
     │
     └──▶ fifty_ui (direct token consumption)
              │
              └──▶ Engine Packages (consume FDL components)
```

### Key Principles

1. **Tokens First:** All visual values come from `fifty_tokens`
2. **Theme Aware:** Components support light/dark via `fifty_theme`
3. **FDL Compliance:** Engine packages consume, never redefine tokens
4. **Layer Independence:** Infrastructure packages have no UI dependencies

---

## CROSS-LAYER DEPENDENCIES

| From | To | Purpose |
|------|----|---------|
| fifty_tokens | fifty_theme | Design tokens → Flutter ThemeData |
| fifty_tokens | fifty_ui | Direct token consumption for components |
| fifty_theme | fifty_ui | Theme context for mode switching |
| fifty_ui | fifty_skill_tree | FDL components in skill tree widgets |
| fifty_utils | all packages | Shared helpers, ApiResponse |
| fifty_storage | apps | Token/preference persistence |
| fifty_cache | apps | API response caching |
| fifty_connectivity | apps | Network state management |

---

## PACKAGE COUNT

| Layer | Count | Packages |
|-------|-------|----------|
| Foundation | 3 | tokens, theme, ui |
| Infrastructure | 4 | cache, storage, utils, connectivity |
| Engine | 6 | audio, speech, sentences, map, printing, skill_tree |
| **Total** | **13** | |

---

## FUTURE PACKAGES (Planned)

| Package | Purpose | Priority |
|---------|---------|----------|
| `fifty_achievement_engine` | Achievement/badge system | P1-High |
| `fifty_forms` | Form validation and management | P1-High |
| `fifty_inventory_engine` | Inventory management UI | P2-Medium |
| `fifty_dialogue_engine` | Branching dialogue system | P2-Medium |

---

*Last Updated: 2026-01-20*
