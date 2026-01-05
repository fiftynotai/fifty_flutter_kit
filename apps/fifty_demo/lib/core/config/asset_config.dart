/// Asset Configuration
///
/// Defines asset paths and configuration for the demo app.
library;

/// Asset path constants.
abstract class AssetPaths {
  /// Base path for images.
  static const String images = 'assets/images/';

  /// Base path for audio files.
  static const String audio = 'assets/audio/';

  /// Base path for map assets.
  static const String maps = 'assets/maps/';
}

/// Map asset configuration.
abstract class MapAssets {
  /// Room background images.
  static const List<String> rooms = [
    'rooms/small_room.png',
    'rooms/medium_room.png',
    'rooms/large_room.jpg',
  ];

  /// Furniture/object images.
  static const List<String> furniture = [
    'furniture/door.png',
    'furniture/box.png',
    'furniture/table.png',
  ];

  /// Entity/character images.
  static const List<String> entities = [
    'monsters/m-1.png',
    'monsters/m-2.png',
  ];
}

/// Audio asset configuration.
abstract class AudioAssets {
  /// BGM track URLs (using sample URLs for demo).
  static const List<String> bgmTracks = [
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
    'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
  ];

  /// SFX sound URLs.
  static const List<String> sfxSounds = [
    'https://www.soundjay.com/buttons/sounds/button-09a.mp3',
    'https://www.soundjay.com/buttons/sounds/button-16.mp3',
  ];
}
