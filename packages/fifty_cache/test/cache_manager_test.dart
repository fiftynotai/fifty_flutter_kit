import 'package:fifty_cache/fifty_cache.dart';
import 'package:test/test.dart';

void main() {
  group('CacheManager', () {
    late MemoryCacheStore store;
    late DefaultCacheKeyStrategy keyStrategy;
    late SimpleTimeToLiveCachePolicy policy;
    late CacheManager manager;

    setUp(() {
      store = MemoryCacheStore();
      keyStrategy = const DefaultCacheKeyStrategy();
      policy = SimpleTimeToLiveCachePolicy(timeToLive: const Duration(hours: 1));
      manager = CacheManager(store, keyStrategy, policy);
    });

    group('tryRead', () {
      test('returns null when cache is empty', () async {
        final result = await manager.tryRead('GET', 'https://api/users', null);
        expect(result, isNull);
      });

      test('returns cached value when present', () async {
        // Manually populate cache
        final key = keyStrategy.buildKey('https://api/users', null);
        await store.put(key, '{"users": []}', ttl: const Duration(hours: 1));

        final result = await manager.tryRead('GET', 'https://api/users', null);
        expect(result, equals('{"users": []}'));
      });

      test('returns null when forceRefresh is true', () async {
        final key = keyStrategy.buildKey('https://api/users', null);
        await store.put(key, '{"users": []}', ttl: const Duration(hours: 1));

        final result = await manager.tryRead(
          'GET',
          'https://api/users',
          null,
          forceRefresh: true,
        );
        expect(result, isNull);
      });

      test('returns null for POST requests with default policy', () async {
        final key = keyStrategy.buildKey(
          'https://api/users',
          null,
          method: 'POST',
        );
        await store.put(key, '{"result": "ok"}', ttl: const Duration(hours: 1));

        final result = await manager.tryRead('POST', 'https://api/users', null);
        expect(result, isNull);
      });

      test('includes headers in key lookup', () async {
        final key = keyStrategy.buildKey(
          'https://api/users',
          null,
          headers: {'Accept-Language': 'en'},
        );
        await store.put(key, '{"lang": "en"}', ttl: const Duration(hours: 1));

        // Should find with matching headers
        final result = await manager.tryRead(
          'GET',
          'https://api/users',
          null,
          headers: {'Accept-Language': 'en'},
        );
        expect(result, equals('{"lang": "en"}'));

        // Should not find with different headers
        final result2 = await manager.tryRead(
          'GET',
          'https://api/users',
          null,
          headers: {'Accept-Language': 'fr'},
        );
        expect(result2, isNull);
      });
    });

    group('tryWrite', () {
      test('stores successful GET response', () async {
        await manager.tryWrite(
          'GET',
          'https://api/users',
          null,
          statusCode: 200,
          bodyString: '{"users": []}',
        );

        final result = await manager.tryRead('GET', 'https://api/users', null);
        expect(result, equals('{"users": []}'));
      });

      test('does not store error responses', () async {
        await manager.tryWrite(
          'GET',
          'https://api/users',
          null,
          statusCode: 404,
          bodyString: '{"error": "Not found"}',
        );

        final result = await manager.tryRead('GET', 'https://api/users', null);
        expect(result, isNull);
      });

      test('does not store null bodyString', () async {
        await manager.tryWrite(
          'GET',
          'https://api/users',
          null,
          statusCode: 200,
          bodyString: null,
        );

        final result = await manager.tryRead('GET', 'https://api/users', null);
        expect(result, isNull);
      });

      test('does not store POST responses with default policy', () async {
        await manager.tryWrite(
          'POST',
          'https://api/users',
          null,
          statusCode: 201,
          bodyString: '{"id": 1}',
        );

        // Would need to use a policy that allows POST reads to verify
        // But with default policy, POST reads return null anyway
        final key = keyStrategy.buildKey(
          'https://api/users',
          null,
          method: 'POST',
        );
        final stored = await store.get(key);
        expect(stored, isNull);
      });

      test('includes headers in key when storing', () async {
        await manager.tryWrite(
          'GET',
          'https://api/users',
          null,
          statusCode: 200,
          bodyString: '{"lang": "en"}',
          headers: {'Accept-Language': 'en'},
        );

        // Should find with matching headers
        final result = await manager.tryRead(
          'GET',
          'https://api/users',
          null,
          headers: {'Accept-Language': 'en'},
        );
        expect(result, equals('{"lang": "en"}'));

        // Should not find without headers
        final result2 = await manager.tryRead(
          'GET',
          'https://api/users',
          null,
        );
        expect(result2, isNull);
      });

      test('stores with query parameters', () async {
        await manager.tryWrite(
          'GET',
          'https://api/users',
          {'page': 1, 'limit': 10},
          statusCode: 200,
          bodyString: '{"users": [], "page": 1}',
        );

        final result = await manager.tryRead(
          'GET',
          'https://api/users',
          {'page': 1, 'limit': 10},
        );
        expect(result, equals('{"users": [], "page": 1}'));

        // Different query should not match
        final result2 = await manager.tryRead(
          'GET',
          'https://api/users',
          {'page': 2, 'limit': 10},
        );
        expect(result2, isNull);
      });
    });

    group('invalidate', () {
      test('removes specific cache entry', () async {
        await manager.tryWrite(
          'GET',
          'https://api/users',
          null,
          statusCode: 200,
          bodyString: '{"users": []}',
        );

        await manager.invalidate('GET', 'https://api/users', null);

        final result = await manager.tryRead('GET', 'https://api/users', null);
        expect(result, isNull);
      });

      test('does not affect other entries', () async {
        await manager.tryWrite(
          'GET',
          'https://api/users',
          null,
          statusCode: 200,
          bodyString: '{"users": []}',
        );
        await manager.tryWrite(
          'GET',
          'https://api/posts',
          null,
          statusCode: 200,
          bodyString: '{"posts": []}',
        );

        await manager.invalidate('GET', 'https://api/users', null);

        final result1 = await manager.tryRead('GET', 'https://api/users', null);
        final result2 = await manager.tryRead('GET', 'https://api/posts', null);
        expect(result1, isNull);
        expect(result2, equals('{"posts": []}'));
      });

      test('invalidates with matching headers', () async {
        await manager.tryWrite(
          'GET',
          'https://api/users',
          null,
          statusCode: 200,
          bodyString: '{"lang": "en"}',
          headers: {'Accept-Language': 'en'},
        );

        await manager.invalidate(
          'GET',
          'https://api/users',
          null,
          headers: {'Accept-Language': 'en'},
        );

        final result = await manager.tryRead(
          'GET',
          'https://api/users',
          null,
          headers: {'Accept-Language': 'en'},
        );
        expect(result, isNull);
      });
    });

    group('clear', () {
      test('removes all cache entries', () async {
        await manager.tryWrite(
          'GET',
          'https://api/users',
          null,
          statusCode: 200,
          bodyString: '{"users": []}',
        );
        await manager.tryWrite(
          'GET',
          'https://api/posts',
          null,
          statusCode: 200,
          bodyString: '{"posts": []}',
        );
        await manager.tryWrite(
          'GET',
          'https://api/comments',
          null,
          statusCode: 200,
          bodyString: '{"comments": []}',
        );

        await manager.clear();

        expect(
          await manager.tryRead('GET', 'https://api/users', null),
          isNull,
        );
        expect(
          await manager.tryRead('GET', 'https://api/posts', null),
          isNull,
        );
        expect(
          await manager.tryRead('GET', 'https://api/comments', null),
          isNull,
        );
      });
    });

    group('integration scenarios', () {
      test('full cache workflow: write, read, invalidate', () async {
        // Write
        await manager.tryWrite(
          'GET',
          'https://api/users/123',
          null,
          statusCode: 200,
          bodyString: '{"id": 123, "name": "John"}',
        );

        // Read back
        final cached = await manager.tryRead(
          'GET',
          'https://api/users/123',
          null,
        );
        expect(cached, equals('{"id": 123, "name": "John"}'));

        // Invalidate after update
        await manager.invalidate('GET', 'https://api/users/123', null);

        // Verify removed
        final afterInvalidate = await manager.tryRead(
          'GET',
          'https://api/users/123',
          null,
        );
        expect(afterInvalidate, isNull);
      });

      test('respects TTL from policy', () async {
        // Create manager with very short TTL
        final shortTtlPolicy = SimpleTimeToLiveCachePolicy(
          timeToLive: const Duration(milliseconds: 1),
        );
        final shortTtlManager =
            CacheManager(store, keyStrategy, shortTtlPolicy);

        await shortTtlManager.tryWrite(
          'GET',
          'https://api/users',
          null,
          statusCode: 200,
          bodyString: '{"users": []}',
        );

        // Wait for expiry
        await Future.delayed(const Duration(milliseconds: 10));

        final result = await shortTtlManager.tryRead(
          'GET',
          'https://api/users',
          null,
        );
        expect(result, isNull);
      });
    });
  });
}
