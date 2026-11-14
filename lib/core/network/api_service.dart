import 'package:diagnostics_patient/core/network/api_client.dart';
import 'package:diagnostics_patient/config/api_config.dart';

/// API Service
/// Provides high-level API methods with automatic retry logic and error handling

class ApiService {
  late final ApiClient _apiClient;

  ApiService({ApiClient? apiClient}) {
    _apiClient = apiClient ??
        ApiClient(
          baseUrl: baseUrl,
          defaultHeaders: ApiConfig.getDefaultHeaders(),
        );
  }

  /// Get API client for direct access if needed
  ApiClient get apiClient => _apiClient;

  /// Generic GET request with retry logic
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    int maxRetries = 1,
  }) async {
    return _retryOperation(
      () => _apiClient.get(
        endpoint,
        queryParameters: queryParameters,
        headers: headers,
      ),
      maxRetries: maxRetries,
    );
  }

  /// Generic POST request with retry logic
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    int maxRetries = 1,
  }) async {
    return _retryOperation(
      () => _apiClient.post(
        endpoint,
        body: body,
        queryParameters: queryParameters,
        headers: headers,
      ),
      maxRetries: maxRetries,
    );
  }

  /// Generic PUT request with retry logic
  Future<Map<String, dynamic>> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    int maxRetries = 1,
  }) async {
    return _retryOperation(
      () => _apiClient.put(
        endpoint,
        body: body,
        queryParameters: queryParameters,
        headers: headers,
      ),
      maxRetries: maxRetries,
    );
  }

  /// Generic DELETE request with retry logic
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    int maxRetries = 1,
  }) async {
    return _retryOperation(
      () => _apiClient.delete(
        endpoint,
        queryParameters: queryParameters,
        headers: headers,
      ),
      maxRetries: maxRetries,
    );
  }

  /// Generic PATCH request with retry logic
  Future<Map<String, dynamic>> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    Map<String, String>? headers,
    int maxRetries = 1,
  }) async {
    return _retryOperation(
      () => _apiClient.patch(
        endpoint,
        body: body,
        queryParameters: queryParameters,
        headers: headers,
      ),
      maxRetries: maxRetries,
    );
  }

  /// Retry operation logic
  Future<Map<String, dynamic>> _retryOperation(
    Future<Map<String, dynamic>> Function() operation, {
    int maxRetries = 1,
  }) async {
    int attempt = 0;
    while (true) {
      try {
        return await operation();
      } catch (e) {
        attempt++;
        if (attempt >= maxRetries) {
          rethrow;
        }
        // Wait before retrying
        await Future.delayed(ApiConfig.retryDelay);
      }
    }
  }

  /// Set authorization token
  void setAuthToken(String token) {
    _apiClient.setAuthorizationToken(token);
  }

  /// Clear authorization token
  void clearAuthToken() {
    _apiClient.clearAuthorizationToken();
  }

  /// Set custom header
  void addHeader(String key, String value) {
    _apiClient.addHeader(key, value);
  }

  /// Remove header
  void removeHeader(String key) {
    _apiClient.removeHeader(key);
  }

  /// Dispose
  void dispose() {
    _apiClient.dispose();
  }
}
