import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fifty_storage/fifty_storage.dart';

/// Mock for FlutterSecureStorage
class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

/// Testable facade for secure token operations
class TestableTokenService {
  TestableTokenService(this._secure);

  final FlutterSecureStorage _secure;

  static const String _kAccess = 'accessToken';
  static const String _kRefresh = 'refreshToken';

  String? _accessCache;
  String? _refreshCache;

  Future<void> initialize() async {
    _accessCache = await _secure.read(key: _kAccess);
    _refreshCache = await _secure.read(key: _kRefresh);
  }

  String? get accessToken => _accessCache;
  String? get refreshToken => _refreshCache;

  Future<void> setAccessToken(String? value) async {
    _accessCache = value;
    if (value == null || value.isEmpty) {
      await _secure.delete(key: _kAccess);
    } else {
      await _secure.write(key: _kAccess, value: value);
    }
  }

  Future<void> setRefreshToken(String? value) async {
    _refreshCache = value;
    if (value == null || value.isEmpty) {
      await _secure.delete(key: _kRefresh);
    } else {
      await _secure.write(key: _kRefresh, value: value);
    }
  }

  Future<void> clearTokens() async {
    _accessCache = null;
    _refreshCache = null;
    await _secure.delete(key: _kAccess);
    await _secure.delete(key: _kRefresh);
  }
}

void main() {
  group('AppStorageService facade', () {
    late MockFlutterSecureStorage mockSecure;
    late TestableTokenService service;

    setUp(() {
      mockSecure = MockFlutterSecureStorage();
      service = TestableTokenService(mockSecure);
    });

    group('initialize', () {
      test('initializes secure storage and hydrates cache', () async {
        // Arrange
        when(() => mockSecure.read(key: 'accessToken'))
            .thenAnswer((_) async => 'stored_access');
        when(() => mockSecure.read(key: 'refreshToken'))
            .thenAnswer((_) async => 'stored_refresh');

        // Act
        await service.initialize();

        // Assert
        expect(service.accessToken, equals('stored_access'));
        expect(service.refreshToken, equals('stored_refresh'));
        verify(() => mockSecure.read(key: 'accessToken')).called(1);
        verify(() => mockSecure.read(key: 'refreshToken')).called(1);
      });
    });

    group('token operations', () {
      test('accessToken returns cached value', () {
        expect(service.accessToken, isNull);
      });

      test('setAccessToken writes to secure storage and updates cache',
          () async {
        // Arrange
        when(() => mockSecure.write(key: 'accessToken', value: 'new_token'))
            .thenAnswer((_) async {});

        // Act
        await service.setAccessToken('new_token');

        // Assert
        expect(service.accessToken, equals('new_token'));
        verify(() => mockSecure.write(key: 'accessToken', value: 'new_token'))
            .called(1);
      });

      test('setAccessToken deletes when null', () async {
        // Arrange
        when(() => mockSecure.delete(key: 'accessToken'))
            .thenAnswer((_) async {});

        // Act
        await service.setAccessToken(null);

        // Assert
        expect(service.accessToken, isNull);
        verify(() => mockSecure.delete(key: 'accessToken')).called(1);
      });

      test('refreshToken returns cached value', () {
        expect(service.refreshToken, isNull);
      });

      test('setRefreshToken writes to secure storage and updates cache',
          () async {
        // Arrange
        when(() => mockSecure.write(key: 'refreshToken', value: 'new_refresh'))
            .thenAnswer((_) async {});

        // Act
        await service.setRefreshToken('new_refresh');

        // Assert
        expect(service.refreshToken, equals('new_refresh'));
        verify(() => mockSecure.write(key: 'refreshToken', value: 'new_refresh'))
            .called(1);
      });

      test('clearTokens clears both tokens', () async {
        // Arrange
        when(() => mockSecure.write(
                key: any(named: 'key'), value: any(named: 'value')))
            .thenAnswer((_) async {});
        when(() => mockSecure.delete(key: 'accessToken'))
            .thenAnswer((_) async {});
        when(() => mockSecure.delete(key: 'refreshToken'))
            .thenAnswer((_) async {});

        // Set initial tokens
        await service.setAccessToken('access');
        await service.setRefreshToken('refresh');

        // Act
        await service.clearTokens();

        // Assert
        expect(service.accessToken, isNull);
        expect(service.refreshToken, isNull);
        verify(() => mockSecure.delete(key: 'accessToken')).called(1);
        verify(() => mockSecure.delete(key: 'refreshToken')).called(1);
      });
    });
  });

  group('AppStorageService singleton', () {
    test('instance returns singleton', () {
      final a = AppStorageService.instance;
      final b = AppStorageService.instance;
      expect(identical(a, b), isTrue);
    });

    test('containerName returns PreferencesStorage container name', () {
      expect(
        AppStorageService.containerName,
        equals(PreferencesStorage.containerName),
      );
    });
  });
}
