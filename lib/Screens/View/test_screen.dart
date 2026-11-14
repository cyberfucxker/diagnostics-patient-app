// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Screens/View/HomeScreens/parameter_details_screen.dart';
import 'package:diagnostics_patient/Screens/test_detail_screen.dart';
import 'package:diagnostics_patient/componant/custome_appBar.dart';
import 'package:diagnostics_patient/controller/test_controller.dart';
import 'package:diagnostics_patient/controller/test_detail_controller.dart';
import 'package:diagnostics_patient/utils/AllText.dart';
import 'package:diagnostics_patient/utils/App_Images.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/strings.dart';

class TestScreen extends StatelessWidget {
  TestController testController = Get.put(TestController());
  @override
  Widget build(BuildContext context) {
    print('Enter in TestScreen');
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: tests[LANGUAGE_TYPE], isArrow: true, isAction: false),
          Expanded(
            child: GetBuilder<TestController>(
                init: TestController(),
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
                      : controller.testModelList!.isEmpty 
                          ? Container(
                              alignment: Alignment.center,
                              child: const Text('No Data Found',
                                  style: TextStyle(
                                    color: blackColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w300,
                                  )),
                            )
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CustomScrollView(
                                slivers: [
                                  SliverList(
                                    delegate: SliverChildListDelegate([
                                      MasonryGridView.count(
                                          physics: NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
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
                                          itemCount: controller.testModelList!.length,
                                          itemBuilder: (context, index) {
                                            int mrp = controller.testModelList![index].mrp!;
                                            double discount = double.parse(controller.testModelList![index].discount.fixed.toString());
                                            double totalDiscount = mrp - discount;
                                            return Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                image: const DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: AssetImage(
                                                    AppImages.defaultImage,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 3),
                                                        child: Text(
                                                          '${controller.testModelList![index].profileName} (${controller.testModelList![index].countOfParamas})',
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(
                                                            fontFamily: "Bold",
                                                            color: whiteColor,
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.only(left: 8, right: 8),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              children: [
                                                                controller.testModelList![index].price != 0
                                                                    ? Text(
                                                                        "₹" + controller.testModelList![index].price.toString(),
                                                                        style: const TextStyle(
                                                                          fontFamily: "Regular",
                                                                          color: whiteColor,
                                                                          fontSize: 11,
                                                                          decoration: TextDecoration.lineThrough,
                                                                        ),
                                                                      )
                                                                    : SizedBox(),
                                                                controller.testModelList![index].price != 0
                                                                    ? Text(
                                                                        " / ",
                                                                        style: TextStyle(
                                                                          color: whiteColor,
                                                                        ),
                                                                      )
                                                                    : SizedBox(),
                                                                controller.testModelList![index].price != 0
                                                                    ? Text(
                                                                        // "₹" + totalDiscount.toString(),
                                                                        "₹" + '${controller.testModelList![index].mrp}',
                                                                        style: const TextStyle(
                                                                          fontFamily: "Regular",
                                                                          color: whiteColor,
                                                                          fontSize: 11,
                                                                        ),
                                                                      )
                                                                    : SizedBox(),
                                                              ],
                                                            ),
                                                            controller.testModelList![index].discount.per != 0
                                                                ? Container(
                                                                    height: 25,
                                                                    width: 40,
                                                                    decoration: const BoxDecoration(
                                                                      image: DecorationImage(
                                                                        image: AssetImage(
                                                                          "assets/popular_package/discount.png",
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    child: Center(
                                                                      child: Text(
                                                                        "${controller.testModelList![index].discount.per}%",
                                                                        // "\$${24}.00",
                                                                        style: TextStyle(
                                                                          color: whiteColor,
                                                                          fontSize: 10,
                                                                          fontFamily: "Regular",
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
                                                      //     "Include : " + '${controller.testModelList![index].countOfParamas}' + " Parameteres",
                                                      //     style: const TextStyle(
                                                      //       fontSize: 12,
                                                      //       fontFamily: "Regular",
                                                      //       color: subTextColor,
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      const Divider(color: whiteColor),
                                                      ...(controller.testModelList![index].paramaterData!).map((e) {
                                                        return Padding(
                                                          padding: const EdgeInsets.only(left: 8, right: 8, top: 1, bottom: 1),
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
                                                                  e,
                                                                  overflow: TextOverflow.ellipsis,
                                                                  maxLines: 1,
                                                                  style: const TextStyle(
                                                                    color: whiteColor,
                                                                    fontSize: 10,
                                                                    fontFamily: "Regular",
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        );
                                                      }).toList(),
                                                    ],
                                                  ),
                                                  Center(
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(bottom: 5),
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          Get.put(TestDetailController()).getTestDetail(controller.testModelList![index].id!);
                                                          Get.put(TestDetailController()).update();
                                                          Get.to(() => TestDetailsScreen(testListModel: controller.testModelList![index]));
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor: whiteColor,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(50),
                                                          ),
                                                          maximumSize: const Size(130, 40),
                                                        ),
                                                        child:  Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Flexible(
                                                              child: Text(
                                                                View_Detail[LANGUAGE_TYPE],
                                                                overflow: TextOverflow.ellipsis,
                                                                maxLines: 1,
                                                                style: const TextStyle(
                                                                  color: blackColor,
                                                                  fontFamily: "Regular",
                                                                  fontSize: 12
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(width: 4),
                                                            const Icon(
                                                              Icons.arrow_forward,
                                                              color: blackColor,
                                                              size: 16,
                                                            ),
                                                          ],
                                                        )
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      GetBuilder<TestController>(builder: (tController) {
                                        return MasonryGridView.count(
                                            physics: NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
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
                                            itemCount: (controller.getParameterModel?.data != null)? controller.getParameterModel!.data.length:0,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(15),
                                                  image: const DecorationImage(
                                                    fit: BoxFit.fill,
                                                    image: AssetImage(
                                                      AppImages.defaultImage,
                                                    ),
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 3),
                                                          child: Text(
                                                            controller.getParameterModel!.data[index].testShortCode,
                                                            maxLines: 2,
                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(
                                                              fontFamily: "Bold",
                                                              color: whiteColor,
                                                            ),
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 8, right: 8),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    "₹" + controller.getParameterModel!.data[index].mrp.toString(),
                                                                    style: const TextStyle(
                                                                      fontFamily: "Regular",
                                                                      color: whiteColor,
                                                                      fontSize: 11,
                                                                      // decoration: TextDecoration.lineThrough,
                                                                    ),
                                                                  ),
                                                                  // const Text(
                                                                  //   " / ",
                                                                  //   style: TextStyle(
                                                                  //     color: whiteColor,
                                                                  //   ),
                                                                  // ),
                                                                  // Text(
                                                                  //   "₹" + double.parse(controller.getParameterModel!.data[index].price.toString()).toStringAsFixed(0),
                                                                  //   style: const TextStyle(
                                                                  //     fontFamily: "Regular",
                                                                  //     color: whiteColor,
                                                                  //     fontSize: 11,
                                                                  //   ),
                                                                  // ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Center(
                                                      child: Padding(
                                                        padding: const EdgeInsets.only(bottom: 5),
                                                        child: ElevatedButton(
                                                          onPressed: () {
                                                            Get.to(() => ParameterDetailScreen(controller.getParameterModel!.data[index].id));
                                                          },
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor: whiteColor,
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(50),
                                                            ),
                                                            maximumSize: const Size(130, 40),
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              Text(
                                                                View_Detail[LANGUAGE_TYPE],
                                                                style: const TextStyle(
                                                                  color: blackColor,
                                                                  fontFamily: "Regular",
                                                                ),
                                                              ),
                                                              // SizedBox(width: 10,),
                                                              const Icon(
                                                                Icons.arrow_forward,
                                                                color: blackColor,
                                                                size: 16,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            });
                                      }),
                                    ]),
                                  ),
                                ],
                              ),
                            );
                }),
          ),
        ],
      ),
    );
  }
}
