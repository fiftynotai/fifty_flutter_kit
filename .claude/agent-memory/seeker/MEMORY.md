# SEEKER Memory

## fifty_tokens Package Configurability

**Status:** Complete audit saved to `fifty_tokens_configurability_audit.md`

**Key Finding:** **75-100% configurability for structural tokens, 0% for decorative tokens**

- FiftyColors: 18/24 properties configurable (75%) — missing border opacity, focusDark opacity
- FiftySpacing: 15/15 ✓ (100%)
- FiftyTypography: 26/26 ✓ (100%)
- FiftyRadii: 8/8 base values configurable ✓ (100%) — BorderRadius objects computed from base
- FiftyMotion: 7/7 ✓ (100%)
- FiftyBreakpoints: 3/3 ✓ (100%)
- **FiftyShadows: 0/5 (0%)** — ALL hardcoded, NO config API
- **FiftyGradients: 0/3 (0%)** — ALL hardcoded, NO config API

**Gap Analysis:**
1. FiftyShadows needs `FiftyShadowsConfig` with sm/md/lg/primaryOpacity/glowOpacity
2. FiftyGradients needs `FiftyGradientsConfig` with gradient endpoint customization
3. FiftyColors.borderLight/Dark opacity (5%) and focusDark opacity (50%) hardcoded

---

## fifty_theme Package Configurability Audit

### Executive Summary
The fifty_theme package is **HIGHLY HARDCODED to the burgundy/cream/dark palette**. While the architecture uses some parameterization, all parameters are pre-filled with Fifty tokens. A consumer wanting to swap to blue/white/light would need to:
1. Replace FiftyColors constants (50+ uses across 6 files)
2. Rebuild component themes explicitly (no generic overrides via copyWith)
3. Modify ThemeExtension hardcoded colors
4. Accept NO official "customize API" — would be a fork/wrapper

### Architecture Summary

**Entry Point:** `FiftyTheme.dark()` and `FiftyTheme.light()` (50/100+ static ThemeData factories)
- NO parameters accepted — fully hardcoded
- NO copyWith() support — ThemeData is sealed after creation
- Reuses FiftyColorScheme and FiftyComponentThemes

**Color System:**
- `FiftyColorScheme.dark()` → ColorScheme with burgundy primary, slateGrey secondary, hunterGreen tertiary
- `FiftyColorScheme.light()` → Same colors, inverted brightness
- All 30+ color slots hardcoded to FiftyColors constants (from fifty_tokens)

**Component Themes:**
- 23 factory functions in `FiftyComponentThemes` (buttons, cards, inputs, appbar, dialogs, etc.)
- Each receives `ColorScheme colorScheme` as parameter
- **Critically:** Most ALSO hardcode FiftyColors directly (burgundy focus states, slateGrey secondaries, etc.)
- Example: `textButtonTheme()` hardcodes `foregroundColor: FiftyColors.burgundy` regardless of ColorScheme

**Custom Extension:**
- `FiftyThemeExtension` provides shadows, motion, accent color
- Hardcoded in `.dark()` and `.light()` factory constructors
- Dark accent: `FiftyColors.powderBlush` (pink)
- Light accent: `FiftyColors.burgundy` (red)
- NO copyWith() override points for colors

**Text Theme:**
- Single unified `FiftyTextTheme.textTheme()` (uses Manrope)
- NO color data (colors come from ColorScheme/Component themes)
- Text colors pulled from ColorScheme + overrides in component styles

### File-by-File Configurability

#### 1. `/lib/fifty_theme.dart` (Entry point)
- `FiftyTheme.dark()` — Returns fully configured ThemeData
  - NO parameters
  - Calls `FiftyColorScheme.dark()` (hardcoded)
  - Passes colorScheme to 23+ component builders (hardcoded)
  - Sets extension: `FiftyThemeExtension.dark()` (hardcoded)
  - Sets fonts: `GoogleFonts.manrope()` (hardcoded)
  - Sets scaffold color: `FiftyColors.darkBurgundy` (hardcoded)
  - Sets canvas color: `FiftyColors.darkBurgundy` (hardcoded)
  - Sets card color: `FiftyColors.surfaceDark` (hardcoded)
- `FiftyTheme.light()` — Similar but with cream palette
  - Cream backgrounds
  - Dark Burgundy text color
  - Light mode AppBar override (hardcoded)
  - Many components use component theme builders from FiftyComponentThemes

**Can a consumer override?** NO
- These are static factory methods, not class properties
- No way to pass custom ColorScheme or override individual components
- ThemeData returned is immutable (sealed)

#### 2. `/lib/src/color_scheme.dart`
- `FiftyColorScheme.dark()` — Returns ColorScheme
  - All 22 slots hardcoded to FiftyColors
  - Primary: `FiftyColors.burgundy`
  - Secondary: `FiftyColors.slateGrey`
  - Tertiary: `FiftyColors.hunterGreen`
  - Surface: `FiftyColors.darkBurgundy`
  - Error: `FiftyColors.burgundy`
  - OnSurface: `FiftyColors.cream`
  - No factory parameters
- `FiftyColorScheme.light()` — Returns ColorScheme
  - Surface: `FiftyColors.cream` (instead of darkBurgundy)
  - OnSurface: `FiftyColors.darkBurgundy` (instead of cream)
  - Rest same as dark

**Can a consumer override?** THEORETICALLY
- If a consumer created their own ColorScheme and passed it to component theme builders, it MIGHT work for simple components (buttons)
- BUT: Would break at FiftyComponentThemes level because most theme builders IGNORE ColorScheme and hardcode colors
- Example: `elevatedButtonTheme()` receives colorScheme but uses `backgroundColor: FiftyColors.burgundy` hardcoded

#### 3. `/lib/src/component_themes.dart` (23 builders)
This is where configurability BREAKS. Each builder:
1. Receives `ColorScheme colorScheme` parameter
2. IGNORES or partially uses it
3. HARDCODES FiftyColors values

**Hardcoded patterns across all builders:**

| Component | Hardcoded Colors | Configured via ColorScheme |
|-----------|-----------------|---------------------------|
| **ElevatedButton** | bg: FiftyColors.burgundy, fg: FiftyColors.cream | NO (ignores colorScheme) |
| **OutlinedButton** | border: FiftyColors.burgundy hover, uses borderColor var | borderColor USES ColorScheme (isDark check) |
| **TextButton** | fg: FiftyColors.burgundy hardcoded | NO |
| **Card** | color: checks isDark, uses surfaceDark/surfaceLight; border: borderColor from isDark | borderColor USES ColorScheme |
| **Input** | fill: checks isDark for color; border: FiftyColors.burgundy focus (HARDCODED) | Border color based on ColorScheme, but focus HARDCODED |
| **AppBar** | bg/fg from isDark (uses colorScheme.brightness) | YES — uses ColorScheme brightness |
| **Dialog** | color: checks isDark; border: from borderColor var | borderColor USES ColorScheme |
| **SnackBar** | bg: FiftyColors.darkBurgundy (HARDCODED) | NO — always dark burgundy |
| **Divider** | color: from borderColor (uses isDark) | YES — border color parametric |
| **Checkbox** | fill: FiftyColors.burgundy (HARDCODED) | NO |
| **Radio** | fill: FiftyColors.burgundy (HARDCODED) | NO |
| **Switch** | on: FiftyColors.slateGrey (HARDCODED) | NO |
| **BottomNavBar** | selected: FiftyColors.burgundy (HARDCODED) | bg USES ColorScheme |
| **NavigationRail** | selected: FiftyColors.burgundy (HARDCODED) | bg USES ColorScheme |
| **TabBar** | indicator: FiftyColors.burgundy (HARDCODED) | NO |
| **FAB** | bg: FiftyColors.burgundy, fg: FiftyColors.cream (HARDCODED) | NO |
| **Chip** | selected: FiftyColors.burgundy (HARDCODED) | bg USES ColorScheme |
| **ProgressIndicator** | color: FiftyColors.burgundy (HARDCODED) | bg USES ColorScheme |
| **Slider** | active/thumb: FiftyColors.burgundy (HARDCODED) | NO |
| **Tooltip** | bg: FiftyColors.darkBurgundy (HARDCODED) | NO |
| **PopupMenu** | color: checks isDark, bg USES ColorScheme | YES for bg |
| **DropdownMenu** | Re-uses inputDecorationTheme | Same as input (burgundy focus hardcoded) |
| **BottomSheet** | bg: checks isDark, USES ColorScheme | YES |
| **Drawer** | bg: checks isDark, USES ColorScheme | YES |
| **ListTile** | text: from isDark (uses ColorScheme.brightness); selected: FiftyColors.burgundy (HARDCODED) | Text USES ColorScheme, but selected color hardcoded |
| **Icon** | color: checks isDark, USES ColorScheme brightness | YES (inverts cream/darkBurgundy based on mode) |
| **Scrollbar** | thumb: FiftyColors.slateGrey (HARDCODED) | NO |

**Summary:** Out of 23 components:
- **7 fully hardcoded** (ElevatedButton, TextButton, Checkbox, Radio, Switch, FAB, Slider, Tooltip, SnackBar, ScrollBar)
- **8 partially hardcoded** (accent colors like burgundy in focus states, but backgrounds adaptive)
- **8 mostly adaptive** (use ColorScheme brightness to determine dark/light)

**Can a consumer override?** DIFFICULT
- Would need to create custom component theme builders that re-implement the same logic
- OR replace FiftyComponentThemes entirely
- OR wrap the final ThemeData with copyWith() to override individual component themes (not all support this)

#### 4. `/lib/src/theme_extensions.dart`
- `FiftyThemeExtension.dark()` factory
  - accent: `FiftyColors.powderBlush` (pink, hardcoded)
  - success: `FiftyColors.hunterGreen` (green, hardcoded)
  - warning: `FiftyColors.warning` (orange, hardcoded)
  - info: `FiftyColors.slateGrey` (blue-grey, hardcoded)
  - shadow tokens: `FiftyShadows.*` (from fifty_tokens, hardcoded)
  - motion tokens: `FiftyMotion.*` (from fifty_tokens, hardcoded)
- `FiftyThemeExtension.light()` factory
  - accent: `FiftyColors.burgundy` (not pink like dark), hardcoded
  - shadowGlow: `FiftyShadows.none` (explicitly disabled in light mode, hardcoded)

**Extension provides a copyWith() method:**
```dart
FiftyThemeExtension copyWith({
  Color? accent,
  List<BoxShadow>? shadowSm,
  // ... 15 total parameters
})
```

**Can a consumer override?** YES, but...
- Only if they manually extract the extension and call copyWith()
- This requires:
  1. Get the theme: `Theme.of(context).extension<FiftyThemeExtension>()`
  2. Call copyWith() with new values
  3. Rebuild the entire ThemeData with `ThemeData(..., extensions: [newExtension])`
- **Not exposed as a public API** — requires manual work per widget
- Doesn't affect ColorScheme or component themes, only extension properties

#### 5. `/lib/src/text_theme.dart`
- Single `FiftyTextTheme.textTheme()` factory
- NO color data embedded (13 TextStyle definitions)
- Colors come from ColorScheme + component theme overrides
- Uses `GoogleFonts.manrope()` (hardcoded font, but can be overridden at MaterialApp level)
- NO parameters, NO customization hook

**Can a consumer override?** YES
- Only by replacing the entire text theme in ThemeData via `textTheme: CustomTextTheme.textTheme()`
- No individual style parameterization

### Hardcoded Colorways Across All Files

| Color | Count | Files | Typical Use |
|-------|-------|-------|------------|
| `FiftyColors.burgundy` | 25+ | component_themes (focus, accent), color_scheme (primary), fifty_theme_data (all modes) | Primary buttons, CTAs, focus states |
| `FiftyColors.cream` | 15+ | component_themes, color_scheme, fifty_theme_data | Dark mode text, light mode backgrounds |
| `FiftyColors.darkBurgundy` | 10+ | color_scheme, component_themes, fifty_theme_data | Dark mode backgrounds, appbar |
| `FiftyColors.slateGrey` | 12+ | color_scheme, component_themes (secondary), theme_extensions (info) | Secondary actions, switches, info |
| `FiftyColors.hunterGreen` | 8+ | color_scheme (tertiary), theme_extensions (success) | Success states, tertiary actions |
| `FiftyColors.powderBlush` | 3 | theme_extensions (dark accent) | Dark mode accent highlight |
| `FiftyColors.surfaceDark` | 5+ | component_themes, color_scheme, fifty_theme_data | Dark mode card/surface |
| `FiftyColors.surfaceLight` | 5+ | component_themes, fifty_theme_data, color_scheme | Light mode card/surface |
| `FiftyColors.warning` | 2 | theme_extensions, colors | Warning states |

### To Swap to Blue/White/Light Palette

**What a consumer would need to do:**

1. **Approach A: Fork fifty_theme** (recommended)
   - Copy the entire package
   - Replace all FiftyColors references with custom constants
   - Update FiftyColorScheme to use new primary (blue instead of burgundy)
   - Update all 23 component themes to use new palette
   - Maintain the same API surface

2. **Approach B: Wrapper (hacky)**
   - Get FiftyTheme.dark()
   - Use ThemeData.copyWith() to override individual component themes
   - Problem: Not all components support copyWith() override
   - Would need manual, fragile per-component overrides

3. **Approach C: Replace at MaterialApp level** (most pragmatic)
   ```dart
   MaterialApp(
     theme: ThemeData(
       useMaterial3: true,
       colorScheme: ColorScheme.light(
         primary: Colors.blue, // Custom
         secondary: Colors.grey, // Custom
         // ... 20+ more slots
       ),
       textTheme: YourTextTheme.textTheme(),
       elevatedButtonTheme: ElevatedButtonThemeData(...),
       // ... 23+ component themes
     ),
   )
   ```
   - Full replacement, NO reuse of fifty_theme

### Configurability Rating

| Aspect | Rating | Notes |
|--------|--------|-------|
| ColorScheme | 🔴 Hardcoded | No factory parameters, all colors preset |
| Component Themes | 🟠 Hardcoded (partial) | Most have burgundy hardcoded despite ColorScheme param |
| ThemeExtension | 🟡 Partially Configurable | copyWith() available but requires manual extraction |
| Text Theme | 🟡 Replaceable | Single factory, no per-style customization |
| Top-level API | 🔴 No Customization | FiftyTheme.dark() / light() accept zero parameters |
| copyWith() Support | 🟠 Breaks at ColorScheme level | ThemeData is sealed; can't compose custom ColorScheme + Fifty components |
| Fallback Override Path | 🟡 Via component themes | Can build custom component themes, but ~23 builders to replace |

### Conclusion

**The fifty_theme package is designed as a complete, opinionated design system with NO customization hooks.** While individual pieces (ColorScheme, component themes) are parameterized internally, all parameters are hardcoded to FiftyColors tokens.

**If a consumer wants burgundy/cream/dark palette:** Just use `FiftyTheme.dark()` or `FiftyTheme.light()`.

**If a consumer wants blue/white/light palette:** Either fork the package, build custom component themes from scratch, or use a completely different theme (e.g., Material3 defaults). There is no "configure" API.

---

## FiftyPreset Structure & Factories

**File Location:** `/packages/fifty_tokens/lib/src/preset.dart`

### Class Structure

```dart
class FiftyPreset {
  const FiftyPreset({
    required this.colors,
    required this.typography,
    required this.spacing,
    required this.radii,
    required this.motion,
    required this.shadows,
    required this.gradients,
    required this.breakpoints,
  });
}
```

**8 required fields** — each is a Config class:
- `FiftyColorConfig` — 16 Color + 2 double (borderOpacity, focusOpacity)
- `FiftyTypographyConfig` — 22 fields (fontFamily, fontSource, 5 weights, 13 sizes, 7 spacing values, 4 line heights)
- `FiftySpacingConfig` — 15 double values (base, xs/sm/md/lg/xl/xxl/xxxl/huge/massive, gutterMobile/Tablet/Desktop)
- `FiftyRadiiConfig` — 8 double values (none/sm/md/lg/xl/xxl/xxxl/full) → computed into BorderRadius convenience objects
- `FiftyMotionConfig` — 7 fields (instant, fast, compiling, systemLoad as Duration; standard, enter, exit as Cubic)
- `FiftyShadowsConfig` — 5 fields (sm, md, lg as List<BoxShadow>; primaryOpacity, glowOpacity as double)
- `FiftyGradientsConfig` — 1 field (primaryEnd as Color)
- `FiftyBreakpointsConfig` — 3 double values (mobile, tablet, desktop)

### Factory Methods

1. **`FiftyPreset.fdlV2` (const static)**
   - Built-in default preset
   - All 8 categories pre-populated with FDL v2 "Sophisticated Warm" values
   - Used as fallback in `fromMap()`

2. **`FiftyPreset.fromMap(Map<String, dynamic>, {fallback})`**
   - Parses a JSON map into a preset
   - Each category's `fromMap()` method handles JSON parsing
   - Missing keys fall back to provided fallback (default: `fdlV2`)
   - Used for runtime theming from JSON

### Instance Methods

**`copyWith({...})`** — Returns new FiftyPreset with specified fields replaced
- 8 optional parameters (one per config category)
- Non-null values replace, null values keep original

### FiftyColorConfig.fromMap() Parsing

**Supported color formats:**
- `int` → direct ARGB value
- `String` → hex in `#RRGGBB`, `0xAARRGGBB`, `AARRGGBB`, or `RRGGBB` format
- 6-digit strings auto-prefixed with `FF` (opaque)
- Parser: `/packages/fifty_tokens/lib/src/config/parse_helpers.dart`

**Example JSON:**
```json
{
  "colors": {
    "primary": "0xFF88292F",
    "primaryHover": "0xFF6E2126",
    "borderOpacity": 0.05,
    "focusOpacity": 0.5,
    ...
  }
}
```

### Export Path

**Barrel file:** `/packages/fifty_tokens/lib/fifty_tokens.dart`
```dart
export 'src/preset.dart';  // FiftyPreset
```

**Public API for consumers:**
```dart
import 'package:fifty_tokens/fifty_tokens.dart';

// Use built-in default
FiftyTokens.load(FiftyPreset.fdlV2);

// Parse from JSON
final preset = FiftyPreset.fromMap(jsonDecode(myJson));
FiftyTokens.load(preset);

// Override specific categories
FiftyTokens.load(
  FiftyPreset.fdlV2.copyWith(
    colors: FiftyPreset.fdlV2.colors.copyWith(
      primary: Color(0xFFFF0000),
    ),
  ),
);
```

### Key Design Notes

1. **All-or-nothing per category** — Can't override individual spacing values without creating full FiftySpacingConfig
   - Exception: `copyWith()` on each config allows partial overrides
   - Pattern: `FiftyPreset.fdlV2.spacing.copyWith(md: 20)`

2. **JSON is the extensibility point** — Consumers define custom presets as JSON files, parse with `fromMap()`
   - Bundled JSON files: `/packages/fifty_tokens/fdl_v2_preset.json`
   - Custom presets: Consumer apps create `assets/brand_theme.json`, load at runtime

3. **Runtime-safe** — No const contexts needed; `FiftyPreset` is mutable data structure, safe to instantiate anywhere

4. **No preset registry** — Presets are just values, not named global singletons
   - Consumers manage their own preset loading lifecycle
   - `FiftyTokens.load()` / `FiftyTokens.configure()` manage active state

---

## Key Files Analyzed

- `/packages/fifty_theme/lib/fifty_theme.dart` (50 lines, entry point)
- `/packages/fifty_theme/lib/src/fifty_theme_data.dart` (410 lines, dark/light factories)
- `/packages/fifty_theme/lib/src/color_scheme.dart` (113 lines, ColorScheme builders)
- `/packages/fifty_theme/lib/src/component_themes.dart` (664 lines, 23 component builders)
- `/packages/fifty_theme/lib/src/theme_extensions.dart` (217 lines, extension definition)
- `/packages/fifty_theme/lib/src/text_theme.dart` (127 lines, text theme)
- `/packages/fifty_tokens/lib/src/colors.dart` (149 lines, FiftyColors constants)

**Total hardcoded color references: 100+ across all files**

---

## fifty_speech_engine Widget Analysis

**Status:** Complete widget audit for builder pattern implementation

### Widget #1: SpeechTtsControls

**File:** `/packages/fifty_speech_engine/lib/src/widgets/speech_tts_controls.dart`

**Type:** `StatelessWidget`

**Constructor Parameters (10 total):**
- `enabled: bool` (required)
- `onEnabledChanged: ValueChanged<bool>` (required)
- `rate: double = 1.0`
- `onRateChanged: ValueChanged<double>?`
- `pitch: double = 1.0`
- `onPitchChanged: ValueChanged<double>?`
- `volume: double = 1.0`
- `onVolumeChanged: ValueChanged<double>?`
- `isSpeaking: bool = false`
- `compact: bool = false`
- `showCard: bool = true` (wraps output in FiftyCard when true)

**Default UI (build method, lines 104-181):**
1. `_TtsHeader` — header row with:
   - Icon (voice_over_off or record_voice_over based on isSpeaking)
   - "TEXT-TO-SPEECH" label
   - Pulsing dot indicator (when isSpeaking)
   - FiftySwitch toggle (enabled/onEnabledChanged)
2. Rate slider (if onRateChanged != null) — shows value as "1.0x"
3. Pitch slider (if onPitchChanged != null) — shows value as "1.0x"
4. Volume slider (if onVolumeChanged != null) — shows value as "100%"
5. Wraps all in FiftyCard if showCard=true

**Builder Pattern Access Points:**
- `enabled` — whether TTS is turned on
- `isSpeaking` — animated icon/dot state
- `rate`, `pitch`, `volume` — slider current values (for range display, value formatting)
- `compact` — spacing adjustments
- `onEnabledChanged` — toggle callback
- Conditional slider display via `onRateChanged`/`onPitchChanged`/`onVolumeChanged` nullability

**Helper Components:**
- `_TtsHeader` (lines 185-246) — internal, stateless
- `_SliderRow` (lines 249-306) — internal, stateless, parameterized slider with icon/label

---

### Widget #2: SpeechSttControls

**File:** `/packages/fifty_speech_engine/lib/src/widgets/speech_stt_controls.dart`

**Type:** `StatelessWidget` (contains internal StatefulWidget `_PulsingDot`)

**Constructor Parameters (10 total):**
- `enabled: bool` (required)
- `onEnabledChanged: ValueChanged<bool>` (required)
- `isListening: bool` (required)
- `onListenPressed: VoidCallback` (required)
- `recognizedText: String = ''`
- `isAvailable: bool = true`
- `errorMessage: String?`
- `onClear: VoidCallback?`
- `compact: bool = false`
- `showCard: bool = true`
- `hintText: String?` (defaults to 'TAP TO SPEAK')

**Default UI (build method, lines 100-164):**
1. `_SttHeader` — header row with:
   - Icon (mic or mic_none based on isListening)
   - "SPEECH-TO-TEXT" label
   - Pulsing dot (only when isListening)
   - FiftySwitch toggle (enabled/onEnabledChanged, disabled if !isAvailable)
2. If enabled:
   - `_MicrophoneSection` — large circular mic button with animated state:
     - Icon (mic or mic_none)
     - Status text: "LISTENING..." or hintText
     - GestureDetector with onTap: onListenPressed
     - Button color/border changes when isListening
   - `_ErrorDisplay` (if errorMessage is non-null/non-empty) — error container with icon
   - `_RecognizedTextDisplay` (if recognizedText.isNotEmpty) — text box with clear button
3. If !isAvailable:
   - `_NotAvailableMessage` — info container

**Builder Pattern Access Points:**
- `enabled` — whether STT is active
- `isListening` — animated icon state, button color, "LISTENING..." text
- `isAvailable` — toggle enabled state, message conditional
- `recognizedText` — conditional display, value in text box
- `errorMessage` — conditional error display
- `compact` — spacing/sizing adjustments
- `hintText` — custom hint text for mic button
- `onEnabledChanged`, `onListenPressed`, `onClear` — callbacks

**Helper Components:**
- `_SttHeader` (lines 168-225) — internal stateless
- `_PulsingDot` (lines 228-279) — **internal STATEFUL**, 1000ms pulsing animation with AlphaAnimation
- `_MicrophoneSection` (lines 282-358) — internal stateless, circular animated button
- `_RecognizedTextDisplay` (lines 361-425) — internal stateless, text box with clear icon
- `_ErrorDisplay` (lines 428-471) — internal stateless, error message container
- `_NotAvailableMessage` (lines 474-513) — internal stateless, unavailable info

---

### Widget #3: SpeechControlsPanel

**File:** `/packages/fifty_speech_engine/lib/src/widgets/speech_controls_panel.dart`

**Type:** `StatelessWidget`

**Constructor Parameters (16 total):**

**TTS Properties:**
- `ttsEnabled: bool` (required)
- `onTtsEnabledChanged: ValueChanged<bool>` (required)
- `rate: double = 1.0`
- `onRateChanged: ValueChanged<double>?`
- `pitch: double = 1.0`
- `onPitchChanged: ValueChanged<double>?`
- `volume: double = 1.0`
- `onVolumeChanged: ValueChanged<double>?`
- `isSpeaking: bool = false`

**STT Properties:**
- `sttEnabled: bool` (required)
- `onSttEnabledChanged: ValueChanged<bool>` (required)
- `isListening: bool` (required)
- `onListenPressed: VoidCallback` (required)
- `recognizedText: String = ''`
- `isSttAvailable: bool = true`
- `sttErrorMessage: String?`
- `onClearRecognizedText: VoidCallback?`
- `sttHintText: String?`

**Panel Options:**
- `showTts: bool = true`
- `showStt: bool = true`
- `compact: bool = false`
- `title: String?`

**Default UI (build method, lines 154-225):**
1. Wraps all in FiftyCard
2. If title:
   - Title text (uppercase)
   - Horizontal divider line
3. If showTts:
   - SpeechTtsControls (embedded, showCard=false)
4. If showTts && showStt:
   - Horizontal divider
5. If showStt:
   - SpeechSttControls (embedded, showCard=false)

**Builder Pattern Access Points:**
- All TTS state (enabled, rate, pitch, volume, isSpeaking)
- All STT state (enabled, listening, recognized, available, error)
- `showTts`/`showStt` — conditional rendering
- `compact` — passed through to child controls
- `title` — optional header

**Helper Components:**
- None (delegates to SpeechTtsControls + SpeechSttControls)

---

### State & Callback Requirements for Builders

**TTS Builder Context:**
```dart
context.ttsEnabled          // bool
context.isSpeaking          // bool (animated icon)
context.rate                // double (current slider value)
context.pitch               // double
context.volume              // double
context.onEnabledChanged    // ValueChanged<bool>
context.onRateChanged       // ValueChanged<double>?
context.onPitchChanged      // ValueChanged<double>?
context.onVolumeChanged     // ValueChanged<double>?
context.compact             // bool (spacing)
```

**STT Builder Context:**
```dart
context.sttEnabled          // bool
context.isListening         // bool (animated state)
context.recognizedText      // String
context.errorMessage        // String?
context.isAvailable         // bool (disable/availability)
context.onEnabledChanged    // ValueChanged<bool>
context.onListenPressed     // VoidCallback
context.onClear             // VoidCallback?
context.hintText            // String?
context.compact             // bool (spacing)
```

**Panel Builder Context:**
- All TTS + STT fields above PLUS:
```dart
context.showTts             // bool (conditional)
context.showStt             // bool (conditional)
context.title               // String? (optional header)
```

---

### Barrel Export

**File:** `/packages/fifty_speech_engine/lib/src/widgets/widgets.dart`

```dart
export 'speech_tts_controls.dart';
export 'speech_stt_controls.dart';
export 'speech_controls_panel.dart';
```

**Main export:** `/packages/fifty_speech_engine/lib/fifty_speech_engine.dart` (line 6)

---

### Example App Integration

**Example Structure:** `/packages/fifty_speech_engine/example/lib/features/speech_demo/`

**Custom Panels (NOT using builder patterns yet):**
- `tts_panel.dart` — Custom TtsPanel widget wrapping SpeechTtsControls + text input + language selector
  - Pulls state from SpeechDemoViewModel
  - Shows: text input field, speak/stop buttons, language dropdown
  - Does NOT use SpeechTtsControls widget directly for UI (custom implementation)
- `stt_panel.dart` — Custom SttPanel widget wrapping SpeechSttControls
  - Similar: pulls state, renders custom UI alongside/with SpeechSttControls

**Why custom panels exist:**
- Example needs EXTRA controls (language selector, text input, custom buttons)
- Current SpeechTtsControls/SpeechSttControls only expose preset controls
- **This is the pain point builders solve** — allow custom "wrapper" UI around the controls

---

### Key Insights for Builder Implementation

1. **Builder opportunity:** Both SpeechTtsControls and SpeechSttControls render hardcoded headers + controls. Builder would replace header/layout without replacing callbacks/logic.

2. **Internal stateful widget:** SpeechSttControls contains `_PulsingDot` (StatefulWidget with AnimationController). Builder must NOT replace this, only allow replacing container layout.

3. **Conditional rendering patterns:** Both use `if (enabled)` and `if (onCallback != null)` to conditionally show sections. Builder must respect these.

4. **Card wrapping:** Both have `showCard` param to optionally wrap in FiftyCard. Builder implementation should expose card wrapping to builder function.

5. **Example app pain point:** TtsPanel in example manually reconstructs similar headers/status layout. Builder pattern would eliminate this duplication.

---

### Implementation Strategy Hints

**For each widget:**

1. **SpeechTtsControls**
   - Extract `build()` layout into a `builder` param (default returns current UI)
   - Builder receives: `enabled`, `isSpeaking`, `rate`, `pitch`, `volume`, `onEnabledChanged`, callbacks, `compact`, `showCard`
   - Builder returns: Widget (the content, NOT wrapped in FiftyCard if showCard=false)

2. **SpeechSttControls**
   - Extract `build()` layout into a `builder` param (default returns current UI)
   - Builder receives: all state fields + callbacks
   - Builder must NOT include `_PulsingDot` logic (too complex) — instead expose `isListening` boolean to builder
   - Builder handles header, mic button, text display; animation stays internal

3. **SpeechControlsPanel**
   - Add `ttsBuilder` and `sttBuilder` params (optional)
   - Panel builds TtsBuilder(context) or SpeechTtsControls (default)
   - Panel builds SttBuilder(context) or SpeechSttControls (default)
   - Title/divider logic stays in panel
