import 'package:fifty_cache/fifty_cache.dart';
import 'package:test/test.dart';

void main() {
  group('SimpleTimeToLiveCachePolicy', () {
    group('canRead', () {
      test('returns true for GET request without force refresh', () {
        final policy = SimpleTimeToLiveCachePolicy();
        expect(
          policy.canRead('GET', 'https://api/users', null),
          isTrue,
        );
      });

      test('returns false when forceRefresh is true', () {
        final policy = SimpleTimeToLiveCachePolicy();
        expect(
          policy.canRead('GET', 'https://api/users', null, forceRefresh: true),
          isFalse,
        );
      });

      test('returns false for POST when cacheGetRequestsOnly is true', () {
        final policy = SimpleTimeToLiveCachePolicy(cacheGetRequestsOnly: true);
        expect(
          policy.canRead('POST', 'https://api/users', null),
          isFalse,
        );
      });

      test('returns true for POST when cacheGetRequestsOnly is false', () {
        final policy = SimpleTimeToLiveCachePolicy(cacheGetRequestsOnly: false);
        expect(
          policy.canRead('POST', 'https://api/users', null),
          isTrue,
        );
      });

      test('handles lowercase method', () {
        final policy = SimpleTimeToLiveCachePolicy();
        expect(
          policy.canRead('get', 'https://api/users', null),
          isTrue,
        );
      });

      test('handles mixed case method', () {
        final policy = SimpleTimeToLiveCachePolicy();
        expect(
          policy.canRead('Get', 'https://api/users', null),
          isTrue,
        );
      });
    });

    group('canWrite', () {
      test('returns true for GET with 200 status', () {
        final policy = SimpleTimeToLiveCachePolicy();
        expect(
          policy.canWrite('GET', 'https://api/users', 200),
          isTrue,
        );
      });

      test('returns true for GET with 201 status', () {
        final policy = SimpleTimeToLiveCachePolicy();
        expect(
          policy.canWrite('GET', 'https://api/users', 201),
          isTrue,
        );
      });

      test('returns true for GET with 299 status', () {
        final policy = SimpleTimeToLiveCachePolicy();
        expect(
          policy.canWrite('GET', 'https://api/users', 299),
          isTrue,
        );
      });

      test('returns false for GET with 199 status', () {
        final policy = SimpleTimeToLiveCachePolicy();
        expect(
          policy.canWrite('GET', 'https://api/users', 199),
          isFalse,
        );
      });

      test('returns false for GET with 300 status', () {
        final policy = SimpleTimeToLiveCachePolicy();
        expect(
          policy.canWrite('GET', 'https://api/users', 300),
          isFalse,
        );
      });

      test('returns false for GET with 404 status', () {
        final policy = SimpleTimeToLiveCachePolicy();
        expect(
          policy.canWrite('GET', 'https://api/users', 404),
          isFalse,
        );
      });

      test('returns false for GET with 500 status', () {
        final policy = SimpleTimeToLiveCachePolicy();
        expect(
          policy.canWrite('GET', 'https://api/users', 500),
          isFalse,
        );
      });

      test('returns false for GET with null status', () {
        final policy = SimpleTimeToLiveCachePolicy();
        expect(
          policy.canWrite('GET', 'https://api/users', null),
          isFalse,
        );
      });

      test('returns false for POST when cacheGetRequestsOnly is true', () {
        final policy = SimpleTimeToLiveCachePolicy(cacheGetRequestsOnly: true);
        expect(
          policy.canWrite('POST', 'https://api/users', 200),
          isFalse,
        );
      });

      test('returns true for POST when cacheGetRequestsOnly is false', () {
        final policy = SimpleTimeToLiveCachePolicy(cacheGetRequestsOnly: false);
        expect(
          policy.canWrite('POST', 'https://api/users', 200),
          isTrue,
        );
      });
    });

    group('timeToLiveFor', () {
      test('returns default TTL when not specified', () {
        final policy = SimpleTimeToLiveCachePolicy();
        expect(
          policy.timeToLiveFor('GET', 'https://api/users', 200),
          equals(const Duration(days: 365)),
        );
      });

      test('returns custom TTL when specified', () {
        final policy = SimpleTimeToLiveCachePolicy(
          timeToLive: const Duration(hours: 6),
        );
        expect(
          policy.timeToLiveFor('GET', 'https://api/users', 200),
          equals(const Duration(hours: 6)),
        );
      });

      test('returns same TTL regardless of method, url, or status', () {
        final policy = SimpleTimeToLiveCachePolicy(
          timeToLive: const Duration(minutes: 30),
        );

        expect(
          policy.timeToLiveFor('GET', 'https://api/users', 200),
          equals(const Duration(minutes: 30)),
        );
        expect(
          policy.timeToLiveFor('POST', 'https://api/data', 201),
          equals(const Duration(minutes: 30)),
        );
        expect(
          policy.timeToLiveFor('PUT', 'https://api/update', 204),
          equals(const Duration(minutes: 30)),
        );
      });
    });
  });
}
