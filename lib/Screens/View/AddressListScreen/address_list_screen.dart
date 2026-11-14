// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Screens/View/AddressListScreen/address_add_screen.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';
import 'package:diagnostics_patient/controller/address_list_controller.dart';
import '../../../componant/custome_appBar.dart';
import '../../../utils/AllText.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';
import '../../Custome_Widgets/custome_widget.dart';

class AddressListScreen extends StatefulWidget {
  const AddressListScreen({Key? key}) : super(key: key);

  @override
  State<AddressListScreen> createState() => _AddressListScreenState();
}

class _AddressListScreenState extends State<AddressListScreen> {
  int listLength = 5;
  AddressListController addressListController =
  Get.put(AddressListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeSecondaryColor,
      body: Column(
        children: [
          ///------ appbar ------
          CustomAppBar(
              title: ADDRESS_LIST[LANGUAGE_TYPE],
              isArrow: true,
              isAction: false),
          Expanded(
            child: GetBuilder<AddressListController>(
              builder: (controller) {
                // ── Loading ──────────────────────────────────────────────
                if (controller.isLoading) {
                  return const Center(
                    child: SizedBox(
                      height: 150,
                      width: 35,
                      child: Center(
                          child: CircularProgressIndicator(
                              color: themeColor)),
                    ),
                  );
                }

                // ── Empty state ──────────────────────────────────────────
                if (controller.data.isEmpty) {
                  // ✅ RefreshIndicator on empty state bhi — user pull karke
                  //    dobara fetch kar sake agar network issue tha.
                  return RefreshIndicator(
                    color: themeColor,
                    onRefresh: () async {
                      await controller.AddressList();
                    },
                    child: SingleChildScrollView(
                      // RefreshIndicator ke liye scroll content zaroori hai
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Center(
                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: customeElevatedButton(
                                MediaQuery.of(context).size.width,
                                ADD_ADDRESS[LANGUAGE_TYPE],
                                callback: () {
                                  Get.find<AddAddressController>()
                                      .tcSaveAS
                                      .text = 'Home';
                                  Get.to(() => LocationScreen(
                                    isEdit: false,
                                    isAddressShowCity: true,
                                    isAddressShowdroup: false,
                                  ));
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }

                // ── Address list with RefreshIndicator ───────────────────
                return RefreshIndicator(
                  color: themeColor,          // spinner ka color themeColor
                  backgroundColor: Colors.white,
                  displacement: 40,           // kitna pull karne pe trigger ho
                  onRefresh: () async {
                    // ✅ await lagaya hai — spinner tab tak dikhega jab tak
                    //    AddressList() complete na ho jaye
                    await controller.AddressList();
                  },
                  child: ListView.builder(
                    // ✅ AlwaysScrollableScrollPhysics zaroori hai — iske
                    //    bina agar list chhoti ho toh pull-to-refresh kaam
                    //    nahi karta (scroll nahi hoti toh gesture detect
                    //    nahi hota).
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    itemCount: addressListController.data.length + 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return addressListController.data.length != index
                          ? AddressDetailCard(
                          data: addressListController.data[index])
                          : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: customeElevatedButton(
                          MediaQuery.of(context).size.width,
                          ADD_ADDRESS[LANGUAGE_TYPE],
                          callback: () async {
                            Get.find<AddAddressController>()
                                .tcHouseNo
                                .text = '';
                            Get.find<AddAddressController>()
                                .tcPhone
                                .text = '';
                            Get.find<AddAddressController>()
                                .tcSaveAS
                                .text = 'Home';
                            bool result =
                            await Get.to(() => LocationScreen(
                              isEdit: false,
                              isAddressShowCity: true,
                              isAddressShowdroup: true,
                            ));
                            if (result) {
                              controller.AddressList();
                            }
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class AddressDetailCard extends StatelessWidget {
  var data;

  AddressDetailCard({this.data});

  AddressListController addressListController =
  Get.put(AddressListController());

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      padding:
      const EdgeInsets.only(right: 10, left: 10, bottom: 10, top: 5),
      decoration: BoxDecoration(
          color: whiteColor, borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: boldText(
                  text: data.name,
                  size: 16,
                  color: blackColor,
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      // ✅ FIX: Edit mode mein caller fields clear/override
                      //    NAHI karega — LocationScreen ka initState khud
                      //    address model se sab prefill karta hai.
                      //    Pehle tcSaveAS.text = 'Home' hard-set hota tha
                      //    jisse saved name override ho jaata tha.
                      bool? result =
                      await Get.to(() => LocationScreen(
                        isEdit: true,
                        address: data,
                        isAddressShowCity: true,
                        isAddressShowdroup: false,
                      ));
                      print('--- result:${result}');
                      if (result == true) {
                        addressListController.AddressList();
                      }
                    },
                    child: Image.asset(
                      'assets/address_list/edit.png',
                      height: 35,
                    ),
                  ),
                  addressListController.isDeleteLoading == true
                      ? Container(
                      height: 15,
                      width: 15,
                      child: CircularProgressIndicator())
                      : InkWell(
                    onTap: () async {
                      bool result =
                      await addressListController.DeleteAddress(
                          id: data.id);
                      if (result) {
                        addressListController.AddressList();
                      }
                    },
                    child: Image.asset(
                      'assets/address_list/delete.png',
                      height: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
          regularText(
            text: data.address,
            color: subTextColor,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}