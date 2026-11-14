// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/componant/custome_appBar.dart';
import 'package:diagnostics_patient/controller/category_Controller.dart';
import 'package:diagnostics_patient/utils/AllText.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/strings.dart';

class SearchScreen extends StatelessWidget {
  CategoryController categoryListController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(title: Search_for_lab[LANGUAGE_TYPE], isArrow: true, isAction: false),
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              cursorColor: subTextColor,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(color: subTextColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: subTextColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: subTextColor),
                  borderRadius: BorderRadius.circular(15),
                ),
                isDense: true,
                prefixIcon: const Icon(
                  Icons.search,
                  color: subTextColor,
                  size: 24,
                ),
                hintText: Search[LANGUAGE_TYPE],
                hintStyle: const TextStyle(
                  color: subTextColor,
                  fontSize: 16,
                  // fontWeight: FontWeight.w300,
                  // letterSpacing: 2.0,
                  fontFamily: "Regular",
                ),
              ),
              onChanged: (value) {
                if (value == "") {
                  categoryListController.getCategory(false);
                } else {
                  categoryListController.searchData(value);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
