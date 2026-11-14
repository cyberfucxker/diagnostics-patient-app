// ignore_for_file: deprecated_member_use, unnecessary_null_comparison

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:diagnostics_patient/Models/lab_model.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/Screens/View/add_home_visit_screen.dart';
import 'package:diagnostics_patient/Screens/map_screen.dart';
import 'package:diagnostics_patient/componant/custome_appBar.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';
import 'package:diagnostics_patient/controller/home_controller.dart';
import 'package:diagnostics_patient/controller/home_visit_controller.dart';
import 'package:diagnostics_patient/controller/near_by_lab_controller.dart';
import 'package:diagnostics_patient/utils/api.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:url_launcher/url_launcher.dart';

// ─── Shimmer Widget ───────────────────────────────────────────────────────────
class _Shimmer extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  final bool isCircle;

  const _Shimmer({
    required this.width,
    required this.height,
    this.radius = 10,
    this.isCircle = false,
  });

  @override
  State<_Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<_Shimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
    _anim = Tween<double>(begin: -2, end: 2).animate(
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
          shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius:
          widget.isCircle ? null : BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value + 1, 0),
            colors: const [
              Color(0xFFE8ECF0),
              Color(0xFFF8FAFB),
              Color(0xFFE0E5EA),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Shimmer Loading Screen ───────────────────────────────────────────────────
class _ShimmerLoading extends StatelessWidget {
  const _ShimmerLoading();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero card shimmer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Shimmer(width: 180, height: 22),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F8FA),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _shimmerRow(),
                      const SizedBox(height: 16),
                      _shimmerRow(),
                      const SizedBox(height: 16),
                      _shimmerRow(),
                      const SizedBox(height: 16),
                      _shimmerRow(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Company card shimmer
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const _Shimmer(
                    width: 52, height: 52, radius: 50, isCircle: true),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _Shimmer(width: 130, height: 16),
                    SizedBox(height: 6),
                    _Shimmer(width: 80, height: 12),
                  ],
                ),
                const Spacer(),
                const _Shimmer(
                    width: 48, height: 48, radius: 50, isCircle: true),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Action tile shimmer
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                _Shimmer(width: 120, height: 16),
                _Shimmer(width: 24, height: 24),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Nearby labs shimmer
          const _Shimmer(width: 160, height: 18),
          const SizedBox(height: 12),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, __) => Container(
                width: 220,
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _Shimmer(width: 140, height: 16),
                    const SizedBox(height: 10),
                    _shimmerRow(iconSize: 16, textWidth: 120),
                    const SizedBox(height: 10),
                    _shimmerRow(iconSize: 16, textWidth: 100),
                    const SizedBox(height: 10),
                    _shimmerRow(iconSize: 16, textWidth: 80),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerRow({double iconSize = 20, double textWidth = 180}) {
    return Row(
      children: [
        _Shimmer(width: iconSize, height: iconSize, isCircle: true),
        const SizedBox(width: 10),
        _Shimmer(width: textWidth, height: 13),
      ],
    );
  }
}

// ─── Main Screen ──────────────────────────────────────────────────────────────
class LabDetailScreen extends StatefulWidget {
  final LabModelList? labModelList;
  final int? id;

  const LabDetailScreen({Key? key, this.labModelList, this.id})
      : super(key: key);

  @override
  State<LabDetailScreen> createState() => _LabDetailScreenState();
}

class _LabDetailScreenState extends State<LabDetailScreen> {
  LabModelList get lab => widget.labModelList!;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F9),
      body: Column(
        children: [
          CustomAppBar(
              title: 'Lab Detail', isArrow: true, isAction: false),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── About Card ───────────────────────────────────────────
                  _buildAboutCard(),
                  const SizedBox(height: 16),

                  // ── Company Profile Card ─────────────────────────────────
                  _buildCompanyCard(),
                  const SizedBox(height: 16),

                  // ── Get Directions Tile ──────────────────────────────────
                  _buildActionTile(
                    title: 'Get Directions',
                    icon: Icons.map_outlined,
                    onTap: () => Get.to(() =>
                        MapScreen(labModelList: lab)),
                  ),
                  const SizedBox(height: 20),

                  // ── Nearby Labs ──────────────────────────────────────────
                  _buildNearbySection(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),

          // ── Add Home Visit Button ────────────────────────────────────────
          _buildBottomButton(width),
        ],
      ),
    );
  }

  // ── About Card ──────────────────────────────────────────────────────────────
  Widget _buildAboutCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lab name
          Text(
            lab.name ?? '—',
            style: const TextStyle(
              fontFamily: "Bold",
              fontSize: 20,
              color: Colors.black,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 14),

          // Info rows inside a subtle container
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F8FA),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _infoRow(
                  svgAsset: 'assets/lab_phone.svg',
                  text: lab.phone ?? '---',
                  onTap: () =>
                      _makePhoneCall('tel:+91${lab.phone}'),
                  tappable: true,
                ),
                _divider(),
                _infoRow(
                  svgAsset: 'assets/lab_email.svg',
                  text: lab.email ?? 'user@example.com',
                ),
                _divider(),
                _infoRow(
                  svgAsset: 'assets/location.svg',
                  text: lab.address ?? '—',
                  multiline: true,
                ),
                _divider(),
                _infoRow(
                  svgAsset: 'assets/location.svg',
                  text: lab.location?.name ?? '—',
                  multiline: true,
                ),
                _divider(),
                _infoRow(
                  pngAsset: 'assets/distance.png',
                  pngColor: Colors.blueAccent,
                  text:
                  '${lab.distance?.toStringAsFixed(1) ?? '0.0'} kms away',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    String? svgAsset,
    String? pngAsset,
    Color? pngColor,
    required String text,
    bool multiline = false,
    bool tappable = false,
    VoidCallback? onTap,
  }) {
    final iconWidget = svgAsset != null
        ? SvgPicture.asset(svgAsset,
        height: 18, width: 18, color: themeColor)
        : Image.asset(pngAsset!,
        height: 18, width: 18, color: pngColor);

    final textWidget = Expanded(
      child: Text(
        text,
        maxLines: multiline ? 5 : 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontFamily: "Regular",
          fontSize: 14,
          color: tappable ? themeColor : Colors.black87,
          fontWeight:
          tappable ? FontWeight.w600 : FontWeight.w500,
          decoration: tappable
              ? TextDecoration.underline
              : TextDecoration.none,
        ),
      ),
    );

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: iconWidget,
        ),
        const SizedBox(width: 10),
        textWidget,
      ],
    );

    if (tappable && onTap != null) {
      return GestureDetector(onTap: onTap, child: row);
    }
    return row;
  }

  Widget _divider() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Divider(height: 1, color: Color(0xFFE8ECF0)),
  );

  // ── Company Card ─────────────────────────────────────────────────────────────
  Widget _buildCompanyCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          ClipOval(
            child: CachedNetworkImage(
              imageUrl: '$imageUrl${lab.profilePic}',
              height: 52,
              width: 52,
              fit: BoxFit.cover,
              placeholder: (_, __) => const _Shimmer(
                  width: 52, height: 52, isCircle: true),
              errorWidget: (_, __, ___) => Container(
                width: 52,
                height: 52,
                color: const Color(0xFFF0F3F7),
                child: Icon(Icons.business_rounded,
                    color: themeColor, size: 26),
              ),
            ),
          ),
          const SizedBox(width: 14),

          // Name + label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  lab.companyName ?? '—',
                  style: const TextStyle(
                    fontFamily: "Bold",
                    fontSize: 15,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Company',
                    style: TextStyle(
                      fontFamily: "Regular",
                      fontSize: 11,
                      color: themeColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Call button
          GestureDetector(
            onTap: () =>
                _makePhoneCall('tel:+91${lab.phone}'),
            child: Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/lab_phone.svg',
                  height: 20,
                  width: 20,
                  color: themeColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Action Tile ──────────────────────────────────────────────────────────────
  Widget _buildActionTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: themeColor, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: "Bold",
                  fontSize: 15,
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 15, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  // ── Nearby Labs Section ──────────────────────────────────────────────────────
  Widget _buildNearbySection() {
    return GetBuilder<NearByLabController>(
      init: NearByLabController(),
      builder: (controller) {
        if (controller.isLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Shimmer(width: 170, height: 18),
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (_, __) => Container(
                    width: 220,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        if (controller.labList == null || controller.labList!.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section header
            Row(
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
                const Text(
                  'Nearby Laboratories',
                  style: TextStyle(
                    fontFamily: "Bold",
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            SizedBox(
              height: 175,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.labList!.length,
                itemBuilder: (context, index) {
                  final nearby = controller.labList![index];
                  return GestureDetector(
                    onTap: () async {
                      try {
                        await Get.to(
                              () => LabDetailScreen(labModelList: nearby),
                          preventDuplicates: false,
                        );
                      } catch (e) {
                        debugPrint('$e');
                      }
                    },
                    child: Container(
                      width: 230,
                      margin: EdgeInsets.only(
                        left: index == 0 ? 0 : 0,
                        right: 12,
                        bottom: 4,
                        top: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x289a90b8),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nearby.name ?? '—',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontFamily: "Bold",
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          _nearbyRow(
                            'assets/lab_phone.svg',
                            nearby.phone ?? '---',
                            isSvg: true,
                          ),
                          const SizedBox(height: 7),
                          _nearbyRow(
                            'assets/location.svg',
                            nearby.address ?? '',
                            isSvg: true,
                          ),
                          const SizedBox(height: 7),
                          _nearbyRow(
                            'assets/distance.png',
                            '${nearby.distance?.toStringAsFixed(1) ?? '—'} kms',
                            isSvg: false,
                            color: Colors.blueAccent,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _nearbyRow(String asset, String text,
      {required bool isSvg, Color? color}) {
    return Row(
      children: [
        isSvg
            ? SvgPicture.asset(asset,
            height: 14, width: 14, color: color ?? themeColor)
            : Image.asset(asset,
            height: 14, width: 14, color: color ?? themeColor),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: "Regular",
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  // ── Bottom Button ────────────────────────────────────────────────────────────
  Widget _buildBottomButton(double width) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: customeElevatedButton(
        width,
        'Add Home Visit',
        callback: () async {
          Get.find<AddAddressController>().tcCity.text =
              Get.find<AddAddressController>().selectedDropdownValue ?? '';
          Get.find<HomeVisitController>().fullNameController.text = '';
          Get.find<HomeVisitController>().mobileNumberController.text = '';
          Get.find<HomeVisitController>().emailController.text = '';
          Get.find<HomeVisitController>().houseNoController.text = '';

          await Get.find<HomeController>().getLabByCityNameData(
            context,
            cityName:
            Get.find<AddAddressController>().selectedDropdownValue ?? '',
          );

          if (widget.labModelList != null) {
            Get.find<HomeController>().selectedBranchName = lab.name;
            Get.find<HomeController>().selectedBranchId = null;
            Get.find<HomeController>().selectedBranchId =
                lab.id.toString();
            Get.find<HomeController>().update();
          }

          Get.to(() => AddHomeVisitScreen());
        },
      ),
    );
  }

  // ── Phone Call ───────────────────────────────────────────────────────────────
  Future<void> _makePhoneCall(String phoneNumber) async {
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      debugPrint('Could not launch $phoneNumber');
    }
  }
}

// ─── Kept for backward compat ─────────────────────────────────────────────────
BoxDecoration getButtonDecoration(Color bgColor,
    {BorderRadius? borderRadius,
      Border? border,
      List<BoxShadow> shadow = const [],
      DecorationImage? image}) {
  return BoxDecoration(
    color: bgColor,
    borderRadius: borderRadius,
    border: border,
    boxShadow: shadow,
    image: image,
  );
}