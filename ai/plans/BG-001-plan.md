# Implementation Plan: BG-001

**Brief:** Component Alignment & Layout Bugs
**Complexity:** M (Medium)
**Risk Level:** Low
**Files Affected:** 3

---

## Summary

Fix 5 alignment and layout bugs across three fifty_ui components:
- FiftyCard (tap area)
- FiftyTextField (multiline text alignment, block cursor alignment, underscore cursor alignment)
- FiftySlider (thumb position)

---

## Files to Modify

| File | Changes |
|------|---------|
| `packages/fifty_ui/lib/src/containers/fifty_card.dart` | Fix InkWell tap area to cover entire card |
| `packages/fifty_ui/lib/src/inputs/fifty_text_field.dart` | Fix multiline vertical alignment, block/underscore cursor alignment |
| `packages/fifty_ui/lib/src/inputs/fifty_slider.dart` | Fix thumb vertical positioning to center on track |

---

## Phase 1: FiftyCard Tap Area Fix (Bug 1)

**Root Cause:**
- InkWell wraps only `cardContent`, not the full card visual
- Decoration (background, border, shadow) is on outer AnimatedContainer
- Result: Only inner content responds to taps

**Fix:**
Move InkWell to wrap the entire `AnimatedContainer`:
```dart
Material(
  color: Colors.transparent,
  child: InkWell(
    onTap: widget.onTap,
    borderRadius: effectiveBorderRadius,
    child: AnimatedContainer(...), // visual decoration
  ),
)
```

---

## Phase 2: FiftyTextField Multiline Alignment (Bug 2)

**Root Cause:**
- Fixed `height: 48` on AnimatedContainer
- For multiline, 48px constraint prevents proper vertical text layout

**Fix:**
1. Remove fixed height for multiline mode
2. Use `constraints` instead:
```dart
constraints: widget.maxLines == 1
    ? const BoxConstraints(minHeight: 48, maxHeight: 48)
    : null,
```
3. Add `textAlignVertical: TextAlignVertical.top` for multiline

---

## Phase 3: FiftyTextField Block Cursor Alignment (Bug 3)

**Root Cause:**
- Block cursor character `\u2588` placed as suffixIcon
- suffixIcon positioning doesn't align with text baseline

**Fix:**
1. Wrap cursor in `Center` widget for vertical alignment
2. Add `height: 1.0` to TextStyle for consistent line height

---

## Phase 4: FiftyTextField Underscore Cursor Alignment (Bug 4)

**Root Cause:**
- Same mechanism as Bug 3
- Underscore `_` sits on baseline but suffix positioning misaligns it

**Fix:**
1. Use `Alignment.bottomCenter` for underscore
2. Add small bottom padding to position on baseline

---

## Phase 5: FiftySlider Thumb Position (Bug 5)

**Root Cause:**
- Thumb in Column with label
- Transform.translate on label still occupies layout space
- Thumb gets pushed below track

**Fix:**
Separate thumb and label into independent Positioned widgets:
```dart
// Label (separate Positioned at top: 0)
if (widget.showLabel)
  Positioned(
    left: thumbPosition,
    top: 0,
    child: /* label widget */,
  ),

// Thumb (vertically centered on track)
Positioned(
  left: thumbPosition,
  top: widget.showLabel ? 24 : 0, // After label space
  child: /* thumb widget */,
),
```

---

## Testing Strategy

**Manual Testing Checklist:**
- [ ] FiftyCard: Tap on card border/edge triggers onTap
- [ ] FiftyCard: Ripple effect covers full card surface
- [ ] FiftyTextField: Multiline text is top-aligned
- [ ] FiftyTextField: Block cursor aligns with text baseline
- [ ] FiftyTextField: Underscore cursor sits on text baseline
- [ ] FiftySlider: Thumb is centered on track at all positions
- [ ] FiftySlider: Thumb remains centered when showLabel is true

---

## Acceptance Criteria

| Bug | Criteria |
|-----|----------|
| 1 | Full card surface is tappable when onTap is provided |
| 2 | Multiline hint/text aligned properly (top for multiline) |
| 3 | Block cursor vertically centered with text |
| 4 | Underscore cursor aligned to baseline |
| 5 | Thumb centered on track, not below it |

---

**Plan Created:** 2026-01-20
**Status:** Ready for Implementation
