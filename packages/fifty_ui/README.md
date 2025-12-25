# fifty_ui

FDL-styled Flutter components for the fifty.dev ecosystem.

[![pub package](https://img.shields.io/pub/v/fifty_ui.svg)](https://pub.dev/packages/fifty_ui)

## Overview

`fifty_ui` provides a comprehensive set of widgets that follow the Fifty Design Language (FDL) specification. Built on top of `fifty_tokens` and `fifty_theme`, these components feature:

- **Crimson glow focus states** - The signature fifty.dev visual effect
- **Zero elevation** - No drop shadows, only outlines and glows
- **Motion animations** - Using FDL timing tokens for consistent feel
- **Dark-first design** - Optimized for OLED displays

## Installation

Add these packages to your `pubspec.yaml`:

```yaml
dependencies:
  fifty_ui:
    path: ../fifty_ui
  fifty_theme:
    path: ../fifty_theme
  fifty_tokens:
    path: ../fifty_tokens
```

## Quick Start

1. **Wrap your app with FiftyTheme:**

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

2. **Use the components:**

```dart
FiftyButton(
  label: 'DEPLOY',
  onPressed: () => handleDeploy(),
  variant: FiftyButtonVariant.primary,
  icon: Icons.rocket_launch,
)
```

## Components

### Buttons

#### FiftyButton

Primary action button with variants and sizes.

```dart
// Primary button
FiftyButton(
  label: 'Submit',
  onPressed: () {},
  variant: FiftyButtonVariant.primary,
)

// Secondary button
FiftyButton(
  label: 'Cancel',
  onPressed: () {},
  variant: FiftyButtonVariant.secondary,
)

// With icon and loading state
FiftyButton(
  label: 'Processing',
  onPressed: () {},
  icon: Icons.sync,
  loading: true,
)
```

**Variants:** `primary`, `secondary`, `ghost`, `danger`
**Sizes:** `small` (32px), `medium` (40px), `large` (48px)

#### FiftyIconButton

Circular icon button with required tooltip.

```dart
FiftyIconButton(
  icon: Icons.settings,
  tooltip: 'Open settings',
  onPressed: () {},
  variant: FiftyIconButtonVariant.primary,
)
```

### Inputs

#### FiftyTextField

Text input with focus glow and validation support.

```dart
FiftyTextField(
  controller: _controller,
  label: 'Email',
  hint: 'Enter your email',
  prefix: Icon(Icons.email),
  errorText: _hasError ? 'Invalid email' : null,
)
```

### Containers

#### FiftyCard

Card container with optional tap interaction and selected state.

```dart
FiftyCard(
  onTap: () => selectItem(),
  selected: isSelected,
  child: CardContent(),
)
```

### Display

#### FiftyChip

Tag/label component with variants.

```dart
FiftyChip(
  label: 'DEPLOYED',
  variant: FiftyChipVariant.success,
  onDeleted: () => removeTag(),
)
```

#### FiftyBadge

Small status indicator with optional glow pulse.

```dart
FiftyBadge(
  label: 'LIVE',
  variant: FiftyBadgeVariant.success,
  showGlow: true,
)
```

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

#### FiftyAvatar

Circular avatar with image or fallback initials.

```dart
FiftyAvatar(
  imageUrl: 'https://example.com/avatar.jpg',
  fallbackText: 'JD',
  size: 48,
)
```

#### FiftyProgressBar

Linear progress indicator with crimson fill.

```dart
FiftyProgressBar(
  value: 0.65,
  label: 'UPLOADING',
  showPercentage: true,
)
```

#### FiftyLoadingIndicator

Pulsing circular loading indicator.

```dart
FiftyLoadingIndicator(
  size: 32,
  strokeWidth: 3,
)
```

#### FiftyDivider

Themed horizontal or vertical divider.

```dart
FiftyDivider()
FiftyDivider(vertical: true, height: 40)
```

### Feedback

#### FiftySnackbar

Toast notification with variants.

```dart
FiftySnackbar.show(
  context,
  message: 'Deployment successful!',
  variant: FiftySnackbarVariant.success,
);
```

#### FiftyDialog

Modal dialog with border glow.

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

#### FiftyTooltip

Hover-triggered tooltip wrapper.

```dart
FiftyTooltip(
  message: 'Click to deploy',
  child: FiftyButton(...),
)
```

### Utils

#### GlowContainer

Reusable container with animated glow effect.

```dart
GlowContainer(
  showGlow: _isFocused || _isHovered,
  borderRadius: FiftyRadii.standardRadius,
  child: MyContent(),
)
```

## FDL Design Principles

1. **No drop shadows** - Use border outlines and crimson glow only
2. **Dark-first** - Primary theme is dark (voidBlack background)
3. **Crimson focus** - All interactive elements glow crimson on focus
4. **Motion tokens** - Use `fifty.fast` (150ms) for hovers, `fifty.compiling` (300ms) for panels
5. **Binary typography** - Headlines use Monument Extended, data uses JetBrains Mono

## Theme Access Pattern

All components access theme via `FiftyThemeExtension`:

```dart
final theme = Theme.of(context);
final fifty = theme.extension<FiftyThemeExtension>()!;
final colorScheme = theme.colorScheme;

// Use fifty.focusGlow, fifty.fast, colorScheme.primary, etc.
```

## Example App

See the `example/` directory for a complete gallery app demonstrating all components.

```bash
cd example
flutter run
```

## License

MIT License - See LICENSE file for details.
