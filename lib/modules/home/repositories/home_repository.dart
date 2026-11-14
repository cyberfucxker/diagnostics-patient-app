import 'package:diagnostics_patient/config/api_config.dart';
import 'package:diagnostics_patient/core/exceptions/app_exceptions.dart';
import 'package:diagnostics_patient/core/network/api_service.dart';

/// Home Repository
/// Handles all API calls and data operations for home module
/// Demonstrates proper repository pattern with GetX

class HomeRepository {
  final ApiService _apiService;

  HomeRepository({required ApiService apiService}) : _apiService = apiService;

  /// Get categories
  Future<List<dynamic>> getCategories() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getCategories);
      
      if (response['status'] == 1) {
        return response['data'] as List<dynamic>? ?? [];
      } else {
        throw ServerException(
          message: response['message'] ?? 'Failed to load categories',
          statusCode: response['status'],
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        message: 'Error fetching categories: ${e.toString()}',
        originalException: e,
      );
    }
  }

  /// Get packages/popular packages
  Future<List<dynamic>> getPackages() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getPackages);
      
      if (response['status'] == 1) {
        return response['data'] as List<dynamic>? ?? [];
      } else {
        throw ServerException(
          message: response['message'] ?? 'Failed to load packages',
          statusCode: response['status'],
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        message: 'Error fetching packages: ${e.toString()}',
        originalException: e,
      );
    }
  }

  /// Get banners
  Future<List<dynamic>> getBanners() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getBanners);
      
      if (response['status'] == 1) {
        return response['data'] as List<dynamic>? ?? [];
      } else {
        throw ServerException(
          message: response['message'] ?? 'Failed to load banners',
          statusCode: response['status'],
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        message: 'Error fetching banners: ${e.toString()}',
        originalException: e,
      );
    }
  }

  /// Get offers
  Future<List<dynamic>> getOffers() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getOffers);
      
      if (response['status'] == 1) {
        return response['data'] as List<dynamic>? ?? [];
      } else {
        throw ServerException(
          message: response['message'] ?? 'Failed to load offers',
          statusCode: response['status'],
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        message: 'Error fetching offers: ${e.toString()}',
        originalException: e,
      );
    }
  }

  /// Get labs by city name
  Future<List<dynamic>> getLabsByCity(String cityName) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.getLabByCityName,
        body: {'cityname': cityName},
      );
      
      if (response['status'] == 1) {
        return response['data'] as List<dynamic>? ?? [];
      } else {
        throw ServerException(
          message: response['message'] ?? 'Failed to load labs',
          statusCode: response['status'],
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        message: 'Error fetching labs: ${e.toString()}',
        originalException: e,
      );
    }
  }

  /// Get cities
  Future<List<dynamic>> getCities() async {
    try {
      final response = await _apiService.get(ApiEndpoints.getCities);
      
      if (response['status'] == 1) {
        return response['data'] as List<dynamic>? ?? [];
      } else {
        throw ServerException(
          message: response['message'] ?? 'Failed to load cities',
          statusCode: response['status'],
        );
      }
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(
        message: 'Error fetching cities: ${e.toString()}',
        originalException: e,
      );
    }
  }
}
