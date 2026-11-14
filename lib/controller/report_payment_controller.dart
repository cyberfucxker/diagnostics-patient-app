// ignore_for_file: body_might_complete_normally_nullable, unnecessary_null_comparison, non_constant_identifier_names

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/address_list_model.dart';
import 'package:diagnostics_patient/Models/card_model.dart';
import 'package:diagnostics_patient/Models/cart_list_model.dart';
import 'package:diagnostics_patient/Models/payment_model.dart';
import 'package:diagnostics_patient/Models/user_details_class.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custom_dialogue.dart';
import 'package:diagnostics_patient/Screens/stripe_screen.dart';
import 'package:diagnostics_patient/controller/cart_detail_controller.dart';
import 'package:diagnostics_patient/controller/reportlogin_controller.dart';
import 'package:diagnostics_patient/utils/api.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:diagnostics_patient/payments/payment_gateway.dart';

class ReportPaymentController extends GetxController {
  final _formKey = new GlobalKey<FormState>();
  bool _autovalidate = false;
  int? _month;
  int? _year;
  PaymentGateway? _gateway;
  TextEditingController _cCardNumber = new TextEditingController();
  String? number;
  TextEditingController _cExpiry = new TextEditingController();
  TextEditingController _cCvv = new TextEditingController();
  TextEditingController _cName = TextEditingController();
  late double totalAmount;
  bool isBooking = false;
  UserDetailsClass userDetails = UserDetailsClass();
  AddressModel selectedAddress = AddressModel();
  List<Cart>? cart;
  DateTime selectedDate = DateTime.now();
  Payment payment = Payment();
  TimeOfDay selectedTime = TimeOfDay.now();
  String? _gatewayOrderId;
  double reportAmount = 0;
  int? regiId = 0;
  String? userFId = '';

  // PaymentGateway? _gateway;
  double? totalAmountForGateway;

  @override
  void onInit() {
    _gateway = PaymentGateway();
    _gateway!.on(PaymentGateway.eventPaymentSuccess, _handlePaymentSuccess);
    super.onInit();
    init();
  }

  init() async {
    await getUserDetails();
    Get.put(CartDetailController()).fetchCartList();
  }

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    try {
      // Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
      Payment payment = Payment();
      payment.amount = totalAmountForGateway;
      payment.paymentMode = "Online";
      payment.paymentReferenceId = response.paymentId;
      payment.paymentOrderId = response.orderId;
      payment.paymentSignature = response.signature;
      payment.status = "Success";
      payment.userId = userDetails.userId;

      await reportPayment(
        amount: reportAmount.toString(),
        // amount: 1.toString(),
        testRegId: regiId.toString(),
        userFId: userFId,
      );
      update();
    } catch (e) {
      hideLoader(Get.context!);
      print("Exception - PaymentController.dart - _handlePaymentSuccess" +
          e.toString());
    }
  }

  reportPayment({String? userFId, String? testRegId, String? amount}) async {
    // Ensure UI update if needed
    update();
    var _body = {
      'UserFID': userFId,
      'TestRegnId': testRegId,
      'amount': amount,
    };

    try {
      // Show loading dialog with message
      showLoadingMsg(
        context: Get.context!,
        title: 'Please Wait...',
        msg: 'We are processing your payment, wait for update',
      );

      final response =
          await http.post(Uri.parse(baseUrl + "$UpdatePayment"), body: _body);

      // Hide the loader dialog when the response is received
      Get.back(); // Dismiss the loader dialog

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        log("reportPayment :: ${jsonResponse}");

        if (jsonResponse['status'] == 1) {
          // Successfully processed payment

          await Get.put(ReportloginController())
              .getReportList(userFid: userFId);
          // Get.back(result: true); // Close the current screen (if needed)

          // Show success message
          Get.snackbar(
            "Success",
            "${jsonResponse['msg']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
          );
        } else {
          // Handle failure (status != 1)
          Get.snackbar(
            "Error",
            "${jsonResponse['msg']}",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: redColor,
          );
          update();
        }
      }
    } catch (e) {
      // Hide loader on error and show error message
      Get.back(); // Hide loader if an error occurs

      Get.snackbar(
        "Failed to load Data",
        "Something went wrong. Try again.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: redColor,
      );
      update();
    }
  }

  // Future<String?> reportPayment({String? userFId, int? testRegId, String? amount}) async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse(baseUrl + "$UpdatePayment"),
  //       headers: {
  //         "Content-Type": "application/json",
  //         "Accept": "application/json",
  //       },
  //       body: json.encode({
  //         "UserFID": userFId,
  //         "TestRegnId": testRegId,
  //         "amount": amount,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       _gatewayOrderId = json.decode(response.body);
  //     } else {
  //       _gatewayOrderId = null;
  //     }
  //     return _gatewayOrderId!;
  //   } catch (e) {
  //     print("Exception -  apiHelper.dart - createGatewayOrder():" + e.toString());
  //     return null;
  //   }
  // }

  Future<String?> createGatewayOrder(
      {String? totalAmount, Map<String, String>? notes}) async {
    try {
      _gatewayOrderId = await _gateway!.createOrder(
          amountInMinorUnits: totalAmount ?? '0', notes: notes);
      return _gatewayOrderId;
    } catch (e) {
      debugPrint("createGatewayOrder error: $e");
      return null;
    }
  }

  Future _save({int? callId, double? amount}) async {
    try {
      totalAmount = amount!;
      // Get.dialog(
      //     LoaderWidget(
      //       loaderText: '',
      //     ),
      //     barrierDismissible: false);
      if (_cCardNumber.text.trim().isEmpty) {
        // global.hideLoader();
        // Fluttertoast.showToast(
        //   backgroundColor: global.toastBackGoundColor,
        //   msg: 'Enter your card number',
        //   textColor: global.textColor,
        //   fontSize: 14,
        // );
        Get.snackbar(
          "Error",
          "Enter your card number",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: redColor,
        );
      } else if (_cExpiry.text.trim().isEmpty) {
        // global.hideLoader();
        // Fluttertoast.showToast(
        //   backgroundColor: global.toastBackGoundColor,
        //   msg: 'Enter your expiry date',
        //   textColor: global.textColor,
        //   fontSize: 14,
        // );
        // Get.snackbar("Warning", "Enter your expiry date");
        Get.snackbar(
          "Error",
          "Enter your expiry date",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: redColor,
        );
      } else if (_cName.text.trim().isEmpty) {
        // global.hideLoader();
        // Fluttertoast.showToast(
        //   backgroundColor: global.toastBackGoundColor,
        //   msg: 'Enter your card name',
        //   textColor: global.textColor,
        //   fontSize: 14,
        // );
        Get.snackbar(
          "Error",
          "Enter your card name",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: redColor,
        );
      } else {
        if (_formKey.currentState!.validate()) {
          var split = _cExpiry.text.split(new RegExp(r'(\/)'));
          _month = int.parse(split[0]);
          _year = int.parse(split[1]);
          CardModel stripeCard = CardModel(
            number: _cCardNumber.text,
            expiryMonth: _month,
            expiryYear: _year,
            cvv: _cCvv.text,
            name: _cName.text,
          );
          // global.hideLoader();
          await payWithNewCard(
              card: stripeCard, amount: amount.toInt() * 100, currency: '');
          // }
        } else {
          // global.hideLoader();
          // showCustomSnackBar("Please fill the correct detail");
        }
      }
    } catch (e) {
      print("Exception - paymentController.dart - _save(): " + e.toString());
    }
  }

  Future<StripeTransactionResponse?> payWithNewCard(
      {int? amount, CardModel? card, String? currency, int? couponId}) async {
    var customers;
    try {
      Get.dialog(
          Center(
            child: CircularProgressIndicator(),
          ),
          barrierDismissible: false);
      customers =
          await StripeService.createCustomer(email: "${userDetails.email}");

      var paymentMethodsObject = await StripeService.createPaymentMethod(card!);
      if (paymentMethodsObject["id"] != null) {
        var paymentIntent = await StripeService.createPaymentIntent(
            amount!,
            currency!,
            customerId: customers["id"],
            paymentMethodsObject["id"]);
        await StripeService.retrivePaymentIntent(paymentIntent["id"]);
        var response = await StripeService.confirmPaymentIntent(
            paymentIntent["id"], paymentMethodsObject["id"]);
        // global.hideLoader();
        String responseId = response["id"];
        if (response["status"] == 'succeeded') {
          try {
            print("Paymant success");
            Payment payment = Payment();
            payment.amount = 500;
            payment.paymentMode = "Stripe";
            payment.paymentReferenceId = responseId;
            payment.paymentOrderId = null;
            payment.paymentSignature = null;
            payment.status = "Success";
            payment.userId = userDetails.userId;
            // await apiHelper.placeOrder(checkOutController.selectedPaymentMethod, checkOutController.totalAmount, checkOutController.cRemark.text, global.currentUser.id!, checkOutController.cartVendorUserId!, 1, checkOutController.products, payment, checkOutController.taxAmount, checkOutController.deliveryCharge, couponId!).then((response) async {
            //   global.hideLoader();
            //   if (response.status == "1") {
            //     Get.to(() => SuccessPaymentScreen(), routeName: "Success Payment Screen");
            //     showCustomSnackBar('Transaction Successfull');
            //   } else {
            //     showCustomSnackBar('${response.message}');
            //   }
            //   update();
            // });
          } catch (e) {
            print("Exception - paymentController.dart - payWithNewCard" +
                e.toString());
          }
          return new StripeTransactionResponse(
              message: 'Transaction successful', success: true);
        } else if (response["status"] == 'requires_action') {
          var url = response["next_action"]["use_stripe_sdk"]["stripe_js"];
          print(url);
          var res = http.get(Uri.parse(url));
          print(res);
          try {
            print("Paymant success");
            Payment payment = Payment();
            payment.amount = 500;
            payment.paymentMode = "Stripe";
            payment.paymentReferenceId = responseId;
            payment.paymentOrderId = null;
            payment.paymentSignature = null;
            payment.status = "Success";
            payment.userId = userDetails.userId;
            // await apiHelper.placeOrder(checkOutController.selectedPaymentMethod, checkOutController.totalAmount, checkOutController.cRemark.text, global.currentUser.id!, checkOutController.cartVendorUserId!, 1, checkOutController.products, payment, checkOutController.taxAmount, checkOutController.deliveryCharge, couponId!).then((response) async {
            //   Get.back();
            //   if (response.status == "1") {
            //     Get.to(() => SuccessPaymentScreen(), routeName: "Success Payment Screen");
            //     showCustomSnackBar('Transaction Successfull');
            //   } else {
            //     showCustomSnackBar('${response.message}');
            //   }
            //   update();
            // });

            // global.showOnlyLoaderDialog(Get.context);
            // Get.dialog(
            //     LoaderWidget(
            //       loaderText: '',
            //     ),
            //     barrierDismissible: false);
            // await apiHelper.addStrip(amount: totalAmount, status: 'Success', paymentId: 'testing').then((result) {
            //   global.hideLoader();
            //   splashController.getCurrentUserData();
            //   splashController.update();
            //   bottomController.setIndex(1, 0);
            //   Get.to(() => BottomNavigationBarScreen(index: 0));
            //   Fluttertoast.showToast(
            //     backgroundColor: global.toastBackGoundColor,
            //     msg: 'Payment transaction sucessfull',
            //     textColor: global.textColor,
            //     fontSize: 14,
            //   );
            //   // }
            // });
          } catch (e) {
            print(
                "Exception - paymentGatewaysScreen.dart - _handlePaymentSuccess" +
                    e.toString());
          }
          return new StripeTransactionResponse(
              message: 'Transaction successful', success: true);
        } else {
          // try {
          //   await apiHelper.addStrip(amount: totalAmount, status: 'failed', paymentId: 'testing');

          //   tryAgainDialog(openCheckout);

          //   Fluttertoast.showToast(
          //     backgroundColor: global.toastBackGoundColor,
          //     msg: 'Payment Failed amount not added into your wallet.',
          //     textColor: global.textColor,
          //     fontSize: 14,
          //   );
          // } catch (e) {
          //   print("Exception - paymentGatewaysScreen.dart -  _handlePaymentError" + e.toString());
          // }
          _tryAgain(payWithNewCard);
          return new StripeTransactionResponse(
              message: 'Transaction failed', success: false);
        }
      } else {
        // global.hideLoader();
        // global.hideLoader();
        Get.back(); //for closing dialog
        Get.snackbar(
          "Error",
          "${paymentMethodsObject['error']['message']}",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: redColor,
        );
      }
    } on PlatformException catch (err) {
      print(
          'Platfrom Exception: payment_gateways_screen.dart -  payWithNewCard() : ${err.toString()}');
      return StripeService.getPlatformExceptionErrorResult(err);
    } catch (err) {
      print(
          'Exception: payment_gateways_screen.dart -  payWithNewCard() : ${err.toString()}');
      return new StripeTransactionResponse(
          message: 'Transaction failed: ${err.toString()}', success: false);
    }
  }

  _tryAgain(Function onClickAction) {
    try {
      showCupertinoDialog(
          context: Get.context!,
          builder: (BuildContext context) {
            return Theme(
              data: ThemeData(dialogBackgroundColor: Colors.white),
              child: CupertinoAlertDialog(
                title: Text(
                  'Transaction failed',
                ),
                content: Text(
                  'Please try again',
                ),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      // setState(() {});
                    },
                  ),
                  CupertinoDialogAction(
                    child: Text('Try Again'),
                    onPressed: () async {
                      Navigator.of(context).pop();

                      onClickAction();

                      // setState(() {});
                    },
                  ),
                ],
              ),
            );
          });
    } catch (e) {
      print("Exception - payment_gateways_screen.dart - _tryAgainDialog(): " +
          e.toString());
    }
  }

  cardDialog({int? paymentCallId, double? amount}) {
    showDialog(
        context: Get.context!,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) => Theme(
                  data: ThemeData(dialogBackgroundColor: Colors.white),
                  child: AlertDialog(
                    contentPadding: EdgeInsets.all(0),
                    elevation: 0.5,
                    scrollable: true,
                    title: Text(
                      'Card Details',
                      style: TextStyle(),
                    ),
                    actions: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            child: Text('Cancel',
                                style:
                                    TextStyle(color: Get.theme.primaryColor)),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextButton(
                              child: Text(
                                'Pay',
                                style: TextStyle(color: Get.theme.primaryColor),
                              ),
                              onPressed: () async {
                                // Get.back();
                                await _save(
                                    callId: paymentCallId!, amount: amount);
                              },
                            ),
                          )
                        ],
                      )
                    ],
                    content: Form(
                      key: _formKey,
                      autovalidateMode: _autovalidate
                          ? AutovalidateMode.always
                          : AutovalidateMode.disabled,
                      // autovalidateMode: AutovalidateMode.always,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 15, right: 15, top: 15),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _cCardNumber,
                              inputFormatters: [
                                //MyFilter(),
                                MaskedTextInputFormatter(
                                  mask: 'xxxx-xxxx-xxxx-xxxx',
                                  separator: '-',
                                ),
                              ],
                              style: TextStyle(color: Colors.black),
                              textInputAction: TextInputAction.next,
                              decoration: new InputDecoration(
                                hintText: 'Card Number',
                                hintStyle: Theme.of(context)
                                    .inputDecorationTheme
                                    .hintStyle,
                                prefixIcon: Icon(
                                  Icons.credit_card,
                                  color: Get.theme.primaryColor,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Get.theme.primaryColor,
                                  ),
                                ),
                              ),
                              textCapitalization: TextCapitalization.none,
                              keyboardType: TextInputType.number,
                              onSaved: (String? value) {
                                number = getCleanedNumber(value!);
                              },
                              // ignore: missing_return
                              validator: (input) {
                                return null;
                                // if (input!.isEmpty) {
                                //   return 'Enter Card Number';
                                // }

                                // input = global.getCleanedNumber(input);

                                // if (input.length < 8) {
                                //   return 'Enter Valid Card Number';
                                // }

                                // int sum = 0;
                                // int length = input.length;
                                // for (var i = 0; i < length; i++) {
                                //   // get digits in reverse order
                                //   int digit = int.parse(input[length - i - 1]);

                                //   // every 2nd number multiply with 2
                                //   if (i % 2 == 1) {
                                //     digit *= 2;
                                //   }
                                //   sum += digit > 9 ? (digit - 9) : digit;
                                // }

                                // if (sum % 10 == 0) {
                                //   return null;
                                // }

                                // return 'Enter Valid Card Number';
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                      CardMonthInputFormatter(),
                                    ],
                                    controller: _cExpiry,
                                    textInputAction: TextInputAction.next,
                                    decoration: new InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.date_range,
                                          color: Get.theme.primaryColor,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Get.theme.primaryColor,
                                          ),
                                        ),
                                        hintText: 'MM/YY',
                                        hintStyle: Theme.of(context)
                                            .inputDecorationTheme
                                            .hintStyle),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    keyboardType: TextInputType.number,
                                    onFieldSubmitted: (value) {
                                      List<int> expiryDate =
                                          getExpiryDate(value);
                                      _month = expiryDate[0];
                                      _year = expiryDate[1];
                                    },
                                    onEditingComplete: () {
                                      List<int> expiryDate =
                                          getExpiryDate(_cExpiry.text);
                                      _month = expiryDate[0];
                                      _year = expiryDate[1];
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter Expiry Date';
                                      }
                                      int year;
                                      int month;
                                      // The value contains a forward slash if the month and year has been
                                      // entered.
                                      if (value.contains(new RegExp(r'(\/)'))) {
                                        var split =
                                            value.split(new RegExp(r'(\/)'));
                                        // The value before the slash is the month while the value to right of
                                        // it is the year.
                                        month = int.parse(split[0]);
                                        year = int.parse(split[1]);
                                      } else {
                                        // Only the month was entered
                                        month = int.parse(
                                            value.substring(0, (value.length)));
                                        year =
                                            -1; // Lets use an invalid year intentionally
                                      }

                                      if ((month < 1) || (month > 12)) {
                                        // A valid month is between 1 (January) and 12 (December)
                                        return 'Expiry month is invalid';
                                      }

                                      var fourDigitsYear =
                                          convertYearTo4Digits(year);
                                      if ((fourDigitsYear < 1) ||
                                          (fourDigitsYear > 2099)) {
                                        // We are assuming a valid should be between 1 and 2099.
                                        // Note that, it's valid doesn't mean that it has not expired.
                                        return 'Expiry year is invalid';
                                      }

                                      if (!hasDateExpired(month, year)) {
                                        return 'Card has expired';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  child: TextFormField(
                                    inputFormatters: [
                                      // ignore: deprecated_member_use
                                      MyFilter(),
                                      new LengthLimitingTextInputFormatter(3),
                                    ],
                                    controller: _cCvv,
                                    obscureText: true,
                                    textInputAction: TextInputAction.next,
                                    decoration: new InputDecoration(
                                        prefixIcon: Icon(
                                          MdiIcons.creditCard,
                                          color: Get.theme.primaryColor,
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Get.theme.primaryColor,
                                          ),
                                        ),
                                        hintText: 'CVV',
                                        hintStyle: Theme.of(context)
                                            .inputDecorationTheme
                                            .hintStyle),
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'Enter CVV';
                                      } else if (value.length < 3 ||
                                          value.length > 4) {
                                        return 'Cvv is invalid';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _cName,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp('[a-zA-Z ]')),
                              ],
                              decoration: new InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Get.theme.primaryColor,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Get.theme.primaryColor,
                                    ),
                                  ),
                                  hintText: 'Card holder name',
                                  hintStyle: Theme.of(context)
                                      .inputDecorationTheme
                                      .hintStyle),
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return null;
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  )));
        });
  }

  void openCheckout(double totalNetAmount, String contactNo, String email,
      String name) async {
    try {
      totalAmountForGateway = totalNetAmount;
      var options;
      Get.dialog(Center(child: CircularProgressIndicator()),
          barrierDismissible: false);

      final reportController = Get.find<ReportloginController>();
      print('--- openCheckout user info ---');
      print('userFId: $userFId');
      print('reportUserFid: ${reportController.reportUserFid}');
      print('reportUserName: ${reportController.reportUserName}');
      print('reportUserEmail: ${reportController.reportUserEmail}');
      print('reportUserPhone: ${reportController.reportUserPhone}');

      Map<String, String> _notes = {
        "userId": userFId ?? reportController.reportUserFid,
        "userName": reportController.reportUserName,
        "userEmail": reportController.reportUserEmail,
      };
      String? _orderId = await createGatewayOrder(
        // totalAmount: (totalNetAmount.toInt() * 100).toString(),
        totalAmount: (1.toInt() * 100).toString(),
        notes: _notes,
      );
      // Get.back();
      if (_orderId != null && _orderId.isNotEmpty) {
        options = {
          'key': const String.fromEnvironment('PAYMENT_PUBLIC_KEY'),
          'order_id': _orderId,
          'amount': 100,
          'name': name,
          'prefill': {'contact': contactNo, 'email': email},
          'currency': 'INR',
          "notes": _notes
        };
        _gateway!.open(options);
        Get.back();
      } else {
        hideLoader(Get.context!);
        Get.snackbar("Warning", "Someting went wrong",
            backgroundColor: redColor, snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      // debugPrint('Error: ${e.toString()}');
      hideLoader(Get.context!);
      print("Exception -  PaymentController.dart - openCheckout():" +
          e.toString());
    }
  }
}

String getCleanedNumber(String text) {
  RegExp regExp = new RegExp(r"[^0-9]");
  return text.replaceAll(regExp, '');
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;

  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  }) {
    assert(mask != null);
    assert(separator != null);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}

List<int> getExpiryDate(String value) {
  var split = value.split(new RegExp(r'(\/)'));
  return [int.parse(split[0]), int.parse(split[1])];
}

class CardMonthInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var newText = newValue.text;
    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }
    var buffer = StringBuffer();
    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 2 == 0 && nonZeroIndex != newText.length) {
        buffer.write('/');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
        text: string,
        selection: TextSelection.collapsed(offset: string.length));
  }
}

bool hasMonthPassed(int year, int month) {
  var now = DateTime.now();
  // The month has passed if:
  // 1. The year is in the past. In that case, we just assume that the month
  // has passed
  // 2. Card's month (plus another month) is more than current month.
  return hasYearPassed(year) ||
      convertYearTo4Digits(year) == now.year && (month < now.month + 1);
}

bool hasYearPassed(int year) {
  int fourDigitsYear = convertYearTo4Digits(year);
  var now = DateTime.now();
  // The year has passed if the year we are currently is more than card's
  // year
  return fourDigitsYear < now.year;
}

bool hasDateExpired(int month, int year) {
  return !(month == null || year == null) && isNotExpired(year, month);
}

bool isNotExpired(int year, int month) {
  // It has not expired if both the year and date has not passed
  return !hasYearPassed(year) && !hasMonthPassed(year, month);
}

int convertYearTo4Digits(int year) {
  if (year < 100 && year >= 0) {
    var now = DateTime.now();
    String currentYear = now.year.toString();
    String prefix = currentYear.substring(0, currentYear.length - 2);
    year = int.parse('$prefix${year.toString().padLeft(2, '0')}');
  }
  return year;
}

class MyFilter extends TextInputFormatter {
  static final _reg = RegExp(r'^\d+$');

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return _reg.hasMatch(newValue.text) ? newValue : oldValue;
  }
}
