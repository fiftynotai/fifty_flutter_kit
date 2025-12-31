import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fifty_storage/fifty_storage.dart';

/// Mock for FlutterSecureStorage
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

/// Testable version of SecureTokenStorage that accepts injected storage
class TestableSecureTokenStorage implements TokenStorage {
  TestableSecureTokenStorage(this._secure);

  final FlutterSecureStorage _secure;

  static const String _kAccess = 'accessToken';
  static const String _kRefresh = 'refreshToken';

  String? _accessCache;
  String? _refreshCache;

  @override
  Future<void> initialize() async {
    _accessCache = await _secure.read(key: _kAccess);
    _refreshCache = await _secure.read(key: _kRefresh);
  }

  @override
  String? get readAccessTokenSync => _accessCache;

  @override
  String? get readRefreshTokenSync => _refreshCache;

  @override
  Future<void> writeAccessToken(String? value) async {
    _accessCache = value;
    if (value == null || value.isEmpty) {
      await _secure.delete(key: _kAccess);
    } else {
      await _secure.write(key: _kAccess, value: value);
    }
  }

  @override
  Future<void> writeRefreshToken(String? value) async {
    _refreshCache = value;
    if (value == null || value.isEmpty) {
      await _secure.delete(key: _kRefresh);
    } else {
      await _secure.write(key: _kRefresh, value: value);
    }
  }

  @override
  Future<void> clearTokens() async {
    _accessCache = null;
    _refreshCache = null;
    await _secure.delete(key: _kAccess);
    await _secure.delete(key: _kRefresh);
  }
}

void main() {
  group('SecureTokenStorage', () {
    late MockFlutterSecureStorage mockSecure;
    late TestableSecureTokenStorage storage;

    setUp(() {
      mockSecure = MockFlutterSecureStorage();
      storage = TestableSecureTokenStorage(mockSecure);
    });

    group('initialize', () {
      test('hydrates access and refresh token caches from secure storage',
          () async {
        // Arrange
        when(() => mockSecure.read(key: 'accessToken'))
            .thenAnswer((_) async => 'stored_access_token');
        when(() => mockSecure.read(key: 'refreshToken'))
            .thenAnswer((_) async => 'stored_refresh_token');

        // Act
        await storage.initialize();

        // Assert
        expect(storage.readAccessTokenSync, equals('stored_access_token'));
        expect(storage.readRefreshTokenSync, equals('stored_refresh_token'));
        verify(() => mockSecure.read(key: 'accessToken')).called(1);
        verify(() => mockSecure.read(key: 'refreshToken')).called(1);
      });

      test('handles null tokens from secure storage', () async {
        // Arrange
        when(() => mockSecure.read(key: 'accessToken'))
            .thenAnswer((_) async => null);
        when(() => mockSecure.read(key: 'refreshToken'))
            .thenAnswer((_) async => null);

        // Act
        await storage.initialize();

        // Assert
        expect(storage.readAccessTokenSync, isNull);
        expect(storage.readRefreshTokenSync, isNull);
      });
    });

    group('writeAccessToken', () {
      test('writes token to secure storage and updates cache', () async {
        // Arrange
        when(() => mockSecure.write(key: 'accessToken', value: 'new_token'))
            .thenAnswer((_) async {});

        // Act
        await storage.writeAccessToken('new_token');

        // Assert
        expect(storage.readAccessTokenSync, equals('new_token'));
        verify(() => mockSecure.write(key: 'accessToken', value: 'new_token'))
            .called(1);
      });

      test('deletes token when null is passed', () async {
        // Arrange
        when(() => mockSecure.delete(key: 'accessToken'))
            .thenAnswer((_) async {});

        // Act
        await storage.writeAccessToken(null);

        // Assert
        expect(storage.readAccessTokenSync, isNull);
        verify(() => mockSecure.delete(key: 'accessToken')).called(1);
      });

      test('deletes token when empty string is passed', () async {
        // Arrange
        when(() => mockSecure.delete(key: 'accessToken'))
            .thenAnswer((_) async {});

        // Act
        await storage.writeAccessToken('');

        // Assert
        expect(storage.readAccessTokenSync, equals(''));
        verify(() => mockSecure.delete(key: 'accessToken')).called(1);
      });
    });

    group('writeRefreshToken', () {
      test('writes token to secure storage and updates cache', () async {
        // Arrange
        when(() => mockSecure.write(key: 'refreshToken', value: 'new_refresh'))
            .thenAnswer((_) async {});

        // Act
        await storage.writeRefreshToken('new_refresh');

        // Assert
        expect(storage.readRefreshTokenSync, equals('new_refresh'));
        verify(() => mockSecure.write(key: 'refreshToken', value: 'new_refresh'))
            .called(1);
      });

      test('deletes token when null is passed', () async {
        // Arrange
        when(() => mockSecure.delete(key: 'refreshToken'))
            .thenAnswer((_) async {});

        // Act
        await storage.writeRefreshToken(null);

        // Assert
        expect(storage.readRefreshTokenSync, isNull);
        verify(() => mockSecure.delete(key: 'refreshToken')).called(1);
      });
    });

    group('clearTokens', () {
      test('clears both tokens from cache and secure storage', () async {
        // Arrange
        when(() => mockSecure.write(key: any(named: 'key'), value: any(named: 'value')))
            .thenAnswer((_) async {});
        when(() => mockSecure.delete(key: 'accessToken'))
            .thenAnswer((_) async {});
        when(() => mockSecure.delete(key: 'refreshToken'))
            .thenAnswer((_) async {});

        // Set initial values
        await storage.writeAccessToken('access');
        await storage.writeRefreshToken('refresh');

        // Act
        await storage.clearTokens();

        // Assert
        expect(storage.readAccessTokenSync, isNull);
        expect(storage.readRefreshTokenSync, isNull);
        verify(() => mockSecure.delete(key: 'accessToken')).called(1);
        verify(() => mockSecure.delete(key: 'refreshToken')).called(1);
      });
    });

    group('synchronous reads', () {
      test('readAccessTokenSync returns cached value without async call', () {
        // The synchronous getter should return the cached value
        // without making any async calls to secure storage
        expect(storage.readAccessTokenSync, isNull);
        verifyNever(() => mockSecure.read(key: any(named: 'key')));
      });

      test('readRefreshTokenSync returns cached value without async call', () {
        expect(storage.readRefreshTokenSync, isNull);
        verifyNever(() => mockSecure.read(key: any(named: 'key')));
      });
    });
  });

  group('TokenStorage contract', () {
    test('SecureTokenStorage implements TokenStorage', () {
      // Verify the singleton implements the contract
      expect(SecureTokenStorage.instance, isA<TokenStorage>());
    });
  });

  group('SecureTokenStorage singleton', () {
    test('instance returns singleton', () {
      final a = SecureTokenStorage.instance;
      final b = SecureTokenStorage.instance;
      expect(identical(a, b), isTrue);
    });
  });
}
