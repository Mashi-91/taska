import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taska/constant/global_function.dart';
import 'package:taska/constant/utils.dart';
import 'package:taska/model/project_model.dart';
import 'package:taska/routes/appRoutes.dart';
import 'package:taska/screen/navigation_tabs/home/homeController.dart';
import 'package:taska/screen/navigation_tabs/project/projectDetailScreen/projectDetailController.dart';
import 'package:taska/screen/navigation_tabs/project/projectDetailScreen/projectDetailWidget.dart';
import 'package:taska/screen/navigation_tabs/project/widget.dart';
import '../../../../model/task_model.dart';

class ProjectDetail extends StatelessWidget {
  const ProjectDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final ProjectModel data = Get.arguments ?? '';
    final controller = Get.put(ProjectDetailController());
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
                  isDivider: false,
                ),
              ])
        ],
      ),
      extendBodyBehindAppBar: true,
      body: GetBuilder<ProjectDetailController>(
        builder: (_) => SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ProjectDetailLogic.buildHeroSection(data),
              ProjectDetailLogic.buildProjectDetailSection(
                project: data,
                context: context,
              ),
            ],
          ),
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
