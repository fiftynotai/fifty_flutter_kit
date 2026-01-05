# Implementation Plan: BR-018 - Fifty Composite Demo App

**Created:** 2026-01-01
**Complexity:** L (Large)
**Estimated Duration:** 2-4 days
**Risk Level:** Medium

---

## Summary

Create a unified demo application at `apps/fifty_demo/` that integrates all 7 Fifty ecosystem packages into a cohesive demonstration featuring interactive map exploration, dialogue systems with TTS/STT, and a comprehensive UI component showcase. The app follows MVVM + Actions architecture with GetIt DI and full FDL styling.

---

## Project Structure

```
apps/fifty_demo/
|
|-- lib/
|   |-- main.dart                           # App entry point
|   |
|   |-- app/
|   |   |-- fifty_demo_app.dart             # Root widget with theme/navigation
|   |   +-- app.dart                         # Barrel export
|   |
|   |-- core/
|   |   |-- di/
|   |   |   +-- service_locator.dart        # GetIt DI setup for all engines
|   |   |-- navigation/
|   |   |   +-- app_navigation.dart         # Navigation constants and helpers
|   |   |-- config/
|   |   |   |-- asset_config.dart           # Asset paths configuration
|   |   |   +-- engine_config.dart          # Engine initialization config
|   |   +-- core.dart                        # Barrel export
|   |
|   |-- shared/
|   |   |-- services/
|   |   |   |-- audio_integration_service.dart   # Wraps FiftyAudioEngine
|   |   |   |-- speech_integration_service.dart  # Wraps FiftySpeechEngine
|   |   |   |-- sentences_integration_service.dart # Wraps FiftySentenceEngine
|   |   |   |-- map_integration_service.dart     # Wraps FiftyMapController
|   |   |   +-- services.dart               # Barrel export
|   |   |-- widgets/
|   |   |   |-- demo_scaffold.dart          # Common scaffold with back nav
|   |   |   |-- status_indicator.dart       # Engine status display
|   |   |   |-- section_header.dart         # Consistent section headers
|   |   |   +-- widgets.dart                # Barrel export
|   |   +-- shared.dart                     # Barrel export
|   |
|   |-- features/
|   |   |
|   |   |-- home/                           # Home/navigation feature
|   |   |   |-- view/
|   |   |   |   |-- home_page.dart          # Landing page with nav cards
|   |   |   |   +-- widgets/
|   |   |   |       |-- feature_nav_card.dart
|   |   |   |       +-- ecosystem_status.dart
|   |   |   |-- viewmodel/
|   |   |   |   +-- home_viewmodel.dart
|   |   |   |-- actions/
|   |   |   |   +-- home_actions.dart
|   |   |   +-- home.dart                   # Barrel export
|   |   |
|   |   |-- map_demo/                       # Map + Audio integration
|   |   |   |-- view/
|   |   |   |   |-- map_demo_page.dart      # Main map view
|   |   |   |   +-- widgets/
|   |   |   |       |-- map_controls.dart   # Pan/zoom controls
|   |   |   |       |-- audio_controls.dart # BGM/SFX toggles
|   |   |   |       +-- entity_info_panel.dart
|   |   |   |-- viewmodel/
|   |   |   |   +-- map_demo_viewmodel.dart
|   |   |   |-- actions/
|   |   |   |   +-- map_demo_actions.dart
|   |   |   |-- service/
|   |   |   |   +-- map_audio_coordinator.dart # Coordinates map + audio
|   |   |   +-- map_demo.dart               # Barrel export
|   |   |
|   |   |-- dialogue_demo/                  # Sentences + Speech integration
|   |   |   |-- view/
|   |   |   |   |-- dialogue_demo_page.dart # Main dialogue view
|   |   |   |   +-- widgets/
|   |   |   |       |-- dialogue_display.dart    # Sentence display panel
|   |   |   |       |-- tts_controls.dart        # TTS toggle/settings
|   |   |   |       |-- stt_controls.dart        # STT toggle/settings
|   |   |   |       |-- sentence_queue_panel.dart
|   |   |   |       +-- choice_buttons.dart
|   |   |   |-- viewmodel/
|   |   |   |   +-- dialogue_demo_viewmodel.dart
|   |   |   |-- actions/
|   |   |   |   +-- dialogue_demo_actions.dart
|   |   |   |-- service/
|   |   |   |   |-- dialogue_orchestrator.dart  # Coordinates sentences + TTS
|   |   |   |   +-- demo_dialogues.dart         # Sample dialogue data
|   |   |   +-- dialogue_demo.dart          # Barrel export
|   |   |
|   |   |-- ui_showcase/                    # All fifty_ui components
|   |   |   |-- view/
|   |   |   |   |-- ui_showcase_page.dart   # Component gallery
|   |   |   |   +-- widgets/
|   |   |   |       |-- buttons_section.dart
|   |   |   |       |-- inputs_section.dart
|   |   |   |       |-- display_section.dart
|   |   |   |       |-- feedback_section.dart
|   |   |   |       |-- organisms_section.dart
|   |   |   |       +-- utils_section.dart
|   |   |   |-- viewmodel/
|   |   |   |   +-- ui_showcase_viewmodel.dart
|   |   |   |-- actions/
|   |   |   |   +-- ui_showcase_actions.dart
|   |   |   +-- ui_showcase.dart            # Barrel export
|   |   |
|   |   +-- features.dart                   # Barrel export all features
|   |
|   +-- fifty_demo.dart                     # Main barrel export
|
|-- assets/
|   |-- images/                             # Map assets
|   |-- audio/
|   +-- maps/
|
|-- test/
|-- android/
|-- ios/
|-- macos/
|-- linux/
|-- windows/
|-- web/
|
|-- pubspec.yaml
|-- analysis_options.yaml
+-- README.md
```

---

## Implementation Phases

### Phase 1: Project Scaffolding
- Create Flutter project with `flutter create`
- Configure pubspec.yaml with all 7 package dependencies
- Set up analysis_options.yaml
- Create directory structure

### Phase 2: Core Infrastructure
- Create service_locator.dart with GetIt DI
- Create integration services for each engine
- Create main.dart with initialization
- Create FiftyDemoApp root widget

### Phase 3: Home Feature
- Create home_page.dart with navigation cards
- Create feature_nav_card.dart
- Create ecosystem_status.dart
- Create home_viewmodel.dart and home_actions.dart

### Phase 4: Map Demo Feature
- Create map_demo_page.dart with FiftyMapWidget
- Create map_controls.dart and audio_controls.dart
- Create map_audio_coordinator.dart
- Create map_demo_viewmodel.dart and map_demo_actions.dart

### Phase 5: Dialogue Demo Feature
- Create dialogue_demo_page.dart
- Create dialogue_display.dart, tts_controls.dart, stt_controls.dart
- Create dialogue_orchestrator.dart and demo_dialogues.dart
- Create dialogue_demo_viewmodel.dart and dialogue_demo_actions.dart

### Phase 6: UI Showcase Feature
- Create ui_showcase_page.dart
- Create section widgets (buttons, inputs, display, feedback, organisms, utils)
- Create ui_showcase_viewmodel.dart and ui_showcase_actions.dart

### Phase 7: Platform & Documentation
- Configure platform folders (permissions, etc.)
- Copy/configure assets
- Create README.md

### Phase 8: Quality Assurance
- Run flutter analyze
- Create basic tests
- Manual platform testing

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # Fifty Ecosystem (7 packages)
  fifty_tokens:
    path: ../../packages/fifty_tokens
  fifty_theme:
    path: ../../packages/fifty_theme
  fifty_ui:
    path: ../../packages/fifty_ui
  fifty_audio_engine:
    path: ../../packages/fifty_audio_engine
  fifty_speech_engine:
    path: ../../packages/fifty_speech_engine
  fifty_sentences_engine:
    path: ../../packages/fifty_sentences_engine
  fifty_map_engine:
    path: ../../packages/fifty_map_engine

  # State Management & DI
  provider: ^6.1.2
  get_it: ^8.0.3

  # Audio
  audioplayers: ^6.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0
```

---

## Success Criteria

1. App launches on all 6 platforms
2. Home page displays with all feature cards
3. Map Demo: Map renders, audio plays, entity selection works
4. Dialogue Demo: Sentences process, TTS speaks, STT recognizes
5. UI Showcase: All components render with FDL styling
6. `flutter analyze` returns zero issues
7. Navigation between all features works
8. Engines initialize and dispose properly

---

**Total Files:** ~55 Dart files + config files
**Approved:** Pending
