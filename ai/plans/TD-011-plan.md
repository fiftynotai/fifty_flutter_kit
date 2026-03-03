# Implementation Plan: TD-011

**Complexity:** L
**Estimated Duration:** 1.5 days (12-14 files, mostly rewrite work)
**Risk Level:** Low (documentation only, no code changes)

---

## Summary

Rewrite 13 of 15 package READMEs to follow the gold-standard selling-points-first structure established by fifty_tokens and fifty_theme. fifty_ui and fifty_scroll_sequence are partial rewrites; fifty_audio_engine and fifty_printing_engine are close to compliant but need restructuring. The four builder-pattern packages (achievement_engine, speech_engine, forms, connectivity) need prominent customization sections added. Simpler infrastructure packages (utils, cache, storage, socket, narrative_engine, world_engine) need a "Why This Package" section and structural reordering.

---

## Gold Standard Template

Derived from `packages/fifty_tokens/README.md` and `packages/fifty_theme/README.md`.

### Standard README Structure

```
# Package Name

[Badges]

**[One-line selling-point tagline in bold.]**

[2-3 sentence description that expands on the value, mentions the ecosystem fit.]
Part of [Fifty Flutter Kit](link).

---

## Why [PackageName]

- **[Benefit 1 bold]** -- [explanation]
- **[Benefit 2 bold]** -- [explanation]
- **[Benefit 3 bold]** -- [explanation]
(3-5 bullets, each starting with a benefit name, not a feature name)

---

## Quick Start

### Installation
[yaml snippet]
[monorepo path snippet]
**Dependencies:** [list]

### Use
[Minimal working code snippet -- get something running in <10 lines]

---

## Customization / Configuration
[This section MUST appear before API Reference]
[Show how to customize behavior -- builders, config objects, overrides]
[Multiple code snippets for common customization scenarios]

---

## [Domain-specific section -- e.g., "Presets", "Strategies", "Widgets"]

---

## API Reference
[Full API tables and descriptions]

---

## Usage Patterns
[Realistic code snippets for common scenarios]

---

## Platform Support
[Table]

---

## [Ecosystem integration section]

---

## Version
**Current:** X.Y.Z

---

## License
```

### Key Rules from Gold Standards

1. The tagline in bold immediately follows the badges -- one sentence, sells the package.
2. "Why [Package]" section uses benefit-led bullets (not feature-list bullets). Compare:
   - BAD: "Multi-step forms with wizard navigation" (feature)
   - GOOD: "Skip the scaffold" -- handles step validation, nav, and state so you build step content only" (benefit)
3. Customization appears as a named section BEFORE the API Reference.
4. Quick Start shows working code in <10 lines.
5. No "Features" list that duplicates what "Why" says.
6. Version number must be accurate.

---

## Per-Package Audit Results

### fifty_tokens -- DONE (gold standard)
- Leads with selling points: YES
- Customization early: YES (appears at section 4)
- Status: Skip

### fifty_theme -- DONE (gold standard)
- Leads with selling points: YES ("The Pipeline" diagram + brand config first)
- Customization early: YES ("Brand Configuration" is section 3)
- Status: Skip

### fifty_ui
- Leads with selling points: NO -- opens with "FDL-styled Flutter component library implementing..." (description, not benefit) then jumps straight to a screenshot table and a Features list
- Customization early: NO -- "Theming" section appears on line 648 (near the bottom of API Reference)
- Current structure: badges -> tagline -> screenshots -> Features list -> Installation -> Quick Start -> Architecture tree -> API Reference (by widget category, very long) -> Theming section (buried) -> Platform Support -> FDL Integration -> Version
- Issues:
  - No "Why fifty_ui?" benefit section
  - "Theming" (how widgets adapt to your colorScheme, using FiftyThemeExtension) is buried at the very end of API Reference
  - Features list is feature-centric, not benefit-centric
  - Good content exists; needs restructuring rather than full rewrite
- Effort: M (restructure + add Why section + move Theming up)

### fifty_connectivity
- Leads with selling points: NO -- opens with "Network connectivity monitoring with intelligent reachability probing (DNS/HTTP)" which is a description, not a benefit pitch
- Customization early: NO -- Configuration section appears at line 237, after Architecture and a full API reference block. Builder callback (contentBuilder on ConnectivityCheckerSplash -- FR-004) is MISSING entirely.
- Current structure: badges -> tagline -> screenshots -> Features list -> Installation -> Quick Start -> Architecture -> API Reference -> Configuration -> Usage Patterns -> Platform Support -> FDL Integration -> Version
- Issues:
  - No "Why fifty_connectivity?" section
  - Features list is fine but not benefit-led
  - contentBuilder on ConnectivityCheckerSplash (FR-004) is completely absent
  - SplashConnectivityState enum is absent
  - logoBuilder mention exists in ConnectivityConfig but the broader customization story is missing
  - Configuration is buried after 6 sections of API reference
- Effort: M (add Why, add builder section, move customization earlier)

### fifty_forms
- Leads with selling points: NO -- "Production-ready form building with validation, multi-step wizards, and draft persistence" is a description
- Customization early: NO -- FiftyFormArray has an `addButtonBuilder` mentioned late in config tables. The four FR-003 builders (navigationBuilder, contentBuilder x2, buttonBuilder) are MISSING entirely.
- Current structure: badges -> tagline -> screenshots -> Features list -> Installation -> Quick Start -> Architecture -> API Reference (very long) -> Configuration -> Usage Patterns -> Platform Support -> FDL Integration -> Version
- Issues:
  - No "Why fifty_forms?" section
  - FR-003 builders entirely absent: FiftyMultiStepForm.navigationBuilder, FiftyValidationSummary.contentBuilder, FiftyFormProgress.contentBuilder, FiftySubmitButton.buttonBuilder
  - Customization story (builders + DraftManager + async validators) is scattered throughout API Reference
  - FiftyMultiStepForm config table (line 316) lacks navigationBuilder
  - FiftySubmitButton usage (line 558) has no mention of buttonBuilder
- Effort: M (add Why, add Customization section with all 4 builders, move builders into relevant API descriptions)

### fifty_achievement_engine
- Leads with selling points: NO -- "Achievement system for Flutter games with condition-based unlocks, progress tracking, and FDL-compliant UI" is a description
- Customization early: NO -- Widget customization only mentioned at bottom of FDL Integration section (line 457) as a tiny snippet with `backgroundColor`/`borderColor`. The 5 FR-001 builders are MISSING entirely.
- Current structure: badges -> tagline -> screenshots -> Features list -> Installation -> Quick Start -> Architecture -> API Reference (Widgets at line 282) -> Usage Patterns -> Platform Support -> FDL Integration (with tiny color override note) -> Version
- Issues:
  - No "Why fifty_achievement_engine?" section
  - FR-001 builders entirely absent: AchievementCard.contentBuilder, AchievementList.itemBuilder, AchievementSummary.contentBuilder, AchievementPopup.contentBuilder, AchievementProgressBar.barBuilder
  - Color overrides mentioned but not the builder API
  - rarityColors Map param (AC-005) also absent
- Effort: M (add Why, add Customization section with all 5 builders + rarity colors)

### fifty_speech_engine
- Leads with selling points: NO -- "A unified speech interface for Flutter games and applications with TTS and STT capabilities" is a description
- Customization early: NO -- No customization section at all. FR-002 builders are MISSING entirely.
- Current structure: badges -> tagline -> screenshots -> Features list -> Installation -> Quick Start -> Architecture -> API Reference -> Usage Patterns -> Platform Support (with detailed platform config) -> FDL Integration -> Version
- Issues:
  - No "Why fifty_speech_engine?" section
  - FR-002 builders entirely absent: SpeechTtsControls.contentBuilder, SpeechSttControls.contentBuilder, SpeechControlsPanel.ttsBuilder/sttBuilder
  - SpeechTtsState and SpeechSttState data classes absent
  - The widgets section is completely absent -- only FiftySpeechEngine, TtsManager, SttManager, SpeechResultModel are documented (the UI layer is undocumented)
- Effort: L (add Why, add Widgets section covering 3 widgets, add Customization section with all builders + state data classes)

### fifty_skill_tree
- Leads with selling points: NO -- "Interactive skill tree widget for Flutter games -- customizable, animated, and game-ready" touches on "customizable" but buries the pitch
- Customization early: PARTIAL -- SkillTreeTheme section appears at line 270 (before Usage Patterns) but `nodeBuilder` on SkillTreeView (the key customization) is buried at line 540
- Current structure: badges -> tagline -> screenshots -> Features list -> Installation -> Quick Start (3 steps) -> Architecture -> API Reference -> Usage Patterns (nodeBuilder is here at line 540) -> Platform Support -> FDL Integration -> Version
- Issues:
  - No "Why fifty_skill_tree?" section
  - nodeBuilder is buried at the bottom of Usage Patterns instead of in a Customization section
  - Theme customization (SkillTreeTheme) is in API Reference but not framed as "here's how to customize the look"
  - SkillTreeTheme.fromContext(BuildContext) factory (AC-005) needs to be checked
- Effort: S-M (add Why, add Customization section pulling nodeBuilder + theme up, restructure)

### fifty_audio_engine
- Leads with selling points: NO -- "A modular, reactive audio system for Flutter games and applications" is a description
- Customization early: PARTIAL -- FadePreset and ChannelLifecycleConfig appear in Configuration (line 349), which is reasonably early. Source swapping is in Usage Patterns (line 428).
- Current structure: badges -> tagline -> screenshots -> Features list -> Installation -> Quick Start -> Architecture -> API Reference (channels) -> Configuration (FadePreset, LifecycleConfig) -> Usage Patterns -> Platform Support -> FDL Integration -> Version
- Issues:
  - No "Why fifty_audio_engine?" section
  - Features list is fine but not benefit-led
  - "Source Swapping" capability (change how paths resolve at runtime) is buried in Usage Patterns
  - The three-channel architecture is a key differentiator not sold in opening
  - Content is otherwise good and structured well
- Effort: S (add Why section, minor restructuring)

### fifty_narrative_engine
- Leads with selling points: NO -- "A sentence processing engine for Flutter games and interactive applications" is a description; unclear value immediately
- Customization early: NO -- No customization section. NarrativeInterpreter callbacks (onRead, onWrite, onAsk, onNavigate, onWait) ARE the customization point and appear in API Reference (line 250), but are not framed as "this is how you customize behavior"
- Current structure: badges -> tagline -> screenshots -> Features list -> Installation -> Quick Start (4 steps) -> Architecture -> API Reference -> Usage Patterns -> Platform Support -> FDL Integration -> Migration Guide -> Version
- Issues:
  - No "Why fifty_narrative_engine?" section
  - The "customization story" is really the interpreter callback system -- not framed as such
  - The package is niche (VN/narrative games); the selling point (complete sentence execution pipeline with pluggable handlers) needs to be front-and-center
  - Good migration guide, good API docs
- Effort: S (add Why, reframe interpreter callbacks as the customization API)

### fifty_world_engine
- Leads with selling points: NO -- "Flame-based interactive grid map rendering for Flutter games" is a description
- Customization early: NO -- Custom entity types (FiftyEntitySpawner.register) are in a Usage Patterns section at line 637. The SkillTreeTheme equivalent (visual customization) doesn't exist -- customization is purely through entity types.
- Current structure: badges -> tagline -> single screenshot -> Features list -> Installation -> Quick Start -> Architecture -> API Reference (very long, comprehensive) -> Configuration -> Usage Patterns -> Platform Support -> FDL Integration -> Version
- Issues:
  - No "Why fifty_world_engine?" section
  - Custom entity type registration is the extensibility hook -- buried at the bottom of Usage Patterns
  - JSON map loading is a selling point not led with
  - API Reference is good and comprehensive
- Effort: S (add Why, pull custom entity types up to a Customization section)

### fifty_printing_engine
- Leads with selling points: NO -- "Production-grade multi-printer ESC/POS printing with Bluetooth and WiFi support" is actually reasonably descriptive but not benefit-led
- Customization early: NO -- Three printing strategies (the key customization) appear at line 263 as API reference entries. SelectPerPrintStrategy (with the selection callback -- the customization hook) is at line 299.
- Current structure: badges -> tagline -> screenshots -> Features list -> Installation -> Quick Start -> Architecture -> API Reference (very detailed) -> Configuration -> Usage Patterns -> Platform Support (with platform-specific setup) -> FDL Integration -> Version
- Issues:
  - No "Why fifty_printing_engine?" section
  - Three routing strategies are a key differentiator -- not led with
  - Auto-connect (a key selling point for reliability) mentioned in features but not in a benefit section
  - Paper size auto-conversion is buried in Configuration
  - Storage-agnostic persistence is a differentiation not highlighted
  - Content is very comprehensive; needs better framing
- Effort: S-M (add Why, add Customization section pulling strategies + callbacks up)

### fifty_socket
- Leads with selling points: NO -- "Phoenix WebSocket infrastructure with auto-reconnect, heartbeat monitoring, and channel management" is a description
- Customization early: NO -- ReconnectConfig and HeartbeatConfig are in Configuration (line 239), reasonably early. But the abstract base class pattern (extend SocketService = the customization model) is explained in Quick Start rather than as a selling point.
- Current structure: badges -> tagline -> screenshots -> Features list -> Installation -> Quick Start -> Architecture -> API Reference -> Configuration -> Error Handling -> Reconnection Methods -> Usage Patterns -> Platform Support -> FDL Integration -> Version
- Issues:
  - No "Why fifty_socket?" section
  - The "extend SocketService" pattern is the key value proposition and customization model, but described in Quick Start as implementation detail rather than as a selling point
  - ReconnectConfig/HeartbeatConfig customization is visible but not framed as "here's how you tune it"
- Effort: S (add Why, minor structural adjustment to frame extensibility)

### fifty_utils
- Leads with selling points: NO -- "Pure Dart/Flutter utilities" is generic; the tagline doesn't sell the individual utilities' value
- Customization early: YES-ISH -- No customization to speak of (it's a utility library). ResponsiveUtils.mobileBreakpoint is mentioned in the API section.
- Current structure: badges -> tagline -> Features list -> Installation -> Quick Start -> Architecture -> API Reference -> Usage Patterns -> Platform Support -> FDL Integration -> Version
- Issues:
  - No "Why fifty_utils?" section
  - Features list is fine but not benefit-led
  - The `apiFetch` stream-based async state is actually a strong selling point, not mentioned up front
  - No screenshots (appropriate for utility library)
- Effort: S (add Why section -- this is a small but real improvement)

### fifty_cache
- Leads with selling points: NO -- "TTL-based HTTP response caching with pluggable stores and policies" is a description
- Customization early: YES -- "Contract-based design" is first bullet in Features, and custom store/policy examples appear in Usage Patterns. This is the best non-gold-standard README for customization surfacing.
- Current structure: badges -> tagline -> Features list -> Installation -> Quick Start -> Architecture -> API Reference -> Usage Patterns (with custom store/policy examples) -> Platform Support -> FDL Integration -> Version
- Issues:
  - No "Why fifty_cache?" section
  - Features list is fairly benefit-like ("Swap implementations without changing client code")
  - Good structure otherwise; mainly needs a Why section
- Effort: XS (add Why section, minor polish)

### fifty_storage
- Leads with selling points: NO -- "Secure token storage and preferences management for Flutter apps" is a description
- Customization early: NO -- The contract-based design (TokenStorage interface) is mentioned in Features and Architecture but not surfaced as "here's how you test/swap implementations"
- Current structure: badges -> tagline -> Features list -> Installation -> Quick Start -> Architecture -> API Reference -> Usage Patterns -> Platform Support -> FDL Integration -> Version
- Issues:
  - No "Why fifty_storage?" section
  - Synchronous reads (in-memory cache after initialize) is a real selling point, buried in Usage Patterns
  - Testing with mocks pattern is at the very end of Usage Patterns
- Effort: S (add Why section, pull synchronous reads and testing pattern earlier)

### fifty_scroll_sequence
- Leads with selling points: PARTIAL -- "Scroll-driven image sequences for Flutter. Apple-style frame scrubbing mapped to scroll position." is actually good -- names the benefit and the reference product
- Customization early: PARTIAL -- `builder` overlay is shown early in Quick Start (pinned mode example). But FrameLoader (the extensibility hook) and PreloadStrategy selection are in API Reference without a "Customization" section header.
- Current structure: badges -> tagline -> screenshots -> Features list -> Installation -> Quick Start (4 examples) -> Architecture -> API Reference (very thorough) -> Frame Preparation Guide -> Usage Patterns -> Platform Support -> FDL Integration -> Version -> License
- Issues:
  - No "Why fifty_scroll_sequence?" section -- the opening tagline is good but the "Why" section with benefit bullets is missing
  - Custom FrameLoader (extensibility) and PreloadStrategy selection are not grouped under a Customization section
  - The frame preparation guide (ffmpeg commands) is placed between API Reference and Usage Patterns -- should be later or in a separate section
  - Content is excellent and thorough; mainly needs structural improvement
- Effort: S (add Why section, add Customization section grouping FrameLoader + PreloadStrategy + builder)

---

## Builder Pattern Highlights to Add

These sections are MISSING from their respective READMEs and must be added as a "Customization" section (before API Reference).

### fifty_achievement_engine -- Builder Customization

```dart
// Replace AchievementCard's inner content
AchievementCard(
  achievement: myAchievement,
  progress: 0.75,
  state: AchievementState.available,
  contentBuilder: (context, achievement, progress, state) {
    return MyCustomCardContent(achievement: achievement);
  },
)

// Replace AchievementList item rendering
AchievementList(
  controller: controller,
  itemBuilder: (context, achievement, progress, state) {
    return MyAchievementRow(achievement: achievement, progress: progress);
  },
)

// Replace AchievementProgressBar fill
AchievementProgressBar(
  progress: 0.75,
  barBuilder: (context, progress) {
    return LinearProgressIndicator(value: progress, color: Colors.amber);
  },
)

// Replace AchievementSummary and AchievementPopup inner content similarly
// via contentBuilder -- all builders are optional; omit for default FDL UI.
```

Also add rarityColors customization:
```dart
AchievementCard(
  achievement: myAchievement,
  rarityColors: {
    AchievementRarity.common: Colors.grey,
    AchievementRarity.uncommon: Colors.green,
  },
)
```

### fifty_speech_engine -- Builder Customization

First, document the widgets that are currently absent from the README:

**Widgets (undocumented -- must be added):**
- `SpeechTtsControls` -- TTS playback controls widget
- `SpeechSttControls` -- STT recording controls widget
- `SpeechControlsPanel` -- Combined TTS+STT panel

Then add the Customization section:

```dart
// Replace TTS controls UI, keep all state management
SpeechTtsControls(
  engine: engine,
  contentBuilder: (context, state) {
    // state is SpeechTtsState -- isSpeaking, currentText, etc.
    return MyTtsControls(
      isSpeaking: state.isSpeaking,
      onSpeak: () => engine.speak('Hello'),
      onStop: engine.stopSpeaking,
    );
  },
)

// Replace STT controls UI, keep recording logic
SpeechSttControls(
  engine: engine,
  contentBuilder: (context, state) {
    // state is SpeechSttState -- isListening, lastResult, etc.
    return MyMicButton(isListening: state.isListening);
  },
)

// Customize one or both panels
SpeechControlsPanel(
  engine: engine,
  ttsBuilder: (context, state) => MyTtsUI(state: state),
  sttBuilder: (context, state) => MySttUI(state: state),
)
```

### fifty_forms -- Builder Customization

```dart
// Custom navigation buttons for multi-step form
FiftyMultiStepForm(
  controller: controller,
  steps: mySteps,
  stepBuilder: (context, index, step) => MyStepContent(step: step),
  onComplete: (values) => submit(values),
  navigationBuilder: (context, isFirstStep, isLastStep, isSubmitting, onNext, onPrevious) {
    return Row(
      children: [
        if (!isFirstStep)
          TextButton(onPressed: onPrevious, child: const Text('Back')),
        ElevatedButton(
          onPressed: isSubmitting ? null : onNext,
          child: Text(isLastStep ? 'Submit' : 'Continue'),
        ),
      ],
    );
  },
)

// Custom submit button
FiftySubmitButton(
  controller: controller,
  label: 'SAVE',
  onPressed: () => controller.submit(save),
  buttonBuilder: (context, isLoading, isEnabled, onPressed) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      child: ElevatedButton(
        onPressed: isEnabled ? onPressed : null,
        child: isLoading ? SpinnerWidget() : const Text('SAVE'),
      ),
    );
  },
)

// Custom validation summary
FiftyValidationSummary(
  controller: controller,
  contentBuilder: (context, errors) {
    return Column(
      children: errors.entries
          .map((e) => Text('${e.key}: ${e.value}', style: errorStyle))
          .toList(),
    );
  },
)

// Custom progress indicator
FiftyFormProgress(
  controller: controller,
  steps: mySteps,
  contentBuilder: (context, steps, currentIndex) {
    return MyProgressDots(total: steps.length, current: currentIndex);
  },
)
```

### fifty_connectivity -- Builder Customization

```dart
// Custom splash screen per connectivity state
ConnectivityCheckerSplash(
  nextRouteName: '/home',
  contentBuilder: (context, state, retry) {
    return switch (state) {
      SplashConnectivityState.checking => const CheckingWidget(),
      SplashConnectivityState.connected => const ConnectedWidget(),
      SplashConnectivityState.failed => FailedWidget(onRetry: retry),
    };
  },
)

// When contentBuilder is provided, logoBuilder is ignored.
// Scaffold + Center wrapping stays widget-owned.
```

---

## Execution Order (Grouped by Effort)

### Group 1: XS/S -- Quick wins (add Why section, minimal restructuring)
Estimated: 4-5 hours total

1. **fifty_cache** -- Add "Why fifty_cache?" section. Minor. 20 min.
2. **fifty_utils** -- Add "Why fifty_utils?" section. Minor. 20 min.
3. **fifty_socket** -- Add "Why fifty_socket?" section + reframe extensibility. 30 min.
4. **fifty_storage** -- Add "Why fifty_storage?", surface synchronous reads + testing pattern. 30 min.
5. **fifty_audio_engine** -- Add "Why fifty_audio_engine?" + source swapping under Customization. 45 min.
6. **fifty_narrative_engine** -- Add "Why fifty_narrative_engine?", reframe interpreter callbacks as Customization. 45 min.
7. **fifty_world_engine** -- Add "Why fifty_world_engine?", add Customization section (custom entity types). 45 min.
8. **fifty_scroll_sequence** -- Add "Why fifty_scroll_sequence?", add Customization section (FrameLoader + PreloadStrategy + builder). 45 min.

### Group 2: S-M -- Structural rewrites (add Why + new Customization section + restructure)
Estimated: 3-4 hours total

9. **fifty_skill_tree** -- Add "Why fifty_skill_tree?", add Customization section (nodeBuilder + SkillTreeTheme), restructure. 60 min.
10. **fifty_printing_engine** -- Add "Why fifty_printing_engine?", add Customization section (3 strategies + callbacks), restructure. 75 min.
11. **fifty_ui** -- Add "Why fifty_ui?", move Theming section up to before API Reference, restructure. 75 min.

### Group 3: M -- Significant rewrites (add Why + missing widget docs + new Customization section)
Estimated: 5-6 hours total

12. **fifty_connectivity** -- Add "Why fifty_connectivity?", add Customization section with FR-004 builder + SplashConnectivityState, update ConnectivityCheckerSplash API docs. 90 min.
13. **fifty_forms** -- Add "Why fifty_forms?", add Customization section with all 4 FR-003 builders, update API docs for navigationBuilder + buttonBuilder + contentBuilder x2. 90 min.
14. **fifty_achievement_engine** -- Add "Why fifty_achievement_engine?", add Customization section with all 5 FR-001 builders + rarityColors, update widget API docs. 90 min.
15. **fifty_speech_engine** -- Add "Why fifty_speech_engine?", add Widgets section (3 widgets currently undocumented), add Customization section with all FR-002 builders + SpeechTtsState/SpeechSttState. 120 min.

---

## Implementation Steps

### Phase 1: Template Definition and Quick Wins (Groups 1)

1. Write the standard README template as the authoritative reference (it is defined above in this plan; FORGER should use this plan as the reference).
2. Apply to fifty_cache -- add "Why fifty_cache?" with 3-4 benefit bullets.
3. Apply to fifty_utils -- add "Why fifty_utils?" with benefit bullets, highlight `apiFetch`.
4. Apply to fifty_socket -- add "Why fifty_socket?", reframe `SocketService` extension as the Customization story.
5. Apply to fifty_storage -- add "Why fifty_storage?", add Customization section showing TokenStorage mock swap.
6. Apply to fifty_audio_engine -- add "Why fifty_audio_engine?", add Customization section (FadePreset, ChannelLifecycleConfig, source swapping).
7. Apply to fifty_narrative_engine -- add "Why fifty_narrative_engine?", add Customization section (NarrativeInterpreter callbacks as the customization points).
8. Apply to fifty_world_engine -- add "Why fifty_world_engine?", add Customization section (FiftyEntitySpawner.register).
9. Apply to fifty_scroll_sequence -- add "Why fifty_scroll_sequence?", add Customization section (FrameLoader, PreloadStrategy, builder overlay).

### Phase 2: Structural Rewrites (Group 2)

10. fifty_skill_tree -- add "Why fifty_skill_tree?", add Customization section pulling nodeBuilder + SkillTreeTheme out of API Reference / Usage Patterns.
11. fifty_printing_engine -- add "Why fifty_printing_engine?", add Customization section (PrintingStrategy + SelectPerPrint callback + paper size regenerator).
12. fifty_ui -- add "Why fifty_ui?", move "Theming" section to between "Customization" and "API Reference", restructure opening.

### Phase 3: Builder-Pattern Packages (Group 3)

13. fifty_connectivity -- add "Why fifty_connectivity?", add Customization section (contentBuilder + SplashConnectivityState enum + logoBuilder note), update ConnectivityCheckerSplash API documentation.
14. fifty_forms -- add "Why fifty_forms?", add Customization section (all 4 builder callbacks), update FiftyMultiStepForm config table to add navigationBuilder, update FiftySubmitButton usage to show buttonBuilder.
15. fifty_achievement_engine -- add "Why fifty_achievement_engine?", add Customization section (all 5 builder callbacks + rarityColors), update widget API docs.
16. fifty_speech_engine -- add "Why fifty_speech_engine?", add Widgets section documenting SpeechTtsControls, SpeechSttControls, SpeechControlsPanel, add Customization section (all builders + SpeechTtsState/SpeechSttState data classes).

### Phase 4: Version Number Audit

17. Verify all version numbers match the actual pubspec.yaml version for each package.

---

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `packages/fifty_cache/README.md` | MODIFY | Add "Why fifty_cache?" section |
| `packages/fifty_utils/README.md` | MODIFY | Add "Why fifty_utils?" section |
| `packages/fifty_socket/README.md` | MODIFY | Add "Why fifty_socket?" section + Customization section |
| `packages/fifty_storage/README.md` | MODIFY | Add "Why fifty_storage?" section + Customization section |
| `packages/fifty_audio_engine/README.md` | MODIFY | Add "Why fifty_audio_engine?" section + Customization section |
| `packages/fifty_narrative_engine/README.md` | MODIFY | Add "Why fifty_narrative_engine?" section + Customization section |
| `packages/fifty_world_engine/README.md` | MODIFY | Add "Why fifty_world_engine?" section + Customization section |
| `packages/fifty_scroll_sequence/README.md` | MODIFY | Add "Why fifty_scroll_sequence?" section + Customization section |
| `packages/fifty_skill_tree/README.md` | MODIFY | Add "Why fifty_skill_tree?" section + Customization section (nodeBuilder + theme) |
| `packages/fifty_printing_engine/README.md` | MODIFY | Add "Why fifty_printing_engine?" section + Customization section (strategies) |
| `packages/fifty_ui/README.md` | MODIFY | Add "Why fifty_ui?" section + move Theming up + restructure opening |
| `packages/fifty_connectivity/README.md` | MODIFY | Add "Why fifty_connectivity?" + Customization section (FR-004 builder) + update ConnectivityCheckerSplash API |
| `packages/fifty_forms/README.md` | MODIFY | Add "Why fifty_forms?" + Customization section (4 FR-003 builders) + update widget API docs |
| `packages/fifty_achievement_engine/README.md` | MODIFY | Add "Why fifty_achievement_engine?" + Customization section (5 FR-001 builders + rarityColors) + update widget docs |
| `packages/fifty_speech_engine/README.md` | MODIFY | Add "Why fifty_speech_engine?" + Widgets section + Customization section (FR-002 builders + state classes) |

---

## "Why" Section Content Guidance

FORGER should write benefit-led bullets using this framing guide. A benefit bullet has the form:
- **[Name of the benefit]** -- [one sentence explaining the practical value to the developer]

### fifty_cache
- **Drop-in anywhere** -- No HTTP client dependency; works with Dio, GetConnect, or plain dart:http.
- **Swap implementations without touching call sites** -- CacheStore, CachePolicy, and CacheKeyStrategy are interfaces; mock in tests, swap for Redis in production.
- **Survive hot restarts** -- GetStorageCacheStore persists cache across app restarts; MemoryCacheStore clears on restart for clean development.
- **Locale and auth aware** -- DefaultCacheKeyStrategy encodes Accept-Language and Authorization presence into keys so different users and locales get distinct cache entries.

### fifty_utils
- **No boilerplate for common tasks** -- DateTime relative time, Duration formatting, Color hex parsing, and responsive breakpoints in one import.
- **Type-safe async state** -- ApiResponse<E> and apiFetch stream loading/success/error states without mutable booleans or nullable fields.
- **Responsive layouts in one line** -- ResponsiveUtils.valueByDevice() returns the right value for mobile, tablet, desktop, or wide without if-else chains.
- **Pure Dart, no platform code** -- Works on every Flutter target including web and desktop.

### fifty_socket
- **Everything handled for you** -- Auto-reconnect with exponential backoff, heartbeat watchdog for silent disconnects, and channel auto-restoration on reconnect, all in the base class.
- **Extend once, cover all cases** -- Override getWebSocketUrl() and you get all reconnect, heartbeat, and channel management infrastructure for free.
- **Typed error stream** -- SocketErrorType enum (connection/auth/channel/message/timeout) lets you handle each failure mode with a switch instead of string parsing.
- **Safe by default** -- Subscription guards prevent duplicate channel joins when Phoenix emits multiple connected events.

### fifty_storage
- **Platform-native security, zero config** -- Tokens go to Android Keystore, iOS Keychain, or Windows Credentials automatically; you call setAccessToken(), the OS handles the rest.
- **Synchronous reads in hot paths** -- Tokens are cached in-memory after initialize(); your HTTP interceptor can call accessToken synchronously without blocking.
- **Contract-based for testing** -- TokenStorage is an interface; inject a mock in tests without touching platform secure storage.
- **Single initialize() call** -- AppStorageService handles both preferences and secure tokens from one entry point before runApp().

### fifty_audio_engine
- **Three purpose-built channels** -- BGM for crossfading playlists, SFX for pooled low-latency playback, Voice for BGM-ducking narration. One engine, three audio roles.
- **Persistent by default** -- Volume settings and playlist position survive app restarts via GetStorage; no manual serialization needed.
- **FiftyMotion-aligned fades** -- FadePreset durations map directly to FDL motion tokens (fast/panel/normal/cinematic); audio transitions feel in sync with UI animations.
- **No boilerplate lifecycle** -- ChannelLifecycleConfig auto-pauses BGM on app background and resumes on foreground with the right fade curve.

### fifty_narrative_engine
- **Sequential execution, not manual state** -- NarrativeQueue handles sentence ordering and NarrativeEngine controls the processing state machine; you write handlers, not flow logic.
- **Pluggable instruction set** -- NarrativeInterpreter delegates read/write/ask/wait/navigate to your callbacks; add TTS, custom dialogs, or screen transitions in a few lines.
- **Idempotent rendering** -- SafeNarrativeWriter deduplicates sentences so re-processing a queue never shows the same sentence twice.
- **Drop into any architecture** -- No GetX, no Flutter widgets required; pure Dart callbacks work with any state management system.

### fifty_world_engine
- **Game-ready grid maps without custom renderers** -- Sprite tiles, entity hierarchy, pan/zoom, and tap callbacks built on Flame; no raw canvas work needed.
- **Design data, not code** -- Define maps as JSON and load them with FiftyWorldLoader; level designers work in data, not Dart.
- **Extend entity types in one call** -- FiftyEntitySpawner.register() adds any custom game entity type without modifying engine source.
- **Safe controller pattern** -- FiftyWorldController is a no-op until bound; call any method before the game loads without null guards.

### fifty_scroll_sequence
- **Apple-quality frame scrubbing in ten lines** -- Scroll position drives cinematic image sequences with automatic pinning, LRU GPU cache, and smooth lerp interpolation.
- **Three frame sources** -- Assets, network (with disk cache), and sprite sheets; switch constructors without changing the widget API.
- **Customizable at every layer** -- builder overlay for reactive text/UI, custom FrameLoader for procedural frames, SnapConfig for keyframe settling.
- **Zero dependencies** -- Flutter SDK only; no additional packages required.

### fifty_skill_tree
- **Five layout algorithms out of the box** -- Vertical, horizontal, radial, grid, and custom positioning; switch layouts with a single line.
- **Full UI control via nodeBuilder** -- Provide a nodeBuilder callback on SkillTreeView to render any widget for any node state; the engine handles unlock logic, prerequisites, and animations.
- **Generic data on every node** -- Attach any custom type T to SkillNode<T> for rewards, ability stats, or metadata; access via node.data at unlock time.
- **Save/load in two lines** -- controller.exportProgress() and controller.importProgress() handle game persistence; pair with any storage solution.

### fifty_printing_engine
- **Manage a whole printer fleet** -- Register Bluetooth and WiFi printers, configure routing strategies (print-to-all, role-based, select-per-print), and fire print jobs without managing connections manually.
- **Auto-reconnects silently** -- Disconnected printers are reconnected automatically during print; your code just calls engine.print() and inspects the PrintResult.
- **Role-based routing for kitchens** -- Assign printers a role (kitchen/receipt/both) and target print jobs by role; the routing strategy handles which printers fire.
- **Paper size conversion built in** -- Provide a regenerator callback and the engine regenerates the ticket for each printer's paper size automatically.

### fifty_ui
- **38 FDL-styled widgets ready to drop in** -- Buttons, inputs, cards, navigation, feedback, and effects all themed consistently with Fifty Design Language v2.
- **Dark-first, adaptive by design** -- All widgets read from Theme.of(context).colorScheme and FiftyThemeExtension; pass a custom colorScheme to FiftyTheme.dark() and every widget adapts.
- **Composable effects** -- KineticEffect, GlitchEffect, GlowContainer, and HalftoneOverlay are standalone wrappers; combine with any widget, not just fifty_ui components.
- **WCAG 2.1 AA** -- Accessible contrast ratios, reduced motion support, and required tooltips on all icon buttons baked in.

### fifty_connectivity
- **Reliable connectivity, not just network state** -- DNS and HTTP health checks distinguish captive portals and offline routers from true internet access; ConnectivityType.noInternet is separate from ConnectivityType.disconnected.
- **Three ready-to-use UX patterns** -- ConnectionOverlay for status banners, ConnectionHandler for content swapping, ConnectivityCheckerSplash for app launch gating; use one or all three.
- **Custom splash screens per state** -- contentBuilder on ConnectivityCheckerSplash gives you (context, SplashConnectivityState, retryAction) and replaces the entire splash content for checking/connected/failed states.
- **Telemetry callbacks** -- onWentOffline and onBackOnline hooks with offline Duration for analytics; no subclassing needed.

### fifty_forms
- **Full validation pipeline, you build the UI** -- FiftyFormController handles field registration, 25 built-in validators, async debounce validation, and draft persistence; you provide the layout.
- **Wizard forms with custom everything** -- FiftyMultiStepForm comes with step validation, progress tracking, and navigation; replace the navigation buttons, progress display, error summary, and submit button individually via optional builders.
- **Async validators with debounce** -- AsyncCustom<String> debounces server-side checks (username availability, email exists) so API calls fire only when the user pauses typing.
- **Draft persistence that survives app kills** -- DraftManager auto-saves form state to GetStorage with configurable debounce; restore drafts on next open with a single hasDraft() check.

### fifty_achievement_engine
- **Full achievement pipeline, any UI** -- AchievementController handles condition evaluation, progress tracking, prerequisite chains, and unlock callbacks; you provide the display.
- **Replace any widget's inner content** -- contentBuilder, itemBuilder, and barBuilder callbacks let you swap out default FDL UI for your game's visual style while keeping all achievement logic intact.
- **Six composable condition types** -- EventCondition, CountCondition, ThresholdCondition, CompositeCondition (AND/OR), TimeCondition, and SequenceCondition cover every unlock pattern without custom code.
- **Generic data on every achievement** -- Attach any type T to Achievement<T> for reward data (gold, items, XP) and access it in the onUnlock callback.

### fifty_speech_engine
- **One engine, two speech modes** -- FiftySpeechEngine unifies flutter_tts and speech_to_text behind a single initialize()/speak()/startListening() API; no managing two SDKs.
- **Custom TTS and STT controls, logic unchanged** -- SpeechTtsControls and SpeechSttControls accept optional contentBuilder callbacks; replace the default FDL UI while keeping all state management intact.
- **Type-safe builder state** -- Builders receive SpeechTtsState (isSpeaking, currentText) and SpeechSttState (isListening, lastResult) data classes, not raw booleans; your custom UI compiles cleanly.
- **Continuous and command modes** -- Set listenContinuously: true for dictation, false for single voice commands; the same engine handles both.

---

## Testing Strategy

- No code changes in this brief -- documentation only.
- After each README is written, verify that all code snippets are syntactically plausible (no obvious typos in class names).
- Verify version numbers against each package's pubspec.yaml before finalizing.
- For the four builder-pattern packages, verify builder signature accuracy against the source code for the builders added in FR-001 through FR-004.

### Builder Signature Verification Checklist

Before writing the Customization section for each builder-pattern package, FORGER must read the actual source files to confirm exact typedefs:

| Package | Source files to verify |
|---------|----------------------|
| fifty_achievement_engine | `lib/src/widgets/achievement_card.dart`, `achievement_list.dart`, `achievement_summary.dart`, `achievement_popup.dart`, `achievement_progress_bar.dart` |
| fifty_speech_engine | `lib/src/widgets/speech_tts_controls.dart`, `speech_stt_controls.dart`, `speech_controls_panel.dart` |
| fifty_forms | `lib/src/widgets/fifty_multi_step_form.dart`, `fifty_validation_summary.dart`, `fifty_form_progress.dart`, `fifty_submit_button.dart` |
| fifty_connectivity | `lib/src/widgets/connectivity_checker_splash.dart` |

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Builder signatures in README don't match actual code | Medium | Medium | FORGER reads source files before writing Customization sections (see verification checklist above) |
| Version numbers in READMEs become stale | Low | Low | Verify against pubspec.yaml during Phase 4 |
| "Why" bullet wording is too marketing-speak | Low | Low | Follow benefit-led formula: **[Name]** -- [practical one-liner] |
| Rewriting disrupts existing doc links | Low | Low | Internal anchor links within READMEs may shift; check any explicit section links |
| fifty_speech_engine widgets section introduces inaccurate API surface | Medium | Medium | FORGER must read all 3 widget source files before writing the new Widgets section |

---

## Commit Strategy

Recommended: 3 commits

1. `docs(packages): add Why sections to infrastructure packages (cache, utils, socket, storage, audio, narrative, world, scroll-sequence)` -- Group 1 packages
2. `docs(packages): add Why and Customization sections to skill-tree, printing-engine, and fifty-ui` -- Group 2 packages
3. `docs(packages): add builder pattern customization docs to connectivity, forms, achievement-engine, speech-engine` -- Group 3 packages (the most impactful commit)

---

Plan created for TD-011

**Complexity:** L
**Files affected:** 15
**Phases:** 4
**Groups:** 3 (by effort level)

Ready for implementation.
