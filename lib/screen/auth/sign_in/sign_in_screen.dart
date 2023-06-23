import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/screen/auth/sign_in/sign_in_widget.dart';

import '../../../widget/custom_button.dart';
import 'controller.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                SizedBox(height: Get.height * 0.02),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                        onTap: () {
                          controller.rememberMeFunc();
                        },
                        child: controller.rememberMe.value
                            ? Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    borderRadius: BorderRadius.circular(4)),
                                child: const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                ))
                            : Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(color: primaryColor)),
                              )),
                    SizedBox(width: Get.width * 0.02),
                    const Text(
                      'Remember me',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
                SizedBox(height: Get.height * 0.03),
                CustomButton(
                  buttonText: 'Sign in',
                  func: () {},
                ),
                SizedBox(height: Get.height * 0.02),
                const Text(
                  "Forgot the password?",
                  style: TextStyle(color: primaryColor),
                ),
                SizedBox(height: Get.height * 0.06),
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
                        Get.back();
                      },
                      child: const Text("Sign up",
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
