// ignore_for_file: unused_element, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/user_details_class.dart';

import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';

import 'package:diagnostics_patient/controller/call_back_screen.dart';

import '../../../Models/family_member_list_model.dart';
import '../../../componant/custome_appBar.dart';
import '../../../componant/validation_screen.dart';
import '../../../utils/AllText.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';

class CallBackScreen extends StatefulWidget {
  final isEdit;
  final Datum? data;
  const CallBackScreen({Key? key, this.isEdit = false, this.data})
      : super(key: key);

  @override
  State<CallBackScreen> createState() => _CallBackScreenState();
}

// enum genderEnum { Male, Female }

class _CallBackScreenState extends State<CallBackScreen> {
  final key = GlobalKey<FormState>();

  final controller = Get.put(CallBaclController());
  UserDetailsClass userDetails = UserDetailsClass();
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
    getUserDetails();
    // if(mounted){
    //   if(widget.isEdit){
    //     controller.setData(widget.data!);
    //   }
    // }
  }

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    print("data ${data.profile}");
    setState(() {
      userDetails = data;
    });

    if (userDetails.isLoggedIn) {
      setState(() {
        controller.nameController.text = userDetails.name!;
        controller.mobileNumberController.text = userDetails.phone.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        children: [
          CustomAppBar(
              title: 'Request Call Back', isArrow: true, isAction: false),
          GetBuilder<CallBaclController>(builder: (controller) {
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

                      // ///---- email ----
                      // textFildHeader(Email[LANGUAGE_TYPE], width),
                      // editCustomTextField(validateEmail, controller.emailController, width, HINT_EMAIL[LANGUAGE_TYPE], textInputType: TextInputType.emailAddress),
                      // const SizedBox(
                      //   height: 19,
                      // ),

                      textFildHeader('I want to say', width),
                      Form(
                        key: controller.formKey,
                        child: editCustomTextField(
                          validateSay,
                          controller.iWantToSayController,
                          width,
                          'I want to say',
                          textInputType: TextInputType.name,
                        ),
                      ),

                      const SizedBox(
                        height: 19,
                      ),

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
                                  controller.addRequestCallBack();
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
