# TS-001: fifty_tokens Complete Test Suite

**Type:** Testing
**Priority:** P0-Critical
**Effort:** M-Medium (1-2d)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2025-11-10
**Completed:** 2025-11-10
**Dependencies:** BR-002 (Colors) ✅, BR-003 (Typography) ✅, BR-004 (Spacing/Radii) ✅, BR-005 (Motion) ✅, BR-006 (Elevation/Breakpoints) ✅

---

## What Needs Testing?

**Component/Module:** entire fifty_tokens package - all token modules

**Current Test Coverage:** 0% (new package)

**Target Test Coverage:** 100% (all constants validated)

**Why is testing needed?**

- Token accuracy is CRITICAL - values must match FDL exactly
- Crimson colors must be precise (#960E29, #B31337)
- Type scale must follow minor third ratio
- Spacing must follow 8px grid
- Motion curves must have correct control points
- These tokens are the foundation - errors propagate to all packages

---

## Testing Gaps

### Current Coverage
- [ ] **Unit Tests:** 0% - No tests exist yet
- [ ] **Widget Tests:** N/A - Pure Dart package, no widgets
- [ ] **Integration Tests:** N/A - No integration needed

### Missing Coverage
- [ ] **Color Tests:** Verify all hex values, alpha channels
- [ ] **Typography Tests:** Verify font families, sizes, weights
- [ ] **Spacing Tests:** Verify scale values, gutters
- [ ] **Radii Tests:** Verify radius values, BorderRadius objects
- [ ] **Motion Tests:** Verify durations, curve control points
- [ ] **Shadow Tests:** Verify shadow colors, blur, offsets
- [ ] **Breakpoint Tests:** Verify breakpoint values

---

## Test Scenarios

### Unit Tests - Colors (FiftyColors)

#### Scenario 1: Crimson Core Accuracy
**What to test:** `FiftyColors.crimsonCore`
**Given:** Color constant defined
**When:** Read color value and convert to hex
**Then:** Hex = `#960E29` exactly

```dart
test('crimsonCore matches FDL specification #960E29', () {
  expect(FiftyColors.crimsonCore.value, equals(0xFF960E29));
});
```

#### Scenario 2: Tech Crimson Accuracy
**What to test:** `FiftyColors.techCrimson`
**Given:** Color constant defined
**When:** Read color value and convert to hex
**Then:** Hex = `#B31337` exactly

```dart
test('techCrimson matches FDL specification #B31337', () {
  expect(FiftyColors.techCrimson.value, equals(0xFFB31337));
});
```

#### Scenario 3: Surface 3 Alpha Channel
**What to test:** `FiftyColors.surface3`
**Given:** Translucent color defined
**When:** Read alpha value
**Then:** Alpha ≈ 0x08 (3% opacity)

```dart
test('surface3 has correct alpha channel (3% opacity)', () {
  expect(FiftyColors.surface3.alpha, equals(0x08));
  expect(FiftyColors.surface3.red, equals(255));
  expect(FiftyColors.surface3.green, equals(255));
  expect(FiftyColors.surface3.blue, equals(255));
});
```

#### Scenario 4: All Colors Non-Null
**What to test:** All color constants
**Given:** All colors defined
**When:** Access each color
**Then:** No null values

---

### Unit Tests - Typography (FiftyTypography)

#### Scenario 1: Font Family Spelling
**What to test:** Font family strings
**Given:** Font families defined
**When:** Read font family strings
**Then:** Exact spelling match

```dart
test('fontFamilyDisplay is "Space Grotesk"', () {
  expect(FiftyTypography.fontFamilyDisplay, equals('Space Grotesk'));
});

test('fontFamilyBody is "Inter"', () {
  expect(FiftyTypography.fontFamilyBody, equals('Inter'));
});

test('fontFamilyCode is "JetBrains Mono"', () {
  expect(FiftyTypography.fontFamilyCode, equals('JetBrains Mono'));
});
```

#### Scenario 2: Type Scale Values
**What to test:** All type scale sizes
**Given:** Type scale defined
**When:** Read size values
**Then:** Match FDL (48, 32, 28, 24, 20, 16, 14, 12)

```dart
test('type scale matches FDL specification', () {
  expect(FiftyTypography.displayXL, equals(48.0));
  expect(FiftyTypography.h1, equals(32.0));
  expect(FiftyTypography.h2, equals(28.0));
  expect(FiftyTypography.h3, equals(24.0));
  expect(FiftyTypography.bodyLarge, equals(20.0));
  expect(FiftyTypography.bodyBase, equals(16.0));
  expect(FiftyTypography.bodySmall, equals(14.0));
  expect(FiftyTypography.caption, equals(12.0));
});
```

#### Scenario 3: Font Weights
**What to test:** FontWeight constants
**Given:** Font weights defined
**When:** Read weight values
**Then:** Match FDL (w400, w500, w600, w700)

```dart
test('font weights match FDL specification', () {
  expect(FiftyTypography.regular, equals(FontWeight.w400));
  expect(FiftyTypography.medium, equals(FontWeight.w500));
  expect(FiftyTypography.semiBold, equals(FontWeight.w600));
  expect(FiftyTypography.bold, equals(FontWeight.w700));
});
```

---

### Unit Tests - Spacing (FiftySpacing)

#### Scenario 1: Spacing Scale Values
**What to test:** All spacing constants
**Given:** Spacing scale defined
**When:** Read spacing values
**Then:** Match FDL (2, 4, 8, 12, 16, 20, 24, 32, 40, 48)

```dart
test('spacing scale matches FDL specification', () {
  expect(FiftySpacing.micro, equals(2.0));
  expect(FiftySpacing.xs, equals(4.0));
  expect(FiftySpacing.sm, equals(8.0));
  expect(FiftySpacing.md, equals(12.0));
  expect(FiftySpacing.lg, equals(16.0));
  expect(FiftySpacing.xl, equals(20.0));
  expect(FiftySpacing.xxl, equals(24.0));
  expect(FiftySpacing.xxxl, equals(32.0));
  expect(FiftySpacing.huge, equals(40.0));
  expect(FiftySpacing.massive, equals(48.0));
});
```

#### Scenario 2: Responsive Gutters
**What to test:** Gutter constants
**Given:** Gutters defined
**When:** Read gutter values
**Then:** Match FDL (desktop: 24, tablet: 16, mobile: 12)

```dart
test('responsive gutters match FDL specification', () {
  expect(FiftySpacing.gutterDesktop, equals(24.0));
  expect(FiftySpacing.gutterTablet, equals(16.0));
  expect(FiftySpacing.gutterMobile, equals(12.0));
});
```

---

### Unit Tests - Radii (FiftyRadii)

#### Scenario 1: Radius Values
**What to test:** All radius constants
**Given:** Radii defined
**When:** Read radius values
**Then:** Match FDL (4, 6, 10, 16, 999)

```dart
test('radius values match FDL specification', () {
  expect(FiftyRadii.xs, equals(4.0));
  expect(FiftyRadii.sm, equals(6.0));
  expect(FiftyRadii.md, equals(10.0));
  expect(FiftyRadii.lg, equals(16.0));
  expect(FiftyRadii.full, equals(999.0));
});
```

#### Scenario 2: BorderRadius Objects
**What to test:** BorderRadius convenience objects
**Given:** BorderRadius objects defined
**When:** Read BorderRadius values
**Then:** Use correct raw values

```dart
test('BorderRadius objects use correct radius values', () {
  expect(FiftyRadii.xsRadius.topLeft.x, equals(4.0));
  expect(FiftyRadii.smRadius.topLeft.x, equals(6.0));
  expect(FiftyRadii.mdRadius.topLeft.x, equals(10.0));
  expect(FiftyRadii.lgRadius.topLeft.x, equals(16.0));
  expect(FiftyRadii.fullRadius.topLeft.x, equals(999.0));
});
```

---

### Unit Tests - Motion (FiftyMotion)

#### Scenario 1: Duration Values
**What to test:** All duration constants
**Given:** Durations defined
**When:** Read duration values
**Then:** Match FDL (120, 180, 240, 280 ms)

```dart
test('duration values match FDL specification', () {
  expect(FiftyMotion.fast.inMilliseconds, equals(120));
  expect(FiftyMotion.base.inMilliseconds, equals(180));
  expect(FiftyMotion.slow.inMilliseconds, equals(240));
  expect(FiftyMotion.overlay.inMilliseconds, equals(280));
});
```

#### Scenario 2: Easing Curves
**What to test:** Cubic bezier curves
**Given:** Curves defined
**When:** Verify curve type and control points
**Then:** Match FDL specifications

```dart
test('easing curves have correct control points', () {
  expect(FiftyMotion.emphasisEnter, isA<Cubic>());
  expect(FiftyMotion.emphasisExit, isA<Cubic>());
  expect(FiftyMotion.standard, isA<Cubic>());
  expect(FiftyMotion.spring, isA<Cubic>());

  // Verify curve behavior at boundaries
  expect(FiftyMotion.emphasisEnter.transform(0.0), equals(0.0));
  expect(FiftyMotion.emphasisEnter.transform(1.0), equals(1.0));
});
```

---

### Unit Tests - Elevation (FiftyElevation)

#### Scenario 1: Ambient Shadow
**What to test:** `FiftyElevation.ambient`
**Given:** Ambient shadow defined
**When:** Read shadow properties
**Then:** Match FDL (black 30%, blur 12)

```dart
test('ambient shadow matches FDL specification', () {
  expect(FiftyElevation.ambient.color.value, equals(0x4D000000));
  expect(FiftyElevation.ambient.blurRadius, equals(12.0));
  expect(FiftyElevation.ambient.offset, equals(Offset.zero));
});
```

#### Scenario 2: Crimson Glow
**What to test:** `FiftyElevation.crimsonGlow`
**Given:** Crimson glow defined
**When:** Read shadow properties
**Then:** Uses FiftyColors.crimsonCore with 45% opacity, blur 8

```dart
test('crimsonGlow uses correct color and blur', () {
  final expectedColor = FiftyColors.crimsonCore.withOpacity(0.45);
  expect(FiftyElevation.crimsonGlow.color.value, equals(expectedColor.value));
  expect(FiftyElevation.crimsonGlow.blurRadius, equals(8.0));
  expect(FiftyElevation.crimsonGlow.offset, equals(Offset.zero));
});
```

#### Scenario 3: Shadow Lists
**What to test:** Combined shadow lists
**Given:** Shadow lists defined
**When:** Check list composition
**Then:** Correct shadows in correct order

```dart
test('card shadow list contains ambient only', () {
  expect(FiftyElevation.card.length, equals(1));
  expect(FiftyElevation.card[0], equals(FiftyElevation.ambient));
});

test('focus shadow list contains glow + ambient', () {
  expect(FiftyElevation.focus.length, equals(2));
  expect(FiftyElevation.focus[0], equals(FiftyElevation.crimsonGlow));
  expect(FiftyElevation.focus[1], equals(FiftyElevation.ambient));
});
```

---

### Unit Tests - Breakpoints (FiftyBreakpoints)

#### Scenario 1: Breakpoint Values
**What to test:** All breakpoint constants
**Given:** Breakpoints defined
**When:** Read breakpoint values
**Then:** Match FDL (mobile: 768, desktop: 1024)

```dart
test('breakpoint values match FDL specification', () {
  expect(FiftyBreakpoints.mobile, equals(768.0));
  expect(FiftyBreakpoints.tablet, equals(768.0));
  expect(FiftyBreakpoints.desktop, equals(1024.0));
});
```

---

## Test Implementation Plan

### Phase 1: Token Validation Tests (Priority)
1. [ ] Create test file: `test/colors_test.dart`
2. [ ] Create test file: `test/typography_test.dart`
3. [ ] Create test file: `test/spacing_test.dart`
4. [ ] Create test file: `test/radii_test.dart`
5. [ ] Create test file: `test/motion_test.dart`
6. [ ] Create test file: `test/shadows_test.dart`
7. [ ] Create test file: `test/breakpoints_test.dart`
8. [ ] Create main test file: `test/fifty_tokens_test.dart` (imports package)

**Effort:** 1 day

### Phase 2: Comprehensive Coverage
1. [ ] Add edge case tests (null checks, type checks)
2. [ ] Add regression tests (verify constants don't change)
3. [ ] Add documentation tests (verify all constants documented)

**Effort:** 4 hours

### Phase 3: Continuous Integration
1. [ ] Verify all tests pass with `flutter test`
2. [ ] Add test coverage reporting
3. [ ] Document test execution in README

**Effort:** 2 hours

---

## Tasks

### Pending
- [ ] Create test directory structure
- [ ] Implement colors_test.dart (crimson accuracy, surfaces, text, semantic)
- [ ] Implement typography_test.dart (font families, scale, weights)
- [ ] Implement spacing_test.dart (scale values, gutters)
- [ ] Implement radii_test.dart (values, BorderRadius objects)
- [ ] Implement motion_test.dart (durations, curves)
- [ ] Implement shadows_test.dart (ambient, glow, lists)
- [ ] Implement breakpoints_test.dart (breakpoint values)
- [ ] Implement fifty_tokens_test.dart (package import test)
- [ ] Run flutter test and ensure 100% pass
- [ ] Verify test coverage >= 100% (all constants tested)
- [ ] Add test execution instructions to README

### In Progress
_(Empty)_

### Completed
_(Empty)_

---

## Session State (Tactical - This Brief)

**Current State:** Not started
**Next Steps When Resuming:** Begin with colors_test.dart - most critical (crimson accuracy)
**Last Updated:** 2025-11-10
**Blockers:** Requires BR-002 through BR-006 to be completed first

---

## Test Data & Mocks

### Mocks Required
- [ ] No mocks needed (pure constants)

### Test Data Fixtures
- [ ] No fixtures needed (hardcoded values from FDL)

### Expected Values (from FDL)
- **Colors:** #960E29, #B31337, #0E0E0F, etc.
- **Typography:** 48, 32, 28, 24, 20, 16, 14, 12 px
- **Spacing:** 2, 4, 8, 12, 16, 20, 24, 32, 40, 48 px
- **Radii:** 4, 6, 10, 16, 999 px
- **Motion:** 120, 180, 240, 280 ms
- **Shadows:** rgba(0,0,0,0.3), rgba(150,14,41,0.45)
- **Breakpoints:** 768, 1024 px

---

## Dependencies

### Testing Libraries
- [ ] `flutter_test` - Already included in Flutter SDK
- [ ] No additional dependencies needed

### Setup Required
- [ ] Create test/ directory (if not exists)
- [ ] Create test files for each token module
- [ ] No mock generation needed

---

## Acceptance Criteria

**Tests are complete when:**

1. [ ] All token modules have test files
2. [ ] Test coverage >= 100% (every constant tested)
3. [ ] All critical values verified (crimson colors, type scale, etc.)
4. [ ] All tests pass (`flutter test`)
5. [ ] Tests are maintainable (clear, well-documented)
6. [ ] Tests follow Dart testing conventions
7. [ ] Edge cases covered (alpha channels, curve boundaries, etc.)
8. [ ] No flaky tests (deterministic, no randomness)
9. [ ] Test execution documented in README

---

## Success Metrics

**Before:**
- Test Coverage: 0%
- Test Count: 0 tests
- Token Validation: Manual only

**After (Target):**
- Test Coverage: 100%
- Test Count: ~60-80 tests
- Token Validation: Automated, runs on every change

---

## References

**Design System:**
- `design_system/fifty_design_system.md` - Source of truth for all values

**Dart Testing:**
- https://dart.dev/guides/testing
- https://api.flutter.dev/flutter/flutter_test/flutter_test-library.html

---

## Notes

**Critical Tests (Must Pass):**
- Crimson Core = #960E29 exactly
- Tech Crimson = #B31337 exactly
- Type scale matches FDL (48, 32, 28, 24, 20, 16, 14, 12)
- Spacing scale matches 8px grid
- Motion durations match FDL (120, 180, 240, 280)

**Test Organization:**
- One test file per token module (colors, typography, etc.)
- Group related tests using `group()`
- Use descriptive test names
- Include expected values in test names

**Test Naming Convention:**
```dart
test('crimsonCore matches FDL specification #960E29', () { ... });
test('spacing scale follows 8px grid', () { ... });
test('emphasisEnter curve has correct control points', () { ... });
```

**Regression Prevention:**
- Tests lock in FDL values
- Any accidental change will fail tests
- Prevents token drift over time

**CI/CD Integration:**
- Tests run automatically on commit (if CI configured)
- Must pass before merge
- Test results visible in PR

**Dependencies:**
- BR-001 (structure) must be done
- BR-002 (colors) must be done - test crimson accuracy
- BR-003 (typography) must be done - test font families and scale
- BR-004 (spacing/radii) must be done - test grid and radius values
- BR-005 (motion) must be done - test durations and curves
- BR-006 (elevation/breakpoints) must be done - test shadows and breakpoints

---

**Created:** 2025-11-10
**Last Updated:** 2025-11-10
**Brief Owner:** Igris AI
