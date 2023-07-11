import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taska/screen/auth/sign_up/sign_up_screen.dart';
import 'package:taska/screen/auth/widget/signin_signup_widget.dart';

import '../../constant/color.dart';

class SignInSignUp extends StatelessWidget {
  const SignInSignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: Get.height * 0.2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            topSection(),
            bottomSection(
              signWithPass: () {
                Get.toNamed('/SignIn');
              },
            ),
            SizedBox(height: Get.height * 0.1),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? ",
                    style: TextStyle(
                      color: Colors.grey.withOpacity(0.6),
                    )),
                const SizedBox(width: 4),
                InkWell(
                  onTap: () {
                    Get.toNamed('/SignUp');
                  },
                  child: const Text("Sign up",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      )),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
