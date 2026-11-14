import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';

import '../Models/category_detail_model.dart';
import 'package:http/http.dart' as http;

import '../utils/api.dart';
import '../utils/colors.dart';

class CategoryDetailController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final id;
  CategoryDetailController(this.id);

  bool isLoading = true;
  int currentTabIndex = 0;
  TabController? tabController;
  bool isListLoading = true;
  int currentPage = 1;
  CategoryDetailModel? categoryDetailModel;
  List<PackageDetail>? packageDetail = [];
  List<PackageDetail>? packageDetail1 = [];
  List<PackageDetail>? packageDetail2 = [];
  List<PackageDetail>? packageDetail3 = [];
  // ScrollController scrollController = ScrollController();
  final addressController = Get.find<AddAddressController>();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
    /* scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.position.pixels) {
        if (isListLoading) {
          getPackageList();
        }
      }
    }); */
    getPackageList();
  }

  void dispose() {
    super.dispose();
    tabController!.dispose();
  }

  getPackageList() async {
    try {
      /*  print(Uri.parse(
          baseUrl + getCategoryDetail + '?cat_id=$id&page=$currentPage'));
      final response = await http.get(Uri.parse(
          baseUrl + getCategoryDetail + '?cat_id=$id&page=$currentPage')); */
      final queryParams = <String, String>{
        'cat_id': id.toString(),
        'page': currentPage.toString(),
      };

      if (addressController.selectedDropdownValue != null)
        queryParams['city'] = addressController.selectedDropdownValue ?? "";
      if (addressController.center!.latitude != null)
        queryParams['lat'] = addressController.center!.latitude.toString();
      if (addressController.center!.longitude != null)
        queryParams['lng'] = addressController.center!.longitude.toString();

      // Construct the full URI
      final uri = Uri.parse(baseUrl + getCategoryDetail).replace(
        queryParameters: queryParams,
      );

      log("--- getPackageList API :: ${uri}");

      final response = await http.get(uri);

      debugPrint('response ${response.request}');
      if (response.statusCode == 200) {
        packageDetail = [];
        final jsonResponse = jsonDecode(response.body);
        print("jsonResponse $jsonResponse");
        if (jsonResponse['status'] == 1) {
          categoryDetailModel = CategoryDetailModel.fromJson(jsonResponse);
          packageDetail!.addAll(categoryDetailModel!.data!.packageDetail!);

          for (var i = 0; i < packageDetail!.length; i++) {
            if (packageDetail![i].type == 1) {
              packageDetail1!.add(packageDetail![i]);
            } else if (packageDetail![i].type == 2) {
              packageDetail2!.add(packageDetail![i]);
            } else {
              packageDetail3!.add(packageDetail![i]);
            }
          }
          log("package length: ${packageDetail1!.length}");
          log("parameter length: ${packageDetail2!.length}");
          log("profile length: ${packageDetail3!.length}");

          // if (categoryDetailModel!.data!.packageDetail!.nextPageUrl == null) {
          //   isListLoading = false;
          // } else {
          //   currentPage++;
          // }

          isLoading = false;
          update();
        } else {
          Get.snackbar(
            "Error",
            "data not found",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: redColor,
          );
          isLoading = false;
          isListLoading = false;
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
      isListLoading = false;
      update();
    }
  }
}
