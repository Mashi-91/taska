import 'dart:developer';
import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taska/constant/color.dart';

import 'controller.dart';

Widget circleProfile(FillProfileController controller) {
  return Center(
    child: Stack(
      children: [
        controller.image.isNotEmpty
            ? CircleAvatar(
                radius: 60,
                backgroundImage: FileImage(File(controller.image.value)),
              )
            : Container(
                width: 120,
                height: 120,
                padding: const EdgeInsets.only(top: 7),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.withOpacity(0.1)),
                child: const Icon(
                  FluentIcons.person_20_filled,
                  color: ColorsUtil.lightGrey,
                  size: 120,
                ),
              ),
        Positioned(
          bottom: 0,
          right: 8,
          child: InkWell(
            onTap: () {
              controller.imagePicker();
            },
            child: Container(
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(6)),
              child: const Icon(
                Icons.edit_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        )
      ],
    ),
  );
}

Widget textFieldSection(
    BuildContext context, FillProfileController controller) {
  return Column(
    children: [
      textFieldForFillYourProfile(
          hintText: 'Full Name',
          controller: controller.fullNameController,
          onChanged: (val) => controller.isButtonEnabled()),
      const SizedBox(height: 16),
      textFieldForFillYourProfile(
          hintText: 'User Name',
          controller: controller.userNameController,
          onChanged: (val) => controller.isButtonEnabled()),
      const SizedBox(height: 16),
      GestureDetector(
        onTap: () async {
          await DatePicker.showSimpleDatePicker(
            context,
            initialDate: DateTime(1994),
            firstDate: DateTime(1960),
            lastDate: DateTime.now(),
            dateFormat: "dd-MMMM-yyyy",
            looping: true,
          ).then((value) {
            if (value != null) {
              final DOB = DateFormat("dd-MMM-yyyy")
                  .format(value)
                  .replaceAllMapped("00:00:00.000", (match) => match.input);
              controller.setDOBValue(DOB);
              log("DOB: ${controller.dateOfBirth.value}");
            }
          });
        },
        child: Container(
          width: double.infinity,
          height: 66,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                controller.dateOfBirth.value != ""
                    ? controller.dateOfBirth.value
                    : "Date of Birth",
                style: TextStyle(color: Colors.grey.withOpacity(0.7)),
              ),
              const Icon(
                Icons.calendar_month_rounded,
                color: Colors.black26,
              )
            ],
          ),
        ),
      ),
      const SizedBox(height: 16),
      textFieldForFillYourProfile(
        hintText: 'Email',
        onChanged: (val) => controller.isButtonEnabled(),
        controller: controller.fillYourEmailAddress,
      ),
      const SizedBox(height: 16),
    ],
  );
}

Widget textFieldForFillYourProfile({
  required String hintText,
  TextInputType keyboardType = TextInputType.name,
  bool isPass = false,
  bool obsecure = false,
  int? maxLength,
  Widget? suffix,
  required Function(String) onChanged,
  Widget? prefix,
  required TextEditingController controller,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obsecure,
    onChanged: (val) => onChanged(val),
    maxLength: maxLength,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      hintText: hintText,
      suffixIcon: suffix,
      prefixIcon: prefix,
      hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Colors.grey.withOpacity(0.1),
            width: 2,
          )),
      filled: true,
      fillColor: Colors.grey.withOpacity(0.1),
    ),
  );
}
