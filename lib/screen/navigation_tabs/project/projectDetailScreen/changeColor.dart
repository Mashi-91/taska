import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/constant/global_function.dart';
import 'package:taska/screen/navigation_tabs/home/homeController.dart';
import 'package:taska/screen/navigation_tabs/project/createProjectScreen/createProjectController.dart';
import 'package:taska/screen/navigation_tabs/project/projectDetailScreen/projectDetailController.dart';
import 'package:taska/screen/navigation_tabs/project/widget.dart';

import '../../../../../constant/utils.dart';

class ChangeColor extends StatelessWidget {
  const ChangeColor({Key? key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments;
    final controller = Get.find<ProjectDetailController>();
    final color =
        GlobalFunction.convertHexToMaterialColor(data['projectColor']);
    // log(color.toString());

    log(controller.selectedColor.toString());
    // log(color.toString());
    return Scaffold(
      appBar: Utils.customAppbar(
        title: 'Set Color',
        isGoBack: true,
      ),
      body: GetBuilder<ProjectDetailController>(
        builder: (_) {
          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.06,
              vertical: Get.height * 0.04,
            ),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemCount: Utils.staticColors.length,
              itemBuilder: (context, index) {
                final isSelected = controller.selectedColor != null
                    ? controller.selectedColor == Utils.staticColors[index]
                    : Utils.staticColors[index].value == color?.value;

                return GestureDetector(
                  onTap: () {
                    dynamic selectedColor = Utils.staticColors[index];
                    // log(selectedColor.toString());
                    controller.setSelectedColor(selectedColor);
                    controller.updateColorInFirebase(data['id'], selectedColor);
                    // log(controller.selectedColor.toString());
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Utils.staticColors[index],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        margin: const EdgeInsets.all(8),
                      ),
                      if (isSelected)
                        Positioned(
                          right: 20,
                          top: 18,
                          child: Utils.customCheckBox(),
                        ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
