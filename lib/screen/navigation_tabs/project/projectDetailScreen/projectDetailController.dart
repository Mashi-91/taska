import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:taska/screen/global_controller.dart';

class ProjectDetailController extends GlobalController {
  late final TextEditingController taskNameController;
  File? photo;
  String? projectDeadLine;
  Color? selectedColor;

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

  Future<void> setProjectDeadline(DateTime selectedDate) async {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
      projectDeadLine = formattedDate;

      // Update the project with the deadline
      // Replace the code below with your logic to update the project's deadline
      // For example, you might want to call an update function from your repository or Firestore
      // await projectRepository.updateProjectDeadline(currentProjectId, formattedDate);
      // or
      // await userCollection
      //     .doc(currentUser?.uid)
      //     .collection('projects')
      //     .doc(currentProjectUID)
      //     .update({
      //   'deadline': formattedDate,
      // });

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
