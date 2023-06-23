import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SignUpController extends GetxController {
  final TextEditingController signUpEmailController = TextEditingController();
  final TextEditingController signUpPasswordController =
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
