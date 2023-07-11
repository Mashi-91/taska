import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/utils.dart';

Widget topSection() {
  return Center(
    child: Column(
      children: [
        const Text(
          "Let's you in",
          style: TextStyle(
              fontSize: 34, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: Get.height * 0.10),
        outlineButton(
            imgPath: 'Google-icon.png',
            title: 'Continue with Google',
            onTap: () {}),
        outlineButton(
            imgPath: 'Twitter-icon.png',
            title: 'Continue with Twitter',
            onTap: () {}),
        outlineButton(
            imgPath: 'Apple-icon.png',
            title: 'Continue with Apple',
            onTap: () {}),
      ],
    ),
  );
}

Widget bottomSection({required VoidCallback signWithPass}) {
  return Column(
    children: [
      Padding(
        padding: EdgeInsets.only(top: Get.height * 0.03),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 140,
              height: 1,
              color: Colors.grey.withOpacity(0.4),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'or',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.6)),
              ),
            ),
            Container(
              width: 140,
              height: 1,
              color: Colors.grey.withOpacity(0.4),
            )
          ],
        ),
      ),
      SizedBox(height: Get.height * 0.05),
      CustomButton(
        isEnable: true,
        buttonText: "Sign in with password",
        func: signWithPass,
        width: 324,
        height: 50,
      ),
    ],
  );
}

Widget outlineButton(
    {required String imgPath, required String title, required Function onTap}) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    width: 324,
    height: 56,
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey.withOpacity(0.4)),
      borderRadius: BorderRadius.circular(12),
    ),
    child: InkWell(
      onTap: () => onTap(),
      splashColor: Colors.grey.withOpacity(0.4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/icons/$imgPath',
            width: 25,
            height: 25,
          ),
          const SizedBox(
            width: 12,
          ),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    ),
  );
}
