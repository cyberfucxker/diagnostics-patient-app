import 'package:diagnostics_patient/config/app_config.dart';
/// API Configuration and Constants
/// Centralized API endpoints and configuration

const String baseUrl = AppConfig.apiBaseUrl;
const String pdfBaseUrl = "${AppConfig.storageBaseUrl}sample_report/";
const String imageUrl = "${AppConfig.storageBaseUrl}profile/";
const String sampleReportPath = "${AppConfig.storageBaseUrl}report/";
const String googleApiKey = AppConfig.googleMapsApiKey;

/// API Endpoints
class ApiEndpoints {
  // Auth endpoints
  static const String otpLogin = 'OTP_login';
  static const String otpVerify = 'OTP_verify';
  static const String register = 'register';
  
  // Category endpoints
  static const String getCategories = 'getcategory';
  static const String getCategoryDetail = 'category_detail';
  static const String searchCategory = 'serach_category';
  
  // Package endpoints
  static const String getPackages = 'get_package';
  static const String getPopularPackages = 'get_popular_package_list';
  static const String getPackageDetail = 'package_detail';
  
  // Test endpoints
  static const String getTests = 'get_test';
  static const String getTestDetail = 'test_detail';
  static const String getParameters = 'get_parameters';
  static const String getParameterDetail = 'parameter_detail';
  
  // Lab endpoints
  static const String getLabs = 'get_lab';
  static const String getLabsByCity = 'getUsersByCity';
  static const String getLabByCityName = 'getlab_bycityname';
  
  // Location endpoints
  static const String getCities = 'get_city';
  static const String getTimeSlots = 'slots';
  
  // Booking endpoints
  static const String bookNow = 'booknow_v2';
  static const String getBookDetails = 'book_detail';
  static const String getBookList = 'book_filter';
  static const String updateBooking = 'update_booking';
  
  // Cart endpoints
  static const String getCart = 'get_cart_v2';
  static const String updateCart = 'update_cart';
  
  // Payment endpoints
  static const String updatePayment = 'UpdatePayment';
  static const String validateCoupon = 'applycoupon_v2';
  static const String serverBookPayment = 'server_book_payment';
  
  // Profile endpoints
  static const String getProfileDetail = 'profile_detail';
  static const String editProfile = 'edit_profile';
  static const String getWallet = 'get_user_wallet';
  static const String getWalletSettings = 'getWalletSetting';
  
  // Member endpoints
  static const String getMemberList = 'get_member_list';
  static const String saveMember = 'save_member';
  static const String deleteMember = 'delete_member';
  static const String updateMember = 'update_member';
  
  // Address endpoints
  static const String getAddresses = 'getaddress';
  static const String saveAddress = 'saveaddress';
  static const String updateAddress = 'update_address';
  static const String deleteAddress = 'delete_address';
  
  // Home visit endpoints
  static const String addHomeVisit = 'homevisit_request';
  static const String getHomeVisits = 'homevisit_get';
  
  // Report endpoints
  static const String getPrescriptions = 'get_prescription';
  static const String uploadPrescription = 'upload_prescription';
  static const String getReports = 'get_reports';
  
  // Misc endpoints
  static const String getOffers = 'get_offer';
  static const String getBanners = 'banner';
  static const String search = 'search';
  static const String searchSuggestion = 'search_suggestion_v2';
  static const String requestCallback = 'request_callback';
  static const String addFeedback = 'add_feedback';
  static const String deleteAccount = 'delete_account';
  static const String currentDateTime = 'current_date_time';
}

/// API Configuration class
class ApiConfig {
  static const int requestTimeout = 30; // seconds
  static const int maxRetries = 3;
  static const Duration retryDelay = Duration(seconds: 2);
  
  /// Default headers for all requests
  static Map<String, String> getDefaultHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }
}

/// Default location constants
class DefaultLocation {
  static const String cityName = AppConfig.defaultCityName;
  static const String slug = AppConfig.defaultCitySlug;
  static const double latitude = AppConfig.defaultLat;
  static const double longitude = AppConfig.defaultLng;
}
