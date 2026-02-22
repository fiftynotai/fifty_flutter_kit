# BR-012: Fifty Audio Engine Example App

**Type:** Feature
**Priority:** P1-High
**Effort:** L-Large (3-5d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2025-12-27
**Completed:** 2025-12-27

---

## Problem

**What's broken or missing?**

The fifty_audio_engine package lacks a comprehensive example app that demonstrates all its capabilities. Users need a reference implementation showing:
- All three audio channels (BGM, SFX, Voice)
- Volume controls, mute toggles, fade presets
- Playlist management and SFX groups
- Integration with the Fifty Design Language

**Why does it matter?**

- Developers need working examples to understand the API
- Demonstrates Fifty ecosystem integration (tokens, theme, ui)
- Serves as a visual showcase of audio + UI synergy
- Validates the package works end-to-end

---

## Goal

**What should happen after this brief is completed?**

1. Comprehensive example app at `packages/fifty_audio_engine/example/`
2. Showcases ALL audio engine capabilities
3. Built entirely with fifty_ui components
4. Follows Fifty Design Language v2 (dark-first, burgundy accents, modern sophisticated)
5. Uses MVVM + Actions architecture pattern
6. Runs on all supported platforms

---

## Context & Inputs

### Audio Engine Capabilities to Demonstrate

| Channel | Features |
|---------|----------|
| **BGM** | Playlist, playNext, playAtIndex, shuffle, cross-fade, volume, mute, pause, resume |
| **SFX** | Play single, playGroup, pooling, throttle, volume, mute |
| **Voice** | Play voice line, BGM ducking (auto/manual), volume, mute |
| **Global** | muteAll, unmuteAll, stopAll, fadeAllIn, fadeAllOut |
| **Fades** | fast (150ms), panel (300ms), normal (800ms), cinematic (2s), ambient (3s) |

### Fifty UI Components to Use

| Component | Usage |
|-----------|-------|
| FiftyHero | App title "AUDIO ENGINE" |
| FiftyCard | Section containers for each channel |
| FiftyButton | Play, pause, stop, next controls |
| FiftyIconButton | Mute, shuffle toggles |
| FiftySlider | Volume controls |
| FiftySwitch | Channel enable/disable |
| FiftyProgressBar | Playback progress |
| FiftyChip | Track info, preset indicators |
| FiftyDataSlate | Status display (current track, duration) |
| FiftyBadge | Channel status (playing, muted) |
| FiftyDropdown | Fade preset selector |
| FiftyNavBar | Section navigation |
| GlitchEffect | Title branding |
| KineticEffect | Interactive feedback |
| GlowContainer | Focus states |

### Affected Modules
- [x] Other: `packages/fifty_audio_engine/example/`

### Layers Touched (MVVM + Actions)
- [x] View (UI widgets)
- [x] Actions (UX orchestration)
- [x] ViewModel (business logic)
- [x] Service (FiftyAudioEngine)
- [x] Model (audio state)

### Dependencies
- [x] fifty_tokens (design tokens)
- [x] fifty_theme (theming)
- [x] fifty_ui (components)
- [x] fifty_audio_engine (audio)

### Related Files
- Target: `packages/fifty_audio_engine/example/`
- Reference: `packages/fifty_ui/example/` (existing pattern)

---

## Constraints

### Architecture Rules
- Must follow MVVM + Actions pattern
- View → Actions → ViewModel → Service → Model
- Use actionHandler() for user-triggered actions
- Reactive state with streams/notifiers

### Multi-Agent Workflow Override
- **Replace:** coder agent
- **With:** mvvm_arch_action_agent
- **Reason:** Ensure MVVM + Actions architecture compliance

### Technical Constraints
- Must use FiftyTheme.dark() as primary theme
- All interactions must have audio feedback
- Must demonstrate real audio playback (include sample assets)
- Must work offline (bundled assets)

### Out of Scope
- Example app publishing to stores
- Recording/microphone features
- External API integrations

---

## Example App Structure

```
example/
├── lib/
│   ├── main.dart                    # App entry, theme setup
│   ├── app/
│   │   └── audio_demo_app.dart      # Main app shell
│   ├── features/
│   │   ├── bgm/
│   │   │   ├── bgm_view.dart        # BGM controls UI
│   │   │   ├── bgm_actions.dart     # User action handlers
│   │   │   └── bgm_view_model.dart  # BGM state
│   │   ├── sfx/
│   │   │   ├── sfx_view.dart        # SFX controls UI
│   │   │   ├── sfx_actions.dart     # User action handlers
│   │   │   └── sfx_view_model.dart  # SFX state
│   │   ├── voice/
│   │   │   ├── voice_view.dart      # Voice controls UI
│   │   │   ├── voice_actions.dart   # User action handlers
│   │   │   └── voice_view_model.dart # Voice state
│   │   └── global/
│   │       ├── global_view.dart     # Global controls
│   │       ├── global_actions.dart  # Global action handlers
│   │       └── global_view_model.dart # Global state
│   └── widgets/
│       ├── channel_card.dart        # Reusable channel container
│       ├── volume_control.dart      # Volume slider with label
│       ├── playback_controls.dart   # Play/pause/stop buttons
│       └── fade_preset_selector.dart # Dropdown for fade presets
├── assets/
│   ├── bgm/
│   │   ├── track_01.mp3             # Sample BGM track 1
│   │   ├── track_02.mp3             # Sample BGM track 2
│   │   └── track_03.mp3             # Sample BGM track 3
│   ├── sfx/
│   │   ├── click_01.mp3             # Button click variant 1
│   │   ├── click_02.mp3             # Button click variant 2
│   │   ├── hover_01.mp3             # Hover sound
│   │   └── success.mp3              # Success notification
│   └── voice/
│       └── greeting.mp3             # Sample voice line
├── pubspec.yaml                     # Dependencies
└── README.md                        # Example documentation
```

---

## Tasks

### Pending
- [ ] Create example app structure
- [ ] Configure pubspec.yaml with ecosystem dependencies
- [ ] Create main.dart with FiftyTheme setup
- [ ] Create audio_demo_app.dart shell with FiftyNavBar
- [ ] Implement BGM feature (view, actions, view_model)
- [ ] Implement SFX feature (view, actions, view_model)
- [ ] Implement Voice feature (view, actions, view_model)
- [ ] Implement Global controls feature
- [ ] Create reusable widgets (channel_card, volume_control, etc.)
- [ ] Add sample audio assets (or use placeholder strategy)
- [ ] Write example README.md
- [ ] Run flutter analyze (zero issues)
- [ ] Test on simulator/emulator

### In Progress
_(Tasks currently being worked on)_

### Completed
_(Finished tasks)_

---

## Session State (Tactical - This Brief)

**Current State:** Not started
**Next Steps When Resuming:** Begin with example app structure
**Last Updated:** 2025-12-27
**Blockers:** None

---

## Workflow State

**Phase:** COMPLETE
**Active Agent:** none
**Retry Count:** 0

### Agent Log
- [2025-12-27 INIT] Orchestrator: Hunt protocol engaged
- [2025-12-27 INIT] Orchestrator: Multi-agent workflow with mvvm_arch_action_agent override
- [2025-12-27 INIT] Orchestrator: Branch implement/BR-012-audio-engine-example created
- [2025-12-27 PLANNING] Starting: planner agent
- [2025-12-27 PLANNING] Completed: Plan saved to ai/plans/BR-012-plan.md
- [2025-12-27 APPROVAL] Awaiting: User approval (L-Large effort)
- [2025-12-27 APPROVAL] Completed: User approved plan
- [2025-12-27 BUILDING] Starting: mvvm_arch_action_agent (replaces coder)
- [2025-12-27 BUILDING] Completed: 18 files created with MVVM + Actions architecture
- [2025-12-27 TESTING] Starting: tester agent
- [2025-12-27 TESTING] Completed: PASS (0 errors, MVVM verified, 12+ UI components)
- [2025-12-27 REVIEWING] Starting: reviewer agent
- [2025-12-27 REVIEWING] Completed: APPROVE (0 critical, 0 major, 3 minor)
- [2025-12-27 COMMITTING] Starting: orchestrator
- [2025-12-27 COMMITTING] Completed: Commit dd0ce11 (23 files, 2781 insertions)
- [2025-12-27 COMPLETE] Hunt successful

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Example app runs successfully
2. [ ] All three channels (BGM, SFX, Voice) have working UI controls
3. [ ] Volume sliders control actual audio volume
4. [ ] Mute toggles work on all channels
5. [ ] Fade preset dropdown demonstrates all 5 presets
6. [ ] Global controls (muteAll, fadeAllOut) work
7. [ ] UI uses exclusively fifty_ui components
8. [ ] FiftyTheme.dark() is applied
9. [ ] MVVM + Actions architecture followed
10. [ ] `flutter analyze` passes (zero issues)
11. [ ] Example README.md documents usage

---

## Test Plan

### Manual Test Cases

#### Test Case 1: BGM Playback
**Steps:**
1. Launch app
2. Navigate to BGM section
3. Tap Play button
4. Adjust volume slider
5. Tap Next button
6. Toggle shuffle
7. Toggle mute

**Expected Result:** Audio plays, volume changes, track advances, shuffle works, mute silences

#### Test Case 2: SFX Interaction
**Steps:**
1. Navigate to SFX section
2. Tap various SFX buttons
3. Rapid-tap to test pooling
4. Adjust SFX volume

**Expected Result:** Sounds play with pooling, no overlap issues, volume controls work

#### Test Case 3: Voice with Ducking
**Steps:**
1. Start BGM playing
2. Navigate to Voice section
3. Tap Play Voice button

**Expected Result:** BGM volume ducks, voice plays, BGM restores after

#### Test Case 4: Global Fade
**Steps:**
1. Start audio on all channels
2. Navigate to Global section
3. Tap Fade Out button
4. Wait for fade complete
5. Tap Fade In button

**Expected Result:** All audio fades out smoothly, then fades back in

---

## Delivery

### Code Changes
- [ ] New files created: `packages/fifty_audio_engine/example/` (complete app)
- [ ] Modified files: None (new example)
- [ ] Deleted files: Existing placeholder example if any

### Documentation Updates
- [ ] Example README.md with screenshots and usage instructions

---

## UI Design Specifications

### Color Usage (FiftyColors)
- Background: voidBlack (#0A0A0A)
- Cards: gunmetal (#1A1A1A)
- Accent: crimsonPulse (#FF073A)
- Text: terminalWhite (#F5F5F5)
- Playing indicator: igrisGreen (#00FF9D)

### Typography (FiftyTypography)
- Hero title: 48px Monument Extended (hype)
- Section headers: 24px Monument Extended
- Labels: 14px JetBrains Mono (logic)
- Status text: 12px JetBrains Mono

### Component Patterns
- All cards: 12px radius, gunmetal fill, 1px crimson border
- Buttons: Primary crimson for main actions
- Sliders: Crimson track, terminalWhite thumb
- Switches: Crimson when active, gunmetal when inactive

---

## Notes

### Audio Asset Strategy

For the example to work without large audio files, use one of:

1. **Bundled mini assets** - Short 2-3 second clips (preferred)
2. **Network assets** - Load from CDN (requires connectivity)
3. **Silent placeholders** - Demonstrate UI without actual audio

Recommendation: Bundle 3-4 short royalty-free clips for each channel.

### Sample Asset Suggestions

| Asset | Duration | Purpose |
|-------|----------|---------|
| bgm_ambient.mp3 | 30s loop | Background atmosphere |
| sfx_click.mp3 | 0.2s | Button interaction |
| sfx_hover.mp3 | 0.1s | Hover feedback |
| sfx_success.mp3 | 0.5s | Action confirmation |
| voice_greeting.mp3 | 2s | Voice sample |

---

**Created:** 2025-12-27
**Last Updated:** 2025-12-27
**Brief Owner:** Igris AI
