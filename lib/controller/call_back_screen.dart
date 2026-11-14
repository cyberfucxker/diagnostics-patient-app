// ignore_for_file: unnecessary_null_comparison, camel_case_types

import 'dart:convert';


import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/prescription_model.dart';
import '../Models/family_member_list_model.dart';
import '../Models/user_details_class.dart';
import 'package:http/http.dart' as http;

import '../utils/api.dart';
import '../utils/colors.dart';

enum genderEnum { Male, Female }

class CallBaclController extends GetxController {
  bool isLoading = true;
  bool isDataNotFound = false;
  bool isSaveLoading = false;
  UserDetailsClass userDetails = UserDetailsClass();
  bool isAgree = true;
  List<PrecriptionList> precriptionList = [];
  PrescriptionModel? prescriptionModel;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  init() async {
    await getUserDetails();
    // await getPrescriptionList();
  }

  bool isButtonLoading = false;

  setLoadingTrue() {
    isLoading = true;
    update();
  }

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
  }

  final formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController relationController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pinCodeController = TextEditingController();
  TextEditingController iWantToSayController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String selectedGender = 'Male';
  String _age = "";

  genderEnum? gender = genderEnum.Male;

  String? imagePath;

  RxList<String> images = RxList<String>([]);


Future<void> pickImageFromGallery() async {
  try {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null && result.files.isNotEmpty) {
      // Clear old images if needed
      images.clear();

      // Add selected image paths
      images.addAll(
        result.files
            .where((file) => file.path != null)
            .map((file) => file.path!)
            .toList(),
      );

      update(); 
    } else {
      // User canceled the picker
      print("Image selection canceled.");
    }
  } catch (e) {
    print("Error picking multiple images: $e");
  }
}

  setData(Datum data) {
    // if (address!.isDefault == 1) {
    //   isAgree = true;
    // } else {
    //   isAgree = false;
    // }
    nameController.text = data.name!;
    relationController.text = data.relation!;
    mobileNumberController.text = data.mobileNo.toString();
    emailController.text = data.email!;
    ageController.text = data.age.toString();
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

  int _calculateAge(DateTime birthdate) {
    DateTime currentDate = DateTime.now();
    int age = currentDate.year - birthdate.year;
    if (currentDate.month < birthdate.month ||
        (currentDate.month == birthdate.month &&
            currentDate.day < birthdate.day)) {
      age--;
    }
    return age;
  }

  changeIsAgree() {
    isAgree = !isAgree;
    update();
  }

  /// Select Date of Birth
  selectDate(date) {
    selectedDate = date;
    dobController.text =
        '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';
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

  addRequestCallBack() async {
    if (formKey.currentState!.validate()) {
      isSaveLoading = true;
      update();
      try {
        final response = await http.post(Uri.parse(baseUrl + requestCallBack),
            headers: {
              'Authorization': 'AppleJackApp',
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
            body: json.encode({
              'user_id': userDetails.userId.toString(),
              'name': nameController.text,
              'number': mobileNumberController.text,
              'message': iWantToSayController.text,
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

  // getPrescriptionList() async {
  //   isDataNotFound = false;
  //   precriptionList.clear();
  //   try {
  //     final response = await http.get(Uri.parse(baseUrl + getPrescription + '?user_id=${userDetails.userId}'));
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       if (jsonResponse['status'] == 1) {
  //         prescriptionModel = PrescriptionModel.fromJson(jsonResponse);
  //         precriptionList.addAll(prescriptionModel!.data);
  //         isDataNotFound = false;
  //         isLoading = false;
  //         update();
  //       } else if (jsonResponse['status'] == 0) {
  //         isDataNotFound = true;
  //         isLoading = false;
  //         update();
  //       } else {
  //         Get.snackbar(
  //           "Error",
  //           "data not found",
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: redColor,
  //         );
  //         isDataNotFound = true;
  //         isLoading = false;
  //         update();
  //         //   throw Exception('Failed to load Data');
  //       }
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       "Failed to load Data",
  //       "Something went wrong. Try again,",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: redColor,
  //     );
  //     isDataNotFound = true;
  //     isLoading = false;
  //     update();
  //   }
  // }
}
