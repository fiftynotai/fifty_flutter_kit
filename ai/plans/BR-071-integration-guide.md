# BR-071 TACTICAL GRID - Package Integration Guide

**Generated:** 2026-02-04
**Packages:** fifty_map_engine, fifty_audio_engine, fifty_ui, fifty_tokens

---

## Package Architecture

```
FiftyAudioEngine (singleton)     FiftyMapWidget (widget)      fifty_ui (components)
      │                                │                             │
      ├── bgm: BgmChannel              ├── FiftyMapController        ├── FiftyButton
      ├── sfx: SfxChannel              ├── FiftyMapBuilder           ├── FiftyCard
      └── voice: VoiceActingChannel    └── Entity Components         ├── FiftyProgressBar
                                                                     └── FiftyDialog
                                            │
                                     fifty_tokens
                               (Colors, Spacing, Typography)
```

---

## 1. fifty_map_engine

### Entity Hierarchy

```
FiftyBaseComponent (abstract)
    ├── FiftyStaticComponent     // Furniture, obstacles
    ├── FiftyMovableComponent    // Units (has movement)
    ├── FiftyRoomComponent       // Board background
    └── FiftyEventComponent      // Overlays (valid moves)
```

### Widget Integration

```dart
class TacticalBoard extends StatefulWidget {
  @override
  State<TacticalBoard> createState() => _TacticalBoardState();
}

class _TacticalBoardState extends State<TacticalBoard> {
  final FiftyMapController controller = FiftyMapController();

  @override
  Widget build(BuildContext context) {
    return FiftyMapWidget(
      controller: controller,
      initialEntities: createBoardEntities(),
      onEntityTap: (entity) => handleUnitSelection(entity),
    );
  }
}
```

### Register Unit Types

```dart
// In initialization
FiftyEntitySpawner.register('knight', (m) => TacticalUnitComponent(model: m));
FiftyEntitySpawner.register('archer', (m) => TacticalUnitComponent(model: m));
FiftyEntitySpawner.register('commander', (m) => TacticalUnitComponent(model: m));
```

### Movement

```dart
// Via Controller
controller.move(entity, targetX, targetY);

// Via Component
component.moveTo(newPosition, newModel, speed: 150);
component.attack(onComplete: () => print('done'));
component.die(onComplete: () => print('removed'));
```

### Valid Move Overlays

```dart
void showValidMoves(List<GridPosition> positions) {
  final overlays = positions.map((pos) => FiftyMapEntity(
    id: 'highlight_${pos.x}_${pos.y}',
    type: 'event',
    asset: 'assets/highlights/valid_move.png',
    gridPosition: Vector2(pos.x.toDouble(), pos.y.toDouble()),
    blockSize: FiftyBlockSize(1, 1),
    zIndex: 50,
  )).toList();

  controller.addEntities(overlays);
}
```

### Key Considerations
- **Tile size:** 64px (FiftyMapConfig.blockSize)
- **Y-axis flipped:** Origin is bottom-left
- **Tap handling:** Uses long-press by default, override for regular tap

---

## 2. fifty_audio_engine

### Initialization (main.dart)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FiftyAudioEngine.instance.initialize([
    'audio/bgm/battle_theme.mp3',
    'audio/bgm/victory.mp3',
  ]);

  runApp(TacticalGridApp());
}
```

### BGM Control

```dart
final engine = FiftyAudioEngine.instance;

// Play battle music
await engine.bgm.playCustomPlaylist(['audio/bgm/battle.mp3']);

// Control
await engine.bgm.pause();
await engine.bgm.resume();
await engine.bgm.setVolume(0.7);

// Reactive updates
engine.bgm.onIsPlayingChanged.listen((isPlaying) {
  setState(() => _bgmPlaying = isPlaying);
});
```

### SFX Groups

```dart
final sfx = FiftyAudioEngine.instance.sfx;

// Register groups
sfx.registerGroup('ui', ['audio/sfx/select.wav', 'audio/sfx/click.wav']);
sfx.registerGroup('combat', ['audio/sfx/attack_1.wav', 'audio/sfx/attack_2.wav']);
sfx.registerGroup('movement', ['audio/sfx/footstep.wav']);

// Play random from group
await sfx.playGroup('combat');

// Play specific
await sfx.play('audio/sfx/victory.wav');
```

### Voice Announcer

```dart
final voice = FiftyAudioEngine.instance.voice;

// Auto-ducks BGM
await voice.playVoice('audio/voice/your_turn.mp3');

// Without ducking
await voice.playVoice('audio/voice/hint.mp3', false);
```

### Audio Coordinator Pattern

```dart
class BattleAudioCoordinator {
  final _engine = FiftyAudioEngine.instance;

  Future<void> onUnitSelected() => _engine.sfx.playGroup('ui');
  Future<void> onUnitMove() => _engine.sfx.playGroup('movement');
  Future<void> onAttack() => _engine.sfx.playGroup('combat');
  Future<void> onTurnStart(bool isPlayer) => _engine.voice.playVoice(
    isPlayer ? 'audio/voice/your_turn.mp3' : 'audio/voice/enemy_turn.mp3'
  );
}
```

### Key Considerations
- **Singleton pattern:** Initialize once in main.dart
- **SFX cooldown:** 150ms between plays (anti-spam)
- **Voice ducks BGM:** Automatic, can disable per-call

---

## 3. fifty_ui Components

### FiftyButton

```dart
// Variants: primary, secondary, outline, ghost, danger
// Sizes: small (36px), medium (48px), large (56px)

FiftyButton(
  label: 'ATTACK',
  onPressed: onAttack,
  variant: FiftyButtonVariant.danger,
  size: FiftyButtonSize.small,
  icon: Icons.sword,
  disabled: !hasTargets,
)
```

### FiftyCard

```dart
FiftyCard(
  child: UnitStats(),
  onTap: () => selectUnit(),
  selected: isSelected,
  scanlineOnHover: true,
  padding: EdgeInsets.all(FiftySpacing.lg),
)
```

### FiftyProgressBar

```dart
// HP Bar
FiftyProgressBar(
  value: unit.hp / unit.maxHp,
  label: 'HP',
  showPercentage: true,
  height: 8,
  foregroundColor: FiftyColors.hunterGreen,
)

// Turn Timer
FiftyProgressBar(
  value: timeRemaining / maxTime,
  foregroundColor: timeRemaining < 10
      ? FiftyColors.burgundy
      : FiftyColors.slateGrey,
)
```

### FiftyDialog

```dart
showFiftyDialog(
  context: context,
  builder: (context) => FiftyDialog(
    title: 'VICTORY',
    content: Text('Commander captured!'),
    actions: [
      FiftyButton(label: 'PLAY AGAIN', onPressed: restart),
      FiftyButton(label: 'MAIN MENU', variant: ghost, onPressed: exit),
    ],
  ),
);
```

### Key Considerations
- **Requires FiftyTheme:** Wrap app with theme provider
- **Labels auto-uppercase:** FDL convention
- **Animations respect reduced-motion:** Accessibility

---

## 4. fifty_tokens

### Colors

```dart
FiftyColors.burgundy        // #88292F - Primary/Player
FiftyColors.slateGrey       // #335C67 - Secondary/Enemy
FiftyColors.darkBurgundy    // #1A0D0E - Background
FiftyColors.cream           // #FEFEE3 - Text/Selection
FiftyColors.hunterGreen     // #4B644A - Success/Valid
FiftyColors.powderBlush     // #FFC9B9 - Accent
```

### Spacing

```dart
FiftySpacing.xs     // 4px
FiftySpacing.sm     // 8px
FiftySpacing.md     // 12px
FiftySpacing.lg     // 16px
FiftySpacing.xl     // 20px
FiftySpacing.xxl    // 24px
```

### Typography

```dart
FiftyTypography.fontFamily      // 'Manrope'
FiftyTypography.displayLarge    // 32px
FiftyTypography.titleMedium     // 18px
FiftyTypography.bodyMedium      // 14px
FiftyTypography.extraBold       // 800
FiftyTypography.bold            // 700
```

---

## Game UI Layout Pattern

```dart
Stack(
  children: [
    // Game board (full area)
    FiftyMapWidget(
      controller: controller,
      onEntityTap: onUnitTap,
    ),

    // HUD overlay
    SafeArea(
      child: Column(
        children: [
          // Top bar
          _TopBar(turn: turn, timer: timer),

          Spacer(),

          // Bottom panel
          _UnitInfoPanel(unit: selectedUnit),
        ],
      ),
    ),
  ],
)
```
