import 'dart:convert';
import 'dart:io';
import 'package:diagnostics_patient/core/exceptions/app_exceptions.dart';
import 'package:http/http.dart' as http;

/// API Client Service
/// Handles all HTTP requests with proper error handling and interceptors

class ApiClient {
  static const int _timeoutDuration = 30; // seconds
  static const String _contentType = 'application/json';

  final String baseUrl;
  final Map<String, String> _defaultHeaders;

  late http.Client _client;

  ApiClient({
    required this.baseUrl,
    Map<String, String>? defaultHeaders,
  }) : _defaultHeaders = defaultHeaders ?? {} {
    _client = http.Client();
    _setupDefaultHeaders();
  }

  void _setupDefaultHeaders() {
    _defaultHeaders['Content-Type'] = _contentType;
    _defaultHeaders['Accept'] = _contentType;
  }

  /// Add custom header
  void addHeader(String key, String value) {
    _defaultHeaders[key] = value;
  }

  /// Remove header
  void removeHeader(String key) {
    _defaultHeaders.remove(key);
  }

  /// Update authorization token
  void setAuthorizationToken(String token) {
    _defaultHeaders['Authorization'] = 'Bearer $token';
  }

  /// Clear authorization token
  void clearAuthorizationToken() {
    _defaultHeaders.remove('Authorization');
  }

  /// GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client
          .get(
            uri,
            headers: _mergeHeaders(headers),
          )
          .timeout(Duration(seconds: _timeoutDuration));
      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      throw _handleException(e);
    }
  }

  /// POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client
          .post(
            uri,
            headers: _mergeHeaders(headers),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(Duration(seconds: _timeoutDuration));
      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      throw _handleException(e);
    }
  }

  /// PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client
          .put(
            uri,
            headers: _mergeHeaders(headers),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(Duration(seconds: _timeoutDuration));
      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      throw _handleException(e);
    }
  }

  /// DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client
          .delete(
            uri,
            headers: _mergeHeaders(headers),
          )
          .timeout(Duration(seconds: _timeoutDuration));
      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      throw _handleException(e);
    }
  }

  /// PATCH request
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
  }) async {
    try {
      final uri = _buildUri(endpoint, queryParameters);
      final response = await _client
          .patch(
            uri,
            headers: _mergeHeaders(headers),
            body: body != null ? json.encode(body) : null,
          )
          .timeout(Duration(seconds: _timeoutDuration));
      return _handleResponse(response);
    } on SocketException {
      throw NoInternetException();
    } on TimeoutException {
      throw TimeoutException();
    } catch (e) {
      throw _handleException(e);
    }
  }

  /// Build URI with query parameters
  Uri _buildUri(String endpoint, Map<String, dynamic>? queryParameters) {
    final url = endpoint.startsWith('http') ? endpoint : '$baseUrl$endpoint';
    return Uri.parse(url).replace(queryParameters: queryParameters);
  }

  /// Merge headers with defaults
  Map<String, String> _mergeHeaders(Map<String, String>? customHeaders) {
    return {..._defaultHeaders, ...(customHeaders ?? {})};
  }

  /// Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final body = json.decode(response.body) as Map<String, dynamic>;

      switch (response.statusCode) {
        case 200:
        case 201:
        case 202:
          return body;
        case 204:
          return {'success': true};
        case 400:
          throw BadRequestException(
            message: body['message'] ?? 'Bad request',
            originalException: body,
          );
        case 401:
          throw UnauthorizedException(originalException: body);
        case 403:
          throw ForbiddenException(originalException: body);
        case 404:
          throw NotFoundException(originalException: body);
        case 500:
        case 502:
        case 503:
          throw ServerException(
            message: body['message'] ?? 'Server error',
            statusCode: response.statusCode,
            originalException: body,
          );
        default:
          throw ServerException(
            message: 'Unknown error',
            statusCode: response.statusCode,
            originalException: body,
          );
      }
    } catch (e) {
      if (e is AppException) rethrow;
      throw ParseException(
        message: 'Failed to parse response',
        originalException: e,
      );
    }
  }

  /// Handle exceptions
  Exception _handleException(dynamic e) {
    if (e is AppException) return e;
    if (e is SocketException) return NoInternetException();
    if (e is TimeoutException) return TimeoutException();
    
    return UnknownException(
      message: e.toString(),
      originalException: e,
    );
  }

  /// Dispose resources
  void dispose() {
    _client.close();
  }
}
