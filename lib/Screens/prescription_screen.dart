// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Models/user_details_class.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/Screens/View/AuthScreen/login_screen.dart';

import 'package:diagnostics_patient/Screens/add_prescription_screen.dart';
import 'package:diagnostics_patient/controller/add_address_controller.dart';
import 'package:diagnostics_patient/controller/home_controller.dart';

import 'package:diagnostics_patient/controller/precription_controller.dart';
import '../../../componant/custome_appBar.dart';
import '../../../utils/AllText.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';

class PrecriptionScreen extends StatefulWidget {
  const PrecriptionScreen({Key? key}) : super(key: key);

  @override
  State<PrecriptionScreen> createState() => _PrecriptionScreenState();
}

// enum genderEnum { Male, Female }

class _PrecriptionScreenState extends State<PrecriptionScreen> {
  final key = GlobalKey<FormState>();

  final prescriptionController = Get.put(AddPrecriptionController());
  UserDetailsClass userDetails = UserDetailsClass();
  bool isLoading = true;

  // genderEnum? _gender = genderEnum.Male;

  getUserDetails() async {
    UserDetailsClass data = await UserDetailsClass().getUserDetails();
    setState(() {
      userDetails = data;
    });
    if (userDetails.isLoggedIn) {
      print('=========================>${userDetails.isLoggedIn}');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // controller.setData(widget.data!);
    getUserDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeSecondaryColor,
      body: Column(
        children: [
          CustomAppBar(title: 'Prescription', isArrow: true, isAction: false),
          Expanded(
            child: SingleChildScrollView(
              child:
                  GetBuilder<AddPrecriptionController>(builder: (controller) {
                return controller.isLoading
                    ? SizedBox(
                        height: Get.height / 1.2,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: themeColor,
                          ),
                        ),
                      )
                    : userDetails.isLoggedIn == false
                        ? Column(
                            children: [
                              SizedBox(height: 300),
                              Center(
                                child: customeElevatedButton(
                                  200,
                                  Login[LANGUAGE_TYPE],
                                  callback: () {
                                    Get.to(() => LoginScreen(index: 2));
                                  },
                                ),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              controller.isDataNotFound ||
                                      controller.precriptionList.isEmpty
                                  ? Container(
                                      margin:
                                          EdgeInsets.only(top: 70, bottom: 70),
                                      child: regularText(
                                          text:
                                              'Upload Prescription Not Found'),
                                    )
                                  : GetBuilder<AddPrecriptionController>(
                                      builder: (prescriptionController) {
                                      return ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          itemCount:
                                              controller.precriptionList.length,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: whiteColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20)),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 0,
                                                      vertical: 15),
                                                  margin: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      boldText(
                                                        text:
                                                            '${prescriptionController.precriptionList[index].name}',
                                                        size: 16,
                                                        color: blackColor,
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                              'assets/lab_phone.svg',
                                                              height: 17,
                                                              width: 17),
                                                          SizedBox(
                                                            height: 5,
                                                            width: 4,
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              '${prescriptionController.precriptionList[index].number != null ? prescriptionController.precriptionList[index].number : '---'}',
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontFamily:
                                                                    'Gilroy',
                                                              ),
                                                              maxLines: 1,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      // regularText(text: '${prescriptionController.precriptionList[index].number}', color: subTextColor, size: 14),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          SvgPicture.asset(
                                                              'assets/location.svg',
                                                              height: 20,
                                                              width: 20),
                                                          SizedBox(width: 4),
                                                          Expanded(
                                                            // flex: 1,
                                                            child: Text(
                                                              '${prescriptionController.precriptionList[index].location.name != null ? prescriptionController.precriptionList[index].location.name : ''}',
                                                              style: TextStyle(
                                                                fontSize: 13,
                                                                color:
                                                                    Colors.grey,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                fontFamily:
                                                                    'Gilroy',
                                                              ),
                                                              maxLines: 3,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      // regularText(text: '${prescriptionController.precriptionList[index].location.name}', color: subTextColor, size: 14),
                                                      // const SizedBox(
                                                      //   height: 10,
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                    }),
                              controller.isButtonLoading
                                  ? Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: customeElevatedButtonOutLine(
                                        MediaQuery.of(context).size.width,
                                        Upload_Precription[LANGUAGE_TYPE],
                                        callback: () async {
                                          prescriptionController
                                              .nameController.text = '';
                                          prescriptionController
                                              .relationController.text = '';
                                          prescriptionController
                                              .mobileNumberController.text = '';
                                          prescriptionController
                                              .emailController.text = '';
                                          prescriptionController
                                              .ageController.text = '';
                                          prescriptionController
                                              .dobController.text = '';
                                          prescriptionController
                                              .cityController.text = '';
                                          prescriptionController
                                              .stateController.text = '';
                                          prescriptionController
                                              .pinCodeController.text = '';
                                          final homeController =
                                              Get.find<HomeController>();
                                          homeController.selectedBranchName =
                                              null;
                                          homeController.selectedBranchId =
                                              null;
                                          homeController.update();
                                          await homeController
                                              .getLabByCityNameData(
                                            context,
                                            cityName: Get.find<
                                                        AddAddressController>()
                                                    .selectedDropdownValue ??
                                                "",
                                            /*  cityName:
                                                Get.find<AddAddressController>()
                                                        .tcCity
                                                        .text ??
                                                    "", */
                                          );
                                          bool isResult = await Get.to(
                                              () => UploadPrecriptionScreen());
                                          if (isResult) {
                                            controller.setLoadingTrue();
                                            controller.getPrescriptionList();
                                          }
                                        },
                                        color: themeSecondaryColor,
                                      ),
                                    ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
