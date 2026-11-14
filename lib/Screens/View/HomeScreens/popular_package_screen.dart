// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Screens/View/HomeScreens/package_details_screen.dart';

import 'package:diagnostics_patient/componant/custome_appBar.dart';
import 'package:diagnostics_patient/controller/popular_package_controller.dart';
import 'package:diagnostics_patient/utils/AllText.dart';
import 'package:diagnostics_patient/utils/App_Images.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/strings.dart';

class PopularPackageScreen extends StatelessWidget {
  PopularPackageController categoryListController =
      Get.put(PopularPackageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
              title: Popular_package[LANGUAGE_TYPE],
              isArrow: true,
              isAction: false),
          Expanded(
            child: GetBuilder<PopularPackageController>(
                init: PopularPackageController(),
                builder: (controller) {
                  return controller.isLoading
                      ? const Center(
                          child: SizedBox(
                            height: 150,
                            width: 35,
                            child: Center(
                                child: CircularProgressIndicator(
                              color: themeColor,
                            )),
                          ),
                        )
                      : controller.popularPackageModelList!.isEmpty
                          ? Container(
                              alignment: Alignment.center,
                              child: const Text('No Data Found',
                                  style: TextStyle(
                                    color: blackColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                  )),
                            )
                          : Container(
                              color: themeSecondaryColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MasonryGridView.count(
                                    padding: EdgeInsets.zero,
                                    crossAxisCount: 2,
                                    mainAxisSpacing: 4,
                                    crossAxisSpacing: 4,
                                    // gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    //   crossAxisCount: 2,
                                    //   crossAxisSpacing: 10.0,
                                    //   childAspectRatio: 0.8,
                                    //   mainAxisSpacing: 10.0,
                                    // ),
                                    itemCount: controller
                                        .popularPackageModelList!.length,
                                    itemBuilder: (context, index) {
                                      int mrp = controller
                                          .popularPackageModelList![index].mrp;
                                      double discount = double.parse(controller
                                          .popularPackageModelList![index]
                                          .discount
                                          .fixed
                                          .toString());
                                      double totalDiscount = mrp - discount;
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          image: const DecorationImage(
                                            fit: BoxFit.fill,
                                            image: AssetImage(
                                              AppImages.defaultImage,
                                            ),
                                          ),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8,
                                                          right: 8,
                                                          top: 12,
                                                          bottom: 3),
                                                  child: Text(
                                                    '${controller.popularPackageModelList![index].name} (${controller.popularPackageModelList![index].noOfParameter.toString()})',
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontFamily: "Bold",
                                                      color: whiteColor,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8, right: 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          controller
                                                                      .popularPackageModelList![
                                                                          index]
                                                                      .price !=
                                                                  0
                                                              ? Text(
                                                                  "₹" +
                                                                      controller
                                                                          .popularPackageModelList![
                                                                              index]
                                                                          .price
                                                                          .toString(),
                                                                  style:
                                                                      const TextStyle(
                                                                    fontFamily:
                                                                        "Regular",
                                                                    color:
                                                                        whiteColor,
                                                                    fontSize:
                                                                        11,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                  ),
                                                                )
                                                              : SizedBox(),
                                                          controller
                                                                      .popularPackageModelList![
                                                                          index]
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
                                                          controller
                                                                      .popularPackageModelList![
                                                                          index]
                                                                      .price !=
                                                                  0
                                                              ? Text(
                                                                  "₹" +
                                                                      controller
                                                                          .popularPackageModelList![
                                                                              index]
                                                                          .mrp
                                                                          .toString(),
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
                                                        ],
                                                      ),
                                                      controller
                                                                  .popularPackageModelList![
                                                                      index]
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
                                                              child: Center(
                                                                child: Text(
                                                                  "${controller.popularPackageModelList![index].discount.per}%",
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
                                                    ],
                                                  ),
                                                ),
                                                // Padding(
                                                //   padding: const EdgeInsets.only(left: 8, right: 8, bottom: 1),
                                                //   child: Text(
                                                //     "Include : " + controller.popularPackageModelList![index].noOfParameter.toString() + " Parameteres",
                                                //     style: const TextStyle(
                                                //       fontSize: 12,
                                                //       fontFamily: "Regular",
                                                //       color: subTextColor,
                                                //     ),
                                                //   ),
                                                // ),
                                                Divider(color: whiteColor),
                                                ...((controller
                                                        .popularPackageModelList![
                                                            index]
                                                        .parameterList)!
                                                    .map((e) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 8,
                                                            right: 8,
                                                            top: 1,
                                                            bottom: 1),
                                                    child: Row(
                                                      children: [
                                                        const Icon(
                                                          Icons.done,
                                                          color: redColor,
                                                          size: 10,
                                                        ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        Flexible(
                                                          child: Text(
                                                            e.name,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                            style:
                                                                const TextStyle(
                                                              color: whiteColor,
                                                              fontSize: 10,
                                                              fontFamily:
                                                                  "Regular",
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList())
                                              ],
                                            ),
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: ElevatedButton(
                                                  onPressed: () {
                                                    /// 1=>package,2=>parameter,3=>profile
                                                    // int type = categoryListController.popularPackageModelList![index].type;
                                                    // print('type $type');
                                                    // print('id ${categoryListController.popularPackageModelList![index].typeId}');
                                                    // if (type == 1) {
                                                    //   Get.to(() => PackageDetailScreen(categoryListController.popularPackageModelList![index].typeId));
                                                    // } else if (type == 2) {
                                                    //   Get.to(() => ParameterDetailScreen(categoryListController.popularPackageModelList![index].typeId));
                                                    //   // Open parameter
                                                    // } else if (type == 3) {
                                                    //   // ProfileDetailScreen()
                                                    //   Get.to(() => ProfileDetailScreen(categoryListController.popularPackageModelList![index].typeId));
                                                    //   // Open Profile
                                                    // }
                                                    Get.to(() => PackageDetailScreen(
                                                        categoryListController
                                                            .popularPackageModelList![
                                                                index]
                                                            .id));
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: whiteColor,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                    ),
                                                    maximumSize:
                                                        const Size(130, 40),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    children: [
                                                      Text(
                                                        View_Detail[
                                                            LANGUAGE_TYPE],
                                                        style: const TextStyle(
                                                          color: blackColor,
                                                          fontFamily: "Regular",
                                                          fontSize: 11

                                                        ),
                                                      ),
                                                      // SizedBox(width: 10,),
                                                      const Icon(
                                                        Icons.arrow_forward,
                                                        color: blackColor,
                                                        size: 14,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            );
                }),
          ),
        ],
      ),
    );
  }
}
