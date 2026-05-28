/// File: app_exception.dart
/// Purpose: Defines custom Exception classes for error handling in Zenup Health.
library core;

abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, [this.code]);

  @override
  String toString() => 'AppException: $message (code: $code)';
}

class ServerException extends AppException {
  ServerException([String message = 'A server error occurred', String? code])
      : super(message, code);
}

class CacheException extends AppException {
  CacheException([String message = 'A cache storage error occurred'])
      : super(message);
}

class NetworkException extends AppException {
  NetworkException([String message = 'No internet connection detected'])
      : super(message);
}

class AuthenticationException extends AppException {
  AuthenticationException([String message = 'Authentication failed', String? code])
      : super(message, code);
}
