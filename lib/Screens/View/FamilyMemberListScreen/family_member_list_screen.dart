import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/controller/add_family_member_controller.dart';
import 'package:diagnostics_patient/controller/family_member_controller.dart';

import '../../../Models/family_member_list_model.dart';
import '../../../componant/custome_appBar.dart';
import '../../../utils/AllText.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';
import '../../Custome_Widgets/custome_widget.dart';
import 'add_new_family_member.dart';

class FamilyMemberList extends StatefulWidget {
  const FamilyMemberList({Key? key}) : super(key: key);

  @override
  State<FamilyMemberList> createState() => _FamilyMemberListState();
}

class _FamilyMemberListState extends State<FamilyMemberList> {
  List<FamilyMemberModel> member = [
    FamilyMemberModel(title: 'Vishal Gorasiya | Self', subTitle: 'Male,24 years'),
    FamilyMemberModel(title: 'Tulsi suhagiya | Self', subTitle: 'Female,20 years'),
    FamilyMemberModel(title: 'Chandani Dobariya | Self', subTitle: 'Female,26 years'),
    FamilyMemberModel(title: 'Ajay Pokiya | Self', subTitle: 'Male,25 years'),
    FamilyMemberModel(title: 'Rashika Dave | Self', subTitle: 'Female,25 years'),
    FamilyMemberModel(title: 'Ankit Suhagiya | Self', subTitle: 'Male,20 years'),
    FamilyMemberModel(title: 'Bhavin Stashiya | Self', subTitle: 'Male,28 years'),
  ];

  final familyMemberController = Get.put(FamilyMemberController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeSecondaryColor,
      body: Column(
        children: [
          CustomAppBar(title: FAMILY_MEMBER_LIST[LANGUAGE_TYPE], isArrow: true, isAction: false),
          Container(
            child: GetBuilder<FamilyMemberController>(builder: (controller) {
              return controller.isLoading
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 250.0),
                        child: CircularProgressIndicator(
                          color: themeColor,
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          controller.isDataNotFound || controller.familyMemberListModel!.data!.isEmpty
                              ? const SizedBox()
                              : Container(
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                      itemCount: controller.familyMemberListModel!.data!.length,
                                      itemBuilder: (context, index) {
                                        bool isFirst = index == 0 ? true : false;
                                        bool isLast = controller.familyMemberListModel!.data!.length - 1 == index ? true : false;
                                        var data = controller.familyMemberListModel!.data![index];
                                        String subTitle = '${data.gender},${data.age} years';
                                        return FamilyMemberListCard(
                                          index: index,
                                          isFirst: isFirst,
                                          isLast: isLast,
                                          title: data.name!,
                                          subTitle: subTitle,
                                          data: data,
                                        );
                                      }),
                                ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            child: customeElevatedButton(MediaQuery.of(context).size.width, ADD_MEMBER[LANGUAGE_TYPE], callback: () async {
                              Get.find<AddFamilyMemberController>().nameController.text = '';
                              Get.find<AddFamilyMemberController>().mobileNumberController.text = '';
                              Get.find<AddFamilyMemberController>().emailController.text = '';
                              Get.find<AddFamilyMemberController>().ageController.text = '';
                              Get.find<AddFamilyMemberController>().dobController.text = '';
                              Get.find<AddFamilyMemberController>().relationController.text = 'Father';

                              bool isResult = await Get.to(() => AddNewFamilyMember());
                              if (isResult) {
                                controller.getFamilyMemberList();
                              }
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             AddNewFamilyMember()));
                              // Navigator.pop(context);
                            }),
                          )
                        ],
                      ),
                    );
            }),
          ),
        ],
      ),
    );
  }
}

class FamilyMemberListCard extends StatelessWidget {
  final int index;
  final bool isFirst;
  final bool isLast;
  final String title;
  final String subTitle;
  final Datum data;

  const FamilyMemberListCard({
    Key? key,
    required this.index,
    required this.isFirst,
    required this.isLast,
    required this.title,
    required this.subTitle,
    required this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: whiteColor,
        borderRadius: isFirst && isLast
            ? const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))
            : isFirst
                ? const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))
                : isLast
                    ? const BorderRadius.only(bottomRight: Radius.circular(20), bottomLeft: Radius.circular(20))
                    : BorderRadius.circular(0),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 15),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          border: isLast ? const Border() : const Border(bottom: BorderSide(color: subTextColor, width: 1)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  boldText(
                    text: title.capitalize,
                    size: 16,
                    color: blackColor,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // Text(title),
                  regularText(text: subTitle, color: subTextColor, size: 14),
                  // Text(subTitle),
                ],
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () async {
                    bool isResult = await Get.to(() => AddNewFamilyMember(
                          isEdit: true,
                          data: data,
                        ));
                    if (isResult) {
                      Get.find<FamilyMemberController>().getFamilyMemberList();
                    }
                  },
                  child: Image.asset(
                    'assets/address_list/edit.png',
                    height: 35,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.find<FamilyMemberController>().deleteMember(memberId: data.id!);
                    print('on delete click');
                  },
                  child: Image.asset(
                    'assets/address_list/delete.png',
                    height: 30,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class FamilyMemberModel {
  String? title;
  String? subTitle;

  FamilyMemberModel({this.title, this.subTitle});
}
