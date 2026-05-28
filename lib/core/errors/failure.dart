/// File: failure.dart
/// Purpose: Defines clean architecture Failure classes for presenting errors in domains/UI.
library core;

abstract class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => 'Failure: $message';
}

class ServerFailure extends Failure {
  const ServerFailure([String message = 'Server error. Please try again.']) : super(message);
}

class CacheFailure extends Failure {
  const CacheFailure([String message = 'Cache operation failed.']) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([String message = 'No internet connection.']) : super(message);
}

class AuthFailure extends Failure {
  const AuthFailure(String message) : super(message);
}
