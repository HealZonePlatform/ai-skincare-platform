/// Base exception class for all app exceptions
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;

  AppException(this.message, [this.statusCode]);

  @override
  String toString() => message;
}

/// Exception for API-related errors (4xx, 5xx)
class ApiException extends AppException {
  ApiException({
    required String message,
    int? statusCode,
  }) : super(message, statusCode);

  bool get isUnauthorized => statusCode == 401;
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isServerError => statusCode != null && statusCode! >= 500;
}

/// Exception for network connectivity issues
class NetworkException extends AppException {
  NetworkException(String message) : super(message);
}

/// Exception for unknown/unexpected errors
class UnknownException extends AppException {
  UnknownException(String message) : super(message);
}

/// Exception for validation errors
class ValidationException extends AppException {
  final Map<String, List<String>>? errors;

  ValidationException({
    required String message,
    this.errors,
  }) : super(message);
}
