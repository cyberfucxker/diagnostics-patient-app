import 'package:dotted_decoration/dotted_decoration.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:diagnostics_patient/controller/cart_detail_controller.dart';
import 'package:diagnostics_patient/controller/coupon_controller.dart';
import 'package:diagnostics_patient/utils/App_Images.dart';
import '../../../componant/custome_appBar.dart';
import '../../../utils/AllText.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';
import '../../../widgets/custom_snackbar.dart';

class CouponListScreen extends StatefulWidget {
  final bool fromCheckOut;
  const CouponListScreen({Key? key, required this.fromCheckOut})
      : super(key: key);

  @override
  State<CouponListScreen> createState() => _CouponListScreenState();
}

class _CouponListScreenState extends State<CouponListScreen> {
  CouponController couponController = Get.put(CouponController());

  CartDetailController cartDetailController = Get.put(CartDetailController());

  final dateName = DateFormat('EEEE').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeSecondaryColor,
      body: Column(
        children: [
          ///------ appbar ------
          CustomAppBar(
              title: COUPON_LIST[LANGUAGE_TYPE],
              isArrow: true,
              isAction: false),
          Expanded(child: GetBuilder<CouponController>(
            builder: (controller) {
              return couponController.isLoading
                  ? const Center(
                      child: SizedBox(
                        height: 150,
                        width: 35,
                        child: Center(
                            child:
                                CircularProgressIndicator(color: themeColor)),
                      ),
                    )
                  : couponController.couponList.isEmpty
                      ? Container(
                          alignment: Alignment.center,
                          child: const Text(
                            'No Data Found',
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        )
                      : ListView.builder(
                          // physics: NeverScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          itemCount: couponController.couponList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: GestureDetector(
                                onTap: () async {
                                  bool isShow = true;
                                  DateTime now = DateTime.now();
                                  final formatter = DateFormat('EEEE');
                                  String getCurrentDay = formatter.format(now);
                                  print("days $getCurrentDay");
                                  List<String> dayList = [];
                                  dayList = couponController
                                      .couponList[index].day!
                                      .split(',');

                                  for (var i = 0; i < dayList.length; i++) {
                                    if (getCurrentDay == dayList[i]) {
                                      isShow = false;
                                      widget.fromCheckOut
                                          ? await cartDetailController
                                              .validateCoupon(
                                                  couponData: couponController
                                                      .couponList[index],
                                                  cartInfo: cartDetailController
                                                      .cartListModel!.data!)
                                          : null;
                                      await cartDetailController
                                          .fetchCartList();
                                    }
                                  }
                                  if (isShow) {
                                    AppSnackbar.warning(
                                      "Warning",
                                      "Coupon not valid for today",
                                    );
                                  }
                                },
                                child: Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    Card(
                                      margin: EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      color: Colors.white,
                                      child: Container(
                                        // width: global.getPlatFrom() ? 280 : Get.width - 40,
                                        width: Get.width,
                                        //width: 310,
                                        // height: 180,
                                        decoration: DottedDecoration(
                                          borderRadius:
                                              BorderRadius.circular(9),
                                          color: Colors.grey[400]!,
                                          strokeWidth: 1.5,
                                          shape: Shape.box,
                                        ),
                                        padding: EdgeInsets.all(10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // CustomImage(
                                                //   image: '${global.appInfo.baseUrls!.partnerImageUrl}/${coupon.image}',
                                                //   height: 35,
                                                //   width: 70,
                                                //   fit: BoxFit.contain,
                                                // ),
                                                Image.asset(
                                                  'assets/labLogo1.jpg',
                                                  // AppImages.newAppLogo,
                                                  height: 35,
                                                  width: 70,
                                                  fit: BoxFit.contain,
                                                ),
                                                SizedBox(
                                                  width: 160,
                                                  child: Text(
                                                    '${couponController.couponList[index].couponValue}${couponController.couponList[index].couponType == "fixed" ? "₹" : "%"} off on',
                                                    style: Get
                                                        .theme
                                                        .primaryTextTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.grey,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 160,
                                                  child: Text(
                                                    '${couponController.couponList[index].day != null ? couponController.couponList[index].day : '--'}',
                                                    style: Get
                                                        .theme
                                                        .primaryTextTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                      color: Colors.grey,
                                                    ),
                                                    maxLines: 4,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                SizedBox(height: 15),
                                                SizedBox(
                                                  width: 160,
                                                  child: Text(
                                                    '${DateFormat('yyyy-MM-dd').format(couponController.couponList[index].couponStartDate!)} To ${DateFormat('yyyy-MM-dd').format(couponController.couponList[index].couponEndDate!)}',
                                                    style: Get
                                                        .theme
                                                        .primaryTextTheme
                                                        .titleMedium!
                                                        .copyWith(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Get
                                                          .theme.primaryColor,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Stack(
                                              clipBehavior: Clip.none,
                                              children: [
                                                Container(
                                                  height: 40,
                                                  width: 90,
                                                  padding: EdgeInsets.only(
                                                      bottom: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey[400],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                Positioned(
                                                  bottom: 5,
                                                  right: 5,
                                                  child: Container(
                                                    height: 40,
                                                    width: 90,
                                                    decoration: BoxDecoration(
                                                      color: themeColor,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ),
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      '${couponController.couponList[index].couponCode}',
                                                      style: Get
                                                          .theme
                                                          .primaryTextTheme
                                                          .titleSmall!
                                                          .copyWith(
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                    // Text(
                                                    //   coupon.code != null && coupon.code!.isNotEmpty
                                                    //       ? 'See code'
                                                    //       : coupon.buttonText != null && coupon.buttonText!.isNotEmpty
                                                    //           ? coupon.buttonText!
                                                    //           : 'Grab Now',
                                                    //   style: Get.theme.primaryTextTheme.titleSmall!.copyWith(color: Colors.white),
                                                    // ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: 120,
                                      child: DottedLine(
                                        dashColor: Colors.grey[400]!,
                                        direction: Axis.vertical,
                                        dashGapLength: 6,
                                        lineThickness: 1.2,
                                        lineLength: 100,
                                      ),
                                    ),
                                    Positioned(
                                      bottom: -20,
                                      right: 100,
                                      child: Card(
                                        color: themeSecondaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: DottedDecoration(
                                            strokeWidth: 1,
                                            color: Colors.grey[400]!,
                                            shape: Shape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: -20,
                                      right: 100,
                                      child: Card(
                                        color: themeSecondaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: Container(
                                          height: 30,
                                          width: 30,
                                          decoration: DottedDecoration(
                                            strokeWidth: 1,
                                            color: Colors.grey[400]!,
                                            shape: Shape.circle,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
            },
          )),
        ],
      ),
    );
  }
}
