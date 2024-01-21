import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'package:logger/logger.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:taska/constant/global_function.dart';
import 'package:taska/model/project_model.dart';
import 'package:taska/model/task_model.dart';
import 'package:taska/routes/appRoutes.dart';
import 'package:taska/screen/navigation_tabs/home/homeController.dart';
import '../constant/utils.dart';
import '../model/fill_profile_model.dart';
import '../screen/fill_your_profile/controller.dart';
// import 'package:http/http.dart' as http;

class GlobalController extends GetxController {
  //<<<<<<<<<<<<<<<<<< Local Variables >>>>>>>>>>>>>>>>>>>>>>>>
  var isLoading = false;
  List taskData = [];
  var imgUrl = '';
  String backgroundImg = '';

  //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Firebase & FireStore Instances >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final User? currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  final firebaseMessaging = FirebaseMessaging.instance;
  final userCollection = FirebaseFirestore.instance.collection('users');
  final taskCollection = FirebaseFirestore.instance.collection('tasks');
  final firebaseStorageRef = FirebaseStorage.instance.ref();
  var currentProjectUID = '';
  var taskList = [];
  var taskUID = '';
  String? notificationToken = '';

  Stream<QuerySnapshot<Map<String, dynamic>>> getTaskSnapshot(dynamic data) =>
      userCollection
          .doc(currentUser?.uid)
          .collection('Projects')
          .doc(data?['uid'])
          .collection('task')
          .snapshots();

  @override
  void onInit() {
    initMessaging();
    super.onInit();
  }

  // <<<<<<<<<<<<<<<<<<< Handle Firebase Messaging >>>>>>>>>>>>>>>>>>>

  // ************* Function to initialize notifications *************
  Future<void> initMessaging() async {
    // request permission from user
    await firebaseMessaging.requestPermission();

    // fetch the FCM token for this device
    final fcmToken = await firebaseMessaging.getToken();
    notificationToken = fcmToken;
    update();
    // print the token
    // log('FCM Token:  ${fcmToken.toString()}');
  }

  // ************** Function FCM Notification Send **************

  // Future<void> sendNotification(String text) async {
  //   try {
  //     if (notificationToken != '' && notificationToken != null) {
  //       var notification = {
  //         'notification': {'title': 'Project Created', 'body': text},
  //         'to': notificationToken,
  //       };
  //
  //       var url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  //       var headers = {
  //         'Content-Type': 'application/json',
  //         'Authorization':
  //             'key=AAAAWq7g9J0:APA91bEdbD5pANMxs4u6pz2QJDO2X2brfJmzWAdfycVgENrQrSOqwrYxOXsBaiKCvzSwI7kfDpoGDKxc6c-BhjLjnrxAGERpeQjB7Sffg0HJ76rlw-17DU9Zv_YH1GuR1twawvyvd5KW', // Replace with your server key
  //       };
  //
  //       var response = await http.post(
  //         url,
  //         headers: headers,
  //         body: jsonEncode(notification),
  //       );
  //
  //       if (response.statusCode == 200) {
  //         log('Notification sent successfully!');
  //       } else {
  //         log('Failed to send notification: ${response.statusCode}');
  //       }
  //     } else {
  //       log('Token Not Found');
  //     }
  //   } catch (e) {
  //     log('Error sending notification: $e');
  //   }
  // }

  // <<<<<<<<<<<<<<<<<<< Firebase Functions >>>>>>>>>>>>>>>>>>>

  // <<<<<<<<<<<<<<<<<< UserSign >>>>>>>>>>>>>>>>>>>>>

  signInUserWithEmailAndPass(BuildContext context,
      {required String email, required String password}) async {
    try {
      // <<<<<<<<<<<<<< Show Loading >>>>>>>>>>>>>>>>>>>
      Utils.customLoadingIndicator(context);
      //<<<<<<<<<<<<<<< SignInUser >>>>>>>>>>>>>>>>>>>>>>
      await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Get.offAllNamed('/');
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        Get.back();
        return Utils.snackBarMsg(msg: "Email is already in use!");
      } else if (email.isEmpty && password.isEmpty) {
        Get.back();
        return Utils.snackBarMsg(msg: 'Enter your credentials.');
      } else if (email.isEmpty) {
        Get.back();
        return Utils.snackBarMsg(msg: 'Enter your email!');
      } else if (password.isEmpty) {
        Get.back();
        return Utils.snackBarMsg(msg: 'Enter your password!');
      } else if (e.code == "user-not-found") {
        Get.back();
        return Utils.snackBarMsg(
            msg:
            "There's no email with this email-id, Please go ahead & create one!");
      } else if (e.code == "invalid-email") {
        Get.back();
        return Utils.snackBarMsg(msg: 'Enter a valid email!');
      } else if (e.code == "weak-password") {
        Get.back();
        return Utils.snackBarMsg(msg: 'Week Password!');
      } else if (e.code == "wrong-password") {
        Get.back();
        return Utils.snackBarMsg(msg: "Wrong Password!");
      }
    } catch (e) {
      Get.back();
      log("Sign-In-User-WithEmailAndPass: $e");
    }
  }

  createEmailAndPassword(BuildContext context,
      {required String email, required String password}) async {
    try {
      // <<<<<<<<<<<<<< Show Loading >>>>>>>>>>>>>>>>>>>
      Utils.customLoadingIndicator(context);
      //<<<<<<<<<<<<<<< Create a User >>>>>>>>>>>>>>>>>>>>>>
      await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await Utils.snackBarMsg(
            msg: 'Your Account has been created, add your profile detail!',
            snackPosition: SnackPosition.TOP);
        Get.offAllNamed('/FillYourProfile');
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == "email-already-in-use") {
        Get.back();
        return Utils.snackBarMsg(msg: "Email is already in use!");
      } else if (email.isEmpty && password.isEmpty) {
        Get.back();
        return Utils.snackBarMsg(msg: 'Enter your credentials.');
      } else if (email.isEmpty) {
        Get.back();
        return Utils.snackBarMsg(msg: 'Enter your email!');
      } else if (password.isEmpty) {
        Get.back();
        return Utils.snackBarMsg(msg: 'Enter your password!');
      } else if (e.code == "invalid-email") {
        Get.back();
        return Utils.snackBarMsg(msg: 'Enter a valid email!');
      } else if (e.code == "weak-password") {
        Get.back();
        return Utils.snackBarMsg(msg: 'Password should be greater than 7.');
      }
    } catch (e) {
      Get.back();
      log("CreateEmailAndPassword: $e");
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
              Utils.buildCustomButton(
                buttonText: 'Go to Homepage',
                func: () {
                  Get.offAllNamed(AppRoutes.signInSignUpScreen);
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
        Get.back();
        return Utils.snackBarMsg(msg: "Enter a valid email-address!");
      } else if (e.code == "auth/user-not-found") {
        Get.back();
        return Utils.snackBarMsg(msg: "Your email-address not registered!");
      }
    } catch (e) {
      Get.back();
      log("Reset-Password-Error: $e");
    }
  }



// <<<<<<<<<<<<<< Store Additional Date in Database >>>>>>>>>>>>>>>>>>>

  Future<void> storeUserDetails(BuildContext context,
      {required FillProfileModel createUserModel,
      required FillProfileController controller}) async {
    try {
      // <<<<<<<<<<<<<< Show Loading >>>>>>>>>>>>>>>>>>>
      Utils.customLoadingIndicator(context);
      //<<<<<<<<<<<<<<< Store User Data >>>>>>>>>>>>>>>>>>>>>>
      if (controller.image.isEmpty) {
        Utils.snackBarMsg(msg: 'Please add your profile image.');
      } else if (controller.fullNameController.text.isEmpty) {
        Utils.snackBarMsg(msg: 'Enter your Full Name.');
      } else if (controller.userNameController.text.isEmpty) {
        Utils.snackBarMsg(msg: 'Enter your User Name.');
      } else if (controller.dateOfBirth.isEmpty) {
        Utils.snackBarMsg(msg: 'Enter your Date of Birth.');
      } else if (controller.fillYourEmailAddress.text.isEmpty) {
        Utils.snackBarMsg(msg: 'Enter your Email-ID.');
      } else if (controller.phoneController.text.isEmpty) {
        Utils.snackBarMsg(msg: 'Enter your Phone Number.');
      } else if (controller.roleController.text.isEmpty) {
        Utils.snackBarMsg(msg: 'Enter your Role.');
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
          await Utils.snackBarMsg(msg: 'Your profile has been created.');
          Get.offAllNamed(AppRoutes.authScreen);
        });
      }
    } on FirebaseFirestore catch (e) {
      Get.back();
      log("FirebaseFireStore: $e");
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

  // ********************** Create A Project **********************

  Future storeProject({required String title}) async {
    final uid = Timestamp.now().seconds.toString();

    try {
      Utils.customLoadingIndicator(
          Get.context!); // Show a custom loading indicator

      final backgroundImg = await getRandomImage();
      final projectColor =
          GlobalFunction.convertColorToHex(getRandomColor(Utils.staticColors));

      final map = ProjectModel(
        id: uid,
        title: title,
        cover: '',
        backgroundCover: backgroundImg,
        projectColor: projectColor,
        projectDeadLine: '',
      );

      await userCollection
          .doc(currentUser?.uid)
          .collection('Projects')
          .doc(uid)
          .set(map.toJson())
          .then((value) async {
        Get.back(); // Close the loading indicator
        Get.back(); // Close the bottom sheet

        Get.toNamed(AppRoutes.createProjectScreen, arguments: map);
        currentProjectUID = uid;
        update();
      });
    } on FirebaseFirestore catch (e) {
      log('Error storing data: $e');
      Get.back(); // Close the loading indicator in case of an error
      Get.back(); // Close the bottom sheet in case of an error
    }
  }

  // ********************* Upload Image *********************
  Future<void> uploadImg({File? cover}) async {
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

  void updateProject({File? cover, String? currentProjectId}) async {
    try {
      await uploadImg(cover: cover);
      await userCollection
          .doc(currentUser?.uid)
          .collection('Projects')
          .doc(currentProjectUID.isEmpty ? currentProjectId : currentProjectUID)
          .update({
        'cover': imgUrl,
      });
    } on FirebaseFirestore catch (e) {
      log('Showing Error uploadProjectSection: $e');
    }
  }

  // void addTaskUID(String? projectUID) async {
  //   try {
  //     final timeStamp = Timestamp.now().millisecondsSinceEpoch.toString();
  //     await taskCollection
  //         .doc(currentUser!.uid)
  //         .collection('Tasks')
  //         .doc(timeStamp)
  //         .set({
  //       'taskID': timeStamp,
  //       'projectID': projectUID,
  //     });
  //     log(taskUID);
  //   } on FirebaseFirestore catch (e) {
  //     log('Showing Error while adding taskUID: $e');
  //   }
  // }

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

  Future<void> deleteProject(
      {String? uid, required BuildContext context}) async {
    try {
      Utils.customLoadingIndicator(context);

      final batch = FirebaseFirestore.instance.batch();

      final projectDocRef =
          userCollection.doc(currentUser?.uid).collection('Projects').doc(uid);

      // Query for tasks and delete them
      final tasksQuerySnapshot = await userCollection
          .doc(currentUser?.uid)
          .collection('Tasks')
          .where('projectId', isEqualTo: uid)
          .get();

      if (tasksQuerySnapshot.docs.isNotEmpty) {
        for (final taskDocSnapshot in tasksQuerySnapshot.docs) {
          batch.delete(taskDocSnapshot.reference);
        }
      }

      // Get project cover and delete it from Firebase Storage if it exists
      final projectData = await projectDocRef.get();
      final coverPath = projectData.data()?['cover'] ?? '';

      if (coverPath.isNotEmpty) {
        final storageRef = firebaseStorageRef.child('$uid.jpg');

        // Check if the project cover exists in Firebase Storage
        final coverSnapshot = await storageRef.getMetadata();
        if (coverSnapshot != null) {
          await storageRef.delete();
          Logger().d('Project cover deleted');
        }
      }

      // Delete project document
      batch.delete(projectDocRef);

      // closing Loading
      Get.back();

      // closing bottomSheet
      Get.back();

      // Commit the batch
      await batch.commit();
    } catch (e, stackTrace) {
      // closing Loading
      Get.back();

      // closing bottomSheet
      Get.back();
      Logger().e('Error deleting project and tasks: $e',
          error: e, stackTrace: stackTrace);
    }
  }

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Get All Data >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Stream? getAllProjects() {
    try {
      final user = userCollection
          .doc(currentUser?.uid)
          .collection('Projects')
          .orderBy('id', descending: true)
          .snapshots();
      return user;
    } on FirebaseFirestore catch (e) {
      log('While getting all projects: $e');
    }
    return null;
  }

  Future<QuerySnapshot<Map<String, dynamic>>>? getAllProjectsByFuture() {
    try {
      final user = userCollection
          .doc(currentUser?.uid)
          .collection('Projects')
          .orderBy('id', descending: true)
          .get();
      log('message');
      return user;
    } on FirebaseFirestore catch (e) {
      log('While getting all projects: $e');
    }
    return null;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllTaskAsStream(
      String projectId) {
    try {
      if (currentUser != null) {
        return userCollection
            .doc(currentUser!.uid)
            .collection(
                'Tasks') // Assuming 'tasks' is the root collection for tasks
            .where('projectId', isEqualTo: projectId)
            .where('userId', isEqualTo: currentUser!.uid)
            .snapshots();
      } else {
        // Handle the case where the user is not authenticated
        Logger().w('User not authenticated');
        return const Stream.empty(); // Return an empty stream
      }
    } catch (e) {
      // Catch any errors that occur during the process
      Logger().e('Error getting all tasks: $e', error: e);
      return const Stream.empty(); // Return an empty stream
    }
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAllTaskAsFuture(
      String projectId) {
    try {
      if (currentUser != null) {
        return userCollection
            .doc(currentUser!.uid)
            .collection(
            'Tasks') // Assuming 'tasks' is the root collection for tasks
            .where('projectId', isEqualTo: projectId)
            .where('userId', isEqualTo: currentUser!.uid)
            .get();
      } else {
        // Handle the case where the user is not authenticated
        Logger().w('User not authenticated');
        return Future.value(); // Return an empty stream
      }
    } catch (e) {
      // Catch any errors that occur during the process
      Logger().e('Error getting all tasks: $e', error: e);
      return Future.value(); // Return an empty stream
    }
  }

  Stream getAllProjectAsStream(String projectId) {
    try {
      if (currentUser != null) {
        return userCollection
            .doc(currentUser!.uid)
            .collection('Projects')
            .doc(projectId)
            .snapshots();
      } else {
        // Handle the case where the user is not authenticated
        Logger().w('User not authenticated');
        return const Stream.empty(); // Return an empty stream
      }
    } catch (e) {
      // Catch any errors that occur during the process
      Logger().e('Error getting all tasks: $e', error: e);
      return const Stream.empty(); // Return an empty stream
    }
  }

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< Create A Task >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<void> storeTask({
    required TaskModel taskModel,
  }) async {
    try {
      final userId = currentUser?.uid;
      if (userId != null) {
        final uid = Timestamp.now().seconds.toString();
        final map = TaskModel(
          taskId: uid,
          projectId: taskModel.projectId,
          userId: userId,
          title: taskModel.title,
          time: taskModel.time,
          isDone: taskModel.isDone,
        ).toJson();

        await userCollection
            .doc(userId)
            .collection('Tasks')
            .doc(uid)
            .set(map)
            .then((value) {
          Logger().t('Your task is create!');
        });
        update();
        Get.back(); // Navigating back using GetX
      } else {
        // Handle the case where the user is not authenticated
        // You can throw an error or log a message here
        Logger().w('User not authenticated');
      }
    } catch (e) {
      // Catch any errors that occur during the process
      Logger().e('Error getting all tasks: $e', error: e);
    }
  }

  // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< GetRandom Image >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

  Future<String> getRandomImage() async {
    // List of image paths in your assets
    List<String> imagePaths = [
      'assets/background_images/home-1.jpg',
      'assets/background_images/home-2.jpg',
      'assets/background_images/home-3.jpg',
      'assets/background_images/home-4.jpg',
      'assets/background_images/home-5.jpg',
      'assets/background_images/home-6.jpg',
    ];

    // Generate a random index within the range of available images
    int randomIndex = math.Random().nextInt(imagePaths.length);

    await Future.delayed(const Duration(milliseconds: 100));

    // Return the randomly selected image path
    backgroundImg = imagePaths[randomIndex];
    update();

    return imagePaths[randomIndex];
  }

  Color getRandomColor(List<Color> staticColors) {
    final math.Random random = math.Random();
    return staticColors[random.nextInt(staticColors.length)];
  }

  // ************************* Update Section *********************************

  // Function to update color in Firebase
  void updateColorInFirebase(
      String currentProjectId, MaterialColor color) async {
    try {
      await userCollection
          .doc(currentUser?.uid)
          .collection('Projects')
          .doc(currentProjectId)
          .update({
        'projectColor': GlobalFunction.convertMaterialColorToHex(color)
      });
      Logger().i('Color updated successfully in Firebase!');
    } catch (e, stackTrace) {
      Logger().e('Error updating color in Firebase: $e',
          error: e, stackTrace: stackTrace);
      // Handle the error as needed, such as displaying an error message or logging
    }
  }

  Future<void> updateFieldFromFirebase({
    required String currentProjectId,
    required String updateField,
    required String firebaseFiledName,
  }) async {
    try {
      await userCollection
          .doc(currentUser?.uid)
          .collection('Projects')
          .doc(currentProjectId)
          .update({
        firebaseFiledName: updateField,
      });
      Logger().i('$updateField updated successfully in Firebase!');
    } catch (e, stackTrace) {
      Logger().e('Error updating color in Firebase: $e',
          error: e, stackTrace: stackTrace);
      // Handle the error as needed, such as displaying an error message or logging
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
