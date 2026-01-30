# BR-050: fifty_demo Theme Mode Integration

**Type:** Feature
**Priority:** P2-Medium
**Effort:** S-Small
**Status:** Done

---

## Problem

The fifty_demo app has a theme selector UI in Settings, but it's purely cosmetic:
- `SettingsViewModel` stores `AppThemeMode` in memory only
- No call to `Get.changeThemeMode()` to actually switch themes
- No persistence via `fifty_storage`
- `GetMaterialApp` is hardcoded to `FiftyTheme.dark()`

The template theme module at `templates/mvvm_actions/lib/src/modules/theme/` provides a complete reference implementation.

---

## Goal

Implement functional theme mode switching in fifty_demo:
1. Theme persists across app restarts
2. Dark/Light/System modes all work
3. Leverage existing Settings UI (no visual changes needed)
4. Follow template pattern for consistency

---

## Context & Inputs

### Template Files (Reference Pattern)
- `templates/mvvm_actions/lib/src/modules/theme/controllers/theme_view_model.dart`
- `templates/mvvm_actions/lib/src/modules/theme/data/services/theme_service.dart`

### Target Files (Modify)
- `apps/fifty_demo/pubspec.yaml` - add fifty_storage dependency
- `apps/fifty_demo/lib/main.dart` - initialize PreferencesStorage
- `apps/fifty_demo/lib/app/fifty_demo_app.dart` - configure darkTheme + themeMode
- `apps/fifty_demo/lib/features/settings/controllers/settings_view_model.dart` - add persistence + Get.changeThemeMode()
- `apps/fifty_demo/lib/features/settings/settings_bindings.dart` - may need ThemeService

### Dependencies
- `fifty_storage` package (PreferencesStorage)
- `fifty_theme` package (FiftyTheme.dark(), FiftyTheme.light())

---

## Constraints

- Use existing Settings UI - no visual changes
- Follow MVVM + Actions architecture
- Use fifty_storage for persistence (not SharedPreferences directly)
- Initialize storage before runApp

---

## Acceptance Criteria

- [ ] Selecting Dark mode applies dark theme immediately
- [ ] Selecting Light mode applies light theme immediately
- [ ] Selecting System mode follows device setting
- [ ] Theme persists after app restart
- [ ] No regressions in existing Settings functionality

---

## Test Plan

**Manual:**
1. Launch app → defaults to dark
2. Go to Settings → select Light → UI updates immediately
3. Kill and restart app → Light theme still active
4. Select System → follows device dark/light setting
5. Verify all pages render correctly in both modes

**Automated:**
- Unit test for SettingsViewModel theme methods
- Verify storage read/write

---

## Delivery

- [ ] Update pubspec.yaml with fifty_storage
- [ ] Initialize PreferencesStorage in main.dart
- [ ] Configure GetMaterialApp with both themes
- [ ] Enhance SettingsViewModel with persistence
- [ ] Test on iOS/Android/Web

---

## Implementation Notes

**Implemented:** 2026-01-30

### Files Modified

| File | Change |
|------|--------|
| `pubspec.yaml` | Added `fifty_storage` dependency |
| `main.dart` | Added `PreferencesStorage.configure()` and `initialize()` |
| `fifty_demo_app.dart` | Added `darkTheme: FiftyTheme.dark()`, `theme: FiftyTheme.light()`, `themeMode: ThemeMode.dark` |
| `settings_view_model.dart` | Added ThemeService injection, `_initializeTheme()`, `_applyTheme()`, `_persistTheme()` |
| `settings_bindings.dart` | Registered ThemeService, inject into SettingsViewModel |
| `settings.dart` | Added ThemeService export |

### Files Created

| File | Purpose |
|------|--------|
| `data/services/theme_service.dart` | Theme persistence via PreferencesStorage |

### Key Implementation Details

1. **Storage initialization**: PreferencesStorage configured with container `fifty_demo` before runApp
2. **Theme persistence**: Uses `PreferencesStorage.instance.themeMode` getter/setter
3. **Theme application**: Calls `Get.changeThemeMode()` on theme change
4. **Initialization**: SettingsViewModel loads saved theme in `onInit()`
5. **Conversion**: Maps `AppThemeMode` enum to Flutter's `ThemeMode`

### Phase 2: Theme-Aware Colors (32 files updated)

**Color Mapping Applied:**
| Hardcoded | Theme-Aware |
|-----------|-------------|
| `FiftyColors.darkBurgundy` | `colorScheme.surface` |
| `FiftyColors.cream` | `colorScheme.onSurface` |
| `FiftyColors.burgundy` | `colorScheme.primary` |
| `FiftyColors.surfaceDark` | `colorScheme.surfaceContainerHighest` |
| `FiftyColors.slateGrey` | `colorScheme.onSurfaceVariant` |
| `FiftyColors.borderDark` | `colorScheme.outline` |

**Semantic Colors Preserved:**
- `FiftyColors.hunterGreen` - success state
- `FiftyColors.warning` - warning state

**Pattern Used:**
```dart
final colorScheme = Theme.of(context).colorScheme;
color: colorScheme.onSurface // instead of FiftyColors.cream
```

### Phase 3: Light Mode Color Hierarchy

**Color Hierarchy (creates floating effect):**
| Element | Color | Hex |
|---------|-------|-----|
| Scaffold/background | `FiftyColors.cream` | #FEFEE3 |
| Cards/surfaces | `FiftyColors.surfaceLight` | #FFFFFF |

**Files Updated:**
- `packages/fifty_theme/lib/src/color_scheme.dart` - `surface: FiftyColors.cream`
- `packages/fifty_theme/lib/src/fifty_theme_data.dart` - scaffold, canvas, appBar, bottomNav use cream

**Result:** White cards float above warm cream background, creating visual depth.
