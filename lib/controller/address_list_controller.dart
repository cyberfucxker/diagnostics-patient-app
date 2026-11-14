// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:diagnostics_patient/Models/address_list_model.dart';
import 'package:diagnostics_patient/utils/api.dart';
import 'package:diagnostics_patient/utils/colors.dart';

import '../Models/user_details_class.dart';

class AddressListController extends GetxController {
  AddressListModel? addressListModel;
  bool isLoading = true;
  List<AddressModel> data = <AddressModel>[].obs;
  bool isDeleteLoading = false;
  UserDetailsClass userDetails = UserDetailsClass();

  void onInit() {
    super.onInit();
    getUserDetails();
    update();
  }

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
    AddressList();
  }

  Future AddressList() async {
    isLoading = true;
    update();
    data.clear();
    try {
      final response = await http.get(Uri.parse(baseUrl + "getaddress?id=${userDetails.userId}"));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          addressListModel = AddressListModel.fromJson(jsonResponse);
          print('--- isEdit Respone ${addressListModel!.data!.length}');
          data = addressListModel!.data!;
          print('--- isEdit Respone data:${data}');
          isLoading = false;
          update();
        } else {
          isLoading = false;
          // Get.snackbar(
          //   "Error",
          //   "data not found",
          //   snackPosition: SnackPosition.BOTTOM,
          //   backgroundColor: redColor,
          // );
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

  Future DeleteAddress({id}) async {
    isLoading = true;
    update();
    try {
      final response = await http.get(Uri.parse(baseUrl + "delete_address?id=$id"));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          AddressList();
          Get.snackbar(
            "Successful",
            "${jsonResponse['msg']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
          );
          // isLoading = false;
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
}
