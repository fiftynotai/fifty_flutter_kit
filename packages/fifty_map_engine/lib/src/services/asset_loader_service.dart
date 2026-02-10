import 'package:flame/cache.dart';

/// **Fifty Asset Loader Service**
///
/// A flexible static service for registering and preloading image assets.
///
/// This service is designed for host apps to define which assets the game map
/// will use. It does not contain any hardcoded paths - everything must be
/// registered manually before `loadAll()` is called.
///
/// **Key Features:**
/// - Manual registration of image asset paths
/// - Bulk loading via [Images]
/// - Supports reset / inspection
///
/// **Usage:**
/// ```dart
/// FiftyAssetLoader.registerAssets([
///   'rooms/small_room.png',
///   'events/npc.png',
/// ]);
///
/// // Later in your game onLoad:
/// await FiftyAssetLoader.loadAll(images);
/// ```
class FiftyAssetLoader {
  FiftyAssetLoader._();

  static final Set<String> _registeredAssets = <String>{};

  /// **Register asset paths**
  ///
  /// - Safe to call multiple times
  /// - Duplicates are ignored
  ///
  /// Example:
  /// ```dart
  /// FiftyAssetLoader.registerAssets([
  ///   'rooms/small_room.png',
  ///   'events/npc.png',
  /// ]);
  /// ```
  static void registerAssets(Iterable<String> assetPaths) {
    _registeredAssets.addAll(assetPaths);
  }

  /// **Preload all registered assets**
  ///
  /// Call this once during `onLoad()` or app startup. Throws an exception
  /// if nothing was registered.
  static Future<void> loadAll(Images images) async {
    if (_registeredAssets.isEmpty) return;
    await images.loadAll(_registeredAssets.toList());
  }

  /// **Reset asset registry**
  ///
  /// Clears the current registry. Useful for testing, hot reload, or teardown.
  static void reset() {
    _registeredAssets.clear();
  }

  /// **Get currently registered assets**
  static List<String> get registeredAssets =>
      List.unmodifiable(_registeredAssets);
}
