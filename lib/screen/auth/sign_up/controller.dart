import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:taska/screen/global_controller.dart';

class SignUpController extends GlobalController {
  //<<<<<<<<<<<< Controller >>>>>>>>>>>>>>>>
  late final TextEditingController signUpEmailController;
  late final TextEditingController signUpPasswordController;

  //<<<<<<<<<<<<<< variable for Storing data >>>>>>>>>>>>>>>>>>
  var hidePassword = true.obs;
  var isSignUpButtonEnable = false.obs;

  @override
  void onInit() {
    signUpEmailController = TextEditingController();
    signUpPasswordController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    signUpPasswordController.dispose();
    signUpEmailController.dispose();
    super.dispose();
  }

  // <<<<<<<<<<<<<<<< Toggle Functions & set Values >>>>>>>>>>>>>>>>>>
  showPassword() {
    hidePassword.value = !hidePassword.value;
  }

  bool isButtonEnable() {
    if (signUpEmailController.text.isNotEmpty &&
        signUpPasswordController.text.isNotEmpty) {
      isSignUpButtonEnable.value = true;
    } else {
      isSignUpButtonEnable.value = false;
    }
    return isSignUpButtonEnable.value;
  }
}
