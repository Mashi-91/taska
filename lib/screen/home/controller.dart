import 'dart:developer';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:taska/constant/snackBar.dart';
import 'package:taska/constant/utils.dart';
import 'package:taska/model/home_model.dart';
import 'package:taska/screen/global_controller.dart';
import 'package:taska/screen/home/cover_screen.dart';
import 'package:taska/screen/home/home_screen.dart';
import 'package:taska/screen/home/profile_screen.dart';
import 'package:taska/screen/home/project_screen.dart';
import 'package:taska/screen/home/widget.dart';

class HomeController extends GlobalController {
  late final TextEditingController searchController;
  late final TextEditingController projectNameController;

  var isTaskValueComplete = false.obs;
  var currentIndex = 0.obs;
  final selected = ''.obs;

  //<<<<<<<<<<<<<<<< Pages >>>>>>>>>>>>>>>>>>>
  final List<Widget> pages = [
    HomeScreen(),
    ProjectScreen(),
    CoverScreen(),
    ProfileScreen(),
  ];

  @override
  void onInit() {
    super.onInit();
    searchController = TextEditingController();
    projectNameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    projectNameController.dispose();
  }

  isTaskComplete() {
    isTaskValueComplete.value = !isTaskValueComplete.value;
  }

  isActive(var i) {
    currentIndex.value = i++;
  }

  //<<<<<<<<<<<<<<<<<Functions>>>>>>>>>>>>>>>>>>>>>
  isCurrentSelected(String val) {
    selected.value = val;
  }

  addProject() {
    storeData(
      title: projectNameController.text,
      options: selected.toString(),
    ).then((value) {
      CustomSnackBar.snackBarMsg(
          title: 'Project Store', msg: 'Your Project has been created!');
    });
  }
}
