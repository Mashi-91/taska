import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/constant/global_function.dart';
import 'package:taska/constant/utils.dart';
import 'package:taska/model/task_model.dart';
import 'package:taska/routes/appRoutes.dart';
import 'package:taska/screen/navigation_tabs/home/homeController.dart';
import 'package:taska/screen/navigation_tabs/project/createProjectScreen/createProjectController.dart';
import 'package:taska/screen/navigation_tabs/project/widget.dart';

class CreateProjectScreen extends StatelessWidget {
  const CreateProjectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CreateProjectController());
    final data = Get.arguments;
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
            if (val == ProjectTitleOptions.DeleteProject) {
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
                              .deleteProject(uid: data['id'], context: context)
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
            } else if (val == ProjectTitleOptions.AddCover) {
              Get.toNamed(AppRoutes.addCover);
            } else if (val == ProjectTitleOptions.AddColor) {
              Get.toNamed(AppRoutes.addColor, arguments: data);
            }
          }, popMenuItem: [
            Utils.buildPopMenuItem(
              title: 'Add Cover',
              value: ProjectTitleOptions.AddCover,
              iconData: FluentIcons.image_16_regular,
            ),
            Utils.buildPopMenuItem(
              title: 'Add Logo',
              value: ProjectTitleOptions.AddLogo,
              iconData: 'change-logo-icon',
              isSvgIcon: true,
            ),
            Utils.buildPopMenuItem(
              title: 'Set Color',
              value: ProjectTitleOptions.AddColor,
              iconData: Icons.remove_red_eye_outlined,
            ),
            Utils.buildPopMenuItem(
              title: 'Edit Project',
              value: ProjectTitleOptions.EditProject,
              iconData: FluentIcons.edit_16_regular,
            ),
            Utils.buildPopMenuItem(
              title: 'Delete Project',
              value: ProjectTitleOptions.DeleteProject,
              iconData: FluentIcons.delete_12_regular,
              color: Colors.red,
              isDivider: false,
            ),
          ])
        ],
      ),
      extendBodyBehindAppBar: true,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.userCollection
            .doc(controller.currentUser?.uid)
            .collection('Projects')
            .doc(data['id'])
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading indicator when waiting for data
            return Scaffold(
              body: Center(
                child: LoadingAnimationWidget.stretchedDots(
                  color: ColorsUtil.primaryColor,
                  size: 50,
                ),
              ),
            );
          } else if (snapshot.hasError) {
            // Show error message when there's an error
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            final project = snapshot.data?.data();
            if (project != null) {
              controller.setProjectData(project);
              return Column(
                children: [
                  buildProjectImageSection(project),
                  Flexible(
                    flex: 3,
                    child: buildProjectDetailSection(
                      project: project,
                      context: context,
                    ),
                  ),
                ],
              );
            } else {
              // Handle null data case
              return const Scaffold(
                body: Center(
                  child: Text('No data available'),
                ),
              );
            }
          } else {
            // Handle no data case
            return const Scaffold(
              body: Center(
                child: Text('No data available'),
              ),
            );
          }
        },
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
                        projectId: data['uid'],
                        isDone: false,
                        time: DateTime.now(),
                      ),
                    );
                    // controller.addTaskUID(data['uid']);
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

  Widget buildProjectImageSection(data) {
    final controller = Get.find<CreateProjectController>();

    return GetBuilder<CreateProjectController>(
      builder: (context) => Flexible(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: controller.photo != null
                  ? FileImage(controller.photo!) // Show picked image
                  : data['cover'] != ''
                      ? CachedNetworkImageProvider(
                          Uri.parse(data['cover']).toString(),
                        ) // Show cover image
                      : AssetImage(data['backgroundCover']) as ImageProvider,
              // Show background cover
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildProjectDetailSection(
      {required Map<String, dynamic> project, required BuildContext context}) {
    final controller = Get.find<CreateProjectController>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18).copyWith(top: 14),
      alignment: Alignment.topLeft,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${project['title']}',
            style: const TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 0.8),
          ),
          const Text(
            'Add Description',
            style: TextStyle(fontSize: 12, color: ColorsUtil.lightBlack),
          ),
          const SizedBox(height: 12),
          controller.selectedDate!.isEmpty
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
                          color: ColorsUtil.lightGrey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CalendarDatePicker2(
                          config: CalendarDatePicker2Config(
                            selectedDayHighlightColor: ColorsUtil.primaryColor,
                          ),
                          value: [DateTime.now()],
                          onValueChanged: (val) {
                            if (val != null) {
                              String formattedDate =
                                  DateFormat('MMM d yyyy').format(val[0]!);
                              controller.setSelectedDate(formattedDate);
                              log(controller.selectedDate.toString());
                            }
                          },
                        ),
                      ),
                    );
                  },
                )
              : buildProgressSection(
                  leftTask: '1',
                  totalTask: '',
                  deadLine: controller.selectedDate.toString(),
                ),
          // task!.isNotEmpty
          //     ? Expanded(
          //         child: ListView.builder(
          //           padding: const EdgeInsets.only(top: 20),
          //           itemCount: task.length,
          //           itemBuilder: (context, i) {
          //             return taskTitleTile(
          //                 title: task[i].data()['title']);
          //           },
          //         ),
          //       )
          //     : SvgPicture.asset(
          //         'assets/images/Empty-img.svg',
          //         height: 400,
          //         alignment: Alignment.bottomCenter,
          //       )
        ],
      ),
    );
  }
}
