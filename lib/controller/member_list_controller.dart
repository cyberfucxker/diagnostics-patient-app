import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/local_package_detail_model.dart';
import 'package:diagnostics_patient/Services/database.dart';
import 'package:diagnostics_patient/controller/cart_detail_controller.dart';

import 'package:diagnostics_patient/controller/coupon_controller.dart';

import '../Models/family_member_list_model.dart';
import 'package:http/http.dart' as http;

import '../Models/user_details_class.dart';
import '../Screens/Custome_Widgets/page_widget.dart';
import '../utils/api.dart';
import '../utils/colors.dart';

class MemberListClass extends GetxController {
  bool isLoading = true;
  bool isButtonLoading = false;
  bool isDataNotFound = false;
  FamilyMemberListModel? familyMemberListModel;
  List<Datum> familyMemberList = [];
  List<Datum> selectedMemberList = [];

  UserDetailsClass userDetails = UserDetailsClass();

  @override
  void onInit() {
    super.onInit();
    init();
  }

  init() async {
    Get.put(CartDetailController());
    await getUserDetails();
    getFamilyMemberList(isNew: false);
  }

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
  }

  deleteMember({required int memberId}) async {
    isLoading = true;
    update();
    try {
      final response =
          await http.get(Uri.parse(baseUrl + "$deleteMemberApi?id=$memberId"));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          getFamilyMemberList(isNew: false);
          Get.snackbar(
            "Success",
            "${jsonResponse['msg']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
          );
          // isLoading = false;
          update();
        } else {
          Get.snackbar(
            "Error",
            "data not found",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: redColor,
          );
          isLoading = false;
          update();
          //   throw Exception('Failed to load Data');
        }
      }
    } catch (e) {
      Get.snackbar(
        "Failed to load Data",
        "Something went wrong. Try again,",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: redColor,
      );
      isLoading = false;
      update();
    }
  }

  setLoadingTrue() {
    isLoading = true;
    update();
  }

  // getFamilyMemberList() async {
  //   isDataNotFound = false;
  //   familyMemberList.clear();
  //   try {
  //     final response = await http.get(Uri.parse(baseUrl + getMemberList + '?id=${userDetails.userId}'));
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       if (jsonResponse['status'] == 1) {
  //         familyMemberListModel = FamilyMemberListModel.fromJson(jsonResponse);
  //         familyMemberList.addAll(familyMemberListModel!.data!);
  //         if (familyMemberList.isNotEmpty) {
  //           familyMemberList[0].isSelected = true;
  //         }
  //         isDataNotFound = false;
  //         isLoading = false;
  //         update();
  //       } else if (jsonResponse['status'] == 0) {
  //         isDataNotFound = true;
  //         isLoading = false;
  //         update();
  //       } else {
  //         Get.snackbar(
  //           "Error",
  //           "data not found",
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: redColor,
  //         );
  //         isDataNotFound = true;
  //         isLoading = false;
  //         update();
  //         //   throw Exception('Failed to load Data');
  //       }
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       "Failed to load Data",
  //       "Something went wrong. Try again,",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: redColor,
  //     );
  //     isDataNotFound = true;
  //     isLoading = false;
  //     update();
  //   }
  // }

  getFamilyMemberList({String? newMemberId, bool? isNew}) async {
    isDataNotFound = false;
    familyMemberList.clear();
    try {
      final response = await http.get(
          Uri.parse(baseUrl + getMemberList + '?id=${userDetails.userId}'));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          familyMemberListModel = FamilyMemberListModel.fromJson(jsonResponse);
          familyMemberList.addAll(familyMemberListModel!.data!);
          if (newMemberId != null) {
            final newMember = familyMemberList
                .firstWhere((element) => element.id == newMemberId);
            newMember.isSelected = true;
            familyMemberList.forEach((element) {
              if (element.id != newMemberId) {
                element.isSelected = false;
              }
            });
          } else {
            if (isNew != null && isNew) {
              familyMemberList[0].isSelected = false;
              familyMemberList.last.isSelected = true;
            } else {
              familyMemberList[0].isSelected = true;
            }
            // if (familyMemberList.isNotEmpty) {
            //   familyMemberList[0].isSelected = true;
            // }
          }
          isDataNotFound = false;
          isLoading = false;
          update();
        } else if (jsonResponse['status'] == 0) {
          isDataNotFound = true;
          isLoading = false;
          update();
        } else {
          Get.snackbar(
            "Error",
            "data not found",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: redColor,
          );
          isDataNotFound = true;
          isLoading = false;
          update();
          //   throw Exception('Failed to load Data');
        }
      }
    } catch (e) {
      Get.snackbar(
        "Failed to load Data",
        "Something went wrong. Try again,",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: redColor,
      );
      isDataNotFound = true;
      isLoading = false;
      update();
    }
  }

  selectMember(int index, bool isSelected) {
    familyMemberList[index].isSelected = isSelected;
    update();
  }

  final dbHelper = DatabaseHelper.instance;

  // addToCart(LocalPackageModel localPackageModel) async {
  //   selectedMemberList.clear();
  //   List<int> selecteIdList = [];
  //   for (var data in familyMemberList) {
  //     if (data.isSelected!) {
  //       selectedMemberList.add(data);
  //       selecteIdList.add(data.id!);
  //     }
  //   }
  //   if (selectedMemberList.isEmpty) {
  //     Get.snackbar(
  //       "Select Member",
  //       "It is mandatory to select at least one member to add to cart",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: redColor,
  //     );
  //     return;
  //   }

  //   String selectIdListString = selecteIdList.toString().replaceAll('[', '').replaceAll(']', '').removeAllWhitespace;

  //   isButtonLoading = true;
  //   update();
  //   try {
  //     final response = await http.get(Uri.parse(baseUrl + "$updaetCart?user_id=${userDetails.userId.toString()}&member_id=$selectIdListString&type_id=${localPackageModel.id}&type=${localPackageModel.packageType}&parameter=${localPackageModel.packageParameters}&action=0"));
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       if (jsonResponse['status'] == 1) {
  //         Get.put(CartDetailController()).coupon = 0;
  //         Get.put(CartDetailController()).update();
  //         Get.put(CartDetailController()).walletPoint = 0;
  //         Get.put(CartDetailController()).update();
  //         Get.put(CouponController()).getWalletAmounts();
  //         Get.offAll(() => PagesWidget(
  //               selectedIndex: 3,
  //             ));
  //         Get.snackbar(
  //           "Success",
  //           "${jsonResponse['msg']}",
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: Colors.green,
  //         );
  //         isButtonLoading = false;
  //         update();
  //       } else {
  //         Get.snackbar(
  //           "Error",
  //           "data not found",
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: redColor,
  //         );
  //         isButtonLoading = false;
  //         update();
  //         //   throw Exception('Failed to load Data');
  //       }
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       "Failed to load Data",
  //       "Something went wrong. Try again,",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: redColor,
  //     );
  //     isButtonLoading = false;
  //     update();
  //   }
  // }
  // bool isAlreadyCheckout = false;

  // addToCart(LocalPackageModel localPackageModel) async {
  //   selectedMemberList.clear();
  //   List<int> selecteIdList = [];
  //   for (var data in familyMemberList) {
  //     if (data.isSelected!) {
  //       selectedMemberList.add(data);
  //       selecteIdList.add(data.id!);
  //     }
  //   }

  //   if (selectedMemberList.isEmpty) {
  //     Get.snackbar(
  //       "Select Member",
  //       "It is mandatory to select at least one member to add to cart",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: redColor,
  //     );
  //     return;
  //   }

  //   // Step 1: Check if the product is already added to the cart for the selected members
  //   // var cartController = Get.put(CartDetailController());
  //   // for (var memberId in selecteIdList) {
  //   //   bool alreadyInCart = cartController.cartListModel?.data?.cart?.any((cartItem) => cartItem.memberId == memberId && cartItem.testdata!.any((testItem) => testItem.typeId == localPackageModel.id)) ?? false;

  //   //   if (alreadyInCart) {
  //   //     Get.snackbar(
  //   //       "Warning",
  //   //       "Please select different member for this package.",
  //   //       snackPosition: SnackPosition.BOTTOM,
  //   //       backgroundColor: Colors.red,
  //   //     );
  //   //     return;
  //   //   }
  //   // }
  //   var cartController = Get.put(CartDetailController());
  //   for (var memberId in selecteIdList) {
  //     bool alreadyInCart = cartController.cartListModel?.data?.cart?.any((cartItem) => cartItem.memberId == memberId && cartItem.testdata!.any((testItem) => testItem.typeId == localPackageModel.id)) ?? false;

  //     if (alreadyInCart) {
  //       isAlreadyCheckout = true;
  //       break;
  //     }
  //   }

  //   if (isAlreadyCheckout) {
  //     Get.snackbar(
  //       "Warning",
  //       "You have already checkout with this package and member.",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //     );
  //     return;
  //   }

  //   // Proceed with adding to cart
  //   String selectIdListString = selecteIdList.toString().replaceAll('[', '').replaceAll(']', '').removeAllWhitespace;

  //   isButtonLoading = true;
  //   update();

  //   try {
  //     final response = await http.get(Uri.parse(baseUrl + "$updaetCart?user_id=${userDetails.userId.toString()}&member_id=$selectIdListString&type_id=${localPackageModel.id}&type=${localPackageModel.packageType}&parameter=${localPackageModel.packageParameters}&action=0"));
  //     if (response.statusCode == 200) {
  //       final jsonResponse = jsonDecode(response.body);
  //       if (jsonResponse['status'] == 1) {
  //         cartController.coupon = 0;
  //         cartController.update();
  //         // cartController.walletPoint = 0;
  //         cartController.update();
  //         Get.put(CouponController()).getWalletAmounts();
  //         Get.offAll(() => PagesWidget(selectedIndex: 3));
  //         Get.snackbar(
  //           "Success",
  //           "${jsonResponse['msg']}",
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: Colors.green,
  //         );
  //       } else {
  //         Get.snackbar(
  //           "Error",
  //           "data not found",
  //           snackPosition: SnackPosition.BOTTOM,
  //           backgroundColor: redColor,
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       "Failed to load Data",
  //       "Something went wrong. Try again,",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: redColor,
  //     );
  //   } finally {
  //     isButtonLoading = false;
  //     update();
  //   }
  // }

  addToCart(LocalPackageModel localPackageModel) async {
    var cartController = Get.find<CartDetailController>();
    log("Fetching latest cart...");
    // await cartController.fetchCartList();
    log("Cart refreshed: ${cartController.cartListModel?.data?.cart?.length}");
    selectedMemberList.clear();
    List<int> selecteIdList = [];
    for (var data in familyMemberList) {
      if (data.isSelected!) {
        selectedMemberList.add(data);
        selecteIdList.add(data.id!);
      }
    }

    if (selectedMemberList.isEmpty) {
      Get.snackbar(
        "Select Member",
        "It is mandatory to select at least one member to add to cart",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: redColor,
      );
      return;
    }

    bool isAlreadyCheckout = false;

    // Step 1: Check if the product is already added to the cart for the selected members
    // var cartController = Get.put(CartDetailController());

    for (var memberId in selecteIdList) {
      bool alreadyInCart =
          cartController.cartListModel?.data?.cart?.any((cartItem) {
                log("cartItem.memberId: ${cartItem.memberId}");
                log("memberId: $memberId");
                log("localPackageModel.id: ${localPackageModel.id}");
                log("cartItem.testdata.any: ${cartItem.testdata!.any((testItem) => testItem.typeId == localPackageModel.id)}");
                return cartItem.memberId == memberId &&
                    cartItem.testdata!.any(
                        (testItem) => testItem.typeId == localPackageModel.id);
              }) ??
              false;

      if (alreadyInCart) {
        isAlreadyCheckout = true;
        break;
      }
    }

    if (isAlreadyCheckout) {
      Get.snackbar(
        "Warning",
        "You have already checkout with this package and member.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      return;
    }

    // Proceed with adding to cart
    String selectIdListString = selecteIdList
        .toString()
        .replaceAll('[', '')
        .replaceAll(']', '')
        .removeAllWhitespace;

    isButtonLoading = true;
    update();

    try {
      final response = await http.get(Uri.parse(baseUrl +
          "$updaetCart?user_id=${userDetails.userId.toString()}&member_id=$selectIdListString&type_id=${localPackageModel.id}&type=${localPackageModel.packageType}&parameter=${localPackageModel.packageParameters}&action=0"));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          cartController.coupon = 0;
          cartController.update();
          // cartController.walletPoint = 0;
          cartController.update();
          Get.put(CouponController()).getWalletAmounts();
          Get.offAll(() => PagesWidget(selectedIndex: 3));
          Get.snackbar(
            "Success",
            "${jsonResponse['msg']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
          );
        } else {
          Get.snackbar(
            "Error",
            "data not found",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: redColor,
          );
        }
      }
    } catch (e) {
      Get.snackbar(
        "Failed to load Data",
        "Something went wrong. Try again,",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: redColor,
      );
    } finally {
      isButtonLoading = false;
      update();
    }
  }

  void insertUserData(
      {required int userId,
      required String name,
      required String age,
      required String relation,
      required String gender,
      required LocalPackageModel localPackageModel}) async {
    Map<String, dynamic> userRow = {
      DatabaseHelper.utUserId: userId,
      DatabaseHelper.utUserName: name,
      DatabaseHelper.utUserAge: age,
      DatabaseHelper.utUserRelation: relation,
      DatabaseHelper.utUserGender: gender,
    };

    List isUserExist =
        await dbHelper.checkUser(userRow[DatabaseHelper.utUserId]);

    /// Not Exist Then Add Or skip
    if (isUserExist.length == 0) {
    } else {}

    Map<String, dynamic> packageRow = {
      DatabaseHelper.pdtUserId: userId,
      DatabaseHelper.pdtPackageId: localPackageModel.packageId,
      DatabaseHelper.pdtPackageType: localPackageModel.packageType,
      DatabaseHelper.pdtPackageName: localPackageModel.packageName,
      DatabaseHelper.pdtPackageMrp: localPackageModel.packageMrp,
      DatabaseHelper.pdtPackagePrice: localPackageModel.packagePrice,
      DatabaseHelper.pdtPackageParameters: localPackageModel.packageParameters,
      DatabaseHelper.pdtPackageDiscount: localPackageModel.packageDiscount,
    };

    List isPackageExist = await dbHelper.checkPackageExist(
        uid: userId,
        packageId: packageRow[DatabaseHelper.pdtPackageId],
        packageType: packageRow[DatabaseHelper.pdtPackageType]);

    if (isPackageExist.length == 0) {
    } else {}

    /// Fetch Data
    queryAllUserList();

    /// Fetch Package Data;
    queryAllPackageList();
  }

  void queryAllUserList() async {
    var allRows = await dbHelper.userQueryAll();
    allRows.forEach((row) {});
  }

  void queryAllPackageList() async {
    var allRows = await dbHelper.packageQueryAll();

    allRows.forEach((row) {});
  }

  void deleteAllFieldFromDatabase() {
    // var deleteData =
  }
}
