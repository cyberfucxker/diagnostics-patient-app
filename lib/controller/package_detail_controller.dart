import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/packageDetails.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';
import 'package:diagnostics_patient/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../Models/user_details_class.dart';

class PackageDetailController extends GetxController {
  PackageDetailModel? packageDetail;
  bool isLoading = true;
  bool isError = false;
  Data? data;
  int selectedTabbar = 0;
  var dio = Dio();
  int index1 = 0;
  bool test = false;
  UserDetailsClass userDetails = UserDetailsClass();
  final addressController = Get.find<AddAddressController>();

  int packageId;
  PackageDetailController(this.packageId);

  @override
  void onInit() {
    super.onInit();
    init();
    // getUserDetails();
    // getPackageDetails();
    // getPermission();
  }

  init() async {
    getUserDetails();
    getPackageDetails();
  }

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    userDetails = data;
  }

  /// type_id id ma pass krva nu
  /// type ma different api call krva ni
  /// 1=>package,2=>parameter,3=>profile
  String? description;

  Future getPackageDetails() async {
    try {
      // final response = await http.get(Uri.parse(baseUrl + getpackagedetail + "?id=$packageId"));

      final queryParams = <String, String>{
        'id': packageId.toString(),
      };

      if (addressController.selectedDropdownValue != null)
        queryParams['city'] = addressController.selectedDropdownValue ?? "";
      if (addressController.center!.latitude != null)
        queryParams['lat'] = addressController.center!.latitude.toString();
      if (addressController.center!.longitude != null)
        queryParams['lng'] = addressController.center!.longitude.toString();

      final uri = Uri.parse(baseUrl + getpackagedetail).replace(
        queryParameters: queryParams,
      );

      log("--- getPackageDetails API :: ${uri}");

      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          packageDetail = PackageDetailModel.fromJson(jsonResponse);
          // Data detail = packageDetail!.data;
          data = packageDetail!.data;
          String selectedCity = addressController.tcCity.text != ''
              ? addressController.tcCity.text
              : addressController.manageCityModel?.data![0].city ?? '';
          /* String selectedCity =
              Get.put(AddAddressController()).tcCity.text != ''
                  ? Get.put(AddAddressController()).tcCity.text
                  : Get.put(AddAddressController())
                          .manageCityModel
                          ?.data![0]
                          .city ??
                      ''; */

          // Replace {city} with the selected city in the description
          description = data!.description.replaceAll('{city}', selectedCity);
          print('feniiiiii ${description}');
          isLoading = false;
          update();
          // return categoryModelList;
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
