import 'package:diagnostics_patient/config/app_config.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/core/base/base_controller.dart';
import 'package:diagnostics_patient/core/base/dialog_service.dart';
import 'package:diagnostics_patient/core/exceptions/app_exceptions.dart';
import 'package:diagnostics_patient/modules/home/repositories/home_repository.dart';

/// Home Controller
/// Demonstrates proper GetX controller implementation
/// Using reactive Rx variables and Obx for UI updates
/// Proper error handling with DialogService

class HomeController extends BaseController {
  final HomeRepository homeRepository;
  final DialogService _dialogService = Get.find<DialogService>();

  /// Reactive state variables
  final RxList<dynamic> categories = <dynamic>[].obs;
  final RxList<dynamic> packages = <dynamic>[].obs;
  final RxList<dynamic> banners = <dynamic>[].obs;
  final RxList<dynamic> offers = <dynamic>[].obs;
  final RxList<dynamic> labs = <dynamic>[].obs;
  final RxList<dynamic> cities = <dynamic>[].obs;

  /// Loading states for specific operations
  final RxBool isCategoriesLoading = false.obs;
  final RxBool isPackagesLoading = false.obs;
  final RxBool isBannersLoading = false.obs;
  final RxBool isLabsLoading = false.obs;

  /// Current selected city
  final RxString selectedCity = AppConfig.defaultCityName.obs;

  HomeController({required this.homeRepository});

  /// Initialize controller
  @override
  void init() {
    super.init();
    _loadInitialData();
  }

  /// Load all initial data
  Future<void> _loadInitialData() async {
    try {
      startLoading();
      
      // Load all data in parallel
      await Future.wait([
        _fetchCategories(),
        _fetchPackages(),
        _fetchBanners(),
        _fetchOffers(),
        _fetchCities(),
      ]);
      
      stopLoading();
    } catch (e) {
      setError(e.toString());
      _dialogService.showError(
        title: 'Error',
        message: errorMessage?.value ?? 'Failed to load data',
      );
    }
  }

  /// Fetch categories
  Future<void> _fetchCategories() async {
    try {
      isCategoriesLoading.value = true;
      final result = await homeRepository.getCategories();
      categories.value = result;
      isCategoriesLoading.value = false;
    } on AppException catch (e) {
      isCategoriesLoading.value = false;
      rethrow;
    }
  }

  /// Fetch packages
  Future<void> _fetchPackages() async {
    try {
      isPackagesLoading.value = true;
      final result = await homeRepository.getPackages();
      packages.value = result;
      isPackagesLoading.value = false;
    } on AppException catch (e) {
      isPackagesLoading.value = false;
      rethrow;
    }
  }

  /// Fetch banners
  Future<void> _fetchBanners() async {
    try {
      isBannersLoading.value = true;
      final result = await homeRepository.getBanners();
      banners.value = result;
      isBannersLoading.value = false;
    } on AppException catch (e) {
      isBannersLoading.value = false;
      rethrow;
    }
  }

  /// Fetch offers
  Future<void> _fetchOffers() async {
    try {
      final result = await homeRepository.getOffers();
      offers.value = result;
    } on AppException catch (e) {
      rethrow;
    }
  }

  /// Fetch cities
  Future<void> _fetchCities() async {
    try {
      final result = await homeRepository.getCities();
      cities.value = result;
    } on AppException catch (e) {
      rethrow;
    }
  }

  /// Fetch labs for selected city
  Future<void> fetchLabsByCity(String cityName) async {
    try {
      isLabsLoading.value = true;
      selectedCity.value = cityName;
      
      final result = await homeRepository.getLabsByCity(cityName);
      labs.value = result;
      
      isLabsLoading.value = false;
    } on NoInternetException {
      isLabsLoading.value = false;
      _dialogService.showError(
        title: 'No Internet',
        message: 'Please check your internet connection',
      );
    } on TimeoutException {
      isLabsLoading.value = false;
      _dialogService.showError(
        title: 'Timeout',
        message: 'Request timeout. Please try again',
      );
    } on ServerException catch (e) {
      isLabsLoading.value = false;
      _dialogService.showError(
        title: 'Error',
        message: e.message,
      );
    } catch (e) {
      isLabsLoading.value = false;
      _dialogService.showError(
        title: 'Error',
        message: 'Failed to load labs',
      );
    }
  }

  /// Refresh home data
  Future<void> refreshHome() async {
    try {
      categories.clear();
      packages.clear();
      banners.clear();
      await _loadInitialData();
      _dialogService.showSuccess(
        title: 'Refreshed',
        message: 'Data updated successfully',
      );
    } catch (e) {
      _dialogService.showError(
        title: 'Error',
        message: 'Failed to refresh data',
      );
    }
  }

  /// Cleanup
  @override
  void dispose() {
    categories.close();
    packages.close();
    banners.close();
    offers.close();
    labs.close();
    cities.close();
    isCategoriesLoading.close();
    isPackagesLoading.close();
    isBannersLoading.close();
    isLabsLoading.close();
    selectedCity.close();
    super.dispose();
  }
}
