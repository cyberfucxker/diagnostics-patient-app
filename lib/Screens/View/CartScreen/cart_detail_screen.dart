// cart_detail_screen.dart
// ignore_for_file: unnecessary_null_comparison, deprecated_member_use

import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/page_widget.dart';
import 'package:diagnostics_patient/Screens/View/CartScreen/coupon_screen.dart';
import 'package:diagnostics_patient/controller/cart_detail_controller.dart';
import 'package:diagnostics_patient/controller/checkout_controller.dart';
import 'package:diagnostics_patient/controller/coupon_controller.dart';
import '../../../utils/AllText.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../Custome_Widgets/custome_widget.dart';
import '../../Custome_Widgets/persondetail_cardview.dart';
import '../../Custome_Widgets/total_card_widget.dart';
import '../AuthScreen/login_screen.dart';
import 'checkout_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// ANIMATED FETCHING TEXT  — replaces every loader/spinner
// ─────────────────────────────────────────────────────────────────────────────
class _FetchingText extends StatefulWidget {
  final String text;
  final double fontSize;
  final Color? color;

  const _FetchingText({
    this.text = 'Fetching...',
    this.fontSize = 13,
    this.color,
  });

  @override
  State<_FetchingText> createState() => _FetchingTextState();
}

class _FetchingTextState extends State<_FetchingText>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);
    _fade = Tween<double>(begin: 0.35, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: Text(
        widget.text,
        style: TextStyle(
          fontFamily: 'Regular',
          fontSize: widget.fontSize,
          color: widget.color ?? themeColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SHIMMER
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
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
    _anim = Tween<double>(begin: -2, end: 2).animate(
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

// ── Shimmer card for cart item ────────────────────────────────────────────────
class _CartShimmerCard extends StatelessWidget {
  const _CartShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _Shimmer(width: 44, height: 44, radius: 22),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _Shimmer(width: 140, height: 14),
                  SizedBox(height: 7),
                  _Shimmer(width: 90, height: 11),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          const _Shimmer(width: double.infinity, height: 1),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _Shimmer(width: 100, height: 11),
              _Shimmer(width: 60, height: 11),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _Shimmer(width: 120, height: 11),
              _Shimmer(width: 50, height: 11),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Shimmer summary card ──────────────────────────────────────────────────────
class _SummaryShimmerCard extends StatelessWidget {
  const _SummaryShimmerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Shimmer(width: 100, height: 14),
          const SizedBox(height: 14),
          ...List.generate(
            4,
                (i) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Shimmer(width: 80 + i * 10, height: 12),
                  const _Shimmer(width: 60, height: 12),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          const _Shimmer(width: double.infinity, height: 1),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _Shimmer(width: 50, height: 15),
              _Shimmer(width: 70, height: 15),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// CART DETAIL SCREEN
// ─────────────────────────────────────────────────────────────────────────────
class CartDetailScreen extends StatefulWidget {
  const CartDetailScreen({Key? key}) : super(key: key);

  @override
  State<CartDetailScreen> createState() => _CartDetailScreenState();
}

class _CartDetailScreenState extends State<CartDetailScreen> {
  late final CartDetailController _cartCtrl;
  late final CouponController _couponCtrl;
  late final CheckoutController _checkoutCtrl;

  // Replaces _checkoutLoading CircularProgressIndicator
  bool _checkoutLoading = false;

  @override
  void initState() {
    super.initState();
    _cartCtrl     = Get.put(CartDetailController());
    _couponCtrl   = Get.put(CouponController());
    _checkoutCtrl = Get.put(CheckoutController());

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cartCtrl.getUserDetails();
      _checkoutCtrl.couponController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: GetBuilder<CartDetailController>(
              builder: (ctrl) {

                // ── Shimmer loading ────────────────────────────────────
                if (ctrl.isLoading) {
                  return SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        const _CartShimmerCard(),
                        const _CartShimmerCard(),
                        const _SummaryShimmerCard(),
                        const SizedBox(height: 16),
                        Container(
                          margin: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              _Shimmer(width: 110, height: 14),
                              SizedBox(height: 12),
                              _Shimmer(
                                  width: double.infinity,
                                  height: 48,
                                  radius: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // ── Not logged in ──────────────────────────────────────
                if (!ctrl.userDetails.isLoggedIn) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80, height: 80,
                          decoration: BoxDecoration(
                            color: themeColor.withOpacity(0.08),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.shopping_cart_outlined,
                              size: 36, color: themeColor),
                        ),
                        const SizedBox(height: 16),
                        const Text('Login to view your cart',
                            style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 15,
                                color: subTextColor)),
                        const SizedBox(height: 20),
                        customeElevatedButton(
                          160,
                          Login[LANGUAGE_TYPE],
                          callback: () => Get.to(() => LoginScreen(index: 3)),
                        ),
                      ],
                    ),
                  );
                }

                // ── Empty cart ─────────────────────────────────────────
                if (ctrl.cartListModel.data.cart.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 88, height: 88,
                          decoration: BoxDecoration(
                            color: themeColor.withOpacity(0.07),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.shopping_bag_outlined,
                              size: 40, color: themeColor),
                        ),
                        const SizedBox(height: 16),
                        const Text('Your cart is empty',
                            style: TextStyle(
                                fontFamily: 'Bold',
                                fontSize: 16,
                                color: blackColor)),
                        const SizedBox(height: 6),
                        Text(
                          'Add tests to get started',
                          style: TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 13,
                              color: subTextColor.withOpacity(0.8)),
                        ),
                        const SizedBox(height: 20),
                        customeElevatedButton(
                          180,
                          'Browse Tests',
                          callback: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PagesWidget(selectedIndex: 0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // ── Cart has items ─────────────────────────────────────
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: ctrl.cartListModel.data.cart.length,
                        itemBuilder: (_, i) {
                          final item = ctrl.cartListModel.data.cart[i];
                          return PersonPackageDetailCardView(
                            width: width,
                            name: '${item.memberName} | ${item.relation}  ',
                            detail: '${item.gender},${item.age} years',
                            cardItem: 2,
                            testdatum: item.testdata,
                            memberId: item.memberId!,
                          );
                        },
                      ),

                      _TotalCardWidget(),
                      const EnterCoupenCodeWIdget(),
                      _WalletWidget(
                        cartController: _cartCtrl,
                        couponCtrl: _couponCtrl,
                      ),

                      const SizedBox(height: 12),

                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: customeElevatedButton(
                          width,
                          'Add More Test',
                          callback: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PagesWidget(selectedIndex: 0),
                            ),
                          ),
                        ),
                      ),

                      // ── Checkout button — loader replaced with fetching text ──
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        child: _checkoutLoading
                            ? Container(
                          width: width,
                          height: 50,
                          decoration: BoxDecoration(
                            color: themeColor.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          alignment: Alignment.center,
                          child: const _FetchingText(
                            text: 'Processing...',
                            fontSize: 14,
                          ),
                        )
                            : customeElevatedButton(
                          width,
                          CHECKOUT[LANGUAGE_TYPE],
                          callback: () => _onCheckout(ctrl),
                        ),
                      ),

                      const SizedBox(height: 28),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── App Bar ──────────────────────────────────────────────────────────────
  Widget _buildAppBar() {
    return Container(
      decoration: BoxDecoration(
        color: themeColor,
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    Get.context!,
                    MaterialPageRoute(
                      builder: (_) => PagesWidget(selectedIndex: 0),
                    ),
                  );
                  _cartCtrl.update();
                },
                child: Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Colors.white, size: 16),
                ),
              ),
              const SizedBox(width: 12),
              boldText(
                text: CART_DETAIL[LANGUAGE_TYPE],
                color: Colors.white,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Checkout ─────────────────────────────────────────────────────────────
  Future<void> _onCheckout(CartDetailController ctrl) async {
    if (_checkoutLoading) return;

    if (ctrl.walletPointController.text.isNotEmpty &&
        (double.tryParse(ctrl.walletPointController.text) ?? 0) > 0 &&
        ctrl.walletPoint == 0) {
      AppSnackbar.warning(
        'Warning',
        'Please apply wallet point first',
      );
      return;
    }

    if (mounted) setState(() => _checkoutLoading = true);

    try {
      await _checkoutCtrl.fetchAddress();
      await _checkoutCtrl.getUserByCityLists();

      log('Checkout: subTotal=${ctrl.subTotals}, '
          'coupon=${ctrl.coupon}, '
          'wallet=${ctrl.walletPoint}, '
          'total=${ctrl.total}');

      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CheckoutScreen(
            subTotal: ctrl.subTotals,
            txt: ctrl.tax,
            coupon: ctrl.coupon,
            discount: ctrl.discount,
            walletPoint: ctrl.walletPoint,
            total: ctrl.total,
            data: ctrl.cartObjData,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _checkoutLoading = false);
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// TOTAL CARD
// ─────────────────────────────────────────────────────────────────────────────
class _TotalCardWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartDetailController>(
      builder: (ctrl) => TotalCard(
        width: Get.width,
        subTotal:    '₹${ctrl.subTotals.toStringAsFixed(2)}',
        coupon:      '₹${ctrl.coupon.toStringAsFixed(2)}',
        walletPoint: '₹${ctrl.walletPoint.toStringAsFixed(2)}',
        total:       '₹${ctrl.total.toStringAsFixed(2)}',
        isShowSavingAmount: ctrl.saving != null && ctrl.saving > 0,
        saving: ctrl.saving,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// WALLET WIDGET
// ─────────────────────────────────────────────────────────────────────────────
class _WalletWidget extends StatelessWidget {
  final CartDetailController cartController;
  final CouponController     couponCtrl;

  const _WalletWidget({
    required this.cartController,
    required this.couponCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartDetailController>(
      builder: (ctrl) => Container(
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Wallet balance row — spinner → fetching text ──────────
            Row(
              children: [
                Icon(Icons.account_balance_wallet_outlined,
                    size: 18, color: themeColor),
                const SizedBox(width: 8),

                GetBuilder<CouponController>(
                  id: 'wallet',
                  builder: (cp) {
                    if (cp.isWalletLoading) {
                      // ✅ No spinner — just animated fetching text
                      return Row(
                        children: const [
                          Text(
                            'Wallet Balance: ',
                            style: TextStyle(
                              fontFamily: 'Bold',
                              fontSize: 15,
                              color: blackColor,
                            ),
                          ),
                          SizedBox(width: 4),
                          _FetchingText(
                            text: 'Fetching...',
                            fontSize: 13,
                          ),
                        ],
                      );
                    }
                    return Text(
                      'Wallet Balance: ₹${cp.walletAmount?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        fontFamily: 'Bold',
                        fontSize: 15,
                        color: blackColor,
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Input + Apply/Remove
            TextField(
              controller: ctrl.walletPointController,
              keyboardType: TextInputType.number,
              readOnly: ctrl.isWalletApplied,
              style: const TextStyle(
                fontFamily: 'Regular',
                fontSize: 14,
                color: blackColor,
              ),
              decoration: InputDecoration(
                hintText: 'Enter wallet amount',
                hintStyle: TextStyle(
                  fontFamily: 'Regular',
                  fontSize: 13,
                  color: subTextColor.withOpacity(0.7),
                ),
                filled: true,
                fillColor: ctrl.isWalletApplied
                    ? Colors.grey.shade100
                    : const Color(0xFFF8F9FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  BorderSide(color: Colors.grey.shade300, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  BorderSide(color: Colors.grey.shade300, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: themeColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                suffixIconConstraints: const BoxConstraints(
                    minWidth: 0, minHeight: 0),
                suffixIcon: Padding(
                  padding:
                  const EdgeInsets.only(right: 8, top: 6, bottom: 6),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      if (ctrl.isWalletApplied) {
                        ctrl.removeWallet(couponCtrl);
                      } else {
                        ctrl.applyWallet(couponCtrl);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: ctrl.isWalletApplied
                            ? Colors.red.shade50
                            : themeColor.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        ctrl.isWalletApplied ? 'Remove' : 'Apply',
                        style: TextStyle(
                          fontFamily: 'Bold',
                          fontSize: 13,
                          color: ctrl.isWalletApplied
                              ? Colors.red
                              : themeColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            if (ctrl.isWalletApplied) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.check_circle_outline_rounded,
                      size: 14, color: Colors.green),
                  const SizedBox(width: 5),
                  Text(
                    '₹${ctrl.walletPoint.toStringAsFixed(2)} wallet applied',
                    style: const TextStyle(
                      fontFamily: 'Regular',
                      fontSize: 12,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// COUPON WIDGET
// ─────────────────────────────────────────────────────────────────────────────
class EnterCoupenCodeWIdget extends StatelessWidget {
  const EnterCoupenCodeWIdget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (ctrl) => Container(
        margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_offer_outlined, size: 16, color: themeColor),
                const SizedBox(width: 7),
                boldText(text: 'Enter Coupon', size: 15, color: blackColor),
              ],
            ),
            const SizedBox(height: 12),

            TextField(
              controller: ctrl.couponController,
              style: const TextStyle(
                  fontFamily: 'Regular', fontSize: 14, color: blackColor),
              onChanged: (v) {
                ctrl.cartDetailController.isCoupenApplied.value = false;
                ctrl.cartDetailController.coupenMSg.value = '';
              },
              decoration: InputDecoration(
                hintText: 'Coupon Code',
                hintStyle: TextStyle(
                    fontFamily: 'Regular',
                    fontSize: 13,
                    color: subTextColor.withOpacity(0.7)),
                filled: true,
                fillColor: const Color(0xFFF8F9FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  BorderSide(color: Colors.grey.shade300, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  BorderSide(color: Colors.grey.shade300, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: themeColor, width: 2),
                ),
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Obx(() {
                    final applied =
                        ctrl.cartDetailController.isCoupenApplied.isTrue &&
                            ctrl.couponController.text.trim().isNotEmpty;
                    return GestureDetector(
                      onTap: () {
                        if (applied) {
                          ctrl.couponController.clear();
                          ctrl.cartDetailController.removeCoupon();
                          ctrl.cartDetailController.isCoupenApplied.value =
                          false;
                        } else if (ctrl.couponController.text
                            .trim()
                            .isNotEmpty) {
                          ctrl.cartDetailController.validateCoupon(
                            couponCode:
                            ctrl.couponController.text.trim(),
                            cartInfo: ctrl
                                .cartDetailController.cartListModel.data,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: applied
                              ? Colors.red.shade50
                              : themeColor.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          applied ? 'Remove' : 'Apply',
                          style: TextStyle(
                            fontFamily: 'Bold',
                            fontSize: 13,
                            color: applied ? Colors.red : themeColor,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // ── Coupon status — LinearProgress → fetching text ─────────
            Obx(() {
              final loading =
                  ctrl.cartDetailController.isLoadValiateCoupen.isTrue;
              final msg = ctrl.cartDetailController.coupenMSg.value;

              if (loading) {
                // ✅ No LinearProgressIndicator — animated fetching text
                return const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: _FetchingText(
                    text: 'Validating coupon...',
                    fontSize: 12,
                  ),
                );
              }

              if (msg.isEmpty) return const SizedBox.shrink();

              final isSuccess =
                  ctrl.cartDetailController.isCoupenApplied.isTrue;
              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(
                      isSuccess
                          ? Icons.check_circle_outline_rounded
                          : Icons.error_outline_rounded,
                      size: 14,
                      color: isSuccess ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        msg,
                        style: TextStyle(
                          fontFamily: 'Regular',
                          fontSize: 12,
                          color: isSuccess ? Colors.green : Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}