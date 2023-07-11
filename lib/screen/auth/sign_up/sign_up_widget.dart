import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:taska/screen/auth/sign_up/controller.dart';

import '../../../constant/color.dart';

Widget topSection({required SignUpController controller}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(
          width: 250,
          child: Text(
            "Create your Account",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          )),
      const SizedBox(height: 40),
      TextFieldForSignUp(
          hintText: "Email",
          controller: controller.signUpEmailController,
          onChanged: (val) {
            if (GetUtils.isEmail(val)) {
              controller.isButtonEnable();
            }
          }),
      const SizedBox(height: 20),
      TextFieldForSignUp(
          hintText: "Password",
          onChanged: (val) {
            controller.isButtonEnable();
          },
          controller: controller.signUpPasswordController,
          isPass: true,
          obsecure: controller.hidePassword.value,
          suffixIcon: GestureDetector(
            onTap: controller.showPassword,
            child: controller.hidePassword.value
                ? const Icon(Icons.visibility_off, color: Colors.grey, size: 20)
                : const Icon(Icons.visibility, color: Colors.grey, size: 20),
          )),
    ],
  );
}

Widget bottomSection() {
  return Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 1,
            color: Colors.grey.withOpacity(0.4),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'or continue with',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Colors.black.withOpacity(0.6)),
            ),
          ),
          Container(
            width: 120,
            height: 1,
            color: Colors.grey.withOpacity(0.4),
          ),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          smallOutlineButton(imgPath: "Twitter-icon.png", onTap: () {}),
          smallOutlineButton(imgPath: "Google-icon.png", onTap: () {}),
          smallOutlineButton(imgPath: "Apple-icon.png", onTap: () {}),
        ],
      ),
    ],
  );
}

Widget TextFieldForSignUp({
  required String hintText,
  bool isPass = false,
  Widget? suffixIcon,
  bool obsecure = false,
  Function(String)? onChanged,
  required TextEditingController controller,
}) {
  return TextFormField(
    controller: controller,
    obscureText: obsecure,
    onChanged: (val) => onChanged!(val),
    decoration: InputDecoration(
      hintText: hintText,
      prefixIcon: isPass
          ? const Icon(Icons.lock, size: 20, color: Colors.grey)
          : const Icon(Icons.email, size: 20, color: Colors.grey),
      suffixIcon: isPass ? suffixIcon : null,
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
      fillColor: Colors.grey.withOpacity(0.2),
    ),
  );
}

Widget smallOutlineButton({required String imgPath, required Function onTap}) {
  return GestureDetector(
    onTap: () => onTap(),
    child: Container(
      width: 84,
      height: 54,
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.only(top: Get.height * 0.04, right: Get.width * 0.03),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2))),
      child: Image.asset(
        "assets/icons/$imgPath",
        width: 10,
        height: 10,
      ),
    ),
  );
}
