# fifty_ui

```
================================================================================
  FIFTY UI COMPONENT LIBRARY
  Kinetic Brutalism Design System
================================================================================
```

FDL-styled Flutter components for the fifty.dev ecosystem.

## Overview

`fifty_ui` provides a comprehensive set of widgets that follow the Fifty Design Language (FDL) specification. Built on top of `fifty_tokens` and `fifty_theme`, these components embody the **Kinetic Brutalism** doctrine:

> **Heavy structure. Fast motion. Raw feedback.**

### Core Principles

| Principle | Implementation |
|-----------|----------------|
| Crimson glow focus states | Signature fifty.dev visual effect on all interactive elements |
| Zero elevation | No drop shadows - only outlines and glows |
| Motion animations | FDL timing tokens (150ms fast, 300ms compiling) |
| Dark-first design | Optimized for OLED displays, voidBlack background |

---

## Installation

### Path Dependency (Monorepo)

```yaml
dependencies:
  fifty_ui:
    path: ../fifty_ui
  fifty_theme:
    path: ../fifty_theme
  fifty_tokens:
    path: ../fifty_tokens
```

### Git Dependency

```yaml
dependencies:
  fifty_ui:
    git:
      url: https://github.com/fiftynotai/fifty_eco_system.git
      path: packages/fifty_ui
  fifty_theme:
    git:
      url: https://github.com/fiftynotai/fifty_eco_system.git
      path: packages/fifty_theme
  fifty_tokens:
    git:
      url: https://github.com/fiftynotai/fifty_eco_system.git
      path: packages/fifty_tokens
```

---

## Quick Start

### 1. Wrap your app with FiftyTheme

```dart
import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_ui/fifty_ui.dart';

void main() {
  runApp(
    MaterialApp(
      theme: FiftyTheme.dark(),
      home: MyApp(),
    ),
  );
}
```

### 2. Use the components

```dart
FiftyButton(
  label: 'DEPLOY',
  onPressed: () => handleDeploy(),
  variant: FiftyButtonVariant.primary,
  icon: Icons.rocket_launch,
  isGlitch: true,
  shape: FiftyButtonShape.sharp,
)
```

---

## Component Catalog

### Buttons

#### FiftyButton

Primary action button following the "Kinetic Switch" specification.

```dart
// Primary with glitch effect
FiftyButton(
  label: 'DEPLOY',
  onPressed: () => handleDeploy(),
  variant: FiftyButtonVariant.primary,
  isGlitch: true,
  shape: FiftyButtonShape.sharp,
)

// Pill-shaped secondary
FiftyButton(
  label: 'CANCEL',
  onPressed: () => Navigator.pop(context),
  variant: FiftyButtonVariant.secondary,
  shape: FiftyButtonShape.pill,
)

// Loading state (animated dots, not spinner)
FiftyButton(
  label: 'PROCESSING',
  onPressed: null,
  loading: true,
)
```

**Properties:**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `label` | String | required | Button text (rendered uppercase) |
| `onPressed` | VoidCallback? | null | Tap callback |
| `variant` | FiftyButtonVariant | primary | Visual style |
| `size` | FiftyButtonSize | medium | Height: small(32), medium(40), large(48) |
| `shape` | FiftyButtonShape | sharp | Border radius: sharp(4px), pill(100px) |
| `isGlitch` | bool | false | RGB split effect on hover |
| `loading` | bool | false | Show animated dots instead of label |
| `icon` | IconData? | null | Leading icon |
| `expanded` | bool | false | Fill available width |

**Variants:** `primary`, `secondary`, `ghost`, `danger`

---

#### FiftyIconButton

Circular icon button with required tooltip for accessibility.

```dart
FiftyIconButton(
  icon: Icons.settings,
  tooltip: 'Open settings',
  onPressed: () => openSettings(),
  variant: FiftyIconButtonVariant.primary,
)
```

---

### Inputs

#### FiftyTextField

Text input styled as a terminal command line.

```dart
// Standard with full border
FiftyTextField(
  controller: _emailController,
  label: 'Email',
  hint: 'Enter your email',
  prefix: Icon(Icons.email),
)

// Terminal style (bottom border + chevron prefix)
FiftyTextField(
  controller: _commandController,
  borderStyle: FiftyBorderStyle.bottom,
  prefixStyle: FiftyPrefixStyle.chevron,
  cursorStyle: FiftyCursorStyle.block,
  hint: 'Enter command',
)

// Comment prefix style
FiftyTextField(
  controller: _noteController,
  prefixStyle: FiftyPrefixStyle.comment, // Shows "//"
)
```

**Properties:**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `borderStyle` | FiftyBorderStyle | full | Border rendering: full, bottom, none |
| `prefixStyle` | FiftyPrefixStyle? | null | Prefix character: chevron(">"), comment("//"), custom, none |
| `customPrefix` | String? | null | Custom prefix when prefixStyle is custom |
| `cursorStyle` | FiftyCursorStyle | line | Cursor type: line, block, underscore |
| `terminalStyle` | bool | false | Legacy: enables chevron prefix + bottom border |

---

### Containers

#### FiftyCard

Bento-style data container with kinetic hover effects.

```dart
FiftyCard(
  onTap: () => selectItem(),
  selected: isSelected,
  scanlineOnHover: true,
  hasTexture: true,
  hoverScale: 1.02,
  child: CardContent(),
)
```

**Properties:**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `hasTexture` | bool | false | Halftone dot pattern overlay |
| `hoverScale` | double | 1.02 | Scale factor on hover (1.0 to disable) |
| `scanlineOnHover` | bool | true | Sweeping scanline effect on hover |
| `selected` | bool | false | Crimson border + glow state |

---

### Display

#### FiftyBadge

Status indicator pills with optional glow animation.

```dart
// Standard badge
FiftyBadge(
  label: 'LIVE',
  variant: FiftyBadgeVariant.success,
  showGlow: true,
)

// Factory constructors for common patterns
FiftyBadge.tech('FLUTTER'),   // Gray/hyperChrome border
FiftyBadge.status('ONLINE'),  // Green with glow
FiftyBadge.ai('IGRIS'),       // IgrisGreen with glow
```

**Variants:** `primary`, `success`, `warning`, `error`, `neutral`

**Factory Constructors:**

| Factory | Color | Glow | Use Case |
|---------|-------|------|----------|
| `.tech()` | HyperChrome | No | Technology labels |
| `.status()` | Success green | Yes | Status indicators |
| `.ai()` | IgrisGreen | Yes | AI-related badges |

---

#### FiftyChip

Tag/label component with delete action.

```dart
FiftyChip(
  label: 'DEPLOYED',
  variant: FiftyChipVariant.success,
  onDeleted: () => removeTag(),
)
```

---

#### FiftyDivider

Themed horizontal or vertical divider.

```dart
FiftyDivider()
FiftyDivider(vertical: true, height: 40)
```

---

#### FiftyDataSlate

Terminal-style key-value display panel.

```dart
FiftyDataSlate(
  title: 'SYSTEM STATUS',
  data: {
    'CPU': '45%',
    'Memory': '8.2 GB',
    'Uptime': '72h 14m',
  },
)
```

---

#### FiftyAvatar

Circular avatar with image or fallback initials.

```dart
FiftyAvatar(
  imageUrl: 'https://example.com/avatar.jpg',
  fallbackText: 'JD',
  size: 48,
)
```

---

#### FiftyProgressBar

Linear progress indicator with crimson fill.

```dart
FiftyProgressBar(
  value: 0.65,
  label: 'UPLOADING',
  showPercentage: true,
)
```

---

#### FiftyLoadingIndicator

Text-based loading indicator (no spinners per FDL).

```dart
// Animated dots: "> LOADING." -> "> LOADING.." -> "> LOADING..."
FiftyLoadingIndicator(
  text: 'LOADING',
  style: FiftyLoadingStyle.dots,
  size: FiftyLoadingSize.medium,
)

// Sequence mode: cycles through custom messages
FiftyLoadingIndicator(
  style: FiftyLoadingStyle.sequence,
  sequences: [
    '> INITIALIZING...',
    '> LOADING ASSETS...',
    '> ESTABLISHING LINK...',
    '> COMPILING...',
  ],
)
```

**Styles:**

| Style | Description |
|-------|-------------|
| `dots` | Animated dots sequence: "." -> ".." -> "..." |
| `pulse` | Text opacity pulsing effect |
| `static` | No animation (for reduced motion) |
| `sequence` | Cycles through custom text sequences |

---

### Feedback

#### FiftySnackbar

Toast notification with semantic variants.

```dart
FiftySnackbar.show(
  context,
  message: 'Deployment successful!',
  variant: FiftySnackbarVariant.success,
);
```

---

#### FiftyDialog

Modal dialog with animated border glow.

```dart
showFiftyDialog(
  context: context,
  builder: (context) => FiftyDialog(
    title: 'CONFIRM',
    content: Text('Proceed with action?'),
    actions: [
      FiftyButton(
        label: 'CANCEL',
        variant: FiftyButtonVariant.ghost,
        onPressed: () => Navigator.pop(context),
      ),
      FiftyButton(
        label: 'CONFIRM',
        onPressed: () => handleConfirm(context),
      ),
    ],
  ),
);
```

---

#### FiftyTooltip

Hover-triggered tooltip wrapper.

```dart
FiftyTooltip(
  message: 'Click to deploy',
  child: FiftyButton(...),
)
```

---

### Navigation

#### FiftyNavBar

Floating "Dynamic Island" style navigation bar with glassmorphism.

```dart
FiftyNavBar(
  items: [
    FiftyNavItem(label: 'Home', icon: Icons.home),
    FiftyNavItem(label: 'Search', icon: Icons.search),
    FiftyNavItem(label: 'Profile', icon: Icons.person),
  ],
  selectedIndex: _currentIndex,
  onItemSelected: (index) => setState(() => _currentIndex = index),
  style: FiftyNavBarStyle.pill,
)
```

**Features:**
- Glassmorphism: 20px blur + 50% black opacity
- Pill or standard border radius
- Active item crimson underbar indicator

---

### Typography

#### FiftyHero

Monument Extended headline text for dramatic impact.

```dart
FiftyHero(
  text: 'Welcome to Fifty',
  size: FiftyHeroSize.display,
  glitchOnMount: true,
  gradient: LinearGradient(
    colors: [FiftyColors.crimsonPulse, FiftyColors.terminalWhite],
  ),
)

// Hero section with subtitle
FiftyHeroSection(
  title: 'The Future of AI',
  subtitle: 'Powered by Fifty.ai',
  glitchOnMount: true,
)
```

**Sizes:**

| Size | Font Size | Use Case |
|------|-----------|----------|
| `display` | 64px | Maximum impact headlines |
| `h1` | 48px | Major headlines |
| `h2` | 32px | Section headers |

---

#### FiftyCodeBlock

Terminal-style code display with syntax highlighting.

```dart
FiftyCodeBlock(
  code: '''
void main() {
  print('Hello, Fifty!');
}
''',
  language: 'dart',
  showLineNumbers: true,
  copyButton: true,
)
```

**Syntax Highlighting Colors:**
- Keywords: Crimson
- Strings: IgrisGreen
- Comments: HyperChrome (italic)
- Numbers: Warning (amber)

---

### Effects

#### KineticEffect

Reusable hover/press scale animation wrapper.

```dart
KineticEffect(
  onTap: () => handleTap(),
  hoverScale: 1.02,
  pressScale: 0.95,
  child: MyCard(),
)
```

**Properties:**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `hoverScale` | double | 1.02 | Scale on hover |
| `pressScale` | double | 0.95 | Scale on press |
| `enabled` | bool | true | Enable/disable effect |

---

#### GlitchEffect

RGB chromatic aberration effect.

```dart
GlitchEffect(
  triggerOnHover: true,
  triggerOnMount: false,
  intensity: 0.8,
  offset: 3.0,
  child: Text('GLITCH'),
)
```

**Properties:**

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `triggerOnHover` | bool | false | Trigger on mouse enter |
| `triggerOnMount` | bool | false | Trigger on widget mount |
| `intensity` | double | 1.0 | Effect visibility (0.0-1.0) |
| `offset` | double | 3.0 | RGB channel separation pixels |

---

## Design Philosophy: Kinetic Brutalism

The FDL defines three core tenets:

### 1. Heavy Structure
- Bold, monospace typography (JetBrains Mono)
- Monument Extended for headlines
- Solid gunmetal containers with crisp borders
- No rounded corners except on pills (4px standard, 100px pill)

### 2. Fast Motion
- Animations complete in 150ms (fast) or 300ms (compiling)
- Scale transformations feel "weighty" (0.95 press, 1.02 hover)
- No spinners - text sequences convey loading
- Instant color transitions on hover

### 3. Raw Feedback
- Crimson glow on focus (2px border + box shadow)
- Scanline effects on card hover
- RGB glitch effects for emphasis
- No drop shadows - only outlines and glows

---

## Theme Access Pattern

All components access theme via `FiftyThemeExtension`:

```dart
final theme = Theme.of(context);
final fifty = theme.extension<FiftyThemeExtension>()!;
final colorScheme = theme.colorScheme;

// Access FDL tokens
fifty.focusGlow      // Crimson box shadow
fifty.fast           // 150ms duration
fifty.compiling      // 300ms duration
fifty.standardCurve  // easeOutExpo
fifty.success        // Success green
fifty.igrisGreen     // AI indicator green
```

---

## Accessibility

All components support:
- Reduced motion preferences (`MediaQuery.disableAnimations`)
- Semantic labels for screen readers
- Required tooltips on icon buttons
- Focus visible states
- Sufficient color contrast ratios

---

## Example App

See the `example/` directory for a complete gallery app demonstrating all components.

```bash
cd example
flutter run
```

---

## Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` | >=3.0.0 | Flutter SDK |
| `fifty_tokens` | path | Design tokens |
| `fifty_theme` | path | Theme integration |
| `flutter_animate` | ^4.5.0 | Animation utilities |

---

## License

MIT License - See LICENSE file for details.

---

```
================================================================================
  Heavy structure. Fast motion. Raw feedback.
  Built for the fifty.dev ecosystem.
================================================================================
```
