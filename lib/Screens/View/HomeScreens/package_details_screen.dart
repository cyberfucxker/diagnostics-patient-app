// ignore_for_file: unnecessary_null_comparison, must_be_immutable, non_constant_identifier_names, unrelated_type_equality_checks

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:diagnostics_patient/Models/local_package_detail_model.dart';
import 'package:diagnostics_patient/Models/user_details_class.dart';
import 'package:diagnostics_patient/Screens/View/AuthScreen/login_screen.dart';
import 'package:diagnostics_patient/Screens/View/HomeScreens/parameter_details_screen.dart';
import 'package:diagnostics_patient/Screens/View/HomeScreens/profile_details_screen.dart';
import 'package:diagnostics_patient/componant/custome_appBar.dart';
import 'package:diagnostics_patient/controller/package_detail_controller.dart';
import 'package:diagnostics_patient/utils/AllText.dart';
import 'package:diagnostics_patient/utils/App_Images.dart';
import 'package:diagnostics_patient/utils/api.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import '../../Custome_Widgets/custome_widget.dart';
import 'dart:io' show Directory, Platform;

import '../FamilyMemberListScreen/member_list_screen.dart';

class PackageDetailScreen extends StatelessWidget {
  TabController? tabController;
  int packageId;
  final PageController controller = PageController();
  UserDetailsClass userDetails = UserDetailsClass();

  PackageDetailScreen(this.packageId);

  // final packageDetailController = Get.put(PackageDetailController());

  var dio = Dio();

  @override
  Widget build(BuildContext context) {
    ProgressDialog pd = ProgressDialog(context: context);
    final width = MediaQuery.of(context).size.width;
    messageDialog(String s1, String s2) {
      return showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return AlertDialog(
              title: Text(
                s1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s2,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  )
                ],
              ),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigator.pop(context);
                  },

                  // color: Theme.of(context).primaryColor,
                  child: Text(
                    Ok[LANGUAGE_TYPE],
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: blackColor,
                    ),
                  ),
                ),
              ],
            );
          });
    }

    // packageDetailController.getPackageDetails(packageId);
    // print('package id : $packageId');
    return Scaffold(
      // appBar: customeAppBar(
      //   Package_Detail[LANGUAGE_TYPE],
      // ),
      /* bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8),
        child: customeElevatedButton(
          width,
          Book_Now[LANGUAGE_TYPE],
          // callback: () => Get.to(()=>PackageDetailScreen(packageId)),
          callback: () {
            var userData = Get.find<PackageDetailController>().userDetails;
            var data = Get.find<PackageDetailController>().packageDetail!.data;
            double mrps = double.parse(data.mrp.toString());
            double prices = double.parse(data.price.toString());
            var localPackageData = LocalPackageModel(
              id: data.id,
              userId: -1,
              packageId: data.id,
              packageType: 1,
              packageName: data.name,
              packageMrp: mrps.toInt(),
              packagePrice: prices.toInt(),
              packageParameters: data.noOfParameter.toString(),
              packageDiscount: 10.toString(),
            );
            if (userData.isLoggedIn) {
              Get.to(
                () => MemberList(localPackageModel: localPackageData),
              );
            } else {
              Get.to(() => LoginScreen(index: 5, localPackageData: localPackageData));
            }
          },
        ),
      ), */
      body: Column(
        children: [
          CustomAppBar(
              title: Package_Detail[LANGUAGE_TYPE],
              isArrow: true,
              isAction: false),
          Expanded(
            child: GetBuilder<PackageDetailController>(
                init: PackageDetailController(packageId),
                builder: (controller) {
                  int mrp = controller.data != null ? controller.data!.mrp : 0;
                  double discount = controller.data != null
                      ? double.parse(controller.data!.discount.fixed.toString())
                      : 0;
                  double totalDiscount = mrp - discount;
                  return controller.isLoading
                      ? const Center(
                          child: SizedBox(
                            height: 500,
                            width: 35,
                            child: Center(
                                child: CircularProgressIndicator(
                              color: themeColor,
                            )),
                          ),
                        )
                      : controller.isError
                          ? Center(
                              child: SizedBox(
                                height: 500,
                                child: Center(
                                    child: regularText(
                                        text: NO_DATA[LANGUAGE_TYPE])),
                              ),
                            )
                          : SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                      color: themeSecondaryColor,
                                      child: Column(
                                        children: [
                                          ListView(
                                            padding: EdgeInsets.zero,
                                            shrinkWrap: true,
                                            physics: const ScrollPhysics(),
                                            children: [
                                              ///----- Card View ///////
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Container(
                                                  height: 130,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                    image:
                                                        const DecorationImage(
                                                      fit: BoxFit.fill,
                                                      image: AssetImage(
                                                        AppImages.defaultImage,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .only(top: 5),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Flexible(
                                                                child: Text(
                                                                  controller
                                                                      .packageDetail!
                                                                      .data
                                                                      .name,
                                                                  maxLines: 1,
                                                                  style: const TextStyle(
                                                                      color:
                                                                          whiteColor,
                                                                      fontFamily:
                                                                          "Bold"),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      shareApp(
                                                                          controller
                                                                              .data);
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(50),
                                                                        color:
                                                                            whiteColor,
                                                                      ),
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .share,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      if (Platform
                                                                          .isAndroid) {
                                                                        // var androidInfo = await DeviceInfoPlugin().androidInfo;
                                                                        // var sdkInt = androidInfo.version.sdkInt;
                                                                        // print(androidInfo.version.sdkInt);
                                                                        // // print('Android $release (SDK $sdkInt), $manufacturer $model');
                                                                        // if (sdkInt >= 31) {
                                                                        //   var status = await Permission.manageExternalStorage.request();
                                                                        //   print("***************************");
                                                                        //   if (!status.isGranted) {
                                                                        //     await Permission.manageExternalStorage.request();
                                                                        //     print(status);
                                                                        //   } else {
                                                                        //     final Time = DateTime.now().millisecond.toString();
                                                                        //     print(Time);
                                                                        //     var fileName = controller.data!.labReport;
                                                                        //     var newFileName = fileName.replaceAll(RegExp('\\.pdf'), "");
                                                                        //     var addFileName = newFileName + "${DateTime.now().second}" + ".pdf";
                                                                        //     print(addFileName);
                                                                        //     print(fileName.replaceAll(RegExp('\\.pdf'), ""));
                                                                        //     pd.show(
                                                                        //       // hideValue:controller.test ? true : false,
                                                                        //       barrierDismissible: true,
                                                                        //       max: 100,
                                                                        //       msg: 'Pdf Downloading...',
                                                                        //       progressType: ProgressType.valuable,
                                                                        //       completed: Completed(completedMsg: "Downloading Done !", completionDelay: 2500),
                                                                        //     );

                                                                        //     print(controller.data!.labReport);
                                                                        //     print(status);
                                                                        //     String path;
                                                                        //     print(controller.index1);
                                                                        //     path = controller.index1 == 0 ? await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS + controller.data!.labReport) : await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS + addFileName);
                                                                        //     print(path);
                                                                        //     controller.download(dio, pdfBaseUrl + controller.data!.labReport, path, pd);
                                                                        //   }
                                                                        // } else {
                                                                        //   print("----------------------------");
                                                                        //   var status = await Permission.storage.request();
                                                                        //   if (!status.isGranted) {
                                                                        //     await Permission.storage.request();
                                                                        //     print(status);
                                                                        //   } else {
                                                                        //     // controller.index;
                                                                        //     if (status.isDenied) {
                                                                        //       messageDialog(Error[LANGUAGE_TYPE], Error_Msg[LANGUAGE_TYPE]);
                                                                        //     } else {
                                                                        //       var fileName = controller.data!.labReport;
                                                                        //       var newFileName = fileName.replaceAll(RegExp('\\.pdf'), "");
                                                                        //       var addFileName = newFileName + "${controller.index1}" + ".pdf";
                                                                        //       pd.show(
                                                                        //         // hidelValue:controller.test? true : false,

                                                                        //         barrierDismissible: true,
                                                                        //         max: 100,
                                                                        //         msg: 'Pdf Downloading...',
                                                                        //         progressType: ProgressType.valuable,
                                                                        //         completed: Completed(completedMsg: "Downloading Done !", completionDelay: 2500),
                                                                        //       );
                                                                        //       controller.addIndex();
                                                                        //       print(controller.data!.labReport);
                                                                        //       print(controller.index1);
                                                                        //       print(status);
                                                                        //       String path;
                                                                        //       path = controller.index1 == 0 ? await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS + controller.data!.labReport) : await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS + addFileName);
                                                                        //       print(path);

                                                                        //       controller.download(dio, pdfBaseUrl + controller.data!.labReport, path, pd);
                                                                        //     }
                                                                        //   }
                                                                        final directory =
                                                                            await getExternalStorageDirectory();
                                                                        if (directory !=
                                                                            null) {
                                                                          final filePath =
                                                                              '${directory.path}/downloaded_file.pdf';
                                                                          print(
                                                                              'File will be saved to: $filePath');

                                                                          // Start the download process here (you will need your Dio or HTTP client)
                                                                          controller.download(
                                                                              dio,
                                                                              pdfBaseUrl + controller.data!.labReport,
                                                                              filePath,
                                                                              pd);

                                                                          pd.show(
                                                                            barrierDismissible:
                                                                                true,
                                                                            max:
                                                                                100,
                                                                            msg:
                                                                                'Pdf Downloading...',
                                                                            progressType:
                                                                                ProgressType.valuable,
                                                                            completed:
                                                                                Completed(completedMsg: "Downloading Done!", completionDelay: 2500),
                                                                          );
                                                                        }
                                                                      } else if (Platform
                                                                          .isIOS) {
                                                                        // Get the app's Documents directory
                                                                        Directory
                                                                            appDocDir =
                                                                            await getApplicationDocumentsDirectory();
                                                                        String
                                                                            appDocPath =
                                                                            appDocDir.path;

                                                                        var fileName = controller
                                                                            .data!
                                                                            .labReport;
                                                                        var newFileName = fileName.replaceAll(
                                                                            RegExp('\\.pdf'),
                                                                            "");
                                                                        var addFileName = newFileName +
                                                                            "${DateTime.now().second}" +
                                                                            ".pdf";
                                                                        String
                                                                            filePath =
                                                                            appDocPath +
                                                                                '/$addFileName';

                                                                        pd.show(
                                                                          barrierDismissible:
                                                                              true,
                                                                          max:
                                                                              100,
                                                                          msg:
                                                                              'Pdf Downloading...',
                                                                          progressType:
                                                                              ProgressType.valuable,
                                                                          completed: Completed(
                                                                              completedMsg: "Downloading Done !",
                                                                              completionDelay: 2500),
                                                                        );

                                                                        print(
                                                                            filePath);

                                                                        // Download the PDF to the app's directory
                                                                        controller.download(
                                                                            dio,
                                                                            pdfBaseUrl +
                                                                                controller.data!.labReport,
                                                                            filePath,
                                                                            pd);
                                                                      }
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(50),
                                                                        color:
                                                                            whiteColor,
                                                                      ),
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                      child:
                                                                          const Icon(
                                                                        Icons
                                                                            .download_sharp,
                                                                        size:
                                                                            15,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Text(
                                                          Paramter_Included[
                                                                  LANGUAGE_TYPE] +
                                                              " : " +
                                                              controller.data!
                                                                  .noOfParameter
                                                                  .toString(),
                                                          style:
                                                              const TextStyle(
                                                            color: subTextColor,
                                                            fontFamily:
                                                                "Regular",
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        controller
                                                                .packageDetail!
                                                                .data
                                                                .shortDesc
                                                                .isEmpty
                                                            ? Container()
                                                            : Text(
                                                                controller
                                                                    .packageDetail!
                                                                    .data
                                                                    .shortDesc,
                                                                maxLines: 1,
                                                                style:
                                                                    const TextStyle(
                                                                  color:
                                                                      subTextColor,
                                                                  fontFamily:
                                                                      "Regular",
                                                                  fontSize: 12,
                                                                ),
                                                              ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Text(
                                                                  Price[LANGUAGE_TYPE] +
                                                                      " : ",
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        "Regular",
                                                                    color:
                                                                        whiteColor,
                                                                    fontSize:
                                                                        12,
                                                                  ),
                                                                ),
                                                                controller.data!
                                                                            .price !=
                                                                        0
                                                                    ? Text(
                                                                        "₹${double.parse(controller.data!.price.toString()).toStringAsFixed(0)}",
                                                                        style:
                                                                            const TextStyle(
                                                                          fontFamily:
                                                                              "Regular",
                                                                          color:
                                                                              whiteColor,
                                                                          fontSize:
                                                                              12,
                                                                          decoration:
                                                                              TextDecoration.lineThrough,
                                                                        ),
                                                                      )
                                                                    : SizedBox(),
                                                                controller.data!
                                                                            .price !=
                                                                        0
                                                                    ? Text(
                                                                        " / ",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              whiteColor,
                                                                        ),
                                                                      )
                                                                    : SizedBox(),
                                                                controller.data!
                                                                            .price !=
                                                                        0
                                                                    ? Text(
                                                                        "₹" +
                                                                            controller.data!.mrp.toString(),
                                                                        // "₹" + controller.popularPackageModelList![index].discount.fixed,
                                                                        style:
                                                                            const TextStyle(
                                                                          fontFamily:
                                                                              "Regular",
                                                                          color:
                                                                              whiteColor,
                                                                          fontSize:
                                                                              11,
                                                                        ),
                                                                      )
                                                                    : SizedBox(),
                                                                // const Text(
                                                                //   " / ",
                                                                //   style: TextStyle(
                                                                //     fontFamily: "Regular",
                                                                //     color: whiteColor,
                                                                //     fontSize: 12,
                                                                //   ),
                                                                // ),
                                                                // Text(
                                                                //   "₹${double.parse(controller.data!.mrp.toString()).toStringAsFixed(0)}",
                                                                //   style: const TextStyle(
                                                                //     fontFamily: "Regular",
                                                                //     color: whiteColor,
                                                                //     fontSize: 12,
                                                                //   ),
                                                                // ),
                                                              ],
                                                            ),
                                                            controller
                                                                        .data!
                                                                        .discount
                                                                        .per !=
                                                                    0
                                                                ? Container(
                                                                    height: 25,
                                                                    width: 40,
                                                                    decoration:
                                                                        const BoxDecoration(
                                                                      image:
                                                                          DecorationImage(
                                                                        image:
                                                                            AssetImage(
                                                                          "assets/popular_package/discount.png",
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "${controller.data!.discount.per}%",
                                                                        // "\$${24}.00",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              whiteColor,
                                                                          fontSize:
                                                                              10,
                                                                          fontFamily:
                                                                              "Regular",
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : SizedBox(),
                                                            Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                controller.data!
                                                                            .totalreview
                                                                            .toString() ==
                                                                        5
                                                                            .toString()
                                                                    ? SizedBox(
                                                                        height:
                                                                            10,
                                                                        child:
                                                                            Row(
                                                                          children: List.generate(
                                                                              5,
                                                                              (index) => Padding(
                                                                                    padding: const EdgeInsets.only(right: 2),
                                                                                    child: Icon(
                                                                                      Icons.star,
                                                                                      color: (index == 0 || index == 1 || index == 2 || index == 3 || index == 4) ? starColor : subTextColor,
                                                                                      size: 12,
                                                                                    ),
                                                                                  )),
                                                                        ),
                                                                      )
                                                                    : controller.data!.totalreview.toString() ==
                                                                            4.toString()
                                                                        ? SizedBox(
                                                                            height:
                                                                                10,
                                                                            child:
                                                                                Row(
                                                                              children: List.generate(
                                                                                  5,
                                                                                  (index) => Padding(
                                                                                        padding: const EdgeInsets.only(right: 2),
                                                                                        child: Icon(
                                                                                          Icons.star,
                                                                                          color: (index == 0 || index == 1 || index == 2 || index == 3) ? starColor : subTextColor,
                                                                                          size: 12,
                                                                                        ),
                                                                                      )),
                                                                            ),
                                                                          )
                                                                        : controller.data!.totalreview.toString() == 3.toString()
                                                                            ? SizedBox(
                                                                                height: 10,
                                                                                child: Row(
                                                                                  children: List.generate(
                                                                                      5,
                                                                                      (index) => Padding(
                                                                                            padding: const EdgeInsets.only(right: 2),
                                                                                            child: Icon(
                                                                                              Icons.star,
                                                                                              color: (index == 0 || index == 1 || index == 2) ? starColor : subTextColor,
                                                                                              size: 12,
                                                                                            ),
                                                                                          )),
                                                                                ),
                                                                              )
                                                                            : controller.data!.totalreview.toString() == 2.toString()
                                                                                ? SizedBox(
                                                                                    height: 10,
                                                                                    child: Row(
                                                                                      children: List.generate(
                                                                                          5,
                                                                                          (index) => Padding(
                                                                                                padding: const EdgeInsets.only(right: 2),
                                                                                                child: Icon(
                                                                                                  Icons.star,
                                                                                                  color: (index == 0 || index == 1) ? starColor : subTextColor,
                                                                                                  size: 12,
                                                                                                ),
                                                                                              )),
                                                                                    ),
                                                                                  )
                                                                                : SizedBox(
                                                                                    height: 10,
                                                                                    child: Row(
                                                                                      children: List.generate(
                                                                                          5,
                                                                                          (index) => Padding(
                                                                                                padding: const EdgeInsets.only(right: 2),
                                                                                                child: Icon(
                                                                                                  Icons.star,
                                                                                                  color: (index == 0) ? starColor : subTextColor,
                                                                                                  size: 12,
                                                                                                ),
                                                                                              )),
                                                                                    ),
                                                                                  ),
                                                                SizedBox(
                                                                  height: 10,
                                                                  child: Text(
                                                                    "(${controller.packageDetail!.data.avgreview})",
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            10,
                                                                        color:
                                                                            subTextColor),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              ///----- Test Details ///////
                                              controller.data!.parameterList
                                                      .isEmpty
                                                  ? Container()
                                                  : Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          vertical: 10,
                                                          horizontal: 8),
                                                      child: Text(
                                                        Test_Details[
                                                            LANGUAGE_TYPE],
                                                        style: const TextStyle(
                                                          fontFamily: "Bold",
                                                          fontSize: 18,
                                                        ),
                                                      ),
                                                    ),
                                              controller.data!.parameterList
                                                      .isEmpty
                                                  ? Container()
                                                  : Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: whiteColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                        ),
                                                        child: ListView.builder(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            itemCount: controller
                                                                .data!
                                                                .parameterList
                                                                .length,
                                                            shrinkWrap: true,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return ExpansionTile(
                                                                  collapsedTextColor:
                                                                      blackColor,
                                                                  expandedAlignment:
                                                                      Alignment
                                                                          .topLeft,
                                                                  title: Text(
                                                                    // '${controller.data!.parameterList[index].name}   (${controller.data!.parameterList[index].parameter != null ? controller.data!.parameterList[index].parameter.length : ''})',
                                                                    '${controller.data!.parameterList[index].name} ${controller.data!.parameterList[index].parameter != null && controller.data!.parameterList[index].parameter.isNotEmpty ? '(${controller.data!.parameterList[index].parameter.length})' : ''}',
                                                                    style:
                                                                        const TextStyle(
                                                                      fontFamily:
                                                                          "Bold",
                                                                      color:
                                                                          blackColor,
                                                                    ),
                                                                  ),
                                                                  trailing:
                                                                      // controller
                                                                      //         .data!
                                                                      //         .parameterList[
                                                                      //             index]
                                                                      //         .parameter
                                                                      //         .isEmpty
                                                                      //     ? Container(
                                                                      //         height:
                                                                      //             20,
                                                                      //         width: 45,
                                                                      //       )
                                                                      //     :
                                                                      InkWell(
                                                                    onTap: () {
                                                                      if (controller
                                                                              .data!
                                                                              .parameterList[
                                                                                  index]
                                                                              .type
                                                                              .toString() ==
                                                                          3
                                                                              .toString()) {
                                                                        Get.to(() => ProfileDetailScreen(int.parse(controller
                                                                            .data!
                                                                            .parameterList[index]
                                                                            .id
                                                                            .toString())));
                                                                      } else if (controller
                                                                              .data!
                                                                              .parameterList[index]
                                                                              .type
                                                                              .toString() ==
                                                                          2.toString()) {
                                                                        Get.to(() => ParameterDetailScreen(int.parse(controller
                                                                            .data!
                                                                            .parameterList[index]
                                                                            .id
                                                                            .toString())));
                                                                      }
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          20,
                                                                      width: 45,
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color:
                                                                            themeColor,
                                                                        borderRadius:
                                                                            BorderRadius.circular(5),
                                                                      ),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          'View',
                                                                          style:
                                                                              const TextStyle(
                                                                            fontFamily:
                                                                                "Bold",
                                                                            color:
                                                                                whiteColor,
                                                                            fontSize:
                                                                                10,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  children: [
                                                                    ...controller
                                                                        .data!
                                                                        .parameterList[
                                                                            index]
                                                                        .parameter
                                                                        .map(
                                                                            (e) {
                                                                      return Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                15,
                                                                            vertical:
                                                                                3),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Container(
                                                                              // color: Colors.red,
                                                                              width: Get.width * 0.73,
                                                                              child: Text(
                                                                                e.name,
                                                                                style: const TextStyle(
                                                                                  color: subTextColor,
                                                                                  fontFamily: "Regular",
                                                                                  overflow: TextOverflow.ellipsis,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            InkWell(
                                                                              onTap: () {
                                                                                print('peramiter call');
                                                                                Get.to(() => ParameterDetailScreen(int.parse(e.id.toString())));
                                                                              },
                                                                              child: Container(
                                                                                height: 20,
                                                                                width: 45,
                                                                                decoration: BoxDecoration(
                                                                                  color: themeColor,
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                                child: Center(
                                                                                  child: Text(
                                                                                    LANGUAGE_TYPE,
                                                                                    // View[LANGUAGE_TYPE],
                                                                                    style: const TextStyle(
                                                                                      fontFamily: "Bold",
                                                                                      color: whiteColor,
                                                                                      fontSize: 10,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }),
                                                                  ]);
                                                            }),
                                                      ),
                                                    ),

                                              ///----- Grid view ////////////
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    customeGrid(
                                                        AppImages.gridImage1,
                                                        Paramter_Included[
                                                            LANGUAGE_TYPE],
                                                        controller.data!
                                                                    .paramterIncluded ==
                                                                null
                                                            ? ""
                                                            : controller.data!
                                                                .paramterIncluded
                                                                .toString()),
                                                    customeGrid(
                                                      AppImages.gridImage2,
                                                      Sample_Collection[
                                                          LANGUAGE_TYPE],
                                                      controller.data!
                                                                  .sampleCollection ==
                                                              null
                                                          ? ""
                                                          : controller.data!
                                                                      .sampleCollection ==
                                                                  1
                                                              ? 'Free'
                                                              : 'Paid',
                                                    ),
                                                    customeGrid(
                                                        AppImages.gridImage3,
                                                        Doctor_Con_Fee[
                                                            LANGUAGE_TYPE],
                                                        controller.data!
                                                                    .sampleCollectionFee ==
                                                                null
                                                            ? ""
                                                            : controller.data!
                                                                        .sampleCollectionFee ==
                                                                    1
                                                                ? 'Free'
                                                                : 'Paid'),
                                                    customeGrid(
                                                        AppImages.gridImage4,
                                                        Test_Booked[
                                                            LANGUAGE_TYPE],
                                                        controller.data!
                                                                    .noOfParameter ==
                                                                null
                                                            ? ""
                                                            : controller.data!
                                                                .noOfParameter
                                                                .toString()),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    customeGrid(
                                                        AppImages.gridImage5,
                                                        Report_Time[
                                                            LANGUAGE_TYPE],
                                                        controller.data!
                                                                    .reportTime ==
                                                                null
                                                            ? ""
                                                            : controller.data!
                                                                .reportTime
                                                                .toString()),
                                                    customeGrid(
                                                      AppImages.gridImage6,
                                                      Fasting_Time[
                                                          LANGUAGE_TYPE],
                                                      controller.data!
                                                                  .fastingTime ==
                                                              null
                                                          ? ""
                                                          : controller.data!
                                                                      .fastingTime ==
                                                                  1
                                                              ? 'Yes'
                                                              : 'No',
                                                    ),
                                                    customeGrid(
                                                        AppImages.gridImage7,
                                                        Test_Recommanded[
                                                            LANGUAGE_TYPE],
                                                        controller.data!
                                                                    .testRecommendedFor ==
                                                                null
                                                            ? ""
                                                            : controller.data!
                                                                .testRecommendedFor
                                                                .toString()),
                                                    customeGrid(
                                                        AppImages.gridImage8,
                                                        Recommended_Age[
                                                            LANGUAGE_TYPE],
                                                        controller.data!
                                                                    .testRecommendedForAge ==
                                                                null
                                                            ? ""
                                                            : controller.data!
                                                                .testRecommendedForAge
                                                                .toString()),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),

                                              ///----- tab view ////////////
                                              DefaultTabController(
                                                length: 3,
                                                child: Container(
                                                  color: whiteColor,
                                                  child: Column(children: [
                                                    TabBar(
                                                      indicatorColor:
                                                          blackColor,
                                                      indicator:
                                                          const UnderlineTabIndicator(
                                                              borderSide:
                                                                  BorderSide(
                                                                      width:
                                                                          3.0),
                                                              insets: EdgeInsets
                                                                  .symmetric(
                                                                      horizontal:
                                                                          16.0,
                                                                      vertical:
                                                                          8)),
                                                      unselectedLabelStyle:
                                                          const TextStyle(
                                                        color: blackColor,
                                                        fontFamily: "Regular",
                                                      ),
                                                      // indicatorPadding: EdgeInsets.all(5),
                                                      labelColor: blackColor,
                                                      unselectedLabelColor:
                                                          blackColor,
                                                      labelStyle:
                                                          const TextStyle(
                                                        color: blackColor,
                                                        fontFamily: "Bold",
                                                      ),
                                                      onTap: (index) {
                                                        print(index);
                                                        controller
                                                            .changeTab(index);
                                                        // setState(() {
                                                        //   _selectedTabbar = index;
                                                        // });
                                                      },
                                                      tabs: const [
                                                        Tab(
                                                          text: 'Overview',
                                                        ),
                                                        Tab(
                                                          text: 'FRQ',
                                                        ),
                                                        Tab(
                                                          text: 'Reviews',
                                                        ),
                                                      ],
                                                    ),
                                                    Builder(builder: (_) {
                                                      if (controller
                                                              .selectedTabbar ==
                                                          0) {
                                                        return controller
                                                                .description!
                                                                .isEmpty
                                                            ? Container()
                                                            : Container(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  child:
                                                                      HtmlWidget(
                                                                    '${controller.description != null ? controller.description : ''}',
                                                                    textStyle:
                                                                        TextStyle(
                                                                      color:
                                                                          subTextColor,
                                                                      fontFamily:
                                                                          "Regular",
                                                                    ),
                                                                  ),
                                                                  // Html(
                                                                  //   data: controller.data!.description,
                                                                  //   style: {
                                                                  //     "p": Style(
                                                                  //       color: subTextColor,
                                                                  //       fontFamily: "Regular",
                                                                  //     ),
                                                                  //   },
                                                                  // ),
                                                                ),
                                                              ); //1st custom tabBarView
                                                      } else if (controller
                                                              .selectedTabbar ==
                                                          1) {
                                                        return controller.data!
                                                                .frqlist.isEmpty
                                                            ? Container()
                                                            : ListView.builder(
                                                                itemCount:
                                                                    controller
                                                                        .data!
                                                                        .frqlist
                                                                        .length,
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    const ScrollPhysics(),
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          controller
                                                                              .data!
                                                                              .frqlist[index]
                                                                              .question,
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                18,
                                                                            fontFamily:
                                                                                "Bold",
                                                                          ),
                                                                        ),
                                                                        Divider(),
                                                                        HtmlWidget(
                                                                          '${controller.data!.frqlist[index].ans}',
                                                                          // data: controller.categoryDetailModel!.data!.description,
                                                                          textStyle:
                                                                              TextStyle(
                                                                            color:
                                                                                subTextColor,
                                                                            fontFamily:
                                                                                "Regular",
                                                                          ),
                                                                        ),
                                                                        // Html(
                                                                        //   data: controller.data!.frqlist[index].ans,
                                                                        //   style: {
                                                                        //     "*": Style(
                                                                        //       color: subTextColor,
                                                                        //       fontFamily: "Regular",
                                                                        //     ),
                                                                        //   },
                                                                        // ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                }); //2nd tabView
                                                      } else {
                                                        return controller.data!
                                                                .review.isEmpty
                                                            ? Container()
                                                            : ListView.builder(
                                                                itemCount:
                                                                    controller
                                                                        .data!
                                                                        .review
                                                                        .length,
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    const ScrollPhysics(),
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  DateTime
                                                                      tempDate =
                                                                      DateFormat("dd-MM-yyyy hh:mm:ss").parse(controller
                                                                          .data!
                                                                          .review[
                                                                              index]
                                                                          .date);
                                                                  var date = DateFormat
                                                                          .yMMMd()
                                                                      .format(
                                                                          tempDate);
                                                                  return Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .only(
                                                                              left: 10),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              Row(
                                                                                children: [
                                                                                  Container(
                                                                                    height: 50,
                                                                                    width: 50,
                                                                                    decoration: controller.data!.review[index].profilePic.isEmpty
                                                                                        ? BoxDecoration(
                                                                                            borderRadius: BorderRadius.circular(50),
                                                                                            image: const DecorationImage(
                                                                                              image: AssetImage("assets/profile/user.png"),
                                                                                              fit: BoxFit.fill,
                                                                                            ),
                                                                                          )
                                                                                        : BoxDecoration(
                                                                                            borderRadius: BorderRadius.circular(50),
                                                                                            image: DecorationImage(
                                                                                              image: NetworkImage(
                                                                                                AppImages.reviewBaseUrl + controller.data!.review[index].profilePic,
                                                                                              ),
                                                                                              fit: BoxFit.fill,
                                                                                            ),
                                                                                          ),
                                                                                  ),
                                                                                  const SizedBox(
                                                                                    width: 15,
                                                                                  ),
                                                                                  Column(
                                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                                    children: [
                                                                                      Text(
                                                                                        controller.data!.review[index].username,
                                                                                        style: const TextStyle(
                                                                                          fontFamily: "Regular",
                                                                                          fontWeight: FontWeight.bold,
                                                                                          color: blackColor,
                                                                                        ),
                                                                                      ),
                                                                                      const SizedBox(
                                                                                        height: 2,
                                                                                      ),
                                                                                      Text(
                                                                                        controller.data!.review[index].date == null ? "" : date,
                                                                                        style: const TextStyle(
                                                                                          fontFamily: "Regular",
                                                                                          color: subTextColor,
                                                                                        ),
                                                                                      )
                                                                                    ],
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              controller.data!.review[index].ratting.toString() == 5.toString()
                                                                                  ? SizedBox(
                                                                                      height: 10,
                                                                                      child: Row(
                                                                                        children: List.generate(
                                                                                            5,
                                                                                            (index) => Padding(
                                                                                                  padding: const EdgeInsets.only(right: 2),
                                                                                                  child: Icon(
                                                                                                    Icons.star,
                                                                                                    color: (index == 0 || index == 1 || index == 2 || index == 3 || index == 4) ? starColor : subTextColor,
                                                                                                    size: 12,
                                                                                                  ),
                                                                                                )),
                                                                                      ),
                                                                                    )
                                                                                  : controller.data!.review[index].ratting.toString() == 4.toString()
                                                                                      ? SizedBox(
                                                                                          height: 10,
                                                                                          child: Row(
                                                                                            children: List.generate(
                                                                                                5,
                                                                                                (index) => Padding(
                                                                                                      padding: const EdgeInsets.only(right: 2),
                                                                                                      child: Icon(
                                                                                                        Icons.star,
                                                                                                        color: (index == 0 || index == 1 || index == 2 || index == 3) ? starColor : subTextColor,
                                                                                                        size: 12,
                                                                                                      ),
                                                                                                    )),
                                                                                          ),
                                                                                        )
                                                                                      : controller.data!.review[index].ratting.toString() == 3.toString()
                                                                                          ? SizedBox(
                                                                                              height: 10,
                                                                                              child: Row(
                                                                                                children: List.generate(
                                                                                                    5,
                                                                                                    (index) => Padding(
                                                                                                          padding: const EdgeInsets.only(right: 2),
                                                                                                          child: Icon(
                                                                                                            Icons.star,
                                                                                                            color: (index == 0 || index == 1 || index == 2) ? starColor : subTextColor,
                                                                                                            size: 12,
                                                                                                          ),
                                                                                                        )),
                                                                                              ),
                                                                                            )
                                                                                          : controller.data!.review[index].ratting.toString() == 2.toString()
                                                                                              ? SizedBox(
                                                                                                  height: 10,
                                                                                                  child: Row(
                                                                                                    children: List.generate(
                                                                                                        5,
                                                                                                        (index) => Padding(
                                                                                                              padding: const EdgeInsets.only(right: 2),
                                                                                                              child: Icon(
                                                                                                                Icons.star,
                                                                                                                color: (index == 0 || index == 1) ? starColor : subTextColor,
                                                                                                                size: 12,
                                                                                                              ),
                                                                                                            )),
                                                                                                  ),
                                                                                                )
                                                                                              : SizedBox(
                                                                                                  height: 10,
                                                                                                  child: Row(
                                                                                                    children: List.generate(
                                                                                                        5,
                                                                                                        (index) => Padding(
                                                                                                              padding: const EdgeInsets.only(right: 2),
                                                                                                              child: Icon(
                                                                                                                Icons.star,
                                                                                                                color: (index == 0) ? starColor : subTextColor,
                                                                                                                size: 12,
                                                                                                              ),
                                                                                                            )),
                                                                                                  ),
                                                                                                ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        const Divider(),
                                                                        // Html(
                                                                        //   data: controller.data!.review[index].description,
                                                                        //   style: {
                                                                        //     "*": Style(
                                                                        //       color: subTextColor,
                                                                        //       fontFamily: "Regular",
                                                                        //     ),
                                                                        //   },
                                                                        // ),
                                                                        HtmlWidget(
                                                                          '${controller.data!.review[index].description}',
                                                                          // data: controller.categoryDetailModel!.data!.description,
                                                                          textStyle:
                                                                              TextStyle(
                                                                            color:
                                                                                subTextColor,
                                                                            fontFamily:
                                                                                "Regular",
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  );
                                                                }); //3rd tabView
                                                      }
                                                    }),
                                                  ]),
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Padding(
                                          //   padding: EdgeInsets.all(8),
                                          //   child: customeElevatedButton(
                                          //     width,
                                          //     Book_Now[LANGUAGE_TYPE],
                                          //     // callback: () => Get.to(()=>PackageDetailScreen(packageId)),
                                          //     callback: () {
                                          //       var userData = Get.find<PackageDetailController>().userDetails;
                                          //       var data = Get.find<PackageDetailController>().packageDetail!.data;
                                          //       double mrps = double.parse(data.mrp.toString());
                                          //       double prices = double.parse(data.price.toString());
                                          //       var localPackageData = LocalPackageModel(
                                          //         id: data.id,
                                          //         userId: -1,
                                          //         packageId: data.id,
                                          //         packageType: 1,
                                          //         packageName: data.name,
                                          //         packageMrp: mrps.toInt(),
                                          //         packagePrice: prices.toInt(),
                                          //         packageParameters: data.noOfParameter.toString(),
                                          //         packageDiscount: 10.toString(),
                                          //       );
                                          //       if (userData.isLoggedIn) {
                                          //         Get.to(
                                          //           () => MemberList(localPackageModel: localPackageData),
                                          //         );
                                          //       } else {
                                          //         Get.to(() => LoginScreen(index: 5, localPackageData: localPackageData));
                                          //       }
                                          //     },
                                          //   ),
                                          // ),
                                        ],
                                      )),
                                ],
                              ),
                            );
                }),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: customeElevatedButton(
              width,
              Book_Now[LANGUAGE_TYPE],
              // callback: () => Get.to(()=>PackageDetailScreen(packageId)),
              callback: () {
                var userData = Get.find<PackageDetailController>().userDetails;
                var data =
                    Get.find<PackageDetailController>().packageDetail!.data;
                double mrps = double.parse(data.mrp.toString());
                double prices = double.parse(data.price.toString());
                var localPackageData = LocalPackageModel(
                  id: data.id,
                  userId: -1,
                  packageId: data.id,
                  packageType: 1,
                  packageName: data.name,
                  packageMrp: mrps.toInt(),
                  packagePrice: prices.toInt(),
                  packageParameters: data.noOfParameter.toString(),
                  packageDiscount: 10.toString(),
                );
                if (userData.isLoggedIn) {
                  Get.to(
                    () => MemberList(localPackageModel: localPackageData),
                  );
                } else {
                  Get.to(() => LoginScreen(
                      index: 5, localPackageData: localPackageData));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
