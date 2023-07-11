import 'package:get/get.dart';
import 'package:taska/screen/auth/auth_home.dart';
import 'package:taska/screen/auth/sign_in/sign_in_screen.dart';
import 'package:taska/screen/auth/sign_up/sign_up_screen.dart';
import 'package:taska/screen/auth/sign_in_sign_up.dart';
import 'package:taska/screen/forgot_password/forgot_password_screen.dart';
import 'package:taska/screen/home/create_project/create_project_screen.dart';
import 'package:taska/screen/home/project_screen.dart';

import '../screen/fill_your_profile/fill_your_profile.dart';
import '../screen/home/home_screen.dart';
import '../screen/onBoardingScreen/on_boarding_screen.dart';

class Routes {
  static List<GetPage> routes = [
    GetPage(name: '/', page: () => const AuthHome()),
    GetPage(name: '/OnBoardingScreen', page: () => OnBoardingScreen()),
    GetPage(name: '/SignInSignUp', page: () => SignInSignUp()),
    GetPage(
      name: '/SignIn',
      page: () => SignInScreen(),
      // transitionDuration: Duration(milliseconds: 500),
      // transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/SignUp',
      page: () => SignUpScreen(),
      // transitionDuration: Duration(milliseconds: 500),
      // transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/FillYourProfile', page: () => FillYourProfile(),
      // transitionDuration:Duration(milliseconds: 500),
      //   transition: Transition.rightToLeft
    ),
    GetPage(
      name: '/ForgotPassword', page: () => ForgotPasswordScreen(),
      // transitionDuration:Duration(milliseconds: 500),
      //   transition: Transition.rightToLeft
    ),
    GetPage(name: '/HomeScreen', page: () => HomeScreen()),
    GetPage(name: '/NewProjectScreen', page: () => NewProject()),
  ];
}
