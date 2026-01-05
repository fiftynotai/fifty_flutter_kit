# Implementation Plan: BR-028

**Brief:** Fifty Demo - Use MVVM+Actions Template Pattern
**Complexity:** L (Large)
**Estimated Duration:** 2-3 working days
**Risk Level:** Medium
**Created:** 2026-01-05

---

## Summary

Refactor the fifty_demo app from Provider + GetIt architecture to MVVM+Actions with GetX. This involves changing state management, dependency injection, and UI binding patterns across ~45 files while preserving all existing functionality.

---

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `apps/fifty_demo/pubspec.yaml` | MODIFY | Replace provider/get_it with get, add loader_overlay |
| `apps/fifty_demo/lib/main.dart` | MODIFY | Add RouteManager init, change to simple runApp |
| `apps/fifty_demo/lib/app/fifty_demo_app.dart` | MODIFY | Use GetMaterialApp, remove MultiProvider, add GlobalLoaderOverlay |
| `apps/fifty_demo/lib/core/di/service_locator.dart` | DELETE | Remove GetIt service locator |
| `apps/fifty_demo/lib/core/routing/route_manager.dart` | CREATE | Add RouteManager from template |
| `apps/fifty_demo/lib/core/presentation/actions/action_presenter.dart` | CREATE | Add ActionPresenter base class |
| `apps/fifty_demo/lib/core/errors/app_exception.dart` | CREATE | Add exception types |
| `apps/fifty_demo/lib/core/bindings/initial_bindings.dart` | CREATE | Add InitialBindings for app-wide deps |
| `apps/fifty_demo/lib/features/home/home_bindings.dart` | CREATE | Add HomeBindings |
| `apps/fifty_demo/lib/features/home/viewmodel/home_viewmodel.dart` | MODIFY | ChangeNotifier -> GetxController |
| `apps/fifty_demo/lib/features/home/actions/home_actions.dart` | MODIFY | Add ActionPresenter composition |
| `apps/fifty_demo/lib/features/home/view/home_page.dart` | MODIFY | Consumer -> GetView + Obx |
| `apps/fifty_demo/lib/features/map_demo/map_demo_bindings.dart` | CREATE | Add MapDemoBindings |
| `apps/fifty_demo/lib/features/map_demo/viewmodel/map_demo_viewmodel.dart` | MODIFY | ChangeNotifier -> GetxController |
| `apps/fifty_demo/lib/features/map_demo/actions/map_demo_actions.dart` | MODIFY | Add ActionPresenter composition |
| `apps/fifty_demo/lib/features/map_demo/view/map_demo_page.dart` | MODIFY | Consumer -> GetView + Obx |
| `apps/fifty_demo/lib/features/map_demo/service/map_audio_coordinator.dart` | MODIFY | ChangeNotifier -> GetxController |
| `apps/fifty_demo/lib/features/dialogue_demo/dialogue_demo_bindings.dart` | CREATE | Add DialogueDemoBindings |
| `apps/fifty_demo/lib/features/dialogue_demo/viewmodel/dialogue_demo_viewmodel.dart` | MODIFY | ChangeNotifier -> GetxController |
| `apps/fifty_demo/lib/features/dialogue_demo/actions/dialogue_demo_actions.dart` | MODIFY | Add ActionPresenter composition |
| `apps/fifty_demo/lib/features/dialogue_demo/view/dialogue_demo_page.dart` | MODIFY | Consumer -> GetView + Obx |
| `apps/fifty_demo/lib/features/dialogue_demo/service/dialogue_orchestrator.dart` | MODIFY | ChangeNotifier -> GetxController |
| `apps/fifty_demo/lib/features/ui_showcase/ui_showcase_bindings.dart` | CREATE | Add UiShowcaseBindings |
| `apps/fifty_demo/lib/features/ui_showcase/viewmodel/ui_showcase_viewmodel.dart` | MODIFY | ChangeNotifier -> GetxController |
| `apps/fifty_demo/lib/features/ui_showcase/actions/ui_showcase_actions.dart` | MODIFY | Add ActionPresenter composition |
| `apps/fifty_demo/lib/features/ui_showcase/view/ui_showcase_page.dart` | MODIFY | Consumer -> GetView + Obx |
| `apps/fifty_demo/lib/shared/services/audio_integration_service.dart` | MODIFY | ChangeNotifier -> GetxController |
| `apps/fifty_demo/lib/shared/services/speech_integration_service.dart` | MODIFY | ChangeNotifier -> GetxController |
| `apps/fifty_demo/lib/shared/services/sentences_integration_service.dart` | MODIFY | ChangeNotifier -> GetxController |
| `apps/fifty_demo/lib/shared/services/map_integration_service.dart` | MODIFY | ChangeNotifier -> GetxController |
| All view widget files | MODIFY | Remove serviceLocator references |

**Total Files: ~45** (8 CREATE, 1 DELETE, ~36 MODIFY)

---

## Implementation Phases

### Phase 1: Dependencies and Core Infrastructure

**1.1 Update pubspec.yaml**
```yaml
# Remove
provider: ^6.1.2
get_it: ^8.0.3

# Add
get: ^4.6.6
loader_overlay: ^4.0.3
```

**1.2 Create Core Infrastructure Files**

- `/core/errors/app_exception.dart` - Exception types
- `/core/presentation/actions/action_presenter.dart` - ActionPresenter base class
- `/core/routing/route_manager.dart` - Navigation helpers
- `/core/bindings/initial_bindings.dart` - App-wide DI

**1.3 Delete service_locator.dart**

---

### Phase 2: Shared Services Migration

**Pattern:**
```dart
// FROM:
class AudioIntegrationService extends ChangeNotifier {
  void notifyListeners();
}

// TO:
class AudioIntegrationService extends GetxController {
  void update();
}
```

Files:
- AudioIntegrationService
- SpeechIntegrationService
- SentencesIntegrationService
- MapIntegrationService

---

### Phase 3: Feature Services Migration

- MapAudioCoordinator
- DialogueOrchestrator

---

### Phase 4-7: Feature Migrations

Each feature (Home, MapDemo, DialogueDemo, UiShowcase):
1. Create {Feature}Bindings
2. Migrate {Feature}ViewModel
3. Migrate {Feature}Actions
4. Migrate {Feature}Page

**Bindings Pattern:**
```dart
class HomeBindings implements Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<HomeViewModel>()) {
      Get.put<HomeViewModel>(HomeViewModel(...), permanent: true);
    }
    if (!Get.isRegistered<HomeActions>()) {
      Get.lazyPut<HomeActions>(() => HomeActions(...), fenix: true);
    }
  }
}
```

**ViewModel Pattern:**
```dart
class HomeViewModel extends GetxController {
  final RxBool _allReady = false.obs;
  bool get allReady => _allReady.value;

  @override
  void onInit() {
    super.onInit();
    initializeServices();
  }
}
```

**View Pattern:**
```dart
class HomePage extends GetView<HomeViewModel> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => ...controller.allReady...);
  }
}
```

---

### Phase 8: App Shell Migration

**FiftyDemoApp:**
```dart
class FiftyDemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlobalLoaderOverlay(
      child: GetMaterialApp(
        theme: FiftyTheme.dark(),
        initialBinding: InitialBindings(),
        home: const DemoShell(),
      ),
    );
  }
}
```

---

### Phase 9: Cleanup and Testing

1. Remove Provider imports
2. Remove GetIt imports
3. Replace serviceLocator references with Get.find
4. Run flutter analyze
5. Manual testing

---

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Listener pattern changes | Medium | High | Test coordinators thoroughly |
| IndexedStack + GetX disposal | Medium | Medium | Use permanent ViewModels |
| Missing imports | High | Low | Run analyze frequently |

---

## Complexity Per Phase

| Phase | Complexity | Duration |
|-------|------------|----------|
| 1. Core Infrastructure | Medium | 2-3 hours |
| 2. Shared Services | Low | 1-2 hours |
| 3. Feature Services | Low | 1 hour |
| 4. Home Feature | Medium | 1-2 hours |
| 5. Map Demo Feature | Medium | 2 hours |
| 6. Dialogue Demo Feature | Medium | 2 hours |
| 7. UI Showcase Feature | Low | 1 hour |
| 8. App Shell | High | 2-3 hours |
| 9. Cleanup & Testing | Medium | 3-4 hours |

**Total: 16-22 hours**

---

**Plan Status:** Ready for implementation
