import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/controller/coupon_controller.dart';
import '../../../componant/custome_appBar.dart';
import '../../../utils/colors.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int listLength = 5;
  CouponController couponController = Get.find<CouponController>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: themeSecondaryColor,
      body: Column(
        children: [
          ///------ appbar ------
          CustomAppBar(title: 'Wallet', isArrow: true, isAction: false),
          GetBuilder<CouponController>(builder: (copController) {
            return couponController.isWalletLoading
                ? Container(
                    margin: const EdgeInsets.only(top: 15, right: 8, left: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    width: width,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Available Wallet Amount : ',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: blackColor,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Bold",
                                )),
                            Text('₹${couponController.walletAmount != null ? couponController.walletAmount : 0}/-')
                          ],
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
          }),
        ],
      ),
    );
  }
}
