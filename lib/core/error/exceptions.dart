/// Base class for all exceptions
class AppException implements Exception {
  final String message;

  AppException(this.message);

  @override
  String toString() => message;
}

/// Server exception
class ServerException extends AppException {
  ServerException(super.message);
}

/// Cache exception
class CacheException extends AppException {
  CacheException(super.message);
}

/// Network exception
class NetworkException extends AppException {
  NetworkException(super.message);
}

/// Validation exception
class ValidationException extends AppException {
  ValidationException(super.message);
}

/// Authentication exception
class AuthException extends AppException {
  AuthException(super.message);
}

/// Unauthorized exception
class UnauthorizedException extends AppException {
  UnauthorizedException(super.message);
}
