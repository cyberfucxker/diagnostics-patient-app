// ignore_for_file: unnecessary_null_comparison, must_be_immutable,
//                 non_constant_identifier_names, deprecated_member_use

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:diagnostics_patient/Models/local_package_detail_model.dart';
import 'package:diagnostics_patient/Models/test_model.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/Screens/View/AuthScreen/login_screen.dart';
import 'package:diagnostics_patient/Screens/View/FamilyMemberListScreen/member_list_screen.dart';
import 'package:diagnostics_patient/Screens/View/HomeScreens/parameter_details_screen.dart';
import 'package:diagnostics_patient/componant/custome_appBar.dart';
import 'package:diagnostics_patient/controller/test_detail_controller.dart';
import 'package:diagnostics_patient/utils/AllText.dart';
import 'package:diagnostics_patient/utils/App_Images.dart';
import 'package:diagnostics_patient/utils/api.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

// ─── Shimmer Widget ───────────────────────────────────────────────────────────
class _ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  const _ShimmerBox({
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  State<_ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<_ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _anim = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value + 1, 0),
            colors: const [
              Color(0xFFE8E8E8),
              Color(0xFFF5F5F5),
              Color(0xFFE0E0E0),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Shimmer Loading Layout ───────────────────────────────────────────────────
class _ShimmerLoading extends StatelessWidget {
  const _ShimmerLoading();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const _ShimmerBox(width: 160, height: 20),
                    Row(children: const [
                      _ShimmerBox(width: 30, height: 30, radius: 50),
                      SizedBox(width: 8),
                      _ShimmerBox(width: 30, height: 30, radius: 50),
                    ]),
                  ],
                ),
                const SizedBox(height: 12),
                const _ShimmerBox(width: 120, height: 14),
                const SizedBox(height: 10),
                const _ShimmerBox(width: 200, height: 14),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _ShimmerBox(width: 100, height: 16),
                    _ShimmerBox(width: 40, height: 24, radius: 6),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.75,
              children: List.generate(
                8,
                    (_) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      _ShimmerBox(width: 36, height: 36, radius: 50),
                      SizedBox(height: 8),
                      _ShimmerBox(width: 50, height: 10),
                      SizedBox(height: 4),
                      _ShimmerBox(width: 30, height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 12),
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _ShimmerBox(width: 70, height: 14),
                _ShimmerBox(width: 40, height: 14),
                _ShimmerBox(width: 60, height: 14),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                6,
                    (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _ShimmerBox(
                    width: i % 3 == 0
                        ? double.infinity
                        : i % 3 == 1
                        ? 260
                        : 180,
                    height: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Star Rating Widget ───────────────────────────────────────────────────────
class _StarRating extends StatelessWidget {
  final double rating;
  final double size;
  const _StarRating({required this.rating, this.size = 12});

  @override
  Widget build(BuildContext context) {
    final filled = rating.round().clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Padding(
          padding: const EdgeInsets.only(right: 2),
          child: Icon(
            i < filled ? Icons.star_rounded : Icons.star_outline_rounded,
            color: i < filled ? starColor : subTextColor,
            size: size,
          ),
        );
      }),
    );
  }
}

// ─── Info Grid Tile ───────────────────────────────────────────────────────────
class _InfoTile extends StatelessWidget {
  final String image;
  final String label;
  final String? value;
  const _InfoTile(this.image, this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(image, height: 32, width: 32),
          const SizedBox(height: 6),
          Flexible(
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: "Regular",
                fontSize: 9,
                color: subTextColor,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Flexible(
            child: Text(
              value ?? '—',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: "Bold",
                fontSize: 11,
                color: blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Main Screen ──────────────────────────────────────────────────────────────
class TestDetailsScreen extends StatelessWidget {
  final TestListModel? testListModel;
  TestDetailsScreen({this.testListModel});

  final _dio = Dio();

  @override
  Widget build(BuildContext context) {
    Get.find<TestDetailController>().getTestDetail(testListModel!.id!);
    final pd    = ProgressDialog(context: context);
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FB),
      body: Column(
        children: [
          CustomAppBar(title: 'Test Details', isArrow: true, isAction: false),
          Expanded(
            child: GetBuilder<TestDetailController>(
              init: TestDetailController(),
              id: 'updateTest',
              builder: (controller) {
                if (controller.isLoading) return const _ShimmerLoading();

                if (controller.isError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.error_outline_rounded,
                            color: themeColor, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          NO_DATA[LANGUAGE_TYPE],
                          style: const TextStyle(
                            fontFamily: "Regular",
                            fontSize: 15,
                            color: subTextColor,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                final data = controller.data;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroCard(context, controller, pd),
                      const SizedBox(height: 16),
                      if (data != null && data.parameterList.isNotEmpty) ...[
                        _sectionTitle(Test_Details[LANGUAGE_TYPE]),
                        _buildParameterList(controller),
                        const SizedBox(height: 16),
                      ],
                      _buildInfoGrid(controller),
                      const SizedBox(height: 16),
                      _buildTabSection(controller),
                      const SizedBox(height: 16),
                    ],
                  ),
                );
              },
            ),
          ),
          GetBuilder<TestDetailController>(
            id: 'updateTest',
            builder: (controller) {
              if (controller.isError) return const SizedBox.shrink();
              return _buildBookNowButton(context, controller, width);
            },
          ),
        ],
      ),
    );
  }

  // ── Hero Card ────────────────────────────────────────────────────────────────
  Widget _buildHeroCard(
      BuildContext context,
      TestDetailController controller,
      ProgressDialog pd,
      ) {
    final model = testListModel!;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(AppImages.defaultImage),
        ),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black.withOpacity(0.15),
              Colors.black.withOpacity(0.40),
            ],
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title + Actions
            Row(
              children: [
                Expanded(
                  child: Text(
                    model.profileName ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontFamily: "Bold",
                      fontSize: 16,
                      height: 1.3,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                _iconBtn(Icons.share_rounded, () => shareTestApp(controller.data)),
                const SizedBox(width: 8),
                _iconBtn(Icons.download_rounded,
                        () => _downloadPdf(context, controller, pd)),
              ],
            ),

            const SizedBox(height: 10),

            _badgeRow(
              Icons.biotech_rounded,
              '${Paramter_Included[LANGUAGE_TYPE]} : ${model.noOfParameter ?? 0}',
            ),

            if ((model.shortDesc ?? '').isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                model.shortDesc!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white70,
                  fontFamily: "Regular",
                  fontSize: 12,
                ),
              ),
            ],

            const SizedBox(height: 12),

            // ✅ FIX: Price + Discount + Stars overflow
            // Root cause: inner Row had mainAxisSize.min but children
            // (strikethrough price + arrow + MRP + badge + stars) exceeded
            // the 304px constraint on small screens.
            // Fix: wrap price section in Flexible so it can shrink,
            // remove Spacer() (it was pushing badge+stars off screen),
            // use fixed SizedBox gaps instead.
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ✅ Flexible — price section shrinks on small screens
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if ((model.price ?? 0) != 0) ...[
                        Flexible(
                          child: Text(
                            '₹${double.parse(model.price.toString()).toStringAsFixed(0)}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: "Regular",
                              color: Colors.white60,
                              fontSize: 13,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text('→',
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13)),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        '₹${model.mrp}',
                        style: const TextStyle(
                          fontFamily: "Bold",
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                // Discount badge
                if ((model.discount.per ?? 0) != 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${model.discount.per}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: "Bold",
                      ),
                    ),
                  ),

                const SizedBox(width: 8),

                // Stars
                if (controller.data != null) ...[
                  _StarRating(
                    rating: (controller.data!.avgreview2 ?? 0).toDouble(),
                    size: 13,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '(${controller.testDetail?.data.avgreview2 ?? 0})',
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                      fontFamily: "Regular",
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)
          ],
        ),
        child: Icon(icon, size: 15, color: blackColor),
      ),
    );
  }

  Widget _badgeRow(IconData icon, String label) {
    // ✅ FIX: mainAxisSize.min + plain Text = text overflow on long labels
    // Row crossAxisAlignment.start + Expanded + softWrap = proper multiline
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 1),
          child: Icon(icon, size: 13, color: Colors.white70),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            label,
            softWrap: true,
            style: const TextStyle(
              color: Colors.white70,
              fontFamily: "Regular",
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  // ── Parameter List ────────────────────────────────────────────────────────────
  Widget _buildParameterList(TestDetailController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: controller.data!.parameterList.length,
          separatorBuilder: (_, __) =>
          const Divider(height: 1, color: Color(0xFFEEEEEE)),
          itemBuilder: (context, index) {
            final param = controller.data!.parameterList[index];
            return Theme(
              data:
              Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                tilePadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                title: Text(
                  param.name ?? 'Parameter',
                  style: const TextStyle(
                    fontFamily: "Bold",
                    color: blackColor,
                    fontSize: 14,
                  ),
                ),
                trailing: GestureDetector(
                  onTap: () => Get.to(() => ParameterDetailScreen(param.id)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      "View",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontFamily: "Bold",
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── Info Grid ─────────────────────────────────────────────────────────────────
  Widget _buildInfoGrid(TestDetailController controller) {
    final d = controller.data;
    final tiles = [
      _InfoTile(AppImages.gridImage1, Paramter_Included[LANGUAGE_TYPE],
          d?.noOfParameter?.toString()),
      _InfoTile(
          AppImages.gridImage2,
          Sample_Collection[LANGUAGE_TYPE],
          d?.sampleCollection == null
              ? null
              : d!.sampleCollection == 1
              ? 'Free'
              : 'Paid'),
      _InfoTile(
          AppImages.gridImage3,
          Doctor_Con_Fee[LANGUAGE_TYPE],
          d?.sampleCollectionFee == null
              ? null
              : d!.sampleCollectionFee == 1
              ? 'Free'
              : 'Paid'),
      _InfoTile(AppImages.gridImage4, Test_Booked[LANGUAGE_TYPE],
          d?.noOfParameter?.toString()),
      _InfoTile(AppImages.gridImage5, Report_Time[LANGUAGE_TYPE],
          d?.reportTime?.toString()),
      _InfoTile(
          AppImages.gridImage6,
          Fasting_Time[LANGUAGE_TYPE],
          d?.fastingTime == null
              ? null
              : d!.fastingTime == 1
              ? 'Yes'
              : 'No'),
      _InfoTile(AppImages.gridImage7, Test_Recommanded[LANGUAGE_TYPE],
          d?.testRecommendedFor?.toString()),
      _InfoTile(AppImages.gridImage8, Recommended_Age[LANGUAGE_TYPE],
          d?.testRecommendedForAge?.toString()),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.72,
        children: tiles,
      ),
    );
  }

  // ── Tab Section ───────────────────────────────────────────────────────────────
  Widget _buildTabSection(TestDetailController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF0F0F5),
                borderRadius:
                BorderRadius.vertical(top: Radius.circular(18)),
              ),
              child: TabBar(
                onTap: controller.changeTab,
                indicator: BoxDecoration(
                  color: themeColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: subTextColor,
                labelStyle:
                const TextStyle(fontFamily: "Bold", fontSize: 13),
                unselectedLabelStyle:
                const TextStyle(fontFamily: "Regular", fontSize: 13),
                padding: const EdgeInsets.all(4),
                dividerColor: Colors.transparent,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'FAQ'),
                  Tab(text: 'Reviews'),
                ],
              ),
            ),
            _buildTabContent(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(TestDetailController controller) {
    if (controller.data == null) return const SizedBox.shrink();

    switch (controller.selectedTabbar) {
      case 0:
        if (controller.data!.description.isEmpty) {
          return _emptyTabMsg('No overview available');
        }
        return Padding(
          padding: const EdgeInsets.all(14),
          child: HtmlWidget(
            controller.data!.description,
            textStyle: const TextStyle(
              color: subTextColor,
              fontFamily: "Regular",
              fontSize: 13,
              height: 1.6,
            ),
          ),
        );

      case 1:
        if (controller.data!.frqlist.isEmpty) {
          return _emptyTabMsg('No FAQs available');
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(14),
          itemCount: controller.data!.frqlist.length,
          separatorBuilder: (_, __) =>
          const Divider(color: Color(0xFFEEEEEE)),
          itemBuilder: (_, i) {
            final faq = controller.data!.frqlist[i];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                        const EdgeInsets.only(top: 2, right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Q',
                          style: TextStyle(
                            fontFamily: "Bold",
                            color: themeColor,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          faq.question,
                          style: const TextStyle(
                            fontFamily: "Bold",
                            fontSize: 14,
                            color: blackColor,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  HtmlWidget(
                    faq.ans,
                    textStyle: const TextStyle(
                      color: subTextColor,
                      fontFamily: "Regular",
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
          },
        );

      default:
        if (controller.data!.review.isEmpty) {
          return _emptyTabMsg('No reviews yet');
        }
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(14),
          itemCount: controller.data!.review.length,
          separatorBuilder: (_, __) =>
          const Divider(color: Color(0xFFEEEEEE)),
          itemBuilder: (_, i) {
            final review = controller.data!.review[i];
            String dateStr = '';
            try {
              final dt = DateFormat("dd-MM-yyyy hh:mm:ss")
                  .parse(review.date);
              dateStr = DateFormat.yMMMd().format(dt);
            } catch (_) {}

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: review.profilePic.isEmpty
                                ? const AssetImage(
                                "assets/profile/user.png")
                            as ImageProvider
                                : NetworkImage(AppImages.reviewBaseUrl +
                                review.profilePic),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              review.username,
                              style: const TextStyle(
                                fontFamily: "Bold",
                                fontSize: 14,
                                color: blackColor,
                              ),
                            ),
                            if (dateStr.isNotEmpty)
                              Text(
                                dateStr,
                                style: const TextStyle(
                                  fontFamily: "Regular",
                                  fontSize: 11,
                                  color: subTextColor,
                                ),
                              ),
                          ],
                        ),
                      ),
                      _StarRating(
                        rating: double.tryParse(
                            review.ratting.toString()) ??
                            0,
                        size: 14,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  HtmlWidget(
                    review.description,
                    textStyle: const TextStyle(
                      color: subTextColor,
                      fontFamily: "Regular",
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            );
          },
        );
    }
  }

  Widget _emptyTabMsg(String msg) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Center(
        child: Text(
          msg,
          style: const TextStyle(
            fontFamily: "Regular",
            color: subTextColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  // ── Book Now Button ───────────────────────────────────────────────────────────
  Widget _buildBookNowButton(
      BuildContext context,
      TestDetailController controller,
      double width,
      ) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          )
        ],
      ),
      child: customeElevatedButton(
        width,
        Book_Now[LANGUAGE_TYPE],
        callback: () {
          final userData = controller.userDetails;
          final data     = controller.testDetail!.data;
          final localPackageData = LocalPackageModel(
            id:                data.id,
            userId:            -1,
            packageId:         data.id,
            packageType:       3,
            packageName:       data.profileName,
            packageMrp:        data.mrp!.toInt(),
            packagePrice:      data.price!.toInt(),
            packageParameters: data.noOfParameter.toString(),
            packageDiscount:   '10',
          );
          if (userData.isLoggedIn) {
            Get.to(() => MemberList(localPackageModel: localPackageData));
          } else {
            Get.to(() => LoginScreen(
                index: 5, localPackageData: localPackageData));
          }
        },
      ),
    );
  }

  // ── PDF Download ──────────────────────────────────────────────────────────────
  void _downloadPdf(
      BuildContext context,
      TestDetailController controller,
      ProgressDialog pd,
      ) async {
    if (Platform.isAndroid) {
      final directory = await getExternalStorageDirectory();
      if (directory != null) {
        final filePath = '${directory.path}/downloaded_file.pdf';
        controller.download(
          _dio,
          pdfBaseUrl + (testListModel!.labReport ?? '.pdf'),
          filePath,
          pd,
        );
        pd.show(
          barrierDismissible: true,
          max: 100,
          msg: 'Pdf Downloading...',
          progressType: ProgressType.valuable,
          completed: Completed(
              completedMsg: "Downloading Done!", completionDelay: 2500),
        );
      }
    } else if (Platform.isIOS) {
      final dir = await getApplicationDocumentsDirectory();
      final ts  = DateTime.now().second;
      final base =
      (testListModel!.labReport ?? '.pdf').replaceAll(RegExp(r'\.pdf'), '');
      final filePath = '${dir.path}/${base}_$ts.pdf';
      pd.show(
        barrierDismissible: true,
        max: 100,
        msg: 'Pdf Downloading...',
        progressType: ProgressType.valuable,
        completed: Completed(
            completedMsg: "Downloading Done!", completionDelay: 2500),
      );
      controller.download(
        _dio,
        pdfBaseUrl + (testListModel!.labReport ?? '.pdf'),
        filePath,
        pd,
      );
    }
  }

  // ── Section Title ─────────────────────────────────────────────────────────────
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: themeColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontFamily: "Bold",
              fontSize: 16,
              color: blackColor,
            ),
          ),
        ],
      ),
    );
  }
}