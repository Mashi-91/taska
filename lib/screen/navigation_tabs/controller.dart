import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:taska/screen/global_controller.dart';
import 'cover_screen.dart';
import 'home/home_screen.dart';
import 'profile_screen.dart';
import 'project_screen.dart';

class HomeController extends GlobalController {
  late final TextEditingController searchController;
  late final TextEditingController projectNameController;
  late final TextEditingController taskNameController;

  var isTaskValueComplete = false.obs;
  var currentIndex = 0.obs;
  final selected = 'Visibility'.obs;
  final isCover = false.obs;
  File? photo;

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
    taskNameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    projectNameController.dispose();
    taskNameController.dispose();
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

  isCoverFunc() {
    isCover.value = !isCover.value;
  }

  Future<void> imagePickerFromCamera({dynamic data}) async {
    try {
      final imagePicker = ImagePicker();
      final image = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 50);
      if (image == null) return;

      final originalFile = File(image.path);

      final appDir = await getApplicationDocumentsDirectory();
      final targetPath = path.join(appDir.path, '$currentProjectUID.jpg');

      try {
        final copiedFile = await originalFile.copy(targetPath);
        photo = copiedFile;

        //
        // if (data == null) {
        //   await userCollection
        //       .doc(currentUser?.uid)
        //       .collection('projects')
        //       .doc(currentProjectUID)
        //       .update({
        //     'cover': photo?.path ?? '',
        //   });
        //   update();
        // }
        updateProject(cover: photo);
        update();
      } catch (e) {
        log('Error copying image: $e');
      }
    } on PlatformException catch (e) {
      log('Failed to Pick Image $e');
    }
  }

  Future<void> imagePickerFromGallery() async {
    try {
      final imagePicker = ImagePicker();
      final image = await imagePicker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final originalFile = File(image.path);

      final appDir = await getApplicationDocumentsDirectory();
      final targetPath = path.join(appDir.path, '$currentProjectUID.jpg');

      try {
        final copiedFile = await originalFile.copy(targetPath);
        photo = copiedFile;
        updateProject(cover: photo);
        update();
      } catch (e) {
        log('Error copying image: $e');
      }
    } on PlatformException catch (e) {
      log('Failed to Pick Image $e');
    }
  }
}
