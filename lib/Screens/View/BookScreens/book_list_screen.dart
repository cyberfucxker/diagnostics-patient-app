// ignore_for_file: must_be_immutable

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:diagnostics_patient/Models/user_details_class.dart';
import 'package:diagnostics_patient/Screens/View/AuthScreen/login_screen.dart';
import 'package:diagnostics_patient/componant/custome_appBar.dart';
import 'package:diagnostics_patient/controller/book_detail_controller.dart';
import '../../../controller/book_controller.dart';
import '../../../utils/AllText.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';
import '../../Custome_Widgets/custome_widget.dart';
import 'book_details_screen.dart';

// ═════════════════════════════════════════════════════════════════════════════
// SHIMMER
// ═════════════════════════════════════════════════════════════════════════════
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
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
    _anim = Tween<double>(begin: -2.0, end: 2.0).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
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
              Color(0xFFE4E7EB),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Skeleton booking card ─────────────────────────────────────────────────────
class _BookingShimmerCard extends StatelessWidget {
  const _BookingShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
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
          // Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _Shimmer(width: 100, height: 14),
              _Shimmer(width: 60, height: 14),
            ],
          ),
          const SizedBox(height: 12),
          // Date + time
          Row(children: const [
            _Shimmer(width: 14, height: 14, radius: 7),
            SizedBox(width: 6),
            _Shimmer(width: 110, height: 12),
            SizedBox(width: 14),
            _Shimmer(width: 14, height: 14, radius: 7),
            SizedBox(width: 6),
            _Shimmer(width: 70, height: 12),
          ]),
          const SizedBox(height: 14),
          const _Shimmer(width: double.infinity, height: 1),
          const SizedBox(height: 14),
          // Footer row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _Shimmer(width: 130, height: 12),
              _Shimmer(width: 64, height: 24, radius: 12),
            ],
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// BOOK LIST SCREEN
// ═════════════════════════════════════════════════════════════════════════════
class BookListScreen extends StatefulWidget {
  final bool? isArrow;
  const BookListScreen({Key? key, this.isArrow}) : super(key: key);

  @override
  State<BookListScreen> createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _bookCtrl = Get.put(BookController());

  UserDetailsClass _userDetails = UserDetailsClass();
  bool _isUserLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(_onTabChanged);
    _loadUser();
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      _bookCtrl.changeTabIndex(_tabController.index);
    }
  }

  Future<void> _loadUser() async {
    final data = await UserDetailsClass().getUserDetails();
    if (mounted) {
      setState(() {
        _userDetails = data;
        _isUserLoading = false;
      });
    }
  }

  Future<void> _onRefresh() async {
    await _loadUser();
    _bookCtrl.reloadAllList();
  }

  // ─────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5FA),
      body: Column(
        children: [
          // ── Header ────────────────────────────────────────────────────
          _buildHeader(),

          // ── Body ──────────────────────────────────────────────────────
          Expanded(
            child: _isUserLoading
                ? _buildShimmerList()
                : !_userDetails.isLoggedIn
                ? _buildNotLoggedIn()
                : _buildTabContent(),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // HEADER
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: themeColor,
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.30),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Title row
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
              child: Row(
                children: [
                  if (widget.isArrow == true)
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 38, height: 38,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      Book_List[LANGUAGE_TYPE],
                      style: const TextStyle(
                        fontFamily: 'Bold',
                        fontSize: 20,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tab bar inside header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: themeColor,
                unselectedLabelColor: Colors.white,
                labelStyle: const TextStyle(
                  fontFamily: 'Bold',
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontFamily: 'Regular',
                  fontSize: 13,
                ),
                dividerColor: Colors.transparent,
                padding: const EdgeInsets.all(4),
                tabs: [
                  Tab(text: All[LANGUAGE_TYPE]),
                  Tab(text: Pending[LANGUAGE_TYPE]),
                  Tab(text: Rejected[LANGUAGE_TYPE]),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
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
            width: 84, height: 84,
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.receipt_long_outlined,
                size: 38, color: themeColor),
          ),
          const SizedBox(height: 16),
          const Text(
            'Login to view your bookings',
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
            callback: () => Get.to(() => LoginScreen(index: 1)),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // TAB CONTENT
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildTabContent() {
    return TabBarView(
      controller: _tabController,
      children: [
        _BookTab(onRefresh: _onRefresh),
        _BookTab(onRefresh: _onRefresh),
        _BookTab(onRefresh: _onRefresh),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // SHIMMER LIST
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildShimmerList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: 5,
      itemBuilder: (_, __) => const _BookingShimmerCard(),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// BOOK TAB — extracted to avoid rebuilding all 3 tabs together
// ═════════════════════════════════════════════════════════════════════════════
class _BookTab extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const _BookTab({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BookController>(
      builder: (ctrl) {
        // ── Shimmer ────────────────────────────────────────────────────
        if (ctrl.isLoading) {
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: 4,
            itemBuilder: (_, __) => const _BookingShimmerCard(),
          );
        }

        // ── Empty ──────────────────────────────────────────────────────
        if (ctrl.orderData == null || (ctrl.orderData?.isEmpty ?? true)) {
          return RefreshIndicator(
            color: themeColor,
            backgroundColor: Colors.white,
            onRefresh: onRefresh,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                height: 400,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 80, height: 80,
                        decoration: BoxDecoration(
                          color: themeColor.withOpacity(0.07),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.inbox_outlined,
                            size: 38, color: themeColor),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        NO_DATA[LANGUAGE_TYPE],
                        style: const TextStyle(
                          fontFamily: 'Bold',
                          fontSize: 16,
                          color: blackColor,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'No bookings found in this category',
                        style: TextStyle(
                          fontFamily: 'Regular',
                          fontSize: 13,
                          color: subTextColor.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }

        // ── List ───────────────────────────────────────────────────────
        return RefreshIndicator(
          color: themeColor,
          backgroundColor: Colors.white,
          onRefresh: onRefresh,
          child: ListView.builder(
            controller: ctrl.scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: (ctrl.orderData?.length ?? 0) + 1, // +1 for footer
            itemBuilder: (context, index) {
              // Footer — pagination loader
              if (index == (ctrl.orderData?.length ?? 0)) {
                return ctrl.isListLoading
                    ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: _PaginationDots(),
                  ),
                )
                    : const SizedBox.shrink();
              }

              // Guard: index out of bounds ya null item skip karo
              final list = ctrl.orderData;
              if (list == null || index >= list.length) {
                return const SizedBox.shrink();
              }
              final data = list[index];

              return DetailCard(
                status:        data.status      ?? 0,
                paymentType:   data.paymentMethod,
                date:          data.date,
                orderId:       data.id?.toString() ?? '',
                time:          data.time,
                amount:        (data.finalTotal  ?? 0).toDouble(),
                sampleBoyName: data.sampleboyDetails?.name ?? '',
                sampleBoyNo:   data.sampleboyDetails?.phone?.toString() ?? '',
              );
            },
          ),
        );
      },
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// PAGINATION DOTS
// ═════════════════════════════════════════════════════════════════════════════
class _PaginationDots extends StatefulWidget {
  @override
  State<_PaginationDots> createState() => _PaginationDotsState();
}

class _PaginationDotsState extends State<_PaginationDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) {
            final v = ((_ctrl.value - i * 0.25) % 1.0).clamp(0.0, 1.0);
            final s = 0.5 + 0.5 * (1 - (v - 0.5).abs() * 2).clamp(0.0, 1.0);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: 8 * s,
              height: 8 * s,
              decoration: BoxDecoration(
                color: themeColor.withOpacity(0.4 + 0.6 * s),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// DETAIL CARD
// ═════════════════════════════════════════════════════════════════════════════
class DetailCard extends StatelessWidget {
  final String orderId;
  final DateTime? date;       // nullable — backend kabhi null bhejta hai
  final String? time;         // nullable
  final String? paymentType;  // nullable
  final int status;
  final double amount;
  final String? sampleBoyName;
  final String? sampleBoyNo;

  const DetailCard({
    Key? key,
    required this.status,
    required this.orderId,
    this.date,
    this.time,
    this.paymentType,
    required this.amount,
    this.sampleBoyName,
    this.sampleBoyNo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final ctrl = Get.put(BookDetailController(orderId: orderId));
        await ctrl.getBookDetail(id: orderId);
        Get.to(() => BookDetailsScreen(orderId: orderId));
      },
      child: Container(
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
        child: Column(
          children: [
            // ── Top section ──────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order ID + Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 34, height: 34,
                            decoration: BoxDecoration(
                              color: themeColor.withOpacity(0.10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(Icons.receipt_outlined,
                                size: 16, color: themeColor),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                BOOK_ID[LANGUAGE_TYPE],
                                style: const TextStyle(
                                  fontFamily: 'Regular',
                                  fontSize: 11,
                                  color: subTextColor,
                                ),
                              ),
                              Text(
                                '#$orderId',
                                style: const TextStyle(
                                  fontFamily: 'Bold',
                                  fontSize: 14,
                                  color: blackColor,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Text(
                        '₹${amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontFamily: 'Bold',
                          fontSize: 16,
                          color: themeColor,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Date + Time chips
                  Row(children: [
                    _InfoChip(
                      icon: 'assets/book_list/date.png',
                      label: date != null ? DateFormat.yMMMd().format(date!) : '—',
                    ),
                    const SizedBox(width: 8),
                    _InfoChip(
                      icon: 'assets/book_list/time.png',
                      label: time ?? '—',
                    ),
                  ]),
                ],
              ),
            ),

            // ── Dotted divider ───────────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DottedLine(
                direction: Axis.horizontal,
                lineLength: double.infinity,
                lineThickness: 1,
                dashLength: 5,
                dashColor: Color(0xFFDEE2E6),
                dashGapLength: 5,
              ),
            ),

            // ── Bottom section ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Payment type + Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        Icon(Icons.payment_rounded,
                            size: 14, color: subTextColor),
                        const SizedBox(width: 5),
                        Text(
                          '${PAYMENT_TYPE[LANGUAGE_TYPE]} ${paymentType ?? '—'}',
                          style: const TextStyle(
                            fontFamily: 'Regular',
                            fontSize: 12,
                            color: subTextColor,
                          ),
                        ),
                      ]),
                      _StatusBadge(status: status),
                    ],
                  ),

                  // Sample boy info
                  if ((sampleBoyName ?? '').isNotEmpty) ...[
                    const SizedBox(height: 10),
                    const Divider(height: 1, color: Color(0xFFF0F0F0)),
                    const SizedBox(height: 10),
                    Row(children: [
                      Icon(Icons.person_outline_rounded,
                          size: 14, color: themeColor),
                      const SizedBox(width: 6),
                      Text(
                        sampleBoyName!,
                        style: const TextStyle(
                          fontFamily: 'Regular',
                          fontSize: 13,
                          color: blackColor,
                        ),
                      ),
                      if ((sampleBoyNo ?? '').isNotEmpty) ...[
                        const SizedBox(width: 12),
                        Icon(Icons.phone_outlined,
                            size: 13, color: themeColor),
                        const SizedBox(width: 4),
                        Text(
                          sampleBoyNo!,
                          style: const TextStyle(
                            fontFamily: 'Regular',
                            fontSize: 13,
                            color: blackColor,
                          ),
                        ),
                      ],
                    ]),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Info chip (date / time) ───────────────────────────────────────────────────
class _InfoChip extends StatelessWidget {
  final String icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(icon, height: 13, width: 13),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Regular',
              fontSize: 12,
              color: subTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// STATUS BADGE
// ═════════════════════════════════════════════════════════════════════════════
class _StatusBadge extends StatelessWidget {
  final int status;
  const _StatusBadge({required this.status});

  _StatusConfig get _cfg {
    switch (status) {
      case 1:
        return _StatusConfig(
          label: PENDING[LANGUAGE_TYPE],
          bg: const Color(0xFFFFF3CD),
          text: const Color(0xFF856404),
          icon: Icons.hourglass_empty_rounded,
        );
      case 2:
        return _StatusConfig(
          label: 'Accept',
          bg: const Color(0xFFD1E7DD),
          text: const Color(0xFF0A3622),
          icon: Icons.check_circle_outline_rounded,
        );
      case 3:
        return _StatusConfig(
          label: REJECT[LANGUAGE_TYPE],
          bg: const Color(0xFFF8D7DA),
          text: const Color(0xFF58151C),
          icon: Icons.cancel_outlined,
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
      case 7:
        return _StatusConfig(
          label: COMPLATE[LANGUAGE_TYPE],
          bg: const Color(0xFFD1E7DD),
          text: const Color(0xFF0A3622),
          icon: Icons.task_alt_rounded,
        );
      default:
        return _StatusConfig(
          label: '—',
          bg: Colors.grey.shade200,
          text: Colors.grey.shade600,
          icon: Icons.info_outline_rounded,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cfg = _cfg;
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