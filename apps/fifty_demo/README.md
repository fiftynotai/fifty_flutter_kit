# Fifty Demo

A composite demo application showcasing the Fifty ecosystem packages working together. Demonstrates audio, speech, sentences, and map engines with Fifty Design Language (FDL) styling.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Screenshots](#screenshots)
- [Getting Started](#getting-started)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Package Dependencies](#package-dependencies)
- [Demo Features](#demo-features)
- [License](#license)

## Overview

Fifty Demo serves as an integration showcase for the Fifty ecosystem. It demonstrates how multiple Fifty packages can work together to create a cohesive application experience with consistent theming, audio management, speech capabilities, and interactive maps.

**Key Highlights:**

- MVVM + Actions architecture with GetX state management
- Fifty Design Language (FDL) dark theme throughout
- Integration of 7 Fifty ecosystem packages
- Tabbed navigation between demo features

## Features

- **Ecosystem Status Dashboard** - Real-time status of all integrated packages
- **Interactive Map Demo** - Grid-based map with entity placement and audio coordination
- **Dialogue System Demo** - Sentence queue processing with TTS/STT capabilities
- **UI Component Showcase** - Full catalog of FDL components (buttons, cards, inputs, feedback)
- **Audio Integration** - BGM, SFX, and Voice channel management
- **Speech Integration** - Text-to-Speech and Speech-to-Text support

## Screenshots

<!-- Add screenshots here -->
<!-- ![Home Screen](docs/screenshots/home.png) -->
<!-- ![Map Demo](docs/screenshots/map_demo.png) -->
<!-- ![Dialogue Demo](docs/screenshots/dialogue_demo.png) -->
<!-- ![UI Showcase](docs/screenshots/ui_showcase.png) -->

## Getting Started

### Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart SDK 3.6.0 or higher

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-org/fifty_eco_system.git
   cd fifty_eco_system/apps/fifty_demo
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

### Platform Support

| Platform | Status |
|----------|--------|
| Android  | Supported |
| iOS      | Supported |
| Web      | Partial (audio limitations) |
| macOS    | Supported |
| Linux    | Supported |
| Windows  | Supported |

## Architecture

Fifty Demo follows the **MVVM + Actions** architecture pattern with GetX for dependency injection and state management.

### Pattern Overview

```
┌─────────────────────────────────────────────────────────────┐
│                          View                               │
│  (GetView<ViewModel>, builds UI from ViewModel state)      │
└─────────────────────────────┬───────────────────────────────┘
                              │ observes
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       ViewModel                             │
│  (GetxController, exposes state, no user action logic)     │
└─────────────────────────────┬───────────────────────────────┘
                              │ managed by
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                        Actions                              │
│  (Handles user interactions, calls services/viewmodel)     │
└─────────────────────────────┬───────────────────────────────┘
                              │ uses
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    Integration Services                     │
│  (Wraps Fifty engines, provides simplified API)            │
└─────────────────────────────────────────────────────────────┘
```

### Key Concepts

- **View**: Stateless widgets using `GetView<ViewModel>` that rebuild on state changes
- **ViewModel**: `GetxController` that holds and exposes reactive state
- **Actions**: Separate class handling user interactions and business logic
- **Integration Services**: Wrappers around Fifty engine packages for simplified access

### Dependency Injection

Dependencies are registered using GetX bindings:

- **InitialBindings**: App-wide services (registered at startup)
- **Feature Bindings**: Feature-specific dependencies (lazy loaded)

```dart
// Example: InitialBindings
Get.lazyPut<AudioIntegrationService>(
  AudioIntegrationService.new,
  fenix: true,
);
```

## Project Structure

```
lib/
├── main.dart                    # Entry point, engine initialization
├── fifty_demo.dart              # Library export
├── app/
│   ├── app.dart                 # App module export
│   └── fifty_demo_app.dart      # Root GetMaterialApp widget
├── core/
│   ├── bindings/
│   │   └── initial_bindings.dart   # App-wide DI registration
│   ├── config/
│   │   ├── asset_config.dart       # Asset path constants
│   │   └── engine_config.dart      # Engine configuration
│   ├── errors/
│   │   └── app_exception.dart      # Custom exceptions
│   ├── navigation/
│   │   └── app_navigation.dart     # Route constants
│   └── presentation/
│       └── actions/
│           └── action_presenter.dart  # Error/loading handling
├── features/
│   ├── home/
│   │   ├── actions/home_actions.dart
│   │   ├── view/
│   │   │   ├── home_page.dart
│   │   │   └── widgets/
│   │   ├── viewmodel/home_viewmodel.dart
│   │   └── home_bindings.dart
│   ├── map_demo/
│   │   ├── actions/map_demo_actions.dart
│   │   ├── service/map_audio_coordinator.dart
│   │   ├── view/
│   │   │   ├── map_demo_page.dart
│   │   │   └── widgets/
│   │   ├── viewmodel/map_demo_viewmodel.dart
│   │   └── map_demo_bindings.dart
│   ├── dialogue_demo/
│   │   ├── actions/dialogue_demo_actions.dart
│   │   ├── service/
│   │   │   ├── demo_dialogues.dart
│   │   │   └── dialogue_orchestrator.dart
│   │   ├── view/
│   │   │   ├── dialogue_demo_page.dart
│   │   │   └── widgets/
│   │   ├── viewmodel/dialogue_demo_viewmodel.dart
│   │   └── dialogue_demo_bindings.dart
│   └── ui_showcase/
│       ├── actions/ui_showcase_actions.dart
│       ├── view/
│       │   ├── ui_showcase_page.dart
│       │   └── widgets/
│       ├── viewmodel/ui_showcase_viewmodel.dart
│       └── ui_showcase_bindings.dart
└── shared/
    ├── services/
    │   ├── audio_integration_service.dart
    │   ├── speech_integration_service.dart
    │   ├── sentences_integration_service.dart
    │   └── map_integration_service.dart
    └── widgets/
        ├── demo_scaffold.dart
        ├── section_header.dart
        └── status_indicator.dart
```

## Package Dependencies

### Fifty Ecosystem Packages

| Package | Version | Description |
|---------|---------|-------------|
| `fifty_tokens` | 0.2.0 | Design tokens (colors, typography, spacing) |
| `fifty_theme` | 0.1.0 | Theme system (dark/light themes) |
| `fifty_ui` | 0.5.0 | UI components (buttons, cards, inputs) |
| `fifty_audio_engine` | 0.7.0 | Audio management (BGM, SFX, Voice channels) |
| `fifty_speech_engine` | 0.1.0 | TTS/STT capabilities |
| `fifty_sentences_engine` | 0.1.0 | Dialogue/sentence queue processing |
| `fifty_map_engine` | 0.1.0 | Interactive grid map rendering |

### Third-Party Dependencies

| Package | Purpose |
|---------|---------|
| `get` | State management and dependency injection |
| `loader_overlay` | Global loading overlay |
| `audioplayers` | Audio playback backend |

## Demo Features

### Home

The landing page displays:
- Ecosystem status with real-time package readiness
- Feature navigation cards
- System information (app version, architecture)

### Map Demo

Interactive grid-based map demonstration featuring:
- Entity placement (characters, monsters, furniture)
- Audio coordination (BGM, ambient SFX)
- Map controls (zoom, pan, entity selection)
- Entity info panel

**Integration:** `fifty_map_engine` + `fifty_audio_engine`

### Dialogue Demo

Sentence queue processing with speech capabilities:
- Pre-defined dialogue scenarios
- TTS playback with auto-advance
- STT voice input recognition
- Sentence queue visualization
- Speaker attribution

**Integration:** `fifty_sentences_engine` + `fifty_speech_engine`

### UI Showcase

Comprehensive catalog of Fifty Design Language components:
- **Buttons**: Primary, secondary, ghost, icon buttons
- **Display**: Cards, hero sections, progress indicators
- **Inputs**: Text fields, dropdowns, switches
- **Feedback**: Toasts, dialogs, loading states

**Integration:** `fifty_ui` + `fifty_tokens` + `fifty_theme`

## Assets

```
assets/
├── images/
│   ├── rooms/        # Room/environment images
│   ├── furniture/    # Furniture sprites
│   ├── monsters/     # Monster sprites
│   └── characters/   # Character sprites
├── audio/
│   └── sfx/          # Sound effects
└── maps/             # Map data files
```

## License

This project is part of the Fifty ecosystem. See the root repository for license information.

---

**Built with the Fifty Design Language**
