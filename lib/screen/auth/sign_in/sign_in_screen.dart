import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/constant/global_function.dart';
import 'package:taska/constant/snackBar.dart';
import 'package:taska/screen/auth/sign_in/sign_in_widget.dart';

import '../../../constant/utils.dart';
import 'controller.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});

  final controller = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
      ),
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
                  buttonText: 'Sign in',
                  isEnable: controller.isSignButtonEnable.value,
                  func: () {
                    controller.signInUserWithEmailAndPass(context,
                        email: controller.signInEmailController.text.trim(),
                        password:
                            controller.signInPasswordController.text.trim());
                  },
                ),
                SizedBox(height: Get.height * 0.02),
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/ForgotPassword');
                  },
                  child: const Text(
                    "Forgot the password?",
                    style: TextStyle(color: primaryColor),
                  ),
                ),
                SizedBox(height: Get.height * 0.06),
                bottomSection(),
                SizedBox(height: Get.height * 0.06),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account? ",
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
