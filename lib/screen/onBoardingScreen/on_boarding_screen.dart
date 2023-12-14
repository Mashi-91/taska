import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:taska/constant/global_function.dart';
import 'package:taska/screen/onBoardingScreen/widget/widget.dart';

import '../../constant/tokens.dart';
import '../../constant/utils.dart';
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
                    description: GlobalFunction.splashScreenPage1Description,
                    imgPath: 'calendar-icon.png',
                  ),
                  CustomPageView(
                    size: size,
                    title: 'Always Connect with Team Anytime Anywhere',
                    description: GlobalFunction.splashScreenPage1Description,
                    imgPath: 'message-icon.png',
                  ),
                  CustomPageView(
                    size: size,
                    title: 'Everything You Can Do in the App',
                    description: GlobalFunction.splashScreenPage1Description,
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
                  Utils.buildCustomButton(
                      isEnable: true,
                      buttonText: 'Next',
                      func: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setInt(ONBOARDINGTOKEN, 1).then((value) {
                          controller.nextButtonFunc(context);
                        });
                      }),
                  const SizedBox(height: 12),
                  Utils.buildCustomButton(
                    buttonText: 'Skip',
                    isSkip: true,
                    isEnable: true,
                    func: () async {
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setInt(ONBOARDINGTOKEN, 1).then((value) {
                        controller.skipButtonFunc();
                      });
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
