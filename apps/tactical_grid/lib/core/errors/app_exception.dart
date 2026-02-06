/// App Exceptions
///
/// Custom exception types for error handling in Tactical Grid.
library;

/// Error key constants.
const String tkError = 'Error';
const String tkGameError = 'Game Error';
const String tkSomethingWentWrongMsg = 'Something went wrong. Please try again.';

/// Base class for all custom exceptions in the app.
class AppException implements Exception {
  /// The error message associated with the exception.
  final String message;

  /// A prefix to indicate the type or source of the exception.
  final String prefix;

  AppException([this.message = '', this.prefix = '']);

  @override
  String toString() => '$prefix: $message';
}

/// Exception for authentication-related issues.
class AuthException extends AppException {
  AuthException([String? message]) : super(message ?? '', 'Auth Error');
}

/// Exception for API-related issues.
class APIException extends AppException {
  APIException([String? message]) : super(message ?? '', 'API Error');
}

/// Exception for game logic issues.
class GameException extends AppException {
  GameException([String? message]) : super(message ?? '', tkGameError);
}
