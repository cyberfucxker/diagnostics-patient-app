import 'package:diagnostics_patient/config/app_config.dart';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:diagnostics_patient/Models/report_list_model.dart';
import 'package:diagnostics_patient/Models/user_details_class.dart';
import 'package:diagnostics_patient/Screens/View/Reports/report_list_screen.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/mediaRequestHelper.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class ReportloginController extends GetxController {
  void onInit() {
    super.onInit();
    init();
  }

  init() async {
    await getUserDetails();
  }

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
    update();
  }

  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  ScrollController scrollController = ScrollController();
  ReportListModel? reportListModel;
  UserDetailsClass userDetails = UserDetailsClass();
  bool isLoading = true;
  List<ReportListDataModel>? reportListData = [];
  Map<int, bool> isDownloading = {};

  // Report OTP login se aane wala user data
  String reportUserFid = '';
  String reportUserName = '';
  String reportUserEmail = '';
  String reportUserPhone = '';

  Future getReportList({String? userFid}) async {
    update();
    try {
      reportListData!.clear();
      final response = await http.get(
        Uri.parse('${AppConfig.hostUrl}report-api?UserFID=$userFid'),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['success'] == true) {
          reportListModel = ReportListModel.fromJson(jsonResponse);
          if (reportListModel!.data != null &&
              reportListModel!.data!.length > 0) {
            reportListData!.addAll(reportListModel!.data!);
            isLoading = false;
            await Future.delayed(Duration.zero);
            Get.offAll(() => ReportListScreen(userFid: userFid));
            update();
          } else {
            update();
          }
        } else {
          isLoading = false;
          update();
        }
      }
    } catch (e) {
      Get.snackbar(
        "Failed to load Data",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: redColor,
      );
      isLoading = false;
      update();
    }
  }

  Future<void> openFile(int testRegnId) async {
    try {
      isDownloading[testRegnId] = true;
      update();
      String fileUrl =
          "${AppConfig.hostUrl}report-download-api?testRegnID=$testRegnId";
      Directory tempDir = await getTemporaryDirectory();
      String filePath = "${tempDir.path}/$testRegnId.pdf";
      Dio dio = Dio();

      await dio.download(fileUrl, filePath);
      await OpenFilex.open(filePath);
      print('File downloaded and opened: $filePath');
    } catch (e) {
      print('Error downloading or opening the file: $e');
    } finally {
      isDownloading[testRegnId] = false;
      update();
    }
  }

  bool isDownloadings(int testRegnId) {
    return isDownloading[testRegnId] ?? false;
  }

  // Future<void> openFile(int fileName) async {
  //   try {
  //     String fileUrl = "${samplePathPdf}$fileName";
  //     Directory tempDir = await getTemporaryDirectory();
  //     String filePath = "${tempDir.path}/$fileName";
  //     Dio dio = Dio();
  //     await dio.download(fileUrl, filePath);
  //     await OpenFilex.open(filePath);
  //     print('File downloaded and opened: $filePath');
  //   } catch (e) {
  //     print('Error downloading or opening the file: $e');
  //   }
  // }
}
