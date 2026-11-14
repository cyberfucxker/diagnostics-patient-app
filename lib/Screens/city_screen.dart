// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:diagnostics_patient/componant/custome_appBar.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';
import 'package:diagnostics_patient/controller/popular_package_controller.dart';

import 'package:diagnostics_patient/utils/colors.dart';

class CityScreen extends StatelessWidget {
  PopularPackageController categoryListController = Get.put(PopularPackageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: 'Select your location', isArrow: true, isAction: false),
          Expanded(
            child: GetBuilder<AddAddressController>(builder: (controller) {
              return Container(
                color: themeSecondaryColor,
                child: GoogleMap(
                  onMapCreated: Get.find<AddAddressController>().onMapCreated,
                  scrollGesturesEnabled: true,
                  initialCameraPosition: CameraPosition(
                    target: Get.find<AddAddressController>().center!,
                    zoom: 15.0,
                  ),
                  onTap: (latLang) {
                    Get.find<AddAddressController>().onMapTap(latLang);
                    //Toast.show(latLang.toString(), context,duration: 2);
                  },
                  buildingsEnabled: true,
                  compassEnabled: true,
                  markers: Get.find<AddAddressController>().markers.values.toSet(),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
