import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taska/model/project_model.dart';
import 'package:taska/screen/navigation_tabs/project/createProjectScreen/createProjectController.dart';
import 'package:taska/screen/navigation_tabs/project/widget.dart';

import '../../../../constant/utils.dart';

class AddCover extends StatelessWidget {
  const AddCover({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CreateProjectController>();
    final ProjectModel data = controller.projectData;

    return Scaffold(
      appBar: Utils.customAppbar(title: 'Add Cover', isGoBack: true, actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(FluentIcons.edit_48_regular),
        )
      ]),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.06, vertical: Get.height * 0.04),
        child: Column(
          children: [
            GetBuilder<CreateProjectController>(
              builder: (_) => Expanded(
                  child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: controller.photo != null
                        ? FileImage(controller.photo!) // Show picked image
                        : data.cover != ''
                            ? CachedNetworkImageProvider(
                                Uri.parse(data.cover.toString()).toString(),
                              ) // Show cover image
                            : AssetImage(data.backgroundCover.toString())
                                as ImageProvider,
                    // Show background cover
                    fit: BoxFit.cover,
                  ),
                ),
              )),
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
                            await controller.imagePickerFromCamera();
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
    );
  }
}
