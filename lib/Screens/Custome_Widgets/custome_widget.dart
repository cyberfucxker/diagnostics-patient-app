// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'package:diagnostics_patient/config/app_config.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/parameter_detail_model.dart';
import 'package:diagnostics_patient/Models/packageDetails.dart';
import 'package:diagnostics_patient/Models/profile_detail_models.dart';
import 'package:diagnostics_patient/Models/test_detail_model.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/strings.dart';
import 'package:diagnostics_patient/widgets/custom_snackbar.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

// ─────────────────────────────────────────────────────────────────────────────
// DESIGN TOKENS — ek jagah change karo, poori app mein reflect hoga
// ─────────────────────────────────────────────────────────────────────────────
class _DS {
  // Radius
  static const double radiusSm  = 8;
  static const double radiusMd  = 12;
  static const double radiusLg  = 16;
  static const double radiusXl  = 20;

  // Field height
  static const double fieldHeight = 54;
  static const double btnHeight   = 52;

  // Font sizes
  static const double fs10 = 10;
  static const double fs12 = 12;
  static const double fs13 = 13;
  static const double fs14 = 14;
  static const double fs16 = 16;
  static const double fs18 = 18;
  static const double fs20 = 20;
  static const double fs28 = 28;

  // Shadows
  static List<BoxShadow> softShadow(Color color) => [
    BoxShadow(
      color: color.withOpacity(0.18),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> fieldShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 10,
      offset: const Offset(0, 3),
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────
// INPUT DECORATION — unified, used by all text fields
// ─────────────────────────────────────────────────────────────────────────────
InputDecoration _fieldDecoration({
  required String hintText,
  Widget? suffixIcon,
  Widget? prefixIcon,
  Color fillColor = Colors.white,
  bool isDark = false,
}) {
  final hintColor = isDark
      ? Colors.white.withOpacity(0.45)
      : const Color(0xFFABB5BE);

  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: hintColor,
      fontSize: _DS.fs14,
      fontFamily: 'Regular',
      fontWeight: FontWeight.w400,
    ),
    filled: true,
    fillColor: isDark
        ? Colors.white.withOpacity(0.08)
        : fillColor,
    suffixIcon: suffixIcon,
    prefixIcon: prefixIcon,
    counterText: '',
    contentPadding: const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 16,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_DS.radiusMd),
      borderSide: BorderSide(
        color: isDark
            ? Colors.white.withOpacity(0.15)
            : const Color(0xFFDEE2E6),
        width: 1.5,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_DS.radiusMd),
      borderSide: BorderSide(
        color: isDark
            ? Colors.white.withOpacity(0.15)
            : const Color(0xFFDEE2E6),
        width: 1.5,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_DS.radiusMd),
      borderSide: BorderSide(
        color: themeColor,
        width: 2,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_DS.radiusMd),
      borderSide: const BorderSide(color: Color(0xFFE63946), width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(_DS.radiusMd),
      borderSide: const BorderSide(color: Color(0xFFE63946), width: 2),
    ),
  );
}

TextStyle _fieldTextStyle({bool isDark = false}) => TextStyle(
  fontFamily: 'Regular',
  fontSize: _DS.fs14,
  fontWeight: FontWeight.w500,
  color: isDark ? Colors.white : const Color(0xFF212529),
);

// ─────────────────────────────────────────────────────────────────────────────
// AUTH SCREEN TEXTS
// ─────────────────────────────────────────────────────────────────────────────
Widget loginText(String welcomeBack) {
  return Text(
    welcomeBack,
    style: const TextStyle(
      color: whiteColor,
      fontFamily: 'Bold',
      fontSize: _DS.fs28,
      letterSpacing: -0.5,
      height: 1.2,
    ),
  );
}

Widget loginSubText(String loginContinue) {
  return Text(
    loginContinue,
    style: TextStyle(
      color: Colors.white.withOpacity(0.65),
      fontSize: _DS.fs16,
      fontFamily: 'Regular',
      height: 1.4,
    ),
  );
}

Widget textFildHeader(String label, double width) {
  return Text(
    label,
    style: TextStyle(
      fontSize: width > 360 ? _DS.fs14 : _DS.fs13,
      color: subTextColor,
      fontFamily: 'Regular',
      fontWeight: FontWeight.w500,
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// TEXT FIELDS
// ─────────────────────────────────────────────────────────────────────────────

/// Auth screen text field (dark background — white text)
Widget customeTextFild(
    String? Function(String?) validateEmail,
    TextEditingController emailController,
    double width,
    String hintText,
    TextInputType textInputType,
    ) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(_DS.radiusMd),
      boxShadow: _DS.fieldShadow,
    ),
    child: TextFormField(
      validator: validateEmail,
      controller: emailController,
      keyboardType: textInputType,
      textInputAction: TextInputAction.done,
      style: _fieldTextStyle(isDark: true),
      cursorColor: whiteColor,
      decoration: _fieldDecoration(
        hintText: hintText,
        isDark: true,
      ),
    ),
  );
}

/// Auth screen password field
Widget customePasswordTextFild(
    String? Function(String?) validateName,
    TextEditingController passwordController,
    double width,
    String hintText,
    bool obscureText,
    VoidCallback toggle,
    ) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(_DS.radiusMd),
      boxShadow: _DS.fieldShadow,
    ),
    child: TextFormField(
      validator: validateName,
      controller: passwordController,
      obscureText: obscureText,
      textInputAction: TextInputAction.done,
      style: _fieldTextStyle(isDark: true),
      cursorColor: whiteColor,
      decoration: _fieldDecoration(
        hintText: hintText,
        isDark: true,
        suffixIcon: InkWell(
          onTap: toggle,
          borderRadius: BorderRadius.circular(30),
          child: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.white.withOpacity(0.65),
            size: 20,
          ),
        ),
      ),
    ),
  );
}

/// General editable text field (light background — dark text)
Widget editCustomTextField(
    String? Function(String?) validateEmail,
    TextEditingController controller,
    double width,
    String hintText, {
      TextInputType? textInputType,
      int? maxLen,
    }) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(_DS.radiusMd),
      boxShadow: _DS.fieldShadow,
    ),
    child: TextFormField(
      maxLength: maxLen,
      keyboardType: textInputType ?? TextInputType.text,
      validator: validateEmail,
      controller: controller,
      textCapitalization: TextCapitalization.words,
      style: _fieldTextStyle(),
      cursorColor: themeColor,
      decoration: _fieldDecoration(hintText: hintText),
    ),
  );
}

/// Read-only tap field (DOB style)
Widget dboTextField(
    String? Function(String?) validate,
    TextEditingController controller,
    double width, {
      VoidCallback? onTap,
    }) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(_DS.radiusMd),
      boxShadow: _DS.fieldShadow,
    ),
    child: TextFormField(
      readOnly: true,
      onTap: onTap,
      controller: controller,
      validator: validate,
      style: _fieldTextStyle(),
      cursorColor: themeColor,
      decoration: _fieldDecoration(
        hintText: 'Date Of Birth',
        suffixIcon: Padding(
          padding: const EdgeInsets.all(14),
          child: Image.asset(
            'assets/add_member/date.png',
            height: 20,
            width: 20,
            color: themeColor,
          ),
        ),
      ),
    ),
  );
}

/// Date picker field
Widget selectDateField(
    String? Function(String?) validate,
    TextEditingController controller,
    double width, {
      VoidCallback? onTap,
    }) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(_DS.radiusMd),
      boxShadow: _DS.fieldShadow,
    ),
    child: TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      validator: validate,
      style: _fieldTextStyle(),
      cursorColor: themeColor,
      decoration: _fieldDecoration(
        hintText: 'Select Date',
        fillColor: themeSecondaryColor,
        suffixIcon: Padding(
          padding: const EdgeInsets.all(14),
          child: Image.asset(
            'assets/add_member/date.png',
            height: 20,
            width: 20,
            color: themeColor,
          ),
        ),
      ),
    ),
  );
}

/// Time picker field
Widget selectTimeField(
    String? Function(String?) validate,
    TextEditingController controller,
    double width, {
      VoidCallback? onTap,
    }) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(_DS.radiusMd),
      boxShadow: _DS.fieldShadow,
    ),
    child: TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      validator: validate,
      style: _fieldTextStyle(),
      cursorColor: themeColor,
      decoration: _fieldDecoration(
        hintText: 'Select Time',
        fillColor: themeSecondaryColor,
        suffixIcon: Padding(
          padding: const EdgeInsets.all(14),
          child: Image.asset(
            'assets/cart/time.png',
            height: 20,
            width: 20,
            color: themeColor,
          ),
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// BUTTONS
// ─────────────────────────────────────────────────────────────────────────────

/// Primary filled button
Widget customeElevatedButton(
    double width,
    String label, {
      required VoidCallback callback,
    }) {
  return Container(
    width: width,
    height: _DS.btnHeight,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(_DS.radiusMd),
      gradient: LinearGradient(
        colors: [
          themeColor,
          themeColor.withOpacity(0.85),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      boxShadow: _DS.softShadow(themeColor),
    ),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_DS.radiusMd),
        ),
        minimumSize: Size(width, _DS.btnHeight),
        padding: EdgeInsets.zero,
      ),
      onPressed: callback,
      child: Text(
        label,
        style: const TextStyle(
          color: whiteColor,
          fontFamily: 'Bold',
          fontSize: _DS.fs18,
          letterSpacing: 0.3,
        ),
      ),
    ),
  );
}

/// Outline / secondary button
Widget customeElevatedButtonOutLine(
    double width,
    String label, {
      required VoidCallback callback,
      Color color = whiteColor,
      Color? textColor,
      Color? borderColor,
    }) {
  final border = borderColor ?? themeColor;
  final text   = textColor   ?? themeColor;

  return Container(
    width: width,
    height: _DS.btnHeight,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(_DS.radiusMd),
      boxShadow: _DS.fieldShadow,
    ),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_DS.radiusMd),
          side: BorderSide(color: border, width: 1.8),
        ),
        minimumSize: Size(width, _DS.btnHeight),
      ),
      onPressed: callback,
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontFamily: 'Bold',
          fontSize: _DS.fs18,
          letterSpacing: 0.3,
        ),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// APP BAR
// ─────────────────────────────────────────────────────────────────────────────
PreferredSizeWidget customeAppBar(String title) {
  return AppBar(
    backgroundColor: themeColor,
    elevation: 0,
    centerTitle: true,
    title: Text(
      title,
      style: const TextStyle(
        fontFamily: 'Bold',
        fontSize: _DS.fs18,
        color: whiteColor,
        letterSpacing: -0.3,
      ),
    ),
    iconTheme: const IconThemeData(color: whiteColor),
    bottom: PreferredSize(
      preferredSize: const Size.fromHeight(1),
      child: Container(
        height: 1,
        color: Colors.white.withOpacity(0.15),
      ),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// INFO GRID TILE
// ─────────────────────────────────────────────────────────────────────────────
Widget customeGrid(
    String gridImage,
    String label,
    String? value,
    ) {
  return Container(
    width: 82,
    decoration: BoxDecoration(
      color: whiteColor,
      borderRadius: BorderRadius.circular(_DS.radiusMd),
      boxShadow: [
        BoxShadow(
          color: themeColor.withOpacity(0.08),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(gridImage, height: 22, width: 22, fit: BoxFit.contain),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: subTextColor,
            fontFamily: 'Regular',
            fontSize: 8,
            height: 1.3,
          ),
          textAlign: TextAlign.center,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 3),
        Text(
          value ?? '—',
          style: TextStyle(
            color: themeColor,
            fontFamily: 'Bold',
            fontSize: _DS.fs12,
            fontWeight: FontWeight.w700,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// TEXT HELPERS
// ─────────────────────────────────────────────────────────────────────────────
Widget semiBoldText({
  dynamic text,
  double? size,
  Color? color,
  TextOverflow? textOverFlow,
  TextAlign? alignment,
  TextDecoration? decoration,
  int? maxLines,
}) {
  return Text(
    text is Map ? text[LANGUAGE_TYPE] : (text?.toString() ?? ''),
    style: TextStyle(
      fontSize: size,
      color: color ?? const Color(0xFF212529),
      fontWeight: FontWeight.w600,
      fontFamily: 'Semibold',
      decoration: decoration ?? TextDecoration.none,
      height: 1.4,
    ),
    textAlign: alignment ?? TextAlign.start,
    overflow: textOverFlow,
    maxLines: maxLines,
  );
}

Widget boldText({
  dynamic text,
  double? size,
  Color? color,
  TextOverflow? textOverFlow,
  TextAlign? alignment,
  TextDecoration? decoration,
  int? maxLines,
}) {
  return Text(
    text is Map ? text[LANGUAGE_TYPE] : (text?.toString() ?? ''),
    style: TextStyle(
      fontSize: size,
      color: color ?? const Color(0xFF212529),
      fontWeight: FontWeight.w700,
      fontFamily: 'Bold',
      decoration: decoration ?? TextDecoration.none,
      height: 1.4,
    ),
    textAlign: alignment ?? TextAlign.start,
    overflow: textOverFlow,
    maxLines: maxLines,
  );
}

Widget regularText({
  dynamic text,
  double? size,
  Color? color,
  TextOverflow? textOverFlow,
  TextAlign? alignment,
  TextDecoration? decoration,
  int? maxLines,
}) {
  return Text(
    text is Map ? text[LANGUAGE_TYPE] : (text?.toString() ?? ''),
    style: TextStyle(
      fontSize: size,
      color: color ?? subTextColor,
      fontWeight: FontWeight.w400,
      fontFamily: 'Regular',
      decoration: decoration ?? TextDecoration.none,
      height: 1.5,
    ),
    textAlign: alignment ?? TextAlign.start,
    overflow: textOverFlow,
    maxLines: maxLines,
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// SHARE FUNCTIONS — unchanged logic, cleaner null safety
// ─────────────────────────────────────────────────────────────────────────────
String get _storeUrl => Platform.isAndroid
    ? AppConfig.androidStoreUrl
    : AppConfig.iosStoreUrl;

Future<void> shareApp(Data? data) async {
  if (data == null) return;
  await Share.share('${data.shortDesc}\n\n$_storeUrl', subject: data.name);
}

Future<void> shareTestApp(TestDetailModelsList? data) async {
  if (data == null) return;
  await Share.share('${data.shortDesc}\n\n$_storeUrl', subject: data.profileName);
}

Future<void> shareProfileApp(ProfileModel? data) async {
  if (data == null) return;
  await Share.share('${data.shortDesc}\n\n$_storeUrl', subject: data.profileName);
}

Future<void> shareParamApp(ParameterModel? data) async {
  if (data == null) return;
  await Share.share('${data.shortDesc}\n\n$_storeUrl', subject: data.name);
}

Future<void> redirectToPlayStore() async {
  final uri = Uri.parse(_storeUrl);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    AppSnackbar.error('Failed', 'Could not open store');
  }
}