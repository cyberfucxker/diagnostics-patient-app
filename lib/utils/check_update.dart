// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:diagnostics_patient/utils/colors.dart';

void showAppUpdateDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: blackColor.withOpacity(0.7),
    builder: (BuildContext context) {
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          insetPadding: EdgeInsets.symmetric(horizontal: 10),
          title: Text(
            'Update App',
            style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Gilroy'),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'We recommend that you update to the latest version. You can keep using the app while downloading the update.',
                style: TextStyle(
                    fontSize: 14,
                    color: blackColor,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Gilroy'),
              ),
              /* SizedBox(height: 10),
              Text(
                'Version 2.0.1 • 15 MB',
                style: TextStyle(
                    fontSize: 13,
                    color: subTextColor,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Gilroy'),
              ), */
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Maybe Later',
                style: TextStyle(
                    fontSize: 13,
                    color: blackColor,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Gilroy'),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(
                'Update Now',
                style: TextStyle(
                    fontSize: 13,
                    color: whiteColor,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Gilroy'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: redColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
