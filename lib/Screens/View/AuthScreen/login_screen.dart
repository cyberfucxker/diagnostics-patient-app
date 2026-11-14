// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/local_package_detail_model.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custom_dialogue.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/Screens/View/AuthScreen/otp_screen.dart';
import 'package:diagnostics_patient/Screens/View/AuthScreen/register_screen.dart';
import 'package:diagnostics_patient/componant/validation_screen.dart';
import 'package:diagnostics_patient/controller/cart_detail_controller.dart';
import 'package:diagnostics_patient/controller/checkout_controller.dart';
import 'package:diagnostics_patient/controller/loginController.dart';
import 'package:diagnostics_patient/utils/AllText.dart';
import 'package:diagnostics_patient/utils/App_Images.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/strings.dart';
import 'package:diagnostics_patient/widgets/custom_snackbar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../utils/api.dart';

class LoginScreen extends StatefulWidget {
  final int? index;
  final LocalPackageModel? localPackageData;

  const LoginScreen({Key? key, this.index, this.localPackageData})
      : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey  = GlobalKey<FormState>();
  final _loginCtrl = Get.put(LoginController());

  String  _phone      = '';
  String? _fcmToken;
  bool    _isLoading  = false; // ← inline loader, dialog nahi

  // ── Animation ─────────────────────────────────────────────────────────────
  late AnimationController _fadeCtrl;
  late Animation<double>   _fadeAnim;
  late Animation<Offset>   _slideAnim;

  @override
  void initState() {
    super.initState();

    // Animation
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    )..forward();
    _fadeAnim  = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.07),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));

    Get.put(CheckoutController());

    // FCM token — background mein, setState nahi
    FirebaseMessaging.instance.getToken().then((t) => _fcmToken = t);

    _loadRemember();
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Remember Me ────────────────────────────────────────────────────────────
  Future<void> _loadRemember() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool('isRemember') ?? false;
    if (remember && mounted) {
      final phone = prefs.getString('rePhone') ?? '';
      setState(() {
        _loginCtrl.phoneController.text = phone;
      });
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Background ───────────────────────────────────────────────
          Image.asset(AppImages.defaultImage, fit: BoxFit.cover),

          // ── Gradient overlay ─────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.30),
                  Colors.black.withOpacity(0.62),
                ],
              ),
            ),
          ),

          // ── Scrollable content ────────────────────────────────────────
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        _buildBackButton(),
                        const SizedBox(height: 36),
                        _buildLogo(),
                        const SizedBox(height: 16),
                        loginText(Welcome_Back[LANGUAGE_TYPE]),
                        const SizedBox(height: 6),
                        loginSubText(Login_Continue[LANGUAGE_TYPE]),
                        const SizedBox(height: 32),
                        _buildPhoneField(size.width),
                        const SizedBox(height: 28),
                        _buildNextButton(size.width),
                        const SizedBox(height: 24),


                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Full-screen loader ────────────────────────────────────────
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.40),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // WIDGETS
  // ─────────────────────────────────────────────────────────────────────────

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () => Get.back(result: true),
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.25)),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/login/logo_white.png',
      height: 130,
      width: 180,
    );
  }

  Widget _buildPhoneField(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textFildHeader(Enter_Phone_Number[LANGUAGE_TYPE], width),
        const SizedBox(height: 8),
        customeTextFild(
          validatePhone,
          _loginCtrl.phoneController,
          width,
          "",
          TextInputType.numberWithOptions(decimal: true, signed: true),
        ),
      ],
    );
  }

  Widget _buildNextButton(double width) {
    return GestureDetector(
      onTap: _isLoading ? null : _onNextTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [themeColor, themeColor.withOpacity(0.82)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: themeColor.withOpacity(0.38),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: _isLoading
              ? const SizedBox(
            width: 20, height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2.5,
            ),
          )
              : Text(
            Next[LANGUAGE_TYPE],
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Bold',
              fontSize: 17,
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Row(children: [
      Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          height: 1,
          color: Colors.white.withOpacity(0.25),
        ),
      ),
      Text(
        Or[LANGUAGE_TYPE],
        style: TextStyle(
          color: Colors.white.withOpacity(0.65),
          fontSize: 15,
          fontFamily: 'Regular',
        ),
      ),
      Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          height: 1,
          color: Colors.white.withOpacity(0.25),
        ),
      ),
    ]);
  }



  // ─────────────────────────────────────────────────────────────────────────
  // ACTIONS
  // ─────────────────────────────────────────────────────────────────────────


  Future<void> _onNextTap() async {
    // Clear stale cart/coupon state
    Get.find<CheckoutController>().couponController.text = '';
    Get.put(CartDetailController())
      ..walletPointController.text = ''
      ..coupon = 0
      ..walletPoint = 0;

    if (!(_formKey.currentState?.validate() ?? false)) return;

    _phone = _loginCtrl.phoneController.text.trim();
    if (_phone.isEmpty) {
      AppSnackbar.warning(
        "Warning",
        "Please enter contact number",
      );
      return;
    }

    await _login(widget.localPackageData);
  }

  Future<void> _login(LocalPackageModel? localPackageData) async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('$SERVER_ADDRESS/sendOTP?phone=$_phone'),
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 1) {
          // OTP sent — navigate to OTP screen
          // ← popUntil hata diya: loader dialog nahi open kiya toh popUntil ki zaroorat nahi
          Get.to(() => OTPScreen(
            phoneNumber: _phone,
            index: widget.index,
            localPackageData: localPackageData,
          ));
        } else if (data['status'] == 0) {
          // Phone not registered — go to register
          Get.to(() => RegisterScreen(
            localPackageData: localPackageData,
          ));
        } else {
          showCustomDialog(
            context: context,
            title: OOPS_ERROR,
            msg: PLEASE_TRY_AFTER_SOME_TIME,
            btnYesText: OK,
            onPressedBtnYes: () => Navigator.pop(context),
          );
        }
      } else {
        showCustomDialog(
          context: context,
          title: OOPS_ERROR,
          msg: 'Server error. Please try again.',
          btnYesText: OK,
          onPressedBtnYes: () => Navigator.pop(context),
        );
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      debugPrint('LoginScreen _login error: $e');
      showCustomDialog(
        context: context,
        title: OOPS_ERROR,
        msg: PLEASE_TRY_AFTER_SOME_TIME,
        btnYesText: OK,
        onPressedBtnYes: () => Navigator.pop(context),
      );
    }
  }
}