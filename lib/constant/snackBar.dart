import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackBar {
  static snackBarMsg(
      {required String title, required String msg, bool isError = false, SnackPosition? snackPosition = SnackPosition.BOTTOM}) {
    Get.snackbar(title, msg,
        snackPosition: snackPosition,
        backgroundColor: isError ? Colors.red : null,
        margin:
            const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 20));
  }
}
