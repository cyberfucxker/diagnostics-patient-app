// ignore_for_file: must_be_immutable

import 'package:diagnostics_patient/config/app_config.dart';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/local_package_detail_model.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custom_dialogue.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/Screens/View/Reports/report_otp_screen.dart';
import 'package:diagnostics_patient/componant/custome_appBar.dart';
import 'package:diagnostics_patient/componant/validation_screen.dart';
import 'package:diagnostics_patient/controller/loginController.dart';
import 'package:diagnostics_patient/controller/reportlogin_controller.dart';
import 'package:diagnostics_patient/utils/AllText.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/strings.dart';
import 'package:diagnostics_patient/widgets/custom_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ReportLoginScreen extends StatefulWidget {
  LocalPackageModel? localPackageData;
  ReportLoginScreen({this.index, this.localPackageData});
  int? index;

  @override
  State<ReportLoginScreen> createState() => _ReportLoginScreenState();
}

class _ReportLoginScreenState extends State<ReportLoginScreen> {
  final key = GlobalKey<FormState>();
  TextEditingController passController = TextEditingController();
  ReportloginController reportloginController =
  Get.put(ReportloginController());
  String phone = "";
  String pass = "";
  String? token;
  bool isRemember = false;

  getToken() async {
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        token = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getToken();
    getRememberValue();
  }

  getRememberValue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool tmpRemember = preferences.getBool('isRemember') ?? false;
    String tmpPhone = preferences.getString('rePhone') ?? '';
    String tmpPassword = preferences.getString('rePassword') ?? '';

    if (tmpRemember) {
      setState(() {
        isRemember = tmpRemember;
        Get.put(LoginController()).phoneController.text = tmpPhone;
        passController.text = tmpPassword;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      // ✅ FIX: backgroundColor white set kiya — kuch themes mein
      //    Scaffold ka default dark ho sakta hai.
      backgroundColor: Colors.white,
      body: Column(
        children: [
          CustomAppBar(
              title: 'Download Report', isArrow: true, isAction: false),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      Image.asset("assets/rpt_img.png"),
                      const SizedBox(height: 30),
                      Center(
                        child: Text(
                          'Login to Download Report',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 25,
                            color: darkBlue,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),

                      textFildHeader('Mobile No', width),
                      const SizedBox(height: 8),

                      TextFormField(
                        validator: validatePhone,
                        controller: reportloginController.phoneController,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: width > 360 ? 16 : 14,
                          // ✅ FIX: text color blackColor — pehle field
                          //    background bhi blackColor tha isliye text
                          //    dikhta nahi tha.
                          color: blackColor,
                          fontFamily: "Regular",
                        ),
                        keyboardType: TextInputType.number,
                        cursorColor: themeColor,
                        maxLength: 10,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          counterText: '',

                          // ✅ FIX: filled: true + fillColor white —
                          //    pehle fillColor: blackColor tha aur filled
                          //    missing tha, jisse background black dikhta tha.
                          filled: true,
                          fillColor: Colors.white,

                          // ✅ FIX: focusColor hata diya — ye TextField ke
                          //    background ko affect karta tha (blackColor tha).
                          // focusColor removed

                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 1.5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                                color: Colors.grey.shade300, width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide:
                            BorderSide(color: themeColor, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.red, width: 1.5),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Colors.red, width: 2),
                          ),

                          hintText: 'Enter your Mobile Number',
                          hintStyle: const TextStyle(
                            color: subTextColor,
                            fontSize: 14,
                            fontFamily: "Regular",
                          ),

                          // ✅ FIX: prefix icon add kiya for better UX
                          prefixIcon: Icon(Icons.phone_outlined,
                              color: themeColor, size: 20),
                        ),
                      ),

                      const SizedBox(height: 30),

                      customeElevatedButton(
                        width,
                        'Sign IN',
                        callback: () async {
                          if (key.currentState!.validate()) {
                            phone =
                                reportloginController.phoneController.text;
                            if (phone.isNotEmpty) {
                              await _login();
                            } else {
                              AppSnackbar.warning(
                                "Warning",
                                "Please enter contact number",
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _login() async {
    try {
      SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
      showLoadingMsg(
        context: context,
        title: LOGGING_IN[LANGUAGE_TYPE],
        msg: PLEASE_WAIT_WHIlE_LOGGING_IN[LANGUAGE_TYPE],
      );
      final _response = await http.get(
          Uri.parse("${AppConfig.hostUrl}otpsend_report?phone=$phone"));
      if (_response.statusCode == 200) {
        var data = jsonDecode(_response.body);
        if (data['success'] == true) {
          if (sharedPreferences.getString('otp') != null) {
            sharedPreferences.remove('otp');
            sharedPreferences.setString("otp", data['otp'].toString());
          } else {
            sharedPreferences.setString("otp", data['otp'].toString());
          }
          Get.to(() => ReportOtpScreen());
        } else {
          Navigator.pop(context);
          showCustomDialog(
            context: context,
            title: OOPS_ERROR,
            msg: PLEASE_TRY_AFTER_SOME_TIME,
            btnYesText: OK,
            onPressedBtnYes: () {
              Navigator.pop(context);
            },
          );
        }
      }
    } catch (e) {
      print('Exception : login_screen - _login() ' + e.toString());
    }
  }
}