import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:taska/constant/routes.dart';
import 'package:taska/model/project_model.dart';
import 'package:taska/model/today_task_model.dart';
import '../constant/snackBar.dart';
import '../constant/utils.dart';
import '../model/fill_profile_model.dart';
import '../screen/fill_your_profile/controller.dart';

class GlobalController extends GetxController {
  //<<<<<<<<<<<<<<<<<< Local Variables >>>>>>>>>>>>>>>>>>>>>>>>
  var isLoading = false;
  List taskData = [];
  var imgUrl = '';

  //<<<<<<<<<<<<<<<<<< Firebase & FireStore Instances >>>>>>>>>>>>>>>>>>>>>>>>

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final userCollection = FirebaseFirestore.instance.collection('users');
  final firebaseStorageRef = FirebaseStorage.instance.ref();
  var currentProjectUID = '';
  var taskList = [];
  var taskUID = '';

  Stream<QuerySnapshot<Map<String, dynamic>>> getTaskSnapshot(dynamic data) =>
      userCollection
          .doc(currentUser?.uid)
          .collection('Projects')
          .doc(data?['uid'])
          .collection('task')
          .snapshots();

  @override
  void onInit() {
    super.onInit();
  }

  // <<<<<<<<<<<<<<<<<<< Firebase Functions >>>>>>>>>>>>>>>>>>>

  createEmailAndPassword(BuildContext context,
      {required String email, required String password}) async {
    try {
      // <<<<<<<<<<<<<< Show Loading >>>>>>>>>>>>>>>>>>>
      customLoadingIndicator(context);
      //<<<<<<<<<<<<<<< Create a User >>>>>>>>>>>>>>>>>>>>>>
      await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await CustomSnackBar.snackBarMsg(
            title: 'Success',
            msg: 'Your Account has been created, add your profile detail!',
            snackPosition: SnackPosition.TOP);
        Get.offAllNamed('/FillYourProfile');
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

  Future<void> storeUserDetails(BuildContext context,
      {required FillProfileModel createUserModel,
      required FillProfileController controller}) async {
    try {
      // <<<<<<<<<<<<<< Show Loading >>>>>>>>>>>>>>>>>>>
      customLoadingIndicator(context);
      //<<<<<<<<<<<<<<< Store User Data >>>>>>>>>>>>>>>>>>>>>>
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
      } else if (controller.fillYourEmailAddress.text.isEmpty) {
        CustomSnackBar.snackBarMsg(
            title: 'Store-User-Error', msg: 'Enter your Email-ID.');
      } else if (controller.phoneController.text.isEmpty) {
        CustomSnackBar.snackBarMsg(
            title: 'Store-User-Error', msg: 'Enter your Phone Number.');
      } else if (controller.roleController.text.isEmpty) {
        CustomSnackBar.snackBarMsg(
            title: 'Store-User-Error', msg: 'Enter your Role.');
      } else {
        await currentUser
            ?.updateDisplayName(controller.userNameController.text);
        await currentUser?.updatePhotoURL(controller.image.value);
        // await currentUser?.updatePhoneNumber(Uri.parse(controller.phoneController.text));
        await fireStore
            .collection('users')
            .doc(currentUser?.uid)
            .set(createUserModel.toJson())
            .then((value) async {
          await CustomSnackBar.snackBarMsg(
              title: 'Success', msg: 'Your profile has been created.');
          Get.offAllNamed("/SignIn");
        });
      }
    } on FirebaseFirestore catch (e) {
      log("FirebaseFireStore: $e");
    }
  }

  // <<<<<<<<<<<<<<<<<< UserSign >>>>>>>>>>>>>>>>>>>>>

  signInUserWithEmailAndPass(BuildContext context,
      {required String email, required String password}) async {
    try {
      // <<<<<<<<<<<<<< Show Loading >>>>>>>>>>>>>>>>>>>
      customLoadingIndicator(context);
      //<<<<<<<<<<<<<<< SignInUser >>>>>>>>>>>>>>>>>>>>>>
      await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Get.offAllNamed('/');
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
                  Get.offAllNamed(signInSignUpScreen);
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

  List<Map<String, dynamic>> items = [
    /*HomeModel(
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
        onPress: () {}),*/
  ];

// <<<<<<<<<<<<<<<<<<<<<< Create A Project >>>>>>>>>>>>>>>>>>>>>>>>>>>
  Future storeProject({required String title}) async {
    final uid = Timestamp.now().seconds.toString();
    final map = ProjectModel(id: uid, title: title, cover: '').toJson();
    Get.back();
    try {
      await userCollection
          .doc(currentUser?.uid)
          .collection('Projects')
          .doc(uid)
          .set(map)
          .then((value) async {
        Get.toNamed(titleScreen, arguments: map);
        currentProjectUID = uid;
        update();
      });
    } on FirebaseFirestore catch (e) {
      log('Hlo This is Error From StoreData $e');
    }
  }

  // <<<<<<<<<<<<<<<<<<<<<< Upload Image >>>>>>>>>>>>>>>>>>>>>>>>>>>
  uploadImg({File? cover}) async {
    try {
      final path = cover!.path
          .replaceAll('/data/user/0/com.example.taska/app_flutter/', '');
      var upload =
          await firebaseStorageRef.child('projectCover/$path').putFile(cover);
      await upload.ref.getDownloadURL().then((value) {
        imgUrl = value;
        update();
      });
      log('UploadSection: $imgUrl');
    } catch (e) {
      log('Showing Error uploadImgSection: $e');
    }
  }

  updateProject({File? cover}) async {
    try {
      await uploadImg(cover: cover);
      await userCollection
          .doc(currentUser?.uid)
          .collection('Projects')
          .doc(currentProjectUID)
          .update({
        'cover': imgUrl,
      });
    } on FirebaseFirestore catch (e) {
      log('Showing Error uploadProjectSection: $e');
    }
  }

  addTaskUID(String? uid) async {
    try {
      await userCollection
          .doc(currentUser!.uid)
          .collection('Projects')
          .doc(uid)
          .set({
        'taskUID': taskUID,
      });
      log(taskUID);
    } on FirebaseFirestore catch (e) {
      log('Showing Error while adding taskUID: $e');
    }
  }

  Future<String?> getCoverImageUrl(String projectId) async {
    try {
      final ref =
          FirebaseStorage.instance.ref().child('projectCover/$projectId.jpg');

      // Check if the object exists by trying to get its data
      final data = await ref.getData();
      log(ref.toString());

      if (data != null) {
        // If data is not null, the object exists
        final url = await ref.getDownloadURL();
        return url;
      } else {
        log('Object does not exist at location.');
        return 'https://armysportsinstitute.com/wp-content/themes/armysports/images/noimg.png';
      }
    } catch (e) {
      log('Error getting cover image URL: $e');
      return null;
    }
  }

  deleteProject({String? uid}) async {
    final batch = FirebaseFirestore.instance.batch();

    final projectDocRef =
        userCollection.doc(currentUser?.uid).collection('Projects').doc(uid);

    // Query for tasks and delete them
    final tasksQuerySnapshot = await projectDocRef.collection('task').get();
    for (final taskDocSnapshot in tasksQuerySnapshot.docs) {
      batch.delete(taskDocSnapshot.reference);
    }

    // Delete project document
    batch.delete(projectDocRef);

    // Delete project cover from Firebase Storage if it exist
    final storageRef =
        firebaseStorageRef.child('${currentUser?.uid}/projectCover/$uid.jpg');
    try {
      await storageRef.getDownloadURL();
      await storageRef.delete();
    } catch (e) {
      log(e.toString());
    }

    // Commit the batch
    try {
      await batch.commit();
      Get.offNamedUntil(homeNavigationController, (route) => route.isCurrent);
    } on FirebaseFirestore catch (e) {
      log('Error deleting project and tasks: $e');
    }
  }

// <<<<<<<<<<<<<<<<<<<<<< Get All Data >>>>>>>>>>>>>>>>>>>>>>>>>>>

  Stream? getAllProjects() {
    try {
      final user = userCollection
          .doc(currentUser?.uid)
          .collection('Projects')
          // .orderBy('uid', descending: true)
          .snapshots();
      return user;
    } on FirebaseFirestore catch (e) {
      log('While getting all projects: $e');
    }
    return null;
  }

  Future? getAllTask(data) {
    try {
      final task = userCollection
          .doc(currentUser?.uid)
          .collection('Projects')
          .doc(data)
          .collection('task')
          .get();
      return task;
    } on FirebaseFirestore catch (e) {
      log('While getting all tasks: $e');
    }
    return null;
  }

// <<<<<<<<<<<<<<<<<<<<<< Create A Task >>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future storeTask(
      {required TodayTaskModel taskModel, required String projectID}) async {
    final uid = Timestamp.now().seconds.toString();
    final map = {
      'title': taskModel.title,
      'id': uid,
      'done': taskModel.isDone,
      'time': taskModel.time,
    };
    Get.back();
    try {
      await userCollection
          .doc(currentUser?.uid)
          .collection('Projects')
          .doc(projectID)
          .collection('task')
          .doc(uid)
          .set(map)
          .then((value) {
        taskUID = uid;
        update();
      });
      refresh();
    } on FirebaseFirestore catch (e) {
      log('Hlo This is Error From StoreData $e');
    }
  }

  // getTaskData(String? projectID) async {
  //   taskList.clear();
  //   await userCollection
  //       .doc(currentUser?.uid)
  //       .collection('Projects')
  //       .doc(projectID)
  //       .collection('task')
  //       .doc()
  //       .get()
  //       .then((tasks) {
  //     taskList.add(tasks.data());
  //   });
  // }
}
