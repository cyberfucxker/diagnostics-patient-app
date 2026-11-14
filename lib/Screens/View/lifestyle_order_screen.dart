import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/componant/custome_appBar.dart';
import 'package:diagnostics_patient/controller/category_Controller.dart';
import 'package:diagnostics_patient/utils/App_Images.dart';
import 'package:diagnostics_patient/utils/colors.dart';

import 'HomeScreens/category_detail_screen.dart';

class TestByLifeStyleOrderScreen extends StatefulWidget {
  @override
  State<TestByLifeStyleOrderScreen> createState() =>
      _TestByLifeStyleOrderScreenState();
}

class _TestByLifeStyleOrderScreenState
    extends State<TestByLifeStyleOrderScreen> {
  // ✅ Get.find — already HomeScreen mein put ho chuka hai
  final CategoryController categoryListController =
  Get.find<CategoryController>();

  @override
  void initState() {
    super.initState();
    // ✅ FIX: build phase ke baad call karo — setState during build crash fix
    WidgetsBinding.instance.addPostFrameCallback((_) {
      categoryListController.getCategory(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: 'Test by Lifestyle Disorder',

            isArrow: true,
            isAction: false,
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: GetBuilder<CategoryController>(
                  // ✅ init: CategoryController() hata diya — naya instance nahi banana
                  builder: (controller) {
                    // Loading
                    if (controller.isLoading) {
                      return const SizedBox(
                        height: 300,
                        child: Center(
                          child: CircularProgressIndicator(color: themeColor),
                        ),
                      );
                    }

                    // Empty
                    if (controller.categoryModelList?.isEmpty ?? true) {
                      return const SizedBox(
                        height: 300,
                        child: Center(
                          child: Text(
                            'No Data Found',
                            style: TextStyle(
                              color: blackColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      );
                    }

                    // Grid
                    return GridView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: controller.categoryModelList!.length,
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 1,
                      ),
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        final item = controller.categoryModelList![index];
                        return GestureDetector(
                          onTap: () {
                            log('Category id: ${item.id}');
                            Get.to(() => CategoryDetailScreen(id: item.id!));
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: const DecorationImage(
                                fit: BoxFit.fill,
                                image: AssetImage(AppImages.defaultImage),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 15,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),

                                  // ✅ Image with error handler
                                  Image.network(
                                    item.image,
                                    height: 50,
                                    width: 50,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.image_not_supported,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),

                                  const SizedBox(height: 10),

                                  // Name
                                  Text(
                                    item.name.toString(),
                                    style: const TextStyle(
                                      fontFamily: "Bold",
                                      color: whiteColor,
                                      fontSize: 18,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),

                                  const SizedBox(height: 7),

                                  // ✅ null-safe short_desc
                                  if (item.short_desc != null &&
                                      item.short_desc!.isNotEmpty)
                                    Text(
                                      item.short_desc![0]
                                          .toString()
                                          .toUpperCase() +
                                          item.short_desc
                                              .toString()
                                              .substring(1),
                                      style: const TextStyle(
                                        fontFamily: "Regular",
                                        color: whiteColor,
                                        fontSize: 13,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}