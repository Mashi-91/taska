import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:taska/screen/global_controller.dart';

class ForgotPasswordController extends GlobalController {
  //<<<<<<<<<<<<<<< Controller >>>>>>>>>>>>>>>>>>>>>>>>
  late final TextEditingController forgotEmailController;

  var isForgotPasswordButtonEnable = false.obs;

  @override
  void onInit() {
    forgotEmailController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    forgotEmailController.dispose();
    super.dispose();
  }

  // <<<<<<<<<<<<<<<<<<<<< Functions >>>>>>>>>>>>>>>>>>>>>>>
  bool isForgotPasswordButtonFunc() {
    if (GetUtils.isEmail(forgotEmailController.text)) {
      isForgotPasswordButtonEnable.value = true;
    } else {
      isForgotPasswordButtonEnable.value = false;
    }
    return isForgotPasswordButtonEnable.value;
  }
}
