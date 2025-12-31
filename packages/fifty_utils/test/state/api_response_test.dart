import 'package:flutter_test/flutter_test.dart';
import 'package:fifty_utils/fifty_utils.dart';

void main() {
  group('ApiStatus', () {
    test('has correct enum values', () {
      expect(ApiStatus.values.length, equals(4));
      expect(ApiStatus.values, contains(ApiStatus.idle));
      expect(ApiStatus.values, contains(ApiStatus.loading));
      expect(ApiStatus.values, contains(ApiStatus.success));
      expect(ApiStatus.values, contains(ApiStatus.error));
    });
  });

  group('ApiResponse', () {
    group('factories', () {
      test('idle creates idle state', () {
        final response = ApiResponse<String>.idle();
        expect(response.status, equals(ApiStatus.idle));
        expect(response.data, isNull);
        expect(response.error, isNull);
        expect(response.stackTrace, isNull);
      });

      test('loading creates loading state', () {
        final response = ApiResponse<String>.loading();
        expect(response.status, equals(ApiStatus.loading));
        expect(response.data, isNull);
        expect(response.error, isNull);
      });

      test('success creates success state with data', () {
        final response = ApiResponse.success('test data');
        expect(response.status, equals(ApiStatus.success));
        expect(response.data, equals('test data'));
        expect(response.error, isNull);
      });

      test('error creates error state with error object', () {
        final error = Exception('test error');
        final response = ApiResponse<String>.error(error);
        expect(response.status, equals(ApiStatus.error));
        expect(response.error, equals(error));
        expect(response.data, isNull);
      });

      test('error creates error state with stack trace', () {
        final error = Exception('test error');
        final stackTrace = StackTrace.current;
        final response = ApiResponse<String>.error(error, stackTrace);
        expect(response.status, equals(ApiStatus.error));
        expect(response.error, equals(error));
        expect(response.stackTrace, equals(stackTrace));
      });
    });

    group('status checks', () {
      test('isLoading returns true only for loading state', () {
        expect(ApiResponse<String>.idle().isLoading, isFalse);
        expect(ApiResponse<String>.loading().isLoading, isTrue);
        expect(ApiResponse.success('data').isLoading, isFalse);
        expect(ApiResponse<String>.error(Exception()).isLoading, isFalse);
      });

      test('isIdle returns true only for idle state', () {
        expect(ApiResponse<String>.idle().isIdle, isTrue);
        expect(ApiResponse<String>.loading().isIdle, isFalse);
        expect(ApiResponse.success('data').isIdle, isFalse);
        expect(ApiResponse<String>.error(Exception()).isIdle, isFalse);
      });

      test('isSuccess returns true only for success state', () {
        expect(ApiResponse<String>.idle().isSuccess, isFalse);
        expect(ApiResponse<String>.loading().isSuccess, isFalse);
        expect(ApiResponse.success('data').isSuccess, isTrue);
        expect(ApiResponse<String>.error(Exception()).isSuccess, isFalse);
      });

      test('isError returns true only for error state', () {
        expect(ApiResponse<String>.idle().isError, isFalse);
        expect(ApiResponse<String>.loading().isError, isFalse);
        expect(ApiResponse.success('data').isError, isFalse);
        expect(ApiResponse<String>.error(Exception()).isError, isTrue);
      });
    });

    group('hasData', () {
      test('returns true when data is present', () {
        expect(ApiResponse.success('data').hasData, isTrue);
      });

      test('returns false when data is null', () {
        expect(ApiResponse<String>.idle().hasData, isFalse);
        expect(ApiResponse<String>.loading().hasData, isFalse);
        expect(ApiResponse<String>.error(Exception()).hasData, isFalse);
      });
    });

    group('hasError', () {
      test('returns true when error is present', () {
        expect(ApiResponse<String>.error(Exception()).hasError, isTrue);
      });

      test('returns false when error is null', () {
        expect(ApiResponse<String>.idle().hasError, isFalse);
        expect(ApiResponse<String>.loading().hasError, isFalse);
        expect(ApiResponse.success('data').hasError, isFalse);
      });
    });

    group('generic types', () {
      test('works with complex types', () {
        final listResponse = ApiResponse.success([1, 2, 3]);
        expect(listResponse.data, equals([1, 2, 3]));

        final mapResponse = ApiResponse.success({'key': 'value'});
        expect(mapResponse.data, equals({'key': 'value'}));
      });

      test('works with custom classes', () {
        final user = _TestUser('John', 30);
        final response = ApiResponse.success(user);
        expect(response.data?.name, equals('John'));
        expect(response.data?.age, equals(30));
      });
    });
  });

  group('apiFetch', () {
    test('emits loading then success', () async {
      final states = <ApiResponse<String>>[];

      await for (final state in apiFetch(() async => 'result')) {
        states.add(state);
      }

      expect(states.length, equals(2));
      expect(states[0].isLoading, isTrue);
      expect(states[1].isSuccess, isTrue);
      expect(states[1].data, equals('result'));
    });

    test('emits loading then error on exception', () async {
      final states = <ApiResponse<String>>[];

      await for (final state in apiFetch<String>(() async {
        throw Exception('test error');
      })) {
        states.add(state);
      }

      expect(states.length, equals(2));
      expect(states[0].isLoading, isTrue);
      expect(states[1].isError, isTrue);
      expect(states[1].error, isA<Exception>());
      expect(states[1].stackTrace, isNotNull);
    });

    test('skips loading when withLoading is false', () async {
      final states = <ApiResponse<String>>[];

      await for (final state in apiFetch(
        () async => 'result',
        withLoading: false,
      )) {
        states.add(state);
      }

      expect(states.length, equals(1));
      expect(states[0].isSuccess, isTrue);
      expect(states[0].data, equals('result'));
    });

    test('handles sync exceptions', () async {
      final states = <ApiResponse<String>>[];

      await for (final state in apiFetch<String>(() {
        throw Exception('sync error');
      })) {
        states.add(state);
      }

      expect(states.length, equals(2));
      expect(states[1].isError, isTrue);
    });

    test('works with complex return types', () async {
      final states = <ApiResponse<List<int>>>[];

      await for (final state in apiFetch(() async => [1, 2, 3])) {
        states.add(state);
      }

      expect(states[1].data, equals([1, 2, 3]));
    });
  });

  group('PaginationResponse', () {
    test('creates pagination response with data and total', () {
      const response = PaginationResponse([1, 2, 3], 100);
      expect(response.data, equals([1, 2, 3]));
      expect(response.totalRows, equals(100));
    });

    test('works with complex data types', () {
      final users = [_TestUser('John', 30), _TestUser('Jane', 25)];
      final response = PaginationResponse(users, 50);
      expect(response.data.length, equals(2));
      expect(response.totalRows, equals(50));
    });

    test('is const constructible', () {
      const response = PaginationResponse('data', 10);
      expect(response.data, equals('data'));
      expect(response.totalRows, equals(10));
    });
  });
}

class _TestUser {
  final String name;
  final int age;

  _TestUser(this.name, this.age);
}
