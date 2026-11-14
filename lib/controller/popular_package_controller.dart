import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/popularPackageModel.dart';
import 'package:diagnostics_patient/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:diagnostics_patient/utils/colors.dart';

class PopularPackageController extends GetxController {
  PopularPackageModel? popularPackageModel;
  bool isLoading = true;
  List<PopularPackageModelList>? popularPackageModelList = [];
  @override
  void onInit() {
    super.onInit();
    getPopularPackage();
    update();
  }

  Future getPopularPackage({String? cityName, double? lat, double? lng}) async {
    log("--- getPopularPackage API Call ---");
    // update();
    try {
      isLoading = true;
      update();

      /* Map<String, String> queryParams = {};
      if (cityName != null) queryParams['city'] = cityName;
      if (lat != null) queryParams['lat'] = lat.toString();
      if (lng != null) queryParams['lng'] = lng.toString(); */
      Map<String, String> queryParams = {
        'city': cityName ?? defaultCityName,
        'lat': (lat ?? defaultLat).toString(),
        'lng': (lng ?? defaultLng).toString(),
      };

      final uri = Uri.parse(baseUrl + getpopularpackage)
          .replace(queryParameters: queryParams);

      log("--- API getPopularPackage :: $uri");
      final response = await http.get(uri);

      // final response = await http.get(Uri.parse(baseUrl + getpopularpackage));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          popularPackageModel = PopularPackageModel.fromJson(jsonResponse);
          popularPackageModelList = popularPackageModel!.data;
          isLoading = false;
          update();
        } else {
          isLoading = false;
          Get.snackbar(
            "Error",
            "data not found",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: redColor,
          );
          update();
        }
      }
    } catch (e) {
      isLoading = false;
      update();
      print('Exception: popular_package_controller.dart - getCategory()' +
          e.toString());
    }
  }
}
