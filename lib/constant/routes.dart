import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:taska/screen/auth/sign_in/sign_in_screen.dart';
import 'package:taska/screen/auth/sign_up/fill_your_profile/fill_your_profile.dart';
import 'package:taska/screen/auth/sign_up/sign_up_screen.dart';
import 'package:taska/screen/auth/sign_in_sign_up.dart';

import '../screen/onBoardingScreen/on_boarding_screen.dart';

class Routes {
  static List<GetPage> routes = [
    GetPage(name: '/', page: () => const SignInSignUp()),
    GetPage(name: '/OnBoardingScreen', page: () => OnBoardingScreen()),
    GetPage(
      name: '/SignIn',
      page: () => SignInScreen(),
      transitionDuration: Duration(milliseconds: 500),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: '/SignUp',
      page: () => SignUpScreen(),
  transitionDuration: Duration(milliseconds: 500),
  transition: Transition.rightToLeft,
    ),
    GetPage(name: '/FillYourProfile', page: () => FillYourProfile(),
    transitionDuration:Duration(milliseconds: 500),
      transition: Transition.rightToLeft
    ),
  ];
}
