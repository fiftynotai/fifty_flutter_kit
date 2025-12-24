# 🕸️ FIFTY.DEV ECOSYSTEM MAP

**Visual dependency and relationship diagram for the fifty.dev modular architecture**

---

## 🧱 FOUNDATION LAYER (Pilot 1)

```
┌────────────────────────────┐
│        fifty_tokens        │
│  (Design Tokens & System)  │
└──────────────┬─────────────┘
               │
               ▼
┌────────────────────────────┐
│        fifty_theme         │
│  (Theme & Extensions)      │
└──────────────┬─────────────┘
               │
               ▼
┌────────────────────────────┐
│         fifty_ui           │
│  (UI Components Library)   │
└──────────────┬─────────────┘
               │
               ▼
┌────────────────────────────┐
│         fifty_docs         │
│  (Docs & Storybook Layer)  │
└────────────────────────────┘
```

**Flow:** Tokens → Theme → UI → Docs  
**Purpose:** Defines the brand’s design and structure backbone.

---

## ⚙️ EXPERIENCE LAYER (Pilot 2)

```
┌────────────────────────────┐
│         fifty_ui           │
│   (Foundation from P1)     │
└───────┬────────┬───────────┘
        │        │
        ▼        ▼
┌──────────────┐ ┌──────────────────────┐
│  fifty_cmd   │ │     fifty_audio      │
│ (CMD Overlay │ │ (Audio Channels)     │
│  Framework)  │ └──────────────┬───────┘
└───────┬──────┘                │
        │                       ▼
        │             ┌──────────────────────┐
        │             │    fifty_speech     │
        │             │ (TTS + STT Engine)  │
        │             └────────────┬────────┘
        ▼                          │
┌──────────────────────┐           ▼
│      fifty_ai        │◄──────────┘
│ (AI Workflow Layer)  │
└──────────────────────┘
```

**Flow:** UI → CMD → AI → Audio/Speech  
**Purpose:** Enables user interaction, intelligence, and sound.

---

## 🧠 SYSTEMS & INTELLIGENCE LAYER (Pilot 3)

```
          ┌────────────────────────────┐
          │        fifty_ai            │
          │   (Core AI Brain)         │
          └────────────┬───────────────┘
                       │
   ┌────────────┬──────┴────────────┬──────────────┐
   ▼            ▼                   ▼              ▼
┌──────┐   ┌──────────────┐   ┌──────────────┐  ┌──────────────┐
│graph │   │  fifty_map   │   │fifty_sentence│  │fifty_offline │
│builder│  │ (Grid Engine)│   │(Dialogue Sys)│  │(Sync Layer)  │
└──────┘   └──────┬───────┘   └──────┬───────┘  └──────┬───────┘
                   │                 │                 │
                   ▼                 ▼                 ▼
             ┌──────────────┐  ┌──────────────┐  ┌──────────────┐
             │ fifty_audio  │  │ fifty_speech │  │ fifty_utils  │
             └──────┬───────┘  └──────────────┘  └──────────────┘
                    │
                    ▼
           ┌──────────────────────┐
           │    fifty_blueprint   │
           │ (AI DevOps Layer)    │
           └──────────┬───────────┘
                      ▼
             ┌────────────────┐
             │   fifty_site   │
             │ (Docs + Web)   │
             └────────────────┘
```

**Flow:** AI Core connects to System Engines (Graph, Map, Sentence) and feeds the DevOps automation layer.

---

## 🔁 CROSS-LAYER DEPENDENCIES

| From | To | Purpose |
|------|----|----------|
| fifty_tokens | fifty_theme | Design tokens → Flutter theme |
| fifty_theme | fifty_ui | Themed component system |
| fifty_ui | fifty_cmd | UI foundation for CMD overlay |
| fifty_cmd | fifty_ai | AI integration via prompt commands |
| fifty_ai | fifty_speech | Conversational and voice logic |
| fifty_speech | fifty_sentence | Spoken dialogue engine |
| fifty_audio | fifty_map / fifty_graph | Ambient sound and feedback |
| fifty_offline | fifty_ai / fifty_map | Caching and sync |
| fifty_utils | all packages | Shared helpers |
| fifty_blueprint | all packages | AI-driven automation and review |
| fifty_site | fifty_docs / fifty_ui | Public display and docs integration |

---

## 🧭 LAYER PURPOSE OVERVIEW

| Layer | Core Packages | Function |
|--------|----------------|-----------|
| **Foundation** | tokens, theme, ui, docs | Defines the brand’s design and code structure |
| **Experience** | cmd, ai, speech, audio | Delivers personality and interactivity |
| **Systems** | graph, map, sentence, offline, blueprint, utils, site | Builds intelligence, automation, and expansion |

---

> **Summary:** Fifty.dev forms a modular, interconnected architecture — from design to AI, from sound to storytelling. Every package is both independent and symbiotic, unified by the same crimson glow and code philosophy.

