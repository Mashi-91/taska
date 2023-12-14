import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/constant/utils.dart';
import 'package:taska/routes/appRoutes.dart';
import 'package:taska/screen/navigation_tabs/home/homeController.dart';
import 'package:taska/screen/navigation_tabs/home/widget.dart';

import '../project/widget.dart';

class SeeAll extends StatelessWidget {
  const SeeAll({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Obx(
      () => Scaffold(
        appBar: Utils.customAppbar(title: 'Recent Project', actions: [
          InkWell(
            splashColor: Colors.transparent,
            onTap: () => controller.isCoverFunc(),
            child: controller.isCover.value
                ? const Icon(
                    FluentIcons.image_16_regular,
                    size: 26,
                  )
                : const Icon(
                    FluentIcons.image_16_filled,
                    size: 26,
                    color: ColorsUtil.primaryColor,
                  ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () => controller.isCoverFunc(),
            child: !controller.isCover.value
                ? Utils.buildSvgToIcon(
                    iconName: 'project-regular-icon',
                    color: Colors.black,
                    height: 18,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  )
                : Utils.buildSvgToIcon(
                    iconName: 'project-filled-icon',
                    // color: Colors.black,
                    height: 18,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
          ),
        ]),
        body: StreamBuilder(
          stream: controller.getAllProjects(),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.stretchedDots(
                    color: ColorsUtil.primaryColor, size: 40),
              );
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: data?.length ?? 0,
                itemBuilder: (context, i) {
                  if (data == null || data.isEmpty) {
                    return const Center(child: Text('No Data Found'));
                  }
                  final projectData = data?[i].data();

                  if (projectData == null || projectData.isEmpty) {
                    return const SizedBox
                        .shrink(); // Handle the case when projectData is null or empty
                  }

                  final title = projectData['title'] ?? '';
                  final tag = title;
                  final cover = projectData['cover'] ?? '';

                  return controller.isCover.value
                      ? Material(
                          child: projectCardWithoutImg(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            title: title,
                            subTitle: 'subTitle',
                            onTapOption: () => Get.toNamed(
                                AppRoutes.projectDetail,
                                arguments: data[i].data()),
                            timeLeft: '1',
                            totalTask: data!.length.toString(),
                            dateLeft: '',
                            leftTask: '',
                          ),
                        )
                      : Material(
                          child: Hero(
                            tag: tag,
                            child: projectCardWithImg(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              imageProvider: projectData['cover'] != '' &&
                                      projectData['cover'] != null
                                  ? CachedNetworkImageProvider(
                                      Uri.parse(cover).toString())
                                  : AssetImage(projectData['backgroundCover']),
                              title: title,
                              subTitle: 'subTitle',
                              onTapOption: () => Get.toNamed(
                                  AppRoutes.projectDetail,
                                  arguments: data[i].data()),
                              leftTask: '1',
                              totalTask: '1',
                              dateLeft: '',
                              timeLeft: '',
                            ),
                          ),
                        );
                },
              );
            }
            return const Center(child: Text('No Data Found'));
          },
        ),
      ),
    );
  }
}
