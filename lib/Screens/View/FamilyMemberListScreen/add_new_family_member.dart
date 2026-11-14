// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Models/family_member_list_model.dart';
import '../../../componant/custome_appBar.dart';
import '../../../componant/validation_screen.dart';
import '../../../controller/add_family_member_controller.dart';
import '../../../utils/AllText.dart';
import '../../../utils/colors.dart';
import '../../../utils/strings.dart';
import '../../Custome_Widgets/custome_widget.dart';

class AddNewFamilyMember extends StatefulWidget {
  final isEdit;
  final Datum? data;
  const AddNewFamilyMember({Key? key, this.isEdit = false, this.data})
      : super(key: key);

  @override
  State<AddNewFamilyMember> createState() => _AddNewFamilyMemberState();
}

class _AddNewFamilyMemberState extends State<AddNewFamilyMember> {
  final key = GlobalKey<FormState>();
  final controller = Get.put(AddFamilyMemberController());

  // ── Relation dropdown list ──────────────────────────────────────────────────
  final List<String> _relations = [
    'Father', 'Mother', 'Parent', 'Spouse',
    'Son', 'Daughter', 'Uncle', 'Aunty', 'Friend', 'Other','Self',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      controller.setData(widget.data!);
    }
  }

  // ── Shared InputDecoration ──────────────────────────────────────────────────
  InputDecoration _fieldDec({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: subTextColor,
        fontSize: 13,
        fontFamily: 'Regular',
      ),
      prefixIcon: Icon(icon, size: 18, color: themeColor.withOpacity(0.7)),
      suffixIcon: suffix,
      filled: true,
      fillColor: const Color(0xFFF7F8FC),
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200, width: 1.2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: themeColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
    );
  }

  // ── Field Label ─────────────────────────────────────────────────────────────
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Text(
        text,
        style: const TextStyle(
          color: blackColor,
          fontSize: 13,
          fontFamily: 'Bold',
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ── Section spacing ─────────────────────────────────────────────────────────
  Widget _gap([double h = 16]) => SizedBox(height: h);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: Column(
        children: [
          CustomAppBar(
            title: widget.isEdit
                ? EDIT_NEW_FAMILY_MEMBER[LANGUAGE_TYPE]
                : ADD_NEW_FAMILY_MEMBER[LANGUAGE_TYPE],
            isArrow: true,
            isAction: false,
          ),
          GetBuilder<AddFamilyMemberController>(
            builder: (controller) {
              return Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 30),
                  child: Form(
                    key: key,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        // ── Header Card ───────────────────────────────────
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                themeColor.withOpacity(0.10),
                                themeColor.withOpacity(0.04),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                                color: themeColor.withOpacity(0.15)),
                          ),
                          child: Row(children: [
                            Container(
                              width: 44, height: 44,
                              decoration: BoxDecoration(
                                color: themeColor.withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.group_add_rounded,
                                  color: themeColor, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.isEdit
                                      ? 'Edit Family Member'
                                      : 'Add Family Member',
                                  style: TextStyle(
                                    color: themeColor,
                                    fontFamily: 'Bold',
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Fill in the details below',
                                  style: TextStyle(
                                    color: subTextColor,
                                    fontFamily: 'Regular',
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        ),

                        // ── Name ─────────────────────────────────────────
                        _label(Enter_Name[LANGUAGE_TYPE]),
                        TextFormField(
                          controller: controller.nameController,
                          validator: validateName,
                          textCapitalization: TextCapitalization.words,
                          style: const TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 14,
                              color: blackColor),
                          decoration: _fieldDec(
                            hint: HINT_NAME[LANGUAGE_TYPE],
                            icon: Icons.person_outline_rounded,
                          ),
                        ),
                        _gap(),

                        // ── Relation ──────────────────────────────────────
                        _label(RELATION[LANGUAGE_TYPE]),
                        DropdownButtonFormField<String>(
                          value: controller.relationController.text.isEmpty
                              ? null
                              : controller.relationController.text,
                          isExpanded: true,
                          dropdownColor: whiteColor,
                          style: const TextStyle(
                            fontFamily: 'Regular',
                            fontSize: 14,
                            color: blackColor,
                          ),
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: themeColor.withOpacity(0.7),
                            size: 22,
                          ),
                          decoration: _fieldDec(
                            hint: HINT_RELATION[LANGUAGE_TYPE],
                            icon: Icons.people_outline_rounded,
                          ),
                          items: _relations
                              .map((label) => DropdownMenuItem(
                            value: label,
                            child: Text(label),
                          ))
                              .toList(),
                          validator: (v) =>
                          v == null || v.isEmpty ? 'Please select relation' : null,
                          onChanged: (value) {
                            setState(() {
                              controller.relationController.text = value!;
                            });
                          },
                        ),
                        _gap(),

                        // ── Mobile ────────────────────────────────────────
                        _label(MOBILE_NO[LANGUAGE_TYPE]),
                        TextFormField(
                          controller: controller.mobileNumberController,
                          validator: validatePhone,
                          keyboardType: TextInputType.number,
                          maxLength: 12,
                          style: const TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 14,
                              color: blackColor),
                          decoration: _fieldDec(
                            hint: HINT_PHONE[LANGUAGE_TYPE],
                            icon: Icons.phone_outlined,
                          ).copyWith(counterText: ''),
                        ),
                        _gap(),

                        // ── Email ─────────────────────────────────────────
                        _label(Email[LANGUAGE_TYPE]),
                        TextFormField(
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 14,
                              color: blackColor),
                          decoration: _fieldDec(
                            hint: HINT_EMAIL[LANGUAGE_TYPE],
                            icon: Icons.email_outlined,
                          ),
                        ),
                        _gap(),

                        // ── Age ───────────────────────────────────────────
                        _label(AGE[LANGUAGE_TYPE]),
                        TextFormField(
                          controller: controller.ageController,
                          validator: validateAge,
                          keyboardType: TextInputType.number,
                          maxLength: 3,
                          style: const TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 14,
                              color: blackColor),
                          decoration: _fieldDec(
                            hint: HINT_AGE[LANGUAGE_TYPE],
                            icon: Icons.cake_outlined,
                          ).copyWith(counterText: ''),
                        ),
                        _gap(),

                        // ── Gender ────────────────────────────────────────
                        _label(GENDER[LANGUAGE_TYPE]),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F8FC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.grey.shade200, width: 1.2),
                          ),
                          child: Row(children: [
                            Expanded(
                              child: _GenderOption(
                                label: MALE[LANGUAGE_TYPE],
                                icon: Icons.male_rounded,
                                value: genderEnum.Male,
                                groupValue: controller.gender,
                                onChanged: controller.selectGender,
                              ),
                            ),
                            Container(
                                width: 1,
                                height: 48,
                                color: Colors.grey.shade200),
                            Expanded(
                              child: _GenderOption(
                                label: FEMALE[LANGUAGE_TYPE],
                                icon: Icons.female_rounded,
                                value: genderEnum.Female,
                                groupValue: controller.gender,
                                onChanged: controller.selectGender,
                              ),
                            ),
                          ]),
                        ),

                        _gap(28),

                        // ── Buttons ───────────────────────────────────────
                        controller.isSaveLoading
                            ? const Center(
                            child: CircularProgressIndicator(
                                color: themeColor))
                            : Row(children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                controller.resetForm();
                                Get.back(result: false);
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                side: BorderSide(
                                    color: themeColor, width: 1.5),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(12)),
                              ),
                              child: Text(
                                CANCEL[LANGUAGE_TYPE],
                                style: TextStyle(
                                  color: themeColor,
                                  fontFamily: 'Bold',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (key.currentState!.validate()) {
                                  if (widget.isEdit) {
                                    controller.addNewMember(
                                        isEdit: true,
                                        memberId: widget.data!.id);
                                  } else {
                                    controller.addNewMember();
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeColor,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(12)),
                              ),
                              child: Text(
                                Save[LANGUAGE_TYPE],
                                style: const TextStyle(
                                  color: whiteColor,
                                  fontFamily: 'Bold',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ]),
                      ],
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

// ─────────────────────────────────────────────────────────────────────────────
// Gender Option Widget
// ─────────────────────────────────────────────────────────────────────────────

class _GenderOption extends StatelessWidget {
  final String label;
  final IconData icon;
  final genderEnum value;
  final genderEnum? groupValue;
  final Function(genderEnum?) onChanged;

  const _GenderOption({
    required this.label,
    required this.icon,
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = groupValue == value;
    return GestureDetector(
      onTap: () => onChanged(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? themeColor.withOpacity(0.08) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? themeColor : subTextColor,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Regular',
                fontSize: 14,
                fontWeight:
                isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? themeColor : subTextColor,
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? themeColor : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                child: Container(
                  width: 9,
                  height: 9,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeColor,
                  ),
                ),
              )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}