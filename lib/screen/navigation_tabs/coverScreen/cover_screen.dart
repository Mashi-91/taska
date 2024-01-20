import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/constant/utils.dart';
import 'package:taska/model/project_model.dart';
import 'package:taska/model/task_model.dart';
import 'package:taska/routes/appRoutes.dart';
import 'package:taska/screen/navigation_tabs/home/homeController.dart';
import 'package:taska/screen/navigation_tabs/project/widget.dart';
import 'package:taska/screen/navigation_tabs/projectScreen/projectScreenController.dart';

class CoverScreen extends StatelessWidget {
  const CoverScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return Scaffold(
      appBar: Utils.customAppbarForProjectScreen(
        title: 'Cover',
      ),
      body: StreamBuilder(
        stream: controller.getAllProjects(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.stretchedDots(
                color: ColorsUtil.primaryColor,
                size: 40,
              ),
            );
          }
          if (snapshot.hasData) {
            final List<ProjectModel> projects =
                ProjectModel.fromDocumentSnapshots(snapshot.data).toList();

            return ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, i) {
                final listProject = projects[i];
                final title = listProject.title;
                final List<TaskModel> totalTasks = controller.homeScreenTask;
                final List<TaskModel> getProjectIdBasedTask = controller
                    .getTotalTasks(totalTasks, projects[i].id)
                    .toList();

                return Material(
                  child: Hero(
                    tag: title,
                    child: projectCardWithImg(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      imageProvider: listProject.cover != ''
                          ? CachedNetworkImageProvider(Uri.parse(listProject.cover!).toString())
                          : AssetImage(listProject.backgroundCover.toString()),
                      title: title,
                      subTitle: 'subTitle',
                      onTapOption: () => Get.toNamed(AppRoutes.projectDetail,
                          arguments: listProject),
                      totalTask: getProjectIdBasedTask.length.toString(),
                      deadLine: listProject.projectDeadLine.toString(),
                      taskModel: getProjectIdBasedTask,
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('No Data Found'));
        },
      ),
    );
  }
}
