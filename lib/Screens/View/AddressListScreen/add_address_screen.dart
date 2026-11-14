import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/controller/checkout_controller.dart';

import '../../../Models/address_list_model.dart';
import '../../../componant/custome_appBar.dart';
import '../../../componant/validation_screen.dart';
import '../../../controller/add_address_controller.dart';
import '../../../utils/AllText.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';

final formKey = GlobalKey<FormState>();

class AddAddressScreen extends StatelessWidget {
  final bool isEdit;
  final AddressModel? address;
  final bool? isAddressShowCity;
  final bool? isAddressShowdroup;
  AddAddressScreen({Key? key, this.isEdit = false, this.address, this.isAddressShowCity, this.isAddressShowdroup}) : super(key: key);

  // final addAddressController = Get.put();

  @override
  Widget build(BuildContext context) {
    // addAddressController.init();
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: whiteColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomAppBar(title: isEdit ? EDIT_ADDRESS[LANGUAGE_TYPE] : ADD_ADDRESS[LANGUAGE_TYPE], isArrow: true, isAction: false),
          GetBuilder<AddAddressController>(
            init: AddAddressController(),
            builder: (controller) {
              return Expanded(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20).copyWith(bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height / 2,
                            child: controller.isGoogleMapLoading
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : GoogleMap(
                                    onMapCreated: controller.onMapCreated,
                                    scrollGesturesEnabled: true,
                                    initialCameraPosition: CameraPosition(
                                      target: controller.center!,
                                      zoom: 15.0,
                                    ),
                                    onTap: (latLang) {
                                      controller.onMapTap(latLang);
                                      //Toast.show(latLang.toString(), context,duration: 2);
                                    },
                                    buildingsEnabled: true,
                                    compassEnabled: true,
                                    markers: controller.markers.values.toSet(),
                                  ),
                          ),
                          // SizedBox(height: 10,),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  regularText(text: 'Default Address'),
                                  Checkbox(
                                    fillColor: MaterialStateColor.resolveWith((states) => blackColor),
                                    value: controller.isDefaultAddress,
                                    onChanged: (bool? value) {
                                      controller.changeIsDefaultAddress();
                                    },
                                  )
                                ],
                              ),
                              textFildHeader(ADDRESS[LANGUAGE_TYPE], width),
                              editCustomTextField(
                                validateAddress,
                                controller.tcAddress,
                                width,
                                ADDRESS[LANGUAGE_TYPE],
                              ),
                              SizedBox(
                                height: 19,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        textFildHeader(HOUSENO[LANGUAGE_TYPE], width),
                                        editCustomTextField(
                                          validateHousNo,
                                          controller.tcHouseNo,
                                          width,
                                          HOUSENO[LANGUAGE_TYPE],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        textFildHeader(STATE[LANGUAGE_TYPE], width),
                                        editCustomTextField(
                                          validateState,
                                          controller.tcState,
                                          width,
                                          STATE[LANGUAGE_TYPE],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        textFildHeader(PINCODE[LANGUAGE_TYPE], width),
                                        editCustomTextField(
                                          validatePinCode,
                                          controller.tcPincode,
                                          width,
                                          PINCODE[LANGUAGE_TYPE],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              isAddressShowCity == false ? SizedBox(height: 19) : SizedBox(),
                              isAddressShowCity == false ? textFildHeader(CITY[LANGUAGE_TYPE], width) : SizedBox(),

                              isAddressShowCity == false
                                  ? editCustomTextField(
                                      validatePinCode,
                                      controller.tcCity,
                                      width,
                                      CITY[LANGUAGE_TYPE],
                                    )
                                  : SizedBox(),

                              isAddressShowdroup! ? SizedBox(height: 19) : SizedBox(),
                              isAddressShowdroup! ? textFildHeader(CITY[LANGUAGE_TYPE], width) : SizedBox(),

                              isAddressShowdroup!
                                  ? controller.isGettingManagersCity
                                      ? const Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : DropdownButtonFormField<String>(
                                          value: Get.find<AddAddressController>().tcCity.text,
                                          validator: validateCity,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: width > 360 ? 16 : 14,
                                            color: blackColor,
                                            fontFamily: "Regular",
                                          ),
                                          decoration: const InputDecoration(
                                            border: UnderlineInputBorder(
                                              borderSide: BorderSide(color: blackColor),
                                            ),
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: subTextColor),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(color: blackColor),
                                            ),
                                            focusColor: blackColor,
                                            fillColor: blackColor,
                                          ),
                                          items: Get.find<AddAddressController>()
                                              .manageCityModel!
                                              .data!
                                              .map((label) => DropdownMenuItem<String>(
                                                    child: Text(label.city.toString()),
                                                    value: label.city,
                                                  ))
                                              .toList(),
                                          hint: Text('Select Branch'),
                                          onChanged: (value) {
                                            Get.find<AddAddressController>().changeCity(value);
                                          },
                                        )
                                  : SizedBox(),

                              // editCustomTextField(
                              //   validateCity,
                              //   controller.tcCity,
                              //   width,
                              //   CITY[LANGUAGE_TYPE],
                              // ),
                              // SizedBox(height: 19),
                              // textFildHeader(PHONE[LANGUAGE_TYPE], width),
                              // editCustomTextField(
                              //   validatePhone,
                              //   controller.tcPhone,
                              //   width,
                              //   PHONE[LANGUAGE_TYPE],
                              //   textInputType: TextInputType.number,
                              //   maxLen: 12,
                              // ),

                              SizedBox(height: 19),
                              textFildHeader(SAVEAS[LANGUAGE_TYPE], width),
                              // editCustomTextField(
                              //   validateSaveAS,
                              //   controller.tcSaveAS,
                              //   width,
                              //   SAVEAS[LANGUAGE_TYPE],
                              // ),
                              DropdownButtonFormField<String>(
                                value: controller.tcSaveAS.text,

                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: width > 360 ? 16 : 14,
                                  color: blackColor,
                                  fontFamily: "Regular",
                                ),
                                decoration: const InputDecoration(
                                  border: UnderlineInputBorder(
                                    borderSide: BorderSide(color: blackColor),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: subTextColor),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: blackColor),
                                  ),
                                  focusColor: blackColor,
                                  fillColor: blackColor,
                                ),
                                items: ['Home', 'Work', 'Other']
                                    .map((label) => DropdownMenuItem(
                                          child: Text(label.toString()),
                                          value: label,
                                        ))
                                    .toList(),
                                // hint: Text(HINT_RELATION[LANGUAGE_TYPE]),
                                onChanged: (value) {
                                  controller.tcSaveAS.text = value!;
                                },
                              ),

                              SizedBox(height: 19),
                              controller.isAddingAddress
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : customeElevatedButton(
                                      width,
                                      isEdit ? Update[LANGUAGE_TYPE] : Save[LANGUAGE_TYPE],
                                      callback: () async {
                                        if (formKey.currentState!.validate()) {
                                          // controller.addNewMember();
                                          if (isEdit) {
                                            controller.addAddress(isEdit: true, addressId: address!.id);
                                          } else {
                                            print("-----------No Ad Address-------------");
                                            controller.addAddress();
                                          }
                                        }
                                      },
                                    ),
                              SizedBox(height: 19),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
