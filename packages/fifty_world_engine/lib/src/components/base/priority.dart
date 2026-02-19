/// **FiftyRenderPriority**
///
/// Defines draw order priorities for map components. Lower values are rendered
/// behind higher values, ensuring correct layering of rooms, entities, and UI.
///
/// **Priority Levels:**
/// - [tileGrid] (-10): tile grid ground layer (below everything)
/// - [background] (0): room backgrounds and terrain
/// - [tileOverlay] (5): tile overlays (highlights, selection)
/// - [furniture] (10): static objects like furniture and props
/// - [door] (20): doors and entryways
/// - [monster] (30): enemy entities
/// - [character] (40): player characters and friendly NPCs
/// - [event] (50): event markers and overlays (quest points, icons)
/// - [decorator] (60): entity decorators (HP bars, selection rings)
/// - [floatingEffect] (70): floating effects (damage popups)
/// - [uiOverlay] (100): UI elements above all map entities (menus, dialogs)
class FiftyRenderPriority {
  FiftyRenderPriority._();

  /// Room backgrounds and terrain
  static const int background = 0;

  /// Static objects (furniture, decorations)
  static const int furniture = 10;

  /// Doors and entryways
  static const int door = 20;

  /// Monsters and enemies
  static const int monster = 30;

  /// Player characters and friendly NPCs
  static const int character = 40;

  /// Event markers and overlays
  static const int event = 50;

  /// Entity decorators (HP bars, selection rings - above entities)
  static const int decorator = 60;

  /// Floating effects (damage popups - above decorators)
  static const int floatingEffect = 70;

  /// UI overlays (menus, dialogs)
  static const int uiOverlay = 100;

  /// Tile grid (ground layer, below everything)
  static const int tileGrid = -10;

  /// Tile overlays (highlights, selection - above tiles, below entities)
  static const int tileOverlay = 5;
}
