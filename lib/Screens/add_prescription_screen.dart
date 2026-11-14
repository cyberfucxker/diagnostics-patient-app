// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/controller/home_controller.dart';
import 'package:diagnostics_patient/controller/precription_controller.dart';
import '../../../Models/family_member_list_model.dart';
import '../../../componant/custome_appBar.dart';
import '../../../componant/validation_screen.dart';
import '../../../utils/AllText.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';

class UploadPrecriptionScreen extends StatefulWidget {
  final isEdit;
  final Datum? data;
  const UploadPrecriptionScreen({Key? key, this.isEdit = false, this.data})
      : super(key: key);

  @override
  State<UploadPrecriptionScreen> createState() =>
      _UploadPrecriptionScreenState();
}

// enum genderEnum { Male, Female }

class _UploadPrecriptionScreenState extends State<UploadPrecriptionScreen> {
  final key = GlobalKey<FormState>();

  final controller = Get.put(AddPrecriptionController());

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.selectedDate,
      firstDate: DateTime(1930),
      lastDate: DateTime.now().add(Duration(days: 15)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: themeColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                // primary: themeColor, // button text color
                foregroundColor: themeColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != controller.selectedDate) {
      controller.selectDate(picked);
    }
  }

  // genderEnum? _gender = genderEnum.Male;

  @override
  void initState() {
    // controller.setData(widget.data!);
    if (widget.isEdit) {
      controller.setData(widget.data!);
    }
    super.initState();
    // if(mounted){
    //   if(widget.isEdit){
    //     controller.setData(widget.data!);
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        children: [
          CustomAppBar(
              title: 'Upload Prescription', isArrow: true, isAction: false),
          GetBuilder<AddPrecriptionController>(builder: (controller) {
            return Expanded(
                child: SingleChildScrollView(
              child: Form(
                key: key,
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      textFildHeader('Select Branch', width),
                      DropdownButtonFormField<String>(
                        value: Get.find<HomeController>().selectedBranchName,
                        validator: validateCity,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: width > 360 ? 16 : 14,
                          color: blackColor,
                          fontFamily: "Regular",
                        ),
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: blackColor),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: subTextColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: blackColor),
                          ),
                          focusColor: blackColor,
                          fillColor: blackColor,
                        ),
                        items: Get.find<HomeController>()
                            .getLabByCityNameModel
                            .data!
                            .map((label) => DropdownMenuItem<String>(
                                  child: Text(label.name.toString()),
                                  value: label.name,
                                ))
                            .toList(),
                        hint: Text('Select Branch'),
                        onChanged: (value) {
                          // Update the selected branch
                          Get.find<HomeController>().selectedBranchName = value;

                          // Find the id for the selected branch and print it
                          var selectedBranch = Get.find<HomeController>()
                              .getLabByCityNameModel
                              .data!
                              .firstWhere((label) => label.name == value);

                          Get.find<HomeController>().selectedBranchId =
                              selectedBranch.id.toString();
                          log("Selected Branch ID: ${Get.find<HomeController>().selectedBranchId}");
                          log("Selected Branch Name: ${Get.find<HomeController>().selectedBranchName}");
                        },
                      ),
                      const SizedBox(height: 19),

                      ///---- Name ----
                      textFildHeader(Enter_Name[LANGUAGE_TYPE], width),
                      editCustomTextField(
                        validateName,
                        controller.nameController,
                        width,
                        HINT_NAME[LANGUAGE_TYPE],
                      ),

                      ///--- Relation ---
                      const SizedBox(
                        height: 19,
                      ),

                      ///---- phoneNumber ----
                      textFildHeader(MOBILE_NO[LANGUAGE_TYPE], width),
                      editCustomTextField(
                          validatePhone,
                          controller.mobileNumberController,
                          width,
                          HINT_PHONE[LANGUAGE_TYPE],
                          textInputType: TextInputType.number,
                          maxLen: 12),

                      const SizedBox(
                        height: 19,
                      ),

                      ///---- email ----
                      textFildHeader(Email[LANGUAGE_TYPE], width),
                      editCustomTextField(
                          validateEmail,
                          controller.emailController,
                          width,
                          HINT_EMAIL[LANGUAGE_TYPE],
                          textInputType: TextInputType.emailAddress),
                      const SizedBox(
                        height: 19,
                      ),

                      /// --- DOB ---
                      textFildHeader(DOB[LANGUAGE_TYPE], width),
                      dboTextField(
                        validateDOB,
                        controller.dobController,
                        width,
                        onTap: () {
                          _selectDate(context);
                          print('on tap call');
                        },
                      ),
                      const SizedBox(
                        height: 19,
                      ),
                      textFildHeader(GENDER[LANGUAGE_TYPE], width),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Wrap(
                            alignment: WrapAlignment.start,
                            runAlignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Radio<genderEnum>(
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => blackColor),
                                value: genderEnum.Male,
                                groupValue: controller.gender,
                                onChanged: (genderEnum? value) {
                                  controller.selectGender(value);
                                  // setState(() {
                                  //   _gender = value;
                                  // });
                                },
                              ),
                              regularText(
                                  text: MALE[LANGUAGE_TYPE],
                                  color: subTextColor,
                                  size: 16),
                            ],
                          ),
                          Wrap(
                            alignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Radio<genderEnum>(
                                fillColor: MaterialStateColor.resolveWith(
                                    (states) => blackColor),
                                value: genderEnum.Female,
                                groupValue: controller.gender,
                                onChanged: (genderEnum? value) {
                                  controller.selectGender(value);
                                  // setState(() {
                                  //   _gender = value;
                                  // });
                                },
                              ),
                              regularText(
                                  text: FEMALE[LANGUAGE_TYPE],
                                  color: subTextColor,
                                  size: 16),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 19,
                      ),

                      /* textFildHeader('Select Branch', width),
                      Get.find<AddAddressController>().isGettingManagersCity
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : DropdownButtonFormField<String>(
                              value:
                                  Get.find<AddAddressController>().tcCity.text,
                              validator: validateCity,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: width > 360 ? 16 : 14,
                                color: blackColor,
                                fontFamily: "Regular",
                              ),
                              decoration: const InputDecoration(
                                border: UnderlineInputBorder(
                                  borderSide: BorderSide(color: blackColor),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: subTextColor),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: blackColor),
                                ),
                                focusColor: blackColor,
                                fillColor: blackColor,
                              ),
                              items: Get.find<AddAddressController>()
                                  .manageCityModel!
                                  .data!
                                  .map((label) => DropdownMenuItem<String>(
                                        child: Text(label.city.toString()),
                                        value: label.city,
                                      ))
                                  .toList(),
                              hint: Text('Select Branch'),
                              onChanged: (value) {
                                Get.find<AddAddressController>()
                                    .changeCity(value);
                              },
                            ), */
                      const SizedBox(height: 19),
                      Row(
                        children: [
                          Checkbox(
                            fillColor: MaterialStateColor.resolveWith(
                                (states) => blackColor),
                            value: controller.isAgree,
                            onChanged: (bool? value) {
                              controller.changeIsAgree();
                            },
                          ),
                          Row(
                            children: [
                              Text(
                                'I agree to the',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Regular",
                                ),
                              ),
                              Text(
                                ' Terms of Use',
                                style: TextStyle(
                                  color: themeColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Regular",
                                ),
                              ),
                              Text(
                                ' and',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Regular",
                                ),
                              ),
                              Text(
                                ' Privacy Policy',
                                style: TextStyle(
                                  color: themeColor,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: "Regular",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      controller.images.isNotEmpty
                          ? Container(
                              height: 90,
                              // width: 60,
                              // color: Colors.red,
                              child: ListView.builder(
                                itemCount: controller.images.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Container(
                                    height: 100,
                                    width: 95,
                                    margin: const EdgeInsets.only(right: 10),
                                    decoration: BoxDecoration(
                                        // borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: FileImage(
                                          File(controller.images[index])),
                                    )),
                                  );
                                },
                              ),
                            )
                          : SizedBox(),

                      Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              backgroundColor: themeColor,
                              // primary: themeColor,
                              // onPrimary: themeColor,
                              minimumSize: Size(width, 50),
                            ),
                            onPressed: () {
                              setState(() {
                                controller.pickImageFromGallery();
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/prescription.png',
                                  height: 20,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  'Upload Prescription',
                                  style: const TextStyle(
                                    color: whiteColor,
                                    fontFamily: "Bold",
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          )),
                      SizedBox(height: 10),

                      Center(
                          child: Text(
                        '(PDF, JPG, JPEG, PNG)',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )),
                      SizedBox(height: 10),

                      controller.isSaveLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              child: customeElevatedButton(
                                MediaQuery.of(context).size.width,
                                'Submit',
                                callback: () async {
                                  controller.uploadPrescription();
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ));
          })
        ],
      ),
    );
  }
}
