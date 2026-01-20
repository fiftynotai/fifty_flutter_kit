# BR-032: Selection Controls (Checkbox & Radio)

**Type:** Feature
**Priority:** P2-Medium
**Effort:** S-Small (0.5-1d)
**Status:** In Progress
**Created:** 2026-01-20
**Requested By:** Monarch

---

## Problem

The fifty_ui library is missing selection control components that were specified in the Design System v2:

1. **FiftyCheckbox** - Multi-select boolean control
2. **FiftyRadio** - Single-select option control

These are fundamental form elements needed for complete form building.

---

## Goal

Implement FDL v2-compliant selection controls:

### FiftyCheckbox
| Property | Value |
|----------|-------|
| Size | 20px |
| Border radius | sm (4px) |
| Checked bg | primary (burgundy) |
| Check icon | Material check, white |
| Unchecked border | gray-200 / white/10% |

### FiftyRadio
| Property | Value |
|----------|-------|
| Size | 20px |
| Shape | Circle |
| Selected | primary (burgundy) filled dot |
| Unselected border | gray-200 / white/10% |

---

## API Design

### FiftyCheckbox
```dart
FiftyCheckbox(
  value: _isChecked,
  onChanged: (value) => setState(() => _isChecked = value),
  label: 'Accept terms',  // Optional
  enabled: true,
)
```

### FiftyRadio
```dart
FiftyRadio<String>(
  value: 'option1',
  groupValue: _selectedOption,
  onChanged: (value) => setState(() => _selectedOption = value),
  label: 'Option 1',  // Optional
)
```

---

## Files to Create

| File | Description |
|------|-------------|
| `lib/src/inputs/fifty_checkbox.dart` | Checkbox component |
| `lib/src/inputs/fifty_radio.dart` | Radio button component |
| `test/inputs/fifty_checkbox_test.dart` | Checkbox tests |
| `test/inputs/fifty_radio_test.dart` | Radio tests |

---

## Acceptance Criteria

- [ ] FiftyCheckbox implemented with v2 styling
- [ ] FiftyRadio implemented with v2 styling
- [ ] Both support enabled/disabled states
- [ ] Both support optional label
- [ ] Animation on state change (150ms)
- [ ] Focus states with accent ring
- [ ] Barrel export updated
- [ ] Tests passing
- [ ] Added to example app (UI-005)

---

## Design Reference

From MG-003 brief:

**FiftyCheckbox:**
- Size: 20px
- Border radius: sm (4px)
- Checked bg: primary
- Check icon: Material check, white

**FiftyRadio:**
- Size: 20px
- Shape: Circle
- Selected: primary filled dot
- Unselected: gray border

---

## Workflow State

**Phase:** REVIEWING
**Active Agent:** reviewer
**Retry Count:** 0

### Agent Log
- `2026-01-20 15:45` - Starting PLANNER agent for implementation planning
- `2026-01-20 15:46` - PLANNER complete - Plan approved (S-Small, auto-approve)
- `2026-01-20 15:46` - Starting CODER agent for implementation
- `2026-01-20 15:50` - CODER complete - 2 files created, 1 modified
- `2026-01-20 15:50` - TESTER complete - Analyzer: 0 issues, Tests: 222 passed
- `2026-01-20 15:51` - Starting REVIEWER agent for code review
