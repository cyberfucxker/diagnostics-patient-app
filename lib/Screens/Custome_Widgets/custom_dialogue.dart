// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/utils/colors.dart';

showCustomDialog(
    {title,
    msg,
    VoidCallback? onPressedBtnYes,
    VoidCallback? onPressedButtonNo,
    btnYesText,
    btnNoText,
    context,
    bool barrierDismissible = false}) {
  return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              constraints: BoxConstraints(maxWidth: 400),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      semiBoldText(text: title, size: 22),
                      // Text(title,
                      //   style: TextStyle(
                      //     fontSize: 22,
                      //     color: blackColor,
                      //     // letterSpacing: .5,
                      //     fontWeight: FontWeight.w500,
                      //     fontFamily: "Semibold",
                      //
                      //   ),
                      //   textAlign: TextAlign.start,
                      //
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      // Text(msg,
                      //   style: TextStyle(
                      //     fontSize: 15,
                      //     color: blackColor,
                      //     // letterSpacing: .5,
                      //     fontWeight: FontWeight.w500,
                      //     fontFamily: "Semibold",
                      //
                      //   ),
                      //   textAlign: TextAlign.center,
                      //
                      // ),
                      semiBoldText(
                          text: msg, size: 15, alignment: TextAlign.center),
                      SizedBox(
                        height: 20,
                      ),
                      btnYesText == null
                          ? Container()
                          : Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: onPressedBtnYes,
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: themeColor,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Center(
                                          child: semiBoldText(
                                              text: btnYesText,
                                              color: whiteColor,
                                              size: 15),
                                          // child: Text(btnYesText,
                                          //   style: TextStyle(
                                          //     fontSize: 15,
                                          //     color: whiteColor,
                                          //     // letterSpacing: .5,
                                          //     fontWeight: FontWeight.w500,
                                          //     fontFamily: "Semibold",
                                          //
                                          //   ),
                                          //   textAlign: TextAlign.center,
                                          //
                                          // ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                      btnYesText == null
                          ? Container()
                          : SizedBox(
                              height: 10,
                            ),
                      btnNoText == null
                          ? Container()
                          : Row(
                              children: [
                                SizedBox(
                                  width: 20,
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: onPressedButtonNo,
                                    borderRadius: BorderRadius.circular(30),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.grey,
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Center(
                                            // child: semiBoldText(
                                            //     text: btnNoText,
                                            //     color: blackColor,
                                            //     size: 15
                                            // ),

                                            child: Container(
                                                child: Text(
                                          btnNoText,
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: blackColor,
                                            // letterSpacing: .5,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Semibold",
                                          ),
                                          textAlign: TextAlign.start,
                                        ))),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      });
}


showLoadingMsg({required BuildContext context, msg, title}) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: blackColor.withOpacity(0.7),
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            contentPadding: EdgeInsets.symmetric(horizontal: 15),
            insetPadding: EdgeInsets.symmetric(horizontal: 20),
            title: semiBoldText(
              text: title,
              color: blackColor,
              size: 20,
            ),
            content: Container(
              margin: EdgeInsets.fromLTRB(0, 10, 0, 20),
              child: Row(
                children: [
                  CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(themeColor),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: regularText(
                      text: msg,
                      size: 14,
                      color: subTextColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
}

showOnlyLoaderDialog(context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return const Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Center(
          child: CircularProgressIndicator(color: themeColor),
        ),
      );
    },
  );
}

void hideLoader(BuildContext context) {
  Navigator.pop(context);
}
