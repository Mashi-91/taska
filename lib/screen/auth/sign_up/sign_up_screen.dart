import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/screen/auth/sign_up/controller.dart';
import 'package:taska/screen/auth/sign_up/sign_up_widget.dart';
import 'package:taska/screen/fill_your_profile/controller.dart';

import '../../../constant/utils.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final controller = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(isGoBack: true),
      body: Obx(
        () => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14.0).copyWith(
            top: Get.height * 0.07,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                topSection(
                  controller: controller,
                ),
                SizedBox(height: Get.height * 0.03),
                CustomButton(
                  buttonText: 'Sign up',
                  isEnable: controller.isSignUpButtonEnable.value,
                  func: () {
                    controller.createEmailAndPassword(
                        controller.signUpEmailController.text.trim(),
                        controller.signUpPasswordController.text.trim());
                  },
                ),
                SizedBox(height: Get.height * 0.08),
                bottomSection(),
                SizedBox(height: Get.height * 0.06),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? ",
                        style: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                        )),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/SignIn');
                      },
                      child: const Text("Sign in",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
