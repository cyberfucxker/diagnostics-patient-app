import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/banner_model.dart';
import 'package:diagnostics_patient/Models/categoryModel.dart';
import 'package:diagnostics_patient/Models/offer_model.dart';
import 'package:diagnostics_patient/Models/suggestion_model.dart';
import 'package:diagnostics_patient/Models/test_model.dart';
import 'package:diagnostics_patient/Screens/View/HomeScreens/package_details_screen.dart';
import 'package:diagnostics_patient/Screens/View/HomeScreens/parameter_details_screen.dart';
import 'package:diagnostics_patient/Screens/test_detail_screen.dart';
import 'package:diagnostics_patient/controller/test_detail_controller.dart';
import 'package:diagnostics_patient/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:diagnostics_patient/utils/colors.dart';

class CategoryController extends GetxController {
  CategoryModel? categoryModel;
  OfferModel? offerModel;
  bool isLoading = true;
  BannerModel? bannerModel;
  SugesstionModel? suggetionModel;
  List<CategoryModelList>? categoryModelList = [];
  List<OfferListModel>? offerModelList = [];
  // BannerList? bannerModelList;
  List<String> bannerModelList = [];
  List<String> seggestionList = [];
  TextEditingController cSearch = TextEditingController();

  void onInit() {
    super.onInit();
    init();
  }

  init() async {
    getBannerList();
    getOffer();
    getSuggestionList();
  }

/*   Future getCategory(bool isNeedAll,
      {String? cityName, double? lat, double? lng}) async {
    log("--- getCategory API Call ---");
    // update();
    try {
      isLoading = true;
      update();
      /* Map<String, String> queryParams = {};
      if (cityName != null) queryParams['city'] = cityName;
      if (lat != null) queryParams['lat'] = lat.toString();
      if (lng != null) queryParams['lng'] = lng.toString(); */

      Map<String, dynamic> queryParams = {
        'city': cityName ?? defaultCityName,
        'lat': lat ?? defaultLat,
        'lng': lng ?? defaultLng,
      };

      final uri = Uri.parse(baseUrl + getcategory)
          .replace(queryParameters: queryParams);

      log("--- API getCategory :: $uri");
      final response = await http.get(uri);

      // final response = await http.get(Uri.parse(baseUrl + getcategory));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          categoryModel = CategoryModel.fromJson(jsonResponse);
          // List<CategoryModelList>?  detail = categoryModel!.categoryModelList;
          categoryModelList = categoryModel!.categoryModelList;
          if (isNeedAll == false) {
            // categoryModelList!.removeRange(3, categoryModelList!.length);
          }
          isLoading = false;
          update();
          // return categoryModelList;
        } else {
          isLoading = false;
          Get.snackbar(
            "Error",
            "data not found",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: redColor,
          );
          update();
          //   throw Exception('Failed to load Data');
        }
      }
    } catch (e) {
      isLoading = false;
      update();
      print(
          'Exception: category_controller.dart - getCategory()' + e.toString());
    }
  } */
  Future<void> getCategory(bool isNeedAll,
      {String? cityName, double? lat, double? lng}) async {
    log("--- getCategory API Call ---");

    // try {
    isLoading = true;
    update();

    Map<String, String> queryParams = {
      'city': cityName ?? defaultCityName,
      'lat': (lat ?? defaultLat).toString(),
      'lng': (lng ?? defaultLng).toString(),
    };

    final uri =
        Uri.parse(baseUrl + getcategory).replace(queryParameters: queryParams);

    log("--- API getCategory :: $uri");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      if (jsonResponse['status'] == 1) {
        categoryModel = CategoryModel.fromJson(jsonResponse);
        categoryModelList = categoryModel!.categoryModelList;

        if (isNeedAll == false) {
          // categoryModelList!.removeRange(3, categoryModelList!.length);
        }

        isLoading = false;
        update();
      } else {
        isLoading = false;
        Get.snackbar(
          "Error",
          "Data not found",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: redColor,
        );
        update();
      }
    } else {
      throw Exception(
          'Failed to load data. Status code: ${response.statusCode}');
    }
    /* } catch (e) {
    isLoading = false;
    update();
    print('Exception in category_controller.dart - getCategory(): $e');
  } */
  }

  Future getOffer() async {
    try {
      print(Uri.parse(baseUrl + getOfferList));
      final response = await http.get(Uri.parse(baseUrl + getOfferList));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          offerModel = OfferModel.fromJson(jsonResponse);
          offerModelList = offerModel!.data;
          update();
        } else {
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
      print('Exception: category_controller.dart - getOffer()' + e.toString());
    }
  }

  void searchData(String value) async {
    isLoading = true;
    try {
      print(Uri.parse(baseUrl + searchCategory + "?term=$value"));
      final response =
          await http.get(Uri.parse(baseUrl + searchCategory + "?term=$value"));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          categoryModel = CategoryModel.fromJson(jsonResponse);
          // List<CategoryModelList>?  detail = categoryModel!.categoryModelList;
          categoryModelList = categoryModel!.categoryModelList;
          isLoading = false;
          update();
          // return categoryModelList;
        } else {
          isLoading = false;
          Get.snackbar(
            "Error",
            "data not found",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: redColor,
          );
          update();
          //   throw Exception('Failed to load Data');
        }
      }
    } catch (e) {
      Get.snackbar(
        "Failed to load Data",
        "Something went wrong. Try again,",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: redColor,
      );
      isLoading = false;
      update();
    }
  }

  // Future searchAPI(String value) async {
  //   isLoading = true;
  //   try {
  //     String decodedValue = Uri.decodeComponent(value);

  //     print(Uri.parse(baseUrl + searchDataApi + "?tags=$decodedValue"));
  //     final response = await http.get(Uri.parse(baseUrl + searchDataApi + "?tags=$decodedValue"));
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       if (jsonResponse['status'] == "1") {
  //         if (jsonResponse['page'] == 'parameter') {
  //           Get.to(() => ParameterDetailScreen(json.decode(response.body)['data']['id']));
  //         } else if (jsonResponse['page'] == 'package') {
  //           Get.to(() => PackageDetailScreen(json.decode(response.body)['data']['id']));
  //         } else if (jsonResponse['page'] == 'profile') {
  //           Get.find<TestDetailController>().isLoading = false;
  //           Get.to(() => TestDetailsScreen(
  //                 testListModel: TestListModel.fromJson(json.decode(response.body)['data']),
  //               ));
  //         }
  //         isLoading = false;
  //         update();
  //       } else {
  //         isLoading = false;
  //         Get.snackbar(
  //           "Success",
  //           jsonResponse['msg'],
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: Colors.green,
  //         );
  //         update();
  //       }
  //     }
  //   } catch (e) {
  //     isLoading = false;
  //     update();
  //     print('Exception: category_controller.dart - searchAPI()' + e.toString());
  //   }
  // }

  Future searchAPI(String value,
      {String? cityName, double? lat, double? lng}) async {
    isLoading = true;
    update();
    try {
      String encodedValue = Uri.encodeComponent(value);

      Map<String, String> queryParams = {
        'city': cityName ?? defaultCityName,
        'lat': lat.toString() ?? defaultLat.toString(),
        'lng': lng.toString() ?? defaultLng.toString(),
      };

      /* if (cityName != null) queryParams['city'] = cityName;
      if (lat != null) queryParams['lat'] = lat.toString();
      if (lng != null) queryParams['lng'] = lng.toString(); */
      if (value.isNotEmpty) queryParams['tags'] = value;

      final uri = Uri.parse(baseUrl + searchDataApi).replace(
        queryParameters: queryParams,
      );

      log("--- API searchDataApi :: $uri");

      final response = await http.get(uri);

      /*print(Uri.parse(baseUrl + searchDataApi + "?tags=$encodedValue"));

      final response = await http
          .get(Uri.parse(baseUrl + searchDataApi + "?tags=$encodedValue")); */
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == "1") {
          if (jsonResponse['page'] == 'parameter') {
            Get.to(() => ParameterDetailScreen(
                json.decode(response.body)['data']['id']));
          } else if (jsonResponse['page'] == 'package') {
            Get.to(() =>
                PackageDetailScreen(json.decode(response.body)['data']['id']));
          } else if (jsonResponse['page'] == 'profile') {
            Get.find<TestDetailController>().isLoading = false;
            Get.to(() => TestDetailsScreen(
                  testListModel: TestListModel.fromJson(
                      json.decode(response.body)['data']),
                ));
          }
          isLoading = false;
          update();
        } else {
          isLoading = false;
          Get.snackbar(
            "Success",
            jsonResponse['msg'],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
          );
          update();
        }
      }
    } catch (e) {
      isLoading = false;
      update();
      print('Exception: category_controller.dart - searchAPI()' + e.toString());
    }
  }

  /// Category Deta

  Future getBannerList() async {
    try {
      print(Uri.parse(baseUrl + getBanner));
      final response = await http.get(Uri.parse(baseUrl + getBanner));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          bannerModel = BannerModel.fromJson(jsonResponse);
          bannerModelList = bannerModel!.appBanner;
          update();
        } else {
          isLoading = false;

          update();
        }
      }
    } catch (e) {
      isLoading = false;
      update();
      print('Exception: category_controller.dart - getBannerList()' +
          e.toString());
    }
  }

  Future getSuggestionList({String? cityName}) async {
    update();
    try {
      Map<String, String> queryParams = {
        'city': cityName ?? defaultCityName,
      };
      /* print(Uri.parse(baseUrl + searchSuggestion));
      final response = await http.get(Uri.parse(baseUrl + searchSuggestion)); */
      final uri = Uri.parse(baseUrl + searchSuggestionV2)
          .replace(queryParameters: queryParams);

      log("--- API searchSuggestionV2 :: $uri");
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == "1") {
          suggetionModel = SugesstionModel.fromJson(jsonResponse);
          seggestionList = suggetionModel!.data;
          update();
        } else {
          isLoading = false;

          update();
        }
      }
    } catch (e) {
      // Get.snackbar(
      //   "Failed to load Data",
      //   "Something went wrong. Try again,",
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: redColor,
      // );
      isLoading = false;
      update();
      print('Exception: category_controller.dart - getSuggestionList()' +
          e.toString());
    }
  }
}
