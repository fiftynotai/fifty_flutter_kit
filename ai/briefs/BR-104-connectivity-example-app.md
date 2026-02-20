# BR-104: Fifty Connectivity Example App

**Type:** Feature
**Priority:** P2-Medium
**Effort:** M (2-3d)
**Status:** Done
**Created:** 2026-02-18

---

## Summary

Create a standalone example app for `fifty_connectivity` that showcases all package features: real-time connection monitoring, reachability probing, offline detection, and auto-reconnect UI. Extract the connectivity module from `templates/mvvm_actions/` as the foundation.

---

## Context

The `fifty_connectivity` package provides a complete connectivity monitoring solution but has no example app. The connectivity module already exists in `templates/mvvm_actions/lib/modules/connections/` with working ViewModel, Actions, Services, and Widgets. Tests exist at `templates/mvvm_actions/test/modules/connections/`.

### Source Material

**Package (`packages/fifty_connectivity/lib/src/`):**
- `controllers/connection_view_model.dart` — ConnectionViewModel (GetxController) with reactive connectivity state
- `services/reachability_service.dart` — ReachabilityService with DNS + HTTP probe strategies
- `actions/connection_actions.dart` — ConnectionActions for manual connectivity checks
- `widgets/connection_handler.dart` — ConnectionHandler widget (wraps child with connectivity-aware UI)
- `widgets/connection_overlay.dart` — ConnectionOverlay (fullscreen offline overlay)
- `widgets/connectivity_checker_splash.dart` — ConnectivityCheckerSplash (startup connectivity gate)
- `config/connectivity_config.dart` — ConnectivityConfig for localization and customization
- `bindings/connection_bindings.dart` — GetX bindings for DI

**Template module (`templates/mvvm_actions/lib/modules/connections/`):**
- `connections_screen.dart` — Full demo screen with status display
- `connections_view_model.dart` — Module ViewModel
- `connections_actions.dart` — Module Actions
- Tests at `templates/mvvm_actions/test/modules/connections/`

---

## Acceptance Criteria

- [ ] Example app at `packages/fifty_connectivity/example/`
- [ ] Uses FDL theming: `FiftyTheme.dark()` / `FiftyTheme.light()`, `ThemeMode.system`
- [ ] `debugShowCheckedModeBanner: false`
- [ ] Home screen with connection status dashboard (current type, reachability, signal info)
- [ ] Demo of `ConnectionHandler` widget wrapping content
- [ ] Demo of `ConnectionOverlay` fullscreen offline state
- [ ] Demo of `ConnectivityCheckerSplash` as startup gate
- [ ] Demo of `ConnectivityConfig` localization customization
- [ ] Demo of manual reachability probe via `ConnectionActions`
- [ ] Bottom navigation or tab navigation between demos
- [ ] All 3 widgets showcased on separate screens/tabs
- [ ] `README.md` follows FDL template (10 sections)
- [ ] 4 dark mode screenshots captured at `<img width="200">`
- [ ] Zero analyzer errors
- [ ] Builds and runs on iOS simulator

---

## Architecture

```
packages/fifty_connectivity/example/
├── lib/
│   ├── main.dart                    # App entry, FDL theme, bottom nav
│   ├── screens/
│   │   ├── home_screen.dart         # Connection status dashboard
│   │   ├── handler_demo_screen.dart # ConnectionHandler widget demo
│   │   ├── overlay_demo_screen.dart # ConnectionOverlay demo
│   │   └── splash_demo_screen.dart  # ConnectivityCheckerSplash demo
│   └── widgets/
│       └── status_card.dart         # Reusable connectivity status card
├── pubspec.yaml
└── README.md
```

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  fifty_connectivity:
    path: ../../
  fifty_theme:
    path: ../../../fifty_theme
  fifty_tokens:
    path: ../../../fifty_tokens
  fifty_ui:
    path: ../../../fifty_ui
  get: ^4.6.6
  connectivity_plus: ^6.1.4
```

---

## Screenshots Required

| Home | Handler | Overlay | Splash |
|:----:|:-------:|:-------:|:------:|
| Connection status dashboard | ConnectionHandler wrapping content | ConnectionOverlay offline state | ConnectivityCheckerSplash gate |

---

## Implementation Notes

- Extract patterns from `templates/mvvm_actions/lib/modules/connections/` but adapt to standalone example structure
- Use `ConnectionBindings` for GetX DI setup in `main.dart`
- The `ConnectionViewModel` exposes `connectionType`, `isConnected`, `isReachable` as reactive observables
- `ReachabilityService` supports DNS probe (default) and HTTP probe strategies
- `ConnectivityConfig` allows customizing all user-facing strings (titles, messages, button labels)
- All widgets use FDL styling internally (FiftyColors, FiftyCard, FiftyButton, FiftyLoadingIndicator)
- For overlay/offline screenshots, may need to simulate disconnected state or use airplane mode on simulator

---

## References

- BR-103 (Printing Engine Example FDL Migration) — pattern for example app structure
- `ai/context/readme_template.md` — FDL README template
- `packages/fifty_connectivity/lib/fifty_connectivity.dart` — public API exports
