import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:taska/model/porject_model.dart';
import '../constant/snackBar.dart';
import '../constant/utils.dart';
import '../model/fill_profile_model.dart';
import '../model/home_model.dart';
import '../screen/fill_your_profile/controller.dart';

class GlobalController extends GetxController {
  //<<<<<<<<<<<<<<<<<< Firebase Instances >>>>>>>>>>>>>>>>>>>>>>>>

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;

  // <<<<<<<<<<<<<<<<<<< Firebase Functions >>>>>>>>>>>>>>>>>>>

  createEmailAndPassword(String email, String password) async {
    try {
      //<<<<<<<<<<<<<<< Create a User >>>>>>>>>>>>>>>>>>>>>>
      await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Get.offNamed('/FillYourProfile');
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return CustomSnackBar.snackBarMsg(
            title: "Email-Error", msg: "Email is already in use!");
      } else if (email.isEmpty && password.isEmpty) {
        return CustomSnackBar.snackBarMsg(
            title: 'Credentials-Error', msg: 'Enter your credentials.');
      } else if (email.isEmpty) {
        return CustomSnackBar.snackBarMsg(
            title: 'Email-Error', msg: 'Enter your email!');
      } else if (password.isEmpty) {
        return CustomSnackBar.snackBarMsg(
            title: 'Password-Error', msg: 'Enter your password!');
      } else if (e.code == "invalid-email") {
        return CustomSnackBar.snackBarMsg(
            title: 'Email-Error', msg: 'Enter a valid email!');
      } else if (e.code == "weak-password") {
        return CustomSnackBar.snackBarMsg(
            title: 'Password-Error', msg: 'Password should be greater than 7.');
      }
    } catch (e) {
      log("CreateEmailAndPassword: $e");
    }
  }

// <<<<<<<<<<<<<< Store Additional Date in Database >>>>>>>>>>>>>>>>>>>

  Future<void> storeUserDetails(
      {required FillProfileModel createUserModel,
      required FillProfileController controller}) async {
    try {
      if (controller.image.isEmpty) {
        CustomSnackBar.snackBarMsg(
            title: 'Store-User-Error', msg: 'Please add your profile image.');
      } else if (controller.fullNameController.text.isEmpty) {
        CustomSnackBar.snackBarMsg(
            title: 'Store-User-Error', msg: 'Enter your Full Name.');
      } else if (controller.userNameController.text.isEmpty) {
        CustomSnackBar.snackBarMsg(
            title: 'Store-User-Error', msg: 'Enter your User Name.');
      } else if (controller.dateOfBirth.isEmpty) {
        CustomSnackBar.snackBarMsg(
            title: 'Store-User-Error', msg: 'Enter your Date of Birth.');
      } else if (controller.phoneController.text.isEmpty) {
        CustomSnackBar.snackBarMsg(
            title: 'Store-User-Error', msg: 'Enter your Phone Number.');
      } else if (controller.roleController.text.isEmpty) {
        CustomSnackBar.snackBarMsg(
            title: 'Store-User-Error', msg: 'Enter your Role.');
      } else {
        await currentUser?.updateDisplayName(createUserModel.userName);
        await currentUser?.updatePhotoURL(createUserModel.imgUrl);
        await fireStore
            .collection('users')
            .add(createUserModel.toJson())
            .then((value) async {
          await CustomSnackBar.snackBarMsg(
              title: 'Success', msg: 'Your profile has been created.');
          Get.offAllNamed("/");
        });
      }
    } on FirebaseFirestore catch (e) {
      log("FirebaseFireStore: $e");
    }
  }

  // <<<<<<<<<<<<<<<<<< UserSign >>>>>>>>>>>>>>>>>>>>>

  signInUserWithEmailAndPass(String email, String password) async {
    try {
      //<<<<<<<<<<<<<<< Create a User >>>>>>>>>>>>>>>>>>>>>>
      await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Get.offAllNamed('/HomeScreen');
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        return CustomSnackBar.snackBarMsg(
            title: "Sign-In-User-Error", msg: "Email is already in use!");
      } else if (email.isEmpty && password.isEmpty) {
        return CustomSnackBar.snackBarMsg(
            title: 'Sign-In-User-Error', msg: 'Enter your credentials.');
      } else if (email.isEmpty) {
        return CustomSnackBar.snackBarMsg(
            title: 'Sign-In-User-Error', msg: 'Enter your email!');
      } else if (password.isEmpty) {
        return CustomSnackBar.snackBarMsg(
            title: 'Sign-In-User-Error', msg: 'Enter your password!');
      } else if (e.code == "user-not-found") {
        return CustomSnackBar.snackBarMsg(
            title: 'Sign-In-User-Error',
            msg:
                "There's no email with this email-id, Please go ahead & create one!");
      } else if (e.code == "invalid-email") {
        return CustomSnackBar.snackBarMsg(
            title: 'Sign-In-User-Error', msg: 'Enter a valid email!');
      } else if (e.code == "weak-password") {
        return CustomSnackBar.snackBarMsg(
            title: 'Sign-In-User-Error', msg: 'Wrong Password!');
      }
    } catch (e) {
      log("Sign-In-User-WithEmailAndPass: $e");
    }
  }

  // <<<<<<<<<<<<<<<<<<< Reset Password >>>>>>>>>>>>>>>>>>>>>>>>>

  resetPasswordWithEmail({required String resetEmail}) async {
    try {
      await firebaseAuth
          .sendPasswordResetEmail(email: resetEmail)
          .then((value) {
        Get.defaultDialog(
          title: '',
          titlePadding: EdgeInsets.zero,
          content: Column(
            children: [
              SvgPicture.asset(
                'assets/icons/Done-icon.svg',
                width: 150,
                height: 150,
              ),
              const SizedBox(height: 24),
              const Text(
                "Your password reset link has been sent!",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              CustomButton(
                buttonText: 'Go to Homepage',
                func: () {
                  Get.offAllNamed('/SignInSignUp');
                },
                width: 230,
                height: 46,
                isEnable: true,
              )
            ],
          ),
        );
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "auth/invalid-email") {
        return CustomSnackBar.snackBarMsg(
            title: 'Reset-Password-Error', msg: "Enter a valid email-address!");
      } else if (e.code == "auth/user-not-found") {
        return CustomSnackBar.snackBarMsg(
            title: "Reset-Password-Error",
            msg: "Your email-address not registered!");
      }
    } catch (e) {
      log("Reset-Password-Error: $e");
    }
  }

  // <<<<<<<<<<<<<<<<<<< Store Data to Database >>>>>>>>>>>>>>>>>>>>>>>>>>>

  final List<HomeModel> items = [
    HomeModel(
        // id: firebaseAuth.currentUser,
        homeImg: "assets/images/home_1_image.jpg",
        title: "Tiki Mobile App Project",
        subTitle: 'Ui Kit Design Project - Dec 20, 2023',
        progress: "80 / 90",
        onPress: () {}),
    HomeModel(
        homeImg: "assets/images/home_2_image.jpg",
        title: "Job Portal Website App",
        progress: "67 / 86",
        subTitle: 'External Client Project - Dec 31, 2023',
        onPress: () {}),
  ];

  Future<void> storeData(
      {required String title, required String options}) async {
    try {
      fireStore.collection('users/$currentUser/Projects/').add({
        'id': currentUser,
        'title': title,
        'options': options,
      }).then((value) => log('Successfully Uploaded!'));
    } on FirebaseFirestore catch (e) {
      log('$e');
    }
  }
}
