import 'dart:async';

import '../contracts/cache_store.dart';

/// **MemoryCacheStore**
///
/// In-memory [CacheStore] implementation for testing and lightweight caching.
/// Entries expire based on TTL.
///
/// **Why**
/// - Zero external dependencies for unit testing.
/// - Lightweight option for short-lived caches that don't need persistence.
/// - Perfect for development and testing scenarios.
///
/// **Key Features**
/// - TTL-based expiration checked on read.
/// - No disk I/O or external dependencies.
/// - Thread-safe within single isolate (Dart's default).
///
/// **Example**
/// ```dart
/// final store = MemoryCacheStore();
/// await store.put('key', 'value', ttl: Duration(minutes: 5));
/// final cached = await store.get('key'); // => 'value'
/// ```
///
// ------------------------------------------------
class MemoryCacheStore implements CacheStore {
  final Map<String, _CacheEntry> _cache = {};

  /// **put**
  ///
  /// Store a value with an expiry computed from TTL.
  // ------------------------------------------------
  @override
  Future<void> put(String key, String value, {required Duration ttl}) async {
    _cache[key] = _CacheEntry(value, DateTime.now().add(ttl));
  }

  /// **get**
  ///
  /// Retrieve a value when present and not expired. Removes expired entries.
  // ------------------------------------------------
  @override
  Future<String?> get(String key) async {
    final entry = _cache[key];
    if (entry == null) return null;
    if (entry.expiry.isBefore(DateTime.now())) {
      await remove(key);
      return null;
    }
    return entry.value;
  }

  /// **remove**
  ///
  /// Delete a single entry by key.
  // ------------------------------------------------
  @override
  Future<void> remove(String key) async {
    _cache.remove(key);
  }

  /// **clear**
  ///
  /// Remove all entries from the cache.
  // ------------------------------------------------
  @override
  Future<void> clear() async {
    _cache.clear();
  }
}

/// Internal cache entry with value and expiry timestamp.
class _CacheEntry {
  _CacheEntry(this.value, this.expiry);

  final String value;
  final DateTime expiry;
}
