import 'package:fifty_cache/fifty_cache.dart';
import 'package:test/test.dart';

void main() {
  group('MemoryCacheStore', () {
    late MemoryCacheStore store;

    setUp(() {
      store = MemoryCacheStore();
    });

    test('put and get returns stored value', () async {
      await store.put('key1', 'value1', ttl: const Duration(hours: 1));
      final result = await store.get('key1');
      expect(result, equals('value1'));
    });

    test('get returns null for non-existent key', () async {
      final result = await store.get('non-existent');
      expect(result, isNull);
    });

    test('get returns null for expired entry', () async {
      await store.put('key1', 'value1', ttl: const Duration(milliseconds: 1));
      // Wait for expiry
      await Future.delayed(const Duration(milliseconds: 10));
      final result = await store.get('key1');
      expect(result, isNull);
    });

    test('remove deletes entry', () async {
      await store.put('key1', 'value1', ttl: const Duration(hours: 1));
      await store.remove('key1');
      final result = await store.get('key1');
      expect(result, isNull);
    });

    test('remove does not throw for non-existent key', () async {
      await expectLater(store.remove('non-existent'), completes);
    });

    test('clear removes all entries', () async {
      await store.put('key1', 'value1', ttl: const Duration(hours: 1));
      await store.put('key2', 'value2', ttl: const Duration(hours: 1));
      await store.put('key3', 'value3', ttl: const Duration(hours: 1));

      await store.clear();

      expect(await store.get('key1'), isNull);
      expect(await store.get('key2'), isNull);
      expect(await store.get('key3'), isNull);
    });

    test('put overwrites existing entry', () async {
      await store.put('key1', 'value1', ttl: const Duration(hours: 1));
      await store.put('key1', 'value2', ttl: const Duration(hours: 1));
      final result = await store.get('key1');
      expect(result, equals('value2'));
    });

    test('multiple entries with different TTLs', () async {
      await store.put('short', 'short-value',
          ttl: const Duration(milliseconds: 1));
      await store.put('long', 'long-value', ttl: const Duration(hours: 1));

      // Wait for short TTL to expire
      await Future.delayed(const Duration(milliseconds: 10));

      expect(await store.get('short'), isNull);
      expect(await store.get('long'), equals('long-value'));
    });

    test('stores and retrieves JSON strings', () async {
      const jsonValue = '{"id": 1, "name": "test", "nested": {"key": "value"}}';
      await store.put('json-key', jsonValue, ttl: const Duration(hours: 1));
      final result = await store.get('json-key');
      expect(result, equals(jsonValue));
    });
  });
}
