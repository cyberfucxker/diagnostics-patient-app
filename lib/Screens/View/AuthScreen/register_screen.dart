// ignore_for_file: must_be_immutable, non_constant_identifier_names, deprecated_member_use

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/local_package_detail_model.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';

import 'package:diagnostics_patient/Screens/View/AuthScreen/login_screen.dart';
import 'package:diagnostics_patient/Screens/View/AuthScreen/otp_screen.dart';
import 'package:diagnostics_patient/componant/validation_screen.dart';
import 'package:diagnostics_patient/controller/loginController.dart';

import 'package:diagnostics_patient/utils/AllText.dart';
import 'package:diagnostics_patient/utils/App_Images.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/strings.dart';
import 'package:diagnostics_patient/widgets/custom_snackbar.dart';
import 'package:http/http.dart' as http;

import '../../../utils/api.dart';
import '../../Custome_Widgets/custom_dialogue.dart';

class RegisterScreen extends StatefulWidget {
  int? index;
  LocalPackageModel? localPackageData;

  RegisterScreen({this.index, this.localPackageData});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final key = GlobalKey<FormState>();
  String? email;
  String? pass;
  String? confirmpass;
  String? name;
  String? phone;
  String? _selectedOption;
  String? age;
  String? d_o_b;
  String? gender;

  DateTime now = new DateTime.now();
  String token = "";
  String _age = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool _obscureText = true;

  ///========== Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  bool _obscureConfirmText = true;

  ///========= Toggles the password show status
  void _toggleConfirm() {
    setState(() {
      _obscureConfirmText = !_obscureConfirmText;
    });
  }

  ///------------- get token ----
  getToken() async {
    FirebaseMessaging.instance.getToken().then((value) {
      setState(() {
        token = value!;
      });
    });
  }

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: themeColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: themeColor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      selectDate(picked);
    }
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

  selectDate(date) {
    setState(() {
      selectedDate = date;
      dobController.text =
      '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}';
      _age = _calculateAge(selectedDate).toString();
      print(_age);
      ageController.text = _age;
    });
  }

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              AppImages.defaultImage,
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                      Get.back();
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      color: whiteColor,
                      size: 18,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  ///---- Logo ----
                  Image.asset(
                    "assets/login/logo_white.png",
                    height: 150,
                    width: 200,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  loginText(Register_Now[LANGUAGE_TYPE]),
                  const SizedBox(
                    height: 6,
                  ),
                  loginSubText(RegisterSubText[LANGUAGE_TYPE]),
                  const SizedBox(
                    height: 30,
                  ),

                  ///---- Name ----
                  textFildHeader(Enter_Name[LANGUAGE_TYPE], width),
                  customeTextFild(validateName, nameController, width, "",
                      TextInputType.text),
                  const SizedBox(
                    height: 10,
                  ),

                  ///---- Email ----
                  textFildHeader(Enter_Email_Address[LANGUAGE_TYPE], width),
                  customeTextFild(validateEmail, emailController, width, "",
                      TextInputType.emailAddress),
                  const SizedBox(
                    height: 10,
                  ),

                  ///---- Phone Number ----
                  textFildHeader(Enter_Phone_Number[LANGUAGE_TYPE], width),
                  customeTextFild(
                    validatePhone,
                    Get.put(LoginController()).phoneController,
                    width,
                    "",
                    TextInputType.phone,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  ///---- Age ----
                  textFildHeader(Enter_age[LANGUAGE_TYPE], width),
                  customeTextFild(validateAge, ageController, width, "",
                      TextInputType.phone),
                  const SizedBox(
                    height: 10,
                  ),

                  ///---- Gender ----
                  SizedBox(
                      child: Row(
                        children: [
                          Expanded(
                            child: RadioListTile(
                              title: const Text(
                                'Male',
                                style: TextStyle(
                                  color: subTextColor,
                                  fontFamily: "Regular",
                                ),
                              ),
                              value: 'male',
                              fillColor: MaterialStateColor.resolveWith(
                                      (states) => subTextColor),
                              groupValue: _selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectedOption = value.toString();
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: RadioListTile(
                              title: const Text(
                                'Female',
                                style: TextStyle(
                                  color: subTextColor,
                                  fontFamily: "Regular",
                                ),
                              ),
                              value: 'female',
                              fillColor: MaterialStateColor.resolveWith(
                                      (states) => subTextColor),
                              groupValue: _selectedOption,
                              onChanged: (value) {
                                setState(() {
                                  _selectedOption = value.toString();
                                });
                              },
                            ),
                          ),
                        ],
                      )),

                  ///----Register Button----
                  customeElevatedButton(width, Register[LANGUAGE_TYPE],
                      callback: () {
                        if (key.currentState!.validate()) {
                          if (passwordController.text ==
                              confirmPasswordController.text) {
                            name = nameController.text;
                            email = emailController.text;
                            phone = Get.put(LoginController()).phoneController.text;
                            age = ageController.text;
                            gender = _selectedOption;

                            signUp();
                          } else {
                            AppSnackbar.error(
                              "Failed data",
                              "Password does not match",
                            );
                          }
                        }
                      }),
                  const SizedBox(
                    height: 20,
                  ),

                  ///---- Already have account/login ----
                  Padding(
                    padding: const EdgeInsets.only(bottom: 26),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          Already_Have_Account[LANGUAGE_TYPE],
                          style: TextStyle(
                            color: subTextColor,
                            fontFamily: "Regular",
                            fontSize: MediaQuery.of(context).size.width > 360
                                ? 16
                                : 14,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        LoginScreen(index: 0)));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              Login[LANGUAGE_TYPE],
                              style: TextStyle(
                                color: whiteColor,
                                fontFamily: "Regular",
                                fontSize:
                                MediaQuery.of(context).size.width > 360
                                    ? 16
                                    : 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --------- Methods ----------------

  signUp() async {
    showLoadingMsg(
        context: context,
        title: LOGGING_IN[LANGUAGE_TYPE],
        msg: PLEASE_WAIT_WHIlE_LOGGING_IN[LANGUAGE_TYPE]);
    final _response = await http.post(
      Uri.parse('$SERVER_ADDRESS/register'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        "name": name,
        "email": email,
        "phone": phone,
        "gender": gender,
        "token": palyer_id,
        "type": 1,
        "d_o_b": d_o_b,
        "password": pass,
        "age": age,
      }),
    );
    print("_response ${_response.body}");

    if (_response.statusCode == 200) {
      var data = jsonDecode(_response.body);
      print("data $data");
      if (data['status'] == 1) {
        await _login();
      } else if (data['status'] == 0) {
        Navigator.pop(context);
        showCustomDialog(
            context: context,
            title: OOPS_ERROR,
            msg: data['msg'],
            btnYesText: OK,
            onPressedBtnYes: () {
              Navigator.pop(context);
            });
      } else {
        Navigator.pop(context);
        showCustomDialog(
            context: context,
            title: OOPS_ERROR,
            msg: PLEASE_TRY_AFTER_SOME_TIME,
            btnYesText: OK,
            onPressedBtnYes: () {
              Navigator.pop(context);
            });
      }
    }
  }

  Future _login() async {
    try {
      showLoadingMsg(
          context: context,
          title: LOGGING_IN[LANGUAGE_TYPE],
          msg: PLEASE_WAIT_WHIlE_LOGGING_IN[LANGUAGE_TYPE]);
      final _response =
      await http.post(Uri.parse("$SERVER_ADDRESS/sendOTP?phone=$phone"));

      if (_response.statusCode == 200) {
        var data = jsonDecode(_response.body);
        if (data['status'] == 1) {
          Navigator.popUntil(context, (route) => route.isFirst);
          await Future.delayed(Duration.zero);
          Get.to(() => OTPScreen(
            phoneNumber: phone,
            index: widget.index,
            localPackageData: widget.localPackageData,
          ));
        } else if (data['status'] == 0) {
          Get.to(() => RegisterScreen());
        } else {
          Navigator.pop(context);
          showCustomDialog(
              context: context,
              title: OOPS_ERROR,
              msg: PLEASE_TRY_AFTER_SOME_TIME,
              btnYesText: OK,
              onPressedBtnYes: () {
                Navigator.pop(context);
              });
        }
      }
    } catch (e) {
      print('Exceptin : login_screen - _login()' + e.toString());
    }
  }
}