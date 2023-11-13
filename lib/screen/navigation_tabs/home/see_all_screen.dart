import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/constant/routes.dart';
import 'package:taska/constant/utils.dart';
import 'package:taska/screen/navigation_tabs/controller.dart';
import 'package:taska/screen/navigation_tabs/home/widget.dart';

import '../project/widget.dart';

class SeeAll extends StatelessWidget {
  const SeeAll({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Obx(
      () => Scaffold(
        appBar: customAppbar(title: 'Recent Project', actions: [
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
                    color: primaryColor,
                  ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () => controller.isCoverFunc(),
            child: !controller.isCover.value
                ? SvgToIcon(
                    iconName: 'project-regular-icon',
                    color: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                  )
                : SvgToIcon(
                    iconName: 'project-filled-icon',
                    // color: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                    color: primaryColor, size: 40),
              );
            }
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: data?.length ?? 0,
                itemBuilder: (context, i) {
                  if (data == null || data.isEmpty) {
                    return const Center(child: Text('No Data Found'));
                  }

                  final projects = data?[i].data();
                  if (projects == null) {
                    return const SizedBox
                        .shrink(); // or handle the case when projects is null
                  }

                  final title = projects['title'] ?? '';
                  final tag = projects['title'];

                  return controller.isCover.value
                      ? Material(
                          child: Hero(
                            tag: tag,
                            child: projectCardWithoutImg(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              title: title,
                              subTitle: 'subTitle',
                              onTapOption: () => Get.toNamed(projectDetail,
                                  arguments: data[i].data()),
                              timeLeft: '1',
                              totalTask: data!.length.toString(),
                              dateLeft: '',
                              leftTask: '',
                            ),
                          ),
                        )
                      : Material(
                          child: Hero(
                            tag: tag,
                            child: projectCardWithImg(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              backGroundImg: projects['cover'] != '' &&
                                      projects['cover'] != null
                                  ? projects['cover']
                                  : 'https://armysportsinstitute.com/wp-content/themes/armysports/images/noimg.png',
                              title: title,
                              subTitle: 'subTitle',
                              onTapOption: () => Get.toNamed(projectDetail,
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
