import 'package:flutter/material.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/utils/strings.dart';
import '../../utils/AllText.dart';
import '../../utils/colors.dart';

class TotalCard extends StatelessWidget {
  final String subTotal;
  final String total;
  final String? tax;
  final String? coupon;
  final String? walletPoint;
  final double width;
  final double saving;
  final bool isShowSavingAmount;

  const TotalCard({
    Key? key,
    required this.width,
    required this.subTotal,
    required this.total,
    this.tax,
    this.coupon,
    this.walletPoint,
    this.isShowSavingAmount = false,
    this.saving = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8, right: 8, left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      width: width,
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          // Sub Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              boldText(text: SUBTOTAL[LANGUAGE_TYPE], color: blackColor),
              regularText(text: subTotal, color: blackColor),
            ],
          ),

          const SizedBox(height: 6),

          // Coupon — sirf tab dikhao jab apply hua ho
          if (coupon != null && coupon != '₹0.00')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                boldText(text: Coupon[LANGUAGE_TYPE], color: blackColor),
                regularText(
                  text: '- $coupon',
                  color: Colors.green,
                ),
              ],
            ),

          // ❌ Discount row hata diya

          const SizedBox(height: 6),

          // Wallet — sirf tab dikhao jab apply hua ho
          if (walletPoint != null && walletPoint != '₹0.00')
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                boldText(text: WalletPoint[LANGUAGE_TYPE], color: blackColor),
                regularText(
                  text: '- $walletPoint',
                  color: Colors.green,
                ),
              ],
            ),

          const SizedBox(height: 10),
          const Divider(color: subTextColor),

          // Final Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              boldText(text: TOTAL[LANGUAGE_TYPE], size: 16, color: blackColor),
              boldText(text: total, size: 16, color: blackColor),
            ],
          ),

          // Saving amount
          if (isShowSavingAmount) ...[
            const SizedBox(height: 15),
            regularText(
              text: '${SAVING_DES[LANGUAGE_TYPE]} ₹${saving.toStringAsFixed(2)}',
              color: const Color(0xff088018),
              size: 12,
            ),
          ],
        ],
      ),
    );
  }
}