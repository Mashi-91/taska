import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taska/screen/auth/sign_in_sign_up.dart';

import '../global_controller.dart';
import '../navigation_tabs/navigation_controller.dart';

class AuthHome extends StatelessWidget {
  const AuthHome({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GlobalController());
    return StreamBuilder(
      stream: controller.firebaseAuth.authStateChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return const HomeNavigationController();
        } else {
          return const SignInSignUp();
        }
      },
    );
  }
}
