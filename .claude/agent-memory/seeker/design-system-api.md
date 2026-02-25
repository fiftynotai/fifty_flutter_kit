# Design System API Verification

## fifty_tokens Package

### FiftyColors
- **Correct:** `FiftyColors.primary` ✓ (line 81 in colors.dart)
  - Alias for `FiftyColors.burgundy`
  - Value: `Color(0xFF88292F)` (Burgundy)
- **Correct:** `FiftyColors.secondary` ✓ (line 87 in colors.dart)
  - Alias for `FiftyColors.slateGrey`
  - Value: `Color(0xFF335C67)` (Slate Grey)
- **Note:** No `FiftyColors.primary` parameter accessor - it's a static const Color value

### FiftySpacing
- **Incorrect in examples:** `FiftySpacing.md` DOES NOT EXIST
  - **Actual accessors:** `FiftySpacing.xs`, `FiftySpacing.sm`, `FiftySpacing.md`, `FiftySpacing.lg`, `FiftySpacing.xl`, etc.
  - Examples show `FiftySpacing.tight` (8px) and `FiftySpacing.standard` (12px) are primary gaps
  - All values: xs(4), sm(8), md(12), lg(16), xl(20), xxl(24), xxxl(32), huge(40), massive(48)
  - Also: `gutterDesktop`(24), `gutterTablet`(16), `gutterMobile`(12)

### FiftyTypography
- **Incorrect in examples:** `FiftyTypography.heading1` DOES NOT EXIST
  - **Actual accessors:** `FiftyTypography.displayLarge`, `FiftyTypography.titleLarge`, `FiftyTypography.bodyLarge`, etc.
  - Type scale values (sizes in px):
    - `displayLarge` (32px), `displayMedium` (24px)
    - `titleLarge` (20px), `titleMedium` (18px), `titleSmall` (16px)
    - `bodyLarge` (16px), `bodyMedium` (14px), `bodySmall` (12px)
    - `labelLarge` (14px), `labelMedium` (12px), `labelSmall` (10px)
  - Font weights: `regular`, `medium`, `semiBold`, `bold`, `extraBold`
  - Letter spacing accessors for display, body, and label variants

### FiftyMotion
- **Incorrect in examples:** `FiftyMotion.normal` DOES NOT EXIST
- **Incorrect in examples:** `FiftyMotion.easeOut` DOES NOT EXIST
- **Actual duration accessors:**
  - `FiftyMotion.instant` (Duration.zero)
  - `FiftyMotion.fast` (150ms)
  - `FiftyMotion.compiling` (300ms)
  - `FiftyMotion.systemLoad` (800ms)
- **Actual easing curve accessors:**
  - `FiftyMotion.standard` - Cubic(0.2, 0, 0, 1)
  - `FiftyMotion.enter` - Cubic(0.2, 0.8, 0.2, 1)
  - `FiftyMotion.exit` - Cubic(0.4, 0, 1, 1)

## fifty_theme Package

### FiftyTheme
- **Correct:** `FiftyTheme.light()` ✓ (line 112 in fifty_theme_data.dart)
  - Returns: `ThemeData`
  - Signature: `static ThemeData light()`
  - No parameters
- **Correct:** `FiftyTheme.dark()` ✓ (line 43 in fifty_theme_data.dart)
  - Returns: `ThemeData`
  - Signature: `static ThemeData dark()`
  - No parameters
- **Note:** Both methods return complete Flutter ThemeData objects (not a theme provider class)

## fifty_ui Package

### FiftyButton
- **Correct:** `FiftyButton` constructor exists ✓ (line 68 in fifty_button.dart)
- **Incorrect parameter name:** `label` NOT `text` ✓
  - Correct: `label: 'GET STARTED'`
  - Field: `required String label` (line 85)
- **Correct:** `onPressed` exists ✓
  - Type: `VoidCallback?` (optional)
- **Additional constructor parameters:**
  - `icon: IconData?` - optional leading icon
  - `trailingIcon: IconData?` - optional trailing icon
  - `variant: FiftyButtonVariant` - button style (primary, secondary, outline, ghost, danger)
  - `size: FiftyButtonSize` - button size (small, medium, large)
  - `loading: bool` - shows loading state
  - `disabled: bool` - disables the button
  - `expanded: bool` - fills available width
  - `isGlitch: bool` - glitch effect on hover

### FiftyButtonVariant (enum)
- `primary` - Solid burgundy background (default)
- `secondary` - Solid slate-grey background
- `outline` - Burgundy border, transparent background
- `ghost` - Text-only
- `danger` - Error/destructive styling

### FiftyButtonSize (enum)
- `small` (36px height)
- `medium` (48px height, default)
- `large` (56px height)

## Critical README Issues Found

1. **fifty_tokens**: Examples use deprecated/non-existent accessors
   - `FiftySpacing.md` should be `FiftySpacing.md` (exists, but examples may show wrong pattern)
   - `FiftyTypography.heading1` doesn't exist - use `FiftyTypography.titleLarge` or `FiftyTypography.displayMedium`
   - `FiftyMotion.normal` doesn't exist - use `FiftyMotion.standard`
   - `FiftyMotion.easeOut` doesn't exist - use `FiftyMotion.exit`

2. **fifty_theme**: Examples appear correct
   - `FiftyTheme.dark()` and `FiftyTheme.light()` both exist and work as documented

3. **fifty_ui**: Examples partially correct
   - `FiftyButton(label: ..., onPressed: ...)` works correctly
   - Missing documented parameters in typical README example (should show variant, size options)
