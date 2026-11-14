// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/local_package_detail_model.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custom_dialogue.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/page_widget.dart';
import 'package:diagnostics_patient/Screens/View/AuthScreen/login_screen.dart';
import 'package:diagnostics_patient/Screens/View/AuthScreen/register_screen.dart';
import 'package:diagnostics_patient/Screens/View/FamilyMemberListScreen/member_list_screen.dart';
import 'package:diagnostics_patient/controller/loginController.dart';
import 'package:diagnostics_patient/controller/test_detail_controller.dart';
import 'package:diagnostics_patient/main.dart';
import 'package:diagnostics_patient/utils/App_Images.dart';
import 'package:diagnostics_patient/utils/api.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/strings.dart';
import 'package:diagnostics_patient/widgets/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class OTPScreen extends StatefulWidget {
  final String? phoneNumber;
  final int? index;
  final LocalPackageModel? localPackageData;

  const OTPScreen({
    Key? key,
    this.phoneNumber,
    this.index,
    this.localPackageData,
  }) : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _loginController = Get.put(LoginController());

  String _otp = '';
  bool _isRemember = false;
  bool _isVerifying = false;

  // ── Countdown ────────────────────────────────────────────────────────────
  Timer? _timer;
  int _secondsLeft = 60;

  // ── Animation ────────────────────────────────────────────────────────────
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    // Fade + slide animation
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut));

    _startTimer();
    _loadRememberValue();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _fadeCtrl.dispose();
    super.dispose();
  }

  // ── Timer ─────────────────────────────────────────────────────────────────
  void _startTimer() {
    _secondsLeft = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        if (_secondsLeft > 0) {
          _secondsLeft--;
        } else {
          t.cancel();
        }
      });
    });
  }

  // ── Remember Me ──────────────────────────────────────────────────────────
  Future<void> _loadRememberValue() async {
    final prefs = await SharedPreferences.getInstance();
    final remember = prefs.getBool('isRemember') ?? false;
    if (remember) {
      final phone = prefs.getString('rePhone') ?? '';
      final otp   = prefs.getString('reOtp')   ?? '';
      if (mounted) {
        setState(() {
          _isRemember = true;
          _loginController.phoneController.text = phone;
          _loginController.otpController.text   = otp;
        });
      }
    }
  }

  Future<void> _saveRemember() async {
    final prefs = await SharedPreferences.getInstance();
    if (_isRemember) {
      await prefs.setBool('isRemember', true);
      await prefs.setString('rePhone', widget.phoneNumber ?? '');
      await prefs.setString('reOtp', _otp);
    } else {
      await prefs.remove('isRemember');
      await prefs.remove('rePhone');
      await prefs.remove('reOtp');
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
          // ── Background image ─────────────────────────────────────────
          Image.asset(
            AppImages.defaultImage,
            fit: BoxFit.cover,
          ),

          // ── Dark gradient overlay ────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.35),
                  Colors.black.withOpacity(0.65),
                ],
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────────
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

                        // ── Back button ────────────────────────────
                        _buildBackButton(),

                        const SizedBox(height: 40),

                        // ── Logo ───────────────────────────────────
                        Image.asset(
                          'assets/login/logo_white.png',
                          height: 130,
                          width: 180,
                        ),

                        const SizedBox(height: 16),

                        loginText("Welcome Back"),
                        const SizedBox(height: 6),
                        loginSubText("Login to continue"),

                        const SizedBox(height: 12),

                        // ── Phone badge ────────────────────────────
                        if ((widget.phoneNumber ?? '').isNotEmpty)
                          _buildPhoneBadge(),

                        const SizedBox(height: 28),

                        // ── OTP Pin field ──────────────────────────
                        _buildOtpField(),

                        const SizedBox(height: 16),

                        // ── Resend timer ───────────────────────────
                        _buildResendRow(),

                        const SizedBox(height: 28),

                        // ── Verify button ──────────────────────────
                        _buildVerifyButton(size.width),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Full-screen loader ────────────────────────────────────────
          if (_isVerifying)
            Container(
              color: Colors.black.withOpacity(0.45),
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
      onTap: () => Get.to(() => LoginScreen(index: 0)),
      child: Container(
        width: 40, height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.25),
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colors.white,
          size: 16,
        ),
      ),
    );
  }

  Widget _buildPhoneBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.phone_rounded,
              size: 14, color: Colors.white.withOpacity(0.8)),
          const SizedBox(width: 6),
          Text(
            widget.phoneNumber ?? '',
            style: TextStyle(
              fontFamily: 'Regular',
              fontSize: 13,
              color: Colors.white.withOpacity(0.85),
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildOtpField() {
  final defaultTheme = PinTheme(
  width: 62,
  height: 62,
  textStyle: const TextStyle(
  color: Colors.white,
  fontSize: 24,
  fontFamily: 'Bold',
  fontWeight: FontWeight.w700,
  ),
  decoration: BoxDecoration(
  color: Colors.white.withOpacity(0.10),
  borderRadius: BorderRadius.circular(14),
  border: Border.all(
  color: Colors.white.withOpacity(0.25),
  width: 1.5,
  ),
  ),
  );

  final focusedTheme = defaultTheme.copyWith(
  decoration: BoxDecoration(
  color: Colors.white.withOpacity(0.18),
  borderRadius: BorderRadius.circular(14),
  border: Border.all(color: themeColor, width: 2),
  boxShadow: [
  BoxShadow(
  color: themeColor.withOpacity(0.30),
  blurRadius: 10,
  offset: const Offset(0, 3),
  ),
  ],
  ),
  );

  final submittedTheme = defaultTheme.copyWith(
  decoration: BoxDecoration(
  color: themeColor.withOpacity(0.20),
  borderRadius: BorderRadius.circular(14),
  border: Border.all(color: themeColor, width: 1.5),
  ),
  );

  return Pinput(
  length: 4,
  controller: _loginController.otpController,
  defaultPinTheme: defaultTheme,
  focusedPinTheme: focusedTheme,
  submittedPinTheme: submittedTheme,
  keyboardType: TextInputType.number,
  autofocus: false,
  hapticFeedbackType: HapticFeedbackType.lightImpact,

  cursor: Column(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
  Container(
  margin: const EdgeInsets.only(bottom: 9),
  width: 22,
  height: 2,
  decoration: BoxDecoration(
  color: themeColor,
  borderRadius: BorderRadius.circular(8),
  ),
  ),
  ],
  ),
  onChanged: (code) {
  if (!mounted) return;
  setState(() => _otp = code);
  if (code.length == 4) FocusScope.of(context).unfocus();
  },
  onCompleted: (code) {
  setState(() => _otp = code);
  FocusScope.of(context).unfocus();
  },
  );
  }

  Widget _buildResendRow() {
  return Center(
  child: _secondsLeft > 0
  ? Row(
  mainAxisSize: MainAxisSize.min,
  children: [
  Icon(Icons.timer_outlined,
  size: 14, color: Colors.white.withOpacity(0.55)),
  const SizedBox(width: 5),
  Text(
  "Wait 00:$_secondsLeft",
  style: TextStyle(
  fontFamily: 'Regular',
  fontSize: 13,
  color: Colors.white.withOpacity(0.55),
  ),
  ),
  ],
  )
      : GestureDetector(
  onTap: () async {
  await _resendOtp();
  _startTimer();
  },
  child: Container(
  padding:
  const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
  decoration: BoxDecoration(
  color: Colors.white.withOpacity(0.12),
  borderRadius: BorderRadius.circular(20),
  border: Border.all(
  color: Colors.white.withOpacity(0.25),
  ),
  ),
  child: Row(
  mainAxisSize: MainAxisSize.min,
  children: [
  Icon(Icons.refresh_rounded,
  size: 15, color: Colors.white.withOpacity(0.85)),
  const SizedBox(width: 6),
  Text(
  "Resend Code",
  style: TextStyle(
  fontFamily: 'Bold',
  fontSize: 13,
  color: Colors.white.withOpacity(0.9),
  fontWeight: FontWeight.w600,
  ),
  ),
  ],
  ),
  ),
  ),
  );
  }

  Widget _buildVerifyButton(double width) {
  return GestureDetector(
  onTap: _isVerifying ? null : _onVerifyTap,
  child: AnimatedContainer(
  duration: const Duration(milliseconds: 200),
  width: width,
  height: 52,
  decoration: BoxDecoration(
  borderRadius: BorderRadius.circular(14),
  gradient: LinearGradient(
  colors: [
  themeColor,
  themeColor.withOpacity(0.82),
  ],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  ),
  boxShadow: [
  BoxShadow(
  color: themeColor.withOpacity(0.40),
  blurRadius: 18,
  offset: const Offset(0, 6),
  ),
  ],
  ),
  child: Center(
  child: _isVerifying
  ? const SizedBox(
  width: 20,
  height: 20,
  child: CircularProgressIndicator(
  color: Colors.white,
  strokeWidth: 2.5,
  ),
  )
      : Text(
  "Next",
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

  // ─────────────────────────────────────────────────────────────────────────
  // ACTIONS
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> _onVerifyTap() async {
  if (!(_formKey.currentState?.validate() ?? false)) return;

  _otp = _loginController.otpController.text;
  await _saveRemember();

  if (_otp.length == 4) {
  await _otpVerify();
  } else {
    AppSnackbar.warning(
      "Warning",
      "Please enter valid OTP",
    );
  }
  }

  Future<void> _otpVerify() async {
  final connectivity = await Connectivity().checkConnectivity();
  if (connectivity == ConnectivityResult.none) {
  _showDialog(
  title: "Error",
  msg: 'No internet connection. Please check your network and try again.',
  );
  return;
  }

  if (!mounted) return;
  setState(() => _isVerifying = true);

  try {
  final uri = Uri.parse(
  '$SERVER_ADDRESS/$otpVerifyUrl'
  '?otp=${_loginController.otpController.text}'
  '&token=$palyer_id'
  '&phone=${widget.phoneNumber}'
  '&login_type=3&token_type=1',
  );

  log('OTP Verify URI: $uri');
  final response = await http.post(uri);

  if (!mounted) return;
  setState(() => _isVerifying = false);

  if (response.statusCode == 200) {
  final data = jsonDecode(response.body);
  log('OTP Response: $data');

  if (data['status'] == 1) {
  await userDetailsClass.setUserDetails(
  userId:  data['register']['user_id'],
  name:    data['register']['name'],
  profile: data['register']['profile_pic'] ?? '',
  phone:   data['register']['phone'],
  email:   data['register']['email']  ?? '',
  gender:  data['register']['gender'],
  isLoggedIn: true,
  pass: _loginController.passController.text,
  );

  Get.put(TestDetailController()).getUserDetails();
  Navigator.popUntil(context, (route) => route.isFirst);
  await Future.delayed(Duration.zero);

  if (widget.localPackageData != null) {
  Get.to(() => MemberList(localPackageModel: widget.localPackageData!));
  } else {
  Navigator.pushReplacement(
  context,
  MaterialPageRoute(
  builder: (_) => PagesWidget(selectedIndex: widget.index ?? 0),
  ),
  );
  }
  } else if (data['status'] == 0) {
  _showDialog(title: "Error", msg: data['msg']?.toString() ?? '');
  } else {
  _showDialog(title: "Error", msg: "Please try after some time.");
  }
  } else {
  _showDialog(
  title: "Error",
  msg: 'Unexpected error occurred. Please try again.',
  );
  }
  } catch (e) {
  if (mounted) setState(() => _isVerifying = false);
  log('_otpVerify error: $e');
  _showDialog(
  title: "Error",
  msg: e is SocketException
  ? 'No internet connection. Please check your network and try again.'
      : "Please try after some time.",
  );
  }
  }

  Future<void> _resendOtp() async {
  try {
  showLoadingMsg(
  context: context, title: 'Resend Otp', msg: 'Please wait..');

  final response = await http.post(
  Uri.parse('$SERVER_ADDRESS/sendOTP?phone=${widget.phoneNumber}'),
  );

  if (!mounted) return;
  Navigator.pop(context); // close loader

  if (response.statusCode == 200) {
  final data = jsonDecode(response.body);
  if (data['status'] == 1) {
  Get.to(
  () => OTPScreen(
  phoneNumber: widget.phoneNumber,
  index: widget.index,
  ),
  preventDuplicates: false,
  );
  } else if (data['status'] == 0) {
  Get.to(() => RegisterScreen());
  } else {
  _showDialog(title: "Error", msg: "Please try after some time.");
  }
  }
  } catch (e) {
  if (mounted) Navigator.pop(context);
  log('_resendOtp error: $e');
  }
  }

  void _showDialog({required String title, required String msg}) {
  showCustomDialog(
  context: context,
  title: title,
  msg: msg,
  btnYesText: "Ok",
  onPressedBtnYes: () => Navigator.pop(context),
  );
  }
}