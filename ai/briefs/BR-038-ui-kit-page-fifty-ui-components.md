# BR-038: UI Kit Page - Use fifty_ui Components

**Type:** Bug Fix / Compliance
**Priority:** P1-High
**Effort:** M-Medium
**Status:** Ready

---

## Problem

The UI Kit showcase page (`ui_showcase`) uses raw Flutter widgets instead of fifty_ui components. This defeats the purpose of showcasing the design system.

**Specific Issues:**
1. `inputs_section.dart:35-62` - Uses raw `TextField` instead of `FiftyTextField`
2. `inputs_section.dart:95-129` - Uses manual toggle with `GestureDetector` instead of `FiftySwitch`
3. `inputs_section.dart:164-176` - Uses raw `Slider` instead of `FiftySlider`
4. `display_section.dart:114-121` - Wrong color labels (CRIMSON, VOID, TERMINAL, CHROME instead of actual FDL v2 names)
5. User reported: "UI kit page shows only buttons nothing else" - Section navigation may be broken

---

## Goal

Replace all raw Flutter widgets with their fifty_ui equivalents to properly showcase the design system.

---

## Context & Inputs

### Affected Files
- `apps/fifty_demo/lib/features/ui_showcase/views/ui_showcase_page.dart`
- `apps/fifty_demo/lib/features/ui_showcase/views/widgets/inputs_section.dart`
- `apps/fifty_demo/lib/features/ui_showcase/views/widgets/display_section.dart`
- `apps/fifty_demo/lib/features/ui_showcase/views/widgets/buttons_section.dart`
- `apps/fifty_demo/lib/features/ui_showcase/views/widgets/feedback_section.dart`

### Required Replacements

**1. Replace TextField with FiftyTextField**
```dart
// WRONG
TextField(
  style: TextStyle(...),
  decoration: InputDecoration(...),
);

// CORRECT
FiftyTextField(
  hint: 'Enter email',
  prefixIcon: Icons.email_outlined,
  controller: controller,
);
```

**2. Replace manual toggle with FiftySwitch**
```dart
// WRONG
GestureDetector(
  onTap: viewModel.toggleSwitch,
  child: Container(width: 48, height: 24, ...),
);

// CORRECT
FiftySwitch(
  value: viewModel.switchValue,
  onChanged: (v) => viewModel.toggleSwitch(),
);
```

**3. Replace Slider with FiftySlider**
```dart
// WRONG
SliderTheme(
  data: SliderThemeData(...),
  child: Slider(value: ..., onChanged: ...),
);

// CORRECT
FiftySlider(
  value: viewModel.sliderValue,
  onChanged: viewModel.setSliderValue,
);
```

**4. Fix color labels**
```dart
// WRONG
_ColorSwatch(color: FiftyColors.burgundy, label: 'CRIMSON'),

// CORRECT
_ColorSwatch(color: FiftyColors.burgundy, label: 'BURGUNDY'),
```

**5. Add missing sections**
- Ensure Segmented Control section uses `FiftySegmentedControl`
- Ensure Radio/Checkbox section uses `FiftyRadio` and `FiftyCheckbox`
- Verify section navigation is working (user can scroll/navigate between sections)

---

## Constraints

- Follow `ai/context/coding_guidelines.md` - FDL Compliance section
- **DO NOT** create raw widgets when fifty_ui components exist
- Use FDL v2 color names: burgundy, darkBurgundy, cream, slateGrey, hunterGreen, powderBlush

---

## Reference

- Design reference: `design_system/v2/fifty_ui_kit_components_1/screen.png` through `fifty_ui_kit_components_4/screen.png`
- Component library: `packages/fifty_ui/lib/fifty_ui.dart`

---

## Acceptance Criteria

- [ ] All inputs use FiftyTextField
- [ ] All switches use FiftySwitch
- [ ] All sliders use FiftySlider
- [ ] Segmented control uses FiftySegmentedControl
- [ ] Radio buttons use FiftyRadio
- [ ] Checkboxes use FiftyCheckbox
- [ ] Color swatches show correct FDL v2 names (burgundy, cream, etc.)
- [ ] All sections are visible and navigable
- [ ] No yellow text with underline (Material ancestor present)

---

## Test Plan

### Manual Testing
1. Navigate to UI Kit page
2. Verify all 4 sections are visible (Buttons, Inputs, Display, Feedback)
3. Test each input type (text field, switch, slider)
4. Verify color swatches show correct names
5. Check for any yellow underlined text (missing Material widget)

### Automated Testing
- No new tests required (UI showcase)

---

## Delivery

- [ ] Update inputs_section.dart
- [ ] Update display_section.dart
- [ ] Update buttons_section.dart (if needed)
- [ ] Update feedback_section.dart (if needed)
- [ ] Run `flutter analyze` - 0 issues
- [ ] Visual verification against design_system/v2 images
