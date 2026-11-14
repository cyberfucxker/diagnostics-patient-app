// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/coupon_model.dart';
import 'package:diagnostics_patient/Models/local_package_detail_model.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custom_dialogue.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';
import 'package:diagnostics_patient/controller/checkout_controller.dart';
import 'package:diagnostics_patient/controller/coupon_controller.dart';
import 'package:diagnostics_patient/widgets/custom_snackbar.dart'; // ✅ AppSnackbar import

import '../Models/cart_list_model.dart';
import '../Models/local_user_model.dart';
import '../Models/user_details_class.dart';
import '../Services/database.dart';
import 'package:http/http.dart' as http;

import '../utils/api.dart';
import '../utils/colors.dart';

class CartDetailController extends GetxController {
  bool isLoading = true;
  bool isDataNotFound = false;
  bool isCartEmpty = false;
  UserDetailsClass userDetails = UserDetailsClass();
  final dbHelper = DatabaseHelper.instance;
  List<CartUserPackageDetailModel> cartUserPackageDetailModel = [];
  final couponController = Get.put(CouponController());
  TextEditingController walletPointController = TextEditingController();
  CartListModel cartListModel = CartListModel();
  double subTotal = 0;
  double subTotals = 0;
  int tax = 0;
  CartData cartObjData = CartData();
  List<CouponListModel> couponList = [];
  double total = 0;
  double saving = 0;
  double coupon = 0;
  double walletPoint = 0;
  double discount = 0;
  CouponListModel? appliedCoupon;
  int? couponId;
  final addressController = Get.find<AddAddressController>();

  @override
  void onInit() {
    super.onInit();
  }

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
    if (userDetails.isLoggedIn) {
      fetchCartList();
    } else {
      isLoading = false;
    }
    update();
  }

  RxBool isLoadValiateCoupen = false.obs;
  RxBool isCoupenApplied = false.obs;
  RxString coupenMSg = "".obs;

  Future validateCoupon({
    String couponCode = '',
    bool isFromCoupenList = false,
    CouponListModel? couponData,
    required CartData cartInfo,
  }) async {
    isLoadValiateCoupen.value = true;
    isCoupenApplied.value = false;
    coupenMSg.value = '';
    log("--- validateCoupon ---");
    try {
      if (isFromCoupenList) {
        showOnlyLoaderDialog(Get.context);
      }

      final Map<String, String> bodyParams = {
        'user_id': "${userDetails.userId ?? 0}",
        'code': couponCode,
        'subtotal': "${subTotals}",
      };

      if (addressController.selectedDropdownValue != null) {
        bodyParams['city'] = addressController.selectedDropdownValue ?? "";
      }
      if (addressController.center?.latitude != null) {
        bodyParams['lat'] = "${addressController.center!.latitude}";
      }
      if (addressController.center?.longitude != null) {
        bodyParams['lng'] = "${addressController.center!.longitude}";
      }
      bodyParams['test_json'] = jsonEncode({
        "Testdata": cartInfo.cart
            .map((e) => {
          "member_id": e.memberId ?? 0,
          "items": e.testdata
              .map((iData) => {
            "id": iData.typeId,
            "type": iData.type,
            "parameter": iData.parameter,
            "mrp": iData.mrp ?? 0.0,
            "price": iData.price ?? 0.0,
          })
              .toList(),
        })
            .toList(),
      });

      final uri = Uri.parse(baseUrl + validateCouponUrlV2);
      log("--- POST API URI :: $uri");
      log("--- validateCoupon POST Body :: ${jsonEncode(bodyParams)}");

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(bodyParams),
      );

      if (isFromCoupenList) hideLoader(Get.context!);

      print("Coupon Validation: ${response.statusCode} ${response.body}");

      var fetchMap =
      response.body.trim().isNotEmpty ? jsonDecode(response.body) : {};
      if (fetchMap is Map) {
        coupenMSg.value = fetchMap['msg'] ?? "";
      }

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == "1") {
          coupon = jsonResponse['discount'] != null
              ? double.tryParse(jsonResponse['discount'].toString()) ?? 0.0
              : 0.0;

          if (total > 0) {
            total = total - coupon;
            if (coupon > 0.0) {
              isCoupenApplied.value = true;
            }
          }

          if (couponData != null) {
            Get.find<CheckoutController>().couponController.text =
            couponData.couponCode!;
          } else {
            Get.find<CheckoutController>().couponController.text = couponCode;
          }

          if (isFromCoupenList) Get.back(result: couponData);
        } else if (jsonResponse['status'] == "0") {
          if (isFromCoupenList) Get.back();
        } else {
          // ✅ was: Get.snackbar("Error", "Coupon not valid", ...)
          AppSnackbar.error('Invalid Coupon', 'This coupon code is not valid.');
          if (isFromCoupenList) Get.back();
        }
        update();
      }

      isLoadValiateCoupen.value = false;
    } catch (e) {
      isLoadValiateCoupen.value = false;
      print('Exception: validateCoupon() — $e');
    }
  }

  fetchCartList() async {
    log("--- fetchCartList START ---");

    cartListModel = CartListModel.fromJson({});
    subTotal = 0;
    saving = 0;
    tax = 0;
    isDataNotFound = false;
    isCartEmpty = false;
    isLoading = true;
    update();

    try {
      if (addressController.center == null) {
        log("❌ addressController.center is NULL");
        // ✅ was: Get.snackbar("Error", "Location not found...", ...)
        AppSnackbar.error(
          'Location Not Found',
          'Please select your address to continue.',
        );
        isLoading = false;
        update();
        return;
      }

      final queryParams = <String, String>{
        'user_id': '${userDetails.userId}',
        'city': addressController.selectedDropdownValue ?? "",
        'lat': addressController.center!.latitude.toString(),
        'lng': addressController.center!.longitude.toString(),
      };

      final uri = Uri.parse(baseUrl + getCartListV2)
          .replace(queryParameters: queryParams);
      log("--- fetchCartList URI: $uri");

      final response = await http.get(uri);
      log("--- Status: ${response.statusCode}");
      log("--- Body: ${response.body}");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == 1) {
          double subtotalAmount = 0;
          double finaltotalAmount = 0;
          double disctotalAmount = 0;

          cartListModel = CartListModel.fromJson(jsonResponse);

          for (var cart in cartListModel.data.cart) {
            for (var test in cart.testdata) {
              final double mrp = test.mrp ?? 0.0;
              final double discFixed = test.discount.fixed;
              finaltotalAmount += mrp - discFixed;
              subtotalAmount += mrp;
              disctotalAmount += discFixed;
            }
          }

          tax = cartListModel.data.txt;
          cartObjData = cartListModel.data;
          subTotals = subtotalAmount;
          subTotal = finaltotalAmount;
          discount = disctotalAmount;

          recalculateTotal();

          isCartEmpty = false;
          isLoading = false;
          update();
        } else if (jsonResponse['status'] == 0) {
          isCartEmpty = true;
          isLoading = false;
          update();
        } else {
          log("❌ Unexpected status: ${jsonResponse['status']}");
          // ✅ was: Get.snackbar("Error", "Data not found", ...)
          AppSnackbar.error('Not Found', 'No cart data found. Please try again.');
          isDataNotFound = true;
          isLoading = false;
          update();
        }
      } else {
        log("❌ HTTP ${response.statusCode}");
        // ✅ was: Get.snackbar("Error", "Server error: ...", ...)
        AppSnackbar.error(
          'Server Error',
          'Something went wrong (${response.statusCode}). Please try again.',
        );
        isDataNotFound = true;
        isLoading = false;
        update();
      }
    } catch (e, stack) {
      log("❌ EXCEPTION: $e\n$stack");
      // ✅ was: Get.snackbar("Failed to load Data", "Something went wrong...", ...)
      AppSnackbar.error(
        'Failed to Load',
        'Could not load cart. Please check your connection.',
      );
      isDataNotFound = true;
      isLoading = false;
      update();
    }

    isLoading = false;
    update();
    log("--- fetchCartList END ---");
  }

  deletePackage(Testdatum data, memberId) async {
    isLoading = true;
    update();
    try {
      final response = await http.get(Uri.parse(
        baseUrl +
            updateCart +
            '?user_id=${userDetails.userId}'
                '&member_id=$memberId'
                '&cart_id=${data.cartId}'
                '&type_id=${data.typeId}'
                '&type=${data.type}'
                '&parameter=${data.parameter}'
                '&action=1',
      ));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          Get.find<CheckoutController>().couponController.text = '';
          coupon = 0;
          await fetchCartList();
        } else {
          // ✅ was: Get.snackbar("Error", "data not found", ...)
          AppSnackbar.error('Error', 'Could not remove item. Please try again.');
          isLoading = false;
          update();
        }
      }
    } catch (e) {
      // ✅ was: Get.snackbar("Failed to load Data", "Something went wrong...", ...)
      AppSnackbar.error('Failed', 'Something went wrong. Please try again.');
      isLoading = false;
      update();
    }
  }

  fetCartPackageDetailFromLocal() async {
    cartUserPackageDetailModel.clear();
    isLoading = true;
    update();

    List<LocalUserModel> userData = await dbHelper.userModelQueryAll();
    List<LocalPackageModel> packageData = await dbHelper.packageModelQueryAll();

    for (var user in userData) {
      List<LocalPackageModel> userPackage = [];
      for (var package in packageData) {
        if (package.userId == user.userId) {
          userPackage.add(package);
        }
      }
      if (userPackage.isNotEmpty) {
        cartUserPackageDetailModel.add(CartUserPackageDetailModel(
          localUserModel: user,
          localPackageDetail: userPackage,
        ));
      }
    }
    isLoading = false;
    update();
  }

  void deletePackageFromCart({
    required packageId,
    required packageType,
    required userId,
  }) async {
    fetCartPackageDetailFromLocal();
  }

  void queryAllUserList() async {
    var allRows = await dbHelper.userQueryAll();
    allRows.forEach((row) {});
  }

  void queryAllPackageList() async {
    var allRows = await dbHelper.packageQueryAll();
    allRows.forEach((row) {});
  }

  // ── Wallet state ──────────────────────────────────────────────────────────
  bool isWalletApplied = false;
  double _originalWalletBalance = 0;

  void recalculateTotal() {
    total = subTotal - coupon - walletPoint;
    if (total < 0) total = 0;
    saving = discount + coupon + walletPoint;
    update();
  }

  void removeCoupon() {
    coupon = 0.0;
    recalculateTotal();
    update();
  }

  void applyWallet(CouponController couponCtrl) {
    debugPrint('🔴 applyWallet called');
    final text = walletPointController.text.trim();

    if (text.isEmpty) {
      // ✅ was: Get.snackbar('Warning', 'Please enter wallet amount', ...)
      AppSnackbar.warning('Wallet', 'Please enter a wallet amount to apply.');
      return;
    }

    final double entered = double.tryParse(text) ?? 0;
    if (entered <= 0) {
      // ✅ was: Get.snackbar('Warning', 'Please enter a valid amount', ...)
      AppSnackbar.warning('Invalid Amount', 'Please enter a valid wallet amount.');
      return;
    }

    final double available = couponCtrl.walletAmount ?? 0;
    if (available <= 0) {
      // ✅ was: Get.snackbar('Warning', 'Insufficient wallet balance', ...)
      AppSnackbar.warning('Insufficient Balance', 'Your wallet balance is too low.');
      return;
    }

    if (entered > available) {
      // ✅ was: Get.snackbar('Warning', 'Amount exceeds wallet balance (₹$available)', ...)
      AppSnackbar.warning(
        'Exceeds Balance',
        'You only have ₹${available.toStringAsFixed(2)} in your wallet.',
      );
      return;
    }

    _originalWalletBalance = couponCtrl.walletAmount!;

    walletPoint = couponCtrl.wallet_cashback_point > 0
        ? entered / couponCtrl.wallet_cashback_point
        : entered;

    couponCtrl.walletAmount = available - entered;
    isWalletApplied = true;
    couponCtrl.update(['wallet']);
    recalculateTotal();

    // ✅ was: Get.snackbar('Success', 'Wallet ₹... applied', ...)
    AppSnackbar.success(
      'Wallet Applied',
      '₹${entered.toStringAsFixed(2)} has been applied to your order.',
    );
  }

  void removeWallet(CouponController couponCtrl) {
    debugPrint('🔴 removeWallet called');

    walletPoint = 0.0;
    isWalletApplied = false;
    walletPointController.clear();

    if (_originalWalletBalance > 0) {
      couponCtrl.walletAmount = _originalWalletBalance;
      _originalWalletBalance = 0;
    }

    couponCtrl.update(['wallet']);
    recalculateTotal();

    // ✅ was: Get.snackbar('Removed', 'Wallet points removed', ...)
    AppSnackbar.info('Wallet Removed', 'Wallet points have been removed from your order.');
  }
}

class CartUserPackageDetailModel {
  LocalUserModel localUserModel;
  List<LocalPackageModel> localPackageDetail;

  CartUserPackageDetailModel({
    required this.localUserModel,
    required this.localPackageDetail,
  });
}