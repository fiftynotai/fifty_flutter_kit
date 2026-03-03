# Implementation Plan: BR-132

**Complexity:** S
**Estimated Duration:** 2-3 hours
**Risk Level:** Low

## Summary

Add a Tokens demo page to `fifty_demo` with buttons that toggle between FDL v2 (burgundy) and Baltic Blue palettes at runtime, demonstrating `FiftyTokens.configure()` and `FiftyTokens.reset()` working live. Revert the TS-003 hardcoded config in `main.dart`.

## Files to Modify

| File | Action | Changes |
|------|--------|---------|
| `apps/fifty_demo/lib/main.dart` | MODIFY | Remove TS-003 `FiftyTokens.configure()` block (lines 27-42) |
| `apps/fifty_demo/lib/features/tokens_demo/views/tokens_demo_page.dart` | CREATE | Demo page with color swatches and palette toggle buttons |
| `apps/fifty_demo/lib/features/tokens_demo/controllers/tokens_demo_view_model.dart` | CREATE | ViewModel tracking active palette name |
| `apps/fifty_demo/lib/features/tokens_demo/actions/tokens_demo_actions.dart` | CREATE | Actions for apply/reset palette |
| `apps/fifty_demo/lib/features/tokens_demo/tokens_demo_bindings.dart` | CREATE | GetX bindings for ViewModel + Actions |
| `apps/fifty_demo/lib/app/fifty_demo_app.dart` | MODIFY | Import and register `TokensDemoBindings` in `_initializeBindings()` |
| `apps/fifty_demo/lib/features/packages/controllers/packages_view_model.dart` | MODIFY | Update `fifty_tokens` entry to have a route and `isAvailable: true` (already true, but change routing behavior) |
| `apps/fifty_demo/lib/features/packages/actions/packages_actions.dart` | MODIFY | Add `case 'fifty_tokens':` to navigate to `TokensDemoPage` instead of showing snackbar |

## Implementation Steps

### Phase 1: Revert main.dart TS-003 Config

**File:** `apps/fifty_demo/lib/main.dart`

Remove lines 27-42 (the entire `FiftyTokens.configure(...)` block). The app should start with default FDL v2 palette (burgundy).

After:
```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage for theme persistence
  PreferencesStorage.configure(containerName: 'fifty_demo');
  await PreferencesStorage.instance.initialize();

  // Initialize FiftyAudioEngine (before app start)
  await FiftyAudioEngine.instance.initialize();
  // ... rest unchanged
}
```

The `import 'package:fifty_tokens/fifty_tokens.dart';` stays because `FiftyTokens` is no longer referenced here, but check -- if no other references exist in main.dart, remove the import. Currently only the configure call uses it, so it should be removed.

Wait -- `FiftyTokens` is the only fifty_tokens usage in main.dart. Remove the import too.

### Phase 2: Create ViewModel

**File:** `apps/fifty_demo/lib/features/tokens_demo/controllers/tokens_demo_view_model.dart`

```dart
/// Tokens Demo ViewModel
///
/// Business logic for the tokens demo feature.
/// Tracks which palette is currently active.
library;

import 'package:get/get.dart';

/// ViewModel for the tokens demo feature.
///
/// Tracks the current palette name and provides swatch data
/// for display on the demo page.
class TokensDemoViewModel extends GetxController {
  /// Whether the Baltic Blue palette is currently active.
  bool _isBalticBlue = false;

  /// Gets whether Baltic Blue palette is active.
  bool get isBalticBlue => _isBalticBlue;

  /// Gets the display name of the current palette.
  String get paletteName => _isBalticBlue ? 'Baltic Blue' : 'FDL v2';

  /// Sets the palette state and notifies listeners.
  void setBalticBlue({required bool active}) {
    _isBalticBlue = active;
    update();
  }
}
```

**Key decisions:**
- Very minimal ViewModel -- only tracks which palette is active for display purposes.
- The actual token configuration happens in Actions (separation of concerns).
- Uses `update()` (GetBuilder pattern) consistent with all other demo ViewModels.

### Phase 3: Create Actions

**File:** `apps/fifty_demo/lib/features/tokens_demo/actions/tokens_demo_actions.dart`

```dart
/// Tokens Demo Actions
///
/// Handles user interactions for the tokens demo feature.
library;

import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/presentation/actions/action_presenter.dart';
import '../controllers/tokens_demo_view_model.dart';

/// Actions for the tokens demo feature.
///
/// Provides palette switching and reset functionality.
class TokensDemoActions {
  /// Creates tokens demo actions with required dependencies.
  TokensDemoActions(this._viewModel, this._presenter);

  final TokensDemoViewModel _viewModel;
  final ActionPresenter _presenter;

  /// Static accessor for convenient access.
  static TokensDemoActions get instance => Get.find<TokensDemoActions>();

  /// The Baltic Blue color configuration.
  static final _balticBlueColors = FiftyPreset.fdlV2.colors.copyWith(
    primary: const Color(0xFF586994),        // Baltic Blue
    primaryHover: const Color(0xFF47567A),   // darkened
    secondary: const Color(0xFF7d869c),      // Lavender Grey
    secondaryHover: const Color(0xFF656D80), // darkened
    success: const Color(0xFFb4c4ae),        // Ash Grey
    accent: const Color(0xFFa2abab),         // Cool Steel
    background: const Color(0xFFe5e8b6),     // Cream
    backgroundDark: const Color(0xFF1A1D2B), // dark variant
    surface: const Color(0xFFD5D8A8),        // slightly darker Cream
    surfaceDark: const Color(0xFF2A2D3B),    // dark variant
    onPrimary: const Color(0xFFe5e8b6),      // Cream on Baltic Blue
    onBackground: const Color(0xFF1A1D2B),   // dark text on Cream
  );

  // ---------------------------------------------------------------------------
  // Palette Actions
  // ---------------------------------------------------------------------------

  /// Applies the Baltic Blue palette and rebuilds the theme.
  void onApplyBalticBlue(BuildContext context) {
    FiftyTokens.configure(colors: _balticBlueColors);
    _rebuildTheme();
    _viewModel.setBalticBlue(active: true);

    if (context.mounted) {
      _presenter.showSuccessSnackBar(
        context,
        'Palette Applied',
        'Baltic Blue palette is now active.',
      );
    }
  }

  /// Resets to the default FDL v2 palette and rebuilds the theme.
  void onResetToFdl(BuildContext context) {
    FiftyTokens.reset();
    _rebuildTheme();
    _viewModel.setBalticBlue(active: false);

    if (context.mounted) {
      _presenter.showSuccessSnackBar(
        context,
        'Palette Reset',
        'FDL v2 palette restored.',
      );
    }
  }

  /// Rebuilds the app theme from current tokens.
  ///
  /// Uses GetX APIs to swap both light and dark ThemeData,
  /// then forces a full widget tree rebuild.
  void _rebuildTheme() {
    Get.changeTheme(FiftyTheme.light());
    // Get.changeDarkTheme may not exist in get ^4.6.6.
    // Get.forceAppUpdate() rebuilds the entire tree, which
    // re-evaluates FiftyTheme.dark() from the GetMaterialApp
    // darkTheme parameter. This is sufficient.
    Get.forceAppUpdate();
  }
}
```

**Key decisions:**
- `_balticBlueColors` is `static final` (not `const` because `copyWith` is not const-constructible). The base values match the TS-003 config exactly.
- `_rebuildTheme()` uses `Get.changeTheme()` + `Get.forceAppUpdate()`. The `Get.forceAppUpdate()` forces the entire widget tree to rebuild, which causes `GetMaterialApp` to re-evaluate its `darkTheme: FiftyTheme.dark()` parameter. This is safer than relying on `Get.changeDarkTheme()` which may not exist in GetX 4.6.6.
- The SnackBar feedback confirms the action visually.

**IMPORTANT NOTE on theme rebuild:**
The `GetMaterialApp` in `fifty_demo_app.dart` uses:
```dart
theme: FiftyTheme.light(),
darkTheme: FiftyTheme.dark(),
```
These are evaluated once at build time. `Get.changeTheme()` replaces the `theme` property. But the `darkTheme` is only re-evaluated when the widget rebuilds. `Get.forceAppUpdate()` triggers that rebuild.

However, `Get.changeTheme()` sets the LIGHT theme. If the app is in dark mode (which it is -- `themeMode: ThemeMode.dark`), we actually need to set the dark theme. Two approaches:

**Option A (recommended):** Call `Get.changeTheme(FiftyTheme.dark())` since the app is in dark mode by default. Then `Get.forceAppUpdate()` to rebuild the tree.

**Option B:** Just call `Get.forceAppUpdate()` alone. The `GetMaterialApp` widget will re-evaluate its `theme:` and `darkTheme:` builder parameters on rebuild because `FiftyTheme.dark()` and `FiftyTheme.light()` read from `FiftyTokens.active` which has already been mutated.

Wait -- the `GetMaterialApp` arguments are NOT builders. They are evaluated eagerly:
```dart
theme: FiftyTheme.light(),      // evaluated once
darkTheme: FiftyTheme.dark(),   // evaluated once
```

So `Get.forceAppUpdate()` rebuilds the `GetMaterialApp` widget, which re-runs `build()`, which re-evaluates `FiftyTheme.light()` and `FiftyTheme.dark()`. This works because `GetMaterialApp` is a StatelessWidget whose build reads these parameters. On `forceAppUpdate()`, it rebuilds from root.

**Conclusion:** `Get.forceAppUpdate()` alone is sufficient. But adding `Get.changeTheme(FiftyTheme.dark())` is a belt-and-suspenders approach that explicitly sets the active theme data. Keep both.

**Revised `_rebuildTheme()`:**
```dart
void _rebuildTheme() {
  // Regenerate ThemeData from updated tokens
  final lightTheme = FiftyTheme.light();
  final darkTheme = FiftyTheme.dark();

  // Set both themes explicitly
  Get.changeTheme(darkTheme);

  // Force full tree rebuild so GetMaterialApp re-evaluates
  Get.forceAppUpdate();
}
```

Actually, `Get.changeTheme` sets the `theme` (light). For the dark theme, GetX uses `Get.rootController.darkTheme`. Let me check if there's a direct way.

The safest approach: just call `Get.forceAppUpdate()`. Since `GetMaterialApp` is rebuilt, it calls `FiftyTheme.dark()` and `FiftyTheme.light()` fresh. This is the cleanest solution.

**Final `_rebuildTheme()`:**
```dart
void _rebuildTheme() {
  Get.forceAppUpdate();
}
```

That's it. `FiftyTokens.configure()` / `FiftyTokens.reset()` mutates the static `_active` preset. The next time `FiftyTheme.dark()` or `FiftyTheme.light()` is called (which happens during `GetMaterialApp.build()`), it reads the updated tokens. `Get.forceAppUpdate()` triggers that rebuild.

### Phase 4: Create Bindings

**File:** `apps/fifty_demo/lib/features/tokens_demo/tokens_demo_bindings.dart`

```dart
/// Tokens Demo Bindings
///
/// Registers Tokens Demo feature dependencies using GetX dependency injection.
library;

import 'package:get/get.dart';

import '../../core/presentation/actions/action_presenter.dart';
import 'actions/tokens_demo_actions.dart';
import 'controllers/tokens_demo_view_model.dart';

/// Registers Tokens Demo feature dependencies.
///
/// **Registered Dependencies**:
/// - [TokensDemoViewModel] - Business logic for tokens demo
/// - [TokensDemoActions] - Action handlers for tokens demo
class TokensDemoBindings implements Bindings {
  @override
  void dependencies() {
    // Register ViewModel (permanent for state persistence)
    if (!Get.isRegistered<TokensDemoViewModel>()) {
      Get.put<TokensDemoViewModel>(
        TokensDemoViewModel(),
        permanent: true,
      );
    }

    // Register Actions
    if (!Get.isRegistered<TokensDemoActions>()) {
      Get.lazyPut<TokensDemoActions>(
        () => TokensDemoActions(
          Get.find<TokensDemoViewModel>(),
          ActionPresenter(),
        ),
        fenix: true,
      );
    }
  }

  /// Cleanup method for state reset.
  static void destroy() {
    if (Get.isRegistered<TokensDemoActions>()) {
      Get.delete<TokensDemoActions>(force: true);
    }
    if (Get.isRegistered<TokensDemoViewModel>()) {
      Get.delete<TokensDemoViewModel>(force: true);
    }
  }
}
```

### Phase 5: Create Demo Page

**File:** `apps/fifty_demo/lib/features/tokens_demo/views/tokens_demo_page.dart`

The page displays:
1. Current palette name header
2. Color swatches grid (6 colors: primary, secondary, surface, success, accent, background) with hex values
3. Two action buttons: "Apply Baltic Blue" / "Reset to FDL v2"

```dart
/// Tokens Demo Page
///
/// Demonstrates runtime palette switching via FiftyTokens.configure().
library;

import 'package:fifty_tokens/fifty_tokens.dart';
import 'package:fifty_ui/fifty_ui.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../shared/widgets/demo_scaffold.dart';
import '../actions/tokens_demo_actions.dart';
import '../controllers/tokens_demo_view_model.dart';

/// Tokens demo page widget.
///
/// Shows color swatches for the active palette and buttons to swap
/// between FDL v2 and Baltic Blue at runtime.
class TokensDemoPage extends GetView<TokensDemoViewModel> {
  const TokensDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TokensDemoViewModel>(
      builder: (viewModel) {
        final actions = Get.find<TokensDemoActions>();
        final colorScheme = Theme.of(context).colorScheme;

        return DemoScaffold(
          title: 'Fifty Tokens',
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Active palette indicator
                const FiftySectionHeader(
                  title: 'Active Palette',
                  subtitle: 'Runtime token configuration demo',
                ),
                _buildPaletteIndicator(context, viewModel),
                SizedBox(height: FiftySpacing.xl),

                // Color swatches
                const FiftySectionHeader(
                  title: 'Color Tokens',
                  subtitle: 'Current semantic color values',
                ),
                _buildColorSwatches(context),
                SizedBox(height: FiftySpacing.xl),

                // Action buttons
                const FiftySectionHeader(
                  title: 'Palette Switcher',
                  subtitle: 'Swap tokens and rebuild theme at runtime',
                ),
                _buildActionButtons(context, viewModel, actions),
                SizedBox(height: FiftySpacing.xl),

                // How it works
                _buildHowItWorks(context),
                SizedBox(height: FiftySpacing.lg),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaletteIndicator(
    BuildContext context,
    TokensDemoViewModel viewModel,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.lg),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(FiftyRadii.sm),
            ),
          ),
          SizedBox(width: FiftySpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.paletteName.toUpperCase(),
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.titleMedium,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: FiftySpacing.xs),
                Text(
                  viewModel.isBalticBlue
                      ? 'Custom palette via FiftyTokens.configure()'
                      : 'Default design tokens (FiftyPreset.fdlV2)',
                  style: TextStyle(
                    fontFamily: FiftyTypography.fontFamily,
                    fontSize: FiftyTypography.bodySmall,
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ),
          ),
          // Configuration status
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: FiftySpacing.sm,
              vertical: FiftySpacing.xs,
            ),
            decoration: BoxDecoration(
              color: viewModel.isBalticBlue
                  ? colorScheme.primary.withValues(alpha: 0.15)
                  : colorScheme.surfaceContainerHighest,
              borderRadius: FiftyRadii.smRadius,
            ),
            child: Text(
              viewModel.isBalticBlue ? 'CUSTOM' : 'DEFAULT',
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.labelSmall,
                fontWeight: FontWeight.bold,
                color: viewModel.isBalticBlue
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.7),
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSwatches(BuildContext context) {
    // Read colors from FiftyColors (which reads from FiftyTokens.active)
    final swatches = [
      ('Primary', FiftyColors.primary),
      ('Secondary', FiftyColors.secondary),
      ('Background', FiftyColors.background),
      ('Surface', FiftyColors.surface),
      ('Success', FiftyColors.success),
      ('Accent', FiftyColors.accent),
    ];

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.md),
      child: Column(
        children: swatches.map((swatch) {
          final (label, color) = swatch;
          return _buildSwatchRow(context, label, color);
        }).toList(),
      ),
    );
  }

  Widget _buildSwatchRow(BuildContext context, String label, Color color) {
    final colorScheme = Theme.of(context).colorScheme;
    final hex = '#${color.value.toRadixString(16).substring(2).toUpperCase()}';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: FiftySpacing.xs),
      child: Row(
        children: [
          // Color swatch
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(FiftyRadii.sm),
              border: Border.all(
                color: colorScheme.outline,
              ),
            ),
          ),
          SizedBox(width: FiftySpacing.md),
          // Label
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodyMedium,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          // Hex value
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: FiftySpacing.sm,
              vertical: FiftySpacing.xs,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: FiftyRadii.smRadius,
            ),
            child: Text(
              hex,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
                letterSpacing: 0.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    TokensDemoViewModel viewModel,
    TokensDemoActions actions,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FiftyButton(
            label: 'APPLY BALTIC BLUE',
            onPressed: viewModel.isBalticBlue
                ? null
                : () => actions.onApplyBalticBlue(context),
            variant: FiftyButtonVariant.primary,
          ),
        ),
        SizedBox(height: FiftySpacing.md),
        SizedBox(
          width: double.infinity,
          child: FiftyButton(
            label: 'RESET TO FDL V2',
            onPressed: viewModel.isBalticBlue
                ? () => actions.onResetToFdl(context)
                : null,
            variant: FiftyButtonVariant.secondary,
          ),
        ),
      ],
    );
  }

  Widget _buildHowItWorks(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return FiftyCard(
      padding: EdgeInsets.all(FiftySpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: colorScheme.onSurface.withValues(alpha: 0.5),
                size: 16,
              ),
              SizedBox(width: FiftySpacing.sm),
              Text(
                'HOW IT WORKS',
                style: TextStyle(
                  fontFamily: FiftyTypography.fontFamily,
                  fontSize: FiftyTypography.bodySmall,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          SizedBox(height: FiftySpacing.sm),
          _buildInfoItem(context,
              'FiftyTokens.configure(colors: ...) sets the active color preset'),
          _buildInfoItem(context,
              'FiftyTheme.dark() / .light() read from FiftyTokens.active'),
          _buildInfoItem(context,
              'Get.forceAppUpdate() rebuilds the entire widget tree'),
          _buildInfoItem(context,
              'All pages reflect the new palette instantly'),
          _buildInfoItem(context,
              'FiftyTokens.reset() restores FDL v2 defaults'),
        ],
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(top: FiftySpacing.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '\u2022',
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(width: FiftySpacing.sm),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: FiftyTypography.fontFamily,
                fontSize: FiftyTypography.bodySmall,
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

**Key design decisions:**
- Color swatches read from `FiftyColors.*` getters (which delegate to `FiftyTokens.active.colors.*`). After `configure()` + rebuild, these return the new values.
- Hex display: converts `Color.value` to hex string.
- Buttons are disabled when already in the target state (Apply disabled when Baltic Blue active; Reset disabled when FDL v2 active).
- "How it Works" section educates users on the token pipeline.
- Pattern matches existing demo pages exactly: `DemoScaffold`, `FiftySectionHeader`, `FiftyCard`, `FiftyButton`.

### Phase 6: Register in App Shell

**File:** `apps/fifty_demo/lib/app/fifty_demo_app.dart`

Add import:
```dart
import '../features/tokens_demo/tokens_demo_bindings.dart';
```

In `_initializeBindings()`, add after the existing bindings:
```dart
TokensDemoBindings().dependencies();
```

### Phase 7: Wire Up Navigation from Packages Hub

**File:** `apps/fifty_demo/lib/features/packages/actions/packages_actions.dart`

Add import:
```dart
import '../../tokens_demo/views/tokens_demo_page.dart';
```

Change the `case 'fifty_tokens':` to navigate instead of showing a snackbar:

Current (lines 98-105):
```dart
case 'fifty_ui':
case 'fifty_tokens':
case 'fifty_theme':
  _presenter.showSuccessSnackBar(
    context,
    'UI Kit',
    'View ${package.name} components in the UI Kit tab.',
  );
  break;
```

New:
```dart
case 'fifty_tokens':
  Get.to<void>(() => const TokensDemoPage());
  break;
case 'fifty_ui':
case 'fifty_theme':
  _presenter.showSuccessSnackBar(
    context,
    'UI Kit',
    'View ${package.name} components in the UI Kit tab.',
  );
  break;
```

**Note:** The `fifty_tokens` PackageDemo entry already exists with `isAvailable: true` and `icon: Icons.palette_outlined` -- no changes needed to the ViewModel.

### Phase 8: Sync ViewModel State on Init

One edge case: if the user navigates to the Tokens page when Baltic Blue is already active (e.g., they applied it previously and navigated away), the ViewModel should reflect reality.

Add to `TokensDemoViewModel.onInit()`:
```dart
@override
void onInit() {
  super.onInit();
  // Sync state with actual token configuration
  _isBalticBlue = FiftyTokens.isConfigured;
}
```

This uses `FiftyTokens.isConfigured` (which returns `true` if `configure()` or `load()` was called and `reset()` has not been called since). Since the ViewModel is `permanent: true`, this only runs once, but it handles the case where the app was configured before the ViewModel was created.

## Testing Strategy

### Manual Testing
1. **Cold start:** Launch app, verify burgundy/FDL v2 palette is active on all pages
2. **Navigate to Tokens page:** Packages hub > Fifty Tokens card > verify page loads with FDL v2 indicator and correct hex values
3. **Apply Baltic Blue:** Tap button, verify:
   - All color swatches update to Baltic Blue values
   - Hex values update
   - Navigate to other pages (Home, UI Kit, Settings) -- all reflect new palette
   - Button states: "Apply" disabled, "Reset" enabled
4. **Reset to FDL v2:** Tap button, verify:
   - All color swatches return to burgundy values
   - All pages reflect original palette
   - Button states swap back
5. **Theme mode interaction:** Switch to light mode in Settings, apply Baltic Blue, verify light theme also uses new colors
6. **Persistence check:** Apply Baltic Blue, kill app, relaunch -- should start with FDL v2 (no persistence by design)

### Automated Testing
No new automated tests required for this feature (it is a demo page with minimal business logic). The `FiftyTokens.configure()` and `FiftyTokens.reset()` APIs are already covered by 317 passing tests in the `fifty_tokens` package.

If desired, a simple widget test could verify:
- `TokensDemoViewModel` tracks `isBalticBlue` correctly
- `paletteName` returns correct string based on state

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| `Get.forceAppUpdate()` does not trigger `GetMaterialApp` rebuild | Low | High | Fallback: wrap `GetMaterialApp` in `Obx` or use `Get.changeTheme()` explicitly. GetX docs confirm `forceAppUpdate()` rebuilds from root. |
| `Get.changeDarkTheme()` does not exist in GetX 4.6.6 | Medium | Low | Plan does not rely on it. Uses `Get.forceAppUpdate()` which triggers full rebuild. |
| Color hex display uses wrong format for `Color.value` in newer Dart | Low | Low | `Color.value` returns the 32-bit ARGB integer. `toRadixString(16).substring(2)` strips the alpha channel. Verify with actual values. |
| TS-003 revert breaks something else in main.dart | Very Low | Low | The TS-003 config was explicitly temporary (visual test). Only main.dart references it. Other files do not depend on Baltic Blue being set at startup. |
| Palette switch does not propagate to FiftyThemeExtension custom fields | Low | Medium | `FiftyTheme.dark()` and `FiftyTheme.light()` build `FiftyThemeExtension` from `FiftyColors.*` getters, which read from `FiftyTokens.active`. So extensions are rebuilt with new values. |

## File Creation Summary

```
apps/fifty_demo/lib/features/tokens_demo/
  views/
    tokens_demo_page.dart          (CREATE)
  controllers/
    tokens_demo_view_model.dart    (CREATE)
  actions/
    tokens_demo_actions.dart       (CREATE)
  tokens_demo_bindings.dart        (CREATE)
```

**Total files:** 4 new, 3 modified
