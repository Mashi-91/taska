import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taska/constant/utils.dart';
import 'package:taska/screen/navigation_tabs/project/widget.dart';

import 'controller.dart';
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
        floatingActionButton: CustomFloatingButton(
          onTap: () {
            customBottomSheet(controller, context,
                title: 'New Project',
                content: Column(
                  children: [
                    customTextField(
                        hintText: 'Project Name',
                        horizontalPadding: 12,
                        verticalPadding: 18,
                        controller: controller.projectNameController),
                    const SizedBox(height: 18),
                    CustomButton(
                      buttonText: 'Create Project',
                      func: () async {
                        // await controller.photo?.delete();
                        await controller.storeProject(
                          title: controller.projectNameController.text,
                        );
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
