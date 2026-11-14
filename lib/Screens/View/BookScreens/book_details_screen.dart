// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:diagnostics_patient/Models/lab_model.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/page_widget.dart';
import 'package:diagnostics_patient/Screens/map_screen.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:timelines_plus/timelines_plus.dart';

// import 'package:timelines/timelines.dart';
import '../../../componant/custome_appBar.dart';
import '../../../controller/book_detail_controller.dart';
import '../../../utils/AllText.dart';
import '../../../utils/App_Images.dart';
import '../../../utils/strings.dart';
import '../../Custome_Widgets/persondetail_cardview.dart';
import '../../Custome_Widgets/total_card_widget.dart';

class BookDetailsScreen extends StatelessWidget {
  final String? orderId;
  final bool isFromCheckOut;

  BookDetailsScreen({Key? key, this.orderId, this.isFromCheckOut = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: () async {
        if (isFromCheckOut) {
          // If coming from checkout, navigate to a Home screen
          Get.offAll(() => PagesWidget(selectedIndex: 0));
        } else {
          // Otherwise, pop the current screen
          Navigator.pop(context);
        }
        return Future.value(
            false); // Return false to prevent default back button behavior
      },
      child: Scaffold(
        backgroundColor: themeSecondaryColor,
        body: Column(
          children: [
            CustomAppBar(
              title: BOOK_DETAILS[LANGUAGE_TYPE],
              isArrow: true,
              isAction: false,
              isShowBackButton: isFromCheckOut,
            ),
            Expanded(
              child: GetBuilder<BookDetailController>(
                  init: BookDetailController(orderId: orderId),
                  builder: (controller) {
                    double dicountPrice = 0;
                    // for (var i = 0; i < controller.bookingDetailModel!.data.orderdata!.length; i++) {
                    //   for (var j = 0; j < controller.bookingDetailModel!.data.orderdata![i].testdata!.length; j++) {
                    //     dicountPrice += controller.bookingDetailModel!.data.orderdata![i].testdata![j].discount.fixed;
                    //   }
                    // }
                    if (controller.bookingDetailModel != null &&
                        controller.bookingDetailModel!.data.orderdata != null) {
                      for (var i = 0;
                          i <
                              controller
                                  .bookingDetailModel!.data.orderdata!.length;
                          i++) {
                        if (controller.bookingDetailModel!.data.orderdata![i]
                                .testdata !=
                            null) {
                          for (var j = 0;
                              j <
                                  controller.bookingDetailModel!.data
                                      .orderdata![i].testdata!.length;
                              j++) {
                            dicountPrice += controller.bookingDetailModel!.data
                                .orderdata![i].testdata![j].discount.fixed;
                          }
                        }
                      }
                    } else {
                      print("Order data is not available.");
                    }
                    return controller.isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                /// Order Detail
                                Container(
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.all(8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    image: const DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(
                                        AppImages.defaultImage,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          color: whiteColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.book_outlined,
                                          size: 50,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            boldText(
                                                text:
                                                    '${BOOK_ID[LANGUAGE_TYPE]} #${controller.bookingDetailModel?.data.id}',
                                                color: whiteColor,
                                                size: 14),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            regularText(
                                                text:
                                                    // '${PLACED_ON[LANGUAGE_TYPE]} Jan 29,2021',
                                                    '${PLACED_ON[LANGUAGE_TYPE]} ${DateFormat.yMMMMd().format(controller.bookingDetailModel!.data.date!)}',
                                                size: 12,
                                                color: subTextColor),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            regularText(
                                                text:
                                                    '₹${controller.bookingDetailModel!.data.finalTotal} ${PAID_BY[LANGUAGE_TYPE]} ${controller.bookingDetailModel!.data.paymentMethod! == 'cod' ? controller.bookingDetailModel!.data.paymentMethod!.toUpperCase() : controller.bookingDetailModel!.data.paymentMethod!}',
                                                color: whiteColor,
                                                size: 12),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            controller.bookingDetailModel?.data
                                                        .sampleboyDetails !=
                                                    null
                                                ? boldText(
                                                    text:
                                                        '${'SampleBoy Name: '} ${controller.bookingDetailModel?.data.sampleboyDetails!.name}',
                                                    color: whiteColor,
                                                    size: 14)
                                                : SizedBox(),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            controller.bookingDetailModel?.data
                                                        .sampleboyDetails !=
                                                    null
                                                ? boldText(
                                                    text:
                                                        '${'SampleBoy No: '} ${controller.bookingDetailModel?.data.sampleboyDetails!.phone}',
                                                    color: whiteColor,
                                                    size: 14)
                                                : SizedBox(),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                /// Time Line

                                // Reject time line
                                controller.bookingDetailModel!.data.status ==
                                            3 ||
                                        controller.bookingDetailModel!.data
                                                .status ==
                                            4
                                    ? Container(
                                        width: width,
                                        margin: const EdgeInsets.only(
                                            top: 05,
                                            bottom: 15,
                                            right: 10,
                                            left: 10),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 12),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: whiteColor,
                                        ),
                                        child: FixedTimeline.tileBuilder(
                                          theme: TimelineThemeData(
                                            nodePosition: 0.18,
                                            color: themeColor,
                                          ),
                                          builder:
                                              TimelineTileBuilder.connected(
                                            contentsAlign: ContentsAlign.basic,
                                            oppositeContentsBuilder:
                                                (context, index) => Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10,
                                                  bottom: 20,
                                                  top: 10,
                                                  right: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  regularText(
                                                      text: controller
                                                          .rejectTimeLineDetail[
                                                              index]
                                                          .time)
                                                ],
                                              ),
                                            ),
                                            contentsBuilder: (context, index) =>
                                                Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10, bottom: 20, top: 8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  boldText(
                                                      text: controller
                                                          .rejectTimeLineDetail[
                                                              index]
                                                          .title,
                                                      color: blackColor),
                                                  regularText(
                                                      text: controller
                                                          .rejectTimeLineDetail[
                                                              index]
                                                          .des,
                                                      color: subTextColor,
                                                      size: 12)
                                                ],
                                              ),
                                            ),
                                            indicatorPositionBuilder:
                                                (context, index) => 0.18,
                                            itemCount: controller
                                                .rejectTimeLineDetail.length,
                                            indicatorBuilder: (_, index) {
                                              if (controller
                                                  .rejectTimeLineDetail[index]
                                                  .isTrue) {
                                                return const DotIndicator(
                                                  color: themeColor,
                                                  child: Icon(
                                                    Icons.check,
                                                    color: Colors.white,
                                                    size: 15.0,
                                                  ),
                                                );
                                              } else {
                                                return const OutlinedDotIndicator(
                                                  borderWidth: 1,
                                                  color: subTextColor,
                                                );
                                              }
                                            },
                                            connectorBuilder: (_, index, ___) =>
                                                DashedLineConnector(
                                              gap: 4,
                                              thickness: 1,
                                              dash: 2,
                                              color: controller
                                                      .rejectTimeLineDetail[
                                                          index]
                                                      .isTrue
                                                  ? themeColor
                                                  : subTextColor,
                                            ),
                                          ),
                                        ),
                                      )
                                    : controller.bookingDetailModel!.data
                                                .status ==
                                            8

                                        /// Parcel Report send Time line
                                        ? Container(
                                            width: width,
                                            margin: const EdgeInsets.only(
                                                top: 05,
                                                bottom: 15,
                                                right: 10,
                                                left: 10),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 12),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: whiteColor,
                                            ),
                                            child: FixedTimeline.tileBuilder(
                                              theme: TimelineThemeData(
                                                nodePosition: 0.18,
                                                color: themeColor,
                                              ),
                                              builder:
                                                  TimelineTileBuilder.connected(
                                                contentsAlign:
                                                    ContentsAlign.basic,
                                                oppositeContentsBuilder:
                                                    (context, index) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          bottom: 20,
                                                          top: 10,
                                                          right: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      regularText(
                                                          text: controller
                                                              .parcelReportLineDetail[
                                                                  index]
                                                              .time)
                                                    ],
                                                  ),
                                                ),
                                                contentsBuilder:
                                                    (context, index) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          bottom: 20,
                                                          top: 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      boldText(
                                                          text: controller
                                                              .parcelReportLineDetail[
                                                                  index]
                                                              .title,
                                                          color: blackColor),
                                                      regularText(
                                                          text: controller
                                                              .parcelReportLineDetail[
                                                                  index]
                                                              .des,
                                                          color: subTextColor,
                                                          size: 12)
                                                    ],
                                                  ),
                                                ),
                                                indicatorPositionBuilder:
                                                    (context, index) => 0.18,
                                                itemCount: controller
                                                    .parcelReportLineDetail
                                                    .length,
                                                indicatorBuilder: (_, index) {
                                                  if (controller
                                                      .parcelReportLineDetail[
                                                          index]
                                                      .isTrue) {
                                                    return const DotIndicator(
                                                      color: themeColor,
                                                      child: Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                        size: 15.0,
                                                      ),
                                                    );
                                                  } else {
                                                    return const OutlinedDotIndicator(
                                                      borderWidth: 1,
                                                      color: subTextColor,
                                                    );
                                                  }
                                                },
                                                connectorBuilder:
                                                    (_, index, ___) =>
                                                        DashedLineConnector(
                                                  gap: 4,
                                                  thickness: 1,
                                                  dash: 2,
                                                  color: controller
                                                          .parcelReportLineDetail[
                                                              index]
                                                          .isTrue
                                                      ? themeColor
                                                      : subTextColor,
                                                ),
                                              ),
                                            ),
                                          )
                                        :
                                        // Accept Time Line
                                        Container(
                                            width: width,
                                            margin: const EdgeInsets.only(
                                                top: 05,
                                                bottom: 15,
                                                right: 10,
                                                left: 10),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0, vertical: 12),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: whiteColor,
                                            ),
                                            child: FixedTimeline.tileBuilder(
                                              theme: TimelineThemeData(
                                                nodePosition: 0.18,
                                                color: themeColor,
                                              ),
                                              builder:
                                                  TimelineTileBuilder.connected(
                                                contentsAlign:
                                                    ContentsAlign.basic,
                                                oppositeContentsBuilder:
                                                    (context, index) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          bottom: 20,
                                                          top: 10,
                                                          right: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      regularText(
                                                          text: controller
                                                              .timeLineDetail[
                                                                  index]
                                                              .time)
                                                    ],
                                                  ),
                                                ),
                                                contentsBuilder:
                                                    (context, index) => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10,
                                                          bottom: 20,
                                                          top: 8),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      boldText(
                                                          text: controller
                                                              .timeLineDetail[
                                                                  index]
                                                              .title,
                                                          color: blackColor),
                                                      regularText(
                                                          text: controller
                                                              .timeLineDetail[
                                                                  index]
                                                              .des,
                                                          color: subTextColor,
                                                          size: 12)
                                                    ],
                                                  ),
                                                ),
                                                indicatorPositionBuilder:
                                                    (context, index) => 0.18,
                                                itemCount: controller
                                                    .timeLineDetail.length,
                                                indicatorBuilder: (_, index) {
                                                  if (controller
                                                      .timeLineDetail[index]
                                                      .isTrue) {
                                                    return const DotIndicator(
                                                      color: themeColor,
                                                      child: Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                        size: 15.0,
                                                      ),
                                                    );
                                                  } else {
                                                    return const OutlinedDotIndicator(
                                                      borderWidth: 1,
                                                      color: subTextColor,
                                                    );
                                                  }
                                                },
                                                connectorBuilder:
                                                    (_, index, ___) =>
                                                        DashedLineConnector(
                                                  gap: 4,
                                                  thickness: 1,
                                                  dash: 2,
                                                  color: controller
                                                          .timeLineDetail[index]
                                                          .isTrue
                                                      ? themeColor
                                                      : subTextColor,
                                                ),
                                              ),
                                            ),
                                          ),

                                /// Collection Address
                                Container(
                                  width: width,
                                  margin: const EdgeInsets.only(
                                      top: 0, bottom: 05, right: 10, left: 10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 12),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: whiteColor,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      boldText(
                                          text:
                                              COLLECTION_ADDRESS[LANGUAGE_TYPE],
                                          size: 16),
                                      const Divider(
                                        color: subTextColor,
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            height: 110,
                                            width: 110,
                                            child: InkWell(
                                              onTap: () async {
                                                print(controller
                                                    .center!.latitude);
                                                print(controller
                                                    .center!.longitude);
                                                Get.to(() => MapScreen(
                                                      labModelList:
                                                          LabModelList(
                                                        location: Location(
                                                            lat: controller
                                                                .center!
                                                                .latitude,
                                                            lng: controller
                                                                .center!
                                                                .longitude),
                                                      ),
                                                    ));
                                              },
                                              child: Stack(
                                                children: [
                                                  ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      child: Image.asset(
                                                        "assets/book_detail/map.jpg",
                                                        fit: BoxFit.fill,
                                                        // height: 110,
                                                        // width: 130,
                                                      )),
                                                  Align(
                                                    alignment: Alignment.center,
                                                    child: Center(
                                                      child: Image.asset(
                                                        "assets/pin.png",
                                                        height: 30,
                                                        width: 30,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  // mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    // for (var map in availableMaps)
                                                    //   ListTile(
                                                    //     onTap: () => map.showMarker(
                                                    //       coords: coords,
                                                    //       title: title,
                                                    //     ),
                                                    //     title: Text(map.mapName),
                                                    //     leading: SvgPicture.asset(
                                                    //       map.icon,
                                                    //       height: 30.0,
                                                    //       width: 30.0,
                                                    //     ),
                                                    //   ),
                                                    Image.asset(
                                                      'assets/book_detail/location.png',
                                                      height: 40,
                                                    ),
                                                    Flexible(
                                                      child: regularText(
                                                          text: controller
                                                                      .bookingDetailModel!
                                                                      .data
                                                                      .useraddressdetails ==
                                                                  null
                                                              ? ""
                                                              : '${controller.bookingDetailModel!.data.useraddressdetails!.houseNo}, ${controller.bookingDetailModel!.data.useraddressdetails!.address}, ${controller.bookingDetailModel!.data.useraddressdetails!.city}-${controller.bookingDetailModel!.data.useraddressdetails!.pincode}, ${controller.bookingDetailModel!.data.useraddressdetails!.state} ',
                                                          size: 12,
                                                          color: blackColor),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    Image.asset(
                                                      'assets/book_detail/contact.png',
                                                      height: 40,
                                                    ),
                                                    Flexible(
                                                      child: regularText(
                                                          text:
                                                              '${controller.bookingDetailModel!.data.phone.toString()}',
                                                          color: blackColor,
                                                          size: 12),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 13),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/book_detail/date.png',
                                                            height: 15,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          regularText(
                                                              text:
                                                                  '${DateFormat.yMMMMd().format(controller.bookingDetailModel!.data.date!)}',
                                                              color: blackColor,
                                                              size: 12),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 13, top: 10),
                                                  child: Row(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/book_detail/time.png',
                                                            height: 15,
                                                          ),
                                                          const SizedBox(
                                                            width: 10,
                                                          ),
                                                          regularText(
                                                              text:
                                                                  '${controller.bookingDetailModel!.data.time}',
                                                              color: blackColor,
                                                              size: 12),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),

                                /// Person Detail CardView
                                controller.bookingDetailModel!.data.orderdata !=
                                        null
                                    ? Container(
                                        child: ListView.builder(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics:
                                                NeverScrollableScrollPhysics(),
                                            itemCount: controller
                                                .bookingDetailModel!
                                                .data
                                                .orderdata
                                                ?.length,
                                            itemBuilder: (context, index) {
                                              var userData = controller
                                                  .bookingDetailModel!
                                                  .data
                                                  .orderdata![index];
                                              var packageData = controller
                                                  .bookingDetailModel!
                                                  .data
                                                  .orderdata![index]
                                                  .testdata!;
                                              return PersonPackageDetailCardView(
                                                width: width,
                                                name:
                                                    '${userData.memberName} | ${userData.relation}   ',
                                                detail:
                                                    '${userData.gender},${userData.age} years',
                                                cardItem: 2,
                                                isSimple: true,
                                                testdatum: packageData,
                                                memberId: 2,
                                              );
                                            }),
                                      )
                                    : SizedBox(),
                                // PersonPackageDetailCardView(
                                //   width: width,
                                //   name: 'Hetal | Self   ',
                                //   detail: 'Female,24 years',
                                //   cardItem: 2,
                                //   isSimple: true, testdatum: controller.bookingDetailModel!.data.orderdata.,
                                // ),
                                // PersonPackageDetailCardView(
                                //   width: width,
                                //   name: 'Vishal | Self   ',
                                //   detail: 'Male,24 years',
                                //   cardItem: 1,
                                //   isSimple: true,
                                // ),

                                const SizedBox(
                                  height: 5,
                                ),

                                /// Total Card
                                TotalCard(
                                  subTotal:
                                      '₹${controller.bookingDetailModel!.data.subtotal}',
                                  total:
                                      '₹${controller.bookingDetailModel!.data.finalTotal?.toDouble()}',
                                  coupon:
                                      '₹${controller.bookingDetailModel!.data.couponDiscount != null ? controller.bookingDetailModel!.data.couponDiscount : '0'}',

                                  walletPoint:
                                      '₹${controller.bookingDetailModel!.data.cashbackPoint != null ? controller.bookingDetailModel!.data.cashbackPoint : '0'}',
                                  tax:
                                      '₹${controller.bookingDetailModel!.data.tax}',
                                  isShowSavingAmount: false,
                                  width: width,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),

                                /// Button
                                controller.bookingDetailModel!.data.status == 7
                                    ? controller.isFeedbackLoading
                                        ? Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 15.0,
                                                  right: 10,
                                                  left: 10,
                                                  bottom: 15),
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          )
                                        : Padding(
                                            padding: const EdgeInsets.only(
                                                top: 15.0,
                                                right: 10,
                                                left: 10,
                                                bottom: 15),
                                            child: Row(
                                              children: [
                                                customeElevatedButtonOutLine(
                                                    width / 2.20,
                                                    FEEDBACK[LANGUAGE_TYPE],
                                                    color: themeSecondaryColor,
                                                    callback: () {
                                                  feedBackDialog(context);
                                                  // save();
                                                  // Navigator.pop(context);
                                                }),
                                                const Spacer(),
                                                customeElevatedButton(
                                                  width / 2.20,
                                                  REPORT[LANGUAGE_TYPE],
                                                  // callback: () {
                                                  //   if (controller.bookingDetailModel!.data.partiallyreports[0].report == null || controller.bookingDetailModel!.data.partiallyreports[0].report == '') {
                                                  //     Get.snackbar(
                                                  //       'Report not uploaded yet!',
                                                  //       'Report show after upload',
                                                  //       snackPosition: SnackPosition.BOTTOM,
                                                  //       backgroundColor: Colors.red,
                                                  //     );
                                                  //   } else {
                                                  //     controller.openFile(controller.bookingDetailModel!.data.partiallyreports[0].report);

                                                  //     print('report uploaded');
                                                  //   }
                                                  //   // Navigator.pop(context);
                                                  // },
                                                  callback: () {
                                                    controller.checkLoginApi();
                                                    // var partiallyReports = controller.bookingDetailModel!.data.partiallyreports;

                                                    // if (partiallyReports.isEmpty) {
                                                    //   Get.snackbar(
                                                    //     'No reports available!',
                                                    //     'Reports will be shown once uploaded',
                                                    //     snackPosition: SnackPosition.BOTTOM,
                                                    //     backgroundColor: Colors.red,
                                                    //   );
                                                    // } else {
                                                    //   // Loop through all reports and check each one
                                                    //   partiallyReports.forEach((report) {
                                                    //     if (report.report == null || report.report == '') {
                                                    //       Get.snackbar(
                                                    //         'Report not uploaded!',
                                                    //         'One of the reports is not uploaded yet',
                                                    //         snackPosition: SnackPosition.BOTTOM,
                                                    //         backgroundColor: Colors.red,
                                                    //       );
                                                    //     } else {
                                                    //       controller.openFile(report.report);
                                                    //       print('Report downloaded: ${report.report}');
                                                    //     }
                                                    //   });
                                                    // }
                                                  },
                                                ),
                                              ],
                                            ),
                                          )
                                    : Container(),
                                controller.bookingDetailModel!.data.status ==
                                            7 &&
                                        controller.bookingDetailModel!.data
                                                .paymentMethod! ==
                                            'cod'
                                    ? Padding(
                                        padding: const EdgeInsets.only(
                                            right: 10,
                                            left: 10,
                                            bottom: 15,
                                            top: 10),
                                        child: customeElevatedButton(
                                          width,
                                          'Invoice',
                                          callback: () {
                                            controller.handleDownloadButton(
                                                controller.bookingDetailModel!
                                                    .data.id!);
                                          },
                                        ),
                                      )
                                    : SizedBox()
                              ],
                            ),
                          );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  feedBackDialog(context) {
    final controller = Get.find<BookDetailController>();
    Get.dialog(
      Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          padding: EdgeInsets.symmetric(vertical: 20),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: darkBlue,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  boldText(text: 'Give Feedback', color: whiteColor, size: 26),
                  SizedBox(
                    width: 5,
                  ),
                  Image.asset(
                    'assets/book_detail/happy.png',
                    height: 24,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              regularText(
                  text: 'What do you thhink of the editing tool?',
                  size: 16,
                  color: subTextColor),
              SizedBox(
                height: 20,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     controller.selectedRating >= 1? Image.asset(controller.s1,height: controller.iconSize,):Image.asset(controller.us1,height: controller.iconSize,),
              //     controller.selectedRating >= 2? Image.asset(controller.s2,height: controller.iconSize,):Image.asset(controller.us2,height: controller.iconSize,),
              //     controller.selectedRating >= 3? Image.asset(controller.s3,height: controller.iconSize,):Image.asset(controller.us3,height: controller.iconSize,),
              //     controller.selectedRating >= 4? Image.asset(controller.s4,height: controller.iconSize,):Image.asset(controller.us4,height: controller.iconSize,),
              //     controller.selectedRating >= 5? Image.asset(controller.s5,height: controller.iconSize,):Image.asset(controller.us5,height: controller.iconSize,),
              //   ],
              // ),
              RatingBar.builder(
                initialRating: controller.selectedRating,
                itemCount: 5,
                itemSize: 50,
                itemPadding: EdgeInsets.symmetric(horizontal: 5),
                unratedColor: Colors.grey,
                itemBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Icon(
                        Icons.sentiment_very_dissatisfied,
                        color: Colors.amber,
                      );
                    case 1:
                      return Icon(
                        Icons.sentiment_dissatisfied,
                        color: Colors.amber,
                      );
                    case 2:
                      return Icon(
                        Icons.sentiment_neutral,
                        color: Colors.amber,
                      );
                    case 3:
                      return Icon(
                        Icons.sentiment_satisfied,
                        color: Colors.amber,
                      );
                    case 4:
                      return Icon(
                        Icons.sentiment_very_satisfied,
                        color: Colors.amber,
                      );
                    default:
                      return Container();
                  }
                },
                onRatingUpdate: (rating) {
                  // print(rating);
                  controller.selectedRating = rating;
                  print(controller.selectedRating);
                },
              ),
              SizedBox(
                height: 20,
              ),
              Material(
                color: darkBlue,
                child: Container(
                  color: whiteColor,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: TextField(
                    style: TextStyle(
                      fontFamily: "Regular",
                      fontSize: 14,
                    ),
                    controller: controller.tcFeedback,
                    maxLines: 5,
                    decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        hintText: 'Type Something you want here...',
                        hintStyle: TextStyle(
                          fontFamily: "Regular",
                          fontSize: 12,
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: customeElevatedButtonOutLine(
                          double.infinity, 'Cancel', callback: () {
                        controller.tcFeedback.clear();
                        controller.selectedRating = 4;
                        Get.back();
                      },
                          color: darkBlue,
                          textColor: whiteColor,
                          borderColor: whiteColor),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: customeElevatedButtonOutLine(
                          double.infinity, 'Submit', callback: () {
                        controller.submitFeedback();
                      }, color: whiteColor, borderColor: whiteColor),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );

    // Widget ratingIcon(int i){
    //   return  Image.asset(controller.s1,height: controller.iconSize,);
    // }
  }
}

class TimeLineDetail {
  String time;
  String title;
  String des;
  bool isTrue;

  TimeLineDetail(
      {required this.time,
      required this.title,
      required this.des,
      required this.isTrue});
}
