/// Configuration for a sprite sheet animation.
///
/// Defines the sprite sheet image, frame dimensions, and a map of named
/// animation states (e.g., idle, walk, attack).
///
/// This is a PUBLIC class - consumers use it to describe entity animations.
///
/// **Example:**
/// ```dart
/// final config = SpriteAnimationConfig(
///   spriteSheetAsset: 'characters/hero_sheet.png',
///   frameWidth: 32,
///   frameHeight: 32,
///   states: {
///     'idle': SpriteAnimationStateConfig(row: 0, frameCount: 4),
///     'walk': SpriteAnimationStateConfig(row: 1, frameCount: 6),
///     'attack': SpriteAnimationStateConfig(row: 2, frameCount: 4, loop: false),
///     'die': SpriteAnimationStateConfig(row: 3, frameCount: 4, loop: false),
///   },
/// );
/// ```
class SpriteAnimationConfig {
  /// Asset path to the sprite sheet image.
  final String spriteSheetAsset;

  /// Width of a single frame in pixels.
  final int frameWidth;

  /// Height of a single frame in pixels.
  final int frameHeight;

  /// Map of animation state name -> configuration.
  ///
  /// Common states: 'idle', 'walk', 'attack', 'die'.
  final Map<String, SpriteAnimationStateConfig> states;

  /// The initial animation state (must exist in [states]).
  final String defaultState;

  /// Creates a [SpriteAnimationConfig].
  const SpriteAnimationConfig({
    required this.spriteSheetAsset,
    required this.frameWidth,
    required this.frameHeight,
    required this.states,
    this.defaultState = 'idle',
  });
}

/// Configuration for a single animation state within a sprite sheet.
///
/// Each state corresponds to a row in the sprite sheet. Frames are read
/// left-to-right from column 0.
///
/// **Fields:**
/// - [row]: which row in the sprite sheet (0-based)
/// - [frameCount]: how many frames to read from that row
/// - [stepTime]: seconds per frame (lower = faster animation)
/// - [loop]: whether the animation loops or plays once
class SpriteAnimationStateConfig {
  /// Row index in the sprite sheet (0-based). Each row is a different state.
  final int row;

  /// Number of frames in this animation.
  final int frameCount;

  /// Time per frame in seconds (e.g., 0.1 = 10 FPS).
  final double stepTime;

  /// Whether the animation loops.
  final bool loop;

  /// Creates a [SpriteAnimationStateConfig].
  const SpriteAnimationStateConfig({
    required this.row,
    required this.frameCount,
    this.stepTime = 0.1,
    this.loop = true,
  });
}
