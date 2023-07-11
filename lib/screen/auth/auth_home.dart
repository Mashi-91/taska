import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taska/screen/auth/sign_in_sign_up.dart';
import 'package:taska/screen/home/home_navigation_controller.dart';

import '../global_controller.dart';
import '../home/home_screen.dart';

class AuthHome extends StatelessWidget {
  const AuthHome({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GlobalController());
    return StreamBuilder(
      stream: controller.firebaseAuth.authStateChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          return HomeNavigationController();
        } else {
          return const SignInSignUp();
        }
      },
    );
  }
}
