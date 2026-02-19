// ignore_for_file: avoid_print

import 'package:fifty_cache/fifty_cache.dart';

void main() async {
  // ===========================================================================
  // FIFTY CACHE EXAMPLE
  // Demonstrating TTL-based caching with pluggable stores and policies
  // ===========================================================================

  // ---------------------------------------------------------------------------
  // Setup: Create a CacheManager with in-memory store
  // ---------------------------------------------------------------------------

  final store = MemoryCacheStore();
  const keyStrategy = DefaultCacheKeyStrategy();
  final policy = SimpleTimeToLiveCachePolicy();

  final cache = CacheManager(store, keyStrategy, policy);

  // ---------------------------------------------------------------------------
  // Write to cache
  // ---------------------------------------------------------------------------

  const method = 'GET';
  const url = 'https://api.example.com/users';
  const query = {'page': '1', 'limit': '10'};
  const responseBody = '{"users": [{"id": 1, "name": "Alice"}]}';

  await cache.tryWrite(
    method,
    url,
    query,
    statusCode: 200,
    bodyString: responseBody,
  );

  print('Wrote response to cache');

  // ---------------------------------------------------------------------------
  // Read from cache
  // ---------------------------------------------------------------------------

  final cached = await cache.tryRead(method, url, query);

  if (cached != null) {
    print('Cache hit: $cached');
  } else {
    print('Cache miss — fetch from network');
  }

  // ---------------------------------------------------------------------------
  // Invalidate a single entry
  // ---------------------------------------------------------------------------

  await cache.invalidate(method, url, query);
  print('Invalidated cache entry');

  // Verify it's gone
  final afterInvalidate = await cache.tryRead(method, url, query);
  print('After invalidate: ${afterInvalidate ?? "null (cache miss)"}');

  // ---------------------------------------------------------------------------
  // Clear all cached entries
  // ---------------------------------------------------------------------------

  await cache.clear();
  print('Cleared all cache entries');
}
