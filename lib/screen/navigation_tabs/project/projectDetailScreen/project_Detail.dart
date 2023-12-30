import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:taska/constant/global_function.dart';
import 'package:taska/model/project_model.dart';
import 'package:taska/routes/appRoutes.dart';
import 'package:taska/screen/navigation_tabs/home/homeController.dart';
import 'package:taska/screen/navigation_tabs/project/projectDetailScreen/projectDetailController.dart';
import 'package:taska/screen/navigation_tabs/project/widget.dart';

import '../../../../constant/color.dart';
import '../../../../constant/utils.dart';
import '../../../../model/task_model.dart';

class ProjectDetail extends StatelessWidget {
  const ProjectDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final ProjectModel data = Get.arguments ?? '';
    final controller = Get.put(ProjectDetailController());
    final homeController = Get.find<HomeController>();
    return Scaffold(
      appBar: Utils.customAppbar(
        backgroundColor: Colors.transparent,
        isGoBack: true,
        color: Colors.white,
        actions: [
          Utils.iconButton(
            onTap: () {},
            icon: const Icon(
              Icons.search_outlined,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          Utils.buildPopMenuButton(context, color: Colors.white,
              onSelected: (val) {
            if (val == ProjectDetailOptions.DeleteProject) {
              customBottomSheet(
                controller,
                context,
                title: 'Delete Project',
                titleColor: Colors.red,
                content: Column(
                  children: [
                    const SizedBox(
                      width: 260,
                      child: Text(
                        'Are you sure want to delete the project?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 0.4,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Utils.buildCustomButton(
                        buttonText: 'Yes, Delete',
                        func: () async {
                          controller
                              .deleteProject(uid: data.id, context: context)
                              .then((value) => Get.back());
                        },
                        isEnable: true,
                        width: double.infinity),
                    const SizedBox(height: 12),
                    Utils.buildCustomButton(
                      buttonText: 'Cancel',
                      func: () => Get.back(),
                      isSkip: true,
                      isEnable: true,
                      width: double.infinity,
                    )
                  ],
                ),
              );
            } else if (val == ProjectDetailOptions.ChangeCover) {
              Get.toNamed(AppRoutes.changeCover, arguments: data);
            } else if (val == ProjectDetailOptions.ChangeColor) {
              Get.toNamed(AppRoutes.changeColor, arguments: data);
            }
          },
              // **************** PopMenuItems *****************

              popMenuItem: [
                Utils.buildPopMenuItem(
                  title: 'Change Cover',
                  value: ProjectDetailOptions.ChangeCover,
                  iconData: FluentIcons.image_16_regular,
                ),
                /*
            buildPopMenuItem(
              title: 'Change Logo',
              value: ProjectDetailOptions.ChangeLogo,
              iconData: 'change-logo-icon',
              isSvgIcon: true,
            ),*/
                Utils.buildPopMenuItem(
                  title: 'Change Color',
                  value: ProjectDetailOptions.ChangeColor,
                  iconData: Icons.remove_red_eye_outlined,
                ),
                Utils.buildPopMenuItem(
                  title: 'Edit Project',
                  value: ProjectDetailOptions.EditProject,
                  iconData: FluentIcons.edit_16_regular,
                ),
                Utils.buildPopMenuItem(
                    title: 'Delete Project',
                    value: ProjectDetailOptions.DeleteProject,
                    iconData: FluentIcons.delete_12_regular,
                    color: Colors.red,
                    isDivider: false),
              ])
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GetBuilder<ProjectDetailController>(
        builder: (context) => Column(
          children: [
            Flexible(
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
                                  ? FileImage(
                                      controller.photo!) // Show picked image
                                  : cover != ''
                                      ? CachedNetworkImageProvider(
                                          Uri.parse(cover!).toString(),
                                        ) // Show cover image
                                      : AssetImage(
                                              data.backgroundCover.toString())
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
            ),
            Flexible(
              flex: 3,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04)
                    .copyWith(top: Get.height * 0.02),
                alignment: Alignment.topLeft,
                color: Colors.white,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: controller.getAllTaskAsStream(data.id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.stretchedDots(
                          color: ColorsUtil.primaryColor,
                          size: 40,
                        ),
                      );
                    }

                    final taskDocs = snapshot.data?.docs ?? [];

                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.title,
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.02),
                          // Adjust as needed
                          const Text(
                            'Add Description',
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorsUtil.lightBlack,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Adjust as needed
                          GetBuilder<ProjectDetailController>(
                            builder: (_) => Column(
                              children: [
                                data.projectDeadLine == '' ||
                                        data.projectDeadLine == null
                                        // controller.memoryDateTime == null
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
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: SfDateRangePicker(
                                                initialDisplayDate:
                                                    DateTime.now(),
                                                minDate: DateTime.now(),
                                                onSelectionChanged: (val) {
                                                  if (val != null) {
                                                    controller
                                                        .setProjectDeadline(
                                                      projectId: data.id,
                                                      dateFromDatePicker:
                                                          val.value,
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
                                        leftTask: '1',
                                        totalTask: taskDocs.length.toString(),
                                        deadLine: data.projectDeadLine == ''
                                            ? data.projectDeadLine.toString()
                                            : controller.memoryDateTime
                                                .toString(),
                                      ),
                              ],
                            ),
                          ),
                          SizedBox(height: Get.height * 0.06),
                          if (taskDocs.isNotEmpty)
                            ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              itemCount: taskDocs.length,
                              itemBuilder: (context, i) {
                                final data =
                                    TaskModel.fromDocumentSnapshot(taskDocs[i]);
                                return taskTitleTile(
                                  title: data.title,
                                  time: data.time,
                                );
                              },
                            )
                          else
                            Center(
                              child: SvgPicture.asset(
                                'assets/images/Empty-img.svg',
                                height: 400,
                                alignment: Alignment.bottomCenter,
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Utils.buildCustomFloatingButton(
        onTap: () {
          customBottomSheet(
            controller,
            context,
            title: 'Add New Task',
            content: Column(
              children: [
                Utils.buildCustomTextField(
                    hintText: 'Task Name',
                    horizontalPadding: 12,
                    verticalPadding: 18,
                    controller: controller.taskNameController),
                const SizedBox(height: 18),
                Utils.buildCustomButton(
                  buttonText: 'Create Task',
                  func: () async {
                    await controller.storeTask(
                      taskModel: TaskModel(
                        title: controller.taskNameController.text,
                        projectId: data.id,
                        isDone: false,
                        time: DateTime.now(),
                      ),
                    );
                  },
                  isEnable: true,
                  height: 62,
                  width: double.infinity,
                )
              ],
            ),
          );
        },
        bottom: 20,
        right: 18,
        width: 60,
        height: 60,
      ),
    );
  }
}
