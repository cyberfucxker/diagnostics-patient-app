import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/page_widget.dart';

import '../Screens/Custome_Widgets/custome_widget.dart';
import '../utils/colors.dart';

class CustomAppBar extends StatelessWidget {
  String title;
  bool isArrow, isAction, isCustomWidget, isShowBackButton;
  Widget? widget;

  // bool isOnPress;
  CustomAppBar({
    required this.title,
    required this.isArrow,
    required this.isAction,
    this.isCustomWidget = false,
    this.widget,
    this.isShowBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: themeColor,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          isArrow == true
              ? GestureDetector(
                  onTap: () {
                    if (isShowBackButton) {
                      Get.offAll(() => PagesWidget(
                            selectedIndex: 0,
                          ));
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  child: Container(child: Icon(Icons.arrow_back_ios,color: whiteColor,)))
              : Container(),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: boldText(text: title,color: whiteColor),
          ),
        ],
      ),
      automaticallyImplyLeading: false,
      actions: [
        isAction == true
            ? isCustomWidget == true
                ? widget!
                : Container(
                    margin: const EdgeInsets.only(right: 5),
                    child: Image.asset(
                      'assets/profile/filter.png',
                      scale: 3.5,
                    ))
            : Container(),
      ],
    );
  }
}
