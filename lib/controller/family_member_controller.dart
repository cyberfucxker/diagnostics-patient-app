// ignore_for_file: camel_case_types

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Models/family_member_list_model.dart';
import '../Models/user_details_class.dart';
import '../utils/api.dart';
import '../utils/colors.dart';
import 'package:http/http.dart' as http;

enum genderEnum { Male, Female }

class FamilyMemberController extends GetxController {
  bool isLoading = true;
  bool isDataNotFound = false;
  bool isSaveLoading = false;
  FamilyMemberListModel? familyMemberListModel;
  UserDetailsClass userDetails = UserDetailsClass();

  @override
  void onInit() {
    super.onInit();
    init();
  }

  init() async {
    await getUserDetails();
    getFamilyMemberList();
  }

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
  }

  /// Get Family Member

  getFamilyMemberList() async {
    isLoading = true;
    update();
    try {
      final response = await http.get(Uri.parse(baseUrl + getMemberList + '?id=${userDetails.userId}'));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          familyMemberListModel = FamilyMemberListModel.fromJson(jsonResponse);
          isLoading = false;
          update();
        } else {
          // Get.snackbar(
          //   "Error",
          //   "data not found",
          //   snackPosition: SnackPosition.BOTTOM,
          //   backgroundColor: redColor,
          // );
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

  deleteMember({required int memberId}) async {
    isLoading = true;
    update();
    try {
      final response = await http.get(Uri.parse(baseUrl + "$deleteMemberApi?id=$memberId"));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          getFamilyMemberList();
          Get.snackbar(
            "Success",
            "${jsonResponse['msg']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
          );
          // isLoading = false;
          update();
        } else {
          // Get.snackbar(
          //   "Error",
          //   "data not found",
          //   snackPosition: SnackPosition.BOTTOM,
          //   backgroundColor: redColor,
          // );
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
      isLoading = false;
      update();
    }
  }

  /// Add New Member

  // TextEditingController nameController = TextEditingController();
  // TextEditingController relationController = TextEditingController();
  // TextEditingController mobileNumberController = TextEditingController();
  // TextEditingController emailController = TextEditingController();
  // TextEditingController ageController = TextEditingController();
  // TextEditingController dobController = TextEditingController();
  // DateTime selectedDate = DateTime.now();
  // String selectedGender = 'Male';
  //
  // genderEnum? gender = genderEnum.Male;
  //
  // /// Select Date of Birth
  // selectDate(date) {
  //   selectedDate = date;
  //   dobController.text =
  //       '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';
  //   update();
  // }
  //
  // /// Select Gender
  // selectGender(value) {
  //   gender = value;
  //   if (gender!.index == 0) {
  //     selectedGender = 'Male';
  //   } else {
  //     selectedGender = 'Female';
  //   }
  //   update();
  // }
  //
  // resetForm() {
  //   nameController.text = '';
  //   relationController.text = 'Self';
  //   mobileNumberController.text = '';
  //   emailController.text = '';
  //   ageController.text = '';
  //   dobController.text = '';
  //   selectedGender = 'Male';
  //   gender = genderEnum.Male;
  //   update();
  // }
  //
  // addNewMember({bool isEdit = false, addressId}) async {
  //   print('call');
  //   print(nameController.text);
  //   print(relationController.text);
  //   print(mobileNumberController.text);
  //   print(emailController.text);
  //   print(ageController.text);
  //   print(dobController.text);
  //   print(selectedGender);
  //
  //   // return;
  //
  //   isSaveLoading = true;
  //   update();
  //
  //   var _body;
  //   if (isEdit) {
  //     _body = {
  //       // 'id': addressId.toString(),
  //       // 'user_id':userDetails.userId.toString(),
  //       // 'name': tcSaveAS.text,
  //       // 'house_no': tcHouseNo.text,
  //       // 'pincode': tcPincode.text,
  //       // 'city': tcHouseNo.text,
  //       // 'state':tcState.text,
  //       // 'is_default': isDefaultInt.toString(),
  //       // 'address': tcAddress.text,
  //       // 'lat':center!.latitude.toString(),
  //       // 'long':center!.longitude.toString(),
  //     };
  //   } else {
  //     _body = {
  //       'id': 0.toString(),
  //       'user_id': userDetails.userId.toString(),
  //       'name': nameController.text,
  //       'mobile_no': mobileNumberController.text,
  //       'age': ageController.text,
  //       'email': emailController.text,
  //       'dob': dobController.text,
  //       'relation': relationController.text,
  //       'gender': selectedGender,
  //     };
  //   }
  //
  //   try {
  //     final response =
  //         await http.post(Uri.parse(baseUrl + "$saveMember"), body: _body);
  //     print('url is ${baseUrl + "$saveMember"}');
  //     print('response is ${response.body}');
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       if (jsonResponse['status'] == 1) {
  //         getFamilyMemberList();
  //         resetForm();
  //         Get.back();
  //         Get.snackbar(
  //           "Success",
  //           "${jsonResponse['msg']}",
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: Colors.green,
  //         );
  //         isSaveLoading = false;
  //         update();
  //       } else {
  //         Get.snackbar(
  //           "Error",
  //           "data not found",
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: redColor,
  //         );
  //         isSaveLoading = false;
  //         update();
  //         //   throw Exception('Failed to load Data');
  //       }
  //     }
  //   } catch (e) {
  //     print(e);
  //     Get.snackbar(
  //       "Failed to load Data",
  //       "Something went wrong. Try again,",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: redColor,
  //     );
  //     isSaveLoading = false;
  //     update();
  //   }
  // }
}
