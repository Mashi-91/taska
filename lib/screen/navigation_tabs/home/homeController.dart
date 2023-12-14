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
import '../coverScreen/cover_screen.dart';
import 'home_screen.dart';
import '../profileScreen/profile_screen.dart';
import '../projectScreen/project_screen.dart';

class HomeController extends GlobalController {
  late final TextEditingController searchController;
  late final TextEditingController projectNameController;

  var isTaskValueComplete = false.obs;
  var currentIndex = 0.obs;
  final selected = 'Visibility'.obs;
  final isCover = false.obs;
  List<Color> colorList = [];

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
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
    projectNameController.dispose();
  }

  // <<<<<<<<<<<<<<<<< Functions >>>>>>>>>>>>>>>>>>>>>
  void isCoverFunc() {
    isCover.value = !isCover.value;
  }

  void clearProjectNameText() {
    projectNameController.clear();
  }

  void isTaskComplete() {
    isTaskValueComplete.value = !isTaskValueComplete.value;
  }

  void isActive(var i) {
    currentIndex.value = i++;
  }

  void isCurrentSelected(String val) {
    selected.value = val;
  }

  Future<void> imagePickerFromCamera({String? currentProjectId}) async {
    try {
      // Picking Image From Camera
      final imagePicker = ImagePicker();
      final image = await imagePicker.pickImage(
          source: ImageSource.camera, imageQuality: 50);

      // If Pick Nothing return null
      if (image == null) return;

      // Set Image Path
      final originalFile = File(image.path);
      final appDir = await getApplicationDocumentsDirectory();
      final targetPath = path.join(appDir.path,
          '${currentProjectUID.isEmpty ? currentProjectId : currentProjectUID}.jpg');

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
        updateProject(cover: photo, currentProjectId: currentProjectId);
        update();
      } catch (e) {
        log('Error copying image: $e');
      }
    } on PlatformException catch (e) {
      log('Failed to Pick Image $e');
    }
  }

  Future<void> imagePickerFromGallery({String? currentProjectId}) async {
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
        updateProject(cover: photo, currentProjectId: currentProjectId);
        update();
      } catch (e) {
        log('Error copying image: $e');
      }
    } on PlatformException catch (e) {
      log('Failed to Pick Image $e');
    }
  }
}
