# BR-030: Fifty Dialogue Engine Package

**Type:** Feature
**Priority:** P2-Medium
**Effort:** L-Large (2-3 weeks)
**Status:** Ready
**Created:** 2026-01-20
**Assignee:** -

---

## Problem

Game developers building RPGs, visual novels, adventure games, or any narrative-driven experience need branching dialogue systems. The existing `fifty_sentences_engine` handles text processing and narration, but lacks:
- Branching conversation trees with player choices
- Character management with portraits and expressions
- Conditional dialogue based on stats, flags, items
- Consequence system for state changes
- Relationship/reputation tracking
- Persistent dialogue state for save games

Developers must build complex dialogue systems from scratch, which is time-consuming and error-prone.

---

## Goal

Create `fifty_dialogue_engine` - a production-ready Flutter package providing a complete dialogue system with:
- DialogueTree with branching nodes and choices
- Character system with portraits and expressions
- Condition system (stats, flags, items, quests, relations)
- Consequence system for state changes
- DialogueStateManager for persistence
- YAML/JSON dialogue file support
- Integration with fifty_sentences_engine, fifty_speech_engine, fifty_audio_engine
- FDL-compliant UI widgets

---

## Context & Inputs

**Target Location:** `packages/fifty_dialogue_engine/`

**Ecosystem Integration:**
| Package | Integration |
|---------|-------------|
| fifty_sentences_engine | Text animation, typewriter effect |
| fifty_speech_engine | Voice acting playback |
| fifty_audio_engine | Ambient sounds, SFX |
| fifty_skill_tree | Skills affect dialogue checks |
| fifty_achievement_engine | Dialogue completion achievements |
| fifty_inventory_engine | Item checks and rewards |
| fifty_ui | Dialogue box, choice buttons |
| fifty_storage | Persist dialogue state |
| fifty_tokens | FDL styling tokens |

**Similar Package Reference:** `packages/fifty_skill_tree/` (patterns, structure)

---

## Proposed Solution

### Core Models

**DialogueNode**
```dart
DialogueNode({
  id: String,
  speaker: String,                     // character ID
  text: String,
  portrait: String?,                   // expression key
  voiceLine: String?,                  // audio file path
  choices: List<DialogueChoice>,
  onEnter: DialogueAction?,
  onExit: DialogueAction?,
})
```

**DialogueChoice**
```dart
DialogueChoice({
  id: String,
  text: String,
  nextNode: String?,                   // null = end dialogue
  condition: DialogueCondition?,
  consequence: DialogueConsequence?,
  style: ChoiceStyle,                  // normal, skill, locked, hidden
})
```

**DialogueCharacter**
```dart
DialogueCharacter({
  id: String,
  name: String,
  portraits: Map<String, String>,      // expression -> asset path
  voiceId: String?,
  color: Color?,
})
```

**DialogueTree**
```dart
DialogueTree({
  id: String,
  name: String,
  startNode: String,
  nodes: Map<String, DialogueNode>,
  characters: Map<String, DialogueCharacter>,
  variables: Map<String, dynamic>,
})
```

### Condition Types

| Type | Purpose |
|------|---------|
| `StatCondition` | Skill/attribute checks |
| `FlagCondition` | Boolean story flags |
| `ItemCondition` | Inventory requirements |
| `QuestCondition` | Quest state checks |
| `RelationCondition` | Relationship thresholds |
| `CompositeCondition` | AND/OR combinations |

### Consequence System

```dart
DialogueConsequence({
  setFlags: Map<String, bool>,
  addItems: Map<String, int>,
  changeRelation: Map<String, int>,
  changeStats: Map<String, num>,
  triggerEvent: String?,
  startQuest: String?,
})
```

### Controller API

**DialogueController**
- `startDialogue(tree)` - Begin conversation
- `currentNode` / `currentSpeaker` - Current state
- `availableChoices` - Filtered by conditions
- `selectChoice(index)` - Make choice
- `advance()` - Auto-advance (no choices)
- `goToNode(id)` - Jump to node
- `endDialogue()` - Force end
- `getFlag(key)` / `setFlag(key, value)` - Flag access
- `getVariable(key)` / `setVariable(key, value)` - Variable access
- `dialogueHistory` / `choiceHistory` - History tracking

**DialogueStateManager**
- Global flags, stats, relations, variables
- Completed dialogues tracking
- `exportState()` / `importState()` - Persistence

### UI Widgets

| Widget | Purpose |
|--------|---------|
| `DialogueBox` | Main dialogue display container |
| `SpeakerPortrait` | Character portrait with expressions |
| `SpeakerName` | Styled character name label |
| `DialogueText` | Animated text with typewriter effect |
| `ChoiceList` | Branching choice buttons |
| `ChoiceButton` | Single choice with condition styling |
| `DialogueHistory` | Scrollable conversation log |
| `SkillCheckIndicator` | Shows skill requirement/result |

### File Format Support

**YAML:**
```yaml
id: merchant_intro
startNode: node_001
nodes:
  node_001:
    speaker: merchant
    text: "Welcome, traveler!"
    choices:
      - text: "Hello!"
        nextNode: node_002
```

**JSON:** Equivalent structure in JSON format

---

## Package Structure

```
fifty_dialogue_engine/
├── lib/
│   ├── src/
│   │   ├── models/
│   │   │   ├── dialogue_tree.dart
│   │   │   ├── dialogue_node.dart
│   │   │   ├── dialogue_choice.dart
│   │   │   ├── dialogue_character.dart
│   │   │   ├── dialogue_consequence.dart
│   │   │   └── choice_style.dart
│   │   ├── conditions/
│   │   │   ├── dialogue_condition.dart
│   │   │   ├── stat_condition.dart
│   │   │   ├── flag_condition.dart
│   │   │   ├── item_condition.dart
│   │   │   ├── quest_condition.dart
│   │   │   ├── relation_condition.dart
│   │   │   └── composite_condition.dart
│   │   ├── controllers/
│   │   │   ├── dialogue_controller.dart
│   │   │   └── dialogue_state_manager.dart
│   │   ├── widgets/
│   │   │   ├── dialogue_box.dart
│   │   │   ├── speaker_portrait.dart
│   │   │   ├── speaker_name.dart
│   │   │   ├── dialogue_text.dart
│   │   │   ├── choice_list.dart
│   │   │   ├── choice_button.dart
│   │   │   ├── dialogue_history.dart
│   │   │   ├── skill_check_indicator.dart
│   │   │   └── widgets.dart
│   │   ├── loaders/
│   │   │   ├── dialogue_loader.dart
│   │   │   ├── yaml_parser.dart
│   │   │   └── json_parser.dart
│   │   ├── serialization/
│   │   │   ├── state_serializer.dart
│   │   │   └── serialization.dart
│   │   └── themes/
│   │       ├── dialogue_theme.dart
│   │       ├── theme_presets.dart
│   │       └── themes.dart
│   └── fifty_dialogue_engine.dart
├── example/
│   ├── lib/
│   │   ├── main.dart
│   │   ├── data/
│   │   │   ├── sample_dialogues.dart
│   │   │   └── dialogues/
│   │   │       └── merchant.yaml
│   │   └── examples/
│   │       ├── basic_dialogue.dart
│   │       ├── rpg_dialogue.dart
│   │       └── visual_novel.dart
│   └── pubspec.yaml
├── test/
│   ├── models/
│   ├── conditions/
│   ├── controllers/
│   ├── loaders/
│   └── widgets/
├── README.md
├── CHANGELOG.md
└── pubspec.yaml
```

---

## Acceptance Criteria

- [ ] Core models: DialogueTree, DialogueNode, DialogueChoice, DialogueCharacter
- [ ] DialogueConsequence with flags, items, relations, stats, events
- [ ] 6 condition types: Stat, Flag, Item, Quest, Relation, Composite
- [ ] DialogueController with full navigation API
- [ ] DialogueStateManager with persistence
- [ ] 8 UI widgets with FDL compliance
- [ ] YAML and JSON dialogue file loaders
- [ ] Theme system with presets (RPG, Visual Novel, Modern)
- [ ] Example app with 3 demo scenarios
- [ ] Unit tests (200+ tests)
- [ ] Documentation (README, API docs, CHANGELOG)
- [ ] Integration examples with ecosystem packages

---

## Test Plan

**Unit Tests:**
- DialogueTree traversal and node lookup
- All condition types evaluate correctly
- Consequence application modifies state
- Controller navigation (advance, select, jump)
- StateManager flag/variable operations
- YAML/JSON parsing

**Widget Tests:**
- DialogueBox renders correctly
- ChoiceList shows/hides based on conditions
- ChoiceButton styling for different ChoiceStyles
- SpeakerPortrait expression switching
- DialogueText typewriter animation

**Integration Tests:**
- Full dialogue flow with branching
- Condition-gated choices
- Consequence application
- State save/load cycle
- Voice line integration

---

## Constraints

- Must follow FDL (Fifty Design Language) patterns
- Use ChangeNotifier pattern (framework-agnostic)
- No external dependencies beyond Flutter SDK, yaml package, and ecosystem packages
- Generic metadata support where applicable
- Immutable models with copyWith
- YAML dependency must be optional (JSON always works)

---

## Delivery

- [ ] Package at `packages/fifty_dialogue_engine/`
- [ ] Example app at `packages/fifty_dialogue_engine/example/`
- [ ] README.md with usage examples
- [ ] CHANGELOG.md with v0.1.0 entry
- [ ] All tests passing
- [ ] Analyzer clean (no warnings)

---

## Workflow State

**Phase:** Not Started
**Active Agent:** None
**Retry Count:** 0

### Agent Log
_(empty - not started)_

---
