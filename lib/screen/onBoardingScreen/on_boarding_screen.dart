import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taska/constant/global_text.dart';
import 'package:taska/screen/auth/sign_in_sign_up.dart';
import 'package:taska/screen/onBoardingScreen/widget/widget.dart';

import '../../constant/tokens.dart';
import '../../widget/custom_button.dart';
import 'controller.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final controller = Get.put(SplashController());
  var currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Obx(
        () => Column(
          children: [
            Flexible(
              flex: 4,
              child: PageView(
                controller: controller.pageController,
                onPageChanged: (val) {
                  controller.onPageChange(val);
                },
                children: [
                  CustomPageView(
                    size: size,
                    title: 'Organize Your Tasks & Projects Easily',
                    description: splashScreenPage1Description,
                    imgPath: 'calendar-icon.png',
                  ),
                  CustomPageView(
                    size: size,
                    title: 'Always Connect with Team Anytime Anywhere',
                    description: splashScreenPage1Description,
                    imgPath: 'message-icon.png',
                  ),
                  CustomPageView(
                    size: size,
                    title: 'Everything You Can Do in the App',
                    description: splashScreenPage1Description,
                    imgPath: 'manage-icon.png',
                  ),
                ],
              ),
            ),
            DotsIndicator(
              dotsCount: 3,
              position: controller.currentIndex.value,
            ),
            SizedBox(height: size.height * 0.02),
            Flexible(
              flex: 1,
              child: Column(
                children: [
                  CustomButton(
                    isDisable: false,
                      buttonText: 'Next',
                      func: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setInt(ONBOARDINGTOKEN, 1).then((value) {
                          controller.nextButtonFunc(context);
                        });
                      }),
                  const SizedBox(height: 12),
                  CustomButton(
                    buttonText: 'Skip',
                    isSkip: true,
                    func: () {
                      controller.skipButtonFunc();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
