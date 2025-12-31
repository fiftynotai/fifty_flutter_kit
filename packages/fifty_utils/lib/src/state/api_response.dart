import 'package:flutter/foundation.dart';

/// **ApiStatus**
///
/// Lifecycle status for a single API request.
///
/// - [idle] - No request has been made yet
/// - [loading] - Request is in progress
/// - [success] - Request completed successfully
/// - [error] - Request failed with an error
enum ApiStatus {
  /// No request has been made yet
  idle,

  /// Request is in progress
  loading,

  /// Request completed successfully
  success,

  /// Request failed with an error
  error,
}

/// **ApiResponse**
///
/// Immutable request state container holding data or error and a status.
///
/// **Why**
/// - Prevent accidental mutations across widgets.
/// - Preserve original error type and stack for diagnostics.
///
/// **Key Features**
/// - `data`, `error`, `stackTrace`, and `status` are all final.
/// - Convenience factories for each lifecycle state.
/// - Readable property getters: `isLoading`, `hasData`, `hasError`.
///
/// **Example**
/// ```dart
/// final response = ApiResponse.success(user);
/// if (response.hasData) print(response.data!.name);
///
/// final loading = ApiResponse<User>.loading();
/// if (loading.isLoading) print('Loading...');
///
/// final error = ApiResponse<User>.error(Exception('Failed'));
/// if (error.hasError) print('Error: ${error.error}');
/// ```
class ApiResponse<E> {
  const ApiResponse._({
    this.data,
    this.error,
    this.stackTrace,
    required this.status,
  });

  /// The data returned from a successful request.
  final E? data;

  /// The error object if the request failed.
  final Object? error;

  /// The stack trace associated with the error.
  final StackTrace? stackTrace;

  /// The current status of the request.
  final ApiStatus status;

  /// Creates an idle state (no request made yet).
  factory ApiResponse.idle() => const ApiResponse._(status: ApiStatus.idle);

  /// Creates a loading state (request in progress).
  factory ApiResponse.loading() =>
      const ApiResponse._(status: ApiStatus.loading);

  /// Creates a success state with the given [data].
  factory ApiResponse.success(E data) =>
      ApiResponse._(data: data, status: ApiStatus.success);

  /// Creates an error state with the given [error] and optional [stackTrace].
  factory ApiResponse.error(Object error, [StackTrace? stackTrace]) =>
      ApiResponse._(error: error, stackTrace: stackTrace, status: ApiStatus.error);

  /// Returns true if the request is currently loading.
  bool get isLoading => status == ApiStatus.loading;

  /// Returns true if the response contains data.
  bool get hasData => data != null;

  /// Returns true if the response contains an error.
  bool get hasError => error != null;

  /// Returns true if the status is idle.
  bool get isIdle => status == ApiStatus.idle;

  /// Returns true if the status is success.
  bool get isSuccess => status == ApiStatus.success;

  /// Returns true if the status is error.
  bool get isError => status == ApiStatus.error;
}

/// **apiFetch**
///
/// Emit a short-lived stream of request states: `loading? -> success | error`.
/// Executes the provided function inside the try/catch, capturing sync throws.
///
/// **Parameters**
/// - [run]: `Future<E> Function()` that performs the async operation.
/// - [withLoading]: When true, emits a loading state first (default true).
/// - [reportToSentry]: When true, forwards caught errors to Sentry (default true).
///
/// **Returns**
/// - `Stream<ApiResponse<E>>`: A stream that completes after emitting the terminal state.
///
/// **Notes**
/// - Prefer to avoid double-reporting errors if your infra already captures them.
///   Set `reportToSentry: false` here when infra captures errors.
///
/// **Example**
/// ```dart
/// apiFetch(() => service.loadUser()).listen((state) {
///   if (state.isLoading) print('Loading...');
///   if (state.hasData) print('Got user: ${state.data}');
///   if (state.hasError) print('Error: ${state.error}');
/// });
/// ```
Stream<ApiResponse<E>> apiFetch<E>(
  Future<E> Function() run, {
  bool withLoading = true,
  bool reportToSentry = true,
}) async* {
  try {
    if (withLoading) yield ApiResponse<E>.loading();
    final data = await run();
    yield ApiResponse.success(data);
  } catch (e, st) {
    yield ApiResponse<E>.error(e, st);
    assert(() {
      debugPrint('Exception: $e');
      debugPrint('StackTrace: $st');
      return true;
    }());
    // TODO: Add your error tracking service here if reportToSentry is true
    // if (reportToSentry) {
    //   await ErrorTracker.captureException(e, stackTrace: st);
    // }
  }
}

/// **PaginationResponse**
///
/// Simple pagination envelope with total rows.
///
/// **Example**
/// ```dart
/// final response = PaginationResponse(users, 100);
/// print('Got ${response.data.length} of ${response.totalRows} users');
/// ```
class PaginationResponse<E> {
  /// Creates a pagination response with [data] and [totalRows].
  const PaginationResponse(this.data, this.totalRows);

  /// The paginated data.
  final E data;

  /// The total number of rows available.
  final int totalRows;
}
