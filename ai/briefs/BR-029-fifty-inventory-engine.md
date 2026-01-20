# BR-029: Fifty Inventory Engine Package

**Type:** Feature
**Priority:** P2-Medium
**Effort:** L-Large (2-3 weeks)
**Status:** Ready
**Created:** 2026-01-20
**Assignee:** -

---

## Problem

Game developers building RPGs, survival games, looters, or any item-based game need inventory systems. There is no Flutter package that provides a complete inventory solution with:
- Item models with rarity, categories, properties
- Multiple capacity systems (slot-based, weight-based, hybrid)
- Stacking, splitting, and sorting
- Equipment slots with stat aggregation
- Drag-drop UI interactions
- Persistence for save games

Developers must build this from scratch every time, which is time-consuming and error-prone.

---

## Goal

Create `fifty_inventory_engine` - a production-ready Flutter package providing a complete inventory system with:
- Flexible Item<T> model with generic metadata
- Multiple inventory capacity modes
- Equipment system with slot restrictions
- Drag-drop ready UI widgets
- JSON serialization for save games
- Integration with fifty_skill_tree, fifty_achievement_engine, fifty_audio_engine

---

## Context & Inputs

**Target Location:** `packages/fifty_inventory_engine/`

**Ecosystem Integration:**
| Package | Integration |
|---------|-------------|
| fifty_skill_tree | Skills unlock slots or reduce weight |
| fifty_achievement_engine | Item collection achievements |
| fifty_audio_engine | Pickup/drop/equip sounds |
| fifty_ui | Tooltips, cards, modals |
| fifty_storage | Persist inventory state |
| fifty_tokens | FDL styling tokens |

**Similar Package Reference:** `packages/fifty_skill_tree/` (patterns, structure)

---

## Proposed Solution

### Core Models

**Item<T>**
```dart
Item<T>({
  id: String,
  name: String,
  description: String,
  icon: String?,
  rarity: ItemRarity,              // common, uncommon, rare, epic, legendary
  category: ItemCategory,           // weapon, armor, consumable, material, quest
  stackable: bool,
  maxStack: int,
  weight: double,
  value: int,
  properties: ItemProperties?,
  data: T?,
})
```

**Inventory**
```dart
Inventory({
  id: String,
  name: String,
  slots: int?,                      // slot-based capacity
  maxWeight: double?,               // weight-based capacity
  categories: List<ItemCategory>,   // allowed categories
  items: List<InventorySlot>,
})
```

**EquipmentSlots**
```dart
EquipmentSlots({
  slots: Map<String, EquipmentSlot>,  // head, chest, mainHand, etc.
})
```

### Capacity Systems

| System | Configuration | Use Case |
|--------|---------------|----------|
| Slot-based | `slots: 20` | Minecraft, Diablo |
| Weight-based | `maxWeight: 100.0` | Skyrim, Dark Souls |
| Hybrid | `slots: 20, maxWeight: 100.0` | Tarkov |
| Unlimited | Neither set | Casual games |

### Controller API

**InventoryController**
- `addItem(inventoryId, item, quantity)` - Add items with auto-stack
- `removeItem(inventoryId, slotIndex)` - Remove from slot
- `removeItemById(inventoryId, itemId, quantity)` - Remove by ID
- `moveItem(inventoryId, fromSlot, toSlot)` - Move within inventory
- `transferItem(from, to, slotIndex)` - Transfer between inventories
- `hasItem(inventoryId, itemId)` - Check existence
- `countItem(inventoryId, itemId)` - Count quantity
- `getFreeSlots(inventoryId)` - Available slots
- `getCurrentWeight(inventoryId)` - Current weight
- `stackItems(inventoryId)` - Auto-consolidate stacks
- `splitStack(inventoryId, slotIndex, quantity)` - Split stack
- `sortInventory(inventoryId, by: SortMode)` - Sort items
- `exportInventories()` / `importInventories()` - Serialization

**EquipmentController**
- `equip(slotId, item)` - Equip item
- `unequip(slotId)` - Unequip to inventory
- `getEquippedStats()` - Aggregate equipment stats
- `canEquip(slotId, item)` - Check slot compatibility

### UI Widgets

| Widget | Purpose |
|--------|---------|
| `InventoryGrid` | Grid display with drag-drop slots |
| `InventorySlotWidget` | Single slot with item display |
| `ItemTooltip` | Hover/long-press item details |
| `EquipmentPanel` | Character equipment layout |
| `ItemIcon` | Rarity-bordered item icon |
| `StackBadge` | Quantity overlay on stacked items |
| `WeightBar` | Current/max weight indicator |
| `DragItemOverlay` | Ghost item during drag |

---

## Package Structure

```
fifty_inventory_engine/
├── lib/
│   ├── src/
│   │   ├── models/
│   │   │   ├── item.dart
│   │   │   ├── item_rarity.dart
│   │   │   ├── item_category.dart
│   │   │   ├── item_properties.dart
│   │   │   ├── inventory.dart
│   │   │   ├── inventory_slot.dart
│   │   │   └── equipment_slots.dart
│   │   ├── controllers/
│   │   │   ├── inventory_controller.dart
│   │   │   └── equipment_controller.dart
│   │   ├── widgets/
│   │   │   ├── inventory_grid.dart
│   │   │   ├── inventory_slot_widget.dart
│   │   │   ├── item_tooltip.dart
│   │   │   ├── equipment_panel.dart
│   │   │   ├── item_icon.dart
│   │   │   ├── stack_badge.dart
│   │   │   ├── weight_bar.dart
│   │   │   └── widgets.dart
│   │   ├── drag_drop/
│   │   │   ├── drag_item_overlay.dart
│   │   │   ├── drop_target.dart
│   │   │   └── drag_drop.dart
│   │   ├── serialization/
│   │   │   ├── inventory_serializer.dart
│   │   │   └── serialization.dart
│   │   └── themes/
│   │       ├── inventory_theme.dart
│   │       ├── theme_presets.dart
│   │       └── themes.dart
│   └── fifty_inventory_engine.dart
├── example/
│   ├── lib/
│   │   ├── main.dart
│   │   ├── data/
│   │   │   └── sample_items.dart
│   │   └── examples/
│   │       ├── basic_inventory.dart
│   │       ├── rpg_inventory.dart
│   │       └── survival_inventory.dart
│   └── pubspec.yaml
├── test/
│   ├── models/
│   ├── controllers/
│   ├── widgets/
│   └── serialization/
├── README.md
├── CHANGELOG.md
└── pubspec.yaml
```

---

## Acceptance Criteria

- [ ] Core models: Item, ItemRarity, ItemCategory, ItemProperties
- [ ] Inventory model with slot/weight/hybrid capacity modes
- [ ] InventorySlot with quantity and lock support
- [ ] EquipmentSlots with slot restrictions
- [ ] InventoryController with full CRUD API
- [ ] EquipmentController with equip/unequip/stats
- [ ] Stacking, splitting, sorting operations
- [ ] 8 UI widgets with FDL compliance
- [ ] Drag-drop system for item movement
- [ ] JSON serialization (export/import)
- [ ] Theme system with presets
- [ ] Example app with 3 demo scenarios (basic, RPG, survival)
- [ ] Unit tests (200+ tests)
- [ ] Documentation (README, API docs, CHANGELOG)
- [ ] Integration examples with ecosystem packages

---

## Test Plan

**Unit Tests:**
- Item model creation and copyWith
- Inventory capacity enforcement (slots, weight, hybrid)
- Stacking logic with maxStack limits
- Splitting stack edge cases
- Equipment slot restrictions
- Serialization round-trip

**Widget Tests:**
- InventoryGrid renders correct slot count
- ItemTooltip displays item details
- StackBadge shows quantity
- WeightBar reflects current/max
- Drag-drop interactions

**Integration Tests:**
- Add item → auto-stack → verify count
- Transfer between inventories
- Equip → check stats → unequip → verify inventory
- Full save/load cycle

---

## Constraints

- Must follow FDL (Fifty Design Language) patterns
- Use ChangeNotifier pattern (framework-agnostic)
- No external dependencies beyond Flutter SDK and ecosystem packages
- Generic type support for custom item data
- Immutable models with copyWith
- Drag-drop must work on mobile and desktop

---

## Delivery

- [ ] Package at `packages/fifty_inventory_engine/`
- [ ] Example app at `packages/fifty_inventory_engine/example/`
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
