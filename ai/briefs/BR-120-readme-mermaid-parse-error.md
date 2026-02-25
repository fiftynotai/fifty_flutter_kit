# BR-120: Fix Mermaid Diagram Parse Error in Root README

**Type:** Bug Fix
**Priority:** P1-High
**Effort:** S-Small (< 4h)
**Assignee:** Igris AI
**Commanded By:** Monarch
**Status:** Done
**Created:** 2026-02-25

---

## Problem

**What's broken or missing?**

The Mermaid architecture diagram in the root README fails to render on GitHub with a parse error:

```
Unable to render rich display

Parse error on line 25:
... utils -.-> App Development util
----------------------^
Expecting 'SEMI', 'NEWLINE', 'EOF', 'AMP', 'START_LINK', 'LINK', 'LINK_ID', got 'NODE_STRING'
```

**Root Cause:** Lines 164-165 of README.md link `utils` to subgraph display names with spaces:

```mermaid
utils -.-> App Development
utils -.-> Game Development
```

Mermaid does not support linking directly to subgraph names that contain spaces. Subgraph display names are labels, not valid node IDs for link targets.

**Why does it matter?**

- The architecture diagram is a key visual in the root README
- GitHub renders a red error box instead of the diagram
- Visitors see a broken page — bad first impression for a "top tier" README

---

## Goal

**What should happen after this brief is completed?**

The Mermaid diagram renders correctly on GitHub with no parse errors. The `fifty_utils` dependency relationship to both App Development and Game Development subgroups is visually represented.

---

## Context & Inputs

### Affected Modules
- [x] Other: Root `README.md` (lines 139-166)

### The Broken Lines
```
utils -.-> App Development
utils -.-> Game Development
```

### Fix Options

**Option A: Link to specific nodes within each subgraph**
```mermaid
utils -.-> forms
utils -.-> cache
utils -.-> audio
utils -.-> world
```
Pros: Valid Mermaid, shows specific dependencies. Cons: Cluttered with many dotted lines.

**Option B: Use subgraph IDs (no spaces)**
```mermaid
subgraph AppDev[App Development]
    ...
end
utils -.-> AppDev
```
Pros: Clean, links to subgraph by ID. Cons: May not render on all Mermaid versions.

**Option C: Link to one representative node per subgraph**
```mermaid
utils -.-> forms
utils -.-> audio
```
Pros: Minimal, clean. Cons: Doesn't explicitly show all connections.

---

## Acceptance Criteria

**The feature/fix is complete when:**

1. [ ] Mermaid diagram renders correctly on GitHub (no parse error)
2. [ ] `fifty_utils` relationship to both subgroups is visually clear
3. [ ] Diagram layout remains clean and readable
4. [ ] No other diagram regressions introduced

---

## Test Plan

### Manual Test Cases

#### Test Case 1: GitHub Rendering
**Steps:**
1. Push fix to GitHub
2. View root README on repository page
3. Verify Mermaid diagram renders without errors
4. Verify all nodes and connections display correctly

**Expected Result:** Clean architecture diagram with no error box

---

## Delivery

### Code Changes
- [ ] Modified: `README.md` (fix lines 164-165 in Mermaid block)

---

## Notes

- Also check `docs/ARCHITECTURE.md` for the same issue — it has a similar Mermaid diagram
- Quick fix, high visibility impact

---

**Created:** 2026-02-25
**Last Updated:** 2026-02-25
**Brief Owner:** Igris AI
