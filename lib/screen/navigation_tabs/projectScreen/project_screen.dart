import 'dart:developer';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
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

class ProjectScreen extends StatelessWidget {
  const ProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: Utils.customAppbarForProjectScreen(
          title: 'My Project',
          actions: [
            InkWell(
              splashColor: Colors.transparent,
              onTap: () => controller.isCoverFunc(),
              child: const Icon(
                FluentIcons.search_32_regular,
                size: 23,
              ),
            ),
            SizedBox(
              width: Get.width * 0.03,
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: ButtonsTabBar(
              backgroundColor: ColorsUtil.primaryColor,
              contentPadding:
              EdgeInsets.symmetric(horizontal: Get.width * 0.06),
              onTap: (val) {
                log(val.toString());
              },
              unselectedBorderColor: ColorsUtil.primaryColor,
              borderColor: ColorsUtil.primaryColor,
              borderWidth: 2,
              radius: 20,
              unselectedBackgroundColor: Colors.transparent,
              unselectedLabelStyle:
              const TextStyle(color: ColorsUtil.primaryColor),
              labelStyle: const TextStyle(color: ColorsUtil.white),
              tabs: const [
                Tab(
                  text: 'To-Do',
                ),
                Tab(
                  text: 'In Progress',
                ),
                Tab(
                  text: 'Completed',
                ),
                Tab(
                  text: 'Archived',
                ),
              ],
              // controller: _tabController,
            ),
          ),
        ),
        body: StreamBuilder(
          stream: controller.getAllProjects(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.stretchedDots(
                    color: ColorsUtil.primaryColor, size: 40),
              );
            }
            if (snapshot.hasData) {
              final List<ProjectModel> listProject =
              ProjectModel.fromDocumentSnapshots(snapshot.data).toList();
              return ListView.builder(
                itemCount: listProject.length ?? 0,
                itemBuilder: (context, i) {
                  final projects = listProject[i];
                  final title = projects.title;
                  final List<TaskModel> totalTasks = controller.homeScreenTask;
                  final List<TaskModel> getProjectIdBasedTask = controller
                      .getTotalTasks(totalTasks, projects.id)
                      .toList();

                  return controller.isCover.value
                      ? Material(
                    child: Hero(
                      tag: title,
                      child: projectCardWithoutImg(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        title: title,
                        subTitle: 'subTitle',
                        onTapOption: () => Get.toNamed(
                            AppRoutes.projectDetail,
                            arguments: projects),
                        timeLeft: '1',
                        totalTask: totalTasks.length.toString(),
                        dateLeft: '',
                        leftTask: '',
                      ),
                    ),
                  )
                      : Material(
                    child: Hero(
                      tag: title,
                      child: projectCardWithImg(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        imageProvider: projects.cover != ''
                            ? CachedNetworkImageProvider(
                            Uri.parse(projects.cover.toString()).toString())
                            : AssetImage(projects.backgroundCover.toString()),
                        title: title,
                        subTitle: 'subTitle',
                        onTapOption: () => Get.toNamed(
                            AppRoutes.projectDetail,
                            arguments: projects),
                        totalTask: getProjectIdBasedTask.length.toString(),
                        deadLine: projects.projectDeadLine.toString(),
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
      ),
    );
  }

// Widget bodySection(){
//   return
// }
}
