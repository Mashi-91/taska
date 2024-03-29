import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:taska/constant/global_function.dart';

import '../../../constant/color.dart';
import '../../../constant/utils.dart';
import '../../../model/task_model.dart';
import '../home/homeController.dart';

Future customBottomSheet(dynamic controller, BuildContext context,
    {required String title,
    Color? titleColor,
    required Widget content,
    double? bottomPadding,
    RouteSettings? routeSetting}) {
  return showModalBottomSheet(
      context: context,
      enableDrag: true,
      isDismissible: true,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30)
              .copyWith(bottomLeft: Radius.zero, bottomRight: Radius.zero)),
      builder: (context) => SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 14),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20)
                    .copyWith(top: 8, bottom: bottomPadding ?? 8),
                child: Column(
                  children: [
                    Utils.buildCustomDivider(height: 3, width: 40),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: titleColor ?? Colors.black),
                    ),
                    const SizedBox(height: 16),
                    Utils.buildCustomDivider(
                      width: double.infinity,
                      height: 2,
                      color: Colors.grey.withOpacity(0.1),
                    ),
                    const SizedBox(height: 20),
                    content,
                  ],
                ),
              ),
            ),
          ));
}

buildProgressSection({
  required String totalTask,
  required String deadLine,
  required List<TaskModel> taskList,
}) {
  final daysLeft = GlobalFunction.calculateTimeLeft(deadLine);
  final showDaysLeft = GlobalFunction.formatDeadline(deadLine);
  // Calculate the completion percentage
  final completedTasks = taskList.where((task) => task.isDone).length;
  final calculatedLinePercentage =
      Utils.calculateLinePercentage(completedTasks, int.parse(totalTask));
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
                color: ColorsUtil.primaryColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                      color: ColorsUtil.lightGrey,
                      spreadRadius: 2,
                      offset: Offset(0, 2),
                      blurRadius: 3),
                ]),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Text(
              '$completedTasks / $totalTask',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          Text(
            '$daysLeft, $showDaysLeft',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          )
        ],
      ),
      const SizedBox(
        height: 20,
      ),
      LinearPercentIndicator(
        animation: true,
        animationDuration: 400,
        padding: EdgeInsets.zero,
        barRadius: const Radius.circular(12),
        animateFromLastPercent: true,
        percent: calculatedLinePercentage,
        backgroundColor: Colors.grey.withOpacity(0.3),
        progressColor: ColorsUtil.primaryColor,
      )
    ],
  );
}

Widget projectCardWithImg({
  required dynamic imageProvider,
  required String title,
  required String subTitle,
  required Function onTapOption,
  required String totalTask,
  required String deadLine,
  List<TaskModel>? taskModel,
  EdgeInsets? margin,
}) {
  final size = Get.height;
  return Container(
    margin: margin ??
        EdgeInsets.symmetric(horizontal: Get.width * 0.01).copyWith(bottom: 0),
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
      BoxShadow(
        offset: const Offset(0, 2), // Positive X value for right side shadow
        color: Colors.grey.withOpacity(0.3),
        spreadRadius: 2,
        blurRadius: 8,
      )
    ]),
    width: double.infinity,
    height: size * 0.34,
    child: Column(
      children: [
        Container(
          height: size * 0.14,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: imageProvider,
            ),
          ),
        ),
        Expanded(
          child: Material(
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20),
            ),
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    // borderRadius: BorderRadius.only(
                    //     bottomRight: Radius.circular(20),
                    //     bottomLeft: Radius.circular(20)),
                    ),
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.06)
                    .copyWith(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                            onPressed: () => onTapOption(),
                            icon: const Icon(Icons.pending_outlined,
                                color: ColorsUtil.lightGrey))
                      ],
                    ),
                    Text(
                      subTitle,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(height: size * 0.02),
                    if (deadLine.isNotEmpty)
                      buildProgressSection(
                        totalTask: totalTask,
                        deadLine: deadLine,
                        taskList: taskModel?.toList() ?? <TaskModel>[],
                      )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget projectCardWithoutImg({
  required String title,
  required String subTitle,
  required Function onTapOption,
  required String totalTask,
  required String leftTask,
  required String timeLeft,
  required String dateLeft,
  EdgeInsets? margin,
}) {
  return Container(
    margin:
        margin ?? const EdgeInsets.symmetric(horizontal: 4).copyWith(bottom: 6),
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: [
      BoxShadow(
          offset: const Offset(0, 2),
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 4)
    ]),
    width: double.infinity,
    height: 160,
    child: Column(
      children: [
        Expanded(
            flex: 2,
            child: Material(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20).copyWith(top: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        IconButton(
                            onPressed: () => onTapOption(),
                            icon: const Icon(Icons.pending_outlined,
                                color: ColorsUtil.lightGrey))
                      ],
                    ),
                    Text(
                      subTitle,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    buildProgressSection(
                      totalTask: totalTask,
                      deadLine: timeLeft,
                      taskList: [],
                    )
                  ],
                ),
              ),
            )),
      ],
    ),
  );
}

Widget taskTile({required TaskModel taskModel}) {
  final time = Utils.formatTaskTime(taskModel.time);
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 1),
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 2)
        ],
    ),
    child: ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Text(
        taskModel.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        time,
        style: const TextStyle(fontSize: 12.5),
      ),
      trailing: InkWell(
        onTap: () {},
        child: taskModel.isDone
            ? Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: ColorsUtil.primaryColor,
                    borderRadius: BorderRadius.circular(4)),
                child: const Icon(
                  Icons.check,
                  size: 14,
                  color: Colors.white,
                ))
            : Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: ColorsUtil.primaryColor)),
              ),
      ),
    ),
  );
}

Widget taskTitleTile({required TaskModel task, required Function onTap}) {
  final time = Utils.formatTaskTime(task.time);
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    width: Get.width,
    height: 80,
    decoration: BoxDecoration(
        color: ColorsUtil.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 1),
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 4)
        ]),
    child: Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 6),
            Text(
              time,
              style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
            ),
          ],
        ),
        const Spacer(),
        IconButton(
          onPressed: () => onTap(),
          icon: task.isDone
              ? Utils.buildSvgToIcon(iconName: 'checkmark-filled-icon')
              : Utils.buildSvgToIcon(iconName: 'checkmark-regular-icon'),
        )
      ],
    ),
  );
}

Widget customIconButton(
    {required String iconButtonName,
    required IconData iconData,
    required Function onTap}) {
  return InkWell(
    onTap: () => onTap(),
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: ColorsUtil.lightGrey.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(iconData, size: 40),
        ),
        const SizedBox(height: 8),
        Text(iconButtonName),
      ],
    ),
  );
}
