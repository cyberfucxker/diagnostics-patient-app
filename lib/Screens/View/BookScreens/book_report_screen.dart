// // ignore_for_file: must_be_immutable

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:diagnostics_patient/Models/booking_detail_model.dart';
// import 'package:diagnostics_patient/Models/report_list_model.dart';
// import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
// import 'package:diagnostics_patient/Screens/Custome_Widgets/page_widget.dart';
// import 'package:diagnostics_patient/componant/custome_appBar.dart';
// import 'package:diagnostics_patient/controller/book_detail_controller.dart';
// import 'package:diagnostics_patient/controller/reportlogin_controller.dart';
// import 'package:diagnostics_patient/utils/colors.dart';

// class BookReportListScreen extends StatelessWidget {
//   Data? bookingData;
//   BookReportListScreen({this.bookingData});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           CustomAppBar(title: 'Reports', isArrow: true, isAction: false),
//           bookingData!.partiallyreports.isEmpty
//               ? Center(
//                   child: Container(
//                     child: Text('No Data Found',
//                         style: TextStyle(
//                           color: blackColor,
//                           fontSize: 15,
//                           fontWeight: FontWeight.w300,
//                         )),
//                   ),
//                 )
//               : ListView.builder(
//                   // controller: bookReportController.scrollController,
//                   shrinkWrap: true,
//                   itemCount: bookingData!.partiallyreports.length,
//                   itemBuilder: (context, index) {
//                     return Container(
//                       width: double.infinity,
//                       margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                       color: whiteColor,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
//                           SizedBox(height: 5),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               RichText(
//                                 text: TextSpan(
//                                   children: [
//                                     TextSpan(
//                                       text: '${bookingData!.partiallyreports[index].reportName} ',
//                                       style: TextStyle(
//                                         fontSize: 15,
//                                         color: darkBlue,
//                                         fontWeight: FontWeight.w700,
//                                         fontFamily: 'Gilroy',
//                                       ),
//                                     ),
//                                     TextSpan(
//                                       text: '${bookingData!.partiallyreports[index].testRegId}',
//                                       style: TextStyle(
//                                         fontSize: 15,
//                                         color: themeColor,
//                                         fontWeight: FontWeight.w700,
//                                         fontFamily: 'Gilroy',
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ],
//                           ),
//                           Get.put(ReportloginController()).isDownloading[bookingData!.partiallyreports[index].testRegId] ?? false
//                               ? Align(
//                                   alignment: Alignment.bottomRight,
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       CircularProgressIndicator(),
//                                       SizedBox(height: 20),
//                                       Text("Downloading..."),
//                                     ],
//                                   ),
//                                 )
//                               : Align(
//                                   alignment: Alignment.bottomRight,
//                                   child: TextButton(
//                                     child: Text("Download Report".toUpperCase(), style: TextStyle(fontSize: 13)),
//                                     style: ButtonStyle(
//                                       padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
//                                       foregroundColor: MaterialStateProperty.all<Color>(themeColor),
//                                       shape: MaterialStateProperty.all<RoundedRectangleBorder>(
//                                         RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(20),
//                                           side: BorderSide(color: themeColor),
//                                         ),
//                                       ),
//                                     ),
//                                     onPressed: () {
//                                       Get.put(ReportloginController()).openFile(bookingData!.partiallyreports[index].testRegId);
//                                     },
//                                   ),
//                                 ),
//                           SizedBox(height: 5),
//                         ]).marginSymmetric(horizontal: 4),
//                       ),
//                     );
//                   },
//                 )
//         ],
//       ),
//     );
//   }

//   void showPatientInfoDialog(BuildContext context, ReportListDataModel reportModel) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           title: Text('Patient Information'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               TextField(
//                 enabled: false,
//                 decoration: InputDecoration(
//                   hintText: '${reportModel.patientName}',
//                   filled: true,
//                   fillColor: Colors.grey[200],
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               TextField(
//                 enabled: false,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.grey[200],
//                   hintText: '${reportModel.balanceAmt}',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             TextButton(
//               child: Text('Close'),
//               style: TextButton.styleFrom(
//                 backgroundColor: Colors.grey[200],
//               ),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//             ElevatedButton(
//               child: Text('Pay'),
//               style: ElevatedButton.styleFrom(),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/report_list_model.dart';
import 'package:diagnostics_patient/componant/custome_appBar.dart';
import 'package:diagnostics_patient/controller/book_detail_controller.dart';
import 'package:diagnostics_patient/controller/report_payment_controller.dart';
import 'package:diagnostics_patient/controller/reportlogin_controller.dart';
import 'package:diagnostics_patient/utils/colors.dart';

class BookReportListScreen extends StatelessWidget {
  String? userFid;

  BookReportListScreen({this.userFid});

  ReportloginController reportloginController = Get.put(ReportloginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: 'Patient Report With Details', isArrow: true, isAction: false),
          Expanded(
            child: GetBuilder<BookDetailController>(builder: (bookReportController) {
              return bookReportController.isLoading
                  ? const Center(
                      child: SizedBox(
                        height: 150,
                        width: 35,
                        child: Center(
                            child: CircularProgressIndicator(
                          color: themeColor,
                        )),
                      ),
                    )
                  : bookReportController.reportListData!.isEmpty
                      ? Container(
                          alignment: Alignment.center,
                          child: const Text('No Data Found',
                              style: TextStyle(
                                color: blackColor,
                                fontSize: 15,
                                fontWeight: FontWeight.w300,
                              )),
                        )
                      : ListView.builder(
                          controller: bookReportController.scrollController,
                          shrinkWrap: true,
                          itemCount: bookReportController.reportListData!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              color: whiteColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  SizedBox(height: 5),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '${bookReportController.reportListData![index].patientName} ',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: darkBlue,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Gilroy',
                                              ),
                                            ),
                                            TextSpan(
                                              text: '${bookReportController.reportListData![index].testRegnId}',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: themeColor,
                                                fontWeight: FontWeight.w700,
                                                fontFamily: 'Gilroy',
                                              ),
                                            ),
                                          ],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '₹${bookReportController.reportListData![index].balanceAmt}',
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700,
                                          overflow: TextOverflow.ellipsis,
                                          fontFamily: 'Gilroy',
                                        ),
                                        maxLines: 1,
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '${bookReportController.reportListData![index].selectedTest}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                      fontFamily: 'Gilroy',
                                    ),
                                    maxLines: 1,
                                  ),
                                  SizedBox(height: 5),
                                  RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                      text: '${bookReportController.reportListData![index].regnDateTimeString}',
                                      style: TextStyle(fontSize: 14, color: subTextColor, fontWeight: FontWeight.w200, fontFamily: 'Gilroy'),
                                    )
                                  ])),
                                  SizedBox(height: 5),
                                  Row(
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Net ',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: subTextColor,
                                                fontWeight: FontWeight.w200,
                                                fontFamily: 'Gilroy',
                                              ),
                                            ),
                                            TextSpan(
                                              text: '₹${bookReportController.reportListData![index].net}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: subTextColor,
                                                fontWeight: FontWeight.w200,
                                                fontFamily: 'Gilroy',
                                              ),
                                            ),
                                          ],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(width: 8),
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: 'Paid ',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.green,
                                                fontWeight: FontWeight.w200,
                                                fontFamily: 'Gilroy',
                                              ),
                                            ),
                                            TextSpan(
                                              text: '₹${bookReportController.reportListData![index].amountPaid}',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.green,
                                                fontWeight: FontWeight.w200,
                                                fontFamily: 'Gilroy',
                                              ),
                                            ),
                                          ],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  bookReportController.reportListData![index].balanceAmt != 0
                                      ? Align(
                                          alignment: Alignment.bottomRight,
                                          child: TextButton(
                                            child: Text("Pay Online".toUpperCase(), style: TextStyle(fontSize: 13)),
                                            style: ButtonStyle(
                                              padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                                              foregroundColor: MaterialStateProperty.all<Color>(themeColor),
                                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20),
                                                  side: BorderSide(color: themeColor),
                                                ),
                                              ),
                                            ),
                                            onPressed: () {
                                              showPatientInfoDialog(context, bookReportController.reportListData![index]);
                                            },
                                          ),
                                        )
                                      : reportloginController.isDownloading[bookReportController.reportListData![index].testRegnId!] ?? false
                                          ? Align(
                                              alignment: Alignment.bottomRight,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  CircularProgressIndicator(),
                                                  SizedBox(height: 20),
                                                  Text("Downloading..."),
                                                ],
                                              ),
                                            )
                                          : Align(
                                              alignment: Alignment.bottomRight,
                                              child: TextButton(
                                                child: Text("Download Report".toUpperCase(), style: TextStyle(fontSize: 13)),
                                                style: ButtonStyle(
                                                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(10)),
                                                  foregroundColor: MaterialStateProperty.all<Color>(themeColor),
                                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.circular(20),
                                                      side: BorderSide(color: themeColor),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  reportloginController.openFile(bookReportController.reportListData![index].testRegnId!);
                                                },
                                              ),
                                            )
                                ]).marginSymmetric(horizontal: 4),
                              ),
                            );
                          },
                        );
            }),
          ),
        ],
      ),
    );
  }

  void showPatientInfoDialog(BuildContext context, ReportListDataModel reportModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text('Patient Information'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  hintText: '${reportModel.patientName}',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                enabled: false,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey[200],
                  hintText: '${reportModel.balanceAmt}',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              style: TextButton.styleFrom(
                backgroundColor: Colors.grey[200],
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Pay'),
              style: ElevatedButton.styleFrom(),
              onPressed: () {
                Get.put(ReportPaymentController()).reportAmount = 10;
                Get.put(ReportPaymentController()).regiId = reportModel.testRegnId;
                Get.put(ReportPaymentController()).userFId = userFid!;
                Get.put(ReportPaymentController()).openCheckout(10, '${reportloginController.userDetails.phone}', '${reportloginController.userDetails.email}', '${reportloginController.userDetails.name}');
                // Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
