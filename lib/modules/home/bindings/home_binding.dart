import 'package:get/get.dart';
import 'package:diagnostics_patient/core/network/api_service.dart';
import 'package:diagnostics_patient/modules/home/controllers/home_controller.dart';
import 'package:diagnostics_patient/modules/home/repositories/home_repository.dart';

/// Home Module Binding
/// Registers all dependencies for home module
/// Initialize this binding when navigating to home screen

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // Repository
    Get.lazyPut<HomeRepository>(
      () => HomeRepository(
        apiService: Get.find<ApiService>(),
      ),
    );

    // Controller
    Get.lazyPut<HomeController>(
      () => HomeController(
        homeRepository: Get.find<HomeRepository>(),
      ),
    );
  }
}
