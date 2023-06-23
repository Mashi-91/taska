import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
  final TextEditingController signInEmailController = TextEditingController();
  final TextEditingController signInPasswordController =
      TextEditingController();

  var hidePassword = true.obs;
  var rememberMe = false.obs;

  showPassword() {
    hidePassword.value = !hidePassword.value;
  }

  rememberMeFunc() {
    rememberMe.value = !rememberMe.value;
  }
}
