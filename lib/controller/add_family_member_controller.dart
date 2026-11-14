// ignore_for_file: camel_case_types

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/controller/member_list_controller.dart';
import '../Models/family_member_list_model.dart';
import '../Models/user_details_class.dart';
import 'package:http/http.dart' as http;
import '../utils/api.dart';
import '../utils/colors.dart';

enum genderEnum { Male, Female }

class AddFamilyMemberController extends GetxController {
  bool isLoading = true;
  bool isDataNotFound = false;
  bool isSaveLoading = false;
  UserDetailsClass userDetails = UserDetailsClass();

  @override
  void onInit() {
    super.onInit();
    getUserDetails();
    init();
  }

  init() async {
    relationController.text = 'Father';
    await getUserDetails();
  }

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController relationController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  String selectedGender = 'Male';
  String _age = "";

  genderEnum? gender = genderEnum.Male;

  setData(Datum data) {
    nameController.text = data.name!;
    relationController.text = data.relation != null ? relationController.text = "Father" : '';
    mobileNumberController.text = data.mobileNo.toString();
    emailController.text = data.email != null ? data.email! : '';
    ageController.text = data.age.toString();
    dobController.text = data.dob != null ? data.dob! : '';
    if (data.gender! == 'Male') {
      selectedGender = data.gender!;
      gender = genderEnum.Male;
    } else {
      selectedGender = data.gender!;
      gender = genderEnum.Female;
    }
    update();
  }

  int _calculateAge(DateTime birthdate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthdate.year;
    if (currentDate.month < birthdate.month || (currentDate.month == birthdate.month && currentDate.day < birthdate.day)) {
      age--;
    }
    return age;
  }

  /// Select Date of Birth
  selectDate(date) {
    selectedDate = date;
    dobController.text = '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';
    _age = _calculateAge(selectedDate).toString();
    print(_age);
    ageController.text = _age;
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
    nameController.text = '';
    relationController.text = 'Father';
    mobileNumberController.text = '';
    emailController.text = '';
    ageController.text = '';
    dobController.text = '';
    selectedGender = 'Male';
    gender = genderEnum.Male;
    update();
  }

  addNewMember({bool isEdit = false, memberId}) async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
    isSaveLoading = true;
    update();
    var _body;
    if (isEdit) {
      _body = {
        'id': memberId.toString(),
        'user_id': userDetails.userId.toString(),
        'name': nameController.text,
        'mobile_no': mobileNumberController.text,
        'age': ageController.text,
        'email': emailController.text,
        'dob': dobController.text,
        'relation': relationController.text,
        'gender': selectedGender,
        'city': cityController.text,
        'state': stateController.text,
        'pincode': pinCodeController.text,
      };
    } else {
      _body = {
        'id': 0.toString(),
        'user_id': userDetails.userId.toString(),
        'name': nameController.text,
        'mobile_no': mobileNumberController.text,
        'age': ageController.text,
        'email': emailController.text,
        'dob': dobController.text,
        'relation': relationController.text,
        'gender': selectedGender,
        'city': cityController.text,
        'state': stateController.text,
        'pincode': pinCodeController.text,
      };
    }

    try {
      final response = await http.post(Uri.parse(baseUrl + "$saveMember"), body: _body);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          // Get.find<MemberListClass>().familyMemberList.last.isSelected = true;
          Get.back(result: true);
          Get.snackbar(
            "Success",
            "${jsonResponse['msg']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
          );

          // Get.find<MemberListClass>().familyMemberList.where((e) => e.id == jsonResponse['data']['id']).first.isSelected = true;
          isSaveLoading = false;
          update();
        } else {
          Get.snackbar(
            "Error",
            "${jsonResponse['msg']}",
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
}
