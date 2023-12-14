import 'dart:developer';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:taska/constant/utils.dart';
import 'package:taska/model/task_model.dart';

import '../../../constant/color.dart';
import 'homeController.dart';

Widget homeAppBar({String title = 'Taska', Widget? action}) {
  return Row(
    children: [
      SvgPicture.asset(
        "assets/icons/app-logo.svg",
        height: 30,
        fit: BoxFit.contain,
      ),
      const SizedBox(width: 16),
      Text(
        title,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      const Spacer(),
      action ?? Container(),
    ],
  );
}

Widget customBottomNavigationBar({
  required void Function(int) onTap,
  required int currentIndex,
}) {
  List<BottomBarItem> items = [
    bottomBarItem(
        icon: const Icon(FluentIcons.home_28_regular, size: 26),
        label: 'Home',
        selectIcon: const Icon(FluentIcons.home_28_filled, size: 26)),
    bottomBarItem(
        paddingRight: 24,
        paddingUp: 4,
        icon: Utils.buildSvgToIcon(
            iconName: 'project-regular-icon', color: ColorsUtil.lightGrey),
        label: 'Project',
        selectIcon: Utils.buildSvgToIcon(iconName: 'project-filled-icon')),
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
  double? paddingDown = 0,
  required Widget selectIcon,
  Color selectedColor = ColorsUtil.primaryColor,
  Color unSelectedColor = ColorsUtil.lightGrey,
}) {
  return BottomBarItem(
    icon: Padding(
      padding: EdgeInsets.only(
          left: paddingLeft!, right: paddingRight!, top: paddingUp!),
      child: icon,
    ),
    title: Padding(
      padding: EdgeInsets.only(
          left: paddingLeft, right: paddingRight, bottom: paddingDown!),
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
