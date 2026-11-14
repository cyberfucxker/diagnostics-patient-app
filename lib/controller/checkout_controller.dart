// ignore_for_file: deprecated_member_use, non_constant_identifier_names, await_only_futures

import 'dart:convert';
import 'dart:developer';

// import 'package:cc_avenue/cc_avenue.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:diagnostics_patient/Models/address_list_model.dart';
import 'package:diagnostics_patient/Models/get_userByCity_model.dart';
import 'package:diagnostics_patient/Models/time_slot_model.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custom_dialogue.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/page_widget.dart';
import 'package:diagnostics_patient/controller/book_detail_controller.dart';
import 'package:diagnostics_patient/controller/cart_detail_controller.dart';
import 'package:diagnostics_patient/controller/online_payment_controller.dart';

import '../Models/cart_list_model.dart';
import '../Models/user_details_class.dart';
import '../Screens/Custome_Widgets/custome_widget.dart';
import '../Screens/View/BookScreens/book_details_screen.dart';
import '../utils/AllText.dart';
import '../utils/api.dart';
import '../utils/colors.dart';
import '../utils/strings.dart';
import '../widgets/custom_snackbar.dart';

class CheckoutController extends GetxController {
  bool isLoading = false;
  bool isBooking = false;
  bool isAddressLoading = true;
  bool isAddressNull = true;
  DateTime selectedDate = DateTime.now();
  DateFormat dateFormatter = DateFormat('yyyy-MM-dd');
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController selectDateController = TextEditingController();
  TextEditingController selectTimeController = TextEditingController();
  TextEditingController labController = TextEditingController();
  UserDetailsClass userDetails = UserDetailsClass();
  AddressListModel? addressListModel;
  AddressModel selectedAddress = AddressModel();
  GetUserCity? getUserCity;
  TimeSlot? getTimeSlot;
  String? selectedTimeSlot;
  int? getCouponId;
  bool isLabShow = false;
  TextEditingController tcCity = TextEditingController();
  TextEditingController couponController = new TextEditingController();
  String selectedLabAddress = '';
  List<GetUserByCityList> getUserByCityList = [];
  List<TimeSlotList> getTimeSlotList = [];
  String? selectedDropdownValue;
  String? cureentDate;
  String? cureentTime;

  final cartDetailController = Get.put(CartDetailController());

  onInit() {
    selectDateController.text =
        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
    selectTimeController.text =
        '${selectedTime.hour.toString().padLeft(2, "0")}:${selectedTime.minute.toString().padLeft(2, "0")}';
    super.onInit();
    init();
  }

  init() async {
    await getUserDetails();
    await getCurrentTime();
    fetchAddress();
    getTimeSlots();
    // getUserByCityLists();
  }

  getCurrentTime() async {
    try {
      showOnlyLoaderDialog(Get.context);
      final response = await http.get(Uri.parse(baseUrl + currentDateTime));
      hideLoader(Get.context!);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        cureentDate = jsonResponse['date'];
        cureentTime = jsonResponse['time'];
      }
    } catch (e) {
      AppSnackbar.error(
        "Failed to load Data",
        "Something went wrong. Try again,",
      );
      isLoading = false;
      update();
    }
  }

  getUserByCityLists() async {
    try {
      showOnlyLoaderDialog(Get.context);
      final response = await http.get(Uri.parse(
          baseUrl + getUserByCityApi + '?city_id=${selectedAddress.id}'));
      log("--- API getUserByCityLists Lab : ${Uri.parse(baseUrl + getUserByCityApi + '?city_id=${selectedAddress.id}')}");
      hideLoader(Get.context!);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        log("--- Response getUserByCityLists Lab : $jsonResponse");
        if (jsonResponse['status'] == 1) {
          log("--- Inside getUserByCityLists Lab : ");
          getUserCity = null;
          getUserByCityList = [];
          getUserCity = GetUserCity.fromJson(jsonResponse);
          getUserByCityList.addAll(getUserCity!.data);
          selectedLabAddress =
              getUserByCityList.isNotEmpty ? getUserByCityList[0].name : '';
          selectedDropdownValue =
              getUserByCityList.isNotEmpty ? getUserByCityList[0].name : null;
          // isLoading = false;
          update();
        } else if (jsonResponse['status'] == 0) {
          getUserByCityList.clear();
          Get.back();
          AppSnackbar.error(
            "Error",
            jsonResponse['msg'],
          );
          // isLoading = false;

          update();
        } else {
          AppSnackbar.error(
            "Error",
            "data not found",
          );
          // isLoading = false;
          update();
          //   throw Exception('Failed to load Data');
        }
      }
    } catch (e) {
      AppSnackbar.error(
        "Failed to load Data",
        "Something went wrong. Try again,",
      );
      isLoading = false;
      update();
    }
  }

  // Function to update the selected time slot
  void updateTimeSlot(String? newTimeSlot) {
    selectedTimeSlot = newTimeSlot;

    update(); // Notifies GetX to update the UI
  }

  // getTimeSlots() async {
  //   try {
  //     showOnlyLoaderDialog(Get.context);
  //     final response = await http.get(Uri.parse(baseUrl + getTimeSlotApi));
  //     if (response.statusCode == 200) {
  //       hideLoader(Get.context!);
  //       final jsonResponse = jsonDecode(response.body);
  //       if (jsonResponse['status'] == 1) {
  //         getTimeSlot = null;
  //         getTimeSlotList = [];

  //         DateTime now = DateTime.now();
  //         TimeOfDay timeOfDay = TimeOfDay.fromDateTime(now);
  //         int hour = timeOfDay.hour;
  //         int minute = timeOfDay.minute;
  //         String formattedTime = '$hour:${minute.toString().padLeft(2, '0')}';
  //         print(formattedTime);
  //         getTimeSlot = TimeSlot.fromJson(jsonResponse);
  //         int currentTime = int.parse(formattedTime.split(":")[0].toString()) + 2;
  //         for (var i = 0; i < getTimeSlot!.data.length; i++) {
  //           int slotHour = int.parse(getTimeSlot!.data[i].timeslot.split(":")[0].toString());
  //           if (currentTime < slotHour) {
  //             // Convert 24-hour timeslot to 12-hour AM/PM format for both start and end times
  //             DateTime tempStartDate = DateFormat("HH:mm").parse(getTimeSlot!.data[i].timeslot);
  //             DateTime tempEndDate = tempStartDate.add(Duration(hours: 1)); // Add 1 hour for the end time
  //             String formattedStartSlot = DateFormat("h:mm a").format(tempStartDate); // Start time (e.g., 6:00 AM)
  //             String formattedEndSlot = DateFormat("h:mm a").format(tempEndDate); // End time (e.g., 7:00 AM)
  //             // Create a combined timeslot string like "6:00 AM - 7:00 AM (Free)"
  //             String formattedSlot = "$formattedStartSlot - $formattedEndSlot (Free)";
  //             getTimeSlot!.data[i].timeslot = formattedSlot;
  //             getTimeSlotList.add(getTimeSlot!.data[i]);
  //           }
  //         }
  //         // Set the initially selected timeslot (if available)
  //         if (getTimeSlotList.isNotEmpty) {
  //           // Set the first timeslot after 2 hours as the default selected timeslot
  //           selectedTimeSlot = getTimeSlotList.first.timeslot;
  //         }
  //         print(getTimeSlotList);
  //         isLoading = false;
  //         update();
  //       } else {
  //         // Handle failure
  //         hideLoader(Get.context!);
  //         Get.snackbar("Error", "Data not found", snackPosition: SnackPosition.BOTTOM, backgroundColor: redColor);
  //         isLoading = false;
  //         update();
  //       }
  //     }
  //   } catch (e) {
  //     // Handle exceptions
  //     hideLoader(Get.context!);
  //     Get.snackbar("Failed to load Data", "Something went wrong. Try again.", snackPosition: SnackPosition.BOTTOM, backgroundColor: redColor);
  //     isLoading = false;
  //     update();
  //     print("Exception getTimeSlots(): $e");
  //   }
  // }

  getTimeSlots() async {
    try {
      showOnlyLoaderDialog(Get.context);
      final response = await http.get(Uri.parse(baseUrl + getTimeSlotApi));
      if (response.statusCode == 200) {
        hideLoader(Get.context!);
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          getTimeSlot = null;
          getTimeSlotList = [];
          DateTime now = DateTime.now();
          TimeOfDay timeOfDay = TimeOfDay.fromDateTime(now);
          int hour = timeOfDay.hour;
          int minute = timeOfDay.minute;
          String formattedTime = '$hour:${minute.toString().padLeft(2, '0')}';
          print(formattedTime);
          getTimeSlot = TimeSlot.fromJson(jsonResponse);
          DateTime currentDate =
              DateTime.now(); // Use current date for comparison
          // Check if the selected date is today (currentDate)
          bool isToday = selectedDate.year == currentDate.year &&
              selectedDate.month == currentDate.month &&
              selectedDate.day == currentDate.day;
          // Add 2 hours for current time slots restriction
          int currentTime = int.parse(formattedTime.split(":")[0]) + 2;

          for (var i = 0; i < getTimeSlot!.data.length; i++) {
            int slotHour = int.parse(
                getTimeSlot!.data[i].timeslot.split(":")[0].toString());
            // If the selected date is today, show only slots 2 hours later
            if (isToday) {
              if (currentTime < slotHour) {
                // Convert 24-hour timeslot to 12-hour AM/PM format
                DateTime tempStartDate =
                    DateFormat("HH:mm").parse(getTimeSlot!.data[i].timeslot);
                DateTime tempEndDate = tempStartDate
                    .add(Duration(hours: 1)); // Add 1 hour for end time
                String formattedStartSlot = DateFormat("h:mm a")
                    .format(tempStartDate); // Start time (e.g., 6:00 AM)
                String formattedEndSlot = DateFormat("h:mm a")
                    .format(tempEndDate); // End time (e.g., 7:00 AM)
                // Create a combined timeslot string like "6:00 AM - 7:00 AM (Free)"
                String formattedSlot =
                    "$formattedStartSlot - $formattedEndSlot (Free)";
                getTimeSlot!.data[i].timeslot = formattedSlot;
                getTimeSlotList.add(getTimeSlot!.data[i]);
              }
            } else {
              // For future dates, show all time slots
              DateTime tempStartDate =
                  DateFormat("HH:mm").parse(getTimeSlot!.data[i].timeslot);
              DateTime tempEndDate = tempStartDate
                  .add(Duration(hours: 1)); // Add 1 hour for end time
              String formattedStartSlot = DateFormat("h:mm a")
                  .format(tempStartDate); // Start time (e.g., 6:00 AM)
              String formattedEndSlot = DateFormat("h:mm a")
                  .format(tempEndDate); // End time (e.g., 7:00 AM)
              // Create a combined timeslot string like "6:00 AM - 7:00 AM (Free)"
              String formattedSlot =
                  "$formattedStartSlot - $formattedEndSlot (Free)";
              getTimeSlot!.data[i].timeslot = formattedSlot;
              getTimeSlotList.add(getTimeSlot!.data[i]);
            }
          }
          // Set the initially selected timeslot (if available)
          if (getTimeSlotList.isNotEmpty) {
            // Set the first timeslot as the default selected timeslot
            selectedTimeSlot = getTimeSlotList.first.timeslot;
          }
          print(getTimeSlotList);
          isLoading = false;
          update();
        } else {
          // Handle failure
          hideLoader(Get.context!);
          AppSnackbar.error("Error", "Data not found");
          isLoading = false;
          update();
        }
      }
    } catch (e) {
      // Handle exceptions
      hideLoader(Get.context!);
      AppSnackbar.error("Failed to load Data", "Something went wrong. Try again.");
      isLoading = false;
      update();
      print("Exception getTimeSlots(): $e");
    }
  }



  String _formatSlot(String startTime24) {
    DateTime tempStartDate = DateFormat("HH:mm").parse(startTime24);
    DateTime tempEndDate = tempStartDate.add(Duration(hours: 1));
    String formattedStart = DateFormat("h:mm a").format(tempStartDate);
    String formattedEnd = DateFormat("h:mm a").format(tempEndDate);
    return "$formattedStart - $formattedEnd (Free)";
  }

  /// ----------------------------------------



  Future<void> selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.dial,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
                primary: themeColor,
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  // primary: themeColor, // button text color
                  foregroundColor: themeColor, // button text color
                ),
              ),
            ),
            child: child!,
          );
        });
    if (timeOfDay != null && timeOfDay != selectedTime) {
      selectedTime = timeOfDay;
      selectTimeController.text =
          '${selectedTime.hour.toString().padLeft(2, "0")}:${selectedTime.minute.toString().padLeft(2, "0")}';
    }
  }

  static const values = <String>['Online', 'COD'];

  setSelectedRadio(val) {
    selectedValue = val;
    update();
  }

  String selectedValue = values.first;


  Future<void> selectDate(BuildContext context) async {
    DateTime now = DateTime.now();
    bool isAfter7PM = now.hour >= 19;

    final DateTime initial = isAfter7PM ? now.add(Duration(days: 1)) : now;

    // Open date picker and allow user to select a date
    final DateTime? picked = await showDatePicker(
      context: context,
      // initialDate: selectedDate, // Initially set to the current date
      initialDate: selectedDate.isBefore(initial) ? initial : selectedDate,
      // firstDate: DateTime.now(),
      firstDate: initial,
      lastDate: DateTime.now().add(Duration(days: 25)),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: themeColor, // Customize the primary color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: themeColor, // Customize button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    // Check if a new date was picked
    if (picked != null && picked != selectedDate) {
      selectedDate = picked; // Update the selected date
      selectDateController.text =
          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'; // Display the selected date in DD/MM/YYYY format

      // Now call getTimeSlots to update the time slots based on the new date
      await getTimeSlots(); // Fetch time slots for the newly selected date
    }
    update(); // Notify the UI to rebuild with the updated data
  }

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
    update();
  }

  Future fetchAddress() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
    // Clear selected address before fetching new data
    changeSelectedAddress(AddressModel());

    isAddressLoading = true;
    update();

    try {
      final response = await http
          .get(Uri.parse(baseUrl + "$getAddress?id=${userDetails.userId}"));

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        print("json response_check_my_address-------------$jsonResponse");

        if (jsonResponse['status'] == 1) {
          addressListModel = AddressListModel.fromJson(jsonResponse);

          // Check for default address first
          bool hasDefault = false;
          for (var data in addressListModel!.data!) {
            if (data.isDefault == 1) {
              changeSelectedAddress(data);
              hasDefault = true;
              break;
            }
          }

          // If no default address is found, select the first one
          if (!hasDefault && addressListModel!.data!.isNotEmpty) {
            changeSelectedAddress(addressListModel!.data!.last);
          }

          isAddressLoading = false;
          isAddressNull = false;
          update();
        } else if (jsonResponse['status'] == 0) {
          isAddressLoading = false;
          isAddressNull = true;
          update();
        } else {
          isAddressNull = true;
          isAddressLoading = false;
          AppSnackbar.error(
            "Error",
            "Data not found",
          );
          update();
        }
      }
    } catch (e) {
      print('meeterror -> $e');
      AppSnackbar.error(
        "Failed to load Data",
        "Something went wrong. Try again.",
      );
      isAddressNull = true;
      isAddressLoading = false;
      update();
    }
  }

  changeSelectedAddress(data) {
    selectedAddress = data;
    selectedLabAddress =
        selectedAddress.name != null && selectedAddress.name != ''
            ? selectedAddress.name!
            : '';
    update();
  }

  bookNow({
    required subTotal,
    required txt,
    required total,
    required walletPoint,
    required CartData data,
    width,
    String? member_id,
    String? coupon_id,
    String? visitType,
    required couponDis,
  }) async {
    print('selectedAddress.id ${selectedAddress.id}');
    if (selectedAddress.id == null) {
      AppSnackbar.warning(
        "Address is required",
        "First select address and then add to cart",
      );
      return;
    } else if (selectedValue == "Online" || selectedValue == "Paystack") {
      print("selectedAddress.id $selectedValue");
      String paymentLink = "";
      if (selectedValue == "Online") {
        Get.put(OnlinePaymentController()).openCheckout(
            total,
            subTotal,
            txt,
            member_id!,
            '${userDetails.phone}',
            '${userDetails.email}',
            '${userDetails.name}');
      } else {}

      var result = await paymentLink;
      print("result $result");
      if (result == 'success') {
        Get.dialog(
          barrierDismissible: false,
          WillPopScope(
            onWillPop: () async => false,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 280,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: darkBlue,
                  ),
                  child: Column(
                    children: [
                      boldText(text: "", color: whiteColor, size: 26),
                      SizedBox(
                        height: 20,
                      ),
                      regularText(
                          text: ORDER_SUCCESS_MSG2[LANGUAGE_TYPE],
                          color: subTextColor,
                          size: 16,
                          alignment: TextAlign.center),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: customeElevatedButton(
                            width * 0.9, TRACK_ORDER[LANGUAGE_TYPE],
                            callback: () {
                          Get.to(() => BookDetailsScreen(
                                orderId: "".toString(),
                                isFromCheckOut: true,
                              ));
                          cartDetailController.cartListModel = CartListModel();
                          cartDetailController.fetchCartList();
                        }),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: customeElevatedButtonOutLine(
                          width * 0.9,
                          BACK_TO_SHOP[LANGUAGE_TYPE],
                          color: themeSecondaryColor,
                          callback: () async {
                            // await Get.find<NearByLabController>().getLabList();
                            Get.offAll(() => PagesWidget(
                                  selectedIndex: 0,
                                ));
                            cartDetailController.cartListModel =
                                CartListModel();
                            cartDetailController.fetchCartList();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      } else if (result == 'fail') {
        print("Else if");
      }
    } else {
      isBooking = true;
      update();
      /* String testJson = "{\"Testdata\":[";
      for (int i = 0; i < data.cart!.length; i++) {
        testJson =
            testJson + "{\"member_id\":${data.cart![i].memberId},\"items\":[";
        for (int j = 0; j < data.cart![i].testdata!.length; j++) {
          var data2 = data.cart![i].testdata![j];
          testJson = testJson +
              "{\"id\":${data2.typeId},\"type\":${data2.type},\"parameter\":${data2.parameter}}${data.cart![i].testdata!.length == j + 1 ? '' : ','}";
        }
        testJson = testJson + "]}${data.cart!.length == i + 1 ? '' : ','}";
      }
      testJson = testJson + "]}"; */
      String testJson = "{\"Testdata\":[";

      for (int i = 0; i < data.cart.length; i++) {
        testJson =
            testJson + "{\"member_id\":${data.cart[i].memberId},\"items\":[";

        for (int j = 0; j < data.cart[i].testdata.length; j++) {
          var data2 = data.cart[i].testdata[j];

          double mrp = data2.mrp ?? 0.0;
          double price = data2.price ?? 0.0;

          testJson = testJson +
              "{\"id\":${data2.typeId},\"type\":${data2.type},\"parameter\":${data2.parameter},\"mrp\":$mrp,\"price\":$price}${data.cart[i].testdata.length == j + 1 ? '' : ','}";
        }

        testJson = testJson + "]}${data.cart.length == i + 1 ? '' : ','}";
      }

      testJson = testJson + "]}";

      if (coupon_id != null) {
        var _body = {
          'user_id': userDetails.userId.toString(),
          'sample_collection_address_id': selectedAddress.id.toString(),
          'date': selectedDate.toString(),
          // 'time': '${selectedTime.hour}:${selectedTime.minute}',
          'time': '${selectedTimeSlot}',
          'payment_method': selectedValue.toString().toLowerCase(),
          'subtotal': subTotal.toString(),
          'tax': txt.toString(),
          'final_total': total.toString(),
          'test_json': testJson,
          'coupon_id': coupon_id,
          // 'wallet_point': 6,
          'wallet_point': walletPoint.toString(),
          'member_id': member_id,
          'visit_type': visitType,
          'coupon_dis': couponDis.toString(),
        };

        print("_body $_body");
        log("_body $_body");
        log(Uri.parse(baseUrl + "$bookNowApiV2").toString());
        try {
          showOnlyLoaderDialog(Get.context);
          final response = await http.post(Uri.parse(baseUrl + "$bookNowApiV2"),
              body: _body);
          if (response.statusCode == 200) {
            hideLoader(Get.context!);
            final jsonResponse = jsonDecode(response.body);
            log("response-------------_1$jsonResponse");

            if (jsonResponse['status'] == 1) {
              // Get.find<CartDetailController>().fetchCartList();
              // Get.back();
              Get.dialog(
                barrierDismissible: false,
                WillPopScope(
                  onWillPop: () async => false,
                  child: Center(
                    child: Container(
                      height: 280,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: darkBlue,
                      ),
                      child: Column(
                        children: [
                          boldText(
                              text: jsonResponse['msg'],
                              color: whiteColor,
                              size: 26),
                          SizedBox(
                            height: 20,
                          ),
                          regularText(
                              text: ORDER_SUCCESS_MSG2[LANGUAGE_TYPE],
                              color: subTextColor,
                              size: 16,
                              alignment: TextAlign.center),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: customeElevatedButton(
                                width * 0.9, TRACK_ORDER[LANGUAGE_TYPE],
                                callback: () {
                              Get.put(BookDetailController(
                                orderId: jsonResponse['data'].toString(),
                              )).getBookDetail(
                                  id: jsonResponse['data'].toString());
                              Get.to(() =>
                                  BookDetailsScreen(isFromCheckOut: true));
                              cartDetailController.cartListModel =
                                  CartListModel();
                              cartDetailController.fetchCartList();
                              /* Get.to(() => BookDetailsScreen(
                                    orderId: jsonResponse['data'].toString(),
                                    isFromCheckOut: true,
                                  ));
                              cartDetailController.cartListModel = null;
                              cartDetailController.fetchCartList(); */
                            }),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: customeElevatedButtonOutLine(
                              width * 0.9,
                              BACK_TO_SHOP[LANGUAGE_TYPE],
                              color: themeSecondaryColor,
                              callback: () async {
                                // await Get.find<NearByLabController>().getLabList();
                                Get.offAll(() => PagesWidget(
                                      selectedIndex: 0,
                                    ));
                                cartDetailController.cartListModel =
                                    CartListModel();
                                cartDetailController.fetchCartList();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );

              Get.snackbar(
                "Success",
                "${jsonResponse['msg']}",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
              );

              isBooking = false;
              update();
            } else if (jsonResponse['status'] == 0) {
              Get.snackbar(
                "Error",
                "${jsonResponse['msg']}",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: redColor,
              );
            } else {
              Get.snackbar(
                "Error",
                "data not found",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: redColor,
              );
              isBooking = false;
              update();
              //   throw Exception('Failed to load Data');
            }
          }
        } catch (e) {
          AppSnackbar.error(
            "Failed to load Data",
            "Something went wrong. Try again,",
          );
          isBooking = false;
          update();
        }
      } else {
        var _body = {
          'user_id': userDetails.userId.toString(),
          'sample_collection_address_id': selectedAddress.id.toString(),
          // 'date': '${selectedDate.day}-${selectedDate.month}-${selectedDate.year}',
          'date': selectedDate.toString(),
          // 'time': '${selectedTime.hour}:${selectedTime.minute}',
          'time': '${selectedTimeSlot}',
          'payment_method': selectedValue.toString().toLowerCase(),
          'subtotal': subTotal.toString(),
          'tax': txt.toString(),
          'final_total': total.toString(),
          'test_json': testJson,
          'wallet_point': walletPoint.toString(),
          'member_id': member_id,
          // 'wallet_point': 6,
          'visit_type': visitType,
          'coupon_dis': couponDis.toString(),
        };

        print("_body $_body");
        log("_body $_body");
        log(Uri.parse(baseUrl + "$bookNowApiV2").toString());
        try {
          showOnlyLoaderDialog(Get.context);
          final response = await http.post(Uri.parse(baseUrl + "$bookNowApiV2"),
              body: _body);

          if (response.statusCode == 200) {
            final jsonResponse = jsonDecode(response.body);
            print("response-------------_2$jsonResponse");
            hideLoader(Get.context!);
            if (jsonResponse['status'] == 1) {
              Get.dialog(
                barrierDismissible: false,
                WillPopScope(
                  onWillPop: () async => false,
                  child: Center(
                    child: Container(
                      height: 280,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: darkBlue,
                      ),
                      child: Column(
                        children: [
                          boldText(
                              text: jsonResponse['msg'],
                              color: whiteColor,
                              size: 26),
                          SizedBox(
                            height: 20,
                          ),
                          regularText(
                              text: ORDER_SUCCESS_MSG2[LANGUAGE_TYPE],
                              color: subTextColor,
                              size: 16,
                              alignment: TextAlign.center),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: customeElevatedButton(
                              width * 0.9,
                              TRACK_ORDER[LANGUAGE_TYPE],
                              callback: () {
                                Get.put(BookDetailController(
                                  orderId: jsonResponse['data'].toString(),
                                )).getBookDetail(
                                    id: jsonResponse['data'].toString());
                                Get.to(() =>
                                    BookDetailsScreen(isFromCheckOut: true));
                                cartDetailController.cartListModel =
                                    CartListModel();
                                cartDetailController.fetchCartList();
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: customeElevatedButtonOutLine(
                              width * 0.9,
                              BACK_TO_SHOP[LANGUAGE_TYPE],
                              color: themeSecondaryColor,
                              callback: () async {
                                // await Get.find<NearByLabController>().getLabList();
                                Get.offAll(() => PagesWidget(
                                      selectedIndex: 0,
                                    ));
                                cartDetailController.cartListModel =
                                    CartListModel();
                                cartDetailController.fetchCartList();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );

              Get.snackbar(
                "Success",
                "${jsonResponse['msg']}",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
              );

              isBooking = false;
              update();
            } else if (jsonResponse['status'] == 0) {
              Get.snackbar(
                "Error",
                "${jsonResponse['msg']}",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: redColor,
              );
            } else {
              Get.snackbar(
                "Error",
                "data not found",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: redColor,
              );
              isBooking = false;
              update();
              //   throw Exception('Failed to load Data');
            }
          }
        } catch (e) {
          AppSnackbar.error(
            "Failed to load Data",
            "Something went wrong. Try again,",
          );
          isBooking = false;
          update();
        }
      }
    }
  }

  String checkType(value) {
    if (value is String) {
      return 'String';
    } else if (value is int) {
      return 'int';
    }
    return 'Someting else';
  }

  Future DeleteAddress({id}) async {
    isAddressLoading = true;
    update();
    try {
      final response =
          await http.get(Uri.parse(baseUrl + "delete_address?id=$id"));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          // AddressList();
          fetchAddress();
          getUserByCityLists();
          AppSnackbar.success(
            "Successful",
            "${jsonResponse['msg']}",
          );
          // isLoading = false;
          update();
          // return categoryModelList;
        } else {
          isAddressLoading = false;
          AppSnackbar.error(
            "Error",
            "data not found",
          );
          update();
          //   throw Exception('Failed to load Data');
        }
      }
    } catch (e) {
      AppSnackbar.error(
        "Failed to load Data",
        "Something went wrong. Try again,",
      );
      isAddressLoading = false;
      update();
    }
  }
}
