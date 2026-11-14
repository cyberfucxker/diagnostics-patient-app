// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:diagnostics_patient/Models/family_member_list_model.dart';
import 'package:diagnostics_patient/Models/local_package_detail_model.dart';
import 'package:diagnostics_patient/controller/add_family_member_controller.dart';

import '../../../componant/custome_appBar.dart';
import '../../../controller/member_list_controller.dart';
import '../../../utils/AllText.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';
import '../../Custome_Widgets/custome_widget.dart';
import 'add_new_family_member.dart';

class MemberList extends StatelessWidget {
  LocalPackageModel localPackageModel;
  MemberList({Key? key, required this.localPackageModel}) : super(key: key);
  final controller = Get.put(MemberListClass());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeSecondaryColor,
      body: Column(
        children: [
          CustomAppBar(
            title: MEMBERS_LIST[LANGUAGE_TYPE],
            isArrow: true,
            isAction: false,
          ),

          // ✅ FIX 1: Wrap in Expanded so it takes remaining space after AppBar
          Expanded(
            child: GetBuilder<MemberListClass>(builder: (controller) {
              if (controller.isLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: themeColor),
                );
              }

              return Column(
                children: [
                  // ✅ FIX 2: Use Expanded instead of fixed height Container
                  Expanded(
                    child: controller.isDataNotFound ||
                        controller.familyMemberList.isEmpty
                        ? Center(
                      child: regularText(text: 'Member Not Found'),
                    )
                        : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      itemCount: controller.familyMemberList.length,
                      itemBuilder: (context, index) {
                        bool isFirst = index == 0;
                        bool isLast =
                            controller.familyMemberList.length - 1 ==
                                index;
                        var data = controller.familyMemberList[index];
                        String subTitle =
                            '${data.gender}, ${data.age} years';

                        return FamilyMemberListCard(
                          data: data,
                          index: index,
                          isFirst: isFirst,
                          isLast: isLast,
                          title: data.name!,
                          subTitle: subTitle,
                          onTap: (isSelected) {
                            controller.selectMember(index, isSelected!);
                          },
                          isSelected: data.isSelected!,
                        );
                      },
                    ),
                  ),

                  // Buttons at the bottom — not inside Expanded, so they stay fixed
                  if (controller.isButtonLoading)
                    const Center(child: CircularProgressIndicator())
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: customeElevatedButtonOutLine(
                        MediaQuery.of(context).size.width,
                        ADD_MEMBER[LANGUAGE_TYPE],
                        callback: () async {
                          Get.find<AddFamilyMemberController>()
                              .nameController
                              .text = '';
                          Get.find<AddFamilyMemberController>()
                              .mobileNumberController
                              .text = '';
                          Get.find<AddFamilyMemberController>()
                              .emailController
                              .text = '';
                          Get.find<AddFamilyMemberController>()
                              .ageController
                              .text = '';
                          Get.find<AddFamilyMemberController>()
                              .dobController
                              .text = '';
                          Get.find<AddFamilyMemberController>()
                              .relationController
                              .text = 'Father';

                          bool isResult =
                          await Get.to(() => AddNewFamilyMember());
                          if (isResult) {
                            controller.setLoadingTrue();
                            controller.getFamilyMemberList(isNew: true);
                          }
                        },
                        color: themeSecondaryColor,
                      ),
                    ),

                  if (!controller.isButtonLoading &&
                      !controller.isDataNotFound &&
                      controller.familyMemberList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: customeElevatedButton(
                        MediaQuery.of(context).size.width,
                        ADD_TO_CART[LANGUAGE_TYPE],
                        callback: () {
                          controller.addToCart(localPackageModel);
                        },
                      ),
                    ),

                  const SizedBox(height: 10),
                ],
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
  final bool isSelected;
  final Function(bool?) onTap;
  final Datum data;

  const FamilyMemberListCard({
    Key? key,
    required this.index,
    required this.isFirst,
    required this.isLast,
    required this.title,
    required this.subTitle,
    required this.isSelected,
    required this.onTap,
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
            Checkbox(
              value: isSelected,
              onChanged: onTap,
              fillColor: MaterialStateProperty.all(blackColor),
              side: const BorderSide(color: subTextColor),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  boldText(
                    text: title + " (${data.relation})",
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
                      Get.find<MemberListClass>().getFamilyMemberList(isNew: false);
                    }
                    // print('on edit click');
                  },
                  child: Image.asset(
                    'assets/address_list/edit.png',
                    color: themeColor,
                    height: 35,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.find<MemberListClass>().deleteMember(memberId: data.id!);
                  },
                  child: Image.asset(
                    'assets/address_list/delete.png',
                    color: themeColor,
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
  bool isSelected;

  FamilyMemberModel({this.title, this.subTitle, this.isSelected = false});
}
