import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';
import 'package:diagnostics_patient/controller/cart_detail_controller.dart';
import '../../../Models/address_list_model.dart';
import '../../../Models/cart_list_model.dart';
import '../../../componant/custome_appBar.dart';
import '../../../componant/validation_screen.dart';
import '../../../controller/checkout_controller.dart';
import '../../../utils/AllText.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';
import '../../../widgets/custom_snackbar.dart';
import '../../Custome_Widgets/custome_widget.dart';
import '../../Custome_Widgets/total_card_widget.dart';
import '../AddressListScreen/collect_address_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Shared dropdown decoration — fixes black background
// ─────────────────────────────────────────────────────────────────────────────
InputDecoration _dropdownDec({String? hint}) => InputDecoration(
  filled: true,
  fillColor: Colors.white,                         // ✅ white, not black
  hintText: hint,
  hintStyle: TextStyle(
    fontFamily: 'Regular',
    fontSize: 14,
    color: subTextColor.withOpacity(0.7),
  ),
  contentPadding:
  const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: themeColor, width: 2),
  ),
  errorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.red, width: 1.5),
  ),
);

TextStyle _dropdownTextStyle(double width) => TextStyle(
  fontFamily: 'Regular',
  fontWeight: FontWeight.w400,
  fontSize: width > 360 ? 14 : 13,
  color: blackColor,
);

// ─────────────────────────────────────────────────────────────────────────────
// Section card container
// ─────────────────────────────────────────────────────────────────────────────
Widget _sectionCard({required Widget child}) => Container(
  margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 10,
        offset: const Offset(0, 3),
      ),
    ],
  ),
  child: child,
);

Widget _sectionTitle(String title) => Padding(
  padding: const EdgeInsets.only(bottom: 12),
  child: Row(children: [
    Container(
      width: 3, height: 16,
      decoration: BoxDecoration(
        color: themeColor,
        borderRadius: BorderRadius.circular(2),
      ),
    ),
    const SizedBox(width: 8),
    Text(
      title,
      style: const TextStyle(
        fontFamily: 'Bold',
        fontSize: 15,
        color: blackColor,
      ),
    ),
  ]),
);

// ═════════════════════════════════════════════════════════════════════════════
// CHECKOUT SCREEN
// ═════════════════════════════════════════════════════════════════════════════
class CheckoutScreen extends StatefulWidget {
  final double subTotal;
  final int    txt;
  final double total;
  final CartData data;
  final double? discount;
  final double? coupon;
  final double? walletPoint;

  const CheckoutScreen({
    Key? key,
    required this.subTotal,
    required this.txt,
    required this.total,
    required this.data,
    this.coupon,
    this.discount,
    this.walletPoint,
  }) : super(key: key);

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      body: Column(
        children: [
          CustomAppBar(
            title: CHECKOUT[LANGUAGE_TYPE],
            isArrow: true,
            isAction: false,
          ),

          Expanded(
            child: GetBuilder<CheckoutController>(
              init: CheckoutController(),
              builder: (ctrl) {
                if (ctrl.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: themeColor),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Total summary ────────────────────────────────
                      _buildTotalCard(width),
                      const SizedBox(height: 4),

                      // ── Collect address ──────────────────────────────
                      CollectAddressCard(
                        width: width,
                        addressData: ctrl.selectedAddress,
                      ),

                      // ── Select lab ───────────────────────────────────
                      if (ctrl.getUserByCityList.isNotEmpty)
                        _buildLabDropdown(ctrl, width),

                      // ── Date & Time ──────────────────────────────────
                      _buildDateTimeCard(ctrl, width),

                      // ── Payment option ───────────────────────────────
                      _buildPaymentCard(ctrl),

                      const SizedBox(height: 12),

                      // ── Book Now button ──────────────────────────────
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: customeElevatedButton(
                          width,
                          BOOK_NOW[LANGUAGE_TYPE],
                          callback: () => _onBookNow(ctrl, width),
                        ),
                      ),
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

  // ── Total Card ─────────────────────────────────────────────────────────────
  Widget _buildTotalCard(double width) {
    return TotalCard(
      width: width,
      subTotal:    '₹${widget.subTotal.toStringAsFixed(2)}',
      coupon:      '₹${(widget.coupon ?? 0).toStringAsFixed(2)}',
      walletPoint: '₹${(widget.walletPoint ?? 0).toStringAsFixed(2)}',
      total:       '₹${widget.total.toStringAsFixed(2)}',
      tax:         '₹${widget.txt}',
    );
  }

  // ── Lab Dropdown ───────────────────────────────────────────────────────────
  Widget _buildLabDropdown(CheckoutController ctrl, double width) {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Select Lab'),
          DropdownButtonFormField<String>(
            value: ctrl.selectedDropdownValue,
            validator: validateCity,
            isExpanded: true,
            icon: Icon(Icons.keyboard_arrow_down_rounded,
                color: themeColor, size: 22),
            dropdownColor: Colors.white,
            style: _dropdownTextStyle(width),
            decoration: _dropdownDec(hint: 'Select Lab'),
            items: ctrl.getUserByCityList
                .map((lab) => DropdownMenuItem<String>(
              value: lab.labName,
              child: Text(
                lab.labName.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ))
                .toList(),
            onChanged: (value) {
              setState(() => ctrl.selectedDropdownValue = value);
              Get.find<AddAddressController>().changeCityAddress(value);
            },
          ),
        ],
      ),
    );
  }

  // ── Date + Time Slot Card ──────────────────────────────────────────────────
  Widget _buildDateTimeCard(CheckoutController ctrl, double width) {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(SELECT_TIME_DATE[LANGUAGE_TYPE]),

          // Date picker field
          selectDateField(
            validateDate,
            ctrl.selectDateController,
            width,
            onTap: () => ctrl.selectDate(context),
          ),
          const SizedBox(height: 12),

          // Time slot dropdown
          GetBuilder<CheckoutController>(
            builder: (checkCtrl) => GestureDetector(
              onTap: checkCtrl.getTimeSlotList.isEmpty
                  ? () {
                AppSnackbar.warning(
                  'No Slots Available',
                  'No time slots available. Please try another date.',
                );
                Future.delayed(const Duration(seconds: 2),
                        () => ctrl.selectDate(context));
              }
                  : null,
              behavior: HitTestBehavior.opaque,
              child: AbsorbPointer(
                absorbing: checkCtrl.getTimeSlotList.isEmpty,
                child: DropdownButtonFormField<String>(
                  value: checkCtrl.selectedTimeSlot,
                  validator: validateCity,
                  isExpanded: true,
                  icon: Icon(Icons.keyboard_arrow_down_rounded,
                      color: checkCtrl.getTimeSlotList.isEmpty
                          ? Colors.grey
                          : themeColor,
                      size: 22),
                  dropdownColor: Colors.white,
                  style: _dropdownTextStyle(width),
                  decoration: _dropdownDec(hint: TIMESLOT[LANGUAGE_TYPE]),
                  items: checkCtrl.getTimeSlotList
                      .map((slot) => DropdownMenuItem<String>(
                    value: slot.timeslot,
                    child: Text(slot.timeslot),
                  ))
                      .toList(),
                  onChanged: checkCtrl.getTimeSlotList.isEmpty
                      ? null
                      : (value) => checkCtrl.updateTimeSlot(value),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Payment Card ───────────────────────────────────────────────────────────
  Widget _buildPaymentCard(CheckoutController ctrl) {
    return _sectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle(PAYMENT_OPTION[LANGUAGE_TYPE]),
          const Divider(color: Color(0xFFEEEEEE), height: 1),
          const SizedBox(height: 8),

          // Online payment
          _PaymentTile(
            assetPath: 'assets/cart/pay.png',
            assetHeight: 40,
            title: 'UPI / Credit Card / Debit Card / Netbanking',
            value: CheckoutController.values[0],
            groupValue: ctrl.selectedValue,
            onChanged: (v) => ctrl.setSelectedRadio(v),
            onTap: () =>
                ctrl.setSelectedRadio(CheckoutController.values[0]),
          ),

          const Divider(color: Color(0xFFF5F5F5), height: 1),

          // COD
          _PaymentTile(
            assetPath: 'assets/cart/cod.png',
            assetHeight: 30,
            title: 'Cash / Card on Sample Collection',
            value: CheckoutController.values[1],
            groupValue: ctrl.selectedValue,
            onChanged: (v) => ctrl.setSelectedRadio(v),
            onTap: () =>
                ctrl.setSelectedRadio(CheckoutController.values[1]),
          ),
        ],
      ),
    );
  }

  // ── Book Now action ────────────────────────────────────────────────────────
  void _onBookNow(CheckoutController ctrl, double width) {
    final getCouponCodeModel = ctrl.getCouponId;

    String? labId;
    final selectedDropdownValue = ctrl.selectedDropdownValue;

    if (ctrl.getUserCity == null || ctrl.getUserByCityList.isEmpty) {
      AppSnackbar.warning(
        'Warning',
        'Lab not found on this address. Please select another location.',
      );
      return;
    }

    for (var i = 0; i < ctrl.getUserCity!.data.length; i++) {
      if (ctrl.getUserCity!.data[i].name == selectedDropdownValue) {
        labId = ctrl.getUserCity!.data[i].id.toString();
        break;
      }
    }

    if (ctrl.selectedTimeSlot == null) {
      AppSnackbar.warning(
        'Time slot not selected',
        'Please select a time slot',
      );
      return;
    }

    if (ctrl.isAddressNull) {
      AppSnackbar.warning(
        'Warning',
        'Please add a delivery address',
      );
      return;
    }

    ctrl.bookNow(
      subTotal:   widget.subTotal,
      txt:        widget.txt,
      total:      widget.total,
      data:       widget.data,
      width:      width,
      walletPoint: widget.walletPoint,
      member_id:  (labId != null && labId.isNotEmpty) ? labId : null,
      coupon_id:  getCouponCodeModel != null
          ? getCouponCodeModel.toString()
          : null,
      visitType:  '0',
      couponDis:  widget.coupon,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// PAYMENT TILE
// ─────────────────────────────────────────────────────────────────────────────
class _PaymentTile extends StatelessWidget {
  final String assetPath;
  final double assetHeight;
  final String title;
  final dynamic value;
  final dynamic groupValue;
  final ValueChanged onChanged;
  final VoidCallback onTap;

  const _PaymentTile({
    required this.assetPath,
    required this.assetHeight,
    required this.title,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == groupValue;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? themeColor.withOpacity(0.04)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Image.asset(assetPath, height: assetHeight, width: 40,
                fit: BoxFit.contain),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Bold',
                  fontSize: 13,
                  color: blackColor,
                ),
              ),
            ),
            Radio(
              value: value,
              groupValue: groupValue,
              activeColor: themeColor,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// COLLECT ADDRESS CARD
// ═════════════════════════════════════════════════════════════════════════════
class CollectAddressCard extends StatelessWidget {
  final double width;
  final AddressModel addressData;

  const CollectAddressCard({
    Key? key,
    required this.width,
    required this.addressData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckoutController>(
      builder: (ctrl) => _sectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _sectionTitle(COLLECTION_ADDRESS[LANGUAGE_TYPE]),
                GestureDetector(
                  onTap: () => Get.to(() => CollectAddressScreen()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: themeColor.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      SELECT_ADDRESS_ADD[LANGUAGE_TYPE],
                      style: TextStyle(
                        fontFamily: 'Bold',
                        fontSize: 12,
                        color: themeColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 12),

            // ── Address content ──────────────────────────────────────
            if (ctrl.isAddressLoading)
              const Center(
                child: CircularProgressIndicator(color: themeColor),
              )
            else if (ctrl.isAddressNull)
              customeElevatedButton(
                width,
                ADD_ADDRESS_ADD[LANGUAGE_TYPE],
                callback: () => Get.to(() => CollectAddressScreen()),
              )
            else ...[
                // Name
                Row(children: [
                  Icon(Icons.person_outline_rounded,
                      size: 15, color: themeColor),
                  const SizedBox(width: 6),
                  Text(
                    addressData.name ?? '',
                    style: const TextStyle(
                      fontFamily: 'Bold',
                      fontSize: 14,
                      color: blackColor,
                    ),
                  ),
                ]),
                const SizedBox(height: 6),

                // Address
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.location_on_outlined,
                        size: 15, color: subTextColor),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        '${addressData.houseNo ?? ''}, '
                            '${addressData.address ?? ''}, '
                            '${addressData.city ?? ''} - '
                            '${addressData.pincode ?? ''}, '
                            '${addressData.state ?? ''}',
                        style: const TextStyle(
                          fontFamily: 'Regular',
                          fontSize: 13,
                          color: subTextColor,
                          height: 1.4,
                        ),
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











// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:diagnostics_patient/controller/add_address_controller.dart';
// import 'package:diagnostics_patient/controller/cart_detail_controller.dart';
// import '../../../Models/address_list_model.dart';
// import '../../../Models/cart_list_model.dart';
// import '../../../componant/custome_appBar.dart';
// import '../../../componant/validation_screen.dart';
// import '../../../controller/checkout_controller.dart';
// import '../../../utils/AllText.dart';
// import '../../../utils/colors.dart';
// import '../../../utils/strings.dart';
// import '../../Custome_Widgets/custome_widget.dart';
// import '../../Custome_Widgets/total_card_widget.dart';
// import '../AddressListScreen/collect_address_screen.dart';
//
// enum SingingCharacter { homeVisit, labVisit }
//
// class CheckoutScreen extends StatefulWidget {
//   final double subTotal;
//   final int txt;
//   final double total;
//   final CartData data;
//   final double? discount;
//   final double? coupon;
//   final double? walletPoint;
//
//   const CheckoutScreen({
//     Key? key,
//     required this.subTotal,
//     required this.txt,
//     required this.total,
//     required this.data,
//     this.coupon,
//     this.discount,
//     this.walletPoint,
//   }) : super(key: key);
//
//   @override
//   State<CheckoutScreen> createState() => _CheckoutScreenState();
// }
//
// class _CheckoutScreenState extends State<CheckoutScreen> {
//   int? selectedRadio;
//
//   void initState() {
//     super.initState();
//     selectedRadio = 0;
//   }
//
//   setSelectedRadio(int val) {
//     setState(() {
//       selectedRadio = val;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     // controller.getUserDetails();
//     // controller.fetchAddress();
//     return Scaffold(
//       backgroundColor: themeSecondaryColor,
//       body: Column(
//         children: [
//           CustomAppBar(
//               title: CHECKOUT[LANGUAGE_TYPE], isArrow: true, isAction: false),
//           GetBuilder<CheckoutController>(
//               init: CheckoutController(),
//               builder: (controller) {
//                 return controller.isLoading
//                     ? Center(
//                         child: CircularProgressIndicator(),
//                       )
//                     : Expanded(
//                         child: SingleChildScrollView(
//                           child: Column(
//                             children: [
//                               /// Total Card ===
//                               TotalCard(
//                                 width: width,
//                                 // subTotal: '₹${widget.subTotal}',
//                                 subTotal:
//                                     '₹${double.parse(widget.subTotal.toString()).toStringAsFixed(1)}',
//                                 coupon: '₹${widget.coupon}',
//
//                                 walletPoint:
//                                     '₹${widget.walletPoint!.toStringAsFixed(1)}',
//                                 total:
//                                     '₹${double.parse(widget.total.toString())}',
//                                 tax: '₹${widget.txt}',
//                               ),
//
//                               /// Collect Address Card ===
//                               CollectAddressCard(
//                                 width: width,
//                                 addressData: controller.selectedAddress,
//                               ),
//
//                               // home screen data
//                               // nearByLabController.labList!.isNotEmpty
//                               //     ? Container(
//                               //         margin: const EdgeInsets.only(top: 15, right: 8, left: 8),
//                               //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                               //         width: width,
//                               //         decoration: BoxDecoration(
//                               //           color: whiteColor,
//                               //           borderRadius: BorderRadius.circular(15),
//                               //         ),
//                               //         child: Column(
//                               //           crossAxisAlignment: CrossAxisAlignment.start,
//                               //           children: [
//                               //             boldText(text: 'Select Lab', size: 16, color: blackColor),
//                               //             const SizedBox(height: 10),
//                               //             DropdownButtonFormField<String>(
//                               //               value: controller.selectedDropdownValues,
//                               //               validator: validateCity,
//                               //               style: TextStyle(
//                               //                 fontWeight: FontWeight.w400,
//                               //                 fontSize: width > 360 ? 16 : 14,
//                               //                 color: blackColor,
//                               //                 fontFamily: "Regular",
//                               //               ),
//                               //               decoration: const InputDecoration(
//                               //                 border: UnderlineInputBorder(
//                               //                   borderSide: BorderSide(color: blackColor),
//                               //                 ),
//                               //                 enabledBorder: UnderlineInputBorder(
//                               //                   borderSide: BorderSide(color: subTextColor),
//                               //                 ),
//                               //                 focusedBorder: UnderlineInputBorder(
//                               //                   borderSide: BorderSide(color: blackColor),
//                               //                 ),
//                               //                 focusColor: blackColor,
//                               //                 fillColor: blackColor,
//                               //               ),
//                               //               items: nearByLabController.labList!
//                               //                   .map((label) => DropdownMenuItem<String>(
//                               //                         child: Text(label.name.toString()),
//                               //                         value: label.id.toString(), // Ensure unique value
//                               //                       ))
//                               //                   .toList(),
//                               //               hint: Text('Select Lab'),
//                               //               onChanged: (value) {
//                               //                 setState(() {
//                               //                   controller.selectedDropdownValues = value;
//                               //                 });
//                               //                 Get.find<AddAddressController>().changeCityAddress(value);
//                               //               },
//                               //             ),
//                               //           ],
//                               //         ),
//                               //       )
//                               //     : SizedBox(),
//
//                               controller.getUserByCityList.isNotEmpty
//                                   ? Container(
//                                       margin: const EdgeInsets.only(
//                                           top: 15, right: 8, left: 8),
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 16, vertical: 16),
//                                       width: width,
//                                       decoration: BoxDecoration(
//                                         color: whiteColor,
//                                         borderRadius: BorderRadius.circular(15),
//                                       ),
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           boldText(
//                                               text: 'Select Lab',
//                                               size: 16,
//                                               color: blackColor),
//                                           const SizedBox(
//                                             height: 10,
//                                           ),
//                                           DropdownButtonFormField<String>(
//                                             initialValue: controller
//                                                 .selectedDropdownValue,
//                                             validator: validateCity,
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w400,
//                                               fontSize: width > 360 ? 16 : 14,
//                                               color: blackColor,
//                                               fontFamily: "Regular",
//                                             ),
//                                             decoration: const InputDecoration(
//                                               border: UnderlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                     color: blackColor),
//                                               ),
//                                               enabledBorder:
//                                                   UnderlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                     color: subTextColor),
//                                               ),
//                                               focusedBorder:
//                                                   UnderlineInputBorder(
//                                                 borderSide: BorderSide(
//                                                     color: blackColor),
//                                               ),
//                                               focusColor: blackColor,
//                                               fillColor: blackColor,
//                                             ),
//                                             items: controller.getUserByCityList
//                                                 .map((label) =>
//                                                     DropdownMenuItem<String>(
//                                                       child: Text(label.labName
//                                                           .toString()),
//                                                       value: label.labName,
//                                                     ))
//                                                 .toList(),
//                                             hint: Text('Select Lab'),
//                                             onChanged: (value) {
//                                               setState(() {
//                                                 controller
//                                                         .selectedDropdownValue =
//                                                     value;
//                                               });
//                                               Get.find<AddAddressController>()
//                                                   .changeCityAddress(value);
//                                             },
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   : SizedBox(),
//
//                               // Container(
//                               //   margin: const EdgeInsets.only(top: 15, right: 8, left: 8),
//                               //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                               //   width: width,
//                               //   decoration: BoxDecoration(
//                               //     color: whiteColor,
//                               //     borderRadius: BorderRadius.circular(15),
//                               //   ),
//                               //   child: Column(
//                               //     crossAxisAlignment: CrossAxisAlignment.start,
//                               //     children: [
//                               //       boldText(text: 'Visit Type', size: 16, color: blackColor),
//                               //       const SizedBox(
//                               //         height: 10,
//                               //       ),
//                               //       SizedBox(
//                               //           child: Row(
//                               //         children: [
//                               //           Radio(
//                               //             value: 0,
//                               //             groupValue: selectedRadio,
//                               //             onChanged: (val) {
//                               //               setSelectedRadio(val!);
//                               //             },
//                               //           ),
//                               //           Text('Home Visit'),
//                               //           Radio(
//                               //             value: 1,
//                               //             groupValue: selectedRadio,
//                               //             onChanged: (val) {
//                               //               print("Radio $val");
//                               //               setSelectedRadio(val!);
//                               //             },
//                               //           ),
//                               //           Text('Lab Visit'),
//                               //         ],
//                               //       )),
//                               //     ],
//                               //   ),
//                               // ),
//                               // Container(
//                               //   margin: const EdgeInsets.only(top: 15, right: 8, left: 8),
//                               //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//                               //   width: width,
//                               //   decoration: BoxDecoration(
//                               //     color: whiteColor,
//                               //     borderRadius: BorderRadius.circular(15),
//                               //   ),
//                               //   child: Column(
//                               //     crossAxisAlignment: CrossAxisAlignment.start,
//                               //     children: [
//                               //       boldText(text: 'Select Coupon', size: 16, color: blackColor),
//                               //       const SizedBox(
//                               //         height: 10,
//                               //       ),
//                               //       TextField(
//                               //         readOnly: true,
//                               //         controller: controller.couponController,
//                               //         onTap: () {
//                               //           Get.to(() => CouponListScreen());
//                               //         },
//                               //         decoration: InputDecoration(
//                               //           hintText: "Coupon Code",
//                               //           border: OutlineInputBorder(
//                               //             borderRadius: BorderRadius.circular(20),
//                               //             borderSide: BorderSide(
//                               //               color: Colors.grey,
//                               //               width: 1,
//                               //               style: BorderStyle.solid,
//                               //             ),
//                               //           ),
//                               //           suffixIcon: Container(
//                               //             margin: EdgeInsets.all(3),
//                               //             child: ElevatedButton(
//                               //               style: ElevatedButton.styleFrom(
//                               //                 minimumSize: Size(100, 50),
//                               //                 primary: Colors.grey,
//                               //                 shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0), side: BorderSide.none),
//                               //               ),
//                               //               child: Text("Apply"),
//                               //               onPressed: () {
//                               //                 print('feni');
//                               //               },
//                               //             ),
//                               //           ),
//                               //         ),
//                               //       ),
//                               //     ],
//                               //   ),
//                               // ),
//
//                               /// Select Date and Time Card ===
//                               Container(
//                                 margin: const EdgeInsets.only(
//                                     top: 15, right: 8, left: 8),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 16, vertical: 16),
//                                 width: width,
//                                 decoration: BoxDecoration(
//                                   color: whiteColor,
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     boldText(
//                                         text: SELECT_TIME_DATE[LANGUAGE_TYPE],
//                                         size: 16,
//                                         color: blackColor),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     selectDateField(
//                                       validateDate,
//                                       controller.selectDateController,
//                                       width,
//                                       onTap: () {
//                                         controller.selectDate(context);
//                                       },
//                                     ),
//                                     const SizedBox(
//                                       height: 10,
//                                     ),
//                                     const SizedBox(height: 10),
//                                     GetBuilder<CheckoutController>(
//                                       builder: (checkOUTController) {
//                                         return GestureDetector(
//                                           onTap: () {
//                                             if (checkOUTController
//                                                 .getTimeSlotList.isEmpty) {
//                                               Get.snackbar(
//                                                 "No Slots Available",
//                                                 "No time slots available. Please try another date.",
//                                                 snackPosition:
//                                                     SnackPosition.BOTTOM,
//                                                 backgroundColor: Colors.red,
//                                                 colorText: Colors.black,
//                                               );
//                                               Future.delayed(
//                                                 const Duration(seconds: 2),
//                                                 () {
//                                                   controller
//                                                       .selectDate(context);
//                                                 },
//                                               );
//                                             }
//                                           },
//                                           behavior: HitTestBehavior.opaque,
//                                           child: AbsorbPointer(
//                                             absorbing: checkOUTController
//                                                 .getTimeSlotList.isEmpty,
//                                             child:
//                                                 DropdownButtonFormField<String>(
//                                               initialValue: checkOUTController
//                                                   .selectedTimeSlot, // Initially selected timeslot
//                                               validator: validateCity,
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.w400,
//                                                 fontSize: width > 360 ? 16 : 14,
//                                                 color: blackColor,
//                                                 fontFamily: "Regular",
//                                               ),
//                                               decoration: const InputDecoration(
//                                                 border: UnderlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: blackColor),
//                                                 ),
//                                                 enabledBorder:
//                                                     UnderlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: subTextColor),
//                                                 ),
//                                                 focusedBorder:
//                                                     UnderlineInputBorder(
//                                                   borderSide: BorderSide(
//                                                       color: blackColor),
//                                                 ),
//                                                 focusColor: blackColor,
//                                                 fillColor: blackColor,
//                                               ),
//                                               items: checkOUTController
//                                                   .getTimeSlotList
//                                                   .map((label) {
//                                                 return DropdownMenuItem<String>(
//                                                   child: Text(label
//                                                       .timeslot), // Display formatted timeslot in AM/PM format
//                                                   value: label.timeslot,
//                                                 );
//                                               }).toList(),
//                                               hint:
//                                                   Text(TIMESLOT[LANGUAGE_TYPE]),
//                                               onChanged: (value) {
//                                                 checkOUTController.updateTimeSlot(
//                                                     value); // Handle selected timeslot
//                                               },
//                                             ),
//                                           ),
//                                         );
//                                       },
//                                     )
//                                   ],
//                                 ),
//                               ),
//
//                               /// Payment Option
//                               // PaymentOption(width: width)
//                               Container(
//                                 margin: const EdgeInsets.only(
//                                     top: 15, right: 8, left: 8),
//                                 padding: const EdgeInsets.symmetric(
//                                     horizontal: 16, vertical: 16),
//                                 width: width,
//                                 decoration: BoxDecoration(
//                                   color: whiteColor,
//                                   borderRadius: BorderRadius.circular(15),
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     boldText(
//                                       text: PAYMENT_OPTION[LANGUAGE_TYPE],
//                                       color: blackColor,
//                                       size: 16,
//                                     ),
//                                     const SizedBox(
//                                       height: 5,
//                                     ),
//                                     const Divider(
//                                       color: subTextColor,
//                                     ),
//                                     ListTile(
//                                       onTap: () {
//                                         controller.setSelectedRadio(
//                                             CheckoutController.values[0]);
//                                       },
//                                       contentPadding: EdgeInsets.zero,
//                                       leading: Image.asset(
//                                         'assets/cart/pay.png',
//                                         height: 60,
//                                         width: 40,
//                                       ),
//                                       title: const Text(
//                                         // 'CC Avenue (Online Payment)',
//                                         ' UPI/ Credit Card / Debit Card / Netbanking',
//                                         style: TextStyle(
//                                             fontFamily: 'Bold', fontSize: 13),
//                                       ),
//                                       trailing: Radio(
//                                         value: CheckoutController.values[0],
//                                         groupValue: controller.selectedValue,
//                                         activeColor: blackColor,
//                                         onChanged: (val) {
//                                           print("Radio $val");
//                                           controller.setSelectedRadio(val);
//                                         },
//                                       ),
//                                     ),
//                                     ListTile(
//                                       onTap: () {
//                                         controller.setSelectedRadio(
//                                             CheckoutController.values[1]);
//                                       },
//                                       contentPadding: EdgeInsets.zero,
//                                       leading: Image.asset(
//                                         'assets/cart/cod.png',
//                                         height: 30,
//                                       ),
//                                       title: Text(
//                                         // COD[LANGUAGE_TYPE],
//                                         'Cash/ Card on Sample Collection',
//                                         style: const TextStyle(
//                                             fontFamily: 'Bold', fontSize: 13),
//                                       ),
//                                       trailing: Radio(
//                                         value: CheckoutController.values[1],
//                                         groupValue: controller.selectedValue,
//                                         activeColor: blackColor,
//                                         onChanged: (val) {
//                                           print("Radio $val");
//                                           controller.setSelectedRadio(val);
//                                         },
//                                       ),
//                                     ),
//                                     // ListTile(
//                                     //   onTap: () {
//                                     //     controller.setSelectedRadio(CheckoutController.values[2]);
//                                     //   },
//                                     //   contentPadding: EdgeInsets.zero,
//                                     //   leading: Image.asset(
//                                     //     'assets/checkout/payStack.png',
//                                     //     height: 30,
//                                     //   ),
//                                     //   title: const Text(
//                                     //     'Online',
//                                     //     style: TextStyle(fontFamily: 'Regular'),
//                                     //   ),
//                                     //   trailing: Radio(
//                                     //     value: CheckoutController.values[2],
//                                     //     groupValue: controller.selectedValue,
//                                     //     activeColor: blackColor,
//                                     //     onChanged: (val) {
//                                     //       print("Radio $val");
//                                     //       controller.setSelectedRadio(val);
//                                     //     },
//                                     //   ),
//                                     // ),
//                                   ],
//                                 ),
//                               ),
//
//                               /// Book Now
//                               GetBuilder<CheckoutController>(
//                                   builder: (checkController) {
//                                 return Padding(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 10, vertical: 10),
//                                   child:
//                                       // controller.isBooking
//                                       //     ? Center(
//                                       //         child: CircularProgressIndicator(),
//                                       //       )
//                                       //     :
//
//                                       customeElevatedButton(
//                                           width, BOOK_NOW[LANGUAGE_TYPE],
//                                           callback: () {
//                                     int? getCouponCodeModel =
//                                         controller.getCouponId ?? null;
//                                     print("widget.subTotal ${widget.subTotal}");
//                                     print("widget.txt ${widget.txt}");
//                                     print("widget.total ${widget.total}");
//                                     print(
//                                         "widget.data ${widget.data.cart!.length}");
//                                     // String? labId;
//                                     // for (var i = 0; i < controller.getUserCity!.data.length; i++) {
//                                     //   labId = controller.getUserCity!.data[i].id.toString();
//                                     // }
//                                     String? labId;
//                                     String? selectedDropdownValue =
//                                         controller.selectedDropdownValue;
//
//                                     if (controller.getUserCity != null &&
//                                         controller
//                                             .getUserByCityList.isNotEmpty) {
//                                       for (var i = 0;
//                                           i <
//                                               controller
//                                                   .getUserCity!.data.length;
//                                           i++) {
//                                         if (controller
//                                                 .getUserCity!.data[i].name ==
//                                             selectedDropdownValue) {
//                                           labId = controller
//                                               .getUserCity!.data[i].id
//                                               .toString();
//                                           break;
//                                         }
//                                       }
//                                       if (controller.selectedTimeSlot == null) {
//                                         Get.snackbar(
//                                           'Time slot not selected',
//                                           'Please select time slot',
//                                           snackPosition: SnackPosition.BOTTOM,
//                                           backgroundColor: redColor,
//                                           colorText: Colors.white,
//                                         );
//                                         return;
//                                       }
//                                       if (!controller.isAddressNull) {
//                                         controller.bookNow(
//                                             subTotal: widget.subTotal,
//                                             txt: widget.txt,
//                                             total: widget.total,
//                                             data: widget.data,
//                                             width: width,
//                                             walletPoint: widget.walletPoint,
//                                             // member_id: controller.getUserCity!.data[0].id.toString(),
//                                             member_id:
//                                                 labId!.isNotEmpty && labId != ''
//                                                     ? labId
//                                                     : null,
//                                             coupon_id: getCouponCodeModel !=
//                                                     null
//                                                 ? getCouponCodeModel.toString()
//                                                 : null,
//                                             visitType: 0.toString(),
//                                             couponDis: widget.coupon);
//                                       } else {
//                                         Get.snackbar(
//                                           'Warning',
//                                           'Please add address',
//                                           snackPosition: SnackPosition.BOTTOM,
//                                           backgroundColor: redColor,
//                                         );
//                                       }
//                                     } else {
//                                       Get.snackbar(
//                                         'Warning',
//                                         'Lab not found on this address please select another location',
//                                         snackPosition: SnackPosition.BOTTOM,
//                                         backgroundColor: redColor,
//                                       );
//                                     }
//
//                                     // Navigator.pop(context);
//                                   }),
//                                 );
//                               }),
//                             ],
//                           ),
//                         ),
//                       );
//               }),
//         ],
//       ),
//     );
//   }
// }
//
// class CollectAddressCard extends StatelessWidget {
//   const CollectAddressCard({
//     Key? key,
//     required this.width,
//     required this.addressData,
//   }) : super(key: key);
//
//   final double width;
//   final AddressModel addressData;
//
//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.find<CheckoutController>();
//     return Container(
//       margin: const EdgeInsets.only(top: 15, right: 8, left: 8),
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//       width: width,
//       decoration: BoxDecoration(
//         color: whiteColor,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               boldText(
//                   text: COLLECTION_ADDRESS[LANGUAGE_TYPE],
//                   color: blackColor,
//                   size: 16),
//               InkWell(
//                 onTap: () {
//                   Get.to(() => CollectAddressScreen());
//
//                   // Navigator.push(
//                   //     context,
//                   //     MaterialPageRoute(
//                   //         builder: (context) => const CollectAddressScreen()));
//                   // Select Address On Click
//                 },
//                 child: regularText(
//                     text: SELECT_ADDRESS_ADD[LANGUAGE_TYPE],
//                     color: themeColor,
//                     size: 14),
//               )
//             ],
//           ),
//           const SizedBox(
//             height: 5,
//           ),
//           const Divider(
//             color: subTextColor,
//           ),
//           const SizedBox(
//             height: 5,
//           ),
//           Get.find<CheckoutController>().isAddressLoading
//               ? SizedBox()
//               : controller.isAddressNull
//                   ? SizedBox()
//                   : boldText(
//                       text: '${addressData.name}', color: blackColor, size: 16),
//           const SizedBox(
//             height: 10,
//           ),
//           Get.find<CheckoutController>().isAddressLoading
//               ? Center(
//                   child: CircularProgressIndicator(),
//                 )
//               : controller.isAddressNull
//                   ? customeElevatedButton(width, ADD_ADDRESS_ADD[LANGUAGE_TYPE],
//                       callback: () {
//                       Get.to(() => CollectAddressScreen());
//                       // Navigator.pop(context);
//                     })
//                   : regularText(
//                       // text: 'A / 234, King Plazaa, Mithakhali, Ahmedabad, Gujarat',
//                       text:
//                           '${addressData.houseNo}, ${addressData.address}, ${addressData.city}-${addressData.pincode}, ${addressData.state}',
//                       color: blackColor),
//           const SizedBox(
//             height: 10,
//           ),
//           // controller.isAddressNull
//           //     ? SizedBox()
//           //     : RichText(
//           //         text: TextSpan(
//           //           text: MOBILE[LANGUAGE_TYPE],
//           //           style: const TextStyle(
//           //             fontSize: 16,
//           //             color: blackColor,
//           //             fontWeight: FontWeight.w500,
//           //             fontFamily: "Bold",
//           //           ),
//           //           children: <TextSpan>[
//           //             TextSpan(
//           //               style: TextStyle(
//           //                 // fontSize: size,
//           //                 color: blackColor,
//           //                 fontSize: 14,
//           //                 // letterSpacing: .5,
//           //                 fontWeight: FontWeight.w500,
//           //                 fontFamily: "Regular",
//           //               ),
//           //             ),
//           //           ],
//           //         ),
//           //       )
//         ],
//       ),
//     );
//   }
// }



