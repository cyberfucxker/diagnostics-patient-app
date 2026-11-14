// import 'dart:convert';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:http/http.dart' as http;
// import 'package:diagnostics_patient/Screens/Custome_Widgets/custom_dialogue.dart';
// import 'package:diagnostics_patient/Screens/View/AuthScreen/login_screen.dart';
// import 'package:diagnostics_patient/Screens/View/AuthScreen/otp_screen.dart';
// import 'package:diagnostics_patient/Screens/View/AuthScreen/register_screen.dart';
// import 'package:diagnostics_patient/Screens/View/CartScreen/cart_detail_screen.dart';
// import 'package:diagnostics_patient/controller/test_detail_controller.dart';
// import 'package:diagnostics_patient/main.dart';
// import 'package:diagnostics_patient/utils/api.dart';
// import 'package:diagnostics_patient/utils/strings.dart';

// import '../utils/AllText.dart';

// class LoginController extends GetxController {
//   void onInit() {
//     super.onInit();
//     init();
//   }

//   init() async {
//     getToken();
//   }

//   String? verificationId;
//   TextEditingController otpController = TextEditingController();
//   TextEditingController phoneController = TextEditingController();
//   TextEditingController emailController = TextEditingController();
//   TextEditingController passController = TextEditingController();
//   String? token;

//   getToken() async {
//     FirebaseMessaging.instance.getToken().then((value) {
//       token = value;
//       update();
//     });
//   }

//   Future sendOTP(String phoneNumber) async {
//     try {
//       showOnlyLoaderDialog(Get.context);
//       await FirebaseAuth.instance.verifyPhoneNumber(
//         timeout: const Duration(seconds: 60),
//         phoneNumber: '+91$phoneNumber',
//         verificationCompleted: (PhoneAuthCredential credential) {
//           print('success');
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           hideLoader(Get.context!);
//           ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
//             content: Text('Warning - ${e.message}'),
//           ));
//           print('failed');
//         },
//         codeSent: (String vId, int? resendToken) {
//           hideLoader(Get.context!);
//           verificationId = vId;
//           update();
//           Get.to(() => OTPScreen());
//         },
//         codeAutoRetrievalTimeout: (String verificationId) {},
//       );
//     } catch (e) {
//       print("Exception - addPhoneScreen.dart - _sendOTP():$e");
//     }
//   }

//   void checkOtp() async {
//     showLoadingMsg(context: Get.context!, title: LOGGING_IN[LANGUAGE_TYPE], msg: PLEASE_WAIT_WHIlE_LOGGING_IN[LANGUAGE_TYPE]);
//     FirebaseAuth auth = FirebaseAuth.instance;
//     var credential = PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: otpController.text);
//     await auth.signInWithCredential(credential).then((result) async {
//       print('Success');
//       loginByOtp("1", phoneController.text);
//     }).catchError((e) {
//       print('Fail');
//       ScaffoldMessenger.of(Get.context!).showSnackBar(SnackBar(
//         content: Text('${e.message}'),
//       ));
//       otpController.clear();
//     }).onError((error, stackTrace) {});
//   }

//   ///--------------- login button --------------
//   loginByOtp(String type, String phoneNo) async {
//     showLoadingMsg(context: Get.context!, title: LOGGING_IN[LANGUAGE_TYPE], msg: PLEASE_WAIT_WHIlE_LOGGING_IN[LANGUAGE_TYPE]);
//     final _response = await http.post(Uri.parse("${SERVER_ADDRESS}/OTP_login?phone=${phoneNo}&token=${(token)}&token_type=1&login_type=1"));

//     final _jsonResponse = jsonDecode(_response.body);

//     if (_response.statusCode == 200) {
//       var data = jsonDecode(_response.body);
//       if (data['status'] == 1) {
//         await userDetailsClass.setUserDetails(
//           userId: data['register']['user_id'],
//           name: data['register']['name'],
//           profile: data['register']['profile_pic'] ?? '',
//           phone: data['register']['phone'],
//           email: data['register']['email'],
//           gender: data['register']['gender'],
//           isLoggedIn: true,
//           pass: passController.text,
//         );
//         Get.put(TestDetailController()).getUserDetails();
//         Navigator.popUntil(Get.context!, (route) => route.isFirst);

//         await Future.delayed(Duration.zero);
//         print('===========================>${userId}');
//         // await Get.find<NearByLabController>().getLabList();
//         //   Navigator.pushReplacement(
//         //       Get.context!,
//         //       MaterialPageRoute(
//         //           builder: (context) => PagesWidget(
//         //                 selectedIndex: 0,
//         //               )));
//         // } else if (data['status'] == 0) {

//         // Navigator.pop(Get.context!);
//         Get.to(() => LoginScreen());
//         showCustomDialog(
//             context: Get.context,
//             title: OOPS_ERROR,
//             msg: data['msg'],
//             btnYesText: OK,
//             onPressedBtnYes: () {
//               Navigator.pop(Get.context!);
//             });
//       } else {
//         // Navigator.pop(Get.context!);
//         Get.to(() => RegisterScreen());
//         showCustomDialog(
//             context: Get.context,
//             title: OOPS_ERROR,
//             msg: PLEASE_TRY_AFTER_SOME_TIME,
//             btnYesText: OK,
//             onPressedBtnYes: () {
//               Navigator.pop(Get.context!);
//             });
//       }
//     }
//   }
// }

// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:diagnostics_patient/Screens/Custome_Widgets/custom_dialogue.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/page_widget.dart';
import 'package:diagnostics_patient/Screens/View/AuthScreen/login_screen.dart';
import 'package:diagnostics_patient/Screens/View/AuthScreen/otp_screen.dart';
import 'package:diagnostics_patient/controller/test_detail_controller.dart';
import 'package:diagnostics_patient/main.dart';
import 'package:diagnostics_patient/utils/api.dart';
import 'package:diagnostics_patient/utils/strings.dart';
import 'package:diagnostics_patient/widgets/custom_snackbar.dart';

import '../utils/AllText.dart';

class LoginController extends GetxController {
  void onInit() {
    super.onInit();
    init();
  }

  init() async {
    getToken();
  }

  String? verificationId;
  TextEditingController otpController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  String? token;

  getToken() async {
    FirebaseMessaging.instance.getToken().then((value) {
      token = value;
      update();
    });
  }

  Future sendOTP(String phoneNumber) async {
    try {
      showOnlyLoaderDialog(Get.context);
      await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: const Duration(seconds: 60),
        phoneNumber: '+91$phoneNumber',
        verificationCompleted: (PhoneAuthCredential credential) {
          // otpController.text = credential.smsCode!;
          print('success');
          // update();
        },
        verificationFailed: (FirebaseAuthException e) {
          hideLoader(Get.context!);
          AppSnackbar.warning(
            'Warning',
            e.message ?? 'OTP verification failed',
          );
          print('failed');
        },
        codeSent: (String vId, int? resendToken) {
          hideLoader(Get.context!);
          verificationId = vId;
          update();
          Get.to(() => OTPScreen());
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print("Exception - addPhoneScreen.dart - _sendOTP():$e");
    }
  }

  void checkOtp() async {
    // showLoadingMsg(context: Get.context!, title: LOGGING_IN[LANGUAGE_TYPE], msg: PLEASE_WAIT_WHIlE_LOGGING_IN[LANGUAGE_TYPE]);
    showOnlyLoaderDialog(Get.context);
    FirebaseAuth auth = FirebaseAuth.instance;
    var credential = PhoneAuthProvider.credential(
        verificationId: verificationId!, smsCode: otpController.text);
    await auth.signInWithCredential(credential).then((result) async {
      hideLoader(Get.context!);
      print('Success');
      loginByOtp("1", phoneController.text);
    }).catchError((e) {
      hideLoader(Get.context!);
      print('Fail');
      AppSnackbar.error(
        'Sign-in failed',
        e.message ?? 'Unable to verify OTP',
      );
      otpController.clear();
    }).onError((error, stackTrace) {});
  }

  ///--------------- login button --------------
  loginByOtp(String type, String phoneNo) async {
    showLoadingMsg(
        context: Get.context!,
        title: LOGGING_IN[LANGUAGE_TYPE],
        msg: PLEASE_WAIT_WHIlE_LOGGING_IN[LANGUAGE_TYPE]);
    final _response = await http.post(Uri.parse(
        "${SERVER_ADDRESS}/OTP_login?phone=${phoneNo}&token=${(palyer_id)}&token_type=1&login_type=1"));

    if (_response.statusCode == 200) {
      var data = jsonDecode(_response.body);
      if (data['status'] == 1) {
        await userDetailsClass.setUserDetails(
          userId: data['register']['user_id'],
          name: data['register']['name'],
          profile: data['register']['profile_pic'] ?? '',
          phone: data['register']['phone'],
          email: data['register']['email'],
          gender: data['register']['gender'],
          isLoggedIn: true,
          pass: passController.text,
        );
        Get.put(TestDetailController()).getUserDetails();
        Navigator.popUntil(Get.context!, (route) => route.isFirst);
        await Future.delayed(Duration.zero);
        Navigator.pushReplacement(
            Get.context!,
            MaterialPageRoute(
                builder: (context) => PagesWidget(
                      selectedIndex: 0,
                    )));
      } else if (data['status'] == 0) {
        Navigator.pop(Get.context!);
        showCustomDialog(
            context: Get.context,
            title: OOPS_ERROR,
            msg: data['msg'],
            btnYesText: OK,
            onPressedBtnYes: () {
              Navigator.pushReplacement(Get.context!,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
            });
      } else {
        Navigator.pop(Get.context!);
        showCustomDialog(
            context: Get.context,
            title: OOPS_ERROR,
            msg: PLEASE_TRY_AFTER_SOME_TIME,
            btnYesText: OK,
            onPressedBtnYes: () {
              Navigator.pop(Get.context!);
            });
      }
    }
  }
}
