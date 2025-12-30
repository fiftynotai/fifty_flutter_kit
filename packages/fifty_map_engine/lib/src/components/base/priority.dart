/// **FiftyRenderPriority**
///
/// Defines draw order priorities for map components. Lower values are rendered
/// behind higher values, ensuring correct layering of rooms, entities, and UI.
///
/// **Priority Levels:**
/// - [background] (0): room backgrounds and terrain
/// - [furniture] (10): static objects like furniture and props
/// - [door] (20): doors and entryways
/// - [monster] (30): enemy entities
/// - [character] (40): player characters and friendly NPCs
/// - [event] (50): event markers and overlays (quest points, icons)
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

  /// UI overlays (menus, dialogs)
  static const int uiOverlay = 100;
}
