/// Cache Demo ViewModel
///
/// Business logic for the cache demo feature.
/// Demonstrates TTL-based caching with hit/miss indicators.
library;

import 'dart:async';

import 'package:fifty_cache/fifty_cache.dart';
import 'package:get/get.dart';

/// ViewModel for the cache demo feature.
///
/// Manages a [CacheManager] with [MemoryCacheStore] to demonstrate
/// TTL-based caching behavior, hit/miss tracking, and cache stats.
class CacheDemoViewModel extends GetxController {
  late final MemoryCacheStore _store;
  late final CacheManager _cacheManager;

  /// TTL duration for cached entries.
  static const Duration cacheTtl = Duration(seconds: 15);

  /// Simulated API endpoints.
  static const List<String> endpoints = [
    'https://api.example.com/users',
    'https://api.example.com/products',
    'https://api.example.com/orders',
  ];

  // ---------------------------------------------------------------------------
  // Observable State
  // ---------------------------------------------------------------------------

  /// Whether an API call is in progress.
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  /// Last result from a fetch attempt.
  final _lastResult = ''.obs;
  String get lastResult => _lastResult.value;

  /// Whether the last fetch was a cache hit.
  final _wasCacheHit = false.obs;
  bool get wasCacheHit => _wasCacheHit.value;

  /// Total cache hits.
  final _hitCount = 0.obs;
  int get hitCount => _hitCount.value;

  /// Total cache misses.
  final _missCount = 0.obs;
  int get missCount => _missCount.value;

  /// Current number of entries in cache.
  final _entryCount = 0.obs;
  int get entryCount => _entryCount.value;

  /// Currently selected endpoint index.
  final _selectedEndpoint = 0.obs;
  int get selectedEndpoint => _selectedEndpoint.value;

  /// Time remaining until cache entry expires (seconds).
  final _ttlRemaining = 0.obs;
  int get ttlRemaining => _ttlRemaining.value;

  /// Whether a cache entry exists for current endpoint.
  final _hasActiveEntry = false.obs;
  bool get hasActiveEntry => _hasActiveEntry.value;

  Timer? _ttlTimer;

  /// Tracks when each endpoint was cached.
  final Map<int, DateTime> _cacheTimestamps = {};

  @override
  void onInit() {
    super.onInit();
    _store = MemoryCacheStore();
    _cacheManager = CacheManager(
      _store,
      const DefaultCacheKeyStrategy(),
      SimpleTimeToLiveCachePolicy(timeToLive: cacheTtl),
    );
  }

  @override
  void onClose() {
    _ttlTimer?.cancel();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------------------

  /// Selects an endpoint by index.
  void selectEndpoint(int index) {
    _selectedEndpoint.value = index;
    _updateTtlForCurrentEndpoint();
    update();
  }

  /// Simulates an API call with cache check.
  Future<void> fetchData() async {
    _isLoading.value = true;
    update();

    final url = endpoints[_selectedEndpoint.value];

    // Try reading from cache first
    final cached = await _cacheManager.tryRead('GET', url, null);

    if (cached != null) {
      // Cache hit
      _wasCacheHit.value = true;
      _hitCount.value++;
      _lastResult.value = cached;
    } else {
      // Cache miss - simulate network delay
      _wasCacheHit.value = false;
      _missCount.value++;

      await Future<void>.delayed(const Duration(milliseconds: 800));

      // Generate simulated response
      final response =
          '{"endpoint": "$url", "timestamp": "${DateTime.now().toIso8601String()}", "data": "Simulated response #${_missCount.value}"}';

      // Write to cache
      await _cacheManager.tryWrite(
        'GET',
        url,
        null,
        statusCode: 200,
        bodyString: response,
      );

      _lastResult.value = response;
      _cacheTimestamps[_selectedEndpoint.value] = DateTime.now();
      _entryCount.value++;
    }

    _isLoading.value = false;
    _updateTtlForCurrentEndpoint();
    update();
  }

  /// Clears all cache entries and resets stats.
  Future<void> clearCache() async {
    await _cacheManager.clear();
    _entryCount.value = 0;
    _hitCount.value = 0;
    _missCount.value = 0;
    _lastResult.value = '';
    _wasCacheHit.value = false;
    _hasActiveEntry.value = false;
    _ttlRemaining.value = 0;
    _cacheTimestamps.clear();
    _ttlTimer?.cancel();
    update();
  }

  /// Updates the TTL countdown for the currently selected endpoint.
  void _updateTtlForCurrentEndpoint() {
    _ttlTimer?.cancel();

    final cachedAt = _cacheTimestamps[_selectedEndpoint.value];
    if (cachedAt == null) {
      _hasActiveEntry.value = false;
      _ttlRemaining.value = 0;
      return;
    }

    final expiresAt = cachedAt.add(cacheTtl);
    final remaining = expiresAt.difference(DateTime.now()).inSeconds;

    if (remaining <= 0) {
      _hasActiveEntry.value = false;
      _ttlRemaining.value = 0;
      _cacheTimestamps.remove(_selectedEndpoint.value);
      return;
    }

    _hasActiveEntry.value = true;
    _ttlRemaining.value = remaining;

    _ttlTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      final left = expiresAt.difference(now).inSeconds;
      if (left <= 0) {
        _hasActiveEntry.value = false;
        _ttlRemaining.value = 0;
        _cacheTimestamps.remove(_selectedEndpoint.value);
        _entryCount.value = _entryCount.value > 0 ? _entryCount.value - 1 : 0;
        _ttlTimer?.cancel();
      } else {
        _ttlRemaining.value = left;
      }
      update();
    });
  }

  /// Gets the hit rate as a percentage string.
  String get hitRateDisplay {
    final total = _hitCount.value + _missCount.value;
    if (total == 0) return '0%';
    final rate = (_hitCount.value / total * 100).toStringAsFixed(0);
    return '$rate%';
  }
}
