import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/screen/navigation_tabs/home/homeController.dart';
import 'package:taska/screen/navigation_tabs/project/widget.dart';

import '../../../../../constant/utils.dart';

class ChangeCover extends StatelessWidget {
  const ChangeCover({Key? key});

  @override
  Widget build(BuildContext context) {
    final data = Get.arguments ?? '';
    final controller = Get.find<HomeController>();

    return Scaffold(
      appBar: Utils.customAppbar(title: 'Add Cover', isGoBack: true, actions: [
        IconButton(
          onPressed: () async {},
          icon: const Icon(FluentIcons.edit_48_regular),
        )
      ]),
      body: GetBuilder<HomeController>(
        builder: (_) => Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Get.width * 0.06, vertical: Get.height * 0.04),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: controller.photo != null
                          ? FileImage(controller.photo!) // Show picked image
                          : data['cover'] != ''
                              ? CachedNetworkImageProvider(
                                  Uri.parse(data['cover']).toString(),
                                ) // Show cover image
                              : AssetImage(data['backgroundCover'])
                                  as ImageProvider,
                      // Show background cover
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Get.height * 0.04),
              Utils.buildCustomButton(
                buttonText: 'Add Cover',
                func: () {
                  customBottomSheet(controller, context,
                      title: 'Add Cover',
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          customIconButton(
                            iconButtonName: 'Camera',
                            iconData: FluentIcons.camera_28_filled,
                            onTap: () async {
                              await controller.imagePickerFromCamera(
                                  currentProjectId: data['id']);
                              Get.back();
                            },
                          ),
                          customIconButton(
                            iconButtonName: 'Gallery',
                            iconData: FluentIcons.image_16_filled,
                            onTap: () async {
                              await controller.imagePickerFromGallery();
                              Get.back();
                            },
                          ),
                        ],
                      ));
                },
                isEnable: true,
                width: double.infinity,
              )
            ],
          ),
        ),
      ),
    );
  }
}
