# Migration Guide: Theme Customization Pipeline (v2.0)

This guide covers all changes introduced by the AC-001 Theme Customization pipeline across `fifty_tokens`, `fifty_theme`, and `fifty_ui`.

---

## Overview

The AC-001 pipeline introduces **runtime token customization** and **theme parameterization** to the Fifty Design Language. Previously, all design tokens were compile-time constants. Now, tokens are backed by configurable getters that default to the same FDL v2 values but can be overridden at runtime.

**What changed:**

1. `fifty_tokens` token values converted from `static const` to `static get`
2. `fifty_theme` accepts optional `colorScheme`, `fontFamily`, and `fontSource` parameters
3. `fifty_ui` widgets resolve colors from `Theme.of(context).colorScheme` instead of direct `FiftyColors.*`
4. Engine packages (`fifty_forms`, `fifty_achievement_engine`, `fifty_connectivity`, `fifty_speech_engine`) similarly updated

**What stayed the same:**

- All default values are identical to FDL v2
- If you do not call `FiftyTokens.configure()`, everything works exactly as before
- Public API surface for widgets is unchanged

---

## Breaking Change: `const` Removal

### Why

Token values like `FiftySpacing.sm` are now getters (to support runtime configuration). Dart getters cannot appear in `const` expressions.

### What is affected

Only `FiftySpacing.*` tokens appeared in `const` contexts in practice. `FiftyRadii`, `FiftyTypography`, `FiftyMotion`, and `FiftyBreakpoints` had zero `const`-context usages in the ecosystem.

### How to fix

Search your codebase for `const` expressions containing `FiftySpacing`:

```bash
grep -rn "const.*FiftySpacing\." lib/ --include="*.dart"
```

Then remove `const` from the enclosing expression.

**Pattern A: const SizedBox**

```dart
// Before (compile error)
const SizedBox(height: FiftySpacing.sm)

// After
SizedBox(height: FiftySpacing.sm)
```

**Pattern B: const EdgeInsets**

```dart
// Before (compile error)
padding: const EdgeInsets.all(FiftySpacing.md),

// After
padding: EdgeInsets.all(FiftySpacing.md),
```

**Pattern C: const EdgeInsets.symmetric / .only**

```dart
// Before (compile error)
margin: const EdgeInsets.symmetric(horizontal: FiftySpacing.lg),

// After
margin: EdgeInsets.symmetric(horizontal: FiftySpacing.lg),
```

**Pattern D: Propagation (parent const with FiftySpacing child)**

When a parent widget has `const` and a child uses `FiftySpacing`, remove `const` from the parent and push it down to children that are truly const:

```dart
// Before
const Padding(
  padding: EdgeInsets.all(FiftySpacing.md),
  child: Text('hello'),
)

// After
Padding(
  padding: EdgeInsets.all(FiftySpacing.md),
  child: const Text('hello'),
)
```

**Pattern E: Default parameter values**

If a constructor default uses `FiftySpacing`, replace with the literal value:

```dart
// Before (compile error)
MyWidget({this.spacing = FiftySpacing.md});

// After
MyWidget({this.spacing = 12}); // FiftySpacing.md == 12
```

### Impact

This is a purely mechanical change with no behavioral impact. Widget layout, spacing, and appearance are identical.

---

## New Feature: Token Configuration

### FiftyTokens.configure()

Override any token category at app startup:

```dart
import 'package:fifty_tokens/fifty_tokens.dart';

void main() {
  FiftyTokens.configure(
    colors: FiftyColorConfig(
      primary: Color(0xFF1A73E8),
      secondary: Color(0xFF34A853),
    ),
    typography: FiftyTypographyConfig(
      fontFamily: 'Inter',
      fontSource: FontSource.googleFonts,
    ),
    spacing: FiftySpacingConfig(
      base: 4,
      sm: 8,
      md: 16,
      lg: 24,
    ),
    radii: FiftyRadiiConfig(
      md: 12,
      lg: 16,
    ),
    motion: FiftyMotionConfig(
      fast: Duration(milliseconds: 200),
    ),
  );

  runApp(MyApp());
}
```

If you never call `configure()`, all tokens retain their FDL v2 defaults.

### FiftyTokens.reset()

Restore all tokens to FDL v2 defaults:

```dart
FiftyTokens.reset();
```

### Font Configuration

Choose between Google Fonts (runtime download) and asset fonts (bundled):

```dart
// Google Fonts (default)
FiftyTokens.configure(
  typography: FiftyTypographyConfig(
    fontFamily: 'Manrope',
    fontSource: FontSource.googleFonts,
  ),
);

// Asset fonts (offline, no network)
FiftyTokens.configure(
  typography: FiftyTypographyConfig(
    fontFamily: 'Manrope',
    fontSource: FontSource.asset,
  ),
);
```

---

## New Feature: Theme Parameterization

### FiftyTheme.dark() / FiftyTheme.light()

Both methods now accept optional parameters:

```dart
MaterialApp(
  theme: FiftyTheme.dark(
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF1A73E8),
      secondary: Color(0xFF34A853),
    ),
    fontFamily: 'Inter',
    fontSource: FontSource.googleFonts,
    extension: FiftyThemeExtension.dark().copyWith(
      success: Colors.green,
    ),
  ),
);
```

If no parameters are passed, the theme uses FDL v2 defaults (same as before).

### FiftyThemeExtension Customization

Override semantic colors, shadows, and motion tokens:

```dart
final customExtension = FiftyThemeExtension.dark().copyWith(
  accent: Color(0xFFFF6B6B),
  success: Color(0xFF00C853),
  warning: Color(0xFFFFAB00),
);

final theme = FiftyTheme.dark(extension: customExtension);
```

---

## New Feature: colorScheme-based Widgets

### What changed

`fifty_ui` widgets now resolve colors from `Theme.of(context).colorScheme` and `FiftyThemeExtension` instead of directly accessing `FiftyColors.*` and `FiftyShadows.*`.

### Why

This ensures widgets automatically adapt to custom color schemes passed through `FiftyTheme.dark(colorScheme: ...)`.

### Access pattern

```dart
@override
Widget build(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final fifty = Theme.of(context).extension<FiftyThemeExtension>();

  return Container(
    color: colorScheme.surface,
    child: Text(
      'Hello',
      style: TextStyle(color: colorScheme.onSurface),
    ),
    decoration: BoxDecoration(
      boxShadow: fifty?.shadowMd ?? FiftyShadows.md,
    ),
  );
}
```

**Structural tokens** (`FiftySpacing`, `FiftyRadii`, `FiftyTypography`) are still accessed directly -- they are not color-dependent and do not need to flow through the theme.

---

## 4 Levels of Customization

### Level 1: Zero Config (FDL Defaults)

No changes needed. Everything works as before:

```dart
MaterialApp(
  theme: FiftyTheme.dark(),
  home: MyApp(),
);
```

### Level 2: Token-Level

Override individual design tokens globally:

```dart
FiftyTokens.configure(
  colors: FiftyColorConfig(
    primary: Color(0xFF1A73E8),
  ),
  spacing: FiftySpacingConfig(
    md: 16,
  ),
);

MaterialApp(
  theme: FiftyTheme.dark(),
  home: MyApp(),
);
```

### Level 3: Theme-Level

Pass a custom `ColorScheme` to the theme factory:

```dart
MaterialApp(
  theme: FiftyTheme.dark(
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF1A73E8),
      secondary: Color(0xFF34A853),
      surface: Color(0xFF121212),
    ),
    fontFamily: 'Inter',
  ),
  home: MyApp(),
);
```

### Level 4: Widget-Level

Override individual component themes via `ThemeData.copyWith`:

```dart
final theme = FiftyTheme.dark().copyWith(
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue,
    ),
  ),
);
```

---

## Package Version Changes

| Package | Old Version | New Version | Change Type |
|---------|-------------|-------------|-------------|
| `fifty_tokens` | 1.0.3 | 2.0.0 | MAJOR (breaking: const to getter) |
| `fifty_theme` | 1.0.1 | 2.0.0 | MAJOR (new parameterized API) |
| `fifty_ui` | 0.6.2 | 0.7.0 | MINOR (0.x semver allows breaking in minor) |
| `fifty_forms` | 0.1.2 | 0.2.0 | MINOR |
| `fifty_connectivity` | 0.1.3 | 0.2.0 | MINOR |
| `fifty_achievement_engine` | 0.1.3 | 0.2.0 | MINOR |
| `fifty_speech_engine` | 0.1.2 | 0.2.0 | MINOR |
| `fifty_skill_tree` | 0.1.2 | 0.2.0 | MINOR |

### Updating Dependencies

```yaml
dependencies:
  fifty_tokens: ^2.0.0
  fifty_theme: ^2.0.0
  fifty_ui: ^0.7.0
```
