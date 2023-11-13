import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:taska/constant/routes.dart';
import 'package:taska/screen/navigation_tabs/controller.dart';
import 'package:taska/screen/navigation_tabs/home/widget.dart';
import 'package:taska/screen/navigation_tabs/project/widget.dart';

import '../../../constant/color.dart';
import '../../../constant/utils.dart';
import '../../../model/today_task_model.dart';

class ProjectDetail extends StatelessWidget {
  ProjectDetail({super.key});
  @override
  Widget build(BuildContext context) {
    final data = Get.arguments ?? '';
    final controller = Get.put(HomeController());
    // log(data.toString());
    return Scaffold(
      appBar: customAppbar(
        backgroundColor: Colors.transparent,
        isGoBack: true,
        color: data['cover'] != '' || data['cover'] != null
            ? Colors.black
            : Colors.white,
        actions: [
          iconButton(
            onTap: () {},
            icon: Icon(
              Icons.search_outlined,
              color: data['cover'] != '' || data['cover'] != null
                  ? Colors.black
                  : Colors.white,
            ),
          ),
          const SizedBox(width: 20),
          buildPopMenuButton(context,
              color: data['cover'] != '' || data['cover'] != null
                  ? Colors.black
                  : Colors.white, onSelected: (val) {
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
                    CustomButton(
                        buttonText: 'Yes, Delete',
                        func: () async {
                          await controller.deleteProject(uid: data['id']);
                        },
                        isEnable: true,
                        width: double.infinity),
                    const SizedBox(height: 12),
                    CustomButton(
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
              customBottomSheet(controller, context,
                  title: 'Add Cover',
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      customIconButton(
                        iconButtonName: 'Camera',
                        iconData: FluentIcons.camera_28_filled,
                        onTap: () async {
                          await controller.imagePickerFromCamera(
                              data: data['cover']);
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
            } else if (val == ProjectDetailOptions.EditProject) {}
          }, popMenuItem: [
            buildPopMenuItem(
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
            ),
            buildPopMenuItem(
              title: 'Change Color',
              value: ProjectDetailOptions.ChangeColor,
              iconData: Icons.remove_red_eye_outlined,
            ),*/
            buildPopMenuItem(
              title: 'Edit Project',
              value: ProjectDetailOptions.EditProject,
              iconData: FluentIcons.edit_16_regular,
            ),
            buildPopMenuItem(
                title: 'Delete Project',
                value: ProjectDetailOptions.DeleteProject,
                iconData: FluentIcons.delete_12_regular,
                color: Colors.red,
                isDivider: false),
          ])
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GetBuilder<HomeController>(
        builder: (context) => Column(
          children: [
            Flexible(
              child: Hero(
                tag: controller.isCover.value ? '' : data['title'],
                child: Material(
                    child: FutureBuilder(
                  future: data['cover'] != ''
                      ? controller.getCoverImageUrl(data['id'])
                      : Future.delayed(const Duration(milliseconds: 100)),
                  builder: (context, snapshot) {
                    // log(snapshot.data.toString());
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: LoadingAnimationWidget.stretchedDots(
                            color: primaryColor, size: 50),
                      );
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: CachedNetworkImageProvider(snapshot.data ??
                                'https://armysportsinstitute.com/wp-content/themes/armysports/images/noimg.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      return Container(
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
                      );
                    }
                  },
                )),
              ),
            ),
            Flexible(
              flex: 3,
              child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18)
                      .copyWith(top: 14),
                  alignment: Alignment.topLeft,
                  color: Colors.white,
                  child: FutureBuilder(
                      future: controller.getTask(data['id']),
                      builder: (context, snapshot) {
                        final task = snapshot.data?.docs ?? [];
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                            child: LoadingAnimationWidget.stretchedDots(
                                color: primaryColor, size: 40),
                          );
                        }
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${data['title']}',
                                style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.8),
                              ),
                              const Text(
                                'Add Description',
                                style:
                                    TextStyle(fontSize: 12, color: lightBlack),
                              ),
                              const SizedBox(height: 26),
                              /*CustomOutlineButton(
                            width: double.infinity,
                            addIcon: false,
                            isEnable: true,
                            borderWidth: 2,
                            buttonText: 'Set Deadline Project',
                            func: () {
                              customBottomSheet(controller, context,
                                  title: 'Set Deadline Project',
                                  content: CustomDateTimePicker(onDateChanged: (val){
                                    log(val.toString());
                                  }));
                            },
                          ),*/
                              buildProgressSection(
                                  leftTask: '1',
                                  totalTask: task.length.toString(),
                                  dateLeft: '13',
                                  timeLeft: 'Dec 23 2024'),
                              const SizedBox(height: 12),
                              task.isNotEmpty
                                  ? Expanded(
                                      child: ListView.builder(
                                        padding: const EdgeInsets.only(top: 20),
                                        itemCount: task.length,
                                        itemBuilder: (context, i) {
                                          return taskTitleTile(
                                              title: task[i].data()['title'] ??
                                                  '');
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
                        );
                      })),
            ),
          ],
        ),
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
