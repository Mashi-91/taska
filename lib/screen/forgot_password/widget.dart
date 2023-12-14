import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/screen/forgot_password/controller.dart';

Widget topSection() {
  return Column(
    children: [
      Center(
        child: SizedBox(
          width: 250,
          height: 250,
          child: Image.asset(
            "assets/images/forgot-Password.png",
          ),
        ),
      ),
      const SizedBox(height: 24),
      const SizedBox(
        width: 200,
        child: Text(
          "Enter your email address for reset password!",
          style: TextStyle(height: 1.2, color: ColorsUtil.lightBlack),
          textAlign: TextAlign.center,
        ),
      )
    ],
  );
}
