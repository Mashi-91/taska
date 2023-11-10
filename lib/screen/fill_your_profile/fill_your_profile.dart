import 'dart:developer';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:taska/constant/snackBar.dart';
import 'package:taska/model/fill_profile_model.dart';
import 'package:taska/screen/fill_your_profile/widget.dart';

import '../../constant/utils.dart';
import 'controller.dart';

class FillYourProfile extends StatefulWidget {
  const FillYourProfile({super.key});

  @override
  State<FillYourProfile> createState() => _FillYourProfileState();
}

class _FillYourProfileState extends State<FillYourProfile> {
  final controller = Get.put(FillProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(title: 'Fill Your Profile'),
      body: Obx(
        () => SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
            child: Column(
              children: [
                circleProfile(controller),
                SizedBox(height: Get.height * 0.03),
                textFieldSection(context, controller),
                textFieldForFillYourProfile(
                  hintText: 'Phone',
                  onChanged: (val) => controller.isButtonEnabled(),
                  prefix: InkWell(
                    onTap: () async {
                      final code = await const FlCountryCodePicker()
                          .showPicker(context: context);
                      controller.setCode(code);
                      setState(() {});
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      width: 40,
                      height: 40,
                      child: controller.code?.flagUri == null
                          ? SvgPicture.asset("assets/flag/india.svg")
                          : controller.code?.flagImage(),
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  controller: controller.phoneController,
                ),
                textFieldForFillYourProfile(
                  hintText: 'Role',
                  onChanged: (val) => controller.isButtonEnabled(),
                  controller: controller.roleController,
                ),
                const SizedBox(height: 40),
                CustomButton(
                  buttonText: 'Continue',
                  isEnable: controller.isEnabled.value,
                  func: () async {
                    await controller.storeUserDetails(context,
                        createUserModel: FillProfileModel(
                          id: controller.currentUser!.uid,
                          fullName: controller.fullNameController.text.trim(),
                          userName: controller.userNameController.text.trim(),
                          imgUrl: controller.image.value,
                          dob: controller.dateOfBirth.value,
                          emailAddress:
                              controller.fillYourEmailAddress.text.trim(),
                          phoneNumber: controller.phoneController.text.trim(),
                          role: controller.roleController.text.trim(),
                        ),
                        controller: controller);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
