This is the **Construction Blueprint** for `fifty_ui`.

While `fifty_theme` provided the definitions (colors, text styles), `fifty_ui` provides the **Tangible Components**. This package contains the actual Widgets that you will use to build your apps.

Every widget here follows the **Kinetic Brutalism** doctrine: **Heavy structure, fast motion, raw feedback.**

---

# 📦 Package: `fifty_ui`

**Role:** The Component Library (The Hardware).
**Dependencies:** `flutter`, `flutter_animate`, `fifty_theme` (or `fifty_tokens`).

---

## 📂 1. Directory Structure

We organize by "Atomic Design" principles but renamed to fit the **System Architect** persona.

```text
lib/
├── src/
│   ├── atoms/                // Primitives
│   │   ├── fifty_button.dart // The Kinetic Switch
│   │   ├── fifty_input.dart  // The Terminal Line
│   │   ├── fifty_badge.dart  // Status Pills
│   │   ├── fifty_divider.dart// Glitch Lines
│   │   └── fifty_loader.dart // Text Sequence Loader
│   ├── molecules/            // Compounds
│   │   ├── fifty_card.dart   // Bento Containers (Data Slates)
│   │   ├── fifty_toast.dart  // System Alerts
│   │   └── fifty_code_block.dart // Syntax Highlighter
│   ├── organisms/            // Complex Structures
│   │   ├── fifty_nav_bar.dart // Dynamic Command Island
│   │   └── fifty_hero.dart   // Monument Text Headers
│   └── utils/
│       ├── kinetic_effect.dart // Hover/Scale logic wrapper
│       └── glitch_effect.dart  // Chromatic Aberration shader
├── fifty_ui.dart             // Main Export
└── pubspec.yaml

```

---

## 🛠 2. Widget Specifications (The Catalog)

### A. `FiftyButton` (The Kinetic Switch)

* **Concept:** A physical mechanical switch. Zero latency feeling.
* **Design:**
* **Shape:** Sharp corners (Radius 4px) or Pill (Radius 100px).
* **States:**
* *Idle:* `Gunmetal` BG, White Text.
* *Hover:* Background snaps to `Crimson`. Text Glitches.
* *Press:* Scale down to `0.95`.




* **Properties:**
* `label` (String)
* `icon` (IconData, optional)
* `isGlitch` (bool) -> Adds RGB split on hover.



### B. `FiftyInput` (The Terminal Line)

* **Concept:** A command line prompt.
* **Design:**
* **No Box:** Background is transparent.
* **Border:** Bottom-only border.
* *Idle:* Thin `HyperChrome`.
* *Focus:* Thick `Crimson`.


* **Prefix:** Always includes a prompt char `> ` or `// ` in `HyperChrome`.
* **Cursor:** Solid block `█` or Underscore `_` that blinks.



### C. `FiftyCard` (The Bento Slate)

* **Concept:** A modular data container.
* **Design:**
* **Base:** `Gunmetal` fill.
* **Border:** `1px` Solid `HyperChrome` (Opacity 10%).
* **Texture:** Optional `HalftoneOverlay` (dots) in the background.
* **Hover:** If `isInteractive` is true, slight scale up (`1.02`) and border turns `Crimson`.


* **Properties:**
* `child` (Widget)
* `hasTexture` (bool)
* `padding` (EdgeInsets)



### D. `FiftyLoader` (The Compiler)

* **Concept:** Rejects spinning circles. Simulates data processing.
* **Design:**
* Displays a sequence of monospace strings that cycle rapidly.
* `> INITIALIZING...` -> `> MOUNTING...` -> `> SYNCING...`


* **Properties:**
* `textStyle` (TextStyle)
* `color` (Color) -> Default `Crimson`.



### E. `FiftyNavBar` (The Command Deck)

* **Concept:** Floating "Dynamic Island" or HUD.
* **Design:**
* **Container:** Glassmorphism (Blur 20px) + Black Opacity 50%.
* **Shape:** Pill.
* **Items:** Text-only or Icon-only.
* **Selection:** Active item gets a `Crimson` underbar `_`.



### F. `FiftyBadge` (The System Tag)

* **Concept:** Status indicators for IGRIS or project labels.
* **Design:**
* **Style:** Outlined Pill.
* **Border:** `HyperChrome` or `IgrisGreen` (for AI).
* **Text:** Tiny Monospace CAPS.


* **Variants:**
* `FiftyBadge.tech("FLUTTER")` (Gray)
* `FiftyBadge.status("ONLINE")` (Green + Glow)



---

## 💻 3. Implementation Examples

Here is how you write the code for the key components using `flutter_animate` for that "Kinetic" feel.

### `fifty_button.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fifty_theme/fifty_theme.dart'; // Assuming specific exports

class FiftyButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isGlitch;

  const FiftyButton({
    super.key, 
    required this.label, 
    required this.onTap,
    this.isGlitch = false,
  });

  @override
  State<FiftyButton> createState() => _FiftyButtonState();
}

class _FiftyButtonState extends State<FiftyButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: 150.ms, // Fast snap
          curve: Curves.easeOutExpo,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: _isHovered ? FiftyColors.crimsonPulse : FiftyColors.gunmetal,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: _isHovered ? FiftyColors.crimsonPulse : FiftyColors.hyperChrome.withOpacity(0.3),
            ),
          ),
          child: Text(
            widget.label.toUpperCase(),
            style: FiftyType.codeText.copyWith( // Using the Mono font
              color: FiftyColors.terminalWhite,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        )
        .animate(target: _isHovered ? 1 : 0)
        .scale(begin: const Offset(1, 1), end: const Offset(1.02, 1.02)), // Slight breathe
      ),
    );
  }
}

```

### `fifty_card.dart`

```dart
import 'package:flutter/material.dart';
import 'package:fifty_theme/fifty_theme.dart';

class FiftyCard extends StatelessWidget {
  final Widget child;
  final bool hasTexture;
  final EdgeInsetsGeometry padding;

  const FiftyCard({
    super.key, 
    required this.child, 
    this.hasTexture = true, 
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: FiftyColors.gunmetal,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: FiftyColors.hyperChrome.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            if (hasTexture)
              Positioned.fill(
                child: Opacity(
                  opacity: 0.05,
                  child: Image.asset(
                    'assets/textures/halftone_pattern.png', 
                    package: 'fifty_ui',
                    repeat: ImageRepeat.repeat,
                  ),
                ),
              ),
            Padding(
              padding: padding,
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}

```

### `fifty_loader.dart`

```dart
import 'package:flutter/material.dart';
import 'package:fifty_theme/fifty_theme.dart';
import 'dart:async';

class FiftyLoader extends StatefulWidget {
  const FiftyLoader({super.key});

  @override
  State<FiftyLoader> createState() => _FiftyLoaderState();
}

class _FiftyLoaderState extends State<FiftyLoader> {
  final List<String> _steps = [
    '> INITIALIZING...',
    '> LOADING ASSETS...',
    '> ESTABLISHING LINK...',
    '> COMPILING...',
  ];
  int _index = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      setState(() {
        _index = (_index + 1) % _steps.length;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _steps[_index],
      style: FiftyType.codeText.copyWith(
        color: FiftyColors.crimsonPulse,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

```

---

## 4. `pubspec.yaml` Plan

```yaml
name: fifty_ui
description: FDL-styled Flutter components for the fifty.dev ecosystem.
version: 1.0.0

environment:
  sdk: ">=3.0.0 <4.0.0"

dependencies:
  flutter:
    sdk: flutter
  # The Visual Definition
  fifty_theme:
    path: ../fifty_theme 
  # For Kinetic Motion
  flutter_animate: ^4.2.0 
  # For Glassmorphism/Filters (Optional but good)
  glass_kit: ^3.0.0

flutter:
  assets:
    - assets/textures/halftone_pattern.png

```
