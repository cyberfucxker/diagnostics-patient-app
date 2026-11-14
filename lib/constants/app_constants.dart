/// App Constants
/// All constant values used throughout the application

class AppConstants {
  // App Info
  static const String appName = 'Diagnostics Patient App';
  static const String appVersion = '1.0.0';
  static const String appVersionCode = '1';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String deviceTokenKey = 'device_token';
  static const String languageKey = 'language';
  static const String themeKey = 'theme';
  static const String isFirstTimeKey = 'is_first_time';
  static const String lastSyncKey = 'last_sync';

  // API Constants
  static const int apiTimeout = 30; // seconds
  static const int maxRetries = 3;
  static const int retryDelay = 2; // seconds

  // Pagination
  static const int pageSize = 20;
  static const int initialPage = 1;

  // Animation Durations
  static const Duration shortAnimDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimDuration = Duration(milliseconds: 300);
  static const Duration longAnimDuration = Duration(milliseconds: 500);

  // UI Dimensions
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;

  static const double defaultBorderRadius = 12.0;
  static const double smallBorderRadius = 8.0;
  static const double largeBorderRadius = 16.0;

  static const double defaultElevation = 4.0;
  static const double smallElevation = 2.0;
  static const double largeElevation = 8.0;

  // Text Sizes
  static const double headingLarge = 28.0;
  static const double headingMedium = 22.0;
  static const double headingSmall = 18.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;

  // Limits
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;
  static const int maxBioLength = 200;
  static const int maxFileSize = 5 * 1024 * 1024; // 5 MB

  // Error Messages
  static const String noInternetError = 'No internet connection. Please check your network.';
  static const String timeoutError = 'Request timeout. Please try again.';
  static const String serverError = 'Server error. Please try again later.';
  static const String unauthorizedError = 'Unauthorized. Please login again.';
  static const String forbiddenError = 'Access forbidden.';
  static const String notFoundError = 'Resource not found.';
  static const String unknownError = 'An unknown error occurred.';
  static const String validationError = 'Please check your input and try again.';

  // Success Messages
  static const String successMessage = 'Operation successful.';
  static const String loginSuccess = 'Login successful.';
  static const String logoutSuccess = 'Logged out successfully.';
  static const String updateSuccess = 'Updated successfully.';
  static const String deleteSuccess = 'Deleted successfully.';
  static const String createSuccess = 'Created successfully.';

  // Warning Messages
  static const String confirmDelete = 'Are you sure you want to delete this item?';
  static const String confirmLogout = 'Are you sure you want to logout?';
}

/// Validation Patterns
class ValidationPatterns {
  static const String emailPattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  
  static const String phonePattern = r'^[0-9]{10}$';
  
  static const String passwordPattern =
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';

  static const String urlPattern =
      r'^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/\/=]*)$';
}

/// Regex Utilities
class RegexUtils {
  static bool isValidEmail(String email) {
    return RegExp(ValidationPatterns.emailPattern).hasMatch(email);
  }

  static bool isValidPhone(String phone) {
    return RegExp(ValidationPatterns.phonePattern).hasMatch(phone);
  }

  static bool isValidPassword(String password) {
    return RegExp(ValidationPatterns.passwordPattern).hasMatch(password);
  }

  static bool isValidUrl(String url) {
    return RegExp(ValidationPatterns.urlPattern).hasMatch(url);
  }
}

/// App Status Codes
class StatusCodes {
  static const int success = 1;
  static const int error = 0;
  static const int notFound = 404;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int serverError = 500;
}
