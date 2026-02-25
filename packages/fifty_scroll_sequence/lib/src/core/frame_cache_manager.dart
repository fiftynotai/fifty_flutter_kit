import 'dart:async';
import 'dart:collection';
import 'dart:ui' as ui;

import '../loaders/frame_loader.dart';

/// LRU cache for decoded [ui.Image] frames with proper GPU texture disposal.
///
/// Maintains a [LinkedHashMap]-based LRU cache where the most recently
/// accessed entries are kept at the end. When the cache exceeds
/// [maxCacheSize], the least recently used entries are evicted and
/// their [ui.Image] objects are disposed to free GPU memory.
///
/// ## Memory Safety
///
/// All cached [ui.Image] objects are GPU-backed textures. They MUST be
/// disposed when evicted or when the cache is cleared. Call [clearAll]
/// when the owning widget unmounts.
///
/// ## Example
///
/// ```dart
/// final cache = FrameCacheManager(maxCacheSize: 100);
/// final image = await cache.loadFrame(0, loader);
///
/// // Later, clean up:
/// cache.clearAll(); // Disposes all cached images
/// ```
class FrameCacheManager {
  /// Creates a [FrameCacheManager] with the given [maxCacheSize].
  FrameCacheManager({this.maxCacheSize = 100});

  /// Maximum number of frames to keep in the cache.
  final int maxCacheSize;

  /// LRU-ordered cache: most recently used at end.
  final LinkedHashMap<int, ui.Image> _cache = LinkedHashMap<int, ui.Image>();

  /// In-flight load indices to prevent duplicate requests.
  final Set<int> _loading = <int>{};

  /// Pending load completers for deduplication.
  final Map<int, Completer<ui.Image>> _pending = <int, Completer<ui.Image>>{};

  /// Get a cached frame, or null if not cached.
  ///
  /// Promotes the entry to most-recently-used position in the LRU cache.
  ui.Image? getFrame(int index) {
    final image = _cache.remove(index);
    if (image != null) {
      _cache[index] = image; // re-insert at end = most recent
    }
    return image;
  }

  /// Load a frame via [loader], using cache if available.
  ///
  /// Deduplicates concurrent requests for the same [index] so that
  /// only one load operation is in flight per frame at any time.
  Future<ui.Image> loadFrame(int index, FrameLoader loader) async {
    // Return cached if available
    final cached = getFrame(index);
    if (cached != null) return cached;

    // Deduplicate in-flight requests
    if (_loading.contains(index)) {
      return _pending[index]!.future;
    }

    _loading.add(index);
    final completer = Completer<ui.Image>();
    _pending[index] = completer;

    try {
      final image = await loader.loadFrame(index);
      _evictIfNeeded();
      _cache[index] = image;
      completer.complete(image);
      return image;
    } catch (e, st) {
      completer.completeError(e, st);
      rethrow;
    } finally {
      _loading.remove(index);
      _pending.remove(index);
    }
  }

  /// Find nearest cached frame searching toward frame 0.
  ///
  /// Used for gapless playback: if the target frame is not yet loaded,
  /// display the closest previously loaded frame to avoid blank flashes.
  /// Returns null if no frames are cached.
  ui.Image? nearestCachedFrame(int targetIndex) {
    for (int i = targetIndex - 1; i >= 0; i--) {
      final image = _cache[i];
      if (image != null) return image;
    }
    return null;
  }

  /// Current number of cached frames.
  int get length => _cache.length;

  /// Whether any loads are currently in flight.
  bool get isLoading => _loading.isNotEmpty;

  /// Estimated memory usage in bytes.
  ///
  /// Rough estimate: width * height * 4 bytes (RGBA) per cached image.
  int get estimatedMemoryBytes {
    int total = 0;
    for (final image in _cache.values) {
      total += image.width * image.height * 4;
    }
    return total;
  }

  /// Dispose all cached images and clear state.
  ///
  /// MUST be called when the owning widget unmounts to free GPU textures.
  void clearAll() {
    for (final image in _cache.values) {
      image.dispose();
    }
    _cache.clear();
    _loading.clear();
    _pending.clear();
  }

  void _evictIfNeeded() {
    while (_cache.length >= maxCacheSize) {
      final oldest = _cache.keys.first;
      final image = _cache.remove(oldest);
      image?.dispose(); // CRITICAL: dispose GPU texture
    }
  }
}
