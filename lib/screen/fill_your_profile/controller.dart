import 'dart:developer';

import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taska/constant/snackBar.dart';
import 'package:taska/screen/auth/sign_up/controller.dart';

class FillProfileController extends SignUpController {
  //<<<<<<<<<<<< Controller >>>>>>>>>>>>>>>>
  late final TextEditingController fullNameController;
  late final TextEditingController userNameController;
  late final TextEditingController phoneController;
  late final TextEditingController roleController;

  //<<<<<<<<<<<<<< variable for Storing data & Getters >>>>>>>>>>>>>>>>>>
  Rx<String> dateOfBirth = "".obs;
  CountryCode? code;
  RxString image = ''.obs;
  var isEnabled = false.obs;
  final countryCode = const FlCountryCodePicker();

  @override
  void onInit() {
    fullNameController = TextEditingController();
    phoneController = TextEditingController();
    userNameController = TextEditingController();
    roleController = TextEditingController();
    super.onInit();
  }

  @override
  void dispose() {
    fullNameController.dispose();
    phoneController.dispose();
    userNameController.dispose();
    roleController.dispose();
    super.dispose();
  }

  // <<<<<<<<<<<<<<<< Toggle Functions & set Values >>>>>>>>>>>>>>>>>>

  setDOBValue(value) {
    dateOfBirth.value = value;
  }

  setCode(value) {
    code = value;
    update();
  }

  bool isButtonEnabled() {
    if (fullNameController.text.isNotEmpty &&
        userNameController.text.isNotEmpty &&
        dateOfBirth.isNotEmpty &&
        phoneController.text.isNotEmpty &&
        roleController.text.isNotEmpty) {
      isEnabled.value = true;
    } else {
      isEnabled.value = false;
    }
    return isEnabled.value;
  }

  // <<<<<<<<<<<<<< Functions >>>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future imagePicker() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? img = await picker.pickImage(source: ImageSource.gallery);
      if (img == null) return;
      image.value = img.path.toString();
    } on PlatformException catch (e) {
      log("Show Error: $e");
    }
    update();
  }
}
