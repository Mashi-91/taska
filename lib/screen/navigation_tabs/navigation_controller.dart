import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taska/constant/utils.dart';
import 'package:taska/screen/navigation_tabs/project/widget.dart';

import 'home/homeController.dart';
import 'home/widget.dart';

class HomeNavigationController extends StatelessWidget {
  const HomeNavigationController({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Obx(
      () => Scaffold(
        resizeToAvoidBottomInset: false,
        body: controller.pages[controller.currentIndex.value],
        floatingActionButton: Utils.buildCustomFloatingButton(
          onTap: () {
            // log(controller.notificationToken.toString());
            customBottomSheet(controller, context,
                title: 'New Project',
                content: Column(
                  children: [
                    Utils.buildCustomTextField(
                        hintText: 'Project Name',
                        horizontalPadding: 12,
                        verticalPadding: 18,
                        controller: controller.projectNameController),
                    const SizedBox(height: 18),
                    Utils.buildCustomButton(
                      buttonText: 'Create Project',
                      func: () async {
                        // await controller.photo?.delete();
                        await controller
                            .storeProject(
                              title: controller.projectNameController.text,
                            )
                            .then((value) => controller.clearProjectNameText());
                        // controller.getRandomImage();
                      },
                      isEnable: true,
                      height: 62,
                      width: double.infinity,
                    )
                  ],
                ));
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
