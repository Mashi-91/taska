import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:taska/screen/forgot_password/controller.dart';
import 'package:taska/screen/forgot_password/widget.dart';

import '../../constant/utils.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgotPasswordController());
    return Scaffold(
      appBar: customAppbar(title: "Forgot Password", isGoBack: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04)
              .copyWith(bottom: Get.height * 0.04),
          child: Column(
            children: [
              topSection(),
              const SizedBox(height: 20),
              TextFormField(
                onChanged: (val) => controller.isForgotPasswordButtonFunc(),
                controller: controller.forgotEmailController,
                decoration: InputDecoration(
                  hintText: 'email',
                  prefixIcon:
                      const Icon(Icons.email, size: 20, color: Colors.grey),
                  hintStyle: TextStyle(color: Colors.grey.withOpacity(0.7)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.1),
                        width: 2,
                      )),
                  filled: true,
                  fillColor: Colors.grey.withOpacity(0.2),
                ),
              ),
              const SizedBox(height: 30),
              CustomButton(
                buttonText: "Continue",
                isEnable: controller.isForgotPasswordButtonEnable.value,
                func: () {
                  controller.resetPasswordWithEmail(
                      resetEmail: controller.forgotEmailController.text.trim());
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
