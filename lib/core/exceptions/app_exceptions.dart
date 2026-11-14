/// Custom exception classes for the application
/// Implements proper error handling and classification

abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  AppException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() => message;
}

/// Network-related exceptions
class NetworkException extends AppException {
  NetworkException({
    required String message,
    String? code,
    dynamic originalException,
  }) : super(
    message: message,
    code: code,
    originalException: originalException,
  );
}

/// API request timeout exception
class TimeoutException extends NetworkException {
  TimeoutException({
    String message = 'Request timeout. Please try again.',
    String? code,
  }) : super(
    message: message,
    code: code ?? 'TIMEOUT',
  );
}

/// No internet connection exception
class NoInternetException extends NetworkException {
  NoInternetException({
    String message = 'No internet connection. Please check your network.',
    String? code,
  }) : super(
    message: message,
    code: code ?? 'NO_INTERNET',
  );
}

/// Server/API error exception
class ServerException extends NetworkException {
  final int? statusCode;

  ServerException({
    required String message,
    this.statusCode,
    String? code,
    dynamic originalException,
  }) : super(
    message: message,
    code: code,
    originalException: originalException,
  );
}

/// Unauthorized access exception (401)
class UnauthorizedException extends ServerException {
  UnauthorizedException({
    String message = 'Unauthorized. Please login again.',
    dynamic originalException,
  }) : super(
    message: message,
    statusCode: 401,
    code: 'UNAUTHORIZED',
    originalException: originalException,
  );
}

/// Forbidden access exception (403)
class ForbiddenException extends ServerException {
  ForbiddenException({
    String message = 'Access forbidden.',
    dynamic originalException,
  }) : super(
    message: message,
    statusCode: 403,
    code: 'FORBIDDEN',
    originalException: originalException,
  );
}

/// Not found exception (404)
class NotFoundException extends ServerException {
  NotFoundException({
    String message = 'Resource not found.',
    dynamic originalException,
  }) : super(
    message: message,
    statusCode: 404,
    code: 'NOT_FOUND',
    originalException: originalException,
  );
}

/// Bad request exception (400)
class BadRequestException extends ServerException {
  BadRequestException({
    required String message,
    dynamic originalException,
  }) : super(
    message: message,
    statusCode: 400,
    code: 'BAD_REQUEST',
    originalException: originalException,
  );
}

/// Generic parsing exception
class ParseException extends AppException {
  ParseException({
    required String message,
    dynamic originalException,
  }) : super(
    message: message,
    code: 'PARSE_ERROR',
    originalException: originalException,
  );
}

/// Cache exception
class CacheException extends AppException {
  CacheException({
    required String message,
    dynamic originalException,
  }) : super(
    message: message,
    code: 'CACHE_ERROR',
    originalException: originalException,
  );
}

/// Database exception
class DatabaseException extends AppException {
  DatabaseException({
    required String message,
    dynamic originalException,
  }) : super(
    message: message,
    code: 'DATABASE_ERROR',
    originalException: originalException,
  );
}

/// Unknown exception
class UnknownException extends AppException {
  UnknownException({
    required String message,
    dynamic originalException,
  }) : super(
    message: message,
    code: 'UNKNOWN_ERROR',
    originalException: originalException,
  );
}
