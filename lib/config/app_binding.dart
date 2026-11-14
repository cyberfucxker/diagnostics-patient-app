import 'package:get/get.dart';
import 'package:diagnostics_patient/core/base/dialog_service.dart';
import 'package:diagnostics_patient/core/network/api_service.dart';
import 'package:diagnostics_patient/widgets/custom_loaders.dart';

/// Global App Binding
/// Registers all services and dependencies used across the application
/// Initialize this in main() before creating GetMaterialApp

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Core Services
    Get.put<ApiService>(ApiService(), permanent: true);
    Get.put<DialogService>(DialogService(), permanent: true);
    Get.put<LoaderService>(LoaderService(), permanent: true);

    // Add more global services here as needed
  }
}
