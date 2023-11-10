import 'dart:developer';
import 'dart:io';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';
import 'package:taska/constant/color.dart';
import 'package:taska/constant/utils.dart';
import 'package:taska/model/today_task_model.dart';
import 'package:taska/screen/navigation_tabs/controller.dart';
import 'package:taska/screen/navigation_tabs/project/widget.dart';

class ProjectTitle extends StatelessWidget {
  const ProjectTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    final data = Get.arguments;
    return Scaffold(
      appBar: customAppbar(
        backgroundColor: Colors.transparent,
        isGoBack: true,
        color: primaryColor,
        actions: [
          iconButton(
            onTap: () {},
            icon: const Icon(
              Icons.search_outlined,
              color: primaryColor,
            ),
          ),
          const SizedBox(width: 20),
          buildPopMenuButton(context, onSelected: (val) {
            if (val == ProjectTitleOptions.DeleteProject) {
              controller.deleteProject(uid: data['uid']);
            }
            if (val == ProjectTitleOptions.AddCover) {
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
            }
          }, popMenuItem: [
            buildPopMenuItem(
              title: 'Add Cover',
              value: ProjectTitleOptions.AddCover,
              iconData: FluentIcons.image_16_regular,
            ),
            buildPopMenuItem(
              title: 'Add Logo',
              value: ProjectTitleOptions.AddLogo,
              iconData: 'change-logo-icon',
              isSvgIcon: true,
            ),
            buildPopMenuItem(
              title: 'Set Color',
              value: ProjectTitleOptions.AddColor,
              iconData: Icons.remove_red_eye_outlined,
            ),
            buildPopMenuItem(
              title: 'Edit Project',
              value: ProjectTitleOptions.EditProject,
              iconData: FluentIcons.edit_16_regular,
            ),
            buildPopMenuItem(
                title: 'Delete Project',
                value: ProjectTitleOptions.DeleteProject,
                iconData: FluentIcons.delete_12_regular,
                color: Colors.red,
                isDivider: false),
          ])
        ],
      ),
      extendBodyBehindAppBar: true,
      body: StreamBuilder2(
        streams: StreamTuple2(
            controller.userCollection
                .doc(controller.currentUser?.uid)
                .collection('projects')
                .doc(data['uid'])
                .snapshots(),
            controller.getTaskSnapshot(data)),
        builder: (context, snapshot) {
          if (snapshot.snapshot1.connectionState == ConnectionState.waiting ||
              snapshot.snapshot2.connectionState == ConnectionState.waiting) {
            // Show loading indicator when waiting for data
            return Scaffold(
              body: Center(
                child: LoadingAnimationWidget.stretchedDots(
                    color: primaryColor, size: 50),
              ),
            );
          } else if (snapshot.snapshot1.hasData) {
            final project = snapshot.snapshot1.data?.data();
            final task = snapshot.snapshot2.data?.docs;
            return Column(
              children: [
                GetBuilder<HomeController>(
                  builder: (context) => Flexible(
                    child: controller.photo != null
                        ? Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(controller.photo as File),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            color: lightGrey_2,
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Positioned(
                                  bottom: 20,
                                  left: 22,
                                  child: iconButton(
                                    onTap: () {},
                                    icon: const CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Icon(
                                        FluentIcons.edit_16_filled,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                  ),
                ),
                Flexible(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18)
                        .copyWith(top: 14),
                    alignment: Alignment.topLeft,
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${project?['title']}',
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8),
                        ),
                        const Text(
                          'Add Description',
                          style: TextStyle(fontSize: 12, color: lightBlack),
                        ),
                        const SizedBox(height: 12),
                        CustomOutlineButton(
                          width: double.infinity,
                          addIcon: false,
                          buttonText: 'Set Deadline Project',
                          func: () {},
                        ),
                        task!.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(top: 20),
                                  itemCount: task.length,
                                  itemBuilder: (context, i) {
                                    return taskTitleTile(
                                        title: task[i].data()['title']);
                                  },
                                ),
                              )
                            : SvgPicture.asset(
                                'assets/images/Empty-img.svg',
                                height: 400,
                                alignment: Alignment.bottomCenter,
                              )
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Scaffold(
              body: Center(
                child: Text(
                    'Error Project: ${snapshot.snapshot1.error} Error Task ${snapshot.snapshot2.error}'),
              ),
            );
          }
        },
      ),
      floatingActionButton: CustomFloatingButton(
        onTap: () {
          customBottomSheet(
            controller,
            context,
            title: 'Add New Task',
            content: Column(
              children: [
                customTextField(
                    hintText: 'Task Name',
                    horizontalPadding: 12,
                    verticalPadding: 18,
                    controller: controller.taskNameController),
                const SizedBox(height: 18),
                CustomButton(
                  buttonText: 'Create Task',
                  func: () async {
                    await controller.storeTask(
                      projectID: data['uid'],
                      taskModel: TodayTaskModel(
                        title: controller.taskNameController.text,
                        isDone: false,
                      ),
                    );
                    controller.addTaskUID(data['uid']);
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
