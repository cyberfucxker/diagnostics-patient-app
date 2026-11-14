// ignore_for_file: unnecessary_null_comparison

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:diagnostics_patient/Models/user_details_class.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/Screens/View/AuthScreen/login_screen.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';
import 'package:diagnostics_patient/controller/home_controller.dart';
import 'package:diagnostics_patient/controller/home_visit_controller.dart';
import '../../../Models/family_member_list_model.dart';
import '../../../componant/custome_appBar.dart';
import '../../../componant/validation_screen.dart';
import '../../../utils/AllText.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';

class AddHomeVisitScreen extends StatefulWidget {
  final bool isEdit;
  final Datum? data;

  const AddHomeVisitScreen({Key? key, this.isEdit = false, this.data})
      : super(key: key);

  @override
  State<AddHomeVisitScreen> createState() => _AddHomeVisitScreenState();
}

class _AddHomeVisitScreenState extends State<AddHomeVisitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _homeVisitCtrl = Get.put(HomeVisitController());

  UserDetailsClass _userDetails = UserDetailsClass();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.data != null) {
      _homeVisitCtrl.setData(widget.data!);
    }
    _getUserDetails();
  }

  Future<void> _getUserDetails() async {
    final data = await UserDetailsClass().getUserDetails();
    if (mounted) {
      setState(() {
        _userDetails = data;
        _isLoading  = false;
      });
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: Column(
        children: [
          CustomAppBar(
            title: widget.isEdit
                ? EDIT_HOME_VISIT[LANGUAGE_TYPE]
                : ADD_HOME_VISIT[LANGUAGE_TYPE],
            isArrow: true,
            isAction: false,
          ),
          Expanded(
            child: GetBuilder<HomeVisitController>(
              builder: (controller) {
                // ── Loading ───────────────────────────────────────────
                if (_isLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: themeColor),
                  );
                }

                // ── Not logged in ─────────────────────────────────────
                if (!_userDetails.isLoggedIn) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.lock_outline_rounded,
                            size: 48, color: themeColor),
                        const SizedBox(height: 14),
                        const Text(
                          'Please login to continue',
                          style: TextStyle(
                            fontFamily: 'Regular',
                            fontSize: 15,
                            color: subTextColor,
                          ),
                        ),
                        const SizedBox(height: 20),
                        customeElevatedButton(
                          180,
                          Login[LANGUAGE_TYPE],
                          callback: () => Get.to(() => LoginScreen(index: 2)),
                        ),
                      ],
                    ),
                  );
                }

                // ── Form ──────────────────────────────────────────────
                return Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Select Branch ─────────────────────────────
                        _buildSectionLabel('Select Branch',
                            Icons.business_outlined),
                        const SizedBox(height: 8),
                        _buildBranchDropdown(width),
                        const SizedBox(height: 20),

                        // ── Full Name ──────────────────────────────────
                        _buildSectionLabel(HINT_FULL_NAME[LANGUAGE_TYPE],
                            Icons.person_outline_rounded),
                        const SizedBox(height: 8),
                        editCustomTextField(
                          validateName,
                          controller.fullNameController,
                          width,
                          HINT_NAME[LANGUAGE_TYPE],
                        ),
                        const SizedBox(height: 20),

                        // ── Phone ──────────────────────────────────────
                        _buildSectionLabel(MOBILE_NO[LANGUAGE_TYPE],
                            Icons.phone_outlined),
                        const SizedBox(height: 8),
                        editCustomTextField(
                          validatePhone,
                          controller.mobileNumberController,
                          width,
                          HINT_PHONE[LANGUAGE_TYPE],
                          textInputType: TextInputType.number,
                          maxLen: 12,
                        ),
                        const SizedBox(height: 20),

                        // ── Email ──────────────────────────────────────
                        _buildSectionLabel(Email[LANGUAGE_TYPE],
                            Icons.email_outlined),
                        const SizedBox(height: 8),
                        editCustomTextField(
                          validateEmail,
                          controller.emailController,
                          width,
                          HINT_EMAIL[LANGUAGE_TYPE],
                          textInputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),

                        // ── Map ───────────────────────────────────────
                        _buildSectionLabel('Select Location on Map',
                            Icons.location_on_outlined),
                        const SizedBox(height: 8),
                        _buildMapSection(),
                        const SizedBox(height: 20),

                        // ── Address ────────────────────────────────────
                        _buildSectionLabel(ADDRESS[LANGUAGE_TYPE],
                            Icons.home_outlined),
                        const SizedBox(height: 8),
                        editCustomTextField(
                          validateAddress,
                          controller.tcAddress,
                          width,
                          ADDRESS[LANGUAGE_TYPE],
                        ),
                        const SizedBox(height: 20),

                        // ── House No + City ────────────────────────────
                        Row(children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionLabel(HOUSENO[LANGUAGE_TYPE],
                                    Icons.door_front_door_outlined),
                                const SizedBox(height: 8),
                                editCustomTextField(
                                  validateHousNo,
                                  controller.houseNoController,
                                  width,
                                  HOUSENO[LANGUAGE_TYPE],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionLabel(CITY[LANGUAGE_TYPE],
                                    Icons.location_city_outlined),
                                const SizedBox(height: 8),
                                editCustomTextField(
                                  validateCity,
                                  controller.cityController,
                                  width,
                                  CITY[LANGUAGE_TYPE],
                                ),
                              ],
                            ),
                          ),
                        ]),
                        const SizedBox(height: 20),

                        // ── State + Pincode ────────────────────────────
                        Row(children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionLabel(STATE[LANGUAGE_TYPE],
                                    Icons.map_outlined),
                                const SizedBox(height: 8),
                                editCustomTextField(
                                  validateState,
                                  controller.stateController,
                                  width,
                                  STATE[LANGUAGE_TYPE],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildSectionLabel(PINCODE[LANGUAGE_TYPE],
                                    Icons.pin_outlined),
                                const SizedBox(height: 8),
                                editCustomTextField(
                                  validatePinCode,
                                  controller.pinCodeController,
                                  width,
                                  PINCODE[LANGUAGE_TYPE],
                                ),
                              ],
                            ),
                          ),
                        ]),
                        const SizedBox(height: 32),

                        // ── Book Button ────────────────────────────────
                        controller.isSaveLoading
                            ? const Center(
                            child: CircularProgressIndicator())
                            : customeElevatedButton(
                          width,
                          'Book Home Visit',
                          callback: () {
                            if (_formKey.currentState!.validate()) {
                              controller.addHomeVisit();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // BRANCH DROPDOWN
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildBranchDropdown(double width) {
    return DropdownButtonFormField<String>(
      value: Get.find<HomeController>().selectedBranchName,
      validator: validateCity,
      isExpanded: true,
      icon: Icon(Icons.keyboard_arrow_down_rounded,
          color: themeColor, size: 22),
      dropdownColor: Colors.white,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: width > 360 ? 14 : 13,
        color: blackColor,
        fontFamily: 'Regular',
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: themeColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        hintStyle: TextStyle(
          color: Colors.grey.shade400,
          fontSize: 14,
          fontFamily: 'Regular',
        ),
      ),
      hint: const Text('Select Branch'),
      // _buildBranchDropdown mein ye change karo
      items: (Get.find<HomeController>()
          .getLabByCityNameModel
          .data ?? [])   // ✅ null safety
          .map((label) => DropdownMenuItem<String>(
        value: label.name,
        child: Text(
          label.name?.toString() ?? '',
          overflow: TextOverflow.ellipsis,
        ),
      ))
          .toList(),
      onChanged: (value) {
        Get.find<HomeController>().selectedBranchName = value;
        final selected = Get.find<HomeController>()
            .getLabByCityNameModel
            .data!
            .firstWhere((label) => label.name == value);
        Get.find<HomeController>().selectedBranchId = selected.id.toString();
        log('Selected Branch ID: ${Get.find<HomeController>().selectedBranchId}');
        log('Selected Branch Name: ${Get.find<HomeController>().selectedBranchName}');
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // MAP SECTION
  // scroll fix: _mapTouched flag — jab user map touch kare toh parent
  // scroll disable, ungli uthane pe wapas enable
  // ─────────────────────────────────────────────────────────────────────────
  bool _mapTouched = false;

  Widget _buildMapSection() {
    return GetBuilder<AddAddressController>(
      builder: (addrCtrl) {

        // ── center fallback ─────────────────────────────────────────────
        // addrCtrl.center null ho sakta hai agar location abhi tak nahi mili
        final center = addrCtrl.center ?? const LatLng(26.9124, 75.7873);

        return Container(
          height: 300,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // ── Google Map ──────────────────────────────────────
                // Listener se parent scroll aur map scroll alag karo
                Listener(
                  onPointerDown: (_) {
                    _mapTouched = true;
                  },
                  onPointerUp: (_) {
                    _mapTouched = false;
                  },
                  onPointerCancel: (_) {
                    _mapTouched = false;
                  },
                  child: GoogleMap(
                    onMapCreated: addrCtrl.onMapCreated,
                    scrollGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    tiltGesturesEnabled: false,
                    zoomControlsEnabled: false,
                    myLocationButtonEnabled: false,
                    compassEnabled: false,
                    buildingsEnabled: false,   // false = faster render
                    indoorViewEnabled: false,  // false = faster render
                    initialCameraPosition: CameraPosition(
                      target: center,
                      zoom: 15.0,
                    ),
                    onTap: (latLng) => addrCtrl.onMapTap(latLng),
                    // Controller ke markers use karo — custom icon already hai
                    markers: addrCtrl.markers.values.toSet(),
                  ),
                ),

                // ── Loading overlay — sirf tab jab map ready na ho ──
                if (addrCtrl.isGoogleMapLoading)
                  Container(
                    color: Colors.grey.shade200,
                    child: Center(
                      child: CircularProgressIndicator(color: themeColor),
                    ),
                  ),

                // ── Zoom + Location controls ────────────────────────
                Positioned(
                  right: 10,
                  bottom: 10,
                  child: Column(
                    children: [
                      _mapButton(
                        icon: Icons.add_rounded,
                        onTap: () => addrCtrl.mapController.animateCamera(
                          CameraUpdate.zoomIn(),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _mapButton(
                        icon: Icons.remove_rounded,
                        onTap: () => addrCtrl.mapController.animateCamera(
                          CameraUpdate.zoomOut(),
                        ),
                      ),
                      const SizedBox(height: 6),
                      _mapButton(
                        icon: Icons.my_location_rounded,
                        onTap: () async {
                          final pos = await addrCtrl.determinePosition();
                          if (pos != null) {
                            addrCtrl.mapController.animateCamera(
                              CameraUpdate.newLatLng(
                                LatLng(pos.latitude, pos.longitude),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _mapButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, size: 18, color: themeColor),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SECTION LABEL
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildSectionLabel(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 15, color: themeColor),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Regular',
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: blackColor,
          ),
        ),
      ],
    );
  }
}