import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/controller/cart_detail_controller.dart';
import 'package:diagnostics_patient/utils/strings.dart';

import '../../utils/AllText.dart';
import '../../utils/App_Images.dart';
import '../../utils/colors.dart';

class PersonPackageDetailCardView extends StatelessWidget {
  final String name;
  final int cardItem;
  final String detail;
  final bool isSimple;
  final List testdatum;
  final int memberId;

  const PersonPackageDetailCardView({
    Key? key,
    required this.width,
    required this.name,
    required this.cardItem,
    required this.detail,
    required this.testdatum,
    this.isSimple = false,
    required this.memberId,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin:const EdgeInsets.all(8),
      margin: const EdgeInsets.only(top: 8, right: 8, left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: const DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage(
            AppImages.defaultImage,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: name,
                style: const TextStyle(color: whiteColor, fontFamily: "Bold"),
                children: <TextSpan>[
                  TextSpan(
                    text: detail,
                    style: const TextStyle(
                      color: subTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      fontFamily: "Regular",
                    ),
                  ),
                ],
              ),
            ),
            isSimple
                ? Container(
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: testdatum.length,
                        itemBuilder: (context, index) {
                          var data = testdatum[index];
                          return PackageDetailSimple(
                            name: data.testName!,
                            parameters: data.parameter.toString(),
                            mrp: data.mrp.toString(),
                            // price: data.price.toString(),
                            price: data.price.toString(),
                            per: data.discount.per.toString(),
                            discount: data.discount.fixed.toString(),
                            onTap: () {},
                          );
                        }),
                  )
                : Container(
                    child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: testdatum.length,
                        itemBuilder: (context, index) {
                          var data = testdatum[index];
                          return PackageDetail(
                            name: data.testName!,
                            parameters: data.parameter.toString(),
                            mrp: data.mrp.toString(),
                            price: data.price.toString(),
                            discount: data.discount.per.toString(),
                            fixed: data.discount.fixed,
                            per: data.discount.per,
                            onTap: () async {
                              Get.find<CartDetailController>().deletePackage(data, memberId);
                            },
                          );
                        }),
                  ),
            // const PackageDetail(),
            // const PackageDetail(),
          ],
        ),
      ),
    );
  }
}

class PackageDetail extends StatelessWidget {
  const PackageDetail({
    Key? key,
    required this.name,
    required this.parameters,
    required this.mrp,
    required this.price,
    required this.discount,
    this.fixed,
    this.per,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final String parameters;
  final String mrp;
  final String price;
  final String discount;
  final double? fixed;
  final int? per;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        children: [
          const Divider(
            color: whiteColor,
            thickness: 1,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boldText(text: '$name', color: whiteColor),
                    const SizedBox(
                      height: 5,
                    ),
                    regularText(text: 'Parameters Included : $parameters', size: 12, color: subTextColor),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        price != "0.0"
                            ? RichText(
                                text: TextSpan(
                                  text: '₹$price',
                                  style: TextStyle(
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 14,
                                    color: themeColor,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Regular",
                                  ),
                                ),
                              )
                            : SizedBox(),
                        price != "0.0"
                            ? Text(
                                " / ",
                                style: TextStyle(
                                  color: whiteColor,
                                ),
                              )
                            : SizedBox(),
                        Text(
                          "₹" + mrp,
                          style: const TextStyle(
                            fontFamily: "Regular",
                            color: whiteColor,
                            fontSize: 11,
                          ),
                        ),
                        SizedBox(width: 60),
                        per != 0
                            ? Container(
                                height: 25,
                                width: 40,
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                      "assets/popular_package/discount.png",
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    "${per}%",
                                    // "\$${24}.00",
                                    style: TextStyle(
                                      color: whiteColor,
                                      fontSize: 10,
                                      fontFamily: "Regular",
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox(),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  // mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Container(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 5, vertical: 2),
                    //   color: const Color(0xff088018),
                    //   child:
                    //   regularText(text: '${SAVE[LANGUAGE_TYPE]} ${discount}%',color: whiteColor,size: 12),
                    // ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      color: Colors.transparent,
                      child: SizedBox(
                        height: 12,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    InkWell(
                        onTap: onTap,
                        child: Image.asset(
                          'assets/cart/delete.png',
                          height: 20,
                        ))
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

class PackageDetailSimple extends StatelessWidget {
  const PackageDetailSimple({
    Key? key,
    required this.name,
    required this.parameters,
    required this.mrp,
    required this.price,
    required this.discount,
    required this.per,
    required this.onTap,
  }) : super(key: key);

  final String name;
  final String parameters;
  final String mrp;
  final String price;
  final String discount;
  final String per;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      child: Column(
        children: [
          const Divider(
            color: whiteColor,
            thickness: 1,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    boldText(text: '$name', color: whiteColor),
                    const SizedBox(
                      height: 5,
                    ),
                    regularText(text: '${PARAMETERS_INCLUDED[LANGUAGE_TYPE]} $parameters', color: subTextColor, size: 14),
                  ],
                ),
              ),
              per != "0"
                  ? Container(
                      height: 25,
                      width: 40,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            "assets/popular_package/discount.png",
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          "${per}%",
                          // "\$${24}.00",
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: 10,
                            fontFamily: "Regular",
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              SizedBox(width: 5),
              price != "0.0"
                  ? Text(
                      "₹" + price.toString(),
                      style: const TextStyle(
                        fontFamily: "Regular",
                        color: whiteColor,
                        fontSize: 11,
                        decoration: TextDecoration.lineThrough,
                      ),
                    )
                  : SizedBox(),
              price != "0.0"
                  ? Text(
                      " / ",
                      style: TextStyle(
                        color: whiteColor,
                      ),
                    )
                  : SizedBox(),
              price != "0.0"
                  ? Text(
                      "₹" + mrp, // Format to 2 decimal places
                      // "₹" + controller.popularPackageModelList![index].discount.fixed,
                      style: const TextStyle(
                        fontFamily: "Regular",
                        color: whiteColor,
                        fontSize: 11,
                      ),
                    )
                  : SizedBox(),

              // regularText(text: '₹$mrp', color: whiteColor)
            ],
          ),
        ],
      ),
    );
  }
}
