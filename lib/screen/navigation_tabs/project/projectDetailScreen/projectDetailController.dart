import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:taska/model/task_model.dart';
import 'package:taska/screen/global_controller.dart';

class ProjectDetailController extends GlobalController {
  late final TextEditingController taskNameController;
  File? photo;
  Color? selectedColor;
  String? memoryDateTime;
  List<TaskModel> projectDetailScreenTask = [];

  // Function to set the selected color
  void setSelectedColor(Color color) {
    selectedColor = color;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    taskNameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    taskNameController.dispose();
  }

  Future<void> setProjectDeadline(
      {required String projectId, required dateFromDatePicker}) async {
    try {
      final projectDeadLine = DateFormat('yyyy-MM-dd').format(
          DateFormat('yyyy-MM-dd').parse(dateFromDatePicker.toString()));
      updateFieldFromFirebase(
        currentProjectId: projectId,
        updateField: projectDeadLine,
        firebaseFiledName: 'projectDeadLine',
      );
      memoryDateTime = projectDeadLine;
      update(); // Update the UI if necessary
    } catch (e) {
      log('Error setting project deadline: $e');
    }
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
