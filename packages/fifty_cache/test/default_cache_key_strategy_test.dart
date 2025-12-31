import 'package:fifty_cache/fifty_cache.dart';
import 'package:test/test.dart';

void main() {
  group('DefaultCacheKeyStrategy', () {
    const strategy = DefaultCacheKeyStrategy();

    group('basic key building', () {
      test('builds key with method and URL', () {
        final key = strategy.buildKey('https://api/users', null);
        expect(key, equals('GET https://api/users | H:auth=0'));
      });

      test('normalizes method to uppercase', () {
        final key = strategy.buildKey(
          'https://api/users',
          null,
          method: 'get',
        );
        expect(key, startsWith('GET '));
      });

      test('handles different HTTP methods', () {
        final getKey = strategy.buildKey(
          'https://api/users',
          null,
          method: 'GET',
        );
        final postKey = strategy.buildKey(
          'https://api/users',
          null,
          method: 'POST',
        );
        final putKey = strategy.buildKey(
          'https://api/users',
          null,
          method: 'PUT',
        );

        expect(getKey, startsWith('GET '));
        expect(postKey, startsWith('POST '));
        expect(putKey, startsWith('PUT '));
      });
    });

    group('query parameters', () {
      test('appends sorted query parameters', () {
        final key = strategy.buildKey(
          'https://api/users',
          {'page': 1, 'limit': 10},
        );
        expect(key, contains('?limit=10&page=1'));
      });

      test('sorts query keys alphabetically', () {
        final key = strategy.buildKey(
          'https://api/users',
          {'z': 1, 'a': 2, 'm': 3},
        );
        expect(key, contains('?a=2&m=3&z=1'));
      });

      test('handles empty query map', () {
        final key = strategy.buildKey('https://api/users', {});
        expect(key, isNot(contains('?')));
      });

      test('handles null query', () {
        final key = strategy.buildKey('https://api/users', null);
        expect(key, isNot(contains('?')));
      });

      test('handles string query values', () {
        final key = strategy.buildKey(
          'https://api/search',
          {'q': 'hello world', 'type': 'users'},
        );
        expect(key, contains('q=hello world'));
        expect(key, contains('type=users'));
      });
    });

    group('header fingerprinting', () {
      test('includes auth=0 when no headers', () {
        final key = strategy.buildKey('https://api/users', null);
        expect(key, contains('auth=0'));
      });

      test('includes auth=1 when Authorization header present', () {
        final key = strategy.buildKey(
          'https://api/users',
          null,
          headers: {'Authorization': 'Bearer token123'},
        );
        expect(key, contains('auth=1'));
      });

      test('includes auth=0 when Authorization header is empty', () {
        final key = strategy.buildKey(
          'https://api/users',
          null,
          headers: {'Authorization': ''},
        );
        expect(key, contains('auth=0'));
      });

      test('includes auth=0 when Authorization header is whitespace', () {
        final key = strategy.buildKey(
          'https://api/users',
          null,
          headers: {'Authorization': '   '},
        );
        expect(key, contains('auth=0'));
      });

      test('includes language when Accept-Language header present', () {
        final key = strategy.buildKey(
          'https://api/users',
          null,
          headers: {'Accept-Language': 'en-US'},
        );
        expect(key, contains('lang=en-us'));
      });

      test('lowercases language value', () {
        final key = strategy.buildKey(
          'https://api/users',
          null,
          headers: {'Accept-Language': 'EN-GB'},
        );
        expect(key, contains('lang=en-gb'));
      });

      test('handles case-insensitive header names', () {
        final key1 = strategy.buildKey(
          'https://api/users',
          null,
          headers: {'accept-language': 'en'},
        );
        final key2 = strategy.buildKey(
          'https://api/users',
          null,
          headers: {'ACCEPT-LANGUAGE': 'en'},
        );
        final key3 = strategy.buildKey(
          'https://api/users',
          null,
          headers: {'Accept-Language': 'en'},
        );

        expect(key1, contains('lang=en'));
        expect(key2, contains('lang=en'));
        expect(key3, contains('lang=en'));
      });

      test('combines language and auth in fingerprint', () {
        final key = strategy.buildKey(
          'https://api/users',
          null,
          headers: {
            'Accept-Language': 'fr',
            'Authorization': 'Bearer xyz',
          },
        );
        expect(key, contains('lang=fr'));
        expect(key, contains('auth=1'));
      });
    });

    group('determinism', () {
      test('produces identical keys for identical inputs', () {
        final key1 = strategy.buildKey(
          'https://api/users',
          {'page': 1, 'limit': 10},
          method: 'GET',
          headers: {'Accept-Language': 'en', 'Authorization': 'Bearer token'},
        );
        final key2 = strategy.buildKey(
          'https://api/users',
          {'page': 1, 'limit': 10},
          method: 'GET',
          headers: {'Accept-Language': 'en', 'Authorization': 'Bearer token'},
        );
        expect(key1, equals(key2));
      });

      test('produces identical keys regardless of query parameter order', () {
        final key1 = strategy.buildKey(
          'https://api/users',
          {'a': 1, 'b': 2, 'c': 3},
        );
        final key2 = strategy.buildKey(
          'https://api/users',
          {'c': 3, 'a': 1, 'b': 2},
        );
        expect(key1, equals(key2));
      });

      test('produces different keys for different URLs', () {
        final key1 = strategy.buildKey('https://api/users', null);
        final key2 = strategy.buildKey('https://api/posts', null);
        expect(key1, isNot(equals(key2)));
      });

      test('produces different keys for different methods', () {
        final key1 = strategy.buildKey(
          'https://api/users',
          null,
          method: 'GET',
        );
        final key2 = strategy.buildKey(
          'https://api/users',
          null,
          method: 'POST',
        );
        expect(key1, isNot(equals(key2)));
      });

      test('produces different keys for auth vs no auth', () {
        final key1 = strategy.buildKey('https://api/users', null);
        final key2 = strategy.buildKey(
          'https://api/users',
          null,
          headers: {'Authorization': 'Bearer token'},
        );
        expect(key1, isNot(equals(key2)));
      });

      test('produces different keys for different languages', () {
        final key1 = strategy.buildKey(
          'https://api/users',
          null,
          headers: {'Accept-Language': 'en'},
        );
        final key2 = strategy.buildKey(
          'https://api/users',
          null,
          headers: {'Accept-Language': 'fr'},
        );
        expect(key1, isNot(equals(key2)));
      });
    });

    group('edge cases', () {
      test('handles URL with existing query string', () {
        final key = strategy.buildKey(
          'https://api/users?existing=true',
          {'new': 'param'},
        );
        // Should append new query params
        expect(key, contains('https://api/users?existing=true'));
        expect(key, contains('new=param'));
      });

      test('handles empty headers map', () {
        final key = strategy.buildKey(
          'https://api/users',
          null,
          headers: {},
        );
        expect(key, contains('auth=0'));
        expect(key, isNot(contains('lang=')));
      });

      test('handles special characters in query values', () {
        final key = strategy.buildKey(
          'https://api/search',
          {'q': 'hello=world&foo'},
        );
        expect(key, contains('q=hello=world&foo'));
      });
    });
  });
}
