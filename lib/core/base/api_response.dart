/// Generic API Response wrapper
/// Standardizes API responses across the application

class ApiResponse<T> {
  final bool success;
  final int? statusCode;
  final String? message;
  final T? data;
  final Map<String, dynamic>? errors;

  ApiResponse({
    required this.success,
    this.statusCode,
    this.message,
    this.data,
    this.errors,
  });

  factory ApiResponse.success({
    required T data,
    String? message,
    int statusCode = 200,
  }) {
    return ApiResponse(
      success: true,
      statusCode: statusCode,
      message: message ?? 'Success',
      data: data,
    );
  }

  factory ApiResponse.error({
    required String message,
    int? statusCode,
    Map<String, dynamic>? errors,
  }) {
    return ApiResponse(
      success: false,
      statusCode: statusCode,
      message: message,
      errors: errors,
    );
  }

  bool get isSuccess => success;
  bool get isError => !success;
}

/// Loading state wrapper
/// Loading state wrapper
class LoadingState<T> {
  final bool isLoading;
  final T? data;
  final String? errorMessage; // ✅ error → errorMessage

  const LoadingState({
    this.isLoading = false,
    this.data,
    this.errorMessage, // ✅
  });

  LoadingState<T> loading() => LoadingState(isLoading: true, data: data);

  LoadingState<T> success(T data) => LoadingState(isLoading: false, data: data);

  LoadingState<T> failure(String message) =>  // ✅ error() → failure()
  LoadingState(isLoading: false, errorMessage: message);

  bool get isError => errorMessage != null;  // ✅ helper
  bool get hasData => data != null;          // ✅ helper
}
