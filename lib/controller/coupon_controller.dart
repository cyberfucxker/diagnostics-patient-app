// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/coupon_model.dart';
import 'package:http/http.dart' as http;
import 'package:diagnostics_patient/Models/user_details_class.dart';
import '../utils/api.dart';
import '../utils/colors.dart';

class CouponController extends GetxController {
  UserDetailsClass userDetails = UserDetailsClass();
  bool isLoading        = true;
  bool isWalletLoading  = false; // ✅ ab sirf wallet widget ke liye
  bool isButtonLoading  = false;
  bool isDataNotFound   = false;
  CouponModel? couponModel;
  List<CouponListModel> couponList = [];
  List<CouponListModel> data = <CouponListModel>[].obs;

  CouponListModel? getCouponCodeModel;
  int wallet_cashback_point = 0;
  double? walletAmount;

  @override
  void onInit() {
    super.onInit();
    init();
  }

  Future<void> init() async {
    await getUserDetails();
    getCouponList();
    await getWalletSetting();
    // ✅ FIX: wallet amount fetch alag se — isLoading affect nahi karega
    // Cart shimmer sirf CartDetailController.isLoading pe depend karta hai
    getWalletAmounts();
  }

  void setLoadingTrue() {
    isLoading = true;
    update();
  }

  Future<void> getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
  }

  Future<void> getCouponList() async {
    isDataNotFound = false;
    couponList.clear();
    try {
      final response = await http.get(Uri.parse(baseUrl + getCoupon));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          couponModel = CouponModel.fromJson(jsonResponse);
          couponList.addAll(couponModel!.data);
          isDataNotFound = false;
        } else {
          isDataNotFound = true;
        }
        isLoading = false;
        update();
      }
    } catch (e) {
      isDataNotFound = true;
      isLoading = false;
      update();
    }
  }

  // ✅ FIX: wallet fetch karo — isWalletLoading sirf wallet widget
  //    mein dikhao, cart ka main shimmer/loader affect nahi hoga
  Future<void> getWalletAmounts() async {
    // ✅ isWalletLoading = true — sirf wallet section mein loading dikhao
    isWalletLoading = true;
    update(['wallet']); // sirf wallet widget rebuild karo

    try {
      final response = await http.get(
        Uri.parse(baseUrl + "get_user_wallet?user_id=${userDetails.userId}"),
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          walletAmount = double.tryParse(
            jsonResponse['data']['wallet_amount'].toString(),
          );
        }
      }
    } catch (e) {
      debugPrint('getWalletAmounts error: $e');
    } finally {
      // ✅ FIX: finally mein false karo — exception pe bhi loading band ho
      isWalletLoading = false;
      update(['wallet']); // sirf wallet section rebuild
    }
  }

  Future<void> getWalletSetting() async {
    try {
      final response =
      await http.get(Uri.parse(baseUrl + getWalletSettingUrl));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          wallet_cashback_point = int.tryParse(
            jsonResponse['data']['wallet_cashback_point'].toString(),
          ) ??
              0;
        }
        update();
      }
    } catch (e) {
      debugPrint('getWalletSetting error: $e');
    }
  }
}