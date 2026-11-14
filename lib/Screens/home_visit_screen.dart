import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/user_details_class.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/Screens/View/AuthScreen/login_screen.dart';
import 'package:diagnostics_patient/Screens/View/add_home_visit_screen.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';
import 'package:diagnostics_patient/controller/home_controller.dart';
import 'package:diagnostics_patient/controller/home_visit_controller.dart';
import '../../../Models/family_member_list_model.dart';
import '../../../componant/custome_appBar.dart';
import '../../../utils/AllText.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';

// ─────────────────────────────────────────────────────────────────────────────
// SHIMMER WIDGET
// ─────────────────────────────────────────────────────────────────────────────
class _Shimmer extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const _Shimmer({
    required this.width,
    required this.height,
    this.radius = 8,
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
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value + 1, 0),
            colors: const [
              Color(0xFFEEF0F3),
              Color(0xFFF8F9FA),
              Color(0xFFE8EAED),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHIMMER CARD
// ─────────────────────────────────────────────────────────────────────────────
class _ShimmerCard extends StatelessWidget {
  const _ShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name + status row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const _Shimmer(width: 140, height: 16, radius: 6),
              const _Shimmer(width: 64, height: 22, radius: 20),
            ],
          ),
          const SizedBox(height: 10),
          const _Shimmer(width: 200, height: 12, radius: 5),
          const SizedBox(height: 8),
          const _Shimmer(width: 160, height: 12, radius: 5),
          const SizedBox(height: 14),
          const DottedLine(
            direction: Axis.horizontal,
            lineLength: double.infinity,
            lineThickness: 1,
            dashLength: 4,
            dashColor: Color(0xFFDEE2E6),
            dashGapLength: 4,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const _Shimmer(width: 14, height: 14, radius: 7),
              const SizedBox(width: 6),
              const _Shimmer(width: 120, height: 11, radius: 5),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// MAIN SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class HomeVisitScreen extends StatefulWidget {
  final bool isEdit;
  final Datum? data;

  const HomeVisitScreen({Key? key, this.isEdit = false, this.data})
      : super(key: key);

  @override
  State<HomeVisitScreen> createState() => _HomeVisitScreenState();
}

class _HomeVisitScreenState extends State<HomeVisitScreen> {
  final _homeVisitCtrl = Get.put(HomeVisitController());

  UserDetailsClass _userDetails = UserDetailsClass();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.data != null) {
      _homeVisitCtrl.setData(widget.data!);
    }
    _getUserDetails();
  }

  Future<void> _getUserDetails() async {
    final data = await UserDetailsClass().getUserDetails();
    if (mounted) {
      setState(() {
        _userDetails = data;
        _isLoading = false;
      });
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Column(
        children: [
          CustomAppBar(
            title: 'Home Visit',
            isArrow: false,
            isAction: false,
          ),
          Expanded(
            child: GetBuilder<HomeVisitController>(
              builder: (controller) {
                // ── Loading shimmer ────────────────────────────────────
                if (_isLoading) {
                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                    itemCount: 4,
                    itemBuilder: (_, __) => const _ShimmerCard(),
                  );
                }

                // ── Not logged in ──────────────────────────────────────
                if (!_userDetails.isLoggedIn) {
                  return _buildNotLoggedIn();
                }

                // ── Logged in ──────────────────────────────────────────
                return Stack(
                  children: [
                    // List or empty state
                    controller.isDataNotFound ||
                        controller.homeVisitList.isEmpty
                        ? _buildEmptyState()
                        : RefreshIndicator(
                      color: themeColor,
                      backgroundColor: Colors.white,
                      onRefresh: () async {
                        controller.setLoadingTrue();
                        controller.getHomeVisitList();
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                            16, 16, 16, 100),
                        itemCount: controller.homeVisitList.length,
                        itemBuilder: (context, index) =>
                            _buildVisitCard(controller, index),
                      ),
                    ),

                    // ── Add button pinned at bottom ──────────────────
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 16,
                      child: controller.isButtonLoading
                          ? const Center(
                        child: CircularProgressIndicator(
                            color: themeColor),
                      )
                          : _buildAddButton(context, controller, width),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // NOT LOGGED IN
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildNotLoggedIn() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_outline_rounded,
                size: 38, color: themeColor),
          ),
          const SizedBox(height: 16),
          const Text(
            'Please login to continue',
            style: TextStyle(
              fontFamily: 'Regular',
              fontSize: 15,
              color: subTextColor,
            ),
          ),
          const SizedBox(height: 20),
          customeElevatedButton(
            160,
            Login[LANGUAGE_TYPE],
            callback: () => Get.to(() => LoginScreen(index: 2)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // EMPTY STATE
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.07),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.home_outlined, size: 40, color: themeColor),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Home Visits Yet',
            style: TextStyle(
              fontFamily: 'Bold',
              fontSize: 16,
              color: blackColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Book a home visit for lab sample\ncollection at your doorstep',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Regular',
              fontSize: 13,
              color: subTextColor.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // VISIT CARD
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildVisitCard(HomeVisitController controller, int index) {
    final item = controller.homeVisitList[index];

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Name + Status ──────────────────────────────────────
            Row(
              children: [
                // Avatar circle
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: themeColor.withOpacity(0.10),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      (item.userName?.isNotEmpty == true)
                          ? item.userName![0].toUpperCase()
                          : 'U',
                      style: TextStyle(
                        fontFamily: 'Bold',
                        fontSize: 18,
                        color: themeColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.userName?.toString() ?? '—',
                        style: const TextStyle(
                          fontFamily: 'Bold',
                          fontSize: 15,
                          color: blackColor,
                          height: 1.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.userEmail?.toString() ?? '—',
                        style: const TextStyle(
                          fontFamily: 'Regular',
                          fontSize: 12,
                          color: subTextColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Status badge
                _StatusBadge(status: item.status ?? 0),
              ],
            ),

            const SizedBox(height: 14),

            // ── Dotted divider ─────────────────────────────────────
            const DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 1,
              dashLength: 4,
              dashColor: Color(0xFFDEE2E6),
              dashGapLength: 4,
            ),

            const SizedBox(height: 14),

            // ── Location row ───────────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on_outlined,
                    size: 14, color: themeColor),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    '${item.state ?? ''} ${item.pincode ?? ''}'.trim(),
                    style: const TextStyle(
                      fontFamily: 'Regular',
                      fontSize: 13,
                      color: subTextColor,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // ADD BUTTON
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildAddButton(
      BuildContext context, HomeVisitController controller, double width) {
    return GestureDetector(
      onTap: () async {
        // Reset fields
        _homeVisitCtrl
          ..fullNameController.text = ''
          ..mobileNumberController.text = ''
          ..emailController.text = ''
          ..houseNoController.text = '';

        final homeController = Get.find<HomeController>();
        homeController
          ..selectedBranchName = null
          ..selectedBranchId = null
          ..update();

        await homeController.getLabByCityNameData(
          context,
          cityName:
          Get.find<AddAddressController>().selectedDropdownValue ?? '',
        );

        final result = await Get.to(() => AddHomeVisitScreen());
        if (result == true) {
          controller.setLoadingTrue();
          controller.getHomeVisitList();
        }
      },
      child: Container(
        height: 52,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [themeColor, themeColor.withOpacity(0.82)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: themeColor.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_circle_outline_rounded,
                color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              ADD_HOME_VISIT[LANGUAGE_TYPE],
              style: const TextStyle(
                fontFamily: 'Bold',
                fontSize: 16,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// STATUS BADGE WIDGET
// ─────────────────────────────────────────────────────────────────────────────
class _StatusBadge extends StatelessWidget {
  final int status;

  const _StatusBadge({required this.status});

  // Status map: 0=Pending,1=Accept,2=Reject,3=Complete,
  //             4=Refund,5=Collected,6=Preparing,7=Complete
  _StatusConfig get _config {
    switch (status) {
      case 0:
        return _StatusConfig(
          label: PENDING[LANGUAGE_TYPE],
          bg: const Color(0xFFFFF3CD),
          text: const Color(0xFF856404),
          icon: Icons.hourglass_empty_rounded,
        );
      case 1:
        return _StatusConfig(
          label: 'Accept',
          bg: const Color(0xFFD1E7DD),
          text: const Color(0xFF0A3622),
          icon: Icons.check_circle_outline_rounded,
        );
      case 2:
        return _StatusConfig(
          label: REJECT[LANGUAGE_TYPE],
          bg: const Color(0xFFF8D7DA),
          text: const Color(0xFF58151C),
          icon: Icons.cancel_outlined,
        );
      case 3:
      case 7:
        return _StatusConfig(
          label: COMPLATE[LANGUAGE_TYPE],
          bg: const Color(0xFFD1E7DD),
          text: const Color(0xFF0A3622),
          icon: Icons.task_alt_rounded,
        );
      case 4:
        return _StatusConfig(
          label: 'Refund',
          bg: const Color(0xFFCFE2FF),
          text: const Color(0xFF052C65),
          icon: Icons.replay_rounded,
        );
      case 5:
        return _StatusConfig(
          label: 'Collected',
          bg: const Color(0xFFD1E7DD),
          text: const Color(0xFF0A3622),
          icon: Icons.inventory_2_outlined,
        );
      case 6:
        return _StatusConfig(
          label: 'Preparing',
          bg: const Color(0xFFD1ECF1),
          text: const Color(0xFF0C5460),
          icon: Icons.science_outlined,
        );
      default:
        return _StatusConfig(
          label: '—',
          bg: Colors.grey.shade200,
          text: Colors.grey.shade700,
          icon: Icons.info_outline_rounded,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cfg = _config;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: cfg.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(cfg.icon, size: 11, color: cfg.text),
          const SizedBox(width: 4),
          Text(
            cfg.label,
            style: TextStyle(
              fontFamily: 'Bold',
              fontSize: 11,
              color: cfg.text,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusConfig {
  final String label;
  final Color bg;
  final Color text;
  final IconData icon;

  const _StatusConfig({
    required this.label,
    required this.bg,
    required this.text,
    required this.icon,
  });
}