// ignore_for_file: camel_case_types

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/home_visit_model.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';
import 'package:diagnostics_patient/controller/home_controller.dart';
import '../Models/family_member_list_model.dart';
import '../Models/user_details_class.dart';
import 'package:http/http.dart' as http;

import '../utils/api.dart';
import '../utils/colors.dart';

enum genderEnum { Male, Female }

class HomeVisitController extends GetxController {
  bool isLoading = true;
  bool isDataNotFound = false;
  bool isError = false;
  int id = 0;
  List<HomeVisitModelList> homeVisitList = [];
  HomeVisitModel? homeVisitModel;

  bool isSaveLoading = false;
  UserDetailsClass userDetails = UserDetailsClass();

  @override
  void onInit() {
    super.onInit();
    init();
  }

  init() async {
    relationController.text = 'Father';
    await getUserDetails();
    getHomeVisitList();
  }

  setLoadingTrue() {
    isLoading = true;
    update();
  }

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
  }

  bool isButtonLoading = false;

  TextEditingController fullNameController = TextEditingController();
  TextEditingController relationController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController tcAddress = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController houseNoController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedGender = 'Male';

  genderEnum? gender = genderEnum.Male;

  setData(Datum data) {
    fullNameController.text = data.name!;
    relationController.text = data.relation!;
    mobileNumberController.text = data.mobileNo.toString();
    emailController.text = data.email!;
    tcAddress.text = data.age.toString();
    dobController.text = data.dob!;
    if (data.gender! == 'Male') {
      selectedGender = data.gender!;
      gender = genderEnum.Male;
    } else {
      selectedGender = data.gender!;
      gender = genderEnum.Female;
    }
    // update();
  }

  /// Select Date of Birth
  selectDate(date) {
    selectedDate = date;
    dobController.text =
        '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';
    update();
  }

  /// Select Gender
  selectGender(value) {
    gender = value;
    if (gender!.index == 0) {
      selectedGender = 'Male';
    } else {
      selectedGender = 'Female';
    }
    update();
  }

  resetForm() {
    fullNameController.text = '';
    relationController.text = 'Father';
    mobileNumberController.text = '';
    emailController.text = '';
    tcAddress.text = '';
    dobController.text = '';
    selectedGender = 'Male';
    gender = genderEnum.Male;
    update();
  }

  addHomeVisit() async {
    log("selectedBranchId:: ${Get.find<HomeController>().selectedBranchId}");
    isSaveLoading = true;
    update();

    try {
      final response = await http.post(Uri.parse(baseUrl + addHomeVisits),
          headers: {
            'Authorization': 'AppleJackApp',
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: json.encode({
            'user_id': userDetails.userId.toString(),
            'user_name': fullNameController.text,
            'user_number': mobileNumberController.text,
            'user_email': emailController.text,
            'city_id': id.toString(),
            // 'lab_id': Get.find<AddAddressController>().id,
            'lat': Get.find<AddAddressController>().center!.latitude.toString(),
            'lng':
                Get.find<AddAddressController>().center!.longitude.toString(),
            'state': stateController.text,
            'pincode': pinCodeController.text,
            'lab_id': Get.find<HomeController>().selectedBranchId ?? '',
          }));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          Get.back(result: true);
          Get.snackbar(
            "Success",
            "${jsonResponse['msg']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
          );
          isSaveLoading = false;
          update();
        } else {
          Get.snackbar(
            "Error",
            "data not found",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: redColor,
          );
          isSaveLoading = false;
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
      isSaveLoading = false;
      update();
    }
  }

  getHomeVisitList() async {
    isDataNotFound = false;
    homeVisitList.clear();
    try {
      final response = await http.get(Uri.parse(
          baseUrl + getHomeVisitLists + '?user_id=${userDetails.userId}'));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          homeVisitModel = HomeVisitModel.fromJson(jsonResponse);
          homeVisitList.addAll(homeVisitModel!.data);
          isDataNotFound = false;
          isLoading = false;
          update();
        } else if (jsonResponse['status'] == 0) {
          isDataNotFound = true;
          isLoading = false;
          update();
        } else {
          Get.snackbar(
            "Error",
            "data not found",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: redColor,
          );
          isDataNotFound = true;
          isLoading = false;
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
      isDataNotFound = true;
      isLoading = false;
      update();
    }
  }
}
