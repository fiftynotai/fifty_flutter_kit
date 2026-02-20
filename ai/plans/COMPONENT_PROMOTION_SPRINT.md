# Component Promotion Sprint - Execution Blueprint

**Created:** 2026-02-02
**Coordinator:** CONDUCTOR (multi-agent-coordinator)
**Briefs:** BR-055, BR-056, BR-057, BR-058
**Status:** READY FOR EXECUTION

---

## Executive Summary

This sprint promotes reusable widgets from `fifty_demo` to their appropriate ecosystem packages:

| Brief | Source | Destination | Components |
|-------|--------|-------------|------------|
| BR-055 | fifty_demo | fifty_ui | FiftyStatusIndicator, FiftySectionHeader |
| BR-056 | fifty_demo | fifty_speech_engine | SpeechTtsControls, SpeechSttControls, SpeechControlsPanel |
| BR-057 | fifty_demo | fifty_ui | FiftySettingsRow, FiftyNavPill, FiftyLabeledIconButton, FiftyInfoRow, FiftyCursor |
| BR-058 | fifty_demo | fifty_audio_engine | AudioControlsPanel |

---

## Phase 1: Planning (Parallel)

### Agent Invocation: PLANNER x 4

All four planning tasks can run in parallel as they have no dependencies.

---

### Task 1A: Plan BR-055

**Agent:** planner
**Brief:** BR-055 - Promote Core Widgets to fifty_ui

**Instructions:**
```
Create an implementation plan for BR-055: Promote Core Widgets to fifty_ui.

CONTEXT:
- Working directory: /Users/m.elamin/StudioProjects/fifty_eco_system
- Architecture: MVVM + Actions (see ai/context/coding_guidelines.md)
- Target package: packages/fifty_ui/

BRIEF SUMMARY:
Promote StatusIndicator and SectionHeader from fifty_demo to fifty_ui as reusable FDL components.

SOURCE FILES:
- apps/fifty_demo/lib/shared/widgets/status_indicator.dart
- apps/fifty_demo/lib/shared/widgets/section_header.dart

DESTINATION FILES:
- packages/fifty_ui/lib/src/display/fifty_status_indicator.dart
- packages/fifty_ui/lib/src/display/fifty_section_header.dart

TASKS:
1. Read source widgets to understand current implementation
2. Design API following existing fifty_ui patterns (see FiftyButton, FiftyCard)
3. Plan file structure and barrel exports
4. Plan fifty_demo migration (update imports, remove old files)
5. List acceptance criteria checkpoints

OUTPUT: Save plan to ai/plans/BR-055-plan.md
```

---

### Task 1B: Plan BR-056

**Agent:** planner
**Brief:** BR-056 - Extract Speech Controls to fifty_speech_engine

**Instructions:**
```
Create an implementation plan for BR-056: Extract Speech Controls to fifty_speech_engine.

CONTEXT:
- Working directory: /Users/m.elamin/StudioProjects/fifty_eco_system
- Architecture: MVVM + Actions (see ai/context/coding_guidelines.md)
- Target package: packages/fifty_speech_engine/

BRIEF SUMMARY:
Extract TtsControls and SttControls from fifty_demo to fifty_speech_engine as callback-based widgets.

SOURCE FILES:
- apps/fifty_demo/lib/features/dialogue_demo/views/widgets/tts_controls.dart
- apps/fifty_demo/lib/features/dialogue_demo/views/widgets/stt_controls.dart

DESTINATION FILES:
- packages/fifty_speech_engine/lib/src/widgets/speech_tts_controls.dart
- packages/fifty_speech_engine/lib/src/widgets/speech_stt_controls.dart
- packages/fifty_speech_engine/lib/src/widgets/speech_controls_panel.dart
- packages/fifty_speech_engine/lib/src/widgets/widgets.dart (barrel)

TASKS:
1. Read source widgets to understand current implementation
2. Design callback-based API (no ViewModel dependencies)
3. Plan SpeechControlsPanel that combines both
4. Plan file structure and barrel exports
5. Plan fifty_demo migration
6. List acceptance criteria checkpoints

OUTPUT: Save plan to ai/plans/BR-056-plan.md
```

---

### Task 1C: Plan BR-057

**Agent:** planner
**Brief:** BR-057 - Promote Utility Widgets to fifty_ui

**Instructions:**
```
Create an implementation plan for BR-057: Promote Utility Widgets to fifty_ui.

CONTEXT:
- Working directory: /Users/m.elamin/StudioProjects/fifty_eco_system
- Architecture: MVVM + Actions (see ai/context/coding_guidelines.md)
- Target package: packages/fifty_ui/
- DEPENDENCY: This brief depends on BR-055 completing first (establishes patterns)

BRIEF SUMMARY:
Promote utility widgets from fifty_demo to fifty_ui: FiftySettingsRow, FiftyNavPill, FiftyLabeledIconButton, FiftyInfoRow, FiftyCursor.

SOURCE FILES:
- _SettingRow: apps/fifty_demo/lib/features/dialogue_demo/views/widgets/tts_controls.dart
- SectionNavPill: apps/fifty_demo/lib/shared/widgets/section_nav_pill.dart
- _ControlButton: apps/fifty_demo/lib/features/map_demo/views/widgets/map_controls.dart
- _InfoRow: apps/fifty_demo/lib/features/map_demo/views/widgets/entity_info_panel.dart
- _TypingCursor: apps/fifty_demo/lib/features/dialogue_demo/views/widgets/dialogue_display.dart

DESTINATION FILES:
- packages/fifty_ui/lib/src/display/fifty_settings_row.dart
- packages/fifty_ui/lib/src/display/fifty_info_row.dart
- packages/fifty_ui/lib/src/controls/fifty_nav_pill.dart
- packages/fifty_ui/lib/src/buttons/fifty_labeled_icon_button.dart
- packages/fifty_ui/lib/src/utils/fifty_cursor.dart

TASKS:
1. Read all source widgets
2. Design APIs following BR-055 patterns (once completed)
3. Evaluate FiftyNavPill vs FiftyChip overlap
4. Evaluate FiftyInfoRow vs FiftyDataSlate overlap
5. Plan consolidation of duplicate widgets
6. Plan file structure and barrel exports
7. Plan fifty_demo migration
8. List acceptance criteria checkpoints

OUTPUT: Save plan to ai/plans/BR-057-plan.md
```

---

### Task 1D: Plan BR-058

**Agent:** planner
**Brief:** BR-058 - Extract Audio Controls to fifty_audio_engine

**Instructions:**
```
Create an implementation plan for BR-058: Extract Audio Controls to fifty_audio_engine.

CONTEXT:
- Working directory: /Users/m.elamin/StudioProjects/fifty_eco_system
- Architecture: MVVM + Actions (see ai/context/coding_guidelines.md)
- Target package: packages/fifty_audio_engine/

BRIEF SUMMARY:
Extract AudioControlsWidget from fifty_demo to fifty_audio_engine as a callback-based widget.

SOURCE FILE:
- apps/fifty_demo/lib/features/map_demo/views/widgets/audio_controls.dart

DESTINATION FILES:
- packages/fifty_audio_engine/lib/src/widgets/audio_controls_panel.dart
- packages/fifty_audio_engine/lib/src/widgets/widgets.dart (barrel)

TASKS:
1. Read source widget to understand current implementation
2. Design callback-based API (no ViewModel dependencies)
3. Plan file structure and barrel exports
4. Plan fifty_demo migration
5. List acceptance criteria checkpoints

OUTPUT: Save plan to ai/plans/BR-058-plan.md
```

---

## Phase 2: Building (Parallel - Group 1)

### Dependencies Met

- All plans from Phase 1 must be complete
- User approval if L/XL complexity (these are M/S, so auto-approve)

### Agent Invocation: CODER x 3

BR-055, BR-056, and BR-058 can build in parallel (different packages).

---

### Task 2A: Build BR-055

**Agent:** coder
**Brief:** BR-055 - Promote Core Widgets to fifty_ui

**Instructions:**
```
Implement BR-055: Promote Core Widgets to fifty_ui.

PLAN: Read ai/plans/BR-055-plan.md for implementation details.

CONTEXT:
- Working directory: /Users/m.elamin/StudioProjects/fifty_eco_system
- Coding guidelines: ai/context/coding_guidelines.md
- Follow MVVM + Actions architecture
- Follow FDL design system patterns

KEY TASKS:
1. Create FiftyStatusIndicator in packages/fifty_ui/lib/src/display/
2. Create FiftySectionHeader in packages/fifty_ui/lib/src/display/
3. Add exports to packages/fifty_ui/lib/src/display/display.dart
4. Add exports to packages/fifty_ui/lib/fifty_ui.dart
5. Update fifty_demo to import from fifty_ui
6. Remove old widgets from fifty_demo

REQUIREMENTS:
- Full dartdoc comments on all public APIs
- Follow existing fifty_ui patterns (see FiftyButton, FiftyCard)
- Use FiftyTokens for all visual values
- Theme-aware via FiftyThemeExtension

VERIFICATION:
- flutter analyze packages/fifty_ui
- flutter analyze apps/fifty_demo
```

---

### Task 2B: Build BR-056

**Agent:** coder
**Brief:** BR-056 - Extract Speech Controls to fifty_speech_engine

**Instructions:**
```
Implement BR-056: Extract Speech Controls to fifty_speech_engine.

PLAN: Read ai/plans/BR-056-plan.md for implementation details.

CONTEXT:
- Working directory: /Users/m.elamin/StudioProjects/fifty_eco_system
- Coding guidelines: ai/context/coding_guidelines.md
- Follow MVVM + Actions architecture
- Callback-based API (no GetX dependencies)

KEY TASKS:
1. Create SpeechTtsControls in packages/fifty_speech_engine/lib/src/widgets/
2. Create SpeechSttControls in packages/fifty_speech_engine/lib/src/widgets/
3. Create SpeechControlsPanel in packages/fifty_speech_engine/lib/src/widgets/
4. Create widgets.dart barrel export
5. Add exports to packages/fifty_speech_engine/lib/fifty_speech_engine.dart
6. Update fifty_demo to use engine widgets
7. Remove old widgets from fifty_demo

REQUIREMENTS:
- Full dartdoc comments
- Callback-based API (ValueChanged<T>, VoidCallback)
- Use FiftyTokens for visual values
- Use fifty_ui components (FiftyButton, FiftySwitch, FiftySlider)

VERIFICATION:
- flutter analyze packages/fifty_speech_engine
- flutter analyze apps/fifty_demo
```

---

### Task 2C: Build BR-058

**Agent:** coder
**Brief:** BR-058 - Extract Audio Controls to fifty_audio_engine

**Instructions:**
```
Implement BR-058: Extract Audio Controls to fifty_audio_engine.

PLAN: Read ai/plans/BR-058-plan.md for implementation details.

CONTEXT:
- Working directory: /Users/m.elamin/StudioProjects/fifty_eco_system
- Coding guidelines: ai/context/coding_guidelines.md
- Follow MVVM + Actions architecture
- Callback-based API (no GetX dependencies)

KEY TASKS:
1. Create AudioControlsPanel in packages/fifty_audio_engine/lib/src/widgets/
2. Create widgets.dart barrel export
3. Add exports to packages/fifty_audio_engine/lib/fifty_audio_engine.dart
4. Update fifty_demo to use engine widget
5. Remove old widget from fifty_demo

REQUIREMENTS:
- Full dartdoc comments
- Callback-based API (ValueChanged<T>, VoidCallback)
- Use FiftyTokens for visual values
- Use fifty_ui components (FiftySwitch, FiftySlider)

VERIFICATION:
- flutter analyze packages/fifty_audio_engine
- flutter analyze apps/fifty_demo
```

---

## Phase 3: Building (Sequential - Group 2)

### Dependencies Met

- BR-055 must be complete (establishes fifty_ui patterns)

### Agent Invocation: CODER x 1

---

### Task 3A: Build BR-057

**Agent:** coder
**Brief:** BR-057 - Promote Utility Widgets to fifty_ui

**Instructions:**
```
Implement BR-057: Promote Utility Widgets to fifty_ui.

PLAN: Read ai/plans/BR-057-plan.md for implementation details.

CONTEXT:
- Working directory: /Users/m.elamin/StudioProjects/fifty_eco_system
- Coding guidelines: ai/context/coding_guidelines.md
- REFERENCE: BR-055 implementation for patterns
- Follow MVVM + Actions architecture

KEY TASKS:
1. Create FiftySettingsRow in packages/fifty_ui/lib/src/display/
2. Create FiftyInfoRow in packages/fifty_ui/lib/src/display/
3. Create FiftyNavPill in packages/fifty_ui/lib/src/controls/
4. Create FiftyLabeledIconButton in packages/fifty_ui/lib/src/buttons/
5. Create FiftyCursor in packages/fifty_ui/lib/src/utils/
6. Add all exports to appropriate barrel files
7. Update fifty_demo to import from fifty_ui
8. Remove duplicate widgets from fifty_demo

REQUIREMENTS:
- Full dartdoc comments
- Follow BR-055 patterns exactly
- Use FiftyTokens for all visual values
- Consolidate duplicate implementations

VERIFICATION:
- flutter analyze packages/fifty_ui
- flutter analyze apps/fifty_demo
```

---

## Phase 4: Testing

### Agent Invocation: TESTER x 1

---

### Task 4A: Test All Implementations

**Agent:** tester
**Brief:** All (BR-055, BR-056, BR-057, BR-058)

**Instructions:**
```
Test all component promotion implementations.

CONTEXT:
- Working directory: /Users/m.elamin/StudioProjects/fifty_eco_system

TEST COMMANDS:
1. flutter analyze packages/fifty_ui
2. flutter analyze packages/fifty_speech_engine
3. flutter analyze packages/fifty_audio_engine
4. flutter analyze apps/fifty_demo
5. cd apps/fifty_demo && flutter test

VERIFICATION CHECKLIST:

BR-055:
- [ ] FiftyStatusIndicator exists and exports correctly
- [ ] FiftySectionHeader exists and exports correctly
- [ ] No analyzer errors in fifty_ui
- [ ] fifty_demo compiles with new imports

BR-056:
- [ ] SpeechTtsControls exists and exports correctly
- [ ] SpeechSttControls exists and exports correctly
- [ ] SpeechControlsPanel exists and exports correctly
- [ ] No analyzer errors in fifty_speech_engine
- [ ] fifty_demo compiles with new imports

BR-057:
- [ ] FiftySettingsRow exists and exports correctly
- [ ] FiftyNavPill exists and exports correctly
- [ ] FiftyLabeledIconButton exists and exports correctly
- [ ] FiftyInfoRow exists and exports correctly
- [ ] FiftyCursor exists and exports correctly
- [ ] No analyzer errors in fifty_ui
- [ ] fifty_demo compiles with new imports

BR-058:
- [ ] AudioControlsPanel exists and exports correctly
- [ ] No analyzer errors in fifty_audio_engine
- [ ] fifty_demo compiles with new imports

OVERALL:
- [ ] All existing tests pass
- [ ] No runtime errors on app launch
```

---

## Phase 5: Review

### Agent Invocation: REVIEWER x 1

---

### Task 5A: Review All Implementations

**Agent:** reviewer
**Brief:** All (BR-055, BR-056, BR-057, BR-058)

**Instructions:**
```
Review all component promotion implementations.

CONTEXT:
- Working directory: /Users/m.elamin/StudioProjects/fifty_eco_system
- Coding guidelines: ai/context/coding_guidelines.md

REVIEW CHECKLIST:

Architecture:
- [ ] Components follow FDL consumption pattern (not self-contained theming)
- [ ] Callback-based APIs (no ViewModel dependencies in engine widgets)
- [ ] Proper barrel exports in each package

Code Quality:
- [ ] Full dartdoc comments on all public APIs
- [ ] Consistent naming conventions
- [ ] FiftyTokens used for all visual values
- [ ] No hardcoded colors, spacing, typography

Migration:
- [ ] Old widgets removed from fifty_demo
- [ ] Imports updated throughout fifty_demo
- [ ] No orphaned files

Completeness:
- [ ] All acceptance criteria from briefs met
- [ ] No TODO comments left behind
- [ ] All files properly formatted

OUTPUT: APPROVE or REJECT with feedback
```

---

## Phase 6: Commit

### Agent: Orchestrator (Main Agent)

**If APPROVED:**

```bash
# Commit BR-055
git add packages/fifty_ui/lib/src/display/fifty_status_indicator.dart
git add packages/fifty_ui/lib/src/display/fifty_section_header.dart
git add packages/fifty_ui/lib/src/display/display.dart
git add packages/fifty_ui/lib/fifty_ui.dart
git add apps/fifty_demo/
git commit -m "feat(fifty_ui): add FiftyStatusIndicator and FiftySectionHeader

- Promote StatusIndicator from fifty_demo to fifty_ui
- Promote SectionHeader from fifty_demo to fifty_ui
- Update fifty_demo to use new components
- Remove old shared widgets

closes #BR-055"

# Commit BR-056
git add packages/fifty_speech_engine/lib/src/widgets/
git add packages/fifty_speech_engine/lib/fifty_speech_engine.dart
git add apps/fifty_demo/
git commit -m "feat(fifty_speech_engine): add speech control widgets

- Add SpeechTtsControls for TTS settings
- Add SpeechSttControls for STT controls
- Add SpeechControlsPanel combining both
- Update fifty_demo to use engine widgets

closes #BR-056"

# Commit BR-057
git add packages/fifty_ui/lib/src/
git add apps/fifty_demo/
git commit -m "feat(fifty_ui): add utility widgets

- Add FiftySettingsRow for settings toggles
- Add FiftyNavPill for navigation pills
- Add FiftyLabeledIconButton for icon+label buttons
- Add FiftyInfoRow for key-value display
- Add FiftyCursor for blinking cursor animation
- Consolidate duplicate widgets from fifty_demo

closes #BR-057"

# Commit BR-058
git add packages/fifty_audio_engine/lib/src/widgets/
git add packages/fifty_audio_engine/lib/fifty_audio_engine.dart
git add apps/fifty_demo/
git commit -m "feat(fifty_audio_engine): add AudioControlsPanel widget

- Extract audio controls from fifty_demo
- Callback-based API for BGM/SFX toggles
- Optional volume sliders
- Update fifty_demo to use engine widget

closes #BR-058"
```

---

## Update Brief Statuses

After successful commits:

1. Update BR-055 status to "Done"
2. Update BR-056 status to "Done"
3. Update BR-057 status to "Done"
4. Update BR-058 status to "Done"
5. Update CURRENT_SESSION.md

---

## Fault Tolerance

### Retry Strategy

| Phase | Max Retries | Backoff |
|-------|-------------|---------|
| Planning | 2 | 0s |
| Building | 3 | 1s, 2s, 4s |
| Testing | 3 | 1s |
| Review | 2 | 0s |

### Failure Modes

**Planning Failure:**
- Retry with more context
- Fallback: Orchestrator creates minimal plan

**Build Failure:**
- Invoke debugger to diagnose
- Retry with fixes
- Max 3 attempts before BLOCKED state

**Test Failure:**
- Identify failing tests
- Invoke coder to fix
- Retry tests
- Max 3 attempts before BLOCKED state

**Review Rejection:**
- Invoke coder with reviewer feedback
- Retry review
- Max 2 attempts before BLOCKED state

### Recovery Points

Checkpoints are saved after each phase:
- `ai/session/checkpoints/phase1-planning.json`
- `ai/session/checkpoints/phase2-building.json`
- `ai/session/checkpoints/phase3-building.json`
- `ai/session/checkpoints/phase4-testing.json`
- `ai/session/checkpoints/phase5-review.json`

---

## Estimated Timeline

| Phase | Duration | Notes |
|-------|----------|-------|
| Planning | 5-10 min | Parallel execution |
| Building (Group 1) | 15-20 min | Parallel (3 briefs) |
| Building (Group 2) | 10-15 min | Sequential (1 brief) |
| Testing | 5-10 min | Single pass |
| Review | 5-10 min | Single pass |
| Commit | 2-5 min | 4 commits |

**Total estimated time:** 45-70 minutes

---

**Blueprint ready for execution.**
