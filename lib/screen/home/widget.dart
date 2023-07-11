import 'dart:developer';

import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:taska/constant/utils.dart';
import 'package:taska/model/today_task_model.dart';
import 'package:taska/screen/auth/sign_up/sign_up_widget.dart';
import 'package:taska/screen/home/controller.dart';

import '../../constant/color.dart';

Widget homeAppBar() {
  return Row(
    children: [
      SvgPicture.asset(
        "assets/icons/app-logo.svg",
        height: 30,
        fit: BoxFit.contain,
      ),
      const SizedBox(width: 16),
      const Text(
        'Taska',
        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      const Spacer(),
      const Icon(FluentIcons.alert_32_filled, color: primaryColor)
    ],
  );
}

Widget projectCard({
  required String backGroundImg,
  Widget? iconImg = const Icon(Icons.ac_unit),
  Widget? participateImg = const Icon(Icons.ac_unit),
  required String title,
  required String subTitle,
  required Function onTapOption,
  required String progress,
}) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 4).copyWith(bottom: 6),
    decoration:
        BoxDecoration(borderRadius: BorderRadius.circular(16), boxShadow: [
      BoxShadow(
          offset: const Offset(0, 2),
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 4)
    ]),
    width: double.infinity,
    height: 300,
    child: Column(
      children: [
        Container(
          height: 130,
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16), topRight: Radius.circular(16)),
              image: DecorationImage(
                  fit: BoxFit.cover, image: AssetImage(backGroundImg))),
          child: Stack(
            children: [
              Positioned(bottom: 12, left: 14, child: iconImg!),
              Positioned(bottom: 12, right: 14, child: participateImg!),
            ],
          ),
        ),
        Expanded(
            flex: 2,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16))),
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
                          icon: const Icon(Icons.pending_outlined))
                    ],
                  ),
                  Text(
                    subTitle,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                  Chip(
                    label: Text(progress),
                    backgroundColor: primaryColor,
                    elevation: 2,
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )),
      ],
    ),
  );
}

Widget taskTile({required bool val, required TodayTaskModel taskModel}) {
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
        taskModel.currentTime,
        style: const TextStyle(fontSize: 12.5),
      ),
      trailing: InkWell(
        onTap: () => taskModel.onTap(),
        child: val
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

Widget customBottomNavigationBar({
  required void Function(int) onTap,
  required int currentIndex,
}) {
  List<BottomBarItem> items = [
    bottomBarItem(
        icon: const Icon(FluentIcons.home_12_regular, size: 26),
        label: 'Home',
        selectIcon: const Icon(FluentIcons.home_12_filled, size: 26)),
    bottomBarItem(
        paddingRight: 24,
        paddingUp: 4,
        icon: const SvgToIcon(icon: 'project-regular-icon', color: lightGrey),
        label: 'Project',
        selectIcon: const SvgToIcon(icon: 'project-filled-icon')),
    bottomBarItem(
        paddingLeft: 24,
        icon: const Icon(FluentIcons.image_16_regular, size: 26),
        label: 'Cover',
        selectIcon: const Icon(FluentIcons.image_16_filled, size: 26)),
    bottomBarItem(
      icon: const Icon(FluentIcons.person_20_regular),
      label: 'Profile',
      selectIcon: const Icon(FluentIcons.person_20_filled),
    ),
  ];

  return StylishBottomBar(
    items: items,
    onTap: (val) => onTap(val),
    fabLocation: StylishBarFabLocation.center,
    currentIndex: currentIndex,
    option: AnimatedBarOptions(),
  );
}

BottomBarItem bottomBarItem({
  required Widget icon,
  required String label,
  double? paddingLeft = 0,
  double? paddingRight = 0,
  double? paddingUp = 0,
  required Widget selectIcon,
  Color selectedColor = primaryColor,
  Color unSelectedColor = lightGrey,
}) {
  return BottomBarItem(
    icon: Padding(
      padding: EdgeInsets.only(
          left: paddingLeft!, right: paddingRight!, top: paddingUp!),
      child: icon,
    ),
    title: Padding(
      padding: EdgeInsets.only(left: paddingLeft, right: paddingRight),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10),
      ),
    ),
    selectedIcon: Padding(
      padding: EdgeInsets.only(
          left: paddingLeft, right: paddingRight, top: paddingUp),
      child: selectIcon,
    ),
    selectedColor: selectedColor,
    unSelectedColor: unSelectedColor,
  );
}

Widget customBottomSheet(HomeController controller) {
  return SingleChildScrollView(
    child: Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(24),
            topLeft: Radius.circular(24),
          )),
      width: double.infinity,
      height: Get.height * 0.48,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          children: [
            const CustomDivider(),
            const SizedBox(height: 16),
            const Text(
              'New Project',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomDivider(
              width: double.infinity,
              height: 2,
              color: Colors.grey.withOpacity(0.1),
            ),
            const SizedBox(height: 20),
            customTextField(
                hintText: 'Project Name',
                horizontalPadding: 12,
                verticalPadding: 18,
                controller: controller.projectNameController),
            const SizedBox(height: 18),
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton(
                  isExpanded: true,
                  value: controller.selected.value,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 12)
                      .copyWith(top: 6),
                  icon: const Icon(FluentIcons.caret_down_12_filled),
                  underline: Container(),
                  items: const [
                    DropdownMenuItem(
                      value: 'Visibility',
                      child: Text('Visibility'),
                    ),
                    DropdownMenuItem(
                      value: 'Private',
                      child: Text('Private'),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(18),
                  onChanged: (val) {
                    controller.isCurrentSelected(val as String);
                  },
                  style: const TextStyle(color: lightGrey),
                ),
              ),
            ),
            const SizedBox(height: 18),
            CustomOutlineButton(
              buttonText: 'Add Member',
              func: () {},
              width: double.infinity,
            ),
            const SizedBox(height: 18),
            CustomButton(
              buttonText: 'Create Project',
              func: () async {
                await controller.addProject();
                // Get.offNamed('/NewProjectScreen');
              },
              isEnable: true,
              height: 62,
              width: double.infinity,
            )
          ],
        ),
      ),
    ),
  );
}
