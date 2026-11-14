import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/Screens/View/HomeScreens/package_details_screen.dart';
import 'package:diagnostics_patient/Screens/View/HomeScreens/parameter_details_screen.dart';
import 'package:diagnostics_patient/Screens/View/HomeScreens/profile_details_screen.dart';
import 'package:diagnostics_patient/controller/category_detail_controller.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import '../../../componant/custome_appBar.dart';
import '../../../utils/AllText.dart';
import '../../../utils/App_Images.dart';
import '../../../utils/strings.dart';

class CategoryDetailScreen extends StatelessWidget {
  final int id;

  const CategoryDetailScreen({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeSecondaryColor,
      body: DefaultTabController(
        length: 3,
        child: GetBuilder<CategoryDetailController>(
          init: CategoryDetailController(id),
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── AppBar ───
                CustomAppBar(
                  title: controller.categoryDetailModel?.data?.name ??
                      CATEGORY_DETAIL[LANGUAGE_TYPE],
                  isArrow: true,
                  isAction: false,
                ),

                // ─── TabBar ───
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: const TabBar(
                    indicatorPadding: EdgeInsets.symmetric(horizontal: 10),
                    indicatorWeight: 3,
                    indicatorColor: blackColor,
                    labelColor: blackColor,
                    unselectedLabelColor: subTextColor,
                    labelStyle:
                    TextStyle(fontSize: 16, fontFamily: 'Regular'),
                    tabs: [
                      Tab(text: 'Package'),
                      Tab(text: 'Parameter'),
                      Tab(text: 'Profile'),
                    ],
                  ),
                ),

                // ─── TabBarView ───
                Expanded(
                  child: TabBarView(
                    children: [
                      _TabContent(
                        controller: controller,
                        tabType: 1,
                        dataList: controller.packageDetail1,
                      ),
                      _TabContent(
                        controller: controller,
                        tabType: 2,
                        dataList: controller.packageDetail2,
                      ),
                      _TabContent(
                        controller: controller,
                        tabType: 3,
                        dataList: controller.packageDetail3,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// ✅ Extracted Tab Content — teeno tabs same code share karte hain
// ═══════════════════════════════════════════

class _TabContent extends StatelessWidget {
  final CategoryDetailController controller;
  final int tabType;
  final List<dynamic>? dataList;

  const _TabContent({
    required this.controller,
    required this.tabType,
    required this.dataList,
  });

  @override
  Widget build(BuildContext context) {
    // Loading
    if (controller.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: themeColor),
      );
    }

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: GetBuilder<CategoryDetailController>(
        builder: (ctrl) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ─── Grid ───
              if (dataList != null && dataList!.isNotEmpty)
                MasonryGridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(5),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  itemCount: dataList!.length,
                  itemBuilder: (context, index) {
                    final data = dataList![index];
                    if (data.type != tabType) return const SizedBox();
                    return _PackageCard(data: data);
                  },
                )
              else
                const SizedBox(
                  height: 150,
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
                ),

              const SizedBox(height: 10),

              // ─── Description Title ───
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: boldText(
                  text:
                  '${ctrl.categoryDetailModel?.data?.name ?? ''} Description',
                  size: 20,
                ),
              ),

              // ─── Description Card ───
              Container(
                width: double.infinity,
                margin:
                const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                padding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: HtmlWidget(
                  '${ctrl.categoryDetailModel?.data?.description ?? ''}',
                  textStyle: const TextStyle(
                    color: subTextColor,
                    fontFamily: "Regular",
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════
// ✅ Extracted Package Card
// ═══════════════════════════════════════════

class _PackageCard extends StatelessWidget {
  final dynamic data;

  const _PackageCard({required this.data});

  void _navigateToDetail() {
    final int type = data.type ?? 0;
    if (type == 1) {
      Get.to(() => PackageDetailScreen(data.id!));
    } else if (type == 2) {
      Get.to(() => ParameterDetailScreen(data.id!));
    } else if (type == 3) {
      Get.to(() => ProfileDetailScreen(data.id!));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(AppImages.defaultImage),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Name ───
          Padding(
            padding:
            const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 3),
            child: Text(
              data.name ?? '',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: "Bold",
                color: whiteColor,
              ),
            ),
          ),

          // ─── Price Row ───
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Price with strikethrough
                Flexible(
                  child: Row(
                    children: [
                      if (data.price != 0) ...[
                        Flexible(
                          child: Text(
                            "₹${data.price}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: "Regular",
                              color: whiteColor,
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                        const Text(
                          " / ",
                          style: TextStyle(color: whiteColor, fontSize: 11),
                        ),
                        Flexible(
                          child: Text(
                            "₹${data.mrp}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: "Regular",
                              color: whiteColor,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ] else
                        Flexible(
                          child: Text(
                            "₹${data.mrp}",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: "Regular",
                              color: whiteColor,
                              fontSize: 11,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Discount Badge
                if (data.discount.per != 0)
                  Container(
                    height: 25,
                    width: 40,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                            "assets/popular_package/discount.png"),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "${data.discount.per}%",
                        style: const TextStyle(
                          color: whiteColor,
                          fontSize: 10,
                          fontFamily: "Regular",
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // ─── Parameters count ───
          Padding(
            padding:
            const EdgeInsets.only(left: 8, right: 8, bottom: 4, top: 2),
            child: Text(
              "Includes: ${data.noOfParameter} Parameters",
              style: const TextStyle(
                fontSize: 11,
                fontFamily: "Regular",
                color: subTextColor,
              ),
            ),
          ),

          const Divider(color: whiteColor, height: 8),

          // ─── Parameter List ───
          if (data.parameterList != null)
            ...data.parameterList!.map<Widget>((e) {
              return Padding(
                padding:
                const EdgeInsets.only(left: 8, right: 8, top: 1, bottom: 1),
                child: Row(
                  children: [
                    const Icon(Icons.done, color: redColor, size: 10),
                    const SizedBox(width: 6),
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

          // ─── View Detail Button ───
          Center(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 6),
              child: ElevatedButton(
                onPressed: _navigateToDetail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  // ✅ FIX: padding kam kiya — overflow fix
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  minimumSize: const Size(0, 32),
                  maximumSize: const Size(130, 40),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // ✅ FIX: min size lega
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        View_Detail[LANGUAGE_TYPE],
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: blackColor,
                          fontFamily: "Regular",
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward,
                      color: blackColor,
                      size: 14, // ✅ FIX: size thoda chhota
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}