import 'package:flutter/animation.dart';
import 'package:taska/screen/navigation_tabs/project/createProjectScreen/setColor.dart';
import 'package:taska/screen/navigation_tabs/project/projectDetailScreen/changeColor.dart';

import 'export.dart';

class AppPages {
  static List<GetPage> routes = [
    GetPage(
      name: AppRoutes.authScreen,
      page: () => const AuthHome(),
      curve: Curves.easeIn,
      transition: Transition.rightToLeft,
      // middlewares: [ConnectivityMiddleware()],
    ),
    GetPage(
      name: AppRoutes.onBoardingScreen,
      page: () => OnBoardingScreen(),
      curve: Curves.easeIn,
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.signInSignUpScreen,
      page: () => SignInSignUp(),
    ),
    GetPage(
      name: AppRoutes.signInScreen,
      page: () => SignInScreen(),
      // transitionDuration: Duration(milliseconds: 500),
      // transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.signUpScreen,
      page: () => SignUpScreen(),
      // transitionDuration: Duration(milliseconds: 500),
      // transition: Transition.rightToLeft,
    ),
    GetPage(
      name: AppRoutes.fillYourProfileScreen, page: () => FillYourProfile(),
      // transitionDuration:Duration(milliseconds: 500),
      //   transition: Transition.rightToLeft
    ),
    GetPage(
      name: AppRoutes.forgotPasswordScreen, page: () => ForgotPasswordScreen(),
      // transitionDuration:Duration(milliseconds: 500),
      //   transition: Transition.rightToLeft
    ),
    GetPage(name: AppRoutes.homeScreen, page: () => HomeScreen()),
    GetPage(
        name: AppRoutes.createProjectScreen, page: () => CreateProjectScreen()),
    GetPage(name: AppRoutes.seeAllScreen, page: () => SeeAll()),
    GetPage(name: AppRoutes.projectDetail, page: () => ProjectDetail()),
    GetPage(
        name: AppRoutes.homeNavigationController,
        page: () => HomeNavigationController()),
    GetPage(name: AppRoutes.changeCover, page: () => ChangeCover()),
    GetPage(name: AppRoutes.changeColor, page: () => ChangeColor()),
    GetPage(name: AppRoutes.addCover, page: () => AddCover()),
    GetPage(name: AppRoutes.addColor, page: () => SetColor()),
  ];
}
