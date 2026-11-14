// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:diagnostics_patient/Models/edit_profile_model.dart';
import 'package:diagnostics_patient/Models/user_details_class.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custom_dialogue.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/page_widget.dart';
import 'package:diagnostics_patient/componant/custome_appBar.dart';
import 'package:diagnostics_patient/controller/test_detail_controller.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/widgets/custom_snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../componant/validation_screen.dart';
import '../../../utils/AllText.dart';
import '../../../utils/api.dart';
import '../../../utils/strings.dart';
import '../../Custome_Widgets/custome_widget.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController  = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  UserDetailsClass _userDetails = UserDetailsClass();
  EditProfileModel? _editProfileModel;
  String? _imagePath;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserDetails() async {
    final data = await UserDetailsClass().getUserDetails();
    if (!mounted) return;
    setState(() {
      _userDetails = data;
      if (data.isLoggedIn) {
        _nameController.text  = data.name  ?? '';
        _phoneController.text = data.phone?.toString() ?? '';
        // ✅ FIX: emailController se le lo — userDetails.email se nahi
        _emailController.text = data.email ?? '';
      }
    });
  }

  Future<void> _pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (!mounted) return;
    setState(() {
      _imagePath = result?.files.single.path;
    });
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        children: [
          CustomAppBar(
            title: Edit_Profile[LANGUAGE_TYPE],
            isArrow: true,
            isAction: false,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // ── Header with profile image ────────────────────────
                    _buildHeader(),

                    const SizedBox(height: 15),

                    // ── Form fields ──────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          textFildHeader(Enter_Name[LANGUAGE_TYPE], width),
                          editCustomTextField(
                              validateName, _nameController, width, "DeoJohan"),
                          const SizedBox(height: 15),

                          textFildHeader(Email[LANGUAGE_TYPE], width),
                          editCustomTextField(
                              validateEmail, _emailController, width,
                              "user@example.com"),
                          const SizedBox(height: 15),

                          textFildHeader(Phone_Number[LANGUAGE_TYPE], width),
                          editCustomTextField(
                              validatePhone, _phoneController, width,
                              "Phone number", maxLen: 12),
                          const SizedBox(height: 19),

                          // ── Save button ──────────────────────────────
                          _isLoading
                              ? const Center(
                              child: CircularProgressIndicator(
                                  color: themeColor))
                              : customeElevatedButton(
                              width, Save[LANGUAGE_TYPE],
                              callback: _validateAndSave),

                          const SizedBox(height: 15),

                          // ── Delete button ────────────────────────────
                          customeElevatedButton(
                            width, Delete_Account[LANGUAGE_TYPE],
                            callback: _showDeleteDialog,
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header widget ──────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      height: 220,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/login/bg.png"),
          fit: BoxFit.fill,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),

            // Profile image
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: _imagePath != null
                          ? FileImage(File(_imagePath!)) as ImageProvider
                          : (_userDetails.profile?.isNotEmpty == true
                          ? NetworkImage(_userDetails.profile!)
                          : const AssetImage("assets/home/profile.png"))
                      as ImageProvider,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: Image.asset("assets/profile/camera.png", height: 26),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              _userDetails.name ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontFamily: "Bold",
                color: whiteColor,
              ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  // ── Validate and save ──────────────────────────────────────────────────────
  void _validateAndSave() {
    if (_imagePath == null &&
        (_userDetails.profile == null || _userDetails.profile!.isEmpty)) {
      showCustomDialog(
        title: ALERT,
        context: context,
        msg: IMAGE_PATH_CANNOT_BE_EMPTY,
        btnYesText: OK,
        onPressedBtnYes: () => Navigator.pop(context),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      _updateProfile();
    }
  }

  // ── Delete dialog ──────────────────────────────────────────────────────────
  void _showDeleteDialog() {
    showCustomDialog(
      context: context,
      title: ALERT[LANGUAGE_TYPE],
      msg: Delete_account_desc[LANGUAGE_TYPE],
      btnYesText: YES_PROCEED[LANGUAGE_TYPE],
      onPressedBtnYes: () async => await _deleteAccount(),
      onPressedButtonNo: () => Navigator.pop(context),
      btnNoText: NO_WAIT[LANGUAGE_TYPE],
    );
  }

  // ── Delete account API ─────────────────────────────────────────────────────
  Future<void> _deleteAccount() async {
    try {
      final response = await http.post(
        Uri.parse('$SERVER_ADDRESS/$deleteMyAccount'),
        body: {'user_id': _userDetails.userId.toString()},
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Get.back();
        if (data['status'] == 1) {
          AppSnackbar.success("Success", data['msg']);
          await _userDetails.removeAllUserDetails();
          Get.find<TestDetailController>().getUserDetails();
          Navigator.popUntil(context, (route) => route.isFirst);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => PagesWidget()));
        }
      }
    } catch (e) {
      debugPrint('_deleteAccount error: $e');
    }
  }

  // ── Update profile API ─────────────────────────────────────────────────────
  Future<void> _updateProfile() async {
    setState(() => _isLoading = true);

    showLoadingMsg(
      context: context,
      msg: PLEASE_WAIT_WHILE_UPDATING_PROFILE,
      title: UPDATING,
    );

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$SERVER_ADDRESS/edit_profile'),
      );

      // ✅ FIX: email ab _emailController.text se ja rahi hai
      //    Pehle userDetails.email ja rahi thi jo empty thi
      request.fields.addAll({
        'id':    _userDetails.userId.toString(),
        'name':  _nameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'email': _emailController.text.trim(), // ✅ FIX
      });

      debugPrint('📤 Update profile fields: ${request.fields}');

      if (_imagePath != null) {
        request.files.add(
          await http.MultipartFile.fromPath('image', _imagePath!),
        );
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        final jsonStr      = await response.stream.bytesToString();
        final jsonResponse = json.decode(jsonStr);

        debugPrint('📥 Update profile response: $jsonResponse');

        Navigator.pop(context); // close loading

        if (jsonResponse['status'] == 1) {
          _editProfileModel = EditProfileModel.fromJson(jsonResponse);

          await _userDetails.setUserDetails(
            isLoggedIn: true,
            name:    _nameController.text.trim(),
            phone:   int.tryParse(_phoneController.text.trim()) ?? 0,
            email:   _editProfileModel!.data!.email.toString(),
            profile: _editProfileModel!.data!.profilePic.toString(),
            userId:  _editProfileModel!.data!.id!.toInt(),
            pass:    _userDetails.pass ?? '',
          );

          if (mounted) {
            AppSnackbar.success(
              "Success",
              "Profile updated successfully",
            );
            Navigator.pop(context, true);
          }
        } else {
          showCustomDialog(
            context: context,
            title: ALERT,
            msg: jsonResponse['msg'] ?? 'Something went wrong',
            btnYesText: OK,
            onPressedBtnYes: () => Navigator.pop(context),
          );
        }
      } else {
        Navigator.pop(context); // close loading
        showCustomDialog(
          context: context,
          title: ALERT,
          msg: response.reasonPhrase ?? 'Server error',
          btnYesText: OK,
          onPressedBtnYes: () => Navigator.pop(context),
        );
      }
    } catch (e) {
      Navigator.pop(context); // close loading
      debugPrint('_updateProfile error: $e');
      showCustomDialog(
        context: context,
        title: ALERT,
        msg: 'Something went wrong. Please try again.',
        btnYesText: OK,
        onPressedBtnYes: () => Navigator.pop(context),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}