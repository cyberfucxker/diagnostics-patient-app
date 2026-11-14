import 'package:get/get.dart';

/// Base GetxController with common functionality
/// All feature controllers should extend this class

abstract class BaseController extends GetxController {
  /// Loading state
  final RxBool isLoading = false.obs;
  
  /// Error message
  final RxString? errorMessage = RxString('');

  /// Initialize loading state
  void startLoading() {
    isLoading.value = true;
    errorMessage?.value = '';
  }

  /// Stop loading and set success
  void stopLoading() {
    isLoading.value = false;
    errorMessage?.value = '';
  }

  /// Stop loading and set error
  void setError(String message) {
    isLoading.value = false;
    errorMessage?.value = message;
  }

  /// Clear error
  void clearError() {
    errorMessage?.value = '';
  }

  /// Lifecycle management
  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void onClose() {
    dispose();
    super.onClose();
  }

  /// Override in subclass for initialization logic
  void init() {}

  /// Override in subclass for cleanup logic
  void dispose() {}

  /// Retry logic helper
  Future<void> retry(Future<void> Function() operation) async {
    try {
      startLoading();
      await operation();
      stopLoading();
    } catch (e) {
      setError(e.toString());
    }
  }
}
