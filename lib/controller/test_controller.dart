import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/getParameterModel.dart';
import 'package:diagnostics_patient/Models/test_model.dart';
import 'package:diagnostics_patient/utils/api.dart';
import 'package:http/http.dart' as http;
import 'package:diagnostics_patient/utils/colors.dart';

class TestController extends GetxController {
  TestModel? testModel;
  bool isLoading = true;
  String? testId;
  GetParameterModel? getParameterModel;
  TestDetailModel? testgDetailModel;
  bool isError = false;
  List<GetParameterListModel>? getParameterListModel = [];

  List<TestListModel>? testModelList = [];
  @override
  void onInit() {
    super.onInit();
    getTest();
    getParameters();
    update();
  }

  List<String>? idList;
  int? count;

  Future getTest({String? cityName, double? lat, double? lng}) async {
    log("--- getTest API call ---");
    try {
      isLoading = true;
      update();

      /*  Map<String, String> queryParams = {};
      if (cityName != null) queryParams['city'] = cityName;
      if (lat != null) queryParams['lat'] = lat.toString();
      if (lng != null) queryParams['lng'] = lng.toString(); */
      Map<String, String> queryParams = {
        'city': cityName ?? defaultCityName,
        'lat': (lat ?? defaultLat).toString(),
        'lng': (lng ?? defaultLng).toString(),
      };

      final uri = Uri.parse(baseUrl + getTestList)
          .replace(queryParameters: queryParams);

      log("--- API getTest REQUEST URL:: $uri");
      log("--- API getTest REQUEST queryParams:: $queryParams");

      final response = await http.post(uri);

      // ----- DEBUG: response status + body -----
      log("--- API getTest STATUS CODE:: ${response.statusCode}");
      log("--- API getTest RESPONSE BODY:: ${response.body}");

      // final response = await http.post(Uri.parse("${baseUrl}get_test"));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        log("--- API getTest DECODED status flag:: ${jsonResponse['status']}");

        if (jsonResponse['status'] == 1) {
          testModel = TestModel.fromJson(jsonResponse);
          testModelList = testModel!.data;
          log("--- API getTest SUCCESS:: total tests = ${testModelList?.length}");

          for (var i = 0; i < testModelList!.length; i++) {
            final String idString = testModelList![i].noOfParameter!;
            idList = idString.split(',');
            testModelList![i].countOfParamas = idList!.length;
            print(idList!.length);
          }
          isLoading = false;
          update();
        } else {
          isLoading = false;
          log("--- API getTest ERROR:: status != 1, message = ${jsonResponse['message'] ?? 'data not found'}");
          Get.snackbar(
            "Error",
            "data not found",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: redColor,
          );
          update();
        }
      } else {
        isLoading = false;
        log("--- API getTest ERROR:: HTTP ${response.statusCode} -> ${response.body}");
        update();
      }
    } catch (e, stackTrace) {
      isLoading = false;
      update();

      log("--- API getTest EXCEPTION:: $e");
      log("--- API getTest STACKTRACE:: $stackTrace");
      print('Exception: test_controller.dart - getTest()' + e.toString());
    }
  }

  Future getParameters() async {
    // update();
    try {
      final response = await http.get(Uri.parse(baseUrl + parameterGet));
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        if (jsonResponse['status'] == 1) {
          try {
            getParameterModel = GetParameterModel.fromJson(jsonResponse);
          } catch (E) {}
          getParameterListModel = getParameterModel!.data;
          isLoading = false;
          update();
        } else if (jsonResponse['status'] == 0) {
          isError = true;
          isLoading = false;
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
      isLoading = false;
      isError = true;
      update();
      print('Exception: test_controller.dart - getParameters()' + e.toString());
    }
  }
}
