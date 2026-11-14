import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/test_detail_model.dart';
import 'package:diagnostics_patient/Models/test_model.dart';
import 'package:diagnostics_patient/Models/user_details_class.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';
import 'package:diagnostics_patient/utils/api.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class TestDetailController extends GetxController {
  TestModel? testModel;
  bool isLoading = true;
  bool isError = false;
  TestDetailModel? testgDetailModel;
  int? testId;
  TestDetailModelsList? data;
  int selectedTabbar = 0;
  int index1 = 0;

  TestDetailController();
  TestDetailModels? testDetail;
  UserDetailsClass userDetails = UserDetailsClass();
  final addressController = Get.find<AddAddressController>();

  // TestController(this.testId);

  List<TestListModel>? testModelList = [];
  @override
  void onInit() {
    super.onInit();
    init();
  }

  init() async {
    getUserDetails();
  }

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
    update();
  }

  Future getTestDetail(int labId) async {
    isLoading = true;
    isError = false;
    update(['updateTest']);
    try {
      // final response =await http.post(Uri.parse(baseUrl + 'profile_detail' + "?id=$labId"));
      final queryParams = <String, String>{
        'id': labId.toString(),
      };

      if (addressController.selectedDropdownValue != null)
        queryParams['city'] = addressController.selectedDropdownValue ?? "";
      if (addressController.center!.latitude != null)
        queryParams['lat'] = addressController.center!.latitude.toString();
      if (addressController.center!.longitude != null)
        queryParams['lng'] = addressController.center!.longitude.toString();

      // Construct the full URI
      final uri = Uri.parse(baseUrl + 'profile_detail').replace(
        queryParameters: queryParams,
      );

      log("--- getTestDetail API :: ${uri}");

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          testDetail = TestDetailModels.fromJson(jsonResponse);
          // Data detail = packageDetail!.data;
          data = testDetail!.data;
          isLoading = false;
          // update(['updateTest']);
          // return categoryModelList;
        } else {
          isLoading = false;
          isError = true;

          // update(['updateTest']);
          //   throw Exception('Failed to load Data');
        }
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      // update(['updateTest']);
      print('Exception: test_detail_controller.dart - getTestDetail()' +
          e.toString());
    }
    update(['updateTest']);
  }

  Future download(
      Dio dio, String pdfBaseUrl, String labReport, ProgressDialog pd) async {
    update();
    try {
      var response = await dio.get(
        pdfBaseUrl,
        onReceiveProgress: (received, total) async {
          int progress = (((received / total) * 100).toInt());
          pd.update(value: progress - 5);
          await Future.delayed(const Duration(milliseconds: 100));
        },
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: true,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      File file = File(labReport);
      pd.update(value: 100);
      // pd.close();
      addIndex();
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
      // pd.update(value: 100);
      // update();
    } catch (e) {}
  }

  void addIndex() {
    index1++;
    update();
  }

  void changeTab(int index) {
    selectedTabbar = index;
    update();
  }
}
