import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taska/screen/global_controller.dart';

class SignInController extends GlobalController {
  // <<<<<<<<<<<<<<<<<<<<<<<<< Controllers >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  late final TextEditingController signInEmailController;
  late final TextEditingController signInPasswordController;

  final signInFormKey = GlobalKey<FormState>();

  Rx<bool> hidePassword = true.obs;
  var isSignButtonEnable = false.obs;

  @override
  void onInit() {
    signInEmailController = TextEditingController();
    signInPasswordController = TextEditingController();

    super.onInit();
  }

  @override
  void dispose() {
    signInEmailController.dispose();
    signInPasswordController.dispose();
    super.dispose();
  }

  // <<<<<<<<<<<<<<<<< Functions >>>>>>>>>>>>>>>>>>>>>>>
  void showPassword() {
    hidePassword.value = !hidePassword.value;
  }

  bool isSignInButtonFunc() {
    if (GetUtils.isEmail(signInEmailController.text) &&
        GetUtils.isLengthGreaterThan(signInPasswordController.text, 6)) {
      isSignButtonEnable.value = true;
    } else {
      isSignButtonEnable.value = false;
    }
    return isSignButtonEnable.value;
  }
}
