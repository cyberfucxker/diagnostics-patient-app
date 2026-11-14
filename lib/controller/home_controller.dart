import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:diagnostics_patient/Models/getlab_by_cityname_model.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custom_dialogue.dart';
import 'package:diagnostics_patient/utils/api.dart';

class HomeController extends GetxController {
  GetLabByCityNameModel getLabByCityNameModel = GetLabByCityNameModel();
  bool isLoading = true;
  String? selectedBranchName;
  String? selectedBranchId;

  @override
  void onInit() {
    // TODO: implement onInit
    selectedBranchName = null;
    selectedBranchId = null;
    super.onInit();
  }

  getLabByCityNameData(context, {required String cityName}) async {
    try {
      isLoading = true;
      showOnlyLoaderDialog(context);
      update();

      final uri = Uri.parse(baseUrl + "$getLabByCityName");
      Map<String, dynamic> requestBody = {};
      requestBody['cityname'] = cityName;
      final jsonBody = json.encode(requestBody);
      log("--- API getLabByCityName:: $uri");
      log("--- API getLabByCityName jsonBody:: $requestBody");

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        hideLoader(context);
        log("--- API getLabByCityName response:: ${response.body}");
        getLabByCityNameModel =
            GetLabByCityNameModel.fromJson(json.decode(response.body));
        isLoading = false;
        update();
      } else {
        hideLoader(context);
        isLoading = false;
        update();
      }
    } catch (e) {
      hideLoader(context);
      isLoading = false;
      update();
    }
  }
}
