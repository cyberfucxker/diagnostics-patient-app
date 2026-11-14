import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';
import 'package:diagnostics_patient/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../Models/parameter_detail_model.dart';
import '../Models/user_details_class.dart';

class ParameterDetailController extends GetxController {
  ParameterDetailModel? packageDetail;
  bool isLoading = true;
  bool isError = false;
  ParameterModel? data;
  int selectedTabbar = 0;
  var dio = Dio();
  int index1 = 0;
  bool test = false;
  UserDetailsClass userDetails = UserDetailsClass();
  final addressController = Get.find<AddAddressController>();

  // int packageId;
  final parameterId;
  ParameterDetailController(this.parameterId);

  @override
  void onInit() {
    super.onInit();
    init();
  }

  init() async {
    await getUserDetails();
    getParameterDetails();
  }

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
  }

  /// type_id id ma pass krva nu
  /// type ma different api call krva ni
  /// 1=>package,2=>parameter,3=>profile

  Future getParameterDetails() async {
    // update();
    try {
      /*  final response = await http
          .get(Uri.parse(baseUrl + getParameterDetail + "?id=$parameterId"));
      log("--- API getParameterDetail :: ${Uri.parse(baseUrl + getParameterDetail + "?id=$parameterId")}"); */
      final queryParams = <String, String>{
        'id': parameterId.toString(),
      };

      if (addressController.selectedDropdownValue != null)
        queryParams['city'] = addressController.selectedDropdownValue ?? "";
      if (addressController.center!.latitude != null)
        queryParams['lat'] = addressController.center!.latitude.toString();
      if (addressController.center!.longitude != null)
        queryParams['lng'] = addressController.center!.longitude.toString();

      final uri = Uri.parse(baseUrl + getParameterDetail).replace(
        queryParameters: queryParams,
      );

      log("--- getParameterDetail  API :: ${uri}");

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        log("--- getParameterDetail Response :: $jsonResponse");
        if (jsonResponse['status'] == 1) {
          try {
            packageDetail = ParameterDetailModel.fromJson(jsonResponse);
          } catch (E) {}
          data = packageDetail!.data;
          isLoading = false;
          update();
        } else if (jsonResponse['status'] == 0) {
          isError = true;
          isLoading = false;
          update();
        } else {
          isLoading = false;
          isError = true;
          Get.snackbar(
            "Error",
            "data not found",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: redColor,
          );
          update();
          //   throw Exception('Failed to load Data');
        }
      }
    } catch (e) {
      Get.snackbar(
        "Failed to load Data",
        "Something went wrong. Try again,",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: redColor,
      );
      isLoading = false;
      isError = true;
      update();
    }
  }

  void changeTab(int index) {
    selectedTabbar = index;
    update();
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
}
