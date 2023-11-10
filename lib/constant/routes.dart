import 'package:get/get.dart';
import 'package:taska/screen/auth/auth_home.dart';
import 'package:taska/screen/auth/sign_in/sign_in_screen.dart';
import 'package:taska/screen/auth/sign_up/sign_up_screen.dart';
import 'package:taska/screen/auth/sign_in_sign_up.dart';
import 'package:taska/screen/forgot_password/forgot_password_screen.dart';
import 'package:taska/screen/navigation_tabs/home/home_screen.dart';
import 'package:taska/screen/navigation_tabs/project/add_cover.dart';
import 'package:taska/screen/navigation_tabs/project/project_Detail.dart';
import 'package:taska/screen/navigation_tabs/home/see_all_screen.dart';
import 'package:taska/screen/navigation_tabs/navigation_controller.dart';

import '../screen/fill_your_profile/fill_your_profile.dart';
import '../screen/navigation_tabs/project/project_title.dart';
import '../screen/onBoardingScreen/on_boarding_screen.dart';

class Routes {
  static List<GetPage> routes = [
    GetPage(name: '/', page: () => const AuthHome()),
    GetPage(name: onBoardingScreen, page: () => OnBoardingScreen()),
    GetPage(name: signInSignUpScreen, page: () => SignInSignUp()),
    GetPage(
      name: signInScreen,
      page: () => SignInScreen(),
      // transitionDuration: Duration(milliseconds: 500),
      // transition: Transition.rightToLeft,
    ),
    GetPage(
      name: signUpScreen,
      page: () => SignUpScreen(),
      // transitionDuration: Duration(milliseconds: 500),
      // transition: Transition.rightToLeft,
    ),
    GetPage(
      name: fillYourProfileScreen, page: () => FillYourProfile(),
      // transitionDuration:Duration(milliseconds: 500),
      //   transition: Transition.rightToLeft
    ),
    GetPage(
      name: forgotPasswordScreen, page: () => ForgotPasswordScreen(),
      // transitionDuration:Duration(milliseconds: 500),
      //   transition: Transition.rightToLeft
    ),
    GetPage(name: homeScreen, page: () => HomeScreen()),
    GetPage(name: titleScreen, page: () => ProjectTitle()),
    GetPage(name: seeAllScreen, page: () => SeeAll()),
    GetPage(name: projectDetail, page: () => ProjectDetail()),
    GetPage(
        name: homeNavigationController, page: () => HomeNavigationController()),
    GetPage(name: addCover, page: () => AddCover()),
  ];
}

const String onBoardingScreen = '/OnBoardingScreen';
const String signInSignUpScreen = '/SignInSignUp';
const String signInScreen = '/SignIn';
const String signUpScreen = '/SignUp';
const String fillYourProfileScreen = '/FillYourProfile';
const String forgotPasswordScreen = '/ForgotPassword';
const String homeScreen = '/HomeScreen';
const String titleScreen = '/titleScreen';
const String seeAllScreen = '/seeAllScreen';
const String projectDetail = '/projectDetail';
const String homeNavigationController = '/homeNavigationController';
const String addCover = '/addCover';
