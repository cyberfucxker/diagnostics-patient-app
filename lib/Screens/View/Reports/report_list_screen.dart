// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/report_list_model.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/page_widget.dart';
import 'package:diagnostics_patient/controller/report_payment_controller.dart';
import 'package:diagnostics_patient/controller/reportlogin_controller.dart';
import 'package:diagnostics_patient/utils/colors.dart';

class ReportListScreen extends StatelessWidget {
  String? userFid;

  ReportListScreen({this.userFid});

  ReportloginController reportloginController =
      Get.put(ReportloginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // CustomAppBar(title: 'Patient Report With Details', isArrow: true, isAction: false),
          AppBar(
            backgroundColor: themeColor,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          Get.context!,
                          MaterialPageRoute(
                              builder: (context) => PagesWidget(
                                    selectedIndex: 0,
                                  )));
                      // Navigator.pop(context);
                    },
                    child: Container(child: Icon(Icons.arrow_back_ios,color:Colors.white))),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: boldText(text: 'Patient Report With Details',color: Colors.white),
                ),
              ],
            ),
            automaticallyImplyLeading: false,
          ),
          Expanded(
            child:
                GetBuilder<ReportloginController>(builder: (reportController) {
              return reportController.isLoading
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
                  : reportController.reportListData!.isEmpty
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
                          controller: reportController.scrollController,
                          shrinkWrap: true,
                          itemCount: reportController.reportListData!.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              color: whiteColor,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 5),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      '${reportController.reportListData![index].patientName} ',
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: darkBlue,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: 'Gilroy',
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      '${reportController.reportListData![index].testRegnId}',
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
                                            '₹${reportController.reportListData![index].balanceAmt}',
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
                                        '${reportController.reportListData![index].selectedTest}',
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
                                          text:
                                              '${reportController.reportListData![index].regnDateTimeString}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: subTextColor,
                                              fontWeight: FontWeight.w200,
                                              fontFamily: 'Gilroy'),
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
                                                  text: '₹${reportController.reportListData![index].net}',
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
                                                  text:
                                                      '₹${reportController.reportListData![index].amountPaid}',
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
                                      reportController.reportListData![index]
                                                  .balanceAmt !=
                                              0
                                          ? Align(
                                              alignment: Alignment.bottomRight,
                                              child: TextButton(
                                                child: Text(
                                                    "Pay Online".toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 13)),
                                                style: ButtonStyle(
                                                  padding: MaterialStateProperty
                                                      .all<EdgeInsets>(
                                                          EdgeInsets.all(10)),
                                                  foregroundColor:
                                                      MaterialStateProperty.all<
                                                          Color>(themeColor),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      side: BorderSide(
                                                          color: themeColor),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  showPatientInfoDialog(
                                                      context,
                                                      reportController
                                                              .reportListData![
                                                          index]);
                                                },
                                              ),
                                            )
                                          : reportloginController.isDownloading[
                                                      reportController
                                                          .reportListData![
                                                              index]
                                                          .testRegnId!] ??
                                                  false
                                              ? Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      CircularProgressIndicator(),
                                                      SizedBox(height: 20),
                                                      Text("Downloading..."),
                                                    ],
                                                  ),
                                                )
                                              : Align(
                                                  alignment:
                                                      Alignment.bottomRight,
                                                  child: TextButton(
                                                    child: Text(
                                                        "Download Report"
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 13)),
                                                    style: ButtonStyle(
                                                      padding:
                                                          MaterialStateProperty
                                                              .all<
                                                                      EdgeInsets>(
                                                                  EdgeInsets
                                                                      .all(10)),
                                                      foregroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                                  themeColor),
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          side: BorderSide(
                                                              color:
                                                                  themeColor),
                                                        ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      reportloginController
                                                          .openFile(
                                                              reportController
                                                                  .reportListData![
                                                                      index]
                                                                  .testRegnId!);
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

  void showPatientInfoDialog(
      BuildContext context, ReportListDataModel reportModel) {
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
                foregroundColor: themeColor,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Pay'),
              style: ElevatedButton.styleFrom(backgroundColor: themeColor),
              onPressed: () {
                Get.put(ReportPaymentController()).reportAmount =
                    reportModel.balanceAmt!.toDouble();
                Get.put(ReportPaymentController()).regiId =
                    reportModel.testRegnId;
                Get.put(ReportPaymentController()).userFId = userFid!;
                Get.put(ReportPaymentController()).openCheckout(
                    reportModel.balanceAmt!.toDouble(),
                    '${reportloginController.userDetails.phone}',
                    '${reportloginController.userDetails.email}',
                    '${reportloginController.userDetails.name}');
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
