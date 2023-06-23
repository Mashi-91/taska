
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  final PageController pageController = PageController(initialPage: 0);
  Rx<int> currentIndex = 0.obs;

  void onPageChange(var val) {
    currentIndex.value = val;
  }

  void nextButtonFunc(BuildContext context) {
    if (currentIndex.value >= 2) {
      Get.offNamedUntil('/', (route) => false);
    }
    pageController.nextPage(
        duration: const Duration(microseconds: 800), curve: Curves.bounceIn);
  }

  void skipButtonFunc() {
    Get.offNamedUntil('/', (route) => false);
  }
}
