import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taska/constant/utils.dart';
import 'package:taska/screen/home/widget.dart';

import '../../constant/color.dart';
import 'controller.dart';

class HomeNavigationController extends StatelessWidget {
  const HomeNavigationController({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Obx(
      () => Scaffold(
        body: controller.pages[controller.currentIndex.value],
        floatingActionButton: taskButton(
          onTap: () {
            Get.bottomSheet(
              customBottomSheet(controller),
            );
          },
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: customBottomNavigationBar(
          onTap: (val) => controller.isActive(val),
          currentIndex: controller.currentIndex.value,
        ),
      ),
    );
  }
}
