# Fifty UI - Component Library

This is the **Construction Blueprint** for `fifty_ui`.

While `fifty_theme` provided the definitions (colors, text styles), `fifty_ui` provides the **Tangible Components**. This package contains the actual Widgets that you will use to build your apps.

Every widget here follows the **FDL v2** specification: **Burgundy primary, mode-aware colors, Manrope typography, motion tokens.**

---

## Package: `fifty_ui`

**Role:** The Component Library (The Hardware).
**Dependencies:** `flutter`, `flutter_animate`, `fifty_tokens`, `fifty_theme`.
**Version:** 1.0.0

---

## Component Inventory (28 Components)

### Buttons (2)

| Component | Description | Key Features |
|-----------|-------------|--------------|
| `FiftyButton` | Primary action button | Variants (primary/secondary/ghost/danger), sizes (sm/md/lg), icon support, expanded mode |
| `FiftyIconButton` | Circular icon button | Icon-only actions, sizes (sm/md/lg), hover effects |

### Inputs (6)

| Component | Description | Key Features |
|-----------|-------------|--------------|
| `FiftyTextField` | Text input field | 48px height, xl radius, prefix/suffix support, validation |
| `FiftySwitch` | Kinetic toggle | ON = slateGrey (not primary), smooth animation |
| `FiftySlider` | Range slider | Mode-aware styling, labels, discrete/continuous |
| `FiftyDropdown` | Dropdown selector | xl radius, search support, multi-select option |
| `FiftyCheckbox` | Multi-select control | v2 styling, label support, indeterminate state |
| `FiftyRadio` | Single-select control | v2 styling, radio group support |

### Controls (1)

| Component | Description | Key Features |
|-----------|-------------|--------------|
| `FiftySegmentedControl` | Pill-style segmented control | Tab-like selection, animated indicator |

### Containers (1)

| Component | Description | Key Features |
|-----------|-------------|--------------|
| `FiftyCard` | Card container | xxl/xxxl radius, md shadow, optional halftone texture |

### Display (7)

| Component | Description | Key Features |
|-----------|-------------|--------------|
| `FiftyBadge` | Status indicator | Outlined pill style, variants (tech/status/custom) |
| `FiftyChip` | Tag/label component | Removable, selectable, icon support |
| `FiftyDivider` | Themed divider | Horizontal/vertical, label support |
| `FiftyDataSlate` | Key-value display panel | Grid layout, titled sections |
| `FiftyAvatar` | User avatar | Image/initials fallback, sizes, status indicator |
| `FiftyProgressBar` | Linear progress indicator | Determinate/indeterminate, color variants |
| `FiftyLoadingIndicator` | Text-based loading | Cycling status messages, terminal aesthetic |

### Feedback (3)

| Component | Description | Key Features |
|-----------|-------------|--------------|
| `FiftySnackbar` | Toast notification | Success/error/warning/info variants, actions |
| `FiftyDialog` | Modal dialog | xxxl radius, title/content/actions slots |
| `FiftyTooltip` | Hover tooltip | Positioning options, rich content support |

### Organisms (2)

| Component | Description | Key Features |
|-----------|-------------|--------------|
| `FiftyNavBar` | Floating navigation bar | Glassmorphism, dynamic island style, pill shape |
| `FiftyHero` | Dramatic headline text | ALL CAPS, Manrope font, sizes (display/h1/h2), glitch effect |
| `FiftyHeroSection` | Hero with subtitle | Combines FiftyHero with subtitle, consistent spacing |

### Molecules (1)

| Component | Description | Key Features |
|-----------|-------------|--------------|
| `FiftyCodeBlock` | Code display | Syntax highlighting, copy button, language label |

### Utils/Effects (5)

| Component | Description | Key Features |
|-----------|-------------|--------------|
| `KineticEffect` | Hover/press animation wrapper | Scale on hover, press-down effect |
| `GlitchEffect` | RGB chromatic aberration | Trigger on mount or on-demand, intensity control |
| `GlowContainer` | Reusable glow wrapper | Animated glow, color customization |
| `HalftonePainter` | CustomPainter for halftone dots | Configurable dot size and spacing |
| `HalftoneOverlay` | Widget wrapper for halftone textures | Easy integration with any widget |

---

## Directory Structure

```text
lib/
├── src/
│   ├── buttons/
│   │   ├── fifty_button.dart
│   │   └── fifty_icon_button.dart
│   ├── inputs/
│   │   ├── fifty_text_field.dart
│   │   ├── fifty_switch.dart
│   │   ├── fifty_slider.dart
│   │   ├── fifty_dropdown.dart
│   │   ├── fifty_checkbox.dart
│   │   └── fifty_radio.dart
│   ├── controls/
│   │   └── fifty_segmented_control.dart
│   ├── containers/
│   │   └── fifty_card.dart
│   ├── display/
│   │   ├── fifty_avatar.dart
│   │   ├── fifty_badge.dart
│   │   ├── fifty_chip.dart
│   │   ├── fifty_data_slate.dart
│   │   ├── fifty_divider.dart
│   │   ├── fifty_loading_indicator.dart
│   │   └── fifty_progress_bar.dart
│   ├── feedback/
│   │   ├── fifty_dialog.dart
│   │   ├── fifty_snackbar.dart
│   │   └── fifty_tooltip.dart
│   ├── organisms/
│   │   ├── fifty_hero.dart         # Contains FiftyHero + FiftyHeroSection
│   │   └── fifty_nav_bar.dart
│   ├── molecules/
│   │   └── fifty_code_block.dart
│   └── utils/
│       ├── glitch_effect.dart
│       ├── glow_container.dart
│       ├── halftone_painter.dart   # Contains HalftonePainter + HalftoneOverlay
│       └── kinetic_effect.dart
├── fifty_ui.dart                   # Main Export
└── pubspec.yaml
```

---

## Usage

### Installation

```yaml
dependencies:
  fifty_ui:
    path: ../fifty_ui
  fifty_theme:
    path: ../fifty_theme
```

### Basic Setup

```dart
import 'package:fifty_theme/fifty_theme.dart';
import 'package:fifty_ui/fifty_ui.dart';

MaterialApp(
  theme: FiftyTheme.dark(),
  home: MyApp(),
);
```

### Component Examples

**Button:**
```dart
FiftyButton(
  label: 'DEPLOY',
  onPressed: () => handleDeploy(),
  variant: FiftyButtonVariant.primary,
  size: FiftyButtonSize.large,
  expanded: true,
)
```

**Checkbox:**
```dart
FiftyCheckbox(
  value: isSelected,
  onChanged: (value) => setState(() => isSelected = value),
  label: 'Enable notifications',
)
```

**Radio:**
```dart
FiftyRadio<String>(
  value: 'option1',
  groupValue: selectedOption,
  onChanged: (value) => setState(() => selectedOption = value),
  label: 'Option 1',
)
```

**Segmented Control:**
```dart
FiftySegmentedControl<int>(
  segments: [
    FiftySegment(value: 0, label: 'Day'),
    FiftySegment(value: 1, label: 'Week'),
    FiftySegment(value: 2, label: 'Month'),
  ],
  selected: selectedIndex,
  onSelectionChanged: (value) => setState(() => selectedIndex = value),
)
```

**Code Block:**
```dart
FiftyCodeBlock(
  code: 'void main() => runApp(MyApp());',
  language: 'dart',
  showCopyButton: true,
)
```

**Hero Section:**
```dart
FiftyHeroSection(
  title: 'Welcome to Fifty',
  subtitle: 'Build beautiful apps faster',
  glitchOnMount: true,
  titleGradient: LinearGradient(
    colors: [FiftyColors.burgundy, FiftyColors.cream],
  ),
)
```

**Nav Bar:**
```dart
FiftyNavBar(
  items: [
    FiftyNavItem(icon: Icons.home, label: 'Home'),
    FiftyNavItem(icon: Icons.search, label: 'Search'),
    FiftyNavItem(icon: Icons.person, label: 'Profile'),
  ],
  selectedIndex: currentIndex,
  onItemTapped: (index) => setState(() => currentIndex = index),
)
```

---

## Design Principles

### FDL v2 Compliance

All components follow the Fifty Design Language v2 specification:

- **Primary Color:** Burgundy (#8B2635)
- **Font Family:** Manrope
- **Mode Support:** Dark and light themes
- **Motion:** Using FDL timing tokens
- **Accessibility:** WCAG 2.1 AA compliant

### Component Categories

| Category | Purpose | Examples |
|----------|---------|----------|
| **Atoms** | Primitive building blocks | Button, TextField, Switch |
| **Molecules** | Composed components | CodeBlock, DataSlate |
| **Organisms** | Complex structures | NavBar, Hero |
| **Utils** | Animation/effect wrappers | KineticEffect, GlitchEffect |

---

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  fifty_tokens: ^1.0.0
  fifty_theme: ^1.0.0
  flutter_animate: ^4.2.0
```

---

**Last Updated:** 2026-01-20
**Version:** 1.0.0
**Components:** 28 total
