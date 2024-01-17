import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/constant/utils.dart';
import 'package:taska/model/project_model.dart';
import 'package:taska/screen/navigation_tabs/home/homeController.dart';
import 'package:taska/screen/navigation_tabs/project/projectDetailScreen/projectDetailController.dart';
import 'package:taska/screen/navigation_tabs/project/widget.dart';
import 'package:taska/model/task_model.dart';

class ProjectDetailLogic {
  static Widget buildHeroSection(ProjectModel data) {
    final homeController = Get.find<HomeController>();
    final controller = Get.find<ProjectDetailController>();

    return Flexible(
      child: Hero(
        tag: homeController.isCover.value ? '' : data.title,
        child: Material(
          child: FutureBuilder(
            future: data.cover != ''
                ? controller.getCoverImageUrl(data.id)
                : Future.delayed(const Duration(milliseconds: 100)),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: LoadingAnimationWidget.stretchedDots(
                    color: ColorsUtil.primaryColor,
                    size: 50,
                  ),
                );
              }

              if (snapshot.hasData && snapshot.data != null) {
                final cover = data.cover;

                return Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: controller.photo != null
                          ? FileImage(controller.photo!) // Show picked image
                          : cover != ''
                              ? CachedNetworkImageProvider(
                                  Uri.parse(cover!).toString(),
                                ) // Show cover image
                              : AssetImage(data.backgroundCover.toString())
                                  as ImageProvider,
                      // Show background cover
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }

              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(data.backgroundCover.toString()),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  static Widget buildProjectDetailSection({
    required ProjectModel project,
    required BuildContext context,
  }) {
    final controller = Get.find<ProjectDetailController>();
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04)
          .copyWith(top: Get.height * 0.02),
      alignment: Alignment.topLeft,
      color: Colors.white,
      child: GetBuilder<ProjectDetailController>(
        builder: (_) {
          return Column(
            children: [
              StreamBuilder(
                stream: controller.getAllProjectAsStream(project.id),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Show loading indicator when waiting for data
                    return Center(
                      child: LoadingAnimationWidget.stretchedDots(
                        color: ColorsUtil.primaryColor,
                        size: 50,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final ProjectModel projectFromStream =
                        ProjectModel.fromJson(snapshot.data!.data()!);

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          projectFromStream.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                        ),
                        SizedBox(height: Get.height * 0.02),
                        const Text(
                          'Add Description',
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorsUtil.lightBlack,
                          ),
                        ),
                        const SizedBox(height: 12),
                        projectFromStream.projectDeadLine == '' ||
                                projectFromStream.projectDeadLine == null
                            ? Utils.buildCustomOutlineButton(
                                width: double.infinity,
                                height: 46,
                                addIcon: false,
                                isEnable: true,
                                borderWidth: 2,
                                buttonText: 'Set Deadline Project',
                                func: () {
                                  customBottomSheet(
                                    controller,
                                    context,
                                    bottomPadding: 0,
                                    title: 'Set Deadline Project',
                                    content: Container(
                                      decoration: BoxDecoration(
                                        color: ColorsUtil.lightGrey
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: SfDateRangePicker(
                                        initialDisplayDate: DateTime.now(),
                                        minDate: DateTime.now(),
                                        selectionColor: ColorsUtil.primaryColor,
                                        todayHighlightColor:
                                            ColorsUtil.primaryColor,
                                        onSelectionChanged: (val) {
                                          if (val != null) {
                                            controller.setProjectDeadline(
                                              projectId: project.id,
                                              dateFromDatePicker: val.value,
                                            );
                                            Get.back();
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                              )
                            : buildProgressSection(
                                totalTask:
                                    controller.projectDetailScreenTask.length.toString(),
                                deadLine: projectFromStream.projectDeadLine
                                    .toString(),
                                taskList: controller.projectDetailScreenTask,
                              ),
                      ],
                    );
                  }
                  return const Text('No Data Available');
                },
              ),
              StreamBuilder(
                stream: controller.getAllTaskAsStream(project.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: LoadingAnimationWidget.stretchedDots(
                        color: ColorsUtil.primaryColor,
                        size: 40,
                      ),
                    );
                  }
                  final List<TaskModel> tasks = snapshot.data!.docs
                      .map((e) => TaskModel.fromDocumentSnapshot(e))
                      .toList();
                  controller.projectDetailScreenTask = tasks;
                  if (tasks.isNotEmpty) {
                    return ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: tasks.length,
                      itemBuilder: (context, i) {
                        final taskList = tasks[i];
                        return taskTitleTile(
                          task: TaskModel(
                            projectId: project.id,
                            title: taskList.title,
                            time: taskList.time,
                            isDone: taskList.isDone,
                          ),
                          onTap: () {},
                        );
                      },
                    );
                  } else {
                    return Center(
                      child: SvgPicture.asset(
                        'assets/images/Empty-img.svg',
                        height: 400,
                        alignment: Alignment.bottomCenter,
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
