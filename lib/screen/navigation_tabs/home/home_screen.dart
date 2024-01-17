import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/model/project_model.dart';
import 'package:taska/model/task_model.dart';
import 'package:taska/routes/appRoutes.dart';
import 'package:taska/screen/navigation_tabs/home/widget.dart';

import '../../../constant/utils.dart';
import 'homeController.dart';
import '../project/widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    return Scaffold(
      appBar: AppBar(
        title: homeAppBar(
          action: const Icon(
            FluentIcons.alert_12_filled,
            color: ColorsUtil.primaryColor,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18).copyWith(top: 12),
              child: Column(
                children: [
                  Utils.buildCustomTextField(
                    controller: controller.searchController,
                    hintText: 'Search',
                    prefixIcon: const Icon(
                      FluentIcons.search_20_filled,
                      color: ColorsUtil.lightGrey,
                    ),
                    suffixIcon: const Icon(
                      FluentIcons.options_16_regular,
                      color: ColorsUtil.primaryColor,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Recent Project',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      InkWell(
                        onTap: () => Get.toNamed(AppRoutes.seeAllScreen),
                        child: const Text(
                          'See All',
                          style: TextStyle(
                              color: ColorsUtil.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: Get.height * 0.36,
              child: StreamBuilder(
                stream: controller.getAllProjects(),
                builder: (context, projectSnapshot) {
                  if (projectSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: LoadingAnimationWidget.stretchedDots(
                        color: ColorsUtil.primaryColor,
                        size: 20,
                      ),
                    );
                  } else if (projectSnapshot.hasData) {
                    final List<ProjectModel> projects =
                        ProjectModel.fromDocumentSnapshots(
                            projectSnapshot.data!);

                    return projectListWidget(projects);
                  } else {
                    return Center(
                      child: Text('Error: ${projectSnapshot.error}'),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Today Task",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {},
                        child: const Text(
                          'See All',
                          style: TextStyle(
                              color: ColorsUtil.primaryColor,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: Get.height * 0.3,
                    child: StreamBuilder(
                      stream: controller.getAllTasksAsStreamOnHomeScreen(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: LoadingAnimationWidget.stretchedDots(
                              color: ColorsUtil.primaryColor,
                              size: 20,
                            ),
                          );
                        } else if (snapshot.hasData) {
                          final List<TaskModel> taskList = snapshot.data!.docs
                              .map((e) => TaskModel.fromDocumentSnapshot(e))
                              .toList();

                          // Task is not done
                          final List<TaskModel> notDoneTasks =
                              controller.filterNotDoneTasks(taskList);

                          // Today Task
                          final List<TaskModel> todayTasks =
                              controller.filterTodayTasks(notDoneTasks);

                          // store in controller
                          controller.setHomeTaskList(taskList);
                          if (todayTasks.isNotEmpty) {
                            return ListView.builder(
                              itemCount: todayTasks.length,
                              itemBuilder: (_, index) {
                                final task = todayTasks[index];
                                return GetBuilder<HomeController>(
                                  builder: (_) {
                                    return taskTile(
                                      taskModel: TaskModel(
                                        title: task.title,
                                        isDone: task.isDone,
                                        projectId: '',
                                        time: task.time,
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          } else {
                            return SvgPicture.asset(
                                'assets/images/Empty-img.svg');
                          }
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          return const SizedBox(); // Handle other cases
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget projectListWidget(List<ProjectModel> projects) {
    final controller = Get.find<HomeController>();
    return CarouselSlider.builder(
      itemCount: projects.take(2).length,
      itemBuilder: (_, i, val) {
        final project = projects[i];
        final List<TaskModel> totalTasks = controller.homeScreenTask;
        final List<TaskModel> getProjectIdBasedTask =
            controller.getTotalTasks(totalTasks, projects[i].id).toList();

        return projectCardWithImg(
          imageProvider: project.cover != ''
              ? CachedNetworkImageProvider(Uri.parse(project.cover!).toString())
              : AssetImage(project.backgroundCover.toString()),
          title: project.title,
          subTitle: 'subTitle',
          onTapOption: () {
            Get.toNamed(AppRoutes.projectDetail, arguments: project);
          },
          leftTask: controller
              .filterNotDoneTasks(getProjectIdBasedTask)
              .length
              .toString(),
          totalTask: getProjectIdBasedTask.length.toString(),
          deadLine: project.projectDeadLine.toString(),
          taskModel: getProjectIdBasedTask, // Pass tasks to projectCardWithImg
        );
      },
      options: CarouselOptions(
        height: Get.height * 0.34,
        viewportFraction: 0.93,
        enableInfiniteScroll: false,
        enlargeCenterPage: true,
        disableCenter: false,
      ),
    );
  }
}
