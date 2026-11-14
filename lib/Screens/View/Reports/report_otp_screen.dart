// ignore_for_file: must_be_immutable

import 'package:diagnostics_patient/config/app_config.dart';
import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/local_package_detail_model.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custom_dialogue.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/page_widget.dart';
import 'package:diagnostics_patient/controller/loginController.dart';
import 'package:diagnostics_patient/controller/reportlogin_controller.dart';
import 'package:diagnostics_patient/utils/AllText.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/strings.dart';
import 'package:diagnostics_patient/widgets/custom_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sms_autofill/sms_autofill.dart';

class ReportOtpScreen extends StatefulWidget {
  LocalPackageModel? localPackageData;
  ReportOtpScreen({this.index, this.localPackageData});
  int? index;

  @override
  State<ReportOtpScreen> createState() => _ReportOtpScreenState();
}

class _ReportOtpScreenState extends State<ReportOtpScreen> {
  final key = GlobalKey<FormState>();
  TextEditingController passController = TextEditingController();
  ReportloginController reportloginController =
  Get.put(ReportloginController());
  String phone = "";
  String? token;

  // ── Resend OTP timer ──────────────────────────────────────────────────────
  Timer? _timer;
  int _secondsLeft = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    getToken();
    getRememberValue();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _secondsLeft = 60;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          _canResend = true;
          t.cancel();
        }
      });
    });
  }

  getToken() async {
    FirebaseMessaging.instance.getToken().then((value) {
      if (mounted) setState(() => token = value);
    });
  }

  getRememberValue() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    bool tmpRemember = preferences.getBool('isRemember') ?? false;
    String tmpPhone = preferences.getString('rePhone') ?? '';
    String tmpPassword = preferences.getString('rePassword') ?? '';

    if (tmpRemember && mounted) {
      setState(() {
        Get.put(LoginController()).phoneController.text = tmpPhone;
        passController.text = tmpPassword;
      });
    }
  }

  void _goHome() {
    Navigator.pushReplacement(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => PagesWidget(selectedIndex: 0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Masked phone for display e.g. ******7890
    final rawPhone = reportloginController.phoneController.text;
    final maskedPhone = rawPhone.length >= 4
        ? '******${rawPhone.substring(rawPhone.length - 4)}'
        : rawPhone;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── AppBar ────────────────────────────────────────────────────
          _buildAppBar(),

          // ── Body ──────────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 48),

                      // ── Illustration ─────────────────────────────────
                      _buildIllustration(),

                      const SizedBox(height: 32),

                      // ── Title & subtitle ─────────────────────────────
                      Text(
                        'OTP Verification',
                        style: TextStyle(
                          fontFamily: 'Bold',
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: darkBlue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'We have sent a 4-digit OTP to',
                        style: TextStyle(
                          fontFamily: 'Regular',
                          fontSize: 14,
                          color: subTextColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        maskedPhone,
                        style: TextStyle(
                          fontFamily: 'Bold',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: darkBlue,
                          letterSpacing: 1.5,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ── OTP Pin Field ─────────────────────────────────
                      _buildOtpField(context),

                      const SizedBox(height: 32),

                      // ── Verify button ─────────────────────────────────
                      customeElevatedButton(
                        width,
                        'Verify OTP',
                        callback: () async {
                          await _verifyOtp(context);
                        },
                      ),

                      const SizedBox(height: 24),



                      const SizedBox(height: 32),
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

  // ── Custom AppBar ─────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      color: themeColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            children: [
              // ✅ FIX: Simple back — pop instead of pushReplacement to
              //    preserve navigation stack properly.
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios_new_rounded,
                    color: Colors.white, size: 20),
              ),
              Expanded(
                child: Text(
                  'Download Report',
                  style: const TextStyle(
                    fontFamily: 'Bold',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Illustration with icon badge ──────────────────────────────────────────
  Widget _buildIllustration() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Image.asset(
        "assets/rpt_img.png",
        fit: BoxFit.contain,
      ),
    );
  }

  // ── OTP Pin Field ─────────────────────────────────────────────────────────
  Widget _buildOtpField(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'Enter OTP',
          style: TextStyle(
            fontFamily: 'Bold',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: darkBlue,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),

        // Pin field
        PinFieldAutoFill(
          codeLength: 4,
          decoration: BoxLooseDecoration(
            radius: const Radius.circular(12),
            // ✅ FIX: strokeColorBuilder use themeColor for focused state
            strokeColorBuilder: PinListenColorBuilder(
              Colors.grey.shade300,
              themeColor,
            ),
            // ✅ FIX: bgColorBuilder white — pehle koi theming issue tha
            bgColorBuilder: PinListenColorBuilder(
              Colors.white,
              themeColor.withOpacity(0.06),
            ),
            gapSpace: 16,
            strokeWidth: 1.5,
            textStyle: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: darkBlue,
              fontFamily: 'Bold',
            ),
            obscureStyle:  ObscureStyle(isTextObscure: false),
          ),
          controller: reportloginController.otpController,
          currentCode: reportloginController.otpController.text,
          onCodeSubmitted: (code) => _verifyOtp(context),
          onCodeChanged: (code) {
            if ((code?.length ?? 0) == 4) {
              FocusScope.of(context).unfocus();
            }
          },
        ),
      ],
    );
  }



  // ── Verify OTP ────────────────────────────────────────────────────────────
  Future<void> _verifyOtp(BuildContext context) async {
    SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();
    final savedOtp = sharedPreferences.getString("otp") ?? '';
    phone = reportloginController.phoneController.text;

    if (reportloginController.otpController.text.isEmpty) {
      AppSnackbar.warning(
        "Warning",
        "Please enter OTP",
      );
      return;
    }

    if (reportloginController.otpController.text == savedOtp) {
      await checkLoginApi();
    } else {
      showCustomDialog(
        context: context,
        title: OOPS_ERROR,
        msg: 'Invalid OTP. Please try again.',
        btnYesText: OK,
        onPressedBtnYes: () => Navigator.pop(context),
      );
    }
  }

  // ── Resend OTP ────────────────────────────────────────────────────────────
  Future<void> _resendOtp() async {
    if (!_canResend) return;
    try {
      showLoadingMsg(
        context: context,
        title: 'Resending OTP',
        msg: PLEASE_WAIT_WHIlE_LOGGING_IN[LANGUAGE_TYPE],
      );
      phone = reportloginController.phoneController.text;
      final response = await http.get(
          Uri.parse("${AppConfig.hostUrl}otpsend_report?phone=$phone"));

      Navigator.pop(context); // close loading

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.remove('otp');
          await prefs.setString("otp", data['otp'].toString());

          reportloginController.otpController.clear();
          _startTimer(); // restart countdown

          AppSnackbar.success(
            "OTP Sent",
            "A new OTP has been sent to your number.",
          );
        } else {
          AppSnackbar.error(
            "Error",
            "Failed to resend OTP. Try again.",
          );
        }
      }
    } catch (e) {
      Navigator.pop(context);
      print('Exception: resendOtp - $e');
    }
  }

  // ── Check Login API ───────────────────────────────────────────────────────
  Future checkLoginApi() async {
    try {
      showLoadingMsg(
        context: context,
        title: LOGGING_IN[LANGUAGE_TYPE],
        msg: PLEASE_WAIT_WHIlE_LOGGING_IN[LANGUAGE_TYPE],
      );
      final response = await http.get(
          Uri.parse("${AppConfig.hostUrl}check_login_api?phone=$phone"));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          print('--- checkLoginApi full data ---');
          print(data['data']);

          reportloginController.reportUserFid   = data['data']['UserFID']?.toString() ?? '';
          reportloginController.reportUserName  = data['data']['Name']?.toString()
              ?? data['data']['name']?.toString() ?? '';
          reportloginController.reportUserEmail = data['data']['Email']?.toString()
              ?? data['data']['email']?.toString() ?? '';
          reportloginController.reportUserPhone = data['data']['Phone']?.toString()
              ?? data['data']['phone']?.toString()
              ?? data['data']['Mobile']?.toString() ?? '';

          print('UserFID: ${reportloginController.reportUserFid}');
          print('Name: ${reportloginController.reportUserName}');
          print('Email: ${reportloginController.reportUserEmail}');
          print('Phone: ${reportloginController.reportUserPhone}');

          await reportloginController.getReportList(
              userFid: data['data']['UserFID']);
        } else {
          Navigator.pop(context); // close loading
          showCustomDialog(
            context: context,
            title: OOPS_ERROR,
            msg: data['msg'] ?? PLEASE_TRY_AFTER_SOME_TIME,
            btnYesText: OK,
            onPressedBtnYes: () => _goHome(),
          );
        }
      }
    } catch (e) {
      print('Exception: checkLoginApi - $e');
    }
  }
}