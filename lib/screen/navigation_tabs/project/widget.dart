import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../constant/color.dart';
import '../../../constant/utils.dart';
import '../../../model/today_task_model.dart';
import '../controller.dart';

Future customBottomSheet(HomeController controller, BuildContext context,
    {required String title,
    Color? titleColor,
    required Widget content,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Column(
                  children: [
                    CustomDivider(height: 3, width: 40),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: titleColor ?? Colors.black),
                    ),
                    const SizedBox(height: 16),
                    CustomDivider(
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

buildProgressSection(
    {required String totalTask,
    required String leftTask,
    required String timeLeft,
    required String dateLeft}) {
  return Column(
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(
                      color: lightGrey,
                      spreadRadius: 2,
                      offset: Offset(0, 2),
                      blurRadius: 3),
                ]),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
            child: Text(
              '$leftTask / $totalTask',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          Text(
            '$timeLeft Days Left, $dateLeft',
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
        percent: 0.5,
        backgroundColor: Colors.grey.withOpacity(0.3),
        progressColor: primaryColor,
      )
    ],
  );
}

Widget projectCardWithImg({
  required String backGroundImg,
  required String title,
  required String subTitle,
  required Function onTapOption,
  required String totalTask,
  required String leftTask,
  required String timeLeft,
  required String dateLeft,
  EdgeInsets? margin,
}) {
  final size = Get.height;
  return Container(
    margin:
        margin ?? const EdgeInsets.symmetric(horizontal: 4).copyWith(bottom: 0),
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(20), boxShadow: [
      BoxShadow(
          offset: const Offset(0, 2),
          color: Colors.grey.withOpacity(0.1),
          // color: Colors.red,
          spreadRadius: 1,
          blurRadius: 20)
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
              image: CachedNetworkImageProvider(
                  Uri.parse(backGroundImg).toString()),
            ),
          ),
        ),
        Expanded(
          child: Material(
            child: SingleChildScrollView(
              child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(20),
                        bottomLeft: Radius.circular(20))),
                padding: const EdgeInsets.symmetric(horizontal: 20)
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
                                color: lightGrey))
                      ],
                    ),
                    Text(
                      subTitle,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    SizedBox(height: size * 0.02),
                    buildProgressSection(
                      totalTask: totalTask,
                      leftTask: leftTask,
                      timeLeft: timeLeft,
                      dateLeft: dateLeft,
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
                                color: lightGrey))
                      ],
                    ),
                    Text(
                      subTitle,
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.normal),
                    ),
                    buildProgressSection(
                      totalTask: totalTask,
                      leftTask: leftTask,
                      timeLeft: timeLeft,
                      dateLeft: dateLeft,
                    )
                  ],
                ),
              ),
            )),
      ],
    ),
  );
}

Widget taskTile({required TodayTaskModel taskModel}) {
  return Container(
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 1),
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 2)
        ]),
    child: ListTile(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      title: Text(
        taskModel.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        'taskModel.dateCreated',
        style: const TextStyle(fontSize: 12.5),
      ),
      trailing: InkWell(
        onTap: () {},
        child: taskModel.isDone
            ? Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                    color: primaryColor,
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
                    border: Border.all(color: primaryColor)),
              ),
      ),
    ),
  );
}

Widget taskTitleTile({required String title, required DateTime time}) {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime yesterday = today.subtract(Duration(days: 1));

  String displayText;

  if (time.isAfter(today)) {
    displayText = 'Today ${DateFormat.jmz().format(time)}';
  } else if (time.isAfter(yesterday)) {
    displayText = 'Yesterday ${DateFormat.jmz().format(time)}';
  } else {
    displayText = DateFormat.yMd().add_jm().format(time);
  }
  return Container(
    margin: const EdgeInsets.only(right: 80, bottom: 12),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              offset: const Offset(0, 1),
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 2)
        ]),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: const Icon(FluentIcons.add_square_16_regular),
            )
          ],
        ),
        const SizedBox(height: 8),
        Text('$displayText')
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
            color: lightGrey.withOpacity(0.2),
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
