import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';

import 'package:get/get.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';
// import 'package:diagnostics_patient/Models/packageDetails.dart';
import 'package:diagnostics_patient/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../Models/profile_detail_models.dart';
import '../Models/user_details_class.dart';

class ProfileDetailController extends GetxController {
  ProfileDetailModel? packageDetail;
  bool isLoading = true;
  bool isError = false;
  ProfileModel? data;
  int selectedTabbar = 0;
  var dio = Dio();
  int index1 = 0;
  bool test = false;
  UserDetailsClass userDetails = UserDetailsClass();
  final addressController = Get.find<AddAddressController>();

  int? packageId;
  ProfileDetailController({this.packageId});

  @override
  void onInit() {
    super.onInit();
    getUserDetails();
    // getPackageDetails();
    // getPermission();
    init();
  }

  init() async {
    await getUserDetails();
    getPackageDetails();
  }

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
    if (userDetails.isLoggedIn) {}
  }

  /// type_id id ma pass krva nu
  /// type ma different api call krva ni
  /// 1=>package,2=>parameter,3=>profile

  Future getPackageDetails() async {
    update();
    try {
      // final response = await http.get(Uri.parse(baseUrl + getProfileDetail + "?id=$packageId"));
      final queryParams = <String, String>{
        'id': packageId.toString(),
      };

      if (addressController.selectedDropdownValue != null)
        queryParams['city'] = addressController.selectedDropdownValue ?? "";
      if (addressController.center!.latitude != null)
        queryParams['lat'] = addressController.center!.latitude.toString();
      if (addressController.center!.longitude != null)
        queryParams['lng'] = addressController.center!.longitude.toString();

      final uri = Uri.parse(baseUrl + getProfileDetail).replace(
        queryParameters: queryParams,
      );

      log("--- getProfileDetail API :: ${uri}");

      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          packageDetail = ProfileDetailModel.fromJson(jsonResponse);
          // Data detail = packageDetail!.data;
          data = packageDetail!.data;
          isLoading = false;
          update();
          // return categoryModelList;
        } else {
          isLoading = false;
          isError = true;

          update();
          //   throw Exception('Failed to load Data');
        }
      }
    } catch (e) {
      isError = true;
      isLoading = false;
      update();
      print('Exception: profile_detail_controller.dart - getPackageDetails()' +
          e.toString());
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
